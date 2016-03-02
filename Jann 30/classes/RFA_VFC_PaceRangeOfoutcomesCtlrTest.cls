@IsTest(seeAllData=false)
public class RFA_VFC_PaceRangeOfoutcomesCtlrTest
{
  static testmethod void pacerangeofoutcomes()
    { 
       RFA__c testRFA = new RFA__c();
       /* testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        RFATestData rtTest = new RFATestData();
         rtTest.buildProfitCenter();
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        */
        testRFA.ID='a0Gg000000AwNO5';
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
        PageReference pageRef = Page.RFA_VFP_PaceRangeOfoutcomes;
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('id', testRFA.id); 
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(testRFA); 
        RFA_VFC_PaceRangeOfoutcomesController controller  = new RFA_VFC_PaceRangeOfoutcomesController (stdController);  
        controller.editpacerangefields();
        controller.savepacerangefields();
        controller.cancelpacerangefields();
    }
}