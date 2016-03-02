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
private class RFA_BC02_ReportingRealignmentFix_test {

    static testMethod void myUnitTest() {
        DateTime createdDateValue = DateTime.now(); //DateTime variable
       String createdDate_Formatted_Date = createdDateValue.format('yyyy-MM-dd'); //date portion of the createdDateValue variable formatted as Strting
       String createdDate_Formatted_Time = createdDateValue.format('HH:mm:ss'); //time portion of the createdDateValue variable formatted as Strting
      String createdDate_Formatted_Zone = createdDateValue.format('Z'); //timezone offset of the createdDateValue variable formatted as Strting
      String finalDateTimeValue = createdDate_Formatted_Date+'T'+createdDate_Formatted_Time+createdDate_Formatted_Zone.substring(0, createdDate_Formatted_Zone.length()-2)+':00';
      SchedulableContext sc;
      RFATestData testData = new RFATestData();
       testData.buildProfitCenter();
    
      
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
      testRFA.RecordTypeId =   rt;
      
      testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
      //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
      testRFA.Stage__c = 'Draft';
      
      testRFA.PrimaryReportingUnitNumber__c=testReportingUnit.Id;
      testRFA.SecondReportingUnitNumber__c=testReportingUnit1.Id;
      testRFA.ThirdReportingUnitNumber__c=testReportingUnit2.Id;
      insert testRFA;
      
      system.debug('testRFA Primary = '+testRFA.PrimaryReportingUnitNumber__c);
      system.debug('testRFA Second = '+testRFA.SecondReportingUnitNumber__c);
      system.debug('testRFA Third = '+testRFA.ThirdReportingUnitNumber__c);
/***********************/
        //create PPOC
        User pocUser = new User();
        pocUser = testData.createUser(RFATestData.rfaStandardUserProfile, 'ppoc', 'ppoc', pocUser);
        RFAUserRole__c ppocUserRole = RFATestData.buildPPOC(testRFA.Id, pocUser);
        insert ppocUserRole;
/***********************/
      testReportingUnit1.NeedRecalculation__c=true;
      update testReportingUnit1;
      
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
      testRFA.PrimaryDOACategorySubCategory__c = '1.A.1  Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
      testRFA.Functional_Currency__c = RFATestData.testARE.Id;
        update testRFA;
        
          
    Test.startTest();
    Set<id> reportingUnitIds = new Set<Id>(); 
        List<ReportingUnit__c> reportingUnitList = [Select Id ,name from ReportingUnit__c where NeedRecalculation__c=true and ActiveInactive__c='Active'];
        for(ReportingUnit__c reportingUnitObj : reportingUnitList)
            reportingUnitIds.add(reportingUnitObj.Id);
        system.debug('Reporting Unit Ids = '+reportingUnitIds);
        String Query = 'Select PrimaryReportingUnitNumber__c,SecondReportingUnitNumber__c,ThirdReportingUnitNumber__c,id,Level__c, PreviousLevel__c from RFA__c where ' 
          +'PrimaryReportingUnitNumber__c IN :reportingUnitIds OR SecondReportingUnitNumber__c IN :reportingUnitIds OR ThirdReportingUnitNumber__c IN :reportingUnitIds '
          +'ORDER BY CreatedDate DESC';
         // RFA__c RFAObj = [Select PrimaryReportingUnitNumber__c,SecondReportingUnitNumber__c,ThirdReportingUnitNumber__c,id,Level__c, PreviousLevel__c from RFA__c where PrimaryReportingUnitNumber__c IN :reportingUnitIds OR SecondReportingUnitNumber__c IN :reportingUnitIds OR ThirdReportingUnitNumber__c IN :reportingUnitIds ORDER BY CreatedDate DESC];
        //  system.debug('RFA = '+RFAObj);
    RFA_BC02_ReportingUnitRealignmentFix testJob=new RFA_BC02_ReportingUnitRealignmentFix();
    testJob.execute(sc);
    RFA_AP20_ReportingUnitRealignmentFix job = new RFA_AP20_ReportingUnitRealignmentFix(Query,reportingUnitIds);
    ID batchprocessid = Database.executeBatch(job,100);
  Test.stopTest();
    }
}