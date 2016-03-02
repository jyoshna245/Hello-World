// 
// (c) 2014 Appirio, Inc.
// 
// InvestigationActivityTriggerHandler_Test
// Test class for InvestigationActivityTriggerHandler
// T-301209
//
// 18 July 2014     Ashish Goyal(JDC)       Original
//

@isTest
private class InvestigationActivityTriggerHandler_Test {
    
    /*
        @Method Name : testCaseTriggerForLead
        @description : Method to test the trigger when Owner role is Compliance Manager
        @parameters  : none
        @returns     : void
    */
     static testMethod void testCaseTriggerForManager() {       
        
        // Test data
        User us;
        User testUser = TestUtilityHelper.createUser('tetta', UserInfo.getProfileId(),'nTest','test.tetts@appirio.com');
        insert testUser; 
        
        // Creating Compliance Manager
        System.runAs(testUser){
            List<UserRole> userRoleList = new List<UserRole>([SELECT Id from UserRole where Name like '%Ethics & Compliance Manager%']);            
            us = TestUtilityHelper.createUser('testa', UserInfo.getProfileId(),'testN','test.tets@appirio.com');
            if(userRoleList.size() > 0){
                us.UserRoleId = userRoleList.get(0).Id;
            }
            insert us;
        }
        
        // running test with Compliance Manager
        System.runAs(us){           
            TestUtilityHelper.createNAAccount();
            Case cs = TestUtilityHelper.createCase(testUser.Id);            
            Test.startTest();
            insert cs;
            system.assert(cs.OwnerId != testUser.Id);           
            Investigation_Activity__c invest = TestUtilityHelper.createInvestigationActivity(cs.Id, true);
            cs.Case_Short_Description__c = 'test des';
            update cs;
            
            Test.stopTest();
        }
     }  
}