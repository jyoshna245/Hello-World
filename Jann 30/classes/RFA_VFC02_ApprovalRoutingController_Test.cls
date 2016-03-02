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
private class RFA_VFC02_ApprovalRoutingController_Test {

    static testMethod void testSubmitForApproval() {
        // TO DO: implement unit test
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();
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
        Test.startTest();
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
         RFAUserRole__c[] validateUserRole = [Select UserName__c, ApprovalRecommendation__c, Level__c, RFA__r.Level__c, RFA__r.Stage__c 
                                              FROM RFAUserRole__c 
                                              WHERE RFA__c =: testRFA.Id 
                                              AND RecordTypeId =: RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id];
         
         System.assertEquals('1. Key Operations', validateUserRole[0].RFA__r.Level__c);
         System.debug('\n RFA Stage :'+validateUserRole[0].RFA__r.Stage__c);
         System.assertEquals('Circulation', validateUserRole[0].RFA__r.Stage__c);
                                              
         for(RFAUserRole__c approver : validateUserRole)
         {
            System.assertEquals('Awaiting Approval', approver.ApprovalRecommendation__c);
         }  
         Test.stopTest();
    }
    
     static testMethod void testSubmitForApprovalnegativeCase() {
        // TO DO: implement unit test
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        
        RFA__c testRFA;
        Test.startTest();
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
            
                    
            controller.sequenceList[0].sequence = 0;
            controller.sequenceList[1].sequence = 1;
            controller.submitForApproval();
        }
         RFAUserRole__c[] validateUserRole = [Select UserName__c, ApprovalRecommendation__c, Level__c, RFA__r.Level__c, RFA__r.Stage__c 
                                              FROM RFAUserRole__c 
                                              WHERE RFA__c =: testRFA.Id 
                                              AND RecordTypeId =: RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id];
         
         //System.assertEquals('1. Key Operations', validateUserRole[0].RFA__r.Level__c);
         System.debug('\n RFA Stage :'+validateUserRole[0].RFA__r.Stage__c);
         //System.assertEquals('Pre-Circulation', validateUserRole[0].RFA__r.Stage__c);
         Test.stopTest();
     } 
     
     static testMethod void testSubmitForApprovalnegativeCase2() {
        // TO DO: implement unit test
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        
        RFA__c testRFA;
        Test.startTest();
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
            
            
        //*********************** Negative Test Case ************************//
                RFATestData.updateCapitalExpenditure(testRFA, 200);
            
            //*******************************************************************//
                    
            controller.sequenceList[0].sequence = 1;
            controller.sequenceList[1].sequence = 1;
            controller.submitForApproval();
        }
         RFAUserRole__c[] validateUserRole = [Select UserName__c, ApprovalRecommendation__c, Level__c, RFA__r.Level__c, RFA__r.Stage__c 
                                              FROM RFAUserRole__c 
                                              WHERE RFA__c =: testRFA.Id 
                                              AND RecordTypeId =: RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id];
         
         System.assertEquals('1. Key Operations', validateUserRole[0].RFA__r.Level__c);
         System.debug('\n RFA Stage :'+validateUserRole[0].RFA__r.Stage__c);
         System.assertEquals('Pre-Circulation', validateUserRole[0].RFA__r.Stage__c);
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