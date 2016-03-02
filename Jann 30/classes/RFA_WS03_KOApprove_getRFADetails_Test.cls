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
private class RFA_WS03_KOApprove_getRFADetails_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.StartTest();
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFATestData.getRecordType('General Request', 'RFA__c');
        String rt1 = RFATestData.getRecordType('Primary Point of Contact', 'RFAUserRole__c');
        String rt2 = RFATestData.getRecordType('Approver', 'RFAUserRole__c');
        
        // creating list for testReportingUnit so that it will not hit governor limit error - RLC march 25, 2014
        
        List <ReportingUnit__c> listActiveInactive = new List <ReportingUnit__c>(); 
             ReportingUnit__c RU = New ReportingUnit__c ();
             RU.ActiveInactive__c  = 'Active';
             RU.Name = 'USA Reporting Unit NA';
             RU.Reporting_Unit_Name__c = 'Atlanta Bottling Company, Limited';
            
          listActiveInactive.add(RU);
          
          
        
        // end of creating list for testReportingUnit so that it will not hit governor limit error - RLC march 25, 2014


        ReportingUnit__c testReportingUnit=new ReportingUnit__c();
        testReportingUnit.ActiveInactive__c = 'Active';
        testReportingUnit.Name = 'USA Reporting Unit NA';
        testReportingUnit.Reporting_Unit_Name__c = 'Atlanta Bottling Company, Limited';
       // insert testReportingUnit;
          listActiveInactive.add(testReportingUnit);

        
        ReportingUnit__c testReportingUnit1=new ReportingUnit__c();
        testReportingUnit1.ActiveInactive__c = 'Active';
        testReportingUnit1.Name = 'India Reporting Unit NA';
        testReportingUnit1.Reporting_Unit_Name__c = 'Bottling Company, Limited';
        //insert testReportingUnit1;
        listActiveInactive.add(testReportingUnit1);

        
        ReportingUnit__c testReportingUnit2=new ReportingUnit__c();
        testReportingUnit2.ActiveInactive__c = 'Active';
        testReportingUnit2.Name = 'USAUnit NA';
        testReportingUnit2.Reporting_Unit_Name__c = 'Atlanta Bottling';
        //insert testReportingUnit2;
       listActiveInactive.add(testReportingUnit2);

        insert( listActiveInactive);
        
        User reportingUnitUser = new User();
        //reportingUnitUser = createUser(rfaStandardUserProfile, 'reUsert', 'rlastt', reportingUnitUser); 
        
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
        testRFA.ExecutiveSummaryGuideline__c='test';
        testRfa.PrimaryDOACategorySubCategory__c='rr';
        
        /* admin user - recode to avoid governor limit error - RLC March 26, 2014*/
        
        list<user> listUser = new list<user>() ;
                   
        User testUsr1 = AdminUser('standt1'); 
        listUser.add(testUsr1 );
        //insert testUsr1;
        User testUsr2 = AdminUser('standt2'); 
           listUser.add(testUsr2 );

        //insert testUsr2;
        User testUsr3 = AdminUser('standt3'); 
        //insert testUsr3;
           listUser.add(testUsr3 );
           insert(listUser);

     /* end of admin user - recode to avoid governor limit error - RLC March 26, 2014*/


/***********************/
        //create PPOC
        User pocUser = new User();
        pocUser = testData.createUser(RFATestData.rfaStandardUserProfile, 'ppoc', 'ppoc', pocUser);
        RFAUserRole__c ppocUserRole = RFATestData.buildPPOC(testRFA.Id, pocUser);
        insert ppocUserRole;
