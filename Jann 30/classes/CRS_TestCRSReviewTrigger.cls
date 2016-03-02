/*
	* author: Ivan_Tsitulenka
	* class: CRS_CRSReviewTriggerHandler
	* method: BeforeInsert, getNumberFromName
	*/
@isTest
private class CRS_TestCRSReviewTrigger {
    
    private static void prepareData(String testName){
    	CRS_CRS_Product__c testProduct = new CRS_CRS_Product__c(Name = testName, Active__c = 'Yes', 
				Beverage_Product_Name__c = 'Test002', KO_Product__c = 'No');
		insert testProduct;
		testProduct = [select Id, Name from CRS_CRS_Product__c where Name = :testProduct.Name];
		
		CRS_Group__c crsGroup = new CRS_Group__c(Name = testName, Active__c = 'Yes');
		insert crsGroup;
		crsGroup = [select Id, Name from CRS_Group__c where Name = :crsGroup.Name];
		
		CRS_Business_Unit__c crsBU = new CRS_Business_Unit__c(Name = testName, Active__c = 'Yes', Group__c = crsGroup.Id);
		insert crsBU;
		crsBU = [select Id, Name from CRS_Business_Unit__c where Name = :crsBU.Name];
		
		RecordType crsRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c'][0];
		CRS__c testCrs = new CRS__c(CRS_Product_Name__c = testProduct.Id, CRS_Group__c = crsGroup.Id, 
			CRS_Business_Unit__c = crsBU.Id, RecordType = crsRecordType, RecordTypeId = crsRecordType.Id);
		insert testCrs;
    }
    
    static testMethod void insertCRSReviewIrvwTest() {
    	prepareData('test1');
    	CRS__c crs = [select Id, Name from CRS__c limit 1];
    	CRS_Review__c crsReview = new CRS_Review__c(CRS_Tracking__c = crs.Id, Name = 'testCRSReview'); 
    	insert crsReview;
    	crsReview = [select Name from CRS_Review__c where Id = :crsReview.Id];
    	System.assert(crsReview.Name == 'Irvw001001');
    	CRS_Review__c crsReview2 = new CRS_Review__c(CRS_Tracking__c = crs.Id);
    	insert crsReview2;
    	crsReview2 = [select Name from CRS_Review__c where Id = :crsReview2.Id];
    	System.assert(crsReview2.Name == 'Irvw001002');
    }
    
    static testMethod void insertCRSReviewALTTest() {
    	prepareData('test1');
    	CRS__c crs = [select Id, Name from CRS__c limit 1];
    	CRS_Review__c crsReview = new CRS_Review__c(Name = crs.Name + 'rvw', CRS_Tracking__c = crs.Id ); 
    	insert crsReview;
    	crsReview = [select Name from CRS_Review__c where Id = :crsReview.Id];
    	System.assert(crsReview.Name == crs.Name + 'rvw');
    }
}