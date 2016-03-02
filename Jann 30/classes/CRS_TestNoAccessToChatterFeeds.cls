@isTest
public class CRS_TestNoAccessToChatterFeeds {
	static testMethod void testFeed() {
     	Profile saProfile = [SELECT Id FROM Profile WHERE Name= :'CRS (crs only) Standard User'];
        User u = new User(Alias = 'sadmin', Email='sysadmin@testorg.sadm', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = saProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='systemadmin@testorg.com');
        insert u;
     	
     	 System.runAs(u) {
	     	CRS__c crs = CRS_TestHelper.prepareDraftCRS();
	     	FeedItem fi = new FeedItem(ParentId = crs.Id, Body ='test sample');
	     	insert fi;
			FeedItem fiToDel = [select id from feeditem where id = :fi.Id];
			delete fi;
     	 }
    } 
}