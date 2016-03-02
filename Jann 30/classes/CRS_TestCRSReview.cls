/*
* author: Ivan_Tsitulenka
* class: CRS_CRSReview
* method: moveToReview, reviewComplete
*/
@isTest
private class CRS_TestCRSReview {

    private static CRS__c prepareData(){
    	CRS_TestHelper.prepareUnderReviewCRS();
    	CRS__c crs = [select Id, Name, Status__c, CRS_Business_Unit__c,
    	CRS_Brand__c from CRS__c limit 1];
    	crs.Status__c = CRS_CRSEdit.CRS_Status_InProcess;
    	update crs;
    	return crs;
    }
    
    static testMethod void moveToReviewTest() {
    	CRS__c crs = prepareData();
    	String crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	CRS_Review__c crsReview = [select Id, Name, Review_Status__c, CRS_Business_Unit__c,
    	CRS_Brand__c from CRS_Review__c where Id = :crsReviewId];
    	System.assert(crsReview.Name == crs.Name + 'rvw');
    	
    	crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	crs.Process_Flow__c = 'Full Review Non-Coke Branded Product';
    	update crs;
    	crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	
    	crs.Process_Flow__c = 'Full Review Coke Branded Product';
    	update crs;
    	crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	
    	crs.Process_Flow__c = 'Full Review & Notification & PAC';
    	update crs;
    	crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	
    	System.assert(crsReview.CRS_Business_Unit__c == crs.CRS_Business_Unit__c);
    	System.assert(crsReview.CRS_Brand__c == crs.CRS_Brand__c);
    }
    
     static testMethod void moveToReviewTest1() {
    	CRS__c crs = prepareData();
    	String crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	CRS_Review__c crsReview = [select Id, Name, Review_Status__c, CRS_Business_Unit__c,
    	CRS_Brand__c from CRS_Review__c where Id = :crsReviewId];
    	System.assert(crsReview.Name == crs.Name + 'rvw');
    	
    	crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	crs.Process_Flow__c = 'Full Review Coke Branded Product & PAC';
    	update crs;
    	crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	
    	crs.Process_Flow__c = 'Full Review (for gvwCRS Only)';
    	update crs;
    	crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	
    	
    	System.assert(crsReview.CRS_Business_Unit__c == crs.CRS_Business_Unit__c);
    	System.assert(crsReview.CRS_Brand__c == crs.CRS_Brand__c);
    }
    
    static testMethod void reviewCompleteTest(){
    	CRS__c crs = prepareData();
    	String crsReviewId = CRS_CRSReview.moveToReview(crs.Id);
    	String crsId = CRS_CRSReview.reviewComplete(crsReviewId);
    	crs = [select Id, Status__c from CRS__c where Id = :crsId];
    	System.assert(crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess);
    	CRS_Review__c crsReview = [select Id, Review_Status__c from CRS_Review__c where Id = :crsReviewId limit 1];
    	System.assert(crsReview.Review_Status__c == 'Review Completed');
    }
}