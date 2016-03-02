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
private class RFA_VCC07_RFA_History_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        String rt = RFATestData.getRecordType('Capital Project Request', 'RFA__c');
        
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =  rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        testRFA.Approver_Name__c = 'test';
        update testRFA;
        
        RFA__History RfaHist = new RFA__History();
        
        Capital_Expenditure__c CapEx = new Capital_Expenditure__c();
        CapEx.Amount__c = 1234567;
        CapEx.RFA__c = testRFA.Id;
        insert CapEx;
        
        PageReference pg = Page.RFA_VFP07_DetailsAsPDF;
        Test.setCurrentPage(pg);   
        ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFA);
        RFA_VCC07_RFA_History  cnrt=new RFA_VCC07_RFA_History();
        RFA_VCC07_RFA_History.RFAObjectHistory InnerClass = new RFA_VCC07_RFA_History.RFAObjectHistory(RfaHist );
        RFA_VCC07_RFA_History.RFAObjectHistory InnerClass2 = new RFA_VCC07_RFA_History.RFAObjectHistory();
        cnrt.getRFAObjectHistory(testRFA.Id);
        cnrt.showMore();
        InnerClass.getActionFormat();
       // InnerClass.RFAObjectHistory();
    }
    
}