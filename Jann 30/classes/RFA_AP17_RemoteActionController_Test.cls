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
private class RFA_AP17_RemoteActionController_Test {

    static testMethod void sendRFAToKeyOpsCoordinator() {
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFATestData.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Draft';
            testRFA.RequestAmountFunctionalCurrency__c = 1200;      
            testRFA.Functional_Currency__c = RFATestData.testARE.Id;
            //testRFA.Stage__c = 'Pre-Circulation';
            testRFA.Level__c = 'Draft';
            testRFA.DataClassification__c = 'Internal Use';
            testRFA.AREMonth__c = 'February';
            testRFA.InitialBudgetYear__c = '2013';
            testRFA.BudgetType__c = 'Formal';
            testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA;
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Key Operations Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('1. Key Operations', validateRFA.Level__c);
        
    }
  
    static testMethod void sendRFAToBusinessUnitCoordinator() {
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFATestData.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
            testRFA.RequestAmountFunctionalCurrency__c = 1200;      
            testRFA.Functional_Currency__c = RFATestData.testARE.Id;
            //testRFA.Stage__c = 'Pre-Circulation';
            testRFA.Level__c = 'Draft';
            testRFA.DataClassification__c = 'Internal Use';
            testRFA.AREMonth__c = 'February';
            testRFA.InitialBudgetYear__c = '2013';
            testRFA.BudgetType__c = 'Formal';
            testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA;
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Business Unit Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('2. Business Unit', validateRFA.Level__c);
        
    }
    
    static testMethod void sendRFAToGroupCoordinator() {
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFATestData.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
            testRFA.RequestAmountFunctionalCurrency__c = 1200;      
            testRFA.Functional_Currency__c = RFATestData.testARE.Id;
            //testRFA.Stage__c = 'Pre-Circulation';
            testRFA.Level__c = 'Draft';
            testRFA.DataClassification__c = 'Internal Use';
            testRFA.AREMonth__c = 'February';
            testRFA.InitialBudgetYear__c = '2013';
            testRFA.BudgetType__c = 'Formal';
            testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA;
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Group Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('3. Group', validateRFA.Level__c);
        
    }
    
    static testMethod void sendRFAToCorpCoordinator() {
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFATestData.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
            testRFA.RequestAmountFunctionalCurrency__c = 1200;      
            testRFA.Functional_Currency__c = RFATestData.testARE.Id;
            //testRFA.Stage__c = 'Pre-Circulation';
            testRFA.Level__c = 'Draft';
            testRFA.DataClassification__c = 'Internal Use';
            testRFA.AREMonth__c = 'February';
            testRFA.InitialBudgetYear__c = '2013';
            testRFA.BudgetType__c = 'Formal';
            testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA;
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Corporate Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('4. Corporate', validateRFA.Level__c);
        
    }
    
    static testMethod void sendRFAToExecCoordinator() {
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFATestData.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
            testRFA.RequestAmountFunctionalCurrency__c = 1200;      
            testRFA.Functional_Currency__c = RFATestData.testARE.Id;
            //testRFA.Stage__c = 'Pre-Circulation';
            testRFA.Level__c = 'Draft';
            testRFA.DataClassification__c = 'Internal Use';
            testRFA.AREMonth__c = 'February';
            testRFA.InitialBudgetYear__c = '2013';
            testRFA.BudgetType__c = 'Formal';
            testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA;
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Executive Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('5. Executive', validateRFA.Level__c);
        
    }
    
    static testMethod void sendRFAToSrExecCoordinator() {
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFATestData.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
            testRFA.RequestAmountFunctionalCurrency__c = 1200;      
            testRFA.Functional_Currency__c = RFATestData.testARE.Id;
            //testRFA.Stage__c = 'Pre-Circulation';
            testRFA.Level__c = 'Draft';
            testRFA.DataClassification__c = 'Internal Use';
            testRFA.AREMonth__c = 'February';
            testRFA.InitialBudgetYear__c = '2013';
            testRFA.BudgetType__c = 'Formal';
            testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA;
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Senior Executive Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('6. Senior Executive', validateRFA.Level__c); 
        
    }
}