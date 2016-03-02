@IsTest(seeAllData=false)
public class RFA_VFC_EditPopupforApprvrsControlerTest 
{
    
    static testmethod void editpopup()
    {           
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        //RFATestData rtTest = new RFATestData();
        // rtTest.buildProfitCenter();
        
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

        PageReference pageRef = Page.RFA_VFP_EditPopupforApprovers;
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('id', testRFARole.id); 
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(testRFARole); 
        RFA_VFC_EditPopupforApprvrsControler controller  = new RFA_VFC_EditPopupforApprvrsControler(stdController);               
       // ApexPages.StandardController Controller = new ApexPages.StandardController();
       // RFA_VFC_EditPopupforApprvrsControler objeditpopup = new RFA_VFC_EditPopupforApprvrsControler();
    }

}