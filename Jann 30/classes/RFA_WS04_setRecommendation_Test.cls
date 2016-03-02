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
private class RFA_WS04_setRecommendation_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
          test.StartTest();
        User testUsr1 = AdminUser('standt1'); 
        insert testUsr1;
        User testUsr2 = AdminUser('standt2'); 
        insert testUsr2;
        User testUsr3 = AdminUser('standt3'); 
        insert testUsr3;
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFATestData.getRecordType('General Request', 'RFA__c');
        String rt2 = RFATestData.getRecordType('Approver', 'RFAUserRole__c');
        ReportingUnit__c testReportingUnit=new ReportingUnit__c();
        testReportingUnit.ActiveInactive__c = 'Active';
        testReportingUnit.Name = 'USA Reporting Unit NA';
        testReportingUnit.Reporting_Unit_Name__c = 'Atlanta Bottling Company, Limited';
        insert testReportingUnit;
        ReportingUnit__c testReportingUnit1=new ReportingUnit__c();
        testReportingUnit1.ActiveInactive__c = 'Active';
        testReportingUnit1.Name = 'India Reporting Unit NA';
        testReportingUnit1.Reporting_Unit_Name__c = 'Bottling Company, Limited';
        insert testReportingUnit1;
        ReportingUnit__c testReportingUnit2=new ReportingUnit__c();
        testReportingUnit2.ActiveInactive__c = 'Active';
        testReportingUnit2.Name = 'USAUnit NA';
        testReportingUnit2.Reporting_Unit_Name__c = 'Atlanta Bottling';
        insert testReportingUnit2;
        
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =  rt;
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        
        testRFA.PrimaryReportingUnitNumber__c=testReportingUnit.Id;
        testRFA.SecondReportingUnitNumber__c=testReportingUnit1.Id;
        testRFA.ThirdReportingUnitNumber__c=testReportingUnit2.Id;
        insert testRFA;
/***********************/
        //create PPOC
        User pocUser = new User();
        pocUser = testData.createUser(RFATestData.rfaStandardUserProfile, 'ppoc', 'ppoc', pocUser);
        RFAUserRole__c ppocUserRole = RFATestData.buildPPOC(testRFA.Id, pocUser);
        insert ppocUserRole;
/***********************/
        
        testRFA.ExecutiveSummaryGuideline__c='test';
        testRfa.PrimaryDOACategorySubCategory__c='rr';
        RFATestData.updateThreeYearCashSpentForRFA(testRFA,Double.valueof('99.0'));
        testRFA.Stage__c = 'Circulation';
        testRFA.Level__c = '1. Key Operations';
        testRFA.DataClassification__c = 'Internal Use';
        testRFA.AREMonth__c = 'February';
        testRFA.InitialBudgetYear__c = '2013';
        testRFA.BudgetType__c = 'Formal';
        testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
        testRFA.RequestAmountFunctionalCurrency__c=99.0;
        testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
        testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
        testRFA.Functional_Currency__c = RFATestData.testARE.Id;
        update testRFA;
        
        
        System.runAs(RFATestData.requester)
        {
            try{
            RFA_WS04_KOApprove_setRecommendation.setRecommendation(null,null,null,null);
            }catch(Exception e)
            {
            }
            
            
        }
        try{
        RFA_WS04_KOApprove_setRecommendation.setRecommendation(null,null,null,null);
        }catch(Exception e)
        {
        
        }
        /*RFAUserRole__c rfaUser = new RFAUserRole__c(level__C='1. Key Operations', RFA__c = testRFA.Id, ApprovalRecommendation__c='Awaiting Approval', UserName__c = userinfo.getUserId(),
                                                    Agent1__c = testUsr1.Id, Agent2__c = testUsr2.Id, Agent3__c = testUsr3.Id,recordTypeId=rt2);
        insert rfaUser;*/
        
        RFAUserRole__c rfaUser = RFATestData.buildApprover(testRFA.Id, testRFA.level__c);
        rfaUser.UserName__c = UserInfo.getUserId();
        rfaUser.Agent1__c = testUsr1.Id;
        rfaUser.Agent2__c = testUsr2.Id;
        rfaUser.Agent3__c = testUsr3.Id;
        insert rfaUser;
        
        ApprovalProcess__c testProcess = new ApprovalProcess__c();
        Database.UpsertResult upsertResult = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
        if(upsertResult.isSuccess())
        {
            rfaUser.ApprovalProcess__c = upsertResult.getId();
            rfaUser.ApprovalOrder__c = 1;
            rfaUser.ApprovalRecommendation__c = 'Awaiting Approval';
            update rfaUser;
                
        }
        
        RFA_WS02_KOApprove_getAllRequests.statusMessageWrapper message=new RFA_WS02_KOApprove_getAllRequests.statusMessageWrapper('d','d');//Message class instance
        
        //RFA_WS04_KOApprove_setRecommendation.response(message);
        
        RFA_WS04_KOApprove_setRecommendation.setRecommendation('Test comments','Approved','standt1@coke.com',rfaUser.id);
        
    
    }
      public static User AdminUser(String alias){
        Profile profile = [select id from profile where name='System Administrator'];
        User user = new User(alias = alias, email=alias + '@coke.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profile.Id,FederationIdentifier=alias + '@coke.com',
            timezonesidkey='Europe/London', username=alias + '@coke.com');
        return user;
    }
}