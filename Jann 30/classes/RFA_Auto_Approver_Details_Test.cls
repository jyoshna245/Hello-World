@isTest(SeeAllData=true)
public class RFA_Auto_Approver_Details_Test {
    static String selectedRec{get;set;}
    static String selectedUnit{get;set;}
    static String selectedPC{get;set;}
    static String selectedDOA{get;set;}
    static String selectedAmount{get;set;}
    static String selectedGroupNames{get;set;}
    static List<RFA_Approver__c> RFAApprovers{get;set;}
    static List<SelectOption> pc{get;set;}
    static List<SelectOption> BusRecordTypes{get;set;}      
    
    static testmethod void testn_constructor(){
        RFA_Auto_Approver_Details_controller ac = new RFA_Auto_Approver_Details_controller();
        System.debug('Size of BusRecordTypes' +ac.BusRecordTypes.size());
        system.assertNotEquals(3, ac.BusRecordTypes.size());
    }

    static testmethod void testp_constructor(){
        RFA_Auto_Approver_Details_controller ac = new RFA_Auto_Approver_Details_controller();
        System.debug('Size of BusRecordTypes' +ac.BusRecordTypes.size());
        system.assertEquals(4, ac.BusRecordTypes.size());
    }    
    static testmethod void test_getBusinessUnits(){
        RFA_Auto_Approver_Details_controller ac = new RFA_Auto_Approver_Details_controller();
        ac.selectedRec = 'CCR';
        pc = new List<SelectOption>();
        system.Test.startTest();
            pc = ac.getBusinessUnits();
            system.assertNotEquals(null, pc);
        system.Test.stopTest();
    }
    
    static testmethod void test_getProfitcenters(){
        RFA_Auto_Approver_Details_controller ac = new RFA_Auto_Approver_Details_controller();
        ac.selectedUnit = 'AC';
        pc = new List<SelectOption>();
        system.Test.startTest();
            pc = ac.getProfitcenters();
            system.assertNotEquals(null, pc);
        system.Test.stopTest();
    }    
    
    static testmethod void test_getDOACategories(){
        RFA_Auto_Approver_Details_controller ac = new RFA_Auto_Approver_Details_controller();
        ac.selectedPc = 'AE00010001';
        pc = new List<SelectOption>();
        system.Test.startTest();
            pc = ac.getDOACategories();
            system.assertNotEquals(null, pc);
        system.Test.stopTest();
    }    
    
    static testmethod void test_getGroupAmounts(){
        RFA_Auto_Approver_Details_controller ac = new RFA_Auto_Approver_Details_controller();
        ac.selectedDOA = '4.A Leases - Operating Leases';
        pc = new List<SelectOption>();
        system.Test.startTest();
            pc = ac.getGroupAmounts();
            system.assertNotEquals(null, pc);
        system.Test.stopTest();
    }     
    
    static testmethod void test_viewApprovers(){
        RFA_Auto_Approver_Details_controller ac = new RFA_Auto_Approver_Details_controller();
		ac.selectedRec = 'CCR';
        ac.selectedUnit = 'AC';
        ac.selectedPc = 'AE00010001';
        ac.selectedDOA = '4.A Leases - Operating Leases';
        ac.selectedAmount = '499999';
        List<RFA_COA_Group__c> groupnumbers = new List<RFA_COA_Group__c>();
        system.Test.startTest();
            ac.viewApprovers();
            system.assertNotEquals(7, ac.RFAApprovers.size());
        system.Test.stopTest();
    }

    static testmethod void test_SelectedgroupUsers(){
        RFA_Auto_Approver_Details_controller ac = new RFA_Auto_Approver_Details_controller();
		ac.selectedRec = 'CCR';
        ac.selectedUnit = 'AC';
        ac.selectedPc = 'AE00010001';
        ac.selectedDOA = '4.A Leases - Operating Leases';
        ac.selectedAmount = '499999';
        List<RFA_COA_Group__c> groupnumbers = new List<RFA_COA_Group__c>();
        ac.viewApprovers();
        system.Test.startTest();
        	ac.SelectedgroupUsers();
            system.assertEquals(7, ac.RFAApprovers.size());
        system.Test.stopTest();
    }   
    
}