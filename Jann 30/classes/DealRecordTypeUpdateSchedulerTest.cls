/***********************************************************************
Class Name  : DealRecordTypeUpdateSchedulerTest
Created By      : Kirti Agarwal
Created Date    : 6th Dec, 2013
Purpose         : Test class for DealRecordTypeUpdateScheduler
Task            : T-216705
************************************************************************/
@isTest
private class DealRecordTypeUpdateSchedulerTest {

     static testMethod void DealRecordTypeUpdateSchedulerTest() {

    	  Deal_UN_PW_Setting__c userNamePWSetting = new Deal_UN_PW_Setting__c();
    	  userNamePWSetting.Name = 'test';
    	  userNamePWSetting.UserName__c = 'test';
    	  userNamePWSetting.Password__c = 'test';
    	  userNamePWSetting.Consumer_Key__c = 'test';
    	  userNamePWSetting.Secret_Key__c = 'test';
    	  userNamePWSetting.Token_End_Point__c = 'test';
    	  insert userNamePWSetting;

    	  Deal_Record_Type_Setting__c recordSetting = new Deal_Record_Type_Setting__c();
    	  recordSetting.Name = 'test';
    	  recordSetting.Label__c = 'test';
    	  recordSetting.Full_Name__c = 'test';
    	  insert recordSetting;

    	  User usr  = createUser('System Administrator',null, 1);
        usr.Deal_Management_User__c = true;
        insert usr;

        Test.StartTest();
        String scheduleStr = String.valueOf(DateTime.now().second())+' '+ String.valueOf(DateTime.now().minute())+ ' '+String.valueOf(DateTime.now().hourGmt()) +' * * ?';
        DealRecordTypeUpdateScheduler schedule = new DealRecordTypeUpdateScheduler();
        String jobId = System.schedule('test schedule11', scheduleStr, schedule);
        system.debug('jobId ::: '+ jobId);

        //we can't check the metadata updation in the test class
        Test.StopTest();
    }



    public static User createUser(String profileName,String Role, Integer index) {
        Profile profile;
        for(Profile p : [select Id,Name from Profile where Name =:profileName limit 1]){
            profile = p;
        }
        User user = new User();
        user.Username = 'testUser'+Date.Today().day()+Date.Today().month()+Date.Today().year() + index +'@test.com';
        user.LastName = 'User'+DateTime.Now();
        user.Email = 'test@user.com';
        user.Alias = 'tUser' + index;
        user.CommunityNickname = 'tuser' + index;
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        if(profile != null){
            user.profileId = profile.id;
        }
        if(Role != null){
            List<UserRole> roleVal = [select Id,Name from UserRole where Name =:Role limit 1];
            if(roleVal.size() > 0)
                user.UserRoleId = roleVal.get(0).Id;
        }
        return user;
    }
}