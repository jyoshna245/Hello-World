/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 20, 2013
* Description  :     Test class for GS1_Constants class
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*
*/
@isTest //(SeeAllData=true)
private class GS1_TestApprCommentCtrl {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
       User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){        
	        Test.startTest();
	        String comment = 'this is a test';
	        GS1_Request__c req = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU)[0];
	        GS1_ApprCommentCtrl c = new GS1_ApprCommentCtrl ();
	        c.objectid = req.id;
	        c.getComments();
	        GS1_AppWebHelperJSCtrl.submitRequest(req.id, null);
	        GS1_ApprovalProcess apr = new GS1_ApprovalProcess(req);
	        apr.decide('Reject', comment);        
	        //System.assert(comment == c.getComments(), 'FAILED!');
	        Test.stopTest();
        }
    }
}