/**
* Author,email :     Madel Pascua , mpascua@coca-cola.com
* Date Create  :     September 24, 2013
* Description  :     Test method for GS1_RequestAttribute
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

//@isTest (SeeAllData=true)
@isTest
private class GS1_TestEANFreeProcessor {
     static testMethod void test1() {
        Test.startTest();
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            DateTime oldDate = system.now();
            oldDate = oldDate.addYears(-10);
            GS1_Request__c[] reqs = GS1_TestHelper.createRequest(6, GS1_TestHelper.REQUEST_CUDU);
            GS1_EAN__c[] barcode = GS1_TestHelper.createBarcodes(true, true, 1111111, 1111113);
            
            reqs[0].EAN_Code__c = barcode[0].id;
            reqs[1].EAN_Code__c = barcode[0].id;
            reqs[0].status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;
            reqs[1].status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;     
            reqs[0].Withdraw_Date__c = system.now();
            reqs[1].Withdraw_Date__c = oldDate;
            
            reqs[2].EAN_Code__c = barcode[1].id;
            reqs[3].EAN_Code__c = barcode[1].id;
            reqs[2].Withdraw_Date__c = oldDate;
            reqs[3].Withdraw_Date__c = oldDate;
            reqs[2].status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;
            reqs[3].status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;             
            
            reqs[4].EAN_Code__c = barcode[2].id;
            reqs[5].EAN_Code__c = barcode[2].id;
            reqs[4].Withdraw_Date__c = oldDate;
            reqs[5].Withdraw_Date__c = oldDate;
            reqs[4].status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            reqs[5].status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN; 
            update reqs;
            
            GS1_EANFreeProcessor proc = new GS1_EANFreeProcessor();
            proc.execute(null);
        }    
        Test.stopTest();
     }
    
}