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
private class RFA_VFC13_New_Approver_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
 
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        RFATestData rtTest = new RFATestData();
         rtTest.buildProfitCenter();
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        
        string profile = RFATestData.RFAStandardUserProfile;
        RFATestData RTData = new RFATestData();
        User grUser = new User();
        grUser = RTData.createUser(profile, 'TestUser', 'grlastt', grUser);

        User grUser2 = new User();
        grUser2 = RTData.createUser(profile, 'TUser2', 'grlas2', grUser2);
                
        RFAUserRole__c testRFARole = new RFAUserRole__c();
        testRFARole.UserName__c = grUser.Id;
        testRFARole.RFA__c = testRFA.ID;
        
        testRFARole.Level__c = '1. Key Operations';
        insert testRFARole;

        PageReference pageRef = Page.RFA_VFP13_New_Approver;
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('id', testRFARole.id); 
        ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFARole);
        RFA_VFC13_New_Approver controller1 = new RFA_VFC13_New_Approver(stdController1); 
            
           controller1.rfaUserObj.UserName__c = grUser2.Id;
           controller1.doSaveAndNew();
       
        PageReference pageRef1 = Page.RFA_VFP13_New_Approver;
        Test.setCurrentPage(pageRef1);     
        ApexPages.Standardcontroller stdController2 = new ApexPages.Standardcontroller(testRFARole);
        RFA_VFC13_New_Approver controller2 = new RFA_VFC13_New_Approver(stdController2); 

    }
    
     static testMethod void myUnitTest2() {
        // TO DO: implement unit test
 
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        RFATestData rtTest = new RFATestData();
         rtTest.buildProfitCenter();
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        
        string profile = RFATestData.RFAStandardUserProfile;
        RFATestData RTData = new RFATestData();
        User grUser = new User();
        grUser = RTData.createUser(profile, 'TestUser', 'grlastt', grUser);

        User grUser2 = new User();
        grUser2 = RTData.createUser(profile, 'TUser2', 'grlas2', grUser2);
                
        RFAUserRole__c testRFARole = new RFAUserRole__c();
        testRFARole.UserName__c = grUser.Id;
        testRFARole.RFA__c = testRFA.ID;
        
        testRFARole.Level__c = '1. Key Operations';
        insert testRFARole;

       

        PageReference pageRef = Page.RFA_VFP13_New_Approver;
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('id', testRFARole.id); 
        ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFARole);
        RFA_VFC13_New_Approver controller1 = new RFA_VFC13_New_Approver(stdController1); 
            
           controller1.rfaUserObj.UserName__c = grUser2.Id;
           controller1.doSave();
           
        PageReference pageRef1 = Page.RFA_VFP13_New_Approver;
        Test.setCurrentPage(pageRef1);     
        ApexPages.Standardcontroller stdController2 = new ApexPages.Standardcontroller(testRFARole);
        RFA_VFC13_New_Approver controller2 = new RFA_VFC13_New_Approver(stdController2); 

    }
}