public without sharing class CRS_AdminActions {
	public static CRS__c updateCRS(CRS__c crs){
		update crs;
		return crs;
	}

	public static CRS_Review__c updateCRSReview(CRS_Review__c crsReview){
		upsert crsReview;
		return crsReview;
	}

	public static List<CRS_Review__c> getIrwCRSReview(){
		return [Select Name From CRS_Review__c where Name like 'Irvw%' order by Name desc limit 1];
	}
}