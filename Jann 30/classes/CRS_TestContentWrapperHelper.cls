/**
 * Test for CRS_ContentWrapperHelper class.
 */
@isTest
private class CRS_TestContentWrapperHelper {
    
    /**
     * In the current API version (25) we cannot programmaticaly link ContentVersion to custom objects.
     * So full testing cannot be performed.
     */
    testMethod static void testSyncCRSWrappers() {
        CRS__c crs = new CRS__c();
        crs.CRS_Document_Title__c = 'test doc title';
        insert crs;
        CRS_ContentWrapperHelper.syncCRSWrappers(crs.Id);
        List<CRS_ContentWrapper__c> wrappers = [SELECT Id, FileId__c FROM CRS_ContentWrapper__c WHERE CRS__c = :crs.Id];
        System.assert(wrappers.size() == 0);
    }
    
    /**
     * In the current API version (25) we cannot programmaticaly link ContentVersion to custom objects.
     * So full testing cannot be performed.
     */
    testMethod static void testSyncCRSReviewWrappers() {
        CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
        CRS_Review__c crsReview = new CRS_Review__c(CRS_Tracking__c = crs.Id);
        insert crsReview;
        CRS_ContentWrapperHelper.syncCRSReviewWrappers(crsReview.Id);
        List<CRS_CRSReviewContentWrapper__c> wrappers = [SELECT Id, FileId__c FROM CRS_CRSReviewContentWrapper__c WHERE CRS_Review__c = :crsReview.Id];
        System.assert(wrappers.size() == 0);
    }
    
}