@IsTest
private class ITPR_Test_Notes { 

    static testMethod void test01(){
    Test.startTest();
        //Get Profile to use for creating users
        //Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        
        List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
        
        List<User> lstUsers = new List<User>();
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
             ITPR_Department__c = 'ITSES - Procurement',
            firstName = 'test',
            lastName = 'approver1',
            profileId = mapProfiles.get('ITSES - Procurement'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
        User approverFin = new User(
            username = 'test1' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
             ITPR_Department__c = 'ITSES - Finance',
            firstName = 'test',
                        lastName = 'approverFin',
            profileId = mapProfiles.get('ITSES - Finance'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approverFin);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver3);
        
        insert lstUsers;
        
        Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
        
        ITPR__c itpr = new ITPR__c(
            Actionable_Request__c = FALSE,
            Any_Noteworthy_Exceptional_Risk__c = 'Yes',
            Are_There_Exceptions_To_LoL__c = 'Yes',
            Are_There_Fees_For_Early_Termination__c = 'Yes',
            Assign_check__c = FALSE,
            Submitted_By_Phone_Number__c='46894686', 
            Category__c = 'Telecom',
            Delegated_Finance_Assignee__c = FALSE,
            Delegated_Legal_Assignee__c = TRUE,
            Delegated_Procurement_Assignee__c = TRUE,
            Delegated_Requestor_check__c = FALSE,
            Delegated_Vendor_Governance_User__c = FALSE,
            Do_not_Auto_Assign__c = FALSE,
            Expiration_Date__c = Date.today().addDays(20),
            Final_Budget_Validated__c = TRUE,
            Finance_Assignee__c = approverFin.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            //Legal_Assignee__c = approver2.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            //Procurement_Assignee__c = approver1.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Pending Project Final Budget',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            //Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = approver2.Id,
            Wave2_Rejected__c = FALSE,
            Wave3_Approver_1__c = approver3.Id,
            Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver1.Id
        );
        
        insert itpr;
        
        RequestNotes__c notes = new RequestNotes__c(
            ITPR__c = itpr.Id,
            Title__c = 'test',
            Comments__c = 'test'
        );
        
        insert notes;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(notes);
        ITPR_Notes itprNotesPage = new ITPR_Notes(sc);
        
        Boolean bShow = itprNotesPage.show;
        bShow = itprNotesPage.notshow;
        
        itprNotesPage.Save2();
        
        
        Test.stopTest();
    }
    
        static testMethod void test02(){
    Test.startTest();
        //Get Profile to use for creating users
        //Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
        }


        List<User> lstUsers = new List<User>();
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'approver1',
             ITPR_Department__c = 'ITSES - Procurement',
            profileId = mapProfiles.get('ITSES - Procurement'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
        User approverFin = new User(
             username = 'test1' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
             ITPR_Department__c = 'ITSES - Finance',
            firstName = 'test',
                        lastName = 'approverFin',
            profileId = mapProfiles.get('ITSES - Finance'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approverFin);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver3);
        
        insert lstUsers;
        
        Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
        
        ITPR__c itpr = new ITPR__c(
            Actionable_Request__c = FALSE,
            Any_Noteworthy_Exceptional_Risk__c = 'Yes',
            Are_There_Exceptions_To_LoL__c = 'Yes',
            Are_There_Fees_For_Early_Termination__c = 'Yes',
            Assign_check__c = FALSE,
            Category__c = 'Telecom',
            Submitted_By_Phone_Number__c='46894686', 
            Delegated_Finance_Assignee__c = FALSE,
            Delegated_Legal_Assignee__c = TRUE,
            Delegated_Procurement_Assignee__c = TRUE,
            Delegated_Requestor_check__c = FALSE,
            Delegated_Vendor_Governance_User__c = FALSE,
            Do_not_Auto_Assign__c = FALSE,
            Expiration_Date__c = Date.today().addDays(20),
            Final_Budget_Validated__c = TRUE,
            Finance_Assignee__c = approverFin.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            //Legal_Assignee__c = approver2.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            //Procurement_Assignee__c = approver1.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Pending Project Final Budget',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            //Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = approver2.Id,
            Wave2_Rejected__c = FALSE,
            Wave3_Approver_1__c = approver3.Id,
            Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver1.Id
        );
        
        insert itpr;
        
        RequestNotes__c notes = new RequestNotes__c(
            ITPR__c = itpr.Id,
            Title__c = 'test',
            Comments__c = 'test'
        );
        
        insert notes;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(notes);
        ITPR_Notes itprNotesPage = new ITPR_Notes(sc);
        
        Boolean bShow = itprNotesPage.show;
        bShow = itprNotesPage.notshow;
        
        itprNotesPage.check = itpr;
        
        itprNotesPage.check.Status__c = System.Label.ITPR_Submitted_Status;
        itprNotesPage.id2 = 'pendingmoreinfo';
        
        itprNotesPage.Save1();
        
        
        Test.stopTest();
    }
    
            static testMethod void test03(){
    Test.startTest();
        //Get Profile to use for creating users
        //Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        
        List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
             }
        }


   
        List<User> lstUsers = new List<User>();
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'approver1',
             ITPR_Department__c = 'ITSES - Procurement',
            profileId = mapProfiles.get('ITSES - Procurement'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
         User approverFin = new User(
            username = 'test1' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test123@test.com',
             ITPR_Department__c = 'ITSES - Finance',
            firstName = 'test',
             lastName = 'approverFin',
            profileId = mapProfiles.get('ITSES - Finance'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approverFin);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver3);
        
        insert lstUsers;
        
        Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
        
        ITPR__c itpr = new ITPR__c(
            Actionable_Request__c = FALSE,
            Any_Noteworthy_Exceptional_Risk__c = 'Yes',
            Are_There_Exceptions_To_LoL__c = 'Yes',
            Are_There_Fees_For_Early_Termination__c = 'Yes',
            Assign_check__c = FALSE,
            Category__c = 'Telecom',
            Submitted_By_Phone_Number__c='46894686', 
            Delegated_Finance_Assignee__c = FALSE,
            Delegated_Legal_Assignee__c = TRUE,
            Delegated_Procurement_Assignee__c = TRUE,
            Delegated_Requestor_check__c = FALSE,
            Delegated_Vendor_Governance_User__c = FALSE,
            Do_not_Auto_Assign__c = FALSE,
            Expiration_Date__c = Date.today().addDays(20),
            Final_Budget_Validated__c = TRUE,
            Finance_Assignee__c = approverFin.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            //Legal_Assignee__c = approver2.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            //Procurement_Assignee__c = approver1.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Pending Project Final Budget',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            //Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = approver2.Id,
            Wave2_Rejected__c = FALSE,
            Wave3_Approver_1__c = approver3.Id,
            Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver1.Id
        );
        
        insert itpr;
        
        RequestNotes__c notes = new RequestNotes__c(
            ITPR__c = itpr.Id,
            Title__c = 'test',
            Comments__c = 'test'
        );
        
        insert notes;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(notes);
        ITPR_Notes itprNotesPage = new ITPR_Notes(sc);
        
        Boolean bShow = itprNotesPage.show;
        bShow = itprNotesPage.notshow;
        
        itprNotesPage.check = itpr;
        
        itprNotesPage.check.Status__c = System.Label.ITPR_In_Process_Status;
        itprNotesPage.id2 = 'pendingbudget';
        
        itprNotesPage.Save1();
        
        
        Test.stopTest();
    }
    