/***********************/
        RFATestData.updateThreeYearCashSpentForRFA(testRFA,Double.valueof('99.0'));
        testRFA.Stage__c = 'Pre-Circulation';
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
        
        RFA_WS03_KOApprove_getRFADetails.StatusMessageWrapper message=new RFA_WS03_KOApprove_getRFADetails.StatusMessageWrapper();
        RFA_WS03_KOApprove_getRFADetails.PreviousApproval pre=new RFA_WS03_KOApprove_getRFADetails.PreviousApproval('e','e','e',system.today(),'e','e');
        RFA_WS03_KOApprove_getRFADetails.ReportingUnits unti=new RFA_WS03_KOApprove_getRFADetails.ReportingUnits(); 
        message.code='Success';
        RFA_WS03_KOApprove_getRFADetails.statusMessageWrapper message1=new RFA_WS03_KOApprove_getRFADetails.statusMessageWrapper('d','d');//Message class instance
        
        System.runAs(RFATestData.requester)
        {
                try{
                RFA_WS03_KOApprove_getRFADetails.getDetails(testRFA.id,null);
                RFA_WS03_KOApprove_getRFADetails.getDetails(null,null);
                }catch(Exception e)
                {
                                
                }
        
                RFA_WS03_KOApprove_getRFADetails.getDetails(testRFA.id,'standt1@coke.com');
         
        }
        /*
        RFAUserRole__c rfaUser = new RFAUserRole__c(level__C='1. Key Operations', RFA__c = testRFA.Id, ApprovalRecommendation__c='Awaiting Approval', UserName__c = userinfo.getUserId(),
                                                    Agent1__c = testUsr1.Id, Agent2__c = testUsr2.Id, Agent3__c = testUsr3.Id,recordTypeId=rt2);
        insert rfaUser;*/
        RFAUserRole__c approver1 = RFATestData.buildApprover(testRFA.Id, testRFA.level__c);
        approver1.UserName__c = UserInfo.getUserId();
        approver1.Agent1__c = testUsr1.Id;
        approver1.Agent2__c = testUsr2.Id;
        approver1.Agent3__c = testUsr3.Id;
        insert approver1;
        
        RFAUserRole__c approver2 = RFATestData.buildApprover(testRFA.Id, testRFA.level__c);
        approver2.UserName__c = UserInfo.getUserId();
        approver2.Agent1__c = testUsr1.Id;
        insert approver2;
        
        ApprovalProcess__c testProcess = new ApprovalProcess__c();
        Database.UpsertResult upsertResult = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
        if(upsertResult.isSuccess())
        {
            approver1.ApprovalProcess__c = upsertResult.getId();
            approver1.ApprovalOrder__c = 1;
            approver1.ApprovalRecommendation__c = 'Awaiting Approval';
            update approver1;
            
            approver2.ApprovalProcess__c = upsertResult.getId();
            approver2.ApprovalOrder__c = 1;
            approver2.ApprovalRecommendation__c = 'Awaiting Approval';
            update approver2;       
        }
        /*
        RFAUserRole__c rfaUser1 = new RFAUserRole__c( RFA__c = testRFA.Id, ApprovalRecommendation__c='Rejected', UserName__c = userinfo.getUserId(),
                                                    Agent1__c = testUsr1.Id,ApprovalComments__c='test',recordTypeId=rt2);
        insert rfaUser1;*/
        
        /*
        ApprovalProcess__c ap=new ApprovalProcess__c(ApprovalProcessLevel__c='1. Key Operations',ApprovalProcessRouting__c='Parallel',RFA__c=testRfa.Id,Status__c='In Progress');
        insert ap;*/
        /*
        rfaUser.ApprovalProcess__c=ap.Id;
        update rfaUser;
        rfaUser1.ApprovalProcess__c=ap.Id;
        update rfaUser1;*/
        RFAUserRole__c rfaUser2 = new RFAUserRole__c( RFA__c = testRFA.Id, UserName__c = userinfo.getUserId(),RecordTypeId=rt1);
        insert rfaUser2;
        
        
       // RFAUserRole__c rfaUser3 = new RFAUserRole__c( RFA__c = testRFA.Id, ApprovalRecommendation__c='Rejected', UserName__c = userinfo.getUserId(),
          //                                          Agent1__c = testUsr1.Id,ApprovalComments__c='test');
        //insert rfaUser2;
        
        Attachment attRec = new Attachment(ParentId = testRFA.Id, Name = 'Test Attachment', body = blob.valueOf('Test Body'));
        insert attRec;
        System.runAs(testUsr1)
        {
            RFA_WS03_KOApprove_getRFADetails.getDetails(testRFA.id,'standt1@coke.com');
        }   
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