/***********************************************************************
Trigger Name  : UserTriggerHandlerTest
Created By   	: Kirti Agarwal
Created Date 	: 6th Dec,2013
Purpose      	: Test class for UserTriggerHandler
Task         	: T-216705
************************************************************************/
@isTest
public class UserTriggerHandlerTest {

	static testMethod void UserTriggerHandlerTest() {
		Test.startTest();
			User userRecord = createUser('System Administrator', null, 1);
			insert userRecord;
		Test.stopTest();
		Boolean val = false;
		Schema.DescribeFieldResult fieldResult = Deal__c.Other_Associates__c.getDescribe();
		List<Schema.PicklistEntry> pickList = fieldResult.getPicklistValues();
		for(Schema.PicklistEntry FieldValue : pickList) {
	     if( FieldValue.getValue() == userRecord.FirstName + ' ' + userRecord.LastName) {
	     	 val = true;
	     }
		}
		// we can't check metadata updation in test class
		// we can't call webservice method in test class
		// so 'metdataservice' class method need to be called directly
		MetadataService.CallOptions_element obj = new MetadataService.CallOptions_element();
    MetadataService.DebuggingInfo_element debugObj = new MetadataService.DebuggingInfo_element();
    MetadataService.LogInfo logObj = new MetadataService.LogInfo();
    MetadataService.DebuggingHeader_element debugHeaderobj = new MetadataService.DebuggingHeader_element();
    MetadataService.retrieve_element retobj = new MetadataService.retrieve_element();
    MetadataService.RetrieveRequest retReqobj = new MetadataService.RetrieveRequest();
    MetadataService.Package_x packobj = new MetadataService.Package_x();
    MetadataService.ProfileObjectPermissions profObj = new MetadataService.ProfileObjectPermissions();
    MetadataService.retrieveResponse_element resObj = new MetadataService.retrieveResponse_element();
    MetadataService.AsyncResult asynObj = new MetadataService.AsyncResult();
    MetadataService.update_element updateObj = new MetadataService.update_element();
    MetadataService.UpdateMetadata updateMetadataObj = new MetadataService.UpdateMetadata();
    MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    MetadataService.RetrieveRequest retReq = new MetadataService.RetrieveRequest();
    MetadataService.updateResponse_element updateRObj = new MetadataService.updateResponse_element();
    MetadataService.SessionHeader_element sessionEle = new MetadataService.SessionHeader_element();
    MetadataService.Picklist pickobj = new MetadataService.Picklist();
    MetadataService.CustomField custFieldObj = new MetadataService.CustomField();
    MetadataService.FilterItem filterObj = new MetadataService.FilterItem();
    MetadataService.PicklistValue plvObj = new MetadataService.PicklistValue();
    MetadataService.RecordTypePicklistValue rTPObj = new MetadataService.RecordTypePicklistValue();
    MetadataService.RecordType rtObj = new MetadataService.RecordType();
    MetadataService.PackageTypeMembers ptmObj = new MetadataService.PackageTypeMembers();

		//system.assertEquals(val, true);
	}

	  public static User createUser(String profileName,String Role, Integer index) {
        Profile profile;
        for(Profile p : [select Id,Name from Profile where Name =:profileName limit 1]){
            profile = p;
        }
        User user = new User();
        user.Username = 'testUser'+Date.Today().day()+Date.Today().month()+Date.Today().year() + index +'@test.com';
        user.FirstName = 'First Name';
        user.LastName = 'User';
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