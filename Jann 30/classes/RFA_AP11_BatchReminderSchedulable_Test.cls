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
private class RFA_AP11_BatchReminderSchedulable_Test {

    static testMethod void testBatchReminder() {
    	// TO DO: implement unit test
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
    	RFATestData testData = new RFATestData();
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);
    		
    		
    	}
    	User approver1 = new User();
    	approver1 = testData.createUser(RFATestData.rfaStandardUserProfile, 'app1', 'app1', approver1);
    	
    	User approver2 = new User();
    	approver2 = testData.createUser(RFATestData.rfaStandardUserProfile, 'app2', 'app2', approver2);
    	
    	RFAUserRole__c rfaApprover1 = RFATestData.buildApprover(testRFA.Id, approver1, '1. Key Operations');
    	RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2, '1. Key Operations');
    	approverLevelMap.put('1. Key Operations', new List<RFAUserRole__c>{rfaApprover1, rfaApprover2});
    	insert approverlevelMap.get('1. Key Operations');
    	
    	System.runAs(RFATestData.levelLCUserMap.get('1. Key Operations'))
    	{
    		Map<String, String> urlParams = new Map<String, String>
    		{
    			'Id' => testRFA.Id
    		};
    		Test.setCurrentPageReference(getPageReference('RFA_VFP03_ApprovalRouting', urlParams));
    		ApexPages.standardController stdController = new ApexPages.Standardcontroller(testRFA);
    		RFA_VFC02_ApprovalRoutingController controller = new RFA_VFC02_ApprovalRoutingController(stdController);
  
    		controller.sequenceList[0].sequence = 1;
    		controller.sequenceList[1].sequence = 1;
    		controller.submitForApproval();
    	}
    	
    	Test.StartTest();
    	
    	
    	
    	String jobId = System.schedule('testBatchReminderApex',
        RFA_AP11_BatchReminderSchedulable.CRON_EXP, 
        new RFA_AP11_BatchReminderSchedulable());
        
        
    	String queryString = 'Select Agent1__c, Agent2__c, Agent3__c, UserName__c, RFA__c, ApprovalProcess__c FROM RFAUserRole__c WHERE' + ' ';
    	queryString = queryString + 'RecordType.Name=' +'\'' + RFAGlobalConstants.APPROVER_RECORDTYPE + '\'';
    	queryString = queryString + ' ' + 'AND ApprovalRecommendation__c=' + '\'' + RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION + '\'';
    	queryString = queryString + ' ' + 'ORDER BY UserName__c LIMIT 20';	
    	
    	RFA_AP10_BatchReminder batchReminder = new RFA_AP10_BatchReminder(queryString);
    	database.executebatch(batchReminder);              
    	
    	Test.stopTest();
    }
    
    static PageReference getPageReference(String page, Map<String, String> params) {
        String url = '/apex/'+page+'?';
        for (String param : params.keySet()) {
            url += param + '=' + params.get(param) + '&';
        }
        PageReference p = new PageReference(url);
        return p;
    }
}