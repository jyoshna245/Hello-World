@IsTest(seeAllData=true)
public class RFA_VFC_NewAutoApproverControllerTest 
{
    
     static testMethod void myUnitTest1() 
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
       system.debug('test RFA USDAmount is:' +testRFA.RequestAmountUSD__c);
        
        
        string profile = RFATestData.RFAStandardUserProfile;
        RFATestData RTData = new RFATestData();
        User grUser = new User();
        grUser = RTData.createUser(profile, 'TestUser', 'grlastt', grUser);

        User grUser2 = new User();
        grUser2 = RTData.createUser(profile, 'TUser2', 'grlas2', grUser2);
                
        RFAUserRole__c testRFARole = new RFAUserRole__c();
        testRFARole.UserName__c = grUser.Id;
        testRFARole.RFA__c = testRFA.ID;        
        testRFARole.Level__c = '1. Key Operations';
        insert testRFARole;
        RFAUserRole__c testRFARole1 = new RFAUserRole__c();
        testRFARole1.UserName__c = grUser2.Id;
        testRFARole1.RFA__c = testRFA.ID;        
        testRFARole1.Level__c = '2. Business Unit';
        insert testRFARole1;
        
        RFA_COA_Group__c testgroup = new RFA_COA_Group__c();
        testgroup.Name = 'testGroup1';
        testgroup.Amount__c = testRFA.RequestAmountUSD__c;
        insert testgroup ;
        
        RFA_Approver__c testapprover = new RFA_Approver__c();
        testapprover.UserName__c = grUser.Id;
        testapprover.UserRole__c = 'Approver';
        testapprover.RFA_COA_Group__c = testgroup.Id;
        insert testapprover;
        testapprover = new RFA_Approver__c();
        testapprover.UserName__c = grUser2.Id;
        testapprover.UserRole__c = 'Info Copy';
        testapprover.RFA_COA_Group__c = testgroup.Id;
        insert testapprover;
        system.debug('Test class RFA is:' +testRFA);
        system.debug('Test class PC number is:' +RFATestData.testProfitCenter.Id);
        system.debug('Test class Group number is:' +testgroup.Id);
        ProfitCenterCOAGroupJunctionobject__c junobj = new ProfitCenterCOAGroupJunctionobject__c();        
        junobj.Profit_Center_Number__c = testRFA.ProfitCenterNumber__c;
        junobj.RFA_COA_Group_Name__c = testgroup.Id;  
        insert junobj ; 
        
        IntermediaterfaAutoAppvr__c  Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='M';
        //Interobj.Approver__c='005g0000002jjTb';
        insert Interobj ; 
        List<ProfitCenterCOAGroupJunctionobject__c>  selectedGroupNames = [select RFA_COA_Group_Name__r.Name from ProfitCenterCOAGroupJunctionobject__c where Profit_Center_Number__r.Id =:testRFA.ProfitCenterNumber__c and RFA_COA_Group_Name__r.Amount__c =: testRFA.RequestAmountUSD__c ];       
        system.debug('junction obj values are:' +selectedGroupNames );
        List<RFA_Approver__c> criteriausers =[select Username__c,UserRole__c,Level__c,RFA_COA_Group__c,RFA_COA_Group__r.name from RFA_Approver__c];
        system.debug('test approvers  are:' +criteriausers );
        PageReference pageRef = Page.RFA_VFP_NewAutoApprover;        
        pageref.getParameters().put('id', testRFARole.id);
         pageref.getParameters().put('DeleteId', Interobj.id); 
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(testRFA); 
        Test.setCurrentPage(pageRef); 
        RFA_VFC_NewAutoApproverController controller  = new RFA_VFC_NewAutoApproverController(stdController);
        controller.DeleteRFAUserrole();
        controller.insertInauObj();
        system.debug('getusers calling'+controller.getusers());
        controller.size=10;
       // controller.tobeDeleted=[select Id from IntermediaterfaAutoAppvr__c where RFAId__c=:testRFA.ID LIMIT 1].Id;
        //controller.intermApp=[select level__c,Agent1__c,Agent2__c,Agent3__c from RFAUserRole__c where RFA__c =:testRFA.ID ];
        controller.searchstring='Bindu';
        controller.searchUsers(); 
        controller.ClearUsers();
        controller.Addtotable();
        
        controller.InsertApprovers();
        controller.getSelected();        
        user uobj = new user();
        RFA_VFC_NewAutoApproverController.Userwrapper obj = new RFA_VFC_NewAutoApproverController.Userwrapper(uobj);
            
    
    }
     static testMethod void myUnitTest2() 
    {
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        RFATestData rtTest = new RFATestData();
         rtTest.buildProfitCenter();
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        string profile = RFATestData.RFAStandardUserProfile;
        RFATestData RTData = new RFATestData();
        User grUser = new User();
        grUser = RTData.createUser(profile, 'TestUser', 'grlastt', grUser);

        User grUser2 = new User();
        grUser2 = RTData.createUser(profile, 'TUser2', 'grlas2', grUser2);
                
        RFAUserRole__c testRFARole = new RFAUserRole__c();
        testRFARole.UserName__c = grUser.Id;
        testRFARole.RFA__c = testRFA.ID;
        
        testRFARole.Level__c = '1. Key Operations';
        insert testRFARole;
        RFA_COA_Group__c testgroup = new RFA_COA_Group__c();
        testgroup.Name = 'testGroup1';
        testgroup.Amount__c = testRFA.RequestAmountUSD__c;
        insert testgroup ;
        
        RFA_Approver__c testapprover = new RFA_Approver__c();
        testapprover.UserName__c = grUser.Id;
        testapprover.UserRole__c = 'Approver';
        testapprover.RFA_COA_Group__c = testgroup.Id;
        insert testapprover;
        system.debug('Test class PC number is:' +testRFA.ProfitCenterNumber__c);
        system.debug('Test class Group number is:' +testgroup.Id);
        
        
       /* ProfitCenterCOAGroupJunctionobject__c junobj = new ProfitCenterCOAGroupJunctionobject__c();
        
        junobj.Profit_Center_Number__c = testRFA.ProfitCenterNumber__c;
        junobj.RFA_COA_Group_Name__c = testgroup.Id;
        insert  junobj ; */
        
        
        IntermediaterfaAutoAppvr__c  Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='M';
        //Interobj.Approver__c='005g0000002jjTb';
        insert Interobj ;      
        

        PageReference pageRef = Page.RFA_VFP_NewAutoApprover;
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('id', testRFARole.id); 
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(testRFA); 
        RFA_VFC_NewAutoApproverController controller  = new RFA_VFC_NewAutoApproverController(stdController);
        controller.size=10;
        //MyStandardClass instance = new MyStandardClass(controller);
        controller.approvedusers =[select Id,Level__c,UserName__c,Agent1__c,Agent2__c,Agent3__c,recordTypeId,Manual_Automated__c,ApprovalRecommendation__c from RFAUserRole__c where RFA__c='a0Gg000000AwNO5' and ApprovalRecommendation__c != null];
        //controller.intermApp=[select ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c from IntermediaterfaAutoAppvr__c where RFAId__c='a0Gg000000AwNO5' order by Level__c asc]; 
        controller.searchstring='Bindu';
        controller.tablerendered=false;
        controller.searchUsers();
        }

}