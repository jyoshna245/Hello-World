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
private class RFA_VFC04_CompletionMemoController_Test
{

    static testmethod void RFA_VFC04_Completion_Test()
    {
    
    	RFATestData testData = new RFATestData();
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;    	
    	RFA__c testRFA;
    	    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);    		
    	}
    	ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFA);
    	RFA_VFC04_CompletionMemoController controller1 = new RFA_VFC04_CompletionMemoController(stdController1);
    	List<SelectOption> options = controller1.getSelectableUsers();
    	controller1.selectedRecipients.add(options[0]);
    	controller1.selectedCCusers = 'test@coke.com';
    	controller1.rfaObj.Thefollowingitem__c = 'Key Operation level for approval and/or for information only as required';
    	controller1.rfaObj.Theapprovalstatusofyourrequestis__c = 'Unconditionally Approved';
    	controller1.rfaObj.CommentsConditions__c = 'This is for the purpose of testing';
    	controller1.rfaObj.ApprovalLetterComments__c = 'The requesting party must ensure appropriate coordination with the above approver(s) to fully address any and all approval conditions. Any failure to fully address these conditions will be subject to Audit review.';
    	controller1.sendEmail();
    
    }

}