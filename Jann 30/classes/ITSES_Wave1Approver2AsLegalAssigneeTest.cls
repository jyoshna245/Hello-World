@isTest
public class ITSES_Wave1Approver2AsLegalAssigneeTest {

  static testMethod void w1a1f1() {
    ITPR__c itpr = new ITPR__c();         

    Account testAccount = new Account( Name = 'Capgemini');
    insert testAccount;

    Profile p = [SELECT Id FROM Profile WHERE Name='ITSES - Legal Business Administrator'];

    System.debug('ITSES' +p);    

    User ProcurementAssignee = new User(Alias = 'user', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserr@testorg.com',ITPR_Department__c='ITSES - Procurement');
    insert ProcurementAssignee;

    User LegalAssignee = new User(Alias = 'user1', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserlegal@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert LegalAssignee;

    /* User FinanceAssignee = new User(Alias = 'user2', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserfinance@testorg.com',ITPR_Department__c='ITSES - Finance');
    insert FinanceAssignee; */

    User VendorGoverAssignee = new User(Alias = 'user3', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserVGA@testorg.com',ITPR_Department__c='ITSES - Vendor Governance');
    insert VendorGoverAssignee;

    User Wave2App1 = new User(Alias = 'user4', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW2AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave2App1;        

    User Wave3App1 = new User(Alias = 'user5', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW3AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave3App1;

    User Wave1App1 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App1;

    User Wave1App2 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP2@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App2;


    User Wave1App3 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP3@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App3;

    Assignment_Routing_Rules__c ar = new Assignment_Routing_Rules__c();
    ar.Organization__c = 'GIT';
    ar.Request_Type__c = 'NDA';
    ar.Category__c = 'Telecom';
    ar.Legal_Assignee__c = LegalAssignee.id;
    ar.Procurement_Assignee__c = ProcurementAssignee.id;
    ar.Vendor_Governance_User__c = VendorGoverAssignee.id;

    insert ar;

    itpr.Organization__c = 'GIT';
    itpr.Request_Type__c = 'NDA';
    itpr.Category__c = 'Telecom';
    itpr.Submitted_By_Phone_Number__c = '12345';
    itpr.Supplier_Name__c = testAccount.Id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.Supplier_Contact_Email__c = 'test@test.com';
    itpr.Supplier_Contact_Phone_Number__c = '12345';
    itpr.Finance_Assignee__c = null;

    //NDA Fields
    itpr.Who_Will_Be_Disclosing_Information__c = 'Both';
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Supplier_Physical_Address__c = 'test';
    itpr.Type_Of_Information__c = 'test';
    itpr.State_Or_Country_Of_Formation__c = 'test';
    itpr.Addressee_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 2;



    //Assignee Details
    //itpr.Procurement_Assignee__c = ProcurementAssignee.Id;
    //itpr.Legal_Assignee__c = LegalAssignee.Id;
    //itpr.Finance_Assignee__c = FinanceAssignee.Id;
    //itpr.Vendor_Governance__c = VendorGoverAssignee.Id;

    //itpr.Wave1_Approver_1__c = Wave1App1.Id;
    //itpr.Wave1_Approver_1__c = LegalAssignee.Id;
    itpr.Wave1_Approver_1__c = ar.Legal_Assignee__c;
    //itpr.Wave1_Approver_2__c = Wave1App2.Id;
    //itpr.Wave1_Approver_3__c = Wave1App3.Id;

    itpr.Wave2_Approver_1__c = Wave2App1.Id;
    // itpr.Wave2_Approver_1__c = Approver3.Id;
    itpr.Wave3_Approver_1__c = Wave3App1.Id;
    //itpr.Legal_Assignee__c = u.Id; */

    insert itpr ;
    ITPR__c itpr1 = [SELECT ID, Wave1_Approver_1__c FROM ITPR__c WHERE Id =: itpr.id];
    system.assertEquals(ar.Legal_Assignee__c, itpr1.Wave1_Approver_1__c);
  }


  static testMethod void w2n() {
    ITPR__c itpr = new ITPR__c();         

    Account testAccount = new Account( Name = 'Capgemini');
    insert testAccount;

    Profile p = [SELECT Id FROM Profile WHERE Name='ITSES - Legal Business Administrator'];

    System.debug('ITSES' +p);    

    User ProcurementAssignee = new User(Alias = 'user', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserr@testorg.com',ITPR_Department__c='ITSES - Procurement');
    insert ProcurementAssignee;

    User LegalAssignee = new User(Alias = 'user1', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserlegal@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert LegalAssignee;

    User FinanceAssignee = new User(Alias = 'user2', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserfinance@testorg.com',ITPR_Department__c='ITSES - Finance');
    insert FinanceAssignee;

    User VendorGoverAssignee = new User(Alias = 'user3', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserVGA@testorg.com',ITPR_Department__c='ITSES - Vendor Governance');
    insert VendorGoverAssignee;

    User Wave2App1 = new User(Alias = 'user4', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW2AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave2App1;        

    User Wave3App1 = new User(Alias = 'user5', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW3AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave3App1;

    User Wave1App1 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App1; 

    Assignment_Routing_Rules__c ar = new Assignment_Routing_Rules__c();
    ar.Organization__c = 'GIT';
    ar.Request_Type__c = 'NDA';
    ar.Category__c = 'Telecom';
    ar.Legal_Assignee__c = LegalAssignee.id;
    ar.Procurement_Assignee__c = ProcurementAssignee.id;
    ar.Vendor_Governance_User__c = VendorGoverAssignee.id;
    insert ar;

    itpr.Organization__c = 'GIT';
    itpr.Request_Type__c = 'NDA';
    itpr.Category__c = 'Telecom';
    itpr.Submitted_By_Phone_Number__c = '12345';
    itpr.Supplier_Name__c = testAccount.Id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.Supplier_Contact_Email__c = 'test@test.com';
    itpr.Supplier_Contact_Phone_Number__c = '12345';

    //NDA Fields
    itpr.Who_Will_Be_Disclosing_Information__c = 'Both';
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Supplier_Physical_Address__c = 'test';
    itpr.Type_Of_Information__c = 'test';
    itpr.State_Or_Country_Of_Formation__c = 'test';
    itpr.Addressee_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 2;



    //Assignee Details
    //itpr.Procurement_Assignee__c = ProcurementAssignee.Id;
    //itpr.Legal_Assignee__c = LegalAssignee.Id;
    itpr.Finance_Assignee__c = FinanceAssignee.Id;
    //itpr.Vendor_Governance__c = VendorGoverAssignee.Id;

    itpr.Wave1_Approver_1__c = Wave1App1.Id;
    //itpr.Wave1_Approver_2__c = LegalAssignee.Id;
    itpr.Wave2_Approver_1__c = Wave2App1.Id;
    // itpr.Wave2_Approver_1__c = Approver3.Id;
    itpr.Wave3_Approver_1__c = Wave3App1.Id;
    //itpr.Legal_Assignee__c = u.Id; */

    insert itpr ;
    ITPR__c itpr1 = [SELECT ID, Wave1_Approver_2__c FROM ITPR__c WHERE Id =: itpr.id];
    system.assertEquals(LegalAssignee.Id, itpr1.Wave1_Approver_2__c);
  }

  static testMethod void w3n() {
    ITPR__c itpr = new ITPR__c();         

    Account testAccount = new Account( Name = 'Capgemini');
    insert testAccount;

    Profile p = [SELECT Id FROM Profile WHERE Name='ITSES - Legal Business Administrator'];

    System.debug('ITSES' +p);    

    User ProcurementAssignee = new User(Alias = 'user', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserr@testorg.com',ITPR_Department__c='ITSES - Procurement');
    insert ProcurementAssignee;

    User LegalAssignee = new User(Alias = 'user1', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserlegal@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert LegalAssignee;

    User FinanceAssignee = new User(Alias = 'user2', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserfinance@testorg.com',ITPR_Department__c='ITSES - Finance');
    insert FinanceAssignee;

    User VendorGoverAssignee = new User(Alias = 'user3', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserVGA@testorg.com',ITPR_Department__c='ITSES - Vendor Governance');
    insert VendorGoverAssignee;

    User Wave2App1 = new User(Alias = 'user4', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW2AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave2App1;        

    User Wave3App1 = new User(Alias = 'user5', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW3AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave3App1;

    User Wave1App1 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App1;
    User Wave1App2 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP2@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App2;

    Assignment_Routing_Rules__c ar = new Assignment_Routing_Rules__c();
    ar.Organization__c = 'GIT';
    ar.Request_Type__c = 'NDA';
    ar.Category__c = 'Telecom';
    ar.Legal_Assignee__c = LegalAssignee.id;
    ar.Procurement_Assignee__c = ProcurementAssignee.id;
    ar.Vendor_Governance_User__c = VendorGoverAssignee.id;
    insert ar;

    itpr.Organization__c = 'GIT';
    itpr.Request_Type__c = 'NDA';
    itpr.Category__c = 'Telecom';
    itpr.Submitted_By_Phone_Number__c = '12345';
    itpr.Supplier_Name__c = testAccount.Id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.Supplier_Contact_Email__c = 'test@test.com';
    itpr.Supplier_Contact_Phone_Number__c = '12345';

    //NDA Fields
    itpr.Who_Will_Be_Disclosing_Information__c = 'Both';
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Supplier_Physical_Address__c = 'test';
    itpr.Type_Of_Information__c = 'test';
    itpr.State_Or_Country_Of_Formation__c = 'test';
    itpr.Addressee_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 2;



    //Assignee Details
    //itpr.Procurement_Assignee__c = ProcurementAssignee.Id;
    //itpr.Legal_Assignee__c = LegalAssignee.Id;
    itpr.Finance_Assignee__c = FinanceAssignee.Id;
    //itpr.Vendor_Governance__c = VendorGoverAssignee.Id;

    itpr.Wave1_Approver_1__c = Wave1App1.Id;
    itpr.Wave1_Approver_2__c = Wave1App2.Id;
    itpr.Wave2_Approver_1__c = Wave2App1.Id;
    // itpr.Wave2_Approver_1__c = Approver3.Id;
    itpr.Wave3_Approver_1__c = Wave3App1.Id;
    //itpr.Legal_Assignee__c = u.Id; */

    insert itpr ;
    ITPR__c itpr1 = [SELECT ID, Wave1_Approver_3__c FROM ITPR__c WHERE Id =: itpr.id];
    system.assertEquals(LegalAssignee.Id, itpr1.Wave1_Approver_3__c);
  }

  static testMethod void w4n() {
    ITPR__c itpr = new ITPR__c();         

    Account testAccount = new Account( Name = 'Capgemini');
    insert testAccount;

    Profile p = [SELECT Id FROM Profile WHERE Name='ITSES - Legal Business Administrator'];

    System.debug('ITSES' +p);    

    User ProcurementAssignee = new User(Alias = 'user', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserr@testorg.com',ITPR_Department__c='ITSES - Procurement');
    insert ProcurementAssignee;

    User LegalAssignee = new User(Alias = 'user1', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserlegal@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert LegalAssignee;

    User FinanceAssignee = new User(Alias = 'user2', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserfinance@testorg.com',ITPR_Department__c='ITSES - Finance');
    insert FinanceAssignee;

    User VendorGoverAssignee = new User(Alias = 'user3', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserVGA@testorg.com',ITPR_Department__c='ITSES - Vendor Governance');
    insert VendorGoverAssignee;

    User Wave2App1 = new User(Alias = 'user4', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW2AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave2App1;        

    User Wave3App1 = new User(Alias = 'user5', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW3AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave3App1;

    User Wave1App1 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App1;
    User Wave1App2 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP2@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App2;

    User Wave1App3 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP3@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App3;

    Assignment_Routing_Rules__c ar = new Assignment_Routing_Rules__c();
    ar.Organization__c = 'GIT';
    ar.Request_Type__c = 'NDA';
    ar.Category__c = 'Telecom';
    ar.Legal_Assignee__c = LegalAssignee.id;
    ar.Procurement_Assignee__c = ProcurementAssignee.id;
    ar.Vendor_Governance_User__c = VendorGoverAssignee.id;
    insert ar;

    itpr.Organization__c = 'GIT';
    itpr.Request_Type__c = 'NDA';
    itpr.Category__c = 'Telecom';
    itpr.Submitted_By_Phone_Number__c = '12345';
    itpr.Supplier_Name__c = testAccount.Id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.Supplier_Contact_Email__c = 'test@test.com';
    itpr.Supplier_Contact_Phone_Number__c = '12345';

    //NDA Fields
    itpr.Who_Will_Be_Disclosing_Information__c = 'Both';
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Supplier_Physical_Address__c = 'test';
    itpr.Type_Of_Information__c = 'test';
    itpr.State_Or_Country_Of_Formation__c = 'test';
    itpr.Addressee_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 2;



    //Assignee Details
    //itpr.Procurement_Assignee__c = ProcurementAssignee.Id;
    //itpr.Legal_Assignee__c = LegalAssignee.Id;
    itpr.Finance_Assignee__c = FinanceAssignee.Id;
    //itpr.Vendor_Governance__c = VendorGoverAssignee.Id;

    itpr.Wave1_Approver_1__c = Wave1App1.Id;
    itpr.Wave1_Approver_2__c = Wave1App2.Id;
    itpr.Wave1_Approver_3__c = Wave1App3.Id;

    itpr.Wave2_Approver_1__c = Wave2App1.Id;
    // itpr.Wave2_Approver_1__c = Approver3.Id;
    itpr.Wave3_Approver_1__c = Wave3App1.Id;
    //itpr.Legal_Assignee__c = u.Id; */

    insert itpr ;
    ITPR__c itpr1 = [SELECT ID, Wave1_Approver_4__c FROM ITPR__c WHERE Id =: itpr.id];
    system.assertEquals(LegalAssignee.Id, itpr1.Wave1_Approver_4__c);
  }

  static testMethod void w5n() {
    ITPR__c itpr = new ITPR__c();         

    Account testAccount = new Account( Name = 'Capgemini');
    insert testAccount;

    Profile p = [SELECT Id FROM Profile WHERE Name='ITSES - Legal Business Administrator'];

    System.debug('ITSES' +p);    

    User ProcurementAssignee = new User(Alias = 'user', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserr@testorg.com',ITPR_Department__c='ITSES - Procurement');
    insert ProcurementAssignee;

    User LegalAssignee = new User(Alias = 'user1', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserlegal@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert LegalAssignee;

    User FinanceAssignee = new User(Alias = 'user2', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserfinance@testorg.com',ITPR_Department__c='ITSES - Finance');
    insert FinanceAssignee;

    User VendorGoverAssignee = new User(Alias = 'user3', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserVGA@testorg.com',ITPR_Department__c='ITSES - Vendor Governance');
    insert VendorGoverAssignee;

    User Wave2App1 = new User(Alias = 'user4', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW2AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave2App1;        

    User Wave3App1 = new User(Alias = 'user5', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW3AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave3App1;

    User Wave1App1 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP1@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App1;
    User Wave1App2 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP2@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App2;

    User Wave1App3 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP3@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App3;

    User Wave1App4 = new User(Alias = 'user6', Email='standarduserr@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduserW1AP4@testorg.com',ITPR_Department__c='ITSES - Legal');
    insert Wave1App4;

    Assignment_Routing_Rules__c ar = new Assignment_Routing_Rules__c();
    ar.Organization__c = 'GIT';
    ar.Request_Type__c = 'NDA';
    ar.Category__c = 'Telecom';
    ar.Legal_Assignee__c = LegalAssignee.id;
    ar.Procurement_Assignee__c = ProcurementAssignee.id;
    ar.Vendor_Governance_User__c = VendorGoverAssignee.id;
    insert ar;

    itpr.Organization__c = 'GIT';
    itpr.Request_Type__c = 'NDA';
    itpr.Category__c = 'Telecom';
    itpr.Submitted_By_Phone_Number__c = '12345';
    itpr.Supplier_Name__c = testAccount.Id;
    itpr.Supplier_Contact_Name__c = 'test';
    itpr.Supplier_Contact_Email__c = 'test@test.com';
    itpr.Supplier_Contact_Phone_Number__c = '12345';

    //NDA Fields
    itpr.Who_Will_Be_Disclosing_Information__c = 'Both';
    itpr.Is_this_NDA_to_be_mutual_or_will_the_com__c = 'No';
    itpr.Supplier_s_Legal_Entity_Name__c = 'test';
    itpr.Supplier_Physical_Address__c = 'test';
    itpr.Type_Of_Information__c = 'test';
    itpr.State_Or_Country_Of_Formation__c = 'test';
    itpr.Addressee_Name__c = 'test';
    itpr.Duration_Of_NDA__c = 2;



    //Assignee Details
    //itpr.Procurement_Assignee__c = ProcurementAssignee.Id;
    //itpr.Legal_Assignee__c = LegalAssignee.Id;
    itpr.Finance_Assignee__c = FinanceAssignee.Id;
    //itpr.Vendor_Governance__c = VendorGoverAssignee.Id;

    itpr.Wave1_Approver_1__c = Wave1App1.Id;
    itpr.Wave1_Approver_2__c = Wave1App2.Id;
    itpr.Wave1_Approver_3__c = Wave1App3.Id;
    itpr.Wave1_Approver_4__c = Wave1App4.Id;

    itpr.Wave2_Approver_1__c = Wave2App1.Id;
    // itpr.Wave2_Approver_1__c = Approver3.Id;
    itpr.Wave3_Approver_1__c = Wave3App1.Id;
    //itpr.Legal_Assignee__c = u.Id; */

    insert itpr ;
    ITPR__c itpr1 = [SELECT ID, Wave1_Approver_5__c FROM ITPR__c WHERE Id =: itpr.id];
    system.assertEquals(LegalAssignee.Id, itpr1.Wave1_Approver_5__c);
    system.debug('Sucess');
  }

}