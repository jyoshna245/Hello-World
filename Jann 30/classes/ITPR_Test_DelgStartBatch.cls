@isTest
private class ITPR_Test_DelgStartBatch{
    static testmethod void test1(){
        test.startTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        String jobId = System.schedule('ITPR_Test_DelgStartBatch', CRON_EXP ,new ITPR_Delegation_OldDocumentStartSchedule());
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
        test.stopTest();
    }
    
  static testmethod void test2(){
  Test.startTest();
       List<ITPRDelegation__c> lst = new List<ITPRDelegation__c>();
       List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
       List<User> lstUsers = new List<User>();
User user1 = new User(
            username = 'testdel1' + DateTime.now().getTime() + '@test.com',
            alias = 'del1',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'del1',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user1);
        User user2 = new User(
            username = 'testdel2' + DateTime.now().getTime() + '@test.com',
            alias = 'del2',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest2',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user2);
        
        User user3 = new User(
            username = 'testdel3' + DateTime.now().getTime() + '@test.com',
            alias = 'del3',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest3',
            profileId = mapProfiles.get('ITSES - Finance'),
            ITPR_Department__c =  'ITSES - Finance',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user3);
        
        
        User user4 = new User(
            username = 'testdel4' + DateTime.now().getTime() + '@test.com',
            alias = 'del4',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest3',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user4);
        
        User user5 = new User(
            username = 'testdel5' + DateTime.now().getTime() + '@test.com',
            alias = 'del5',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest5',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user5);
        
        User user6 = new User(
            username = 'testdel6' + DateTime.now().getTime() + '@test.com',
            alias = 'del6',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest6',
            profileId = mapProfiles.get('System Administrator'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user6);
        
        User user7 = new User(
            username = 'testdel7' + DateTime.now().getTime() + '@test.com',
            alias = 'del7',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest7',
            profileId = mapProfiles.get('System Administrator'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user7);
        
        insert lstUsers;
       System.runAs(user5){
       ITPRDelegation__c delObj = new ITPRDelegation__c ();
       
       delObj.Delegate_To__c= user4.Id;
       delObj.start_Date__c = Date.Today() +5;
       delObj.End_Date__c = Date.Today() +10;
       insert delObj;
        
       lst.add(delObj);
       }
       System.runAs(user1) {
       ITPRDelegation__c delObj1 = new ITPRDelegation__c ();
       delObj1.Delegate_To__c= user2.Id;
       delObj1.start_Date__c = Date.Today() +5;
       delObj1.End_Date__c = Date.Today() +10;
       insert delObj1;
       lst.add(delObj1);
       }
       
       
       ITPR__c ITPRObj = new ITPR__c();
       ITPRObj.Procurement_Assignee__c = User2.Id;
       ITPRObj.Request_Type__c = System.Label.ITPR_Request_type_RFI;
    ITPRObj.category__c = 'Telecom';
    ITPRObj.Organization__c = 'CONA';
    ITPRObj.Finance_Assignee__c = user3.Id;
    ITPRObj.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
     ITPRObj.Date_Needed_by__c =  Date.today();
    ITPRObj.Supplier_Contact_Phone_Number__c = '9998889898';
    ITPRObj.Engagement_Of_A_New_Supplier__c = 'No';
    ITPRObj.Manager__C = user2.Id;
    ITPRObj.Opportunity_Statement__c = 'test';
    ITPRObj.CAPEX1__c = 200;
    ITPRObj.OPEX1__c = 100;
    ITPRObj.Procurement_Assignee__c= user1.Id;
       insert ITPRObj;
       
       
       
       ITPR__c ITPRObj1 = new ITPR__c();
       ITPRObj1.Procurement_Assignee__c = User2.Id;
       ITPRObj1.Request_Type__c = System.Label.ITPR_Request_type_RFI;
    ITPRObj1.category__c = 'Telecom';
    ITPRObj1.Organization__c = 'CONA';
    ITPRObj1.Finance_Assignee__c = user3.Id;
    ITPRObj1.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
     ITPRObj1.Date_Needed_by__c =  Date.today();
    ITPRObj1.Supplier_Contact_Phone_Number__c = '9998889898';
    ITPRObj1.Engagement_Of_A_New_Supplier__c = 'No';
    ITPRObj1.Manager__c = user2.Id;
    ITPRObj1.Opportunity_Statement__c = 'test';
    ITPRObj1.CAPEX1__c = 200;
    ITPRObj1.OPEX1__c = 100;
    ITPRObj1.Legal_Assignee__c= user4.Id;
    insert ITPRObj1;
       
       
        Database.BatchableContext BC;
        List<sObject> scope = new List<sobject>();
        scope.add(ITPRObj);
        scope.add(ITPRObj1);
        
       ITPR_Delegation_OldDocumentsStartBatch obj = new ITPR_Delegation_OldDocumentsStartBatch();
       obj.lstDelegation = lst;
       obj.start(BC);
        obj.execute(BC, scope);
        obj.finish(BC);
        
        Test.stopTest();
    }
}