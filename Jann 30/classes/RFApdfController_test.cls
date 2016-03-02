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

@IsTest(seeAllData=false)
Public class RFApdfController_test{
        
    static testmethod void generatePDF()
    {           
    
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        insert testRFA;
         
        PageReference pageRef = new PageReference(testRFA.id);
        
        System.currentPageReference().getParameters().put('id', testRFA.id); 
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(testRFA); 
        RFApdfController controller  = new RFApdfController(stdController);               
        
    }

}