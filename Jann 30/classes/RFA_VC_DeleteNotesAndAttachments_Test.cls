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
private class RFA_VC_DeleteNotesAndAttachments_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        RFATestData rtTest = new RFATestData();
        rtTest.buildProfitCenter();
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        Note n=new Note();
        n.Body='Test Note';
        n.Title='Test Title';
        n.ParentId=testRFA.id;
        
        insert n;

        Blob myBIGblob=Blob.toPdf('TEST STRING');
        Attachment att=new Attachment();
        att.Body=myBIGblob;
        att.Name='AttachmentTest';
        att.ParentId=testRFA.id;
        
        insert att;

         PageReference pageRef = Page.RFA_VFP_DeleteNotesAndAttachments;
         Test.setCurrentPage(pageRef);
       
       ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFA);
       RFA_VC_DeleteNotesAndAttachments controllerObj = new RFA_VC_DeleteNotesAndAttachments(stdController1);
       RFA_VC_DeleteNotesAndAttachments.RFAAttachments obj=new RFA_VC_DeleteNotesAndAttachments.RFAAttachments();
       
       RFA_VC_DeleteNotesAndAttachments.RFAAttachments obj1=new RFA_VC_DeleteNotesAndAttachments.RFAAttachments(att,true);
       RFA_VC_DeleteNotesAndAttachments.RFAAttachments obj2=new RFA_VC_DeleteNotesAndAttachments.RFAAttachments(n,true);
       
       controllerObj.getAttachmentList();
       controllerObj.getListCount();
       controllerObj.deleteAttachment();
       
        
   
       
       
       
    }
}