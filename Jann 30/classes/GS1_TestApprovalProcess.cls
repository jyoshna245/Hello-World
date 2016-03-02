/**
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     September 26, 2013
* Description  :     Test method for GS1_ApprovalProcess 
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

@isTest //(SeeAllData=true)
private class GS1_TestApprovalProcess{ 
    static testMethod void successfulTest() {
        Test.startTest();
        // TO DO: implement unit test
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            String comment = 'this is a test';
            GS1_Request__c[] req = GS1_TestHelper.createRequest(3, GS1_TestHelper.REQUEST_CUDU);
            GS1_Trademark__c tm = GS1_TestHelper.createTrademark(1)[0];
            GS1_AppWebHelperJSCtrl.submitRequest(req[0].id, null);
            GS1_ApprovalProcess apr = new GS1_ApprovalProcess(req[0]);        
            apr.decide('Reject', comment);                     
            apr.decide('Approve', comment);
            apr.getLastErrorMessage();
            
            apr = new GS1_ApprovalProcess(req[1]);
            //apr.submit('test only');        
            GS1_AppWebHelperJSCtrl.submitRequest(req[1].id, null);               
            GS1_AuthorProfile__c[] auths = [select id,Active__c from GS1_AuthorProfile__c];
            for (GS1_AuthorProfile__c au : auths) {
                au.Active__c = false;
            }        
            update auths;
            
            apr.decide('Reject', 'test');
            apr.decide('Approve', 'test');
            
            apr = new GS1_ApprovalProcess(req[2]);
            apr.submit('test only');        
            
            GS1_ApprovalProcess apr2 = new GS1_ApprovalProcess(tm);
            apr2.submit('test');
        }
        Test.stopTest();
    }
}