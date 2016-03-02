public with sharing class CRS_ContentWrapperDeleteController {
    private ApexPages.StandardController stdController;
    private Boolean isCRSReviewWrapper;    
    
    public CRS_ContentWrapperDeleteController(ApexPages.StandardController controller) {
        stdController = controller;

        PageReference pageRef = ApexPages.currentPage();
        isCRSReviewWrapper = pageRef.getUrl().contains('Review');  
    
        if (!Test.isRunningTest()) {
            if (isCRSReviewWrapper) {
            	stdController.addFields(new String[]{'FileId__c', 'CRS_Review__c'});
            } else {
                stdController.addFields(new String[]{'FileId__c', 'CRS__c'});	
            }
        }
        
    }   
    
    /**
     * Deleting CRS_ContentWrapper__c or CRS_CRSReviewContentWrapper__c with corresponding ContentDocument record.
     */
    public PageReference deleteRecord() {
    	PageReference result = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        
        SObject wrapper = stdController.getRecord();
            	
    	String parentId = (String) ((isCRSReviewWrapper) ? wrapper.get('CRS_Review__c') : wrapper.get('CRS__c'));
    	String fileId = (String) wrapper.get('FileId__c');
    	
        // Cannot directly fetch ContentDocument by Id, thus ContentDocument is retrieved using ContentDocumentLink.
        List<ContentDocumentLink> docLinks = 
                [Select ContentDocument.LatestPublishedVersionId, ContentDocument.Id From ContentDocumentLink Where ContentDocumentId = :fileId]; 
        
        // ContentDocument related to wrapper to be deleted. 
        ContentDocument cDoc = null; 
        for (ContentDocumentLink cdl : docLinks) {
            if (cdl.ContentDocumentId == fileId) {
                cDoc = cdl.ContentDocument;     
                break;                
            }
        }	
         
        boolean isCRSSA = !([select Id from Profile where Id = :UserInfo.getProfileId() and 
			Name = :CRS_CRSEdit.getSAProfileName()].isEmpty());
        
		if (cDoc != null) {
			if(isCRSSA){
            delete cDoc;    		 	
			} else {
				CRS_ContentWrapper_Del__c attachToDel = new CRS_ContentWrapper_Del__c(ParentId__c = parentId, FileId__c = fileId);
				insert attachToDel;
			}
        }

    	delete wrapper;
    	return result;
    }
}