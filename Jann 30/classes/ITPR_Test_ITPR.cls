@IsTest
private class ITPR_Test_ITPR { 

    static testMethod void test01(){
    Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(new ITPR__c());
        ITPR itpr = new ITPR(sc);
        List<User> lstUsers = new List<User>();
        String profileName = itpr.userProfileName;
        Id recType = itpr.rectype;
        Boolean v = itpr.getVisibile1();
        v = itpr.getVisibile();
        v = itpr.getVisibile2();
        v = itpr.getVisibile3();
        v = itpr.getVisibile4();
        v = itpr.submitbtn;
        v = itpr.accept;
        v = itpr.pendingmoreinfo;
        v = itpr.pendingbudget;
        v = itpr.onhold;
        v = itpr.reactivate;
        v = itpr.cancel;
        v = itpr.complete1;
        v = itpr.printcoversheet;
        v = itpr.printcoversheet2;
        v = itpr.ExecutedandFiled;
        v = itpr.NotExecutedandClosed;
        v = itpr.ReOpen;
        
        //Get Profile to use for creating users
        Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
        map<string,Id> mapPNames = new map<string,Id>();
         List<profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name ='System Administrator'];
        
        for(Profile p1 : lstProfiles){
    
    mapPNames.put(p1.name, p1.Id);
    
    }
    
        
        //Create Approver 1
        User approver1 = new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'approver1',
             ITPR_Department__c = 'ITSES - Procurement',
            profileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(approver1);
        
         User u1 = new User(Alias = '5sand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='2standarduser35@testorg.com');
      lstUsers.add(u1);
        
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        lstUsers.add(approver3);
        
            User u8 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser50@testorg.com');
      lstUsers.add(u8);
       User u9 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser49@testorg.com');
      lstUsers.add(u9);
       User u10 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser48@testorg.com');
      lstUsers.add(u10);
       User u11 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser47@testorg.com');
      lstUsers.add(u11);
       User u12 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser46@testorg.com');
      lstUsers.add(u12);
       User u13 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser45@testorg.com');
      lstUsers.add(u13);
       User u14 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser44@testorg.com');
      lstUsers.add(u14);
       User u15 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser43@testorg.com');
      lstUsers.add(u15);
       User u16 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser42@testorg.com');
      lstUsers.add(u16);
       User u17 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser41@testorg.com');
      lstUsers.add(u17);
      
      User u18 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser419@testorg.com');
      lstUsers.add(u18);
      User u19 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser418@testorg.com');
      lstUsers.add(u19);
      User u20 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser417@testorg.com');
      lstUsers.add(u20);
      User u21 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser416@testorg.com');
      lstUsers.add(u21);
        
        insert lstUsers;
        
        Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
        
        ITPR__c itpr2 = new ITPR__c(
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
            Finance_Assignee__c = u1.Id,
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
            Status__c = System.Label.ITPR_Pending_More_Info_Needed_Status,
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Submitted_By_Phone_Number__c='2222222222',
            Supplier_Name__c = supplier.Id,
             wave1_approver_2__c = u9.Id,
             wave1_approver_3__c = u10.Id,
             wave1_approver_4__c = u11.Id,
             wave1_approver_5__c = u12.Id,
             wave2_approver_2__c = u13.Id,
             wave2_approver_3__c = u14.Id,
             wave2_approver_4__c = u15.Id,
             wave2_approver_5__c = u16.Id,
             wave3_approver_2__c = u17.Id,
               wave3_approver_5__c = u18.Id,
               wave3_approver_3__c = u19.Id,
          wave3_approver_4__c = u20.Id,
   
            //Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = approver1.Id,
            Wave1_Rejected__c = TRUE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = approver2.Id,
            Wave2_Rejected__c = TRUE,
            Wave3_Approver_1__c = approver3.Id,
            Wave3_Rejected__c = TRUE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver1.Id,
            CAPEX1__c = 100
        );
        
        insert itpr2;
        
       
        
        system.runAs(approver1){
            v = itpr.getVisibile1();
            v = itpr.getVisibile();
            v = itpr.getVisibile2();
            v = itpr.getVisibile3();
            v = itpr.getVisibile4();
            v = itpr.printcoversheet2;
        }
        
        itpr2.Request_Type__c = System.Label.ITPR_Request_Type_RFI;
        update itpr2;
        sc = new ApexPages.StandardController(itpr2);
        itpr = new ITPR(sc);
        
        v = itpr.pendingbudget;
        v = itpr.complete1;
        
        
        Test.stopTest();
    }
    
