@isTest
private class ITPR_Test_AutomateAssignee 
{

static testMethod void populateAssignee3() 
    {
    Test.startTest();
    
    List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
      ITPR__c lt9 = new ITPR__c();
  
      List<User> lstUsers = new List<User>();

      User u = new User(Alias = 'standt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'), ITPR_Department__c =  'ITSES - Requestor',
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser34@testorg.com');
      lstUsers.add(u);

      User u1 = new User(Alias = 'stand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser35@testorg.com');
      lstUsers.add(u1);

      User u5 = new User(Alias = 'standt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser39@testorg.com');
      lstUsers.add(u5);

       User u6 = new User(Alias = 'standt5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser40@testorg.com');
      lstUsers.add(u6);

      User u2 = new User(Alias = 'standt6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser36@testorg.com');
      lstUsers.add(u2);

      User u3 = new User(Alias = 'standt77', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser38@testorg.com');
      lstUsers.add(u3);

    insert lstUsers;
      
    Account acc = new Account();
    acc.Name = 'Infosys';
    acc.RecordTypeId  = ITPR_Test_AutomateAssignee.getRecordTypeId('Account', 'IT-SES');
    acc.OwnerID=u.Id;
    system.debug ('rsas value of getRTID ' + acc.RecordTypeId);
    insert acc;
    
      
      
      System.runAs(u) {
      ITPR__c lt5 = new ITPR__c();
      lt5.Request_Type__c = 'Other Legal';
    lt5.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    lt5.category__c = 'Telecom';
    lt5.Organization__c = 'CONA';
    lt5.Supplier_Name__c = acc.id;
    lt5.Supplier_Contact_Name__c = 'test';
    lt5.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    lt5.Supplier_Contact_Phone_Number__c = '9998889898';
    lt5.Engagement_Of_A_New_Supplier__c = 'No';
    lt5.Manager__C = u2.Id;
    lt5.Opportunity_Statement__c = 'test';
    lt5.CAPEX1__c = 200;
    lt5.OPEX1__c = 100;
    lt5.Supplier_s_Legal_Entity_Name__c = 'test';
    lt5.Duration_Of_NDA__c = 30.0;
    lt5.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    lt5.Supplier_Contact_email__c = 'test@test.com';
    lt5.Finance_Assignee__c = u1.Id;
    lt5.Addressee_Name__c = 'test';
    lt5.Status__c = 'Draft';
    lt5.Procurement_Assignee__c = null;
    lt5.Vendor_Governance__c = u5.id;
    lt5.Legal_Assignee__c = u6.id;
    lt5.OwnerId = u3.Id;
    lt5.Wave2_Approver_1__c = u6.id; 
    lt5.Submitted_on_behalf_of__c = null;

    insert lt5; 

  }
  Test.stopTest();
  }
  
  
   static testMethod void populateAssignee5() 
    {
      Test.startTest();
      ITPR__c lt9 = new ITPR__c();

     List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }
      
  
        List<User> lstUsers = new List<User>();

      User u = new User(Alias = 'standt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser34@testorg.com');
      lstUsers.add(u);

      User u1 = new User(Alias = 'stand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser35@testorg.com');
      lstUsers.add(u1);

      User u5 = new User(Alias = 'standt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser39@testorg.com');
      lstUsers.add(u5);

       User u6 = new User(Alias = 'standt5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser40@testorg.com');
      lstUsers.add(u6);

      User u2 = new User(Alias = 'standt6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser36@testorg.com');
      lstUsers.add(u2);

      User u3 = new User(Alias = 'standt77', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser38@testorg.com');
      lstUsers.add(u3);

    insert lstUsers;
      
      Account acc = new Account();
    acc.Name = 'Infosys';
    acc.RecordTypeId  = ITPR_Test_AutomateAssignee.getRecordTypeId('Account', 'IT-SES');
    acc.OwnerID=u.Id;
    system.debug ('rsas value of getRTID ' + acc.RecordTypeId);
    insert acc;
      
      System.runAs(u) {
      ITPR__c lt5 = new ITPR__c();
      lt5.Request_Type__c = 'Other Procurement';
    lt5.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    lt5.category__c = 'Telecom';
    lt5.Organization__c = 'CONA';
    lt5.Supplier_Name__c = acc.id;
    lt5.Supplier_Contact_Name__c = 'test';
    lt5.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    lt5.Supplier_Contact_Phone_Number__c = '9998889898';
    lt5.Engagement_Of_A_New_Supplier__c = 'No';
    lt5.Manager__C = u2.Id;
    lt5.Opportunity_Statement__c = 'test';
    lt5.CAPEX1__c = 200;
    lt5.OPEX1__c = 100;
    lt5.Supplier_s_Legal_Entity_Name__c = 'test';
    lt5.Duration_Of_NDA__c = 30.0;
    lt5.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    lt5.Supplier_Contact_email__c = 'test@test.com';
    lt5.Finance_Assignee__c = u1.Id;
    lt5.Addressee_Name__c = 'test';
    lt5.Status__c = 'Draft';
    lt5.Procurement_Assignee__c = u2.id;
    lt5.Vendor_Governance__c = u5.id;
    lt5.Legal_Assignee__c = null;
    lt5.OwnerId = u3.Id;
    lt5.Wave2_Approver_1__c = u6.id; 
    lt5.Submitted_on_behalf_of__c = null;

    insert lt5; 

  }
  Test.stopTest();
  }
  
  static testMethod void populateAssignee4() 
    { 
    Test.startTest();
   
    
    List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }    

    List<User> lstUsers = new List<User>();

      User u = new User(Alias = 'standt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser34@testorg.com');
       
      lstUsers.add(u);
      
      User u1 = new User(Alias = 'stand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser35@testorg.com');  
      lstUsers.add(u1);
   
      User u5 = new User(Alias = 'standt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser39@testorg.com');
      lstUsers.add(u5);
      
       User u6 = new User(Alias = 'standt5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser40@testorg.com');
      lstUsers.add(u6);
 
      User u2 = new User(Alias = 'standt6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser36@testorg.com');  
      lstUsers.add(u2);
  
      User u3 = new User(Alias = 'standt77', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser385@testorg.com');
      lstUsers.add(u3);
      
       User u7 = new User(Alias = 'standt77', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser384@testorg.com');    
      lstUsers.add(u7);
      
       User u8 = new User(Alias = 'standt77', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser383@testorg.com');    
      lstUsers.add(u8);
     
       User u9 = new User(Alias = 'standt77', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser382@testorg.com');    
      lstUsers.add(u9);
    
       User u10 = new User(Alias = 'standt77', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapProfiles.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser381@testorg.com');    
    lstUsers.add(u10);
    
    insert lstUsers;
    
     Account acc = new Account();
    acc.Name = 'Infosys';
    acc.RecordTypeId  = ITPR_Test_AutomateAssignee.getRecordTypeId('Account', 'IT-SES');
    acc.OwnerId=u.id;
    system.debug ('rsas value of getRTID ' + acc.RecordTypeId);
    insert acc;
    
    

    system.runas(u)
    {
    ITPR__c lt5 = new ITPR__c();
    lt5.Request_Type__c = 'SOW';
    lt5.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    lt5.category__c = 'Telecom';
    lt5.Organization__c = 'CONA';
    lt5.Supplier_Name__c = acc.id;
    lt5.Supplier_Contact_Name__c = 'test';
    lt5.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    lt5.Supplier_Contact_Phone_Number__c = '9998889898';
    lt5.Engagement_Of_A_New_Supplier__c = 'No';
    lt5.Manager__C = u2.Id;
    lt5.Opportunity_Statement__c = 'test';
    lt5.CAPEX1__c = 200;
    lt5.OPEX1__c = 100;
    lt5.Supplier_s_Legal_Entity_Name__c = 'test';
    lt5.Duration_Of_NDA__c = 30.0;
    lt5.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    lt5.Supplier_Contact_email__c = 'test@test.com';
    lt5.Finance_Assignee__c = u1.Id;
    lt5.Addressee_Name__c = 'test';
    lt5.Status__c = 'Draft';
    lt5.Procurement_Assignee__c = u2.id;
    lt5.Vendor_Governance__c = u5.id;
    lt5.Legal_Assignee__c = u6.id;
    lt5.OwnerId = u3.Id;
   lt5.Wave2_Approver_1__c = u.id; 
    lt5.Submitted_on_behalf_of__c = null;
    insert lt5;    
    lt5.CAPEX1__c = 300;
    lt5.Status__c = 'Submitted';
    update lt5;
   
    
    
    }
    

    system.runas(u2)
    {
    ITPR__c test = [select id,status__c from ITPR__c where status__c = 'Submitted'];
    test.status__c = 'In Process';
    //update test;
    
    }
    Test.stopTest();
}
static testmethod void testcall(){
Test.startTest();

List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or name = 'System Administrator'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    } 


List<User> lstUsers = new List<User>();
User user1 = new User(
            username = 'testdel1' + DateTime.now().getTime() + '@test.com',
            alias = 'del1',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'del1',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user1);
        
        User user2 = new User(
            username = 'testdel2' + DateTime.now().getTime() + '@test.com',
            alias = 'del2',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest2',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user2);
        
        User user3 = new User(
            username = 'testdel3' + DateTime.now().getTime() + '@test.com',
            alias = 'del3',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest3',
            profileId = mapProfiles.get('ITSES - Finance'),
            ITPR_Department__c =  'ITSES - Finance',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user3);
        
         User userfin = new User(
            username = 'testdefin' + DateTime.now().getTime() + '@test.com',
            alias = 'delf3',
            email = 'testfin@test.com',
            firstName = 'test',
            lastName = 'fintest3',
            profileId = mapProfiles.get('ITSES - Finance'),
            ITPR_Department__c =  'ITSES - Finance',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(userfin);
        
        
        
        User user4 = new User(
            username = 'testdel4' + DateTime.now().getTime() + '@test.com',
            alias = 'del4',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest3',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user4);
        
        User user5 = new User(
            username = 'testdel5' + DateTime.now().getTime() + '@test.com',
            alias = 'del5',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest5',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user5);
        
        User user6 = new User(
            username = 'testdel6' + DateTime.now().getTime() + '@test.com',
            alias = 'del6',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest6',
            profileId = mapProfiles.get('ITSES - Vendor Governance'),
            ITPR_Department__c =  'ITSES - Vendor Governance',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user6);
        
        User user7 = new User(
            username = 'testdel7' + DateTime.now().getTime() + '@test.com',
            alias = 'del7',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest7',
            profileId = mapProfiles.get('System Administrator'),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user7);
        
        insert lstUsers;

List<ITPR__c> newitpr = new List<ITPR__c>();
Account supplier = new Account(Name = 'TestSupplier');

List<ITPR__c> lstITPRsToInsert = new List<ITPR__c>();
List<ITPR__c> lstITPRsToUpdate = new List<ITPR__c>();

        insert supplier;
ITPR__c itpr1 = new ITPR__c(
            Request_Type__c = 'New Master',
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
            Finance_Assignee__c = userfin.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
           Legal_Assignee__c = user4.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            Procurement_Assignee__c = user1.Id,
           
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Assigned',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            //Vendor_Governance__c = approver3.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = user5.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = user1.Id,
           Wave2_Rejected__c = FALSE,
        // Wave3_Approver_1__c = approver3.Id,
        //  Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes'
           
        );

         
       lstITPRsToInsert.add(itpr1);
       
       ITPR__c itpr2 = new ITPR__c(
            Request_Type__c = 'Change in Existing Master',
            Actionable_Request__c = FALSE,
            Any_Noteworthy_Exceptional_Risk__c = 'Yes',
            Are_There_Exceptions_To_LoL__c = 'Yes',
            Are_There_Fees_For_Early_Termination__c = 'Yes',
            Assign_check__c = FALSE,
            Category__c = 'Infrastructure',
            Delegated_Finance_Assignee__c = FALSE,
            Delegated_Legal_Assignee__c = TRUE,
            Delegated_Procurement_Assignee__c = TRUE,
            Delegated_Requestor_check__c = FALSE,
            Delegated_Vendor_Governance_User__c = FALSE,
            Do_not_Auto_Assign__c = FALSE,
            Expiration_Date__c = Date.today().addDays(20),
            Final_Budget_Validated__c = TRUE,
            Finance_Assignee__c = user3.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            Legal_Assignee__c = user4.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            //Procurement_Assignee__c = approver1.Id,
           
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Pending Project Fianl Budget',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
            //Vendor_Governance__c = user6.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = user5.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = user1.Id,
           Wave2_Rejected__c = FALSE,
        // Wave3_Approver_1__c = approver3.Id,
        //  Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes'
           
        );
        lstITPRsToInsert.add(itpr2);
        
        insert lstITPRsToInsert;
newitpr.add(itpr1);
newitpr.add(itpr2);
Assignment_Routing_Rules__c objrule = new Assignment_Routing_Rules__c();
objrule.Category__c = 'Telecom';
objrule.Organization__c = 'CONA';
objrule.Request_Type__c = 'New Master';
objrule.Procurement_Assignee__c = user1.Id;
objrule.legal_assignee__c = user4.Id;
objrule.vendor_governance_user__c = user6.Id;
insert objrule;
Map<Id, Assignment_Routing_Rules__c> itprAssigneesUpd = new Map<Id, Assignment_Routing_Rules__c>();
itprAssigneesUpd.put(objrule.id,objrule);
Map<Id, ITPR__c> oldMapITPR = new Map<Id, ITPR__c>();

oldMapITPR.put(itpr2.Id,itpr2);

itpr1.request_type__c = 'Change in Existing Master';
lstITPRsToUpdate.add(itpr1);


itpr2.request_type__c = 'COA';
//itpr2.legal_assignee__c = user5.Id;
lstITPRsToUpdate.add(itpr2);

update lstITPRsToUpdate;

oldMapITPR.put(itpr1.Id,itpr1);
oldMapITPR.put(itpr2.Id,itpr2);
system.runas(user1)
{
/*List<ITPRDelegation__c> dellst = new List<ITPRdelegation__c>();
ITPRDelegation__c del1 = new ITPRDelegation__c();
del1.start_Date__c = Date.newInstance(2014, 04, 16);
del1.end_date__c = Date.newInstance(2014, 04, 16);
del1.delegate_to__c = user2.Id;
insert del1;*/
}
   


ITPR_PopulateAssignees objCls = new ITPR_PopulateAssignees();
 objCls.AssigneeUpdate(newitpr,itprAssigneesUpd,oldMapITPR);
 Test.stopTest();
}

static testmethod void assignmentmethod(){
Test.startTest();
 
List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }

List<User> lstUsers = new List<User>();
 User user1 = new User(
            username = 'testdel1' + DateTime.now().getTime() + '@test.com',
            alias = 'del1',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'del1',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user1);
        User user2 = new User(
            username = 'testdel2' + DateTime.now().getTime() + '@test.com',
            alias = 'del2',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest2',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user2);
        
        User user3 = new User(
            username = 'testdel3' + DateTime.now().getTime() + '@test.com',
            alias = 'del3',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest3',
            profileId = mapProfiles.get('ITSES - Finance'),
            ITPR_Department__c =  'ITSES - Finance',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user3);
        
        
        User user4 = new User(
            username = 'testdel4' + DateTime.now().getTime() + '@test.com',
            alias = 'del4',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest3',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user4);
        
        User user5 = new User(
            username = 'testdel5' + DateTime.now().getTime() + '@test.com',
            alias = 'del5',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest5',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user5);
        
        User user6 = new User(
            username = 'testdel6' + DateTime.now().getTime() + '@test.com',
            alias = 'del6',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest6',
            profileId = mapProfiles.get('ITSES - Vendor Governance'),
            ITPR_Department__c =  'ITSES - Vendor Governance',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user6);
        
        insert lstUsers;
   Assignment_Routing_Rules__c objrule = new Assignment_Routing_Rules__c();
objrule.Category__c = 'Telecom';
objrule.Organization__c = 'CONA';
objrule.Request_Type__c = 'New Master';
objrule.Procurement_Assignee__c = user1.Id;
objrule.legal_assignee__c = user4.Id;
objrule.vendor_governance_user__c = user6.Id;
insert objrule;

objrule.Category__c = 'Telecom';
objrule.Organization__c = 'CONA';
objrule.Request_Type__c = 'New Master';
try{
update objrule;
}catch(Exception e){}
Test.stopTest();
}


/*static testmethod void assignmentmethod1(){
Test.startTest();
 
List<Profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%'];
    Map<String,String> mapProfiles = new Map<String, String>();
    if(lstProfiles != null && lstProfiles.size() > 0) {
        for(Profile p : lstProfiles){
           mapProfiles.put(p.name,p.Id); 
        }
    }

List<User> lstUsers = new List<User>();
 User user1 = new User(
            username = 'testdel1' + DateTime.now().getTime() + '@test.com',
            alias = 'del1',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'del1',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user1);
        User user2 = new User(
            username = 'testdel2' + DateTime.now().getTime() + '@test.com',
            alias = 'del2',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest2',
            profileId = mapProfiles.get('ITSES - Procurement'),
            ITPR_Department__c =  'ITSES - Procurement',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user2);
        
        User user3 = new User(
            username = 'testdel3' + DateTime.now().getTime() + '@test.com',
            alias = 'del3',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest3',
            profileId = mapProfiles.get('ITSES - Finance'),
            ITPR_Department__c =  'ITSES - Finance',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user3);
        
        
        User user4 = new User(
            username = 'testdel4' + DateTime.now().getTime() + '@test.com',
            alias = 'del4',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest3',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        lstUsers.add(user4);
        
        User user5 = new User(
            username = 'testdel5' + DateTime.now().getTime() + '@test.com',
            alias = 'del5',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest5',
            profileId = mapProfiles.get('ITSES - Legal'),
            ITPR_Department__c =  'ITSES - Legal',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user5);
        
        User user6 = new User(
            username = 'testdel6' + DateTime.now().getTime() + '@test.com',
            alias = 'del6',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'deltest6',
            profileId = mapProfiles.get('ITSES - Vendor Governance'),
            ITPR_Department__c =  'ITSES - Vendor Governance',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            isactive = true
        );
        lstUsers.add(user6);
        
        insert lstUsers;
   Assignment_Routing_Rules__c objrule = new Assignment_Routing_Rules__c();
objrule.Category__c = 'Telecom';
objrule.Organization__c = 'CONA';
objrule.Request_Type__c = 'New Master';
objrule.Procurement_Assignee__c = user1.Id;
objrule.legal_assignee__c = user4.Id;
objrule.vendor_governance_user__c = user6.Id;
insert objrule;

Account supplier = new Account(Name = 'TestSupplier');
insert supplier;

List<ITPR__c> lstITPRsToInsert = new List<ITPR__c>();
 ITPR__c itpr2 = new ITPR__c(
            Request_Type__c = 'New Master',
            Actionable_Request__c = FALSE,
            Any_Noteworthy_Exceptional_Risk__c = 'Yes',
            Are_There_Exceptions_To_LoL__c = 'Yes',
            Are_There_Fees_For_Early_Termination__c = 'Yes',
            Assign_check__c = FALSE,
            Category__c = 'Telecom',
            
            Do_not_Auto_Assign__c = FALSE,
            Expiration_Date__c = Date.today().addDays(20),
            Final_Budget_Validated__c = TRUE,
           Finance_Assignee__c = user3.Id,
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            //Legal_Assignee__c = user5.Id,
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            //Procurement_Assignee__c = user2.Id,
           
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = 'Pending Project Final Budget',
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
            Supplier_Name__c = supplier.Id,
           // Vendor_Governance__c = user6.Id,
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = user5.Id,
            Wave1_Rejected__c = FALSE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = user1.Id,
           Wave2_Rejected__c = FALSE,
        // Wave3_Approver_1__c = approver3.Id,
        //  Wave3_Rejected__c = FALSE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes'
           
        );
        lstITPRsToInsert.add(itpr2);
        
        insert lstITPRsToInsert;


Test.stopTest();
}*/

 /*
    @
     Name : getRecordTypeId
    @description : Method to get the record type id for given object and record type name
    @parameters  : String, String
    @returns     : Id
    */
    public static Id getRecordTypeId(String objType, String name) {
        SObject obj;
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objType);
        if (targetType != null) {
            obj = targetType.newSObject();
            Schema.DescribeSObjectResult d = obj.getSObjectType().getDescribe();
            if (d != null) {
                Map<String,Schema.RecordTypeInfo> rtMap = d.getRecordTypeInfosByName();
                if (rtMap != null) {
                    Schema.RecordTypeInfo rtInfo = rtMap.get(name);
                    if (rtInfo != null) {
                        return rtInfo.getRecordTypeId();
                    }
                }
            }
        }
        return null;
    }





}