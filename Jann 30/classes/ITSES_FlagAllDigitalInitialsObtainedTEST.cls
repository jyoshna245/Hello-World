@isTest

private class ITSES_FlagAllDigitalInitialsObtainedTEST {

	static testMethod void testScheduleFlagAllDigitalInitials (){
		
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
	
	 	//Test ITSES_FlagAllDigitalInitialsObtained class
        ITSES_FlagAllDigitalInitialsObtained skedule = new ITSES_FlagAllDigitalInitialsObtained();
        String timeOfRun = '0 0 * * * ?'; //every hour is scheduling 
        system.schedule('Test Schedule for All Digital Initials Obratined', timeOfRun, skedule);
        Test.stopTest();
	
	 List<ITPR__c> testITSES = [SELECT ID, Name, Status__c, Flag_as_All_Digital_Initials_Obtained__c from ITPR__c where Status__c = 'All Digital Initials Obtained' AND ID=:itpr.Id];
	
	for (ITPR__c testitpr: testITSES)
	{
		if(testitpr.Status__c=='All Digital Initials Obtained'){
			//do nothing..
		}
	}
	
		
		
	}

}