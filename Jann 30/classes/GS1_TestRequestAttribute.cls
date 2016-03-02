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

@isTest //(SeeAllData=true)
private class GS1_TestRequestAttribute{ 
    static testMethod void successfulTest() {
        Test.startTest();    
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            List<GS1_Request__c>  gs1ListTest = GS1_TestHelper.createRequest(3, GS1_TestHelper.REQUEST_CUDU);     
            //insert gs1ListTest;    
            GS1_RequestAttribute gs1ReqAttribute = new GS1_RequestAttribute(gs1ListTest[0]);    
            Boolean testVar = gs1ReqAttribute.userCanSubmit;    
            testVar = gs1ReqAttribute.userCanAllocateEAN; 
            testVar = gs1ReqAttribute.userCanWithdraw; 
            testVar = gs1ReqAttribute.userCanReactivate;     
            testVar = gs1ReqAttribute.userCanCreateCopy; 
            testVar = gs1ReqAttribute.userCanEdit; 
            testVar = gs1ReqAttribute.userCanCancelDuplicate; 
            testVar = gs1ReqAttribute.userCanAllocateShortLong; 
            testVar = gs1ReqAttribute.userCanCancel;    
      
            gs1ListTest[1].Status__c = GS1_Constants.REQUEST_STATUS_NEW;
            GS1_RequestAttribute gs1ReqAttribute2 = new GS1_RequestAttribute(gs1ListTest[1]);
            testVar = gs1ReqAttribute2.userCanCreateCopy; 
    
            gs1ListTest[2].Status__c = GS1_Constants.REQUEST_STATUS_APPROVED;
            GS1_RequestAttribute gs1ReqAttribute3 = new GS1_RequestAttribute(gs1ListTest[2]);
            testVar = gs1ReqAttribute3.userCanAllocateEAN; 
    
            gs1ListTest[2].Status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            GS1_RequestAttribute gs1ReqAttribute4 = new GS1_RequestAttribute(gs1ListTest[2]);    
            testVar = gs1ReqAttribute4.userCanWithdraw;    
            
            gs1ListTest[2].Status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;
            GS1_RequestAttribute gs1ReqAttribute5 = new GS1_RequestAttribute(gs1ListTest[2]);
            testVar = gs1ReqAttribute5.userCanReactivate;     
    
            gs1ListTest[2].Status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            gs1ListTest[2].EAN_Code__c = GS1_TestHelper.createBarCodes(false,false, 1000001, 1000001)[0].Id;
            update gs1ListTest;
  
            GS1_RequestAttribute gs1ReqAttribute6 = new GS1_RequestAttribute(gs1ListTest[2]);
            testVar = gs1ReqAttribute6.userCanWithdraw;
    
            gs1ListTest[2].Status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;
            GS1_RequestAttribute gs1ReqAttribute7 = new GS1_RequestAttribute(gs1ListTest[2]);
            testVar = gs1ReqAttribute7.userCanReactivate;
        }
        Test.stopTest();    
    }     
}