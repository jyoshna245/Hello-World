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

@IsTest(SeeallData=true)
public class RFA_VFC_ObjectHierarchyViewctrl_Test 
{
    static testmethod void Apprvrdetailsmethod1()
    {
        
        RFATestData testData = new RFATestData();
        //RFA__c testRFA; 
        RFA_Business_Unit__c testBU= RFATestData.buildRFAHierarchyBusinessUnit();
        insert testBU;
        ProfitCenter__c pc=testData.buildRFAHierarchyProfitCenter(testBU.id); 
        RFA_COA_Group__c testgroup = new RFA_COA_Group__c();
        
        testgroup.Name = 'testGroup1';
        testgroup.Amount__c = 999999;
        testgroup.DOA_Category__c ='4.A Leases - Operating Leases';
        insert testgroup ;
        String profile = RFATestData.RFAStandardUserProfile;
        RFATestData RTData = new RFATestData();
        User grUser = new User();
        grUser = RTData.createUser(profile, 'TestUser', 'grlastt', grUser);
        
        User grUser2 = new User();
        grUser2 = RTData.createUser(profile, 'TUser2', 'grlas2', grUser2);
        
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
        
        //system.debug('Test class RFA is:' +testRFA);
        system.debug('Test class PC number is:' +RFATestData.testProfitCenter.Id);
        system.debug('Test class Group number is:' +testgroup.Id);
        
        ProfitCenterCOAGroupJunctionobject__c junobj = new ProfitCenterCOAGroupJunctionobject__c();        
        junobj.Profit_Center_Number__c = pc.Id;
        junobj.RFA_COA_Group_Name__c = testgroup.Id;  
        insert junobj ;  
         
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        
        
        User approverUser;
        
        System.runAs(RFATestData.requester)
        {
            //testRFA = RFATestData.buildTestRFA(testRFA, rt);
            
        }
        
        
        PageReference pageRef = Page.RFA_VFP_ObjectHierarchyViewPage;        
        Test.setCurrentPage(pageRef); 
        
        
        
        
        RFA_VFC_ObjectHierarchyViewController controller  = new RFA_VFC_ObjectHierarchyViewController();
        
        IntermediaterfaAutoAppvr__c  Interobj = new IntermediaterfaAutoAppvr__c ();
        
        controller.selectedRec='TestRec';
        
       
        controller.selectedRec='CCNA';
        controller.getBusinessUnits();
        controller.selectedUnit=testBU.name;        
        controller.getProfitcenters();
        controller.selectedPC=pc.Name;    
        controller.getDOACategories();
        controller.selectedDOA='4.A Leases - Operating Leases';
        controller.getGroupAmounts();
        controller.selectedAmount='999999';
        
        controller.selectedGroupNames=testgroup.Id;
        controller.viewApprovers();
        
        controller.selectedAmount='199999';        
        controller.selectedGroupNames=testgroup.Id;
        controller.viewApprovers();
        
        controller.selectedAmount='199999'; 
        controller.viewApprovers();
        
        controller.selectedGroupNames=testgroup.Id;
        controller.SelectedgroupUsers();
        controller.AddUsers();
        controller.selectedGroupNames=testgroup.Id;
        
        User testUser = new User();   
        testUser = new User();
        testUser.alias = 'tt';
        testUser.email = 'cok@cocacola1.com';
        testUser.emailencodingkey='UTF-8';
        testUser.lastName = 'ln';
        testUser.languagelocalekey='en_US';
        testUser.localesidkey='en_US';
        String profileId=RFATestData.getRFAStandardUserProfile();
        testUser.ProfileId = profileId;
        testUser.timezonesidkey='Europe/London';
        testUser.UserName = 'rt'+'@rfa.cocacola.com';
        insert testUser;
        
        RFA_Approver__c existingRFAApproversInsert=new RFA_Approver__c();
        existingRFAApproversInsert.Level__c='1. Key Operations';
        existingRFAApproversInsert.RFA_COA_Group__c=testgroup.Id;
        existingRFAApproversInsert.UserName__c=testUser.id;
        existingRFAApproversInsert.UserRole__c='Approver';             
        
        insert existingRFAApproversInsert;
        
        Test.startTest();
        List<IntermediaterfaAutoAppvr__c> intermTest1 = new  List<IntermediaterfaAutoAppvr__c>();
        User userobj=[Select id from User  where Profile.Name = 'RFA - Standard User' limit 1];
        controller  = new RFA_VFC_ObjectHierarchyViewController();
        intermTest1 = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c ();   
        Interobj.Approver__c=userobj.id;
        Interobj.RoleType__c='Approver';
        Interobj.Level__c='1. Key Operations'; 
        Interobj.ExistingOne__c=userobj.id;
        insert Interobj ;  
        
        intermTest1.add(Interobj);
        pageref.getParameters().put('Saverownum', '0');
        Test.setCurrentPage(pageRef);
        controller.intermediateObj=intermTest1; 
        
        controller.updateApprovers();
        Test.stopTest();
        
        controller.rowNum=0;
        Interobj = new IntermediaterfaAutoAppvr__c ();        
        Interobj.Manual_Automated__c='Manual';
        Interobj.Approver__c=userobj.id;
        insert Interobj ;
        List<IntermediaterfaAutoAppvr__c> listIntermediate = new List<IntermediaterfaAutoAppvr__c>();   
        listIntermediate.add(Interobj);
        controller.intermediateObj=listIntermediate;
        pageref.getParameters().put('DeleteId',Interobj.Id); 
        pageref.getParameters().put('indexid','0'); 
        
        pageref.getParameters().put('EditId',Interobj.Id); 
        controller.EditUsers(); 
        controller.selectedGroupNames=testgroup.Id;        
        controller.viewApprovers();
        pageref.getParameters().put('indexid','0');
        Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.Approver__c=userobj.id;
        Interobj.RoleType__c='Approver';
        insert Interobj ;    
        intermTest1 = new List<IntermediaterfaAutoAppvr__c>();
        intermTest1.add(Interobj);
        Test.setCurrentPage(pageRef);
        controller.intermediateObj=intermTest1;
        controller.DeleteUsers();   
        
    }    
    
