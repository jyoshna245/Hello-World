@IsTest(seeAllData=true)
public class RFA_VFC_AddMultipleUsersctlrTest 
{
    static testMethod void AddMultipleusers() 
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
        testRFARole.Manual_Automated__c='Manual';
        insert testRFARole;
        RFAUserRole__c testRFARole1 = new RFAUserRole__c();
        testRFARole1.UserName__c = grUser2.Id;
        testRFARole1.RFA__c = testRFA.ID;        
        testRFARole1.Level__c = '2. Business Unit';        
        insert testRFARole1;
        string doacategory = testRFA.PrimaryDOACategorySubCategory__c;
        doacategory= doacategory.replaceAll('(\\s+)', '');        
        
        RFA_COA_Group__c testgroup = new RFA_COA_Group__c();
        testgroup.Name = 'testGroup1';
        testgroup.Amount__c = testRFA.RequestAmountUSD__c;
        testgroup.DOA_Category__c = doacategory; 
        insert testgroup ;
        
        ProfitCenterCOAGroupJunctionobject__c testjunobj = new ProfitCenterCOAGroupJunctionobject__c();
        testjunobj.RFA_COA_Group_Name__c = testgroup.id;
        testjunobj.Profit_Center_Number__c = testRFA.ProfitCenterNumber__c;
        insert testjunobj ;
        
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
       
        
        IntermediaterfaAutoAppvr__c  Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='Manual';
        Interobj.Approver__c=grUser.Id;
        insert Interobj ;
       
        Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='Auto';
        Interobj.Approver__c=grUser.Id;
        insert Interobj ;
                
        PageReference pageRef = Page.RFA_VFP_AddMultipleUsers;        
        pageref.getParameters().put('id', testRFARole.id);        
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(testRFA); 
        Test.setCurrentPage(pageRef); 
        RFA_VFC_AddMultipleUsersctlr controller  = new RFA_VFC_AddMultipleUsersctlr(stdController);        
        controller.insertInauObj();
        Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='Manual';
        Interobj.Approver__c=grUser.Id;
        insert Interobj ;        
        pageref.getParameters().put('DeleteId', Interobj.id);
        pageref.getParameters().put('EditId', Interobj.id);
        pageref.getParameters().put('Saverownum','0');
        pageref.getParameters().put('Cancelrownum','0');
        pageref.getParameters().put('indexid', '0');               
      
        controller.size=10;      
        controller.EditUsers(); 
        controller.DeleteUsers();
        controller.SaveUsers();
        controller.Cancelusers();
        controller.updateagentsinfo();
        controller.InsertUsers();
        controller.pagination(); 
        controller.previous();
        controller.next();
        controller.first();
        controller.last(); 
        controller.getprv(); 
        controller.getnxt();
        controller.getfst();
        controller.getlst();
        Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='Manual';
        Interobj.Approver__c=grUser.Id;
        Interobj.ApprovalComments__c='Approved';
        insert Interobj ;
        Test.startTest(); 
        pageref.getParameters().put('EditId', Interobj.id);
        pageref.getParameters().put('indexid', '0');
        controller.EditUsers(); 
        Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='Auto';
        Interobj.Approver__c=grUser.Id;
        Interobj.RoleType__c=null;
        insert Interobj ;  
         pageref.getParameters().put('Saverownum','0'); 
         controller.SaveUsers(); 
        Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='Auto'; 
        Interobj.Approver__c=null;       
        Interobj.RoleType__c='Approver';
        Interobj.Level__c=null;
        insert Interobj ;  
         pageref.getParameters().put('Saverownum','0'); 
         controller.SaveUsers();
         Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='Auto';        
        Interobj.RoleType__c='Approver';
        Interobj.Level__c='1. Key Operations' ;
        insert Interobj ;  
         pageref.getParameters().put('Saverownum','0'); 
         controller.SaveUsers();
         controller.validateemptyrow();
       
            
    
    }
     static testMethod void AddMultipleusersmethod2() 
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
        testRFARole.Manual_Automated__c='Manual';
        insert testRFARole;
         PageReference pageRef = Page.RFA_VFP_AddMultipleUsers;        
        pageref.getParameters().put('id', testRFARole.id);
         ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(testRFA); 
        Test.setCurrentPage(pageRef); 
        RFA_VFC_AddMultipleUsersctlr controller  = new RFA_VFC_AddMultipleUsersctlr(stdController);        
        controller.insertInauObj();
        IntermediaterfaAutoAppvr__c  Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='Auto';        
        Interobj.RoleType__c='Approver';
        Interobj.Level__c='1. Key Operations' ;
        Interobj.ExistingOne__c='';
        Interobj.Approver__c=grUser.Id;
        insert Interobj;
       controller.InsertUsers();
       pageref.getParameters().put('DeleteId', Interobj.id);
       pageref.getParameters().put('indexid', '0');
       Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.RFAId__c = testRFA.ID;
        Interobj.Manual_Automated__c='Manual';
        Interobj.Approver__c=grUser.Id;
        Interobj.ApprovalComments__c='Approved';
        insert Interobj ;        
        controller.DeleteUsers();
        
    }
}