/***********************************************************************
Trigger Name  : DealTriggerHandler_Test
Created By   	: Kirti Agarwal
Created Date 	: 15th Nov,2013
Purpose      	: Test class for class DealTriggerHandler
Task         	: T-212459
************************************************************************/
@isTest
private class DealTriggerHandler_Test {

    static testMethod void DealTriggerTestForAfterInsert() {

      List<User> listOfUser = new List<User>();
      for(Integer i = 1; i<=3; i++){
	      User usr  = createUser('first'+i,'last'+i,'System Administrator',null, i);
	      usr.Deal_Management_User__c = false;
        listOfUser.add(usr);
      }
      insert listOfUser;
    	 Deal_History_Tracking_Setting__c rec = new Deal_History_Tracking_Setting__c();
    	 rec.Name = 'Current_Status__c';
    	 insert rec;
    	 List<Deal__c> dealList = new List<Deal__c>();
    	 for(integer i=0; i<100; i++) {
	       Deal__c deal = new Deal__c();
	       deal.Current_Status__c = 'test 1';
		     deal.Close_Date__c = date.today().addDays(1);
		     deal.Target__c = 'test';
		     deal.Other_Associates__c = 'first1 last1;first3 last3';
		     deal.Current_Status_Date__c = date.today();
	       dealList.add(deal);
    	 }
    	 insert dealList;

    	 Test.StartTest();
    	 List<Deal__c> dealListRec = new List<Deal__c>();
       for(Deal__c deal : dealList) {
	       deal.Current_Status__c = 'test 2';
	       deal.Other_Associates__c = 'first1 last1;first2 last2';
	       dealListRec.add(deal);
       }
       update dealListRec;

       List<Deal_History_Tracking__c> dealRecList = [SELECT id,
       																						New_Value__c,
       																						Previous_Value__c
   																				FROM Deal_History_Tracking__c
   																				WHERE Deal__c IN: dealListRec];

   		for(Deal_History_Tracking__c dealRec : dealRecList) {
	   		system.assertEquals(dealRec.New_Value__c, 'test 2');
	   	  system.assertEquals(dealRec.Previous_Value__c, 'test 1');
   		}

       Test.StopTest();
    }

    static testMethod void DealTriggerTestForBeforeInsert() {
    	Test.StartTest();
    	User usr  = createUser('first','last','System Administrator',null, 1);
    	usr.Deal_Management_User__c = false;
    	insert usr;

    	 Deal__c deal = new Deal__c();
	     deal.Current_Status__c = 'test 1';
	     deal.Close_Date__c = date.today().addDays(1);
	     deal.Target__c = 'test';
	     deal.Current_Status_Date__c = date.today();
	     deal.Other_Associates__c = usr.FirstName + ' ' + usr.LastName;
	     insert deal;
	     Test.stopTest();

	    //cann't get the share record because of we cannot change in metadata picklist value of Deal in test class

    }

     public static User createUser(String firstName,String lastName, String profileName,String Role, Integer index) {
        Profile profile;
        for(Profile p : [select Id,Name from Profile where Name =:profileName limit 1]){
            profile = p;
        }
        User user = new User();
        user.Username = firstName+Date.Today().day()+Date.Today().month()+Date.Today().year() + index +'@test.com';
        user.FirstName = firstName;
        user.LastName = lastName;
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