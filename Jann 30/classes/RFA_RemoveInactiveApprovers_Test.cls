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
@isTest(SeeAllData=true)
private class RFA_RemoveInactiveApprovers_Test {
    
    static testmethod void RFA_RemoveInactiveApprovers_TestMethod1()
    {
        
        User testUser=new User();
        
        testUser = new User();
        testUser.alias = 'RFA1';
        testUser.email = 'cokeuserfortest@cocacola.com';
        testUser.emailencodingkey='UTF-8';
        testUser.lastName = 'test';
        testUser.languagelocalekey='en_US';
        testUser.localesidkey='en_US';
        testUser.ProfileId = RFATestData.rfaStandardUserProfile;
        testUser.timezonesidkey='Europe/London';
        testUser.UserName =  'test1235@rfa.cocacola.com';
        testUser.IsActive=True;
        insert testUser;
        
         
        RFA_COA_Group__c RFACOAgrouptest=new RFA_COA_Group__c();
        RFACOAgrouptest.Currency__c='USD';
        RFACOAgrouptest.Amount__c=12356;
        RFACOAgrouptest.DOA_Category__c='2.IT Investments and Website Presence';
        RFACOAgrouptest.Group__c=5;
        insert RFACOAgrouptest;
		  
        
        RFA_Approver__c RFAApproverTest = new RFA_Approver__c();
        RFAApproverTest.RFA_COA_Group__c=  RFACOAgrouptest.id;
        RFAApproverTest.UserName__c=testUser.id;
        RFAApproverTest.UserRole__c='Co-Creator';
        insert RFAApproverTest; 
        
        
        
		testUser = new User();
        testUser.alias = 'RFA1';
        testUser.email = 'cokeuserfortest123@cocacola.com';
        testUser.emailencodingkey='UTF-8';
        testUser.lastName = 'test';
        testUser.languagelocalekey='en_US';
        testUser.localesidkey='en_US';
        testUser.ProfileId = RFATestData.rfaStandardUserProfile;
        testUser.timezonesidkey='Europe/London';
        testUser.UserName =  'test123533@rfa.cocacola.com';
        testUser.IsActive=false;
        insert testUser;  
         
       
        
    }
	
    
}