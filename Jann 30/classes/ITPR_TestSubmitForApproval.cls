@isTest
private class ITPR_TestSubmitForApproval
{

 static testMethod void populateAssignee3() 
    {
    Test.startTest();
map<string,Id> mapPNames = new map<string,Id>();
    List<profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name ='System Administrator'];
    List<User> usr = new List<User>();
    List<User> us = new List<User>();
    
    for(Profile p : lstProfiles){
    
    mapPNames.put(p.name, p.Id);
    
    }

     User u = new User(Alias = 'standt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor',
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser34@testorg.com');
      us.add(u);
     // insert u;
      User u1 = new User(Alias = 'stand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser35@testorg.com');
      us.add(u1);
      //insert u1;
      User u5 = new User(Alias = 'standt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance',
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser39@testorg.com');
     us.add(u5);
       User u6 = new User(Alias = 'standt5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId =  mapPnames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser40@testorg.com');
      us.add(u6);
      User u2 = new User(Alias = 'standt6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser36@testorg.com');
     us.add(u2);
      User u3 = new User(Alias = 'standt77', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser38@testorg.com');
     us.add(u3);
      
     insert us;
           
    Account acc = new Account();
    acc.Name = 'Infosys';
    insert acc;
      
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
    //lt5.Duration_Of_NDA__c = 30.0;
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
    lt5.Wave1_Approver_1__c = u5.id;
    lt5.Submitted_on_behalf_of__c = null;
    

    insert lt5; 
    lt5.Wave1_Approved__c = False;
    lt5.Wave2_Approved__c = False;
    lt5.Status__c = 'Pending Project Final Budget';
    update lt5;
    
   /* lt5.Status__c = 'In Approvals';
    lt5.Final_Budget_Validated__c = True;
    lt5.Wave1_Approved__c = true;
    update lt5; */
    
    Test.stopTest();
   }
   
   static testMethod void populateAssignee4() 
    {
    Test.startTest();
map<string,Id> mapPNames = new map<string,Id>();
    List<profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name ='System Administrator'];
    List<User> usr = new List<User>();
    List<User> us = new List<User>();
    
    for(Profile p : lstProfiles){
    
    mapPNames.put(p.name, p.Id);
    
    }

     User u = new User(Alias = 'standt11', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('ITSES - Requestor'),ITPR_Department__c =  'ITSES - Requestor', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser34@testorg.com');
      us.add(u);
     // insert u;
      User u1 = new User(Alias = 'stand8t', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('ITSES - Finance'),ITPR_Department__c =  'ITSES - Finance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser35@testorg.com');
      us.add(u1);
      //insert u1;
      User u5 = new User(Alias = 'standt4', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance',
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser39@testorg.com');
     us.add(u5);
       User u6 = new User(Alias = 'standt5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId =  mapPnames.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser40@testorg.com');
      us.add(u6);
      User u2 = new User(Alias = 'standt6', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser36@testorg.com');
     us.add(u2);
      User u3 = new User(Alias = 'standt77', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPnames.get('System Administrator'), 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser38@testorg.com');
     us.add(u3);
     insert us;
          
    Account acc = new Account();
    acc.Name = 'Infosys';
    insert acc;
      
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
   // lt5.Duration_Of_NDA__c = 30.0;
    lt5.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    lt5.Supplier_Contact_email__c = 'test@test.com';
    lt5.Finance_Assignee__c = u1.Id;
    lt5.Addressee_Name__c = 'test';
    lt5.Status__c = 'Draft';
    lt5.Procurement_Assignee__c = null;
    lt5.Vendor_Governance__c = u5.id;
    lt5.Legal_Assignee__c = u6.id;
    lt5.OwnerId = u3.Id;
    lt5.Wave2_Approver_1__c = u2.Id; 
    lt5.Wave3_Approver_1__c = u6.Id; 
    lt5.Final_Budget_Validated__c = True;
    lt5.Wave1_Approved__c = true;
    lt5.Submitted_on_behalf_of__c = null;
    lt5.Do_you_want_additional_approver__c = False;
    lt5.If_Required_Has_The_TRB_Approved__c = 'Yes';
    lt5.If_Rqd_Has_Hosting_Cert_Team_Approved__c = 'Yes';
    
    insert lt5;
    /* Attachment attach=new Attachment();   
    attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=lt5.id;
        insert attach; */
     
   lt5.Wave2_Approver_1__c = null; 
    lt5.Wave1_Approved__c = False;
    lt5.Wave2_Approved__c = False;
    lt5.Status__c = 'Pending Project Final Budget';
    update lt5;
   /* 
    lt5.Status__c = 'In Approvals';
    lt5.Final_Budget_Validated__c = True;
    lt5.Wave1_Approved__c = true;
    update lt5; */
    
   /* try
    {
    delete attach;
    }
    catch(Exception e){}*/
     
     lt5.Status__c = 'All Digital Initials Obtained';  
    lt5.Wave1_Approved__c = true;
    lt5.Wave2_Approved__c = true;
    update lt5; 
    
        /*ITPR__c lt6 = new ITPR__c();
    lt6.Request_Type__c = 'Other Legal';
    lt6.Date_Needed_by__c =  Date.newInstance(2098, 1, 1);
    lt6.category__c = 'Telecom';
    lt6.Organization__c = 'CONA';
    lt6.Supplier_Name__c = acc.id;
    lt6.Supplier_Contact_Name__c = 'test';
    lt6.I_Have_Read_The_Provided_ITP_OLA__c = 'test';
    lt6.Supplier_Contact_Phone_Number__c = '9998889898';
    lt6.Engagement_Of_A_New_Supplier__c = 'No';
    lt6.Manager__C = u2.Id;
    lt6.Opportunity_Statement__c = 'test';
    lt6.CAPEX1__c = 200;
    lt6.OPEX1__c = 100;
    lt6.Supplier_s_Legal_Entity_Name__c = 'test';
   // lt6.Duration_Of_NDA__c = 30.0;
    lt6.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';  
    lt6.Supplier_Contact_email__c = 'test@test.com';
    lt6.Finance_Assignee__c = u1.Id;
    lt6.Addressee_Name__c = 'test';
    lt6.Status__c = 'Draft';
    lt6.Procurement_Assignee__c = null;
    lt6.Vendor_Governance__c = u5.id;
    lt6.Legal_Assignee__c = u6.id;
    lt6.OwnerId = u3.Id;
    lt6.Wave2_Approver_1__c = u2.Id; 
    lt6.Wave3_Approver_1__c = u6.Id; 
    lt6.Final_Budget_Validated__c = True;
    lt6.Wave1_Approved__c = true;
    lt6.Submitted_on_behalf_of__c = null;
    lt6.Do_you_want_additional_approver__c = False;
    lt6.If_Required_Has_The_TRB_Approved__c = 'Yes';
    lt6.If_Rqd_Has_Hosting_Cert_Team_Approved__c = 'Yes';
    insert lt6;
     
   lt6.Wave2_Approver_1__c = null; 
    lt6.Wave1_Approved__c = False;
    lt6.Wave2_Approved__c = False;
    lt6.Status__c = 'Pending Project Final Budget';
    update lt6;*/

  /*  try{
    lt6.Status__c = 'In Approvals';
    lt6.Final_Budget_Validated__c = False;
    lt6.Wave1_Approved__c = true;
    update lt6;
} catch(Exception e){}*/
    
    
    
   /* lt5.Wave2_Approver_1__c = null; 
    lt5.Wave1_Approved__c = False;
    lt5.Wave2_Approved__c = False;
    
    lt5.Final_Budget_Validated__c = True;
    lt5.Wave1_Approved__c = true;
    
    lt5.Status__c = 'All Digital Initials Obtained';  
    lt5.Wave1_Approved__c = true;
    lt5.Wave2_Approved__c = true;
    update lt5;*/
     
   /* try{
    lt5.Status__c = 'In Approvals';
    lt5.Final_Budget_Validated__c = True;
    lt5.Wave1_Approved__c = true;
    lt5.wave3_Approver_1__c = null;
    lt5.wave2_Approver_1__c = null;
    update lt5;
    }*/
    
    Test.stopTest();
   
   }
 
   
   
}