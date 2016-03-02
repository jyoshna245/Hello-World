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
private class RFA_RF1_50_LocationCoordinator_V2_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
 

        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        RFATestData rtTest = new RFATestData();
         rtTest.buildProfitCenter();
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        insert testRFA;

         PageReference pageRef = Page.RFA_RF1_50_LocationCoordinator_V2;
         Test.setCurrentPage(pageRef);
       
       ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFA);
       RFA_RF1_50_LocationCoordinator_V2 controller1 = new RFA_RF1_50_LocationCoordinator_V2(stdController1);
       controller1.empty();
       controller1.Beginning();
       controller1.Previous();
       controller1.Next();
       controller1.End();
       controller1.getDisablePrevious();
       controller1.getDisableNext();
       controller1.getTotal_size();
       controller1.getPageNumber();
       controller1.getTotalPages();
       List<SObject> testList = new List<SObject>();
       controller1.sortBy = 'Level__c';
       controller1.sortDir  = 'ASC';
       controller1.sortList(testList );

    }
}