// 
//  (c) 2014 Appirio, Inc.
// 
//  CaseTriggerHnadler_Test
//  Test class for CaseTriggerHnadler
//  T-295612
//
//  14th July 2014      Ashish Goyal(JDC)       Original
//  25th July 2014      Hemendra Singh Bhati    Modified
@isTest
private class CaseTriggerHnadler_Test
{
     /*
        @Method Name : testCaseTriggerForLead
        @description : Method to test the trigger when Owner role is Compliance Manager
        @parameters  : none
        @returns     : void
    */
     static testMethod void testCaseTriggerForManager()
     {
      // Creating Test Data.
      User us;
      User testUser = TestUtilityHelper.createUser('tetta', UserInfo.getProfileId(),'nTest','test.tetts@appirio.com');
      insert testUser; 

      // Creating Compliance Manager.
      System.runAs(testUser)
      {
          List<UserRole> userRoleList = new List<UserRole>([SELECT Id from UserRole where Name like '%Ethics & Compliance Manager%']);          
          us = TestUtilityHelper.createUser('testa', UserInfo.getProfileId(),'testN','test.tets@appirio.com');
            if(userRoleList.size() > 0)
            {
               us.UserRoleId = userRoleList.get(0).Id;
            }
            insert us;
      }

      // Running Test With Compliance Manager.
        System.runAs(us)
        {           
                    TestUtilityHelper.createNAAccount();
                    Case cs = TestUtilityHelper.createCase(testUser.Id);            

                    Test.startTest();

                    insert cs;
                    system.assert(cs.OwnerId != testUser.Id);

                    Investigation_Activity__c invest = TestUtilityHelper.createInvestigationActivity(cs.Id, true);
                    cs.Case_Short_Description__c = 'Test Short Description';
                    update cs;

            Test.stopTest();
      }
    }

        /*
            @Method Name : testCaseTriggerForLead
            @description : Method to test the trigger when Owner role is Compliance User
            @parameters  : none
            @returns     : void
        */
    static testMethod void testCaseTriggerForUser()
    {       
        // Creating Test Data.
           User us;
           User testUser = TestUtilityHelper.createUser('tetta', UserInfo.getProfileId(),'nTest','test.tetts@appirio.com');
           insert testUser;

       // Creating Compliance User.
       System.runAs(testUser)
       {
          List<UserRole> userRoleList = new List<UserRole>([SELECT Id from UserRole where Name like '%Ethics & Compliance User%']);         
                us = TestUtilityHelper.createUser('testa', UserInfo.getProfileId(),'testN','test.tets@appirio.com');
            if(userRoleList.size() > 0)
            {
               us.UserRoleId = userRoleList.get(0).Id;
            }
            insert us;
           }

           // Running Test With Compliance User.
         System.runAs(us)
         {
            TestUtilityHelper.createNAAccount(); 
            Case cs = TestUtilityHelper.createCase(testUser.Id);

            Test.startTest();

            cs.Affected_Employee_Last_Name__c = 'Test Affected Last Name';
            cs.Contacting_Employee_Last_Name__c = 'Test Contacting Last Name';
            cs.Affected_Employee_Job_Title__c = 'SFDC Consultant';
            cs.Affected_Employee_Hire_Date__c = Date.today();
            insert cs;

          Investigation_Activity__c testInvest = TestUtilityHelper.createInvestigationActivity(cs.Id,true);

          system.assert(cs.OwnerId != testUser.Id);

          List<Contact> c = [SELECT Id FROM Contact];
          system.assert(c.size() > 0,'CaseTrigger failed to create new contacts.');

          cs.Type = 'Centrally Managed';
          cs.Status = 'Closed';
          cs.Code_Violation_Picklist__c = 'No';
          cs.Resolution_Date__c = Date.Today();
          cs.Resolution_Category__c = 'Example';
          update cs;

            Test.stopTest();
       }
     }
}