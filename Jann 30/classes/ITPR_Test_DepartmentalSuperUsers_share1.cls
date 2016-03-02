@Istest
public class ITPR_Test_DepartmentalSuperUsers_share1 {
  
  static testmethod void test01()
  {
  Test.startTest();  
  List<User> lstUsers = new List<User>();
  //Get Profile to use for creating users        
  Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
  List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name = 'System Administrator']; 
  Map<String,String> mapPNames = new Map<String, String>();
  
  if(lstProfiles != null && lstProfiles.size() > 0) 
   {
    for(Profile p1 : lstProfiles )
    {
     mapPNames.put(p1.name,p1.Id); 
    }   
   }  

//Create Approver 1        
User approver1 = new User
           ( 
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
           
            User approver2 = approver1.clone();       
            approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';        
            lstUsers.add(approver2); 
            
            User approver3 = approver1.clone();        
            approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';        
            lstUsers.add(approver3);
            
            User u8 = new User(Alias = '3stant5', Email='standarduser1@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser50@testorg.com');      
            lstUsers.add(u8);  
            
            User u9 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Finance'),
            ITPR_Department__c =  'ITSES - Finance',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser49@testorg.com');      
            lstUsers.add(u9);       
            
            User u10 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',      
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser48@testorg.com');      
            lstUsers.add(u10);       
            
            User u11 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Vendor Governance'),
            ITPR_Department__c =  'ITSES - Vendor Governance',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser47@testorg.com');      
            lstUsers.add(u11);       
            
            User u12 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser46@testorg.com');      
            lstUsers.add(u12);       
            
            User u13 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser45@testorg.com');      
            lstUsers.add(u13);       
            
            User u14 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',      
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser44@testorg.com');      
            lstUsers.add(u14);       
            
            User u15 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Legal'), 
            ITPR_Department__c =  'ITSES - Legal',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser43@testorg.com');      
            lstUsers.add(u15);       
            
            
            User u16 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Requestor'),
            ITPR_Department__c =  'ITSES - Requestor',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser42@testorg.com');      
            lstUsers.add(u16);       
            
            User u17 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Finance'),
            ITPR_Department__c =  'ITSES - Finance',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser41@testorg.com');      
            lstUsers.add(u17);            
            
            User u18 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser419@testorg.com');      
            lstUsers.add(u18);      
            
            User u19 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',       
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser418@testorg.com');      
            lstUsers.add(u19);      
            
            User u20 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Finance'), 
            ITPR_Department__c =  'ITSES - Finance',      
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser417@testorg.com');      
            lstUsers.add(u20);      
            
            User u21 = new User(Alias = '3stant5', 
            Email='standarduser1@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Procurement'), 
            ITPR_Department__c =  'ITSES - Procurement',      
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser416@testorg.com');      
            lstUsers.add(u21);  
            
            User u22 = new User(Alias = '3stant52', 
            Email='standarduser152@testorg.com',       
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',       
            LocaleSidKey='en_US', 
            ProfileId = mapPNames.get('ITSES - Vendor Governance'), 
            ITPR_Department__c =  'ITSES - Vendor Governance',      
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='4standarduser4162@testorg.com');      
            lstUsers.add(u22);                
            
            insert lstUsers;
    system.debug('~~~~~'+lstUsers);
            
            Account supplier = new Account(Name = 'TestSupplier');        
            insert supplier;
            
        ITPR__c itpr1 = new ITPR__c
        (

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
        //Finance_Assignee__c = approver1.Id,
        If_Yes_Explain1__c = 'test',
        If_Yes_Explain2__c = 'test',
        If_Yes_Explain3__c = 'test',
        If_yes_Explain4__c = 'test',
        //Legal_Assignee__c = approver2.Id,
        Organization__c = 'CONA',
        Primary_Assignee__c = 'Jackie Wang',
        ownerId = u20.Id,
        Procurement_Assignee__c = approver1.Id,
        Legal_Assignee__c = u8.Id,
        Finance_Assignee__c = u9.Id,
        Vendor_Governance__c = u22.Id,

        Request_Type__c = 'New Master',
        Standard_Indemnifications_Including_IP__c = 'Yes',
        Standard_Representations_Warranties__c = 'Yes',
        //Status__c = System.Label.ITPR_Pending_More_Info_Needed_Status,
        Status__c ='On Hold',
        Supplier_Contact_Email__c = 'test@infy.com',
        Supplier_Contact_Name__c = 'test',
        Supplier_Contact_Phone_Number__c = '1111111111',
        Supplier_Name__c = supplier.Id,
        Submitted_By_Phone_Number__c = '1111111112',


        Wave1_Approver_1__c = approver1.Id,
        wave1_approver_2__c = u11.Id,
        wave1_approver_3__c = u12.Id,
            
        Wave2_Approver_1__c = approver2.Id,
        wave2_approver_2__c = u13.Id,
        wave2_approver_3__c = u14.Id,

        Wave3_Approver_1__c = approver3.Id,
        wave3_approver_2__c = u17.Id,
        wave3_approver_3__c = u18.Id,
        //Wave1_Approved__c = FALSE,
        //Wave1_Rejected__c = TRUE,
        //Wave2_Approved__c = FALSE,
        //Wave2_Rejected__c = TRUE,
        //Wave3_Rejected__c = TRUE,
        Will_Supplier_Retain_Rights_To_New_IP__c = 'No',
        //ownerId = u20.Id,
        CAPEX1__c = 100        
        );
        insert itpr1; 
      
          ITPR__c itpr2 = new ITPR__c
        (

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
        //Finance_Assignee__c = approver1.Id,
        If_Yes_Explain1__c = 'test',
        If_Yes_Explain2__c = 'test',
        If_Yes_Explain3__c = 'test',
        If_yes_Explain4__c = 'test',
        //Legal_Assignee__c = approver2.Id,
        Organization__c = 'CONA',
        Primary_Assignee__c = 'Jackie Wang',
        ownerId = u20.Id,
        Procurement_Assignee__c = approver1.Id,
        Legal_Assignee__c = u8.Id,
        Finance_Assignee__c = u9.Id,
        Vendor_Governance__c = u22.Id,

        Request_Type__c = 'New Master',
        Standard_Indemnifications_Including_IP__c = 'Yes',
        Standard_Representations_Warranties__c = 'Yes',
        //Status__c = System.Label.ITPR_Pending_More_Info_Needed_Status,
        Status__c ='Pending Project Final Budget',
        Supplier_Contact_Email__c = 'test@infy.com',
        Supplier_Contact_Name__c = 'test',
        Supplier_Contact_Phone_Number__c = '1111111111',
        Supplier_Name__c = supplier.Id,
        Submitted_By_Phone_Number__c = '1111111112',


        Wave1_Approver_1__c = approver1.Id,
        wave1_approver_2__c = u11.Id,
        wave1_approver_3__c = u12.Id,
            
        Wave2_Approver_1__c = approver2.Id,
        wave2_approver_2__c = u13.Id,
        wave2_approver_3__c = u14.Id,

        Wave3_Approver_1__c = approver3.Id,
        wave3_approver_2__c = u17.Id,
        wave3_approver_3__c = u18.Id,
        //Wave1_Approved__c = FALSE,
        //Wave1_Rejected__c = TRUE,
        //Wave2_Approved__c = FALSE,
        //Wave2_Rejected__c = TRUE,
        //Wave3_Rejected__c = TRUE,
        Will_Supplier_Retain_Rights_To_New_IP__c = 'No',
        //ownerId = u20.Id,
        CAPEX1__c = 100        
        );
        
        List<DepartmentalSuperUser__c> lstDSU = new List<DepartmentalSuperUser__c >();
                 
        DepartmentalSuperUser__c dsu1 =new DepartmentalSuperUser__c
        (         
    
        From_user__c = u15.Id,        
        Viewer1__c = u14.Id,
        Viewer2__c = u13.Id,        
        Viewer3__c = u16.Id,        
        Viewer4__c = u22.Id,        
        Viewer5__c = u14.Id,        
        Type_of_Access_1__c='Read/Edit',        
        Type_of_Access_2__c='Read/Edit',        
        Type_of_Access_3__c='Read/Edit',        
        Type_of_Access_4__c='Read/Edit',        
        Type_of_Access_5__c='Read/Edit', 
        OwnerId = u8.Id //usLS[0].id 

          ); 
          
        lstDSU.add(dsu1) ; 
        System.debug('OwnerId = u15.id'+u15.Id);
        
        DepartmentalSuperUser__c dsu2 =new DepartmentalSuperUser__c
        (         
        From_user__c = u9.Id,        
        Viewer1__c = u17.Id,
        Viewer2__c = u17.Id,        
        Viewer3__c = u17.Id,        
        Viewer4__c = u17.Id,        
        Viewer5__c = u17.Id,        
        Type_of_Access_1__c='Read/Edit',        
        Type_of_Access_2__c='Read/Edit',        
        Type_of_Access_3__c='Read/Edit',        
        Type_of_Access_4__c='Read/Edit',        
        Type_of_Access_5__c='Read/Edit', 
        OwnerId = u9.Id //usLS[0].id 
          ); 
        //insert dsu2 ;
        lstDSU.add(dsu2); 
        System.debug('OwnerId = u9.id'+u9.Id);
    
    DepartmentalSuperUser__c dsu3 =new DepartmentalSuperUser__c
        (         
        From_user__c = u11.Id,        
        Viewer1__c = u22.Id,        
        Viewer2__c = u16.Id,        
        Viewer3__c = u20.Id,        
        Viewer4__c = u21.Id,        
        Viewer5__c = u17.Id,        
        Type_of_Access_1__c='Read/Edit',        
        Type_of_Access_2__c='Read/Edit',        
        Type_of_Access_3__c='Read/Edit',        
        Type_of_Access_4__c='Read/Edit',        
        Type_of_Access_5__c='Read/Edit' ,
         OwnerId = u22.Id  
        );    
        lstDSU.add(dsu3);
        
DepartmentalSuperUser__c dsu4 =new DepartmentalSuperUser__c
        (         
        From_user__c = approver1.Id,        
        Viewer1__c = approver2.Id,        
        Viewer2__c = approver2.Id,        
        Viewer3__c = approver2.Id,        
        Viewer4__c = approver2.Id,        
        Viewer5__c = approver2.Id,        
        Type_of_Access_1__c='Read/Edit',        
        Type_of_Access_2__c='Read/Edit',        
        Type_of_Access_3__c='Read/Edit',        
        Type_of_Access_4__c='Read/Edit',        
        Type_of_Access_5__c='Read/Edit' ,
         OwnerId = u21.Id  
        );    
        lstDSU.add(dsu4) ;       
        
DepartmentalSuperUser__c dsu5 =new DepartmentalSuperUser__c
        (         
        From_user__c = u20.Id,        
        Viewer1__c = u16.Id,        
        Viewer2__c = u16.Id,        
        Viewer3__c = u16.Id,        
        Viewer4__c = u16.Id,        
        Viewer5__c = u16.Id,        
        Type_of_Access_1__c='Read/Edit',        
        Type_of_Access_2__c='Read/Edit',        
        Type_of_Access_3__c='Read/Edit',        
        Type_of_Access_4__c='Read/Edit',        
        Type_of_Access_5__c='Read/Edit' ,
         OwnerId = approver1.Id  
        );    
       lstDSU.add(dsu5) ;           
    
        DepartmentalSuperUser__c dsu6 =new DepartmentalSuperUser__c
        (         
        From_user__c = u22.Id,        
        Viewer1__c = u11.Id,        
        Viewer2__c = u11.Id,        
        Viewer3__c = u11.Id,        
        Viewer4__c = u11.Id,        
        Viewer5__c = u11.Id,        
        Type_of_Access_1__c='Read/Edit',        
        Type_of_Access_2__c='Read/Edit',        
        Type_of_Access_3__c='Read/Edit',        
        Type_of_Access_4__c='Read/Edit',        
        Type_of_Access_5__c='Read/Edit' ,
         OwnerId = u22.Id  
        );    
        lstDSU.add(dsu6) ; 
    
        //DepartmentalSuperUser__c dsurecords = [select id,Viewer1__c,Viewer2__c,Viewer3__c,Viewer4__c,Viewer5__c,Type_of_Access_1__c,Type_of_Access_2__c,Type_of_Access_3__c,Type_of_Access_4__c,Type_of_Access_5__c,Additional_Access_1_Department__c,Additional_Access_2_Department__c,Additional_Access_3_Department__c,Additional_Access_4_Department__c,Additional_Access_5_Department__c from DepartmentalSuperUser__c];// where From_user__c := u15.Id];
        //system.debug('dsurecords...'+dsurecords);
        
        List<ITPR__Share> lstITPRShare = new List<ITPR__Share>(); 
        ITPR_DepartmentalSuperUsers_share1 dsu_m = new ITPR_DepartmentalSuperUsers_share1();        
        
      dsu_m.DSU_ITPR_Share(lstDSU);
      
        Test.stopTest();

 }
  
     
}