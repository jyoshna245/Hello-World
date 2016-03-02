/**
 * Test for CRS_ContentWrapperDeleteController class
 */
@isTest
private class CRS_TestContentWrapperDeleteController {
	
    /**
     * In the current API version (25) we cannot programmaticaly link ContentVersion to custom objects.
     * So full testing cannot be performed.
     */
	/*testMethod static void testDeleteRecord() {
        PageReference pageRef = Page.CRS_ContentWrapperDelete;
        pageRef.getParameters().put('retURL', 'testUrl');
        
        Test.setCurrentPage(pageRef);
        
        CRS__c crs = new CRS__c();
        crs.CRS_Document_Title__c = 'test doc title';
        insert crs;
        
        CRS_ContentWrapper__c wrapper = new CRS_ContentWrapper__c();
        wrapper.CRS__c = crs.Id;
        insert wrapper;
        
        CRS_ContentWrapperDeleteController testController = new CRS_ContentWrapperDeleteController(new ApexPages.StandardController(wrapper));
        testController.deleteRecord();
	}
*/
}