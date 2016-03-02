/**
* Author,email :     Madel Pascua , mpascua@coca-cola.com
* Date Create  :     September 23, 2013
* Description  :     Test method for GS1_CommonFunctions
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

@isTest //(SeeAllData=true)
private class GS1_TestCommonFunctions{
    
    static testMethod void successfulTest() {
       	User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){     	
        	Test.startTest();           
            //GS1_CommonFunctions gs1CF = new GS1_CommonFunctions();    
            GS1_CommonFunctions.navigateToRecordList('GS1_Request__c');
            GS1_CommonFunctions.navigateToRecordList('GS1_Non_Existing_Dummy_Object__c');    
            String prefixId = GS1_CommonFunctions.getObjectPrefix('GS1_Request__c');
            String objectName = GS1_CommonFunctions.getObjectNameByPrefix(prefixId);
            GS1_CommonFunctions.isGS1Admin(UserInfo.getUserId());
            Id etId = [SELECT Id from EmailTemplate LIMIT 1].Id;
            GS1_Request__c  gs1Test = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU)[0];        
            //insert gs1Test;
            GS1_CommonFunctions.composeEmailFromTemplate(etId , gs1Test.Id);
            GS1_CommonFunctions.isSystemAdministrator();
        	Test.stopTest();
        }
   }          
}