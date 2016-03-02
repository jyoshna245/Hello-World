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
@isTest(SeeAllData=true )
private class RFA_VCC04_CapitalExpCompCntrlSTDtest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        String rt = RFATestData.getRecordType('Capital Project Request', 'RFA__c');
        
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =  rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        Capital_Expenditure__c CapEx = new Capital_Expenditure__c();
        CapEx.Amount__c = 1234567;
        CapEx.RFA__c = testRFA.Id;
        insert CapEx;
        
        PageReference pg = Page.RFA_VFP01_CapitalExpenditure;
        Test.setCurrentPage(pg);   
        RFA_VCC04_CapitalExpComponentContrlSTD   cnrt=new RFA_VCC04_CapitalExpComponentContrlSTD     ();
        cnrt.setRecordRFAId(testRFA.id);
        cnrt.getRFA_Capital_CreationMethod();
        cnrt.capitalExpenditureList.add(CapEx);
        cnrt.performEdit();
        cnrt.performCancel();
        cnrt.performSave();
        
        //ISBillingExtension ib = new ISBillingExtension(mc);    
    }
    
     static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        String rt = RFATestData.getRecordType('Small Project Request', 'RFA__c');
        
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =  rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        Capital_Expenditure__c CapEx = new Capital_Expenditure__c();
        CapEx.Amount__c = 1234567;
        CapEx.RFA__c = testRFA.Id;
        insert CapEx;
        
        PageReference pg = Page.RFA_VFP01_CapitalExpenditure;
        Test.setCurrentPage(pg);   
        RFA_VCC04_CapitalExpComponentContrlSTD   cnrt=new RFA_VCC04_CapitalExpComponentContrlSTD     ();
        cnrt.setRecordRFAId(testRFA.id);
        cnrt.getRFA_Capital_CreationMethod();
        cnrt.capitalExpenditureList.add(CapEx);
        cnrt.performEdit();
        cnrt.performCancel();
        cnrt.performSave();
        
        //ISBillingExtension ib = new ISBillingExtension(mc);    
    }

    
    
    
}