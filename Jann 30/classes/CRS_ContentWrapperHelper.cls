global with sharing class CRS_ContentWrapperHelper {
	private final static String CRS_WRAPPER = 'CRS_ContentWrapper__c';
	private final static String CRS_REVIEW_WRAPPER = 'CRS_CRSReviewContentWrapper__c';
	
    /**
     * Wrappers synchronization for CRS__c object.
     */
    webservice static Integer syncCRSWrappers(String parentId) {
    	return syncWrappers(CRS_WRAPPER, parentId);
    }
    
    /**
     * Wrappers synchronization for CRS_Review__c object.
     */
    webservice static Integer syncCRSReviewWrappers(String parentId) {
        return syncWrappers(CRS_REVIEW_WRAPPER, parentId);    
    }
    
    /**
     * Synchronize wrappers and attached files -
     * create new wrappers for newly attached files.
     * We don't need to delete wrappers here, because it is impossible to know in Apex
     * which files were removed and which are not shared to current user.
     *
     * Returns number that will be considered in JS button: 
     * 0 - if everything is ok;
     * 1 - if parent CRS record is locked via approval process;
     * 2 - if some another exception is thrown;
     * 3 - if things are already in sync (there is nothing to save).
     */
    private static Integer syncWrappers(String parentObjectType, String parentId) {
        List<ContentDocumentLink> docLinks = 
                [SELECT ContentDocument.Id, ContentDocument.Title
                   FROM ContentDocumentLink
                  WHERE LinkedEntityId = :parentId]; 
        
        Set<String> wrappersToDel = new Set<String>();
        for (CRS_ContentWrapper_Del__c wrapperToDel : [SELECT Id, FileId__c FROM CRS_ContentWrapper_Del__c WHERE ParentId__c  like :parentId+'%']) {
            wrappersToDel.add(wrapperToDel.FileId__c);
        }
        
        String parentObjIdField = (parentObjectType == CRS_WRAPPER) ? 'CRS__c' : 'CRS_Review__c';
        String query = 'SELECT Id, FileId__c FROM '+parentObjectType+' WHERE '+ parentObjIdField + ' = \'' + parentId +'\''; 
        List<SObject> existingWrappers = Database.query(query);
        
        //Get map <fileId:wrapper> from wrappers list
        Map<String, SObject> wrappersByFile = new Map<String, SObject>();
        for (SObject wrapper : existingWrappers) {
            wrappersByFile.put((String)wrapper.get('FileId__c'), wrapper);
        }
        
        List<SObject> wrappersToCreate = new List<SObject>();
        for (ContentDocumentLink docLink : docLinks) {
            if (wrappersByFile.get(docLink.ContentDocument.Id) == null && !wrappersToDel.contains(docLink.ContentDocument.Id)) {
            	SObject wrapper;
            	if (parentObjectType == CRS_WRAPPER) {
	                 wrapper = new CRS_ContentWrapper__c();
            	} else if (parentObjectType == CRS_REVIEW_WRAPPER) {
	                 wrapper = new CRS_CRSReviewContentWrapper__c();
            	}
            	wrapper.put(parentObjIdField, parentId);
            	wrapper.put('FileId__c', docLink.ContentDocument.Id);
            	wrapper.put('Filename__c', docLink.ContentDocument.Title);
                if (wrapper != null) {
                    wrappersToCreate.add(wrapper);
                }               
            }
        }
        
        Integer result = 0;
        
        if (wrappersToCreate.size() > 0) {
        	try {
                insert wrappersToCreate;
        	} catch(DmlException e) {
        		system.debug('~~~:Exception during Content Wrappers creation: ' + e);
        		StatusCode exceptionStatusCode = e.getDmlType(0);
        		if (StatusCode.ENTITY_IS_LOCKED == exceptionStatusCode) {
        			result = 1;
        		} else {
        			result = 2;
        		}
        	}
        } else {
        	result = 3;
        }
        
        return result;    
    }

}