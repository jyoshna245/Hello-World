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
private class RFA_VFC04_ApprovalProcessController_Test
{
    static testmethod void RFA_VFC04_ApprovalProcess_Test1()
    {
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        RFA__c testRFA; 
        User approverUser;
        
        System.runAs(RFATestData.requester)
        {
            testRFA = RFATestData.buildTestRFA(testRFA, rt);
            
        }
        
        System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
        {
            approverUser = new User();
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
            RFA__c rfaVsal = [Select Id, Level__c, Stage__c FROM RFA__c where Id =: testRFA.Id];
            System.assertEquals('1. Key Operations', rfaVsal.Level__c);
            System.assertEquals('Circulation', rfaVsal.Stage__c);
        } 
        Test.startTest();
        ApexPages.Standardcontroller stdController;
        RFA_VFC04_ApprovalProcessController controller;
        System.runAs(approverUser)
        {
            Map<String, String> urlParams = new Map<String, String>{
                'Id' => testRFA.Id
                    };
                        Test.setCurrentPage(getPageReference('RFA_VFP02_Override', urlParams));
            
            stdController = new ApexPages.Standardcontroller(testRFA);
            controller = new RFA_VFC04_ApprovalProcessController(stdController);
            controller.prepareWorkItem();
            List<SelectOption> recomOptions = controller.recommendationOptions;
            controller.selectedRecommendation = 'Unconditionally Approved';
            controller.selectedWorkItem = controller.workItemOptions[0].getValue();
            
            
        }
        controller.submitRecommendation();
        ApprovalProcess__c processVal = [Select ApprovalProcessLevel__c, RFA__r.Level__c, RFA__r.Stage__c, Status__c FROM ApprovalProcess__c WHERE RFA__c =: testRFA.Id];
        System.assertEquals('Completed', processVal.Status__c);
        System.assertEquals('1. Key Operations', processVal.RFA__r.Level__c);
        System.assertEquals('Post-Circulation', processVal.RFA__r.Stage__c);     
        Test.StopTest();
    }
    
    static testmethod void RFA_VFC04_ApprovalProcess_Test2()
    {
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        RFA__c testRFA; 
        User approverUser;
        
        System.runAs(RFATestData.requester)
        {
            testRFA = RFATestData.buildTestRFA(testRFA, rt);
            
        }
        
        System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
        {
            approverUser = new User();
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
            RFA__c rfaVsal = [Select Id, Level__c, Stage__c FROM RFA__c where Id =: testRFA.Id];
            System.assertEquals('1. Key Operations', rfaVsal.Level__c);
            System.assertEquals('Circulation', rfaVsal.Stage__c);
        } 
        Test.startTest();
        ApexPages.Standardcontroller stdController;
        RFA_VFC04_ApprovalProcessController controller;
        System.runAs(approverUser)
        {
            Map<String, String> urlParams = new Map<String, String>{
                'Id' => testRFA.Id
                    };
                        Test.setCurrentPage(getPageReference('RFA_VFP02_Override', urlParams));
            
            stdController = new ApexPages.Standardcontroller(testRFA);
            controller = new RFA_VFC04_ApprovalProcessController(stdController);
            controller.prepareWorkItem();
            List<SelectOption> recomOptions = controller.recommendationOptions;
            controller.selectedRecommendation = 'Unconditionally Approved';
            //controller.selectedWorkItem = controller.workItemOptions[0].getValue();
            
            
        }
        controller.submitRecommendation();
        ApprovalProcess__c processVal = [Select ApprovalProcessLevel__c, RFA__r.Level__c, RFA__r.Stage__c, Status__c FROM ApprovalProcess__c WHERE RFA__c =: testRFA.Id];
        
        Test.StopTest();
    }
    
    
    //For REQ 23.12
    static testmethod void RFA_VFC04_ApprovalProcess_Test3()
    {
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        RFA__c testRFA;	
        User approverUser;
        User approverAgent1;
        
        System.runAs(RFATestData.requester)
        {
            testRFA = RFATestData.buildTestRFA(testRFA, rt);
            
        }
        
        System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
        {
            approverUser = new User();
            approverUser = testData.createUser(RFATestData.rfaStandardUserProfile, 'apr1', 'apr1', approverUser);
            
            approverAgent1 = new User();
            approverAgent1 = testData.createUserasAgent(RFATestData.rfaStandardUserProfile, 'Agnt', approverAgent1);
            
            RFAUserRole__c approver = RFATestData.buildApprover(testRFA.Id, approverUser, testRFA.level__c);
            
            //approver.ApprovalRecommendation__c = 'Awaiting Approval';
            system.debug('approverUser is '+approverAgent1);
            system.debug('approver '+approverAgent1.id);
            approver.Agent1__c =  approverAgent1.id;
            //approver.UserName__c = approverUser.id;
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
            
            RFA__c rfaVsal = [Select Id, Level__c, Stage__c FROM RFA__c where Id =: testRFA.Id];
            System.assertEquals('1. Key Operations', rfaVsal.Level__c);
            System.assertEquals('Circulation', rfaVsal.Stage__c);
        } 
        Test.startTest();
        ApexPages.Standardcontroller stdController;
        RFA_VFC04_ApprovalProcessController controller;
        System.runAs(approverUser)
        {
            Map<String, String> urlParams = new Map<String, String>{
                'Id' => testRFA.Id
                    };
                        Test.setCurrentPage(getPageReference('RFA_VFP02_Override', urlParams));
            
            stdController = new ApexPages.Standardcontroller(testRFA);
            controller = new RFA_VFC04_ApprovalProcessController(stdController);
            controller.prepareWorkItem();
            List<SelectOption> recomOptions = controller.recommendationOptions;
            controller.selectedRecommendation = 'Rejected';
            controller.approvalComments='rej';
            
            
            controller.selectedWorkItem = controller.workItemOptions[0].getValue();
            
            
            
        }
        controller.submitRecommendation();
        
        ApprovalProcess__c processVal = [Select ApprovalProcessLevel__c, RFA__r.Level__c, RFA__r.Stage__c, Status__c FROM ApprovalProcess__c WHERE RFA__c =: testRFA.Id];
        
        System.assertEquals('Completed', processVal.Status__c);
        System.assertEquals('1. Key Operations', processVal.RFA__r.Level__c);
        System.assertEquals('Post-Circulation', processVal.RFA__r.Stage__c);  	 
        Test.StopTest();
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