                static testMethod void test04(){
    Test.startTest();
        //Get Profile to use for creating users
        //Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
        
        }
        List<User> lstUsers = new List<User>();
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'approver1',
             ITPR_Department__c = 'ITSES - Procurement',
            profileId = mapProfiles.get('ITSES - Procurement'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
        
    User approverFin = new User(
             username = 'test1' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test111@test.com',
             ITPR_Department__c = 'ITSES - Finance',
            firstName = 'test',
                         lastName = 'approverFin',
            profileId = mapProfiles.get('ITSES - Finance'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approverFin);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver3);
        
        insert lstUsers;
        
        Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
        
        ITPR__c itpr = new ITPR__c(
            Actionable_Request__c = FALSE,
            Any_Noteworthy_Exceptional_Risk__c = 'Yes',
            Are_There_Exceptions_To_LoL__c = 'Yes',
            Are_There_Fees_For_Early_Termination__c = 'Yes',
            Assign_check__c = FALSE,
            Category__c = 'Telecom',
            Delegated_Finance_Assignee__c = FALSE,
            Delegated_Legal_Assignee__c = TRUE,
            Delegated_Procurement_Assignee__c = TRUE,
            Delegated_Requestor_check__c = FALSE,
            Delegated_Vendor_Governance_User__c = FALSE,
            Do_not_Auto_Assign__c = FALSE,
            Expiration_Date__c = Date.today().addDays(20),
            Final_Budget_Validated__c = TRUE,
            Submitted_By_Phone_Number__c='46894686', 
            Finance_Assignee__c = approverFin.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            //Legal_Assignee__c = approver2.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            //Procurement_Assignee__c = approver1.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Pending Project Final Budget',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            //Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = approver2.Id,
            Wave2_Rejected__c = FALSE,
            Wave3_Approver_1__c = approver3.Id,
            Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver1.Id
        );
        
        insert itpr;
        
        RequestNotes__c notes = new RequestNotes__c(
            ITPR__c = itpr.Id,
            Title__c = 'test',
            Comments__c = 'test'
        );
        
        insert notes;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(notes);
        ITPR_Notes itprNotesPage = new ITPR_Notes(sc);
        
        Boolean bShow = itprNotesPage.show;
        bShow = itprNotesPage.notshow;
        
        itprNotesPage.check = itpr;
        
        itprNotesPage.check.Status__c = System.Label.ITPR_In_Process_Status;
        itprNotesPage.id2 = 'onhold';
        
        itprNotesPage.Save1();
        
        
        Test.stopTest();
    }
    
