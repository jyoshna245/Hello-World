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
public class RFA_WS04_PDFGeneratorCM_Test {
    static testMethod void myUnitTest() {
        RFATestData testData = new RFATestData();
        String rt = RFATestData.getRecordType('General Request', 'RFA__c');
        RFA__c testRFA = new RFA__c();
        testRFA.RequestTitle__c = 'testtitle';
        testRFA.DataClassification__c = 'Restricted';
        //testRFA.RequestAmountFunctionalCurrency__c = '10';
        //testRFA.Functional_Currency__c = '100';
        testRFA.AREMonth__c = 'January';
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =   rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        try{
            insert testRFA;
           }
        catch(System.DMLException e) {}


        /* POC */
        User testUserPOC = new User();
        testUserPOC = testData.createUser(RFATestData.rfaStandardUserProfile, 'ppoc', 'ppoc', testUserPOC);
        String utPOC = RFATestData.getRecordType('Primary Point of Contact', 'RFAUserRole__c');
        RFAUserRole__c TestURPOC = new RFAUserRole__c();
        TestURPOC.UserName__c = testUserPOC.id;
        TestURPOC.RecordTypeId =   utPOC;
        TestURPOC.RFA__c = testRFA.id;
        insert TestURPOC; 

        /* Co-Creater */
        User testUserCOC = new User();
        testUserCOC = testData.createUser(RFATestData.rfaStandardUserProfile, 'Co-Cre', 'Co-Cre', testUserCOC);
        String utCOC = RFATestData.getRecordType('Co-Creator', 'RFAUserRole__c');
        RFAUserRole__c TestURCOC = new RFAUserRole__c();
        TestURCOC.UserName__c = testUserCOC.id;
        TestURCOC.RecordTypeId =   utCOC;
        TestURCOC.RFA__c = testRFA.id;
        insert TestURCOC; 
        
        /* Approver */
        User testUserApprover = new User();
        testUserApprover = testData.createUser(RFATestData.rfaStandardUserProfile, 'Approver', 'Approver', testUserApprover);
        String utApp = RFATestData.getRecordType('Approver', 'RFAUserRole__c');
        RFAUserRole__c TestURApp = new RFAUserRole__c();
        TestURApp.UserName__c = testUserApprover.id;
        TestURApp.RecordTypeId =   utApp;
        TestURApp.Agent1__c = testUserCOC.id;
        TestURApp.RFA__c = testRFA.id;
        insert TestURApp; 
        
        /* LOC */
        ProfitCenter__c testProfitCenter = new ProfitCenter__c();
        testProfitCenter.Business_Unit_Name__c = 'Coca-Cola USA Industries';
        testProfitCenter.GroupName__c = 'Bottling Investments';
        testProfitCenter.KeyOperationName__c = 'Coca Cola NA';
        testProfitCenter.ProfitCenterName__c = 'Test Coke PC';
        testProfitCenter.ActiveInactive__c = 'Active';
        insert testProfitCenter;
        
        User testUserLOCA = new User();
        testUserLOCA = testData.createUser(RFATestData.rfaStandardUserProfile, 'LOC', 'LOC', testUserCOC);
        
        ProfitCenterUserRole__c PCUR = new ProfitCenterUserRole__c();
        PCUR.Level__c = '1. Key Operations';
        PCUR.ProfitCenter__c = testProfitCenter.id;
        PCUR.UserName__c = testUserLOCA.Id;
        PCUR.UserType__c = 'Location Coordinator';
        insert PCUR;
        
        testRFA.ToEmailAddressCM__c = 'bisht Sanjeev';
        testRFA.CCEmailAddressCM__c = 'bisht Sanjeev';
        testRFA.POC_Name__c = TestURPOC.UserName__r.Name;
        testRFA.CO_CREATOR_Name__c = TestURCOC.UserName__r.Name;
        testRFA.Approver_Name__c = TestURApp.UserName__r.Name;
        testRFA.Agents_Name__c = TestURApp.Agent1__c;
        testRFA.LOC_Name__c = PCUR.UserName__r.Name;
        
        testRFA.Thefollowingitem__c = 'Key operation level for Approval and/or for information as requied';
        testRFA.Theapprovalstatusofyourrequestis__c = 'Conditionally Approved';
        testRFA.ApprovalLetterComments__c = 'Not Applicable';
        testRFA.CommentsConditions__c = 'Test';
    
        try{
            update testRFA;
           }
        catch(System.DMLException e) {}
        
        }
    static testMethod void testAttachments()
        {
            RFA__c testRFA = new RFA__c();
            insert testRFA;
     
            Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=testRFA.id;
            insert attach;
            
            List<Attachment> attachments=[select id, name from Attachment where parent.id=:testRFA.id];
            System.assertEquals(1, attachments.size());
        }
}