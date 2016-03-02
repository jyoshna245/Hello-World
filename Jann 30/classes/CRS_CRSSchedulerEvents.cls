public with sharing class CRS_CRSSchedulerEvents {
	public static void recountMTRDay(){
		String underReviewStatus = CRS_CRSEdit.CRS_Status_UnderReview;
		List<CRS__c> draftCRS = [select Id, CreatedDate, MTR_Day_Count__c, Status__c from CRS__c 
			where Status__c =:underReviewStatus];
		for(CRS__c crs : draftCRS){
			if(!crs.CreatedDate.isSameDay(datetime.now())){
				if(crs.MTR_Day_Count__c != null){
					crs.MTR_Day_Count__c++;
				} else {
					crs.MTR_Day_Count__c = 1;
				}
			}
		}
		update draftCRS;
	}
	
	public static void deleteTenYearsOldCRS(){
		date d = system.today().addYears(-10);
		List<Id> delIds = new List<Id>();
		List<CRS__c> listCRS = [select Id, Name, Date_Closed__c, Status__c from CRS__c 
			where Date_Closed__c <= :d];
		for(CRS__c crs: listCRS){
			delIds.add(crs.Id);
		}
		List<CRS_Review__c> crsReview = [select Id, Name from CRS_Review__c where CRS_Tracking__c in :delIds];
		if(!crsReview.isEmpty()){
			delete crsReview;
		}
		if(!listCRS.isEmpty()){
			delete listCRS;	
		}
	}
	
	public static void deleteAllAttachments(){
		List<ContentDocument> cDocs = new List<ContentDocument>();
		CRS_ContentWrapper_Del__c[] wrappers = [Select FileId__c, ParentId__c From CRS_ContentWrapper_Del__c limit 150];
		for(CRS_ContentWrapper_Del__c wrapper : wrappers){
	        cDocs.add([Select ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Id From ContentDocumentLink Where ContentDocumentId = :wrapper.FileId__c limit 1].ContentDocument);
		}
		if(!cDocs.isEmpty()){
			delete cDocs;
		}
		delete wrappers;
	}

}