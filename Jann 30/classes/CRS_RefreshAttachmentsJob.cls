/*
 * Batch Apex job for creating attachments wrappers for both CRS__c & CRS_Review__c objects.
 * Actually this job does the same as "Refresh Attachments" button on these objects layouts but for all objects at once.
 * This job created in scope of data migration.
 * 
 * How to use it:
 * - You should login as user who uploaded files into chatter feed, else this code will not see these files;
 * - Enable debug logs so you can find info about processed records after this job has finished (see finish method);
 * - Execute anonymous apex:
 *      1) for CRS__c: "database.executeBatch(new CRS_RefreshAttachmentsJob(CRS_RefreshAttachmentsJob.CRS_TYPE), 100);"
 *      2) for CRS_Review__c: "database.executeBatch(new CRS_RefreshAttachmentsJob(CRS_RefreshAttachmentsJob.REVIEW_TYPE), 100);"
 */
global with sharing class CRS_RefreshAttachmentsJob 
        implements Database.Batchable<SObject>, Database.Stateful {
    global final static String CRS_TYPE = 'CRS__c';
    global final static String REVIEW_TYPE = 'CRS_Review__c';
    
    private final static String CRS_WRAPPER = 'CRS_ContentWrapper__c';
    private final static String CRS_REVIEW_WRAPPER = 'CRS_CRSReviewContentWrapper__c';
    
    private final static String FILE_ID_FIELD = 'FileId__c';
    private final static String FILE_NAME_FIELD = 'Filename__c';
    
    global String parentObjectType;
        	
    global Integer totalParentRecords;
    global Integer totalWrappers;
    
    global CRS_RefreshAttachmentsJob(String parentObjectType) {
    	this.parentObjectType = parentObjectType;
    	
    	totalParentRecords = 0;
    	totalWrappers = 0;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
    	String query = 'SELECT Id FROM ' + parentObjectType; 
    	return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope){
    	List<SObject> newWrappers = new List<SObject>();
    	
    	system.debug('~~~Scope size:'+scope.size());
    	
    	for (SObject parent : scope) {
    		newWrappers.addAll(createWrappers((String) parent.get('Id')));
    	}
    	
    	if (newWrappers.size() > 0) {
            try {
                insert newWrappers;
            } catch(Exception e) {
                system.debug('~~~:Exception during Content Wrappers creation: ' + e);
            }
        } 
    }

    global void finish(Database.BatchableContext BC){
    	system.debug('~~~Total parent records affected:' + totalParentRecords);
    	system.debug('~~~Total wrappers created:' + totalWrappers);
    }
    
    private List<SObject> createWrappers(String parentId) {
        List<ContentDocumentLink> docLinks = 
                [SELECT ContentDocument.Id, ContentDocument.Title
                   FROM ContentDocumentLink
                  WHERE LinkedEntityId = :parentId]; 
        
        //Count parent CRS__c or CRS_Review__c records for which wrappers will be created.
        if (docLinks.size() > 0) {
        	totalParentRecords++;
        }
        
        String wrapperName = (parentObjectType == CRS_TYPE) ? CRS_WRAPPER : CRS_REVIEW_WRAPPER;
        String wrappersQuery = 'SELECT Id, FileId__c FROM ' + wrapperName + ' WHERE '+ parentObjectType + ' = \'' + parentId +'\'';
        List<SObject> existingWrappers = Database.query(wrappersQuery);
        
        //Get map <fileId:wrapper> from wrappers list
        Map<String, SObject> wrappersByFile = new Map<String, SObject>();
        for (SObject wrapper : existingWrappers) {
            wrappersByFile.put((String)wrapper.get(FILE_ID_FIELD), wrapper);
        }
        
        List<SObject> wrappersToCreate = new List<SObject>();
        for (ContentDocumentLink docLink : docLinks) {
            if (wrappersByFile.get(docLink.ContentDocument.Id) == null) {
                SObject wrapper;
                if (parentObjectType == CRS_TYPE) {
                     wrapper = new CRS_ContentWrapper__c();
                } else if (parentObjectType == REVIEW_TYPE) {
                     wrapper = new CRS_CRSReviewContentWrapper__c();
                }
                        
                wrapper.put(parentObjectType, parentId);
                wrapper.put(FILE_ID_FIELD, docLink.ContentDocument.Id);
                wrapper.put(FILE_NAME_FIELD, docLink.ContentDocument.Title);
                
                wrappersToCreate.add(wrapper);
            }
        }
        
        totalWrappers += wrappersToCreate.size();
        
        return wrappersToCreate;
    }
    
}