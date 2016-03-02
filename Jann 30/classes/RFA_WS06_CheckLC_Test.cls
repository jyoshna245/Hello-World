/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */ 
@isTest
private class RFA_WS06_CheckLC_Test {

    static testMethod void myUnitTest() {
    test.StartTest();
       
        RFATestData testData = new RFATestData();
    	testData.buildProfitCenter();
    	//testData.buildProfitCenterUserRole(RFATestData.testProfitCenter.Id); 
    	testData.createRequester();
  		
  		//Adding loggedIn User
    	
    	
    	ProfitCenterUserRole__c koUserRole_User = new ProfitCenterUserRole__c();
    	koUserRole_User.Level__c = '1. Key Operations';
    	koUserRole_User.ProfitCenter__c =RFATestData.testProfitCenter.Id;
    	koUserRole_User.UserName__c = RFATestData.requester.Id;
    	koUserRole_User.UserType__c = 'Location Coordinator';
    	insert koUserRole_User;
    	
    	koUserRole_User.UserName__c=UserInfo.getUserId();
    	koUserRole_User.UserType__c='2. Business Unit';
    	update koUserRole_User;
    	System.RunAs(RFATestData.requester)
    	{
    		
  		RFA_WS06_CheckLC.isLocationCoorinator(RFATestData.testProfitCenter.Id);
    	}
    	System.RunAs(RFATestData.requester)
    	{
    	koUserRole_User.UserType__c='2. Business Unit';
    	try{
    	update koUserRole_User;
    	}catch (DMLException e)
    	{	
    		System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));	
    	}
    	koUserRole_User.UserName__c=UserInfo.getUserId();
    	try{
    		
    	}catch(DMLException e)
    	{
    			System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));	
    	
    	}
    	
    	}
    	RFA_WS06_CheckLC.isLocationCoorinator(RFATestData.testProfitCenter.Id);
    	}
}