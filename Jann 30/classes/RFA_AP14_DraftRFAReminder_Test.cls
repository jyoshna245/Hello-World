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
private class RFA_AP14_DraftRFAReminder_Test {

    static testMethod void testDraftReminder() {
        RFATestData testData = new RFATestData();
        testData.createRequester();
        testData.buildProfitCenter();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        
        System.runAs(RFATestData.requester)
        {
            RFA__c testRFA1 = new RFA__c();
            testRFA1.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA1.RecordTypeId =     rt;
            testRFA1.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA1.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA1.Stage__c = 'Draft';
            testRFA1.RequestAmountFunctionalCurrency__c = 1200;     
            testRFA1.Functional_Currency__c = RFATestData.testARE.Id;
            testRFA1.Stage__c = 'Pre-Circulation';
            testRFA1.Level__c = 'Draft';
            testRFA1.DataClassification__c = 'Internal Use';
            testRFA1.AREMonth__c = 'February';
            testRFA1.InitialBudgetYear__c = '2013';
            testRFA1.BudgetType__c = 'Formal';
            testRFA1.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA1.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA1.PrimaryDOACategorySubCategory__c = '1.A.1  Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA1;
            
            RFA__c testRFA2 = new RFA__c();
            testRFA2.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA2.RecordTypeId =     rt;
            testRFA2.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA2.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA2.Stage__c = 'Draft';
            testRFA2.RequestAmountFunctionalCurrency__c = 1200;     
            testRFA2.Functional_Currency__c = RFATestData.testARE.Id;
            testRFA2.Stage__c = 'Pre-Circulation';
            testRFA2.Level__c = 'Draft';
            testRFA2.DataClassification__c = 'Internal Use';
            testRFA2.AREMonth__c = 'February';
            testRFA2.InitialBudgetYear__c = '2013';
            testRFA2.BudgetType__c = 'Formal';
            testRFA2.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA2.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA2.PrimaryDOACategorySubCategory__c = '1.A.1  Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA2;
            
            RFA__c testRFA3 = new RFA__c();
            testRFA3.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA3.RecordTypeId =     rt;
            testRFA3.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA3.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA3.Stage__c = 'Draft';
            testRFA3.RequestAmountFunctionalCurrency__c = 1200;     
            testRFA3.Functional_Currency__c = RFATestData.testARE.Id;
            testRFA3.Stage__c = 'Pre-Circulation';
            testRFA3.Level__c = 'Draft';
            testRFA3.DataClassification__c = 'Internal Use';
            testRFA3.AREMonth__c = 'February';
            testRFA3.InitialBudgetYear__c = '2013';
            testRFA3.BudgetType__c = 'Formal';
            testRFA3.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA3.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA3.PrimaryDOACategorySubCategory__c = '1.A.1  Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA3;
            
            RFA__c testRFA4 = new RFA__c();
            testRFA4.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA4.RecordTypeId =     rt;
            testRFA4.RequestTitle__c = 'Capital Project Request RFA Title';
            testRFA4.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA4.Stage__c = 'Draft';
            testRFA4.RequestAmountFunctionalCurrency__c = 1200;     
            testRFA4.Functional_Currency__c = RFATestData.testARE.Id;
            testRFA4.Stage__c = 'Pre-Circulation';
            testRFA4.Level__c = 'Draft';
            testRFA4.DataClassification__c = 'Internal Use';
            testRFA4.AREMonth__c = 'February';
            testRFA4.InitialBudgetYear__c = '2013';
            testRFA4.BudgetType__c = 'Formal';
            testRFA4.IsthisanAnnualCapitalPlanrequest__c = 'No';
            testRFA4.ExecutiveSummary__c = 'This is for the purpose of testing';
            testRFA4.PrimaryDOACategorySubCategory__c = '1.A.1  Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA4;
        }
        
        String jobId = System.schedule('testDraftBatchReminderApex',
        RFA_AP14_DraftRFAReminderSchedulable.CRON_EXP,  
        new RFA_AP14_DraftRFAReminderSchedulable());
        
        String baseQuery = 'Select ProfitCenterNumber__c, Id, CreatedById, ControlNumber__c, Stage__c, RequestTitle__c FROM RFA__c WHERE';
        //baseQuery = baseQuery + ' ' + 'createdDate < NEXT_N_DAYS:1';
        baseQuery = baseQuery + ' ' + 'Stage__c =' + '\'' + RFAGlobalConstants.RFA_STAGE_DRAFT + '\'';  
        baseQuery = baseQuery + ' ' + ' ' + 'ORDER BY CreatedById LIMIT 20';
        
        RFA_AP15_RFADraftReminderBatchable draftBatchReminder = new RFA_AP15_RFADraftReminderBatchable(baseQuery);
        //execute batch
        database.executebatch(draftBatchReminder); 
    }
}