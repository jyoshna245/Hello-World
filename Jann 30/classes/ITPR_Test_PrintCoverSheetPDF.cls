@IsTest(seeAllData = true)
private class ITPR_Test_PrintCoverSheetPDF { 

    static testMethod void test01(){
    Test.startTest();
        //Get Profile to use for creating users
        Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        
        List<User> lstUsers = new List<User>();
        
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'approver1',
            profileId = p.Id,
            ITPR_Department__c = 'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        approver2.ITPR_Department__c = 'ITSES - Legal';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        approver3.ITPR_Department__c = 'ITSES - Vendor Governance';
        lstUsers.add(approver3);
        
        User approver4 = approver1.clone();
        approver4.username = 'test4' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver4);
        
        User approver5 = approver1.clone();
        approver5.username = 'test5' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver5);
        
        User approver6 = approver1.clone();
        approver6.username = 'test6' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver6);
        
        User approver7 = approver1.clone();
        approver7.username = 'test7' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver7);
        
        User approver8 = approver1.clone();
        approver8.username = 'test8' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver8);
        
        User approver9 = approver1.clone();
        approver9.username = 'test9' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver9);
        
        User approver10 = approver1.clone();
        approver10.username = 'test10' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver10);
        
        User approver11 = approver1.clone();
        approver11.username = 'test11' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver11);
        
        User approver12 = approver1.clone();
        approver12.username = 'test12' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver12);
        
        User approver13 = approver1.clone();
        approver13.username = 'test13' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver13);
        
        User approver14 = approver1.clone();
        approver14.username = 'test14' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver14);
        
        User approver15 = approver1.clone();
        approver15.username = 'test15' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver15);

        User approver16 = approver1.clone();
        approver16.username = 'test16' + DateTime.now().getTime() + '@test.com';
        approver16.ITPR_Department__c = 'ITSES - Finance';
        lstUsers.add(approver16);

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
            Finance_Assignee__c = approver16.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            Legal_Assignee__c = approver2.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            Procurement_Assignee__c = approver1.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            //Status__c = 'Pending Project Final Budget',
            Status__c = 'All Digital Initials Obtained',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            Submitted_By_Phone_Number__c = '1111111112',
            Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = TRUE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Approver_2__c = approver2.Id,
            Wave1_Approver_3__c = approver3.Id,
            Wave1_Approver_4__c = approver4.Id,
            Wave1_Approver_5__c = approver5.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = TRUE,
            Wave2_Approver_1__c = approver6.Id,
            Wave2_Approver_2__c = approver7.Id,
            Wave2_Approver_3__c = approver8.Id,
            Wave2_Approver_4__c = approver9.Id,
            Wave2_Approver_5__c = approver10.Id,
            Wave2_Rejected__c = FALSE,
            Wave3_Approver_1__c = approver11.Id,
            Wave3_Approver_2__c = approver12.Id,
            Wave3_Approver_3__c = approver13.Id,
            Wave3_Approver_4__c = approver14.Id,
            Wave3_Approver_5__c = approver15.Id,
            Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver1.Id
        );
        
        insert itpr;
        
        ProcessInstance approvedSteps = [SELECT TargetObjectId FROM ProcessInstance WHERE Status = 'Approved' LIMIT 1];
        //insert approvedSteps;
        
        //ITPR__c itpr1 = [SELECT Id,Name FROM ITPR__c WHERE ID=:approvedSteps.TargetObjectId LIMIT 1];
        //ITPR__c itpr1 = [SELECT Id,Name FROM ITPR__c LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(itpr);
        ITPR_PrintCoverSheetPDF coverPDF = new ITPR_PrintCoverSheetPDF(sc);
        Test.stopTest();
    }
    
    static testMethod void test02(){
    Test.startTest();
        //Get Profile to use for creating users
        Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        
        List<User> lstUsers = new List<User>();
        
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'approver1',
            profileId = p.Id,
             ITPR_Department__c = 'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        approver2.ITPR_Department__c = 'ITSES - Legal';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        approver3.ITPR_Department__c = 'ITSES - Vendor Governance';
        lstUsers.add(approver3);
        
        User approver4 = approver1.clone();
        approver4.username = 'test16' + DateTime.now().getTime() + '@test.com';
        approver4.ITPR_Department__c = 'ITSES - Finance';
        lstUsers.add(approver4);
        
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
            Finance_Assignee__c = approver4.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            Legal_Assignee__c = approver2.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            Procurement_Assignee__c = approver1.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            //Status__c = 'Pending Project Final Budget',
            Status__c = 'All Digital Initials Obtained',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            Submitted_By_Phone_Number__c = '1111111112',
            Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = TRUE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = TRUE,
            Wave2_Approver_1__c = approver2.Id,
            Wave2_Rejected__c = FALSE,
            Wave3_Approver_1__c = approver3.Id,
            Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver1.Id
        );
        
        insert itpr;
        
        ProcessInstance approvedSteps = [SELECT TargetObjectId FROM ProcessInstance WHERE Status = 'Approved' LIMIT 1];
        //insert approvedSteps;
        
        //ITPR__c itpr1 = [SELECT Id,Name FROM ITPR__c WHERE ID=:approvedSteps.TargetObjectId LIMIT 1];
        //ITPR__c itpr1 = [SELECT Id,Name FROM ITPR__c LIMIT 1 ];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(itpr);
        ITPR_PrintCoverSheetPDF coverPDF = new ITPR_PrintCoverSheetPDF(sc);
        Test.stopTest();
    }
}