    static testmethod void test02(){
    List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
    
    
        
      List<USer> lstUsers = new List<User>();  
      
   User u = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'), ITPR_Department__c =  'ITSES - Procurement',
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser34@testorg.com');
      lstUsers.add(u);
      
       User u1 = new User(Alias = '5sand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='2standarduser35@testorg.com');
      lstUsers.add(u1);
    
     User u2 = new User(Alias = '2stat6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='5standarduser36@testorg.com');
      lstUsers.add(u2);
      
      User u3 = new User(Alias = 'stand877', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='7standarduser38@testorg.com');
      lstUsers.add(u3);
      
            User u5 = new User(Alias = '4stadt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='3standarduser39@testorg.com');
      lstUsers.add(u5);
      
       User u6 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser40@testorg.com');
      lstUsers.add(u6);
      User u7 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser348@testorg.com');
      lstUsers.add(u7);
      
      insert lstUsers;
      
    Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
       Test.startTEST();
               ITPR__c itpr = new ITPR__c();
    itpr.Request_Type__c = 'Eval Agreement';
    itpr.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    itpr.category__c = 'Telecom';
    itpr.Organization__c = 'CONA';
    itpr.Supplier_Name__c = supplier.id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    itpr.Supplier_Contact_Phone_Number__c = '9998889898';
    itpr.Submitted_By_Phone_Number__c='2222222222';
    itpr.Engagement_Of_A_New_Supplier__c = 'No';
    itpr.Manager__C = u2.Id;
    itpr.Opportunity_Statement__c = 'test';
    itpr.CAPEX1__c = 200;
    itpr.OPEX1__c = 100;
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 30.0;
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    itpr.Supplier_Contact_email__c = 'test@test.com';
    itpr.Finance_Assignee__c = u1.Id;
    itpr.Addressee_Name__c = 'test';
    itpr.Status__c = 'Draft';
    itpr.Procurement_Assignee__c = u2.id;
    itpr.Vendor_Governance__c = u5.id;
    itpr.Legal_Assignee__c = u6.id;
    itpr.OwnerId = u3.Id; 
    itpr.Submitted_on_behalf_of__c = null;
    itpr.wave2_approver_1__c = u6.Id;
    itpr.wave1_approver_1__c = u2.Id;
    itpr.delegated_Requestor__c = u7.id;
    itpr.transfered_Requestor__c = u7.id;
    
    insert itpr; 
    
         
     ApexPages.currentPage().getParameters().put('id',itpr.id);
          ApexPages.StandardController sc = new ApexPages.StandardController(itpr);
        ITPR controllerObj = new ITPR(sc);
       controllerObj.submit();
        
       
      /*  itpr.status__c = 'In Process';
        update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(itpr);
        ITPR con2 = new ITPR(sc2);
        con2.pendingfinalbudget();
        
        itpr.status__c = 'Cancelled';
        update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc3 = new ApexPages.StandardController(itpr);
        ITPR con3 = new ITPR(sc3);
        con3.reopen();
        
        itpr.status__c = System.Label.ITPR_On_Hold_Status;
        update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc4 = new ApexPages.StandardController(itpr);
        ITPR con4 = new ITPR(sc4);
        con4.reactivate();
        
        itpr.status__c = 'Submitted';
        update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc5 = new ApexPages.StandardController(itpr);
        ITPR con5 = new ITPR(sc5);
        con5.accept();
        
        itpr.status__c = 'All Digital Initials Obtained';
        update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc6 = new ApexPages.StandardController(itpr);
        ITPR con6 = new ITPR(sc6);
        con6.ExecutedAndFiled();*/
        
        test.stopTest();
        }
        
            static testmethod void test03(){
    List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
    
    
        
      List<USer> lstUsers = new List<User>();  
      
   User u = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser34@testorg.com');
      lstUsers.add(u);
      
       User u1 = new User(Alias = '5sand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='2standarduser35@testorg.com');
      lstUsers.add(u1);
    
     User u2 = new User(Alias = '2stat6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='5standarduser36@testorg.com');
      lstUsers.add(u2);
      
      User u3 = new User(Alias = 'stand877', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='7standarduser38@testorg.com');
      lstUsers.add(u3);
      
            User u5 = new User(Alias = '4stadt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='3standarduser39@testorg.com');
      lstUsers.add(u5);
      
       User u6 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser40@testorg.com');
      lstUsers.add(u6);
      
       User u7 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser348@testorg.com');
      lstUsers.add(u7);
      
      User u8 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser50@testorg.com');
      lstUsers.add(u8);
       User u9 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser49@testorg.com');
      lstUsers.add(u9);
       User u10 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser48@testorg.com');
      lstUsers.add(u10);
       User u11 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser47@testorg.com');
      lstUsers.add(u11);
       User u12 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser46@testorg.com');
      lstUsers.add(u12);
       User u13 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser45@testorg.com');
      lstUsers.add(u13);
       User u14 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser44@testorg.com');
      lstUsers.add(u14);
       User u15 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser43@testorg.com');
      lstUsers.add(u15);
       User u16 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser42@testorg.com');
      lstUsers.add(u16);
       User u17 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser41@testorg.com');
      lstUsers.add(u17);
      
       User u18 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser419@testorg.com');
      lstUsers.add(u18);
      User u19 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser418@testorg.com');
      lstUsers.add(u19);
      User u20 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser417@testorg.com');
      lstUsers.add(u20);
      User u21 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser416@testorg.com');
      lstUsers.add(u21);

      
      insert lstUsers;
      
    Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
       Test.startTest();
               ITPR__c itpr = new ITPR__c();
    itpr.Request_Type__c = 'Eval Agreement';
    itpr.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    itpr.category__c = 'Telecom';
    itpr.Organization__c = 'CONA';
    itpr.Supplier_Name__c = supplier.id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    itpr.Supplier_Contact_Phone_Number__c = '9998889898';
    itpr.Submitted_By_Phone_Number__c='2222222222';
    itpr.Engagement_Of_A_New_Supplier__c = 'No';
    itpr.Manager__C = u2.Id;
    itpr.Opportunity_Statement__c = 'test';
    itpr.CAPEX1__c = 200;
    itpr.OPEX1__c = 100;
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 30.0;
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    itpr.Supplier_Contact_email__c = 'test@test.com';
    itpr.Finance_Assignee__c = u1.Id;
    itpr.Addressee_Name__c = 'test';
    itpr.Status__c = 'Draft';
    itpr.Procurement_Assignee__c = u2.id;
    itpr.Vendor_Governance__c = u5.id;
    itpr.Legal_Assignee__c = u6.id;
    itpr.OwnerId = u3.Id; 
    itpr.Submitted_on_behalf_of__c = null;
    itpr.wave2_approver_1__c = u6.Id;
    itpr.wave1_approver_1__c = u2.Id;
    itpr.delegated_Requestor__c = u7.id;
    itpr.transfered_Requestor__c = u7.id;
    itpr.Wave1_Rejected__c = TRUE;
    itpr.Wave2_Rejected__c = TRUE;
    itpr.Wave3_Rejected__c = TRUE;
     itpr.wave1_approver_2__c = u9.Id;
    itpr.wave1_approver_3__c = u10.Id;
    itpr.wave1_approver_4__c = u11.Id;
    itpr.wave1_approver_5__c = u12.Id;
    itpr.wave2_approver_2__c = u13.Id;
    itpr.wave2_approver_3__c = u14.Id;
    itpr.wave2_approver_4__c = u15.Id;
    itpr.wave2_approver_5__c = u16.Id;
    itpr.wave3_approver_1__c = u17.Id;
    itpr.wave3_approver_2__c = u18.Id;
    itpr.wave3_approver_3__c = u19.Id;
    itpr.wave3_approver_4__c = u20.Id;
    itpr.wave3_approver_5__c = u21.Id;
    insert itpr; 
    
        itpr.Status__c = 'In Process';
         update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(itpr);
        ITPR con2 = new ITPR(sc2);
        con2.pendingfinalbudget();
        
        
        test.stopTest();
        }
        
            static testmethod void test04(){
    List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
    
     
        
      List<USer> lstUsers = new List<User>();  
      
   User u = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'), ITPR_Department__c =  'ITSES - Procurement',
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser34@testorg.com');
      lstUsers.add(u);
      
       User u1 = new User(Alias = '5sand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='2standarduser35@testorg.com');
      lstUsers.add(u1);
    
     User u2 = new User(Alias = '2stat6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='5standarduser36@testorg.com');
      lstUsers.add(u2);
      
      User u3 = new User(Alias = 'stand877', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='7standarduser38@testorg.com');
      lstUsers.add(u3);
      
            User u5 = new User(Alias = '4stadt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='3standarduser39@testorg.com');
      lstUsers.add(u5);
      
       User u6 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser40@testorg.com');
      lstUsers.add(u6);
      
       User u7 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser348@testorg.com');
      lstUsers.add(u7);
      
      insert lstUsers;
      
    Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
       Test.startTest();
               ITPR__c itpr = new ITPR__c();
    itpr.Request_Type__c = 'Eval Agreement';
    itpr.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    itpr.category__c = 'Telecom';
    itpr.Organization__c = 'CONA';
    itpr.Supplier_Name__c = supplier.id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    itpr.Supplier_Contact_Phone_Number__c = '9998889898';
    itpr.Engagement_Of_A_New_Supplier__c = 'No';
    itpr.Manager__C = u2.Id;
    itpr.Opportunity_Statement__c = 'test';
    itpr.Submitted_By_Phone_Number__c='2222222222';
    itpr.CAPEX1__c = 200;
    itpr.OPEX1__c = 100;
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 30.0;
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    itpr.Supplier_Contact_email__c = 'test@test.com';
    itpr.Finance_Assignee__c = u1.Id;
    itpr.Addressee_Name__c = 'test';
    itpr.Status__c = 'Draft';
    itpr.Procurement_Assignee__c = u2.id;
    itpr.Vendor_Governance__c = u5.id;
    itpr.Legal_Assignee__c = u6.id;
    itpr.OwnerId = u3.Id; 
    itpr.Submitted_on_behalf_of__c = null;
   itpr.wave2_approver_1__c = u6.Id;
    itpr.wave1_approver_1__c = u.Id;
    itpr.delegated_Requestor__c = u7.id;
    itpr.transfered_Requestor__c = u7.id;
    insert itpr; 
    
       

        
        itpr.status__c = 'Cancelled';
        update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc3 = new ApexPages.StandardController(itpr);
        ITPR con3 = new ITPR(sc3);
        con3.reopen();
        

        
        test.stopTest();
        }
   
       static testmethod void test05(){
    List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
    
    
        
      List<USer> lstUsers = new List<User>();  
      
   User u = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser34@testorg.com');
      lstUsers.add(u);
      
       User u1 = new User(Alias = '5sand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='2standarduser35@testorg.com');
      lstUsers.add(u1);
    
     User u2 = new User(Alias = '2stat6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='5standarduser36@testorg.com');
      lstUsers.add(u2);
      
      User u3 = new User(Alias = 'stand877', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='7standarduser38@testorg.com');
      lstUsers.add(u3);
      
            User u5 = new User(Alias = '4stadt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='3standarduser39@testorg.com');
      lstUsers.add(u5);
      
       User u6 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser40@testorg.com');
      lstUsers.add(u6);
      
       User u7 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser348@testorg.com');
      lstUsers.add(u7);
      
      insert lstUsers;
      
    Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
       Test.startTest();
               ITPR__c itpr = new ITPR__c();
    itpr.Request_Type__c = 'Eval Agreement';
    itpr.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    itpr.category__c = 'Telecom';
    itpr.Organization__c = 'CONA';
    itpr.Supplier_Name__c = supplier.id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    itpr.Supplier_Contact_Phone_Number__c = '9998889898';
    itpr.Submitted_By_Phone_Number__c='2222222222';
    itpr.Engagement_Of_A_New_Supplier__c = 'No';
    itpr.Manager__C = u2.Id;
    itpr.Opportunity_Statement__c = 'test';
    itpr.CAPEX1__c = 200;
    itpr.OPEX1__c = 100;
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 30.0;
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    itpr.Supplier_Contact_email__c = 'test@test.com';
    itpr.Finance_Assignee__c = u1.Id;
    itpr.Addressee_Name__c = 'test';
    itpr.Status__c = 'Draft';
    itpr.Procurement_Assignee__c = u2.id;
    itpr.Vendor_Governance__c = u5.id;
    itpr.Legal_Assignee__c = u6.id;
    itpr.OwnerId = u3.Id; 
    itpr.Submitted_on_behalf_of__c = null;
    itpr.wave2_approver_1__c = u6.Id;
    itpr.wave1_approver_1__c = u2.Id;
    itpr.delegated_Requestor__c = u7.id;
    itpr.transfered_Requestor__c = u7.id;
    insert itpr; 
    
        
     
      
        itpr.status__c = System.Label.ITPR_On_Hold_Status;
        update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc4 = new ApexPages.StandardController(itpr);
        ITPR con4 = new ITPR(sc4);
        con4.reactivate();
        
        
        
        test.stopTest();
        }
        
            static testmethod void test06(){
    List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
    
    
        
      List<USer> lstUsers = new List<User>();  
      
   User u = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser34@testorg.com');
      lstUsers.add(u);
      
       User u1 = new User(Alias = '5sand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='2standarduser35@testorg.com');
      lstUsers.add(u1);
    
     User u2 = new User(Alias = '2stat6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'), ITPR_Department__c =  'ITSES - Procurement',
      TimeZoneSidKey='America/Los_Angeles', UserName='5standarduser36@testorg.com');
      lstUsers.add(u2);
      
      User u3 = new User(Alias = 'stand877', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='7standarduser38@testorg.com');
      lstUsers.add(u3);
      
            User u5 = new User(Alias = '4stadt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='3standarduser39@testorg.com');
      lstUsers.add(u5);
      
       User u6 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser40@testorg.com');
      lstUsers.add(u6);
      
       User u7 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser348@testorg.com');
      lstUsers.add(u7);
      
      User u29 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser448@testorg.com');
      lstUsers.add(u29);
      
      User u8 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser50@testorg.com');
      lstUsers.add(u8);
       User u9 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser49@testorg.com');
      lstUsers.add(u9);
       User u10 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser48@testorg.com');
      lstUsers.add(u10);
       User u11 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser47@testorg.com');
      lstUsers.add(u11);
       User u12 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser46@testorg.com');
      lstUsers.add(u12);
       User u13 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser45@testorg.com');
      lstUsers.add(u13);
       User u14 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser44@testorg.com');
      lstUsers.add(u14);
       User u15 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser43@testorg.com');
      lstUsers.add(u15);
       User u16 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser42@testorg.com');
      lstUsers.add(u16);
       User u17 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser41@testorg.com');
      lstUsers.add(u17);
      
       User u18 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser419@testorg.com');
      lstUsers.add(u18);
      User u19 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser418@testorg.com');
      lstUsers.add(u19);
      User u20 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser417@testorg.com');
      lstUsers.add(u20);
      User u21 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser416@testorg.com');
      lstUsers.add(u21);
      
      insert lstUsers;
      
    Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
       Test.startTest();
               ITPR__c itpr = new ITPR__c();
    itpr.Request_Type__c = 'Eval Agreement';
    itpr.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    itpr.category__c = 'Telecom';
    itpr.Organization__c = 'CONA';
    itpr.Supplier_Name__c = supplier.id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    itpr.Supplier_Contact_Phone_Number__c = '9998889898';
    itpr.Submitted_By_Phone_Number__c='2222222222';
    itpr.Engagement_Of_A_New_Supplier__c = 'No';
    itpr.Manager__C = u2.Id;
    itpr.Opportunity_Statement__c = 'test';
    itpr.CAPEX1__c = 200;
    itpr.OPEX1__c = 100;
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 30.0;
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    itpr.Supplier_Contact_email__c = 'test@test.com';
    itpr.Finance_Assignee__c = u1.Id;
    itpr.Addressee_Name__c = 'test';
    itpr.Status__c = 'Draft';
    itpr.Procurement_Assignee__c = u2.id;
    itpr.Vendor_Governance__c = u5.id;
    itpr.Legal_Assignee__c = u6.id;
    itpr.OwnerId = u3.Id; 
    itpr.Submitted_on_behalf_of__c = u29.Id;
    itpr.wave2_approver_1__c = u6.Id;
    itpr.wave1_approver_1__c = u2.Id;
    itpr.delegated_Requestor__c = u7.id;
    itpr.transfered_Requestor__c = u7.id;
    itpr.wave1_approver_2__c = u9.Id;
    itpr.wave1_approver_3__c = u10.Id;
    itpr.wave1_approver_4__c = u11.Id;
    itpr.wave1_approver_5__c = u12.Id;
    itpr.wave2_approver_2__c = u13.Id;
    itpr.wave2_approver_3__c = u14.Id;
    itpr.wave2_approver_4__c = u15.Id;
    itpr.wave2_approver_5__c = u16.Id;
    itpr.wave3_approver_1__c = u17.Id;
    itpr.wave3_approver_2__c = u18.Id;
    itpr.wave3_approver_3__c = u19.Id;
    itpr.wave3_approver_4__c = u20.Id;
    itpr.wave3_approver_5__c = u21.Id;
    insert itpr; 
    
         
        
        itpr.status__c = 'Submitted';
        update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc5 = new ApexPages.StandardController(itpr);
        ITPR con5 = new ITPR(sc5);
        con5.accept();
        
        
        
        test.stopTest();
        }
        
            static testmethod void test07(){
    List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
    
    
        
      List<USer> lstUsers = new List<User>();  
      
   User u = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser34@testorg.com');
      lstUsers.add(u);
      
       User u1 = new User(Alias = '5sand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='2standarduser35@testorg.com');
      lstUsers.add(u1);
    
     User u2 = new User(Alias = '2stat6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='5standarduser36@testorg.com');
      lstUsers.add(u2);
      
      User u3 = new User(Alias = 'stand877', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='7standarduser38@testorg.com');
      lstUsers.add(u3);
      
            User u5 = new User(Alias = '4stadt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='3standarduser39@testorg.com');
      lstUsers.add(u5);
      
       User u6 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser51@testorg.com');
      lstUsers.add(u6);
      
       User u7 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser350@testorg.com');
      lstUsers.add(u7);
      
      User u29 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser358@testorg.com');
      lstUsers.add(u29);
      
       User u8 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser40@testorg.com');
      lstUsers.add(u8);
       User u9 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser49@testorg.com');
      lstUsers.add(u9);
       User u10 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser48@testorg.com');
      lstUsers.add(u10);
       User u11 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser47@testorg.com');
      lstUsers.add(u11);
       User u12 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser46@testorg.com');
      lstUsers.add(u12);
       User u13 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser45@testorg.com');
      lstUsers.add(u13);
       User u14 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser44@testorg.com');
      lstUsers.add(u14);
       User u15 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser43@testorg.com');
      lstUsers.add(u15);
       User u16 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser42@testorg.com');
      lstUsers.add(u16);
       User u17 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser41@testorg.com');
      lstUsers.add(u17);
      
      User u18 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser419@testorg.com');
      lstUsers.add(u18);
      User u19 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser418@testorg.com');
      lstUsers.add(u19);
      User u20 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser417@testorg.com');
      lstUsers.add(u20);
      User u21 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser416@testorg.com');
      lstUsers.add(u21);
      
      insert lstUsers;
      
    Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
       
       Test.startTest(); 
               ITPR__c itpr = new ITPR__c();
    itpr.Request_Type__c = 'Eval Agreement';
    itpr.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    itpr.category__c = 'Telecom';
    itpr.Organization__c = 'CONA';
    itpr.Supplier_Name__c = supplier.id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    itpr.Supplier_Contact_Phone_Number__c = '9998889898';
        itpr.Submitted_By_Phone_Number__c='2222222222';
    itpr.Engagement_Of_A_New_Supplier__c = 'No';
    itpr.Manager__C = u2.Id;
    itpr.Opportunity_Statement__c = 'test';
    itpr.CAPEX1__c = 200;
    itpr.OPEX1__c = 100;
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 30.0;
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    itpr.Supplier_Contact_email__c = 'test@test.com';
    itpr.Finance_Assignee__c = u1.Id;
    itpr.Addressee_Name__c = 'test';
    itpr.Status__c = 'Draft';
    itpr.Procurement_Assignee__c = u2.id;
    itpr.Vendor_Governance__c = u5.id;
    itpr.Legal_Assignee__c = u6.id;
    itpr.OwnerId = u3.Id; 
    itpr.Submitted_on_behalf_of__c = u29.Id;
    itpr.wave2_approver_1__c = u6.Id;
    itpr.wave1_approver_1__c = u2.Id;
    itpr.wave1_approver_2__c = u9.Id;
    itpr.wave1_approver_3__c = u10.Id;
    itpr.wave1_approver_4__c = u11.Id;
    itpr.wave1_approver_5__c = u12.Id;
    itpr.wave2_approver_2__c = u13.Id;
    itpr.wave2_approver_3__c = u14.Id;
    itpr.wave2_approver_4__c = u15.Id;
    itpr.wave2_approver_5__c = u16.Id;
    itpr.wave3_approver_1__c = u17.Id;
    itpr.wave3_approver_2__c = u18.Id;
    itpr.wave3_approver_3__c = u19.Id;
    itpr.wave3_approver_4__c = u20.Id;
    itpr.wave3_approver_5__c = u21.Id;
    itpr.delegated_Requestor__c = u7.id;
    itpr.transfered_Requestor__c = u7.id;
    insert itpr; 
    
        
     
        itpr.status__c = 'All Digital Initials Obtained';
        update itpr;
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc6 = new ApexPages.StandardController(itpr);
        ITPR con6 = new ITPR(sc6);
        con6.ExecutedAndFiled();
        
        test.stopTest();
        }
        
         //Added by Ravi Alok for story #28
     static testmethod void test08()
            
    {
    List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
      List<USer> lstUsers = new List<User>();  
      
      User u = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser34@testorg.com');
      lstUsers.add(u);
      
      User u1 = new User(Alias = '5sand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='2standarduser35@testorg.com');
      lstUsers.add(u1);
    
      User u2 = new User(Alias = '2stat6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='5standarduser36@testorg.com');
      lstUsers.add(u2);
      
      User u3 = new User(Alias = 'stand877', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='7standarduser38@testorg.com');
      lstUsers.add(u3);
      
      User u5 = new User(Alias = '4stadt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='3standarduser39@testorg.com');
      lstUsers.add(u5);
      
      User u6 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser51@testorg.com');
      lstUsers.add(u6);
      
      User u7 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser350@testorg.com');
      lstUsers.add(u7);
      
      User u29 = new User(Alias = '5andt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='1standarduser358@testorg.com');
      lstUsers.add(u29);
      
       User u8 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser40@testorg.com');
      lstUsers.add(u8);
      
      User u9 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser49@testorg.com');
      lstUsers.add(u9);
      
      User u10 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser48@testorg.com');
      lstUsers.add(u10);
      
      User u11 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser47@testorg.com');
      lstUsers.add(u11);
      
      User u12 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser46@testorg.com');
      lstUsers.add(u12);
      
      User u13 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser45@testorg.com');
      lstUsers.add(u13);
      
      User u14 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser44@testorg.com');
      lstUsers.add(u14);
      
      User u15 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser43@testorg.com');
      lstUsers.add(u15);
      
      User u16 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser42@testorg.com');
      lstUsers.add(u16);
      
      User u17 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser41@testorg.com');
      lstUsers.add(u17);
      
      User u18 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser419@testorg.com');
      lstUsers.add(u18);
      
      User u19 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser418@testorg.com');
      lstUsers.add(u19);
      
      User u20 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser417@testorg.com');
      lstUsers.add(u20);
      
      User u21 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser416@testorg.com');
      lstUsers.add(u21);
      
      insert lstUsers;
      
      Account supplier = new Account(Name = 'TestSupplier');
      insert supplier;
       
       Test.startTest(); 
       
    ITPR__c itpr = new ITPR__c();
    itpr.Request_Type__c = 'NDA';
    itpr.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    itpr.category__c = 'Telecom';
    itpr.Organization__c = 'CONA';
    itpr.Supplier_Name__c = supplier.id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    itpr.Supplier_Contact_Phone_Number__c = '9998889898';
       itpr.Submitted_By_Phone_Number__c='2222222222';
    itpr.Engagement_Of_A_New_Supplier__c = 'No';
    itpr.Manager__C = u2.Id;
    itpr.Opportunity_Statement__c = 'test';
    itpr.CAPEX1__c = 200;
    itpr.OPEX1__c = 100;
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 30.0;
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    itpr.Supplier_Contact_email__c = 'test@test.com';
    itpr.Finance_Assignee__c = u1.Id;
    itpr.Addressee_Name__c = 'test';
    itpr.Status__c = 'Draft';
    itpr.Procurement_Assignee__c = u2.id;
    itpr.Vendor_Governance__c = u5.id;
    itpr.Legal_Assignee__c = u6.id;
    itpr.OwnerId = u3.Id; 
    itpr.Submitted_on_behalf_of__c = u29.Id;
    itpr.State_Or_Country_Of_Formation__c = 'test';
    itpr.Who_Will_Be_Disclosing_Information__c = 'TCCC Entity Only';
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';
    itpr.Supplier_s_Legal_Entity_Name__c = 'Test';
    itpr.Supplier_Physical_Address__c = 'Test Address';
    itpr.Type_Of_Information__c = 'test';
    itpr.Addressee_Name__c = 'Test';

    itpr.wave1_approver_1__c = u.Id;
    itpr.wave1_approver_2__c = u9.Id;
    itpr.wave1_approver_3__c = u10.Id;
    itpr.wave1_approver_4__c = u11.Id;

    
    itpr.wave2_approver_1__c = u12.Id;
    itpr.wave2_approver_2__c = u13.Id;
    itpr.wave2_approver_3__c = u14.Id;
    itpr.wave2_approver_4__c = u15.Id;

    
    itpr.wave3_approver_1__c = u17.Id;
    itpr.wave3_approver_2__c = u18.Id;
    itpr.wave3_approver_3__c = u19.Id;
    itpr.wave3_approver_4__c = u20.Id;

    itpr.delegated_Requestor__c = u7.id;
    itpr.transfered_Requestor__c = u7.id;
    
    itpr.Additional_Approver_1__c = null;
    itpr.Additional_Approver_2__c = null;
    itpr.Additional_Approver_3__c = null;
    itpr.status__c = 'All Digital Initials Obtained';
    itpr.Wave1_Approved__c = TRUE;
    itpr.Wave2_Approved__c = TRUE;
    itpr.Additional_Approval_Complete__c = FALSE;
    itpr.Do_you_want_additional_approver__c = TRUE;
    itpr.Additional_Approval_Complete__c = FALSE;
    
    insert itpr; 
    
      System.assertEquals(itpr.Additional_Approver_1__c, null);
      System.assertEquals(itpr.Additional_Approver_2__c, null);
      System.assertEquals(itpr.Additional_Approver_3__c, null);   

        itpr.Additional_Approver_1__c = u12.Id;
        itpr.Additional_Approver_2__c = u16.Id;
        itpr.Additional_Approver_3__c = u21.Id;   
     
        update itpr;
        
        ApexPages.currentPage().getParameters().put('id',itpr.id);
        ApexPages.StandardController sc6 = new ApexPages.StandardController(itpr);
        ITPR con6 = new ITPR(sc6);
        con6.saveApprovers();
        
      System.assertNotEquals(itpr.Additional_Approver_1__c, null);
      System.assertNotEquals(itpr.Additional_Approver_2__c, null);
      System.assertNotEquals(itpr.Additional_Approver_3__c, null);
        
        test.stopTest();
    }

}