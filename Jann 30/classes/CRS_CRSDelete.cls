global with sharing class CRS_CRSDelete {

	public String message {get;set;}
	public Boolean isError {get;set;}
	public Boolean isCRSBA {get;set;}
	public Boolean isCRSSA {get;set;}
	private CRS__c crs;

	public CRS_CRSDelete(ApexPages.StandardController stdController) {
		isError = false;
		crs=(CRS__c)stdController.getRecord();
        //crs = [select Id, Initiated_By__c, Name, Status__c, OwnerId from CRS__c where Id = :Apexpages.currentPage().getParameters().get('delId')];
        isCRSBA = !([select Id from Profile where Id = :UserInfo.getProfileId() and 
			Name = :CRS_CRSEdit.getBAProfileName()].isEmpty());
		isCRSSA = !([select Id from Profile where Id = :UserInfo.getProfileId() and 
			Name = :CRS_CRSEdit.getSAProfileName()].isEmpty());
	}
	
	public void deleteCRS(){
		if(isCRSSA || isCRSBA ||
			(crs.Status__c == CRS_CRSEdit.CRS_Status_Draft && UserInfo.getUserId() == crs.OwnerId)){
	    	try{
	    		List<CRS_Message__c> crsMessages = [select Id from CRS_Message__c where CRS__c = :crs.Id];
                if(!crsMessages.isEmpty()){
                    delete crsMessages;
                }
	        	List<CRS_Review__c> reviewList = [select Id from CRS_Review__c where CRS_Tracking__c = :crs.Id];
	    		if(!reviewList.isEmpty()){
	    			delete reviewList;
	    		}
	            delete crs;
	            message = 'CRS number ' +crs.Name + ' was deleted.';
	        }catch(Exception e){
	            ApexPages.addMessages(e);
	        }
        } else {
        	isError = true;
        	message = 'You don\'t have permissions';
        }
	}
}