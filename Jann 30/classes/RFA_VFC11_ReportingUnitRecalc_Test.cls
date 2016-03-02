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
private class RFA_VFC11_ReportingUnitRecalc_Test {

    static testMethod void myUnitTest() {
    	RFATestData testData = new RFATestData();
    	RFA__c testRFA = new RFA__c();
    	
    	testData.buildProfitCenter();
    	
    	testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
		testRFA.RecordTypeId = 	RFATestData.getRecordType('General Request', 'RFA__c'); 
		testRFA.RequestTitle__c = 'General Request RFA Title';
		testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
		testRFA.SecondReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
		testRFA.ThirdReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
		testRFA.Stage__c = 'Draft';
		
		insert testRFA;
    	
    	PageReference pg = Page.RFA_RF1_10_ReportingUnitRecalculation;
    	Test.setCurrentPage(pg);
 		pg.getParameters().put('id', RFATestData.testReportingUnit.Id);
 		ApexPages.StandardController sc = new ApexPages.StandardController(RFATestData.testReportingUnit);
     	RFA_VFC11_ReportingUnitRecalculation control=new RFA_VFC11_ReportingUnitRecalculation(sc);
    	control.callRecalculationMethod();
    }
}