 static testMethod void test05(){
    Test.startTest();
        //Get Profile to use for creating users
        //Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        
        List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }}
        
        
        List<User> lstUsers = new List<User>();
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'approver1',
             ITPR_Department__c = 'ITSES - Procurement',
            profileId = mapProfiles.get('ITSES - Procurement'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
        User approverFin = new User(
            username = 'test1' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test123@test.com',
             ITPR_Department__c = 'ITSES - Finance',
            firstName = 'test',
                         lastName = 'approverFin',
            profileId = mapProfiles.get('ITSES - Finance'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approverFin);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver3);
        
        insert lstUsers;
        
        Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
        
        ITPR__c itpr = new ITPR__c(
            Actionable_Request__c = FALSE,
            Any_Noteworthy_Exceptional_Risk__c = 'Yes',
            Are_There_Exceptions_To_LoL__c = 'Yes',
            Are_There_Fees_For_Early_Termination__c = 'Yes',
            Assign_check__c = FALSE,
            Category__c = 'Telecom',
            Delegated_Finance_Assignee__c = FALSE,
            Delegated_Legal_Assignee__c = TRUE,
            Delegated_Procurement_Assignee__c = TRUE,
            Delegated_Requestor_check__c = FALSE,
            Delegated_Vendor_Governance_User__c = FALSE,
            Do_not_Auto_Assign__c = FALSE,
            Expiration_Date__c = Date.today().addDays(20),
            Submitted_By_Phone_Number__c='46894686', 
            Final_Budget_Validated__c = TRUE,
            Finance_Assignee__c = approverFin.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            //Legal_Assignee__c = approver2.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            //Procurement_Assignee__c = approver1.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Pending Project Final Budget',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            //Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = approver2.Id,
            Wave2_Rejected__c = FALSE,
            Wave3_Approver_1__c = approver3.Id,
            Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver1.Id
        );
        
        insert itpr;
        
        RequestNotes__c notes = new RequestNotes__c(
            ITPR__c = itpr.Id,
            Title__c = 'test',
            Comments__c = 'test'
        );
        
        insert notes;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(notes);
        ITPR_Notes itprNotesPage = new ITPR_Notes(sc);
        
        Boolean bShow = itprNotesPage.show;
        bShow = itprNotesPage.notshow;
        
        itprNotesPage.check = itpr;
        
        itprNotesPage.check.Status__c = System.Label.ITPR_In_Process_Status;
        itprNotesPage.id2 = 'cancel';
        
        itprNotesPage.Save1();
        
        
        Test.stopTest();
    }

   static testMethod void test06(){
    Test.startTest();
        //Get Profile to use for creating users
        //Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        
        List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
        }
        List<User> lstUsers = new List<User>();
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'approver1',
          profileId = mapProfiles.get('ITSES - Procurement'),
             ITPR_Department__c = 'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
        
    User approverFin = new User(
             username = 'test1' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test123@test.com',
             ITPR_Department__c = 'ITSES - Finance',
            firstName = 'test',
             lastName = 'approverFin',
            profileId = mapProfiles.get('ITSES - Finance'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approverFin);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver3);
        
        insert lstUsers;
        
        Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
        
        ITPR__c itpr = new ITPR__c(
            Actionable_Request__c = FALSE,
            Any_Noteworthy_Exceptional_Risk__c = 'Yes',
            Are_There_Exceptions_To_LoL__c = 'Yes',
            Are_There_Fees_For_Early_Termination__c = 'Yes',
            Assign_check__c = FALSE,
            Category__c = 'Telecom',
            Delegated_Finance_Assignee__c = FALSE,
            Delegated_Legal_Assignee__c = TRUE,
            Delegated_Procurement_Assignee__c = TRUE,
            Delegated_Requestor_check__c = FALSE,
            Delegated_Vendor_Governance_User__c = FALSE,
            Do_not_Auto_Assign__c = FALSE,
            Expiration_Date__c = Date.today().addDays(20),
            Final_Budget_Validated__c = TRUE,
            Finance_Assignee__c = approverFin.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            //Legal_Assignee__c = approver2.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            //Procurement_Assignee__c = approver1.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Pending Project Final Budget',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            //Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = approver2.Id,
            Wave2_Rejected__c = FALSE,
            Wave3_Approver_1__c = approver3.Id,
            Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            Submitted_By_Phone_Number__c='46894686', 
            ownerId = approver1.Id
        );
        
        insert itpr;
        
        RequestNotes__c notes = new RequestNotes__c(
            ITPR__c = itpr.Id,
            Title__c = 'test',
            Comments__c = 'test'
        );
        
        insert notes;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(notes);
        ITPR_Notes itprNotesPage = new ITPR_Notes(sc);
        
        Boolean bShow = itprNotesPage.show;
        bShow = itprNotesPage.notshow;
        
        itprNotesPage.check = itpr;
        
        itprNotesPage.check.Status__c = System.Label.ITPR_In_Process_Status;
        itprNotesPage.id2 = 'complete';
        
        itprNotesPage.Save1();
        
        
        Test.stopTest();
    }
    
                       static testMethod void test07(){
    Test.startTest();
        //Get Profile to use for creating users
        //Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        
        
List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
       } 
        List<User> lstUsers = new List<User>();
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
           email = 'test123@test.com',
            firstName = 'test',
            lastName = 'approver1',
             ITPR_Department__c = 'ITSES - Procurement',
            profileId = mapProfiles.get('ITSES - Procurement'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
        User approverFin = new User(
             username = 'test1' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
             ITPR_Department__c = 'ITSES - Finance',
            firstName = 'test',
            lastName = 'approverFin',
            profileId = mapProfiles.get('ITSES - Finance'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approverFin);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver3);
        
        insert lstUsers;
        
        Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
        
        ITPR__c itpr = new ITPR__c(
            Actionable_Request__c = FALSE,
            Any_Noteworthy_Exceptional_Risk__c = 'Yes',
            Are_There_Exceptions_To_LoL__c = 'Yes',
            Are_There_Fees_For_Early_Termination__c = 'Yes',
            Assign_check__c = FALSE,
            Category__c = 'Telecom',
            Delegated_Finance_Assignee__c = FALSE,
            Delegated_Legal_Assignee__c = TRUE,
            Delegated_Procurement_Assignee__c = TRUE,
            Delegated_Requestor_check__c = FALSE,
            Delegated_Vendor_Governance_User__c = FALSE,
            Do_not_Auto_Assign__c = FALSE,
            Expiration_Date__c = Date.today().addDays(20),
            Final_Budget_Validated__c = TRUE,
            Finance_Assignee__c = approverFin.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            //Legal_Assignee__c = approver2.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            //Procurement_Assignee__c = approver1.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Pending Project Final Budget',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            //Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = approver2.Id,
            Wave2_Rejected__c = FALSE,
            Wave3_Approver_1__c = approver3.Id,
            Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver1.Id,
            Submitted_By_Phone_Number__c='46894686' 
        );
        
        insert itpr;
        
        RequestNotes__c notes = new RequestNotes__c(
            ITPR__c = itpr.Id,
            Title__c = 'test',
            Comments__c = 'test'
        );
        
        insert notes;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(notes);
        ITPR_Notes itprNotesPage = new ITPR_Notes(sc);
        
        Boolean bShow = itprNotesPage.show;
        bShow = itprNotesPage.notshow;
        
        itprNotesPage.check = itpr;
        
        itprNotesPage.check.Status__c = System.Label.ITPR_All_Digital_Initials_Obtained_Status;
        itprNotesPage.id2 = 'notexecuted';
        
        itprNotesPage.Save1();
        
        
        Test.stopTest();
    }
}