    static testmethod void Apprvrdetailsmethod2()
    {
        RFA_VFC_ObjectHierarchyViewController controller  = new RFA_VFC_ObjectHierarchyViewController();
        
        controller.selectedRec='--Select--';
        controller.viewApprovers();        
        
    }
    
    static testmethod void Apprvrdetailsmethod3()
    {
        RFA_VFC_ObjectHierarchyViewController controller  = new RFA_VFC_ObjectHierarchyViewController();
        controller.selectedRec='CCNA'; 
        controller.selectedUnit='--Select--';
        controller.viewApprovers(); 
        
    }
    static testmethod void Apprvrdetailsmethod4()
    {
        RFA_VFC_ObjectHierarchyViewController controller  = new RFA_VFC_ObjectHierarchyViewController();
        controller.selectedRec='CCNA'; 
        controller.selectedUnit='Test';
        controller.selectedPc='--Select--';
        controller.viewApprovers(); 
        
    }
    static testmethod void Apprvrdetailsmethod5()
    {
        RFA_VFC_ObjectHierarchyViewController controller  = new RFA_VFC_ObjectHierarchyViewController();
        controller.selectedRec='CCNA'; 
        controller.selectedUnit='Test';
        controller.selectedPc='Test';
        controller.selectedDOA='--Select--';
        controller.viewApprovers(); 
        
    }
    static testmethod void Apprvrdetailsmethod6()
    {
        RFA_VFC_ObjectHierarchyViewController controller  = new RFA_VFC_ObjectHierarchyViewController();
        controller.selectedRec='CCNA'; 
        controller.selectedUnit='Test';
        controller.selectedPc='Test';
        controller.selectedDOA='Test';
        controller.selectedAmount='--Select--';
        controller.viewApprovers(); 
        
    }
    static testmethod void ApprvrdetailsmethodSaveUsers()
    {
        Test.startTest();
        RFA_VFC_ObjectHierarchyViewController controller  = new RFA_VFC_ObjectHierarchyViewController();
         User usrobj=[Select id from User  where Profile.Name = 'RFA - Standard User' limit 1];
        List<IntermediaterfaAutoAppvr__c> intermTest = new List<IntermediaterfaAutoAppvr__c>();                
        IntermediaterfaAutoAppvr__c  Interobj = new IntermediaterfaAutoAppvr__c ();        
        Interobj.Approver__c=usrobj.id;
        insert Interobj ;
        intermTest.add(Interobj);
        controller.intermediateObj=intermTest;
        PageReference pageRef = Page.RFA_VFP_ObjectHierarchyViewPage;
        pageref.getParameters().put('Saverownum', '0');
        Test.setCurrentPage(pageRef);
        controller.SaveUsers(); 
        intermTest = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c ();
        insert Interobj ;
        intermTest.add(Interobj);
        controller.intermediateObj=intermTest;
        pageRef = Page.RFA_VFP_ObjectHierarchyViewPage;
        pageref.getParameters().put('Saverownum', '0');
        Test.setCurrentPage(pageRef);
        controller.SaveUsers();  
        
        controller  = new RFA_VFC_ObjectHierarchyViewController();
        intermTest = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.Approver__c=usrobj.id;
        Interobj.RoleType__c='Approver';
        insert Interobj ;        
        intermTest.add(Interobj);
        pageref.getParameters().put('Saverownum', '0');
        Test.setCurrentPage(pageRef);
        controller.intermediateObj=intermTest;
        controller.SaveUsers();
        
        
        controller  = new RFA_VFC_ObjectHierarchyViewController();
        intermTest = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c (); 
        Interobj.Approver__c=usrobj.id;
        Interobj.RoleType__c='Co-Creator';
        insert Interobj ;        
        intermTest.add(Interobj);
        pageref.getParameters().put('Saverownum', '0');
        Test.setCurrentPage(pageRef);
        controller.intermediateObj=intermTest;
        controller.SaveUsers();
        
        controller  = new RFA_VFC_ObjectHierarchyViewController();
        intermTest = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.Approver__c=usrobj.id;
        Interobj.RoleType__c='Primary Point of Contact';
        Interobj.Level__c='1. Key Operations';        
        insert Interobj ;
        intermTest.add(Interobj);
        pageref.getParameters().put('Saverownum', '0');
        Test.setCurrentPage(pageRef);
        controller.intermediateObj=intermTest;
        controller.SaveUsers();
        
        controller  = new RFA_VFC_ObjectHierarchyViewController();
        intermTest = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c ();
        Interobj.Approver__c=usrobj.id;
        Interobj.RoleType__c='Co-Creator';
        Interobj.Level__c='1. Key Operations';        
        insert Interobj ;
        intermTest.add(Interobj);
        pageref.getParameters().put('Saverownum', '0');
        Test.setCurrentPage(pageRef);
        controller.intermediateObj=intermTest;
        controller.SaveUsers();
        
        controller  = new RFA_VFC_ObjectHierarchyViewController();
        intermTest = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c ();   
        Interobj.Approver__c=usrobj.id;
        Interobj.RoleType__c='Approver';
        Interobj.Level__c='1. Key Operations'; 
        insert Interobj ;        
        intermTest.add(Interobj);
        pageref.getParameters().put('Saverownum', '0');
        Test.setCurrentPage(pageRef);
        controller.intermediateObj=intermTest;
        controller.SaveUsers();
        
        controller  = new RFA_VFC_ObjectHierarchyViewController();
        intermTest = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c ();   
        Interobj.Approver__c=usrobj.id;
        Interobj.RoleType__c='Approver';
        Interobj.Level__c='1. Key Operations'; 
        insert Interobj ;        
        intermTest.add(Interobj);
        pageref.getParameters().put('Saverownum', '0');
        Test.setCurrentPage(pageRef);
        controller.intermediateObj=intermTest;
        controller.SaveUsers();
        
        
        controller  = new RFA_VFC_ObjectHierarchyViewController();       
        intermTest = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c ();   
        Interobj.Approver__c=usrobj.id;
        Interobj.RoleType__c='Approver';
        Interobj.Level__c='1. Key Operations'; 
        insert Interobj ;          
        controller.tobeEdited=Interobj.id;
        intermTest.add(Interobj);
        controller.intermediateObj=intermTest;
        pageref.getParameters().put('Cancelrownum', '0');
        controller.Cancelusers();      
        
        controller  = new RFA_VFC_ObjectHierarchyViewController();       
        intermTest = new List<IntermediaterfaAutoAppvr__c>();
        Interobj = new IntermediaterfaAutoAppvr__c ();   
        Interobj.Approver__c=usrobj.id;
        Interobj.RoleType__c='Approver';
        Interobj.Level__c='1. Key Operations'; 
        insert Interobj ;          
        controller.tobeEdited=Interobj.id;
        intermTest.add(Interobj);
        controller.intermediateObj=intermTest; 
        PageReference pageRef1 = Page.RFA_VFP_ObjectHierarchyViewPage;        
        pageref1.getParameters().put('EditId', Interobj.id);
        controller.EditUsers();  
        Test.stopTest();
    }  
    
    
}