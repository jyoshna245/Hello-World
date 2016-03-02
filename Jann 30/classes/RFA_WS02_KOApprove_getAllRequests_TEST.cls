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
private class  RFA_WS02_KOApprove_getAllRequests_TEST 
{
    static testmethod void RFA_AP01_Test()
     {      
        test.StartTest();
        User testUsr1 = AdminUser('standt1'); 
        insert testUsr1;
        User testUsr2 = AdminUser('standt2'); 
        insert testUsr2;
        User testUsr3 = AdminUser('standt3'); 
        insert testUsr3;
        RFATestData testData = new RFATestData();
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFATestData.getRecordType('Capital Project Request', 'RFA__c');
    	
    	System.runAs(RFATestData.requester)
    	{
    	
    	RFA_WS02_KOApprove_getAllRequests.getAllRFADetails();
    	
    
    	RFA_WS02_KOApprove_getAllRequests.statusMessageWrapper message=new RFA_WS02_KOApprove_getAllRequests.statusMessageWrapper('d','d');//Message class instance
    	RFA_WS02_KOApprove_getAllRequests.rfaFinalWrapper finalWrapper=new RFA_WS02_KOApprove_getAllRequests.rfaFinalWrapper();
    	RFA_WS02_KOApprove_getAllRequests.rfaDataContainer dataContainer=new RFA_WS02_KOApprove_getAllRequests.rfaDataContainer();
    	RFA_WS02_KOApprove_getAllRequests.rfaWrappersForAllRequests allRequests=new RFA_WS02_KOApprove_getAllRequests.rfaWrappersForAllRequests(); 
    	}
    	RFA__c testRFA = new RFA__c();
    	/*testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
    	testRFA.RecordTypeId = 	rt;
    	testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
    	testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
    	testRFA.Stage__c = 'Draft';
    	insert testRFA;*/
    	//testRFA = new RFA__c(ProfitCenterNumber__c = RFATestData.testProfitCenter.Id, RequestTitle__c = 'Capital Project Request RFA Title', 
           //                 PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id, Stage__c = 'Draft');      
        //insert testRFA;
        
        /*
        RFAUserRole__c rfaUser = new RFAUserRole__c( RFA__c = testRFA.Id, ApprovalRecommendation__c='Awaiting Approval', UserName__c = userinfo.getUserId(),
                                                    Agent1__c = testUsr1.Id, Agent2__c = testUsr2.Id, Agent3__c = testUsr3.Id);
        insert rfaUser;*/
        
        testRFA = RFATestData.buildTestRFA(testRFA, rt);
        
        User approverUser = new User();
		approverUser = testData.createUser(RFATestData.rfaStandardUserProfile, 'app1', 'app1', approverUser);
		RFAUserRole__c approver = RFATestData.buildApprover(testRFA.Id, approverUser, testRFA.level__c);
		insert approver;
        ApprovalProcess__c testProcess = new ApprovalProcess__c();
		Database.UpsertResult upsertResult = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
		if(upsertResult.isSuccess())
		{
			approver.ApprovalProcess__c = upsertResult.getId();
			approver.ApprovalOrder__c = 1;
			approver.ApprovalRecommendation__c = 'Awaiting Approval';
			update approver;	
		}
        Attachment attRec = new Attachment(ParentId = testRFA.Id, Name = 'Test Attachment', body = blob.valueOf('Test Body'));
        insert attRec;
        
        RFA_WS02_KOApprove_getAllRequests.getAllRFADetails();
        test.stopTest();
    	
     }
     
     public static User AdminUser(String alias){
        Profile profile = [select id from profile where name='System Administrator'];
        User user = new User(alias = alias, email=alias + '@bel.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profile.Id,FederationIdentifier=alias + '@bel.com',
            timezonesidkey='Europe/London', username=alias + '@bel.com');
        return user;
    }
}