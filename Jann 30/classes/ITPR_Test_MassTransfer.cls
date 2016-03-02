@isTest
private class ITPR_Test_MassTransfer{
    static testmethod void test1(){
        test.startTest();
        String CRON_EXP = '0 0 0 6 9 ? 2022';
        String jobId = System.schedule('ITPR_Test_MassTransfer', CRON_EXP ,new ITPR_MassTransferScheduler());
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
        test.stopTest();
    }
    
    static testmethod void test2(){
    Test.startTest();
       List<ITPR_Mass_Transfer__c> lst = new List<ITPR_Mass_Transfer__c>();
       List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
        List<User> lstUsers = new List<User>();
        User user1 = new User(
            username = 'testmass1' + DateTime.now().getTime() + '@test.com',
            alias = 'mass1',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'mass1',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user1);
        User user2 = new User(
            username = 'testmass2' + DateTime.now().getTime() + '@test.com',
            alias = 'mass2',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'masstest2',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user2);
        
        User user3 = new User(
            username = 'testmass3' + DateTime.now().getTime() + '@test.com',
            alias = 'mass3',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'masstest3',
            profileId = mapProfiles.get('ITSES - Finance'),
            ITPR_Department__c =  'ITSES - Finance',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user3);
        
        
        User user4 = new User(
            username = 'testmass4' + DateTime.now().getTime() + '@test.com',
            alias = 'mass4',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'masstest3',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user4);
        
        User user5 = new User(
            username = 'testmass5' + DateTime.now().getTime() + '@test.com',
            alias = 'mass5',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'masstest5',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user5);
       insert lstUsers;
       
       ITPR_Mass_Transfer__c mtObj = new ITPR_Mass_Transfer__c();
       mtObj.Select_User__c = user1.Id;
       mtObj.Mass_Transfer_To__c= user2.Id;
       insert mtObj; 
       ITPR_Mass_Transfer__c mtObj1 = new ITPR_Mass_Transfer__c();
       mtObj1.Select_User__c = user4.Id;
       mtObj1.Mass_Transfer_To__c= user5.Id;
       insert mtObj1;
       
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
    ITPRObj1.Manager__C = user2.Id;
    ITPRObj1.Opportunity_Statement__c = 'test';
    ITPRObj1.CAPEX1__c = 200;
    ITPRObj1.OPEX1__c = 100;
    ITPRObj1.Legal_Assignee__c= user4.Id;
       insert ITPRObj1;
       
       
        Database.BatchableContext BC;
        List<sObject> scope = new List<sobject>();
        scope.add(ITPRObj);
        scope.add(ITPRObj1);
        
       ITPR_MassTransferBatch  obj = new ITPR_MassTransferBatch ();
       obj.start(BC);
        obj.execute(BC, scope);
        obj.finish(BC);
        
        Test.stopTest();
    }
}