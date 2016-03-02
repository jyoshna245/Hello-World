@isTest(SeeAllData = false)
public class ITSES_Test_ViewAttachments{
 static testMethod void test01(){
     Test.startTest();
    
     
    //Integer pageSize =5;
    //Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
    //PageReference pagref= Page.ITPR_Final_Attachment_New_Page; 
     //Test.setCurrentPage(pagref);
      //Get Profile to use for creating users
        Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
      map<string,Id> mapPNames = new map<string,Id>();
         List<profile> lstProfiles = [select Id,Name from Profile where Name like 'ITSES%' or Name ='System Administrator'];
        
        for(Profile p1 : lstProfiles){
        mapPNames.put(p1.name, p1.Id);
     }
    
    
    List<USer> lstUsers = new List<User>();
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
        User approver2 = approver1.clone();
        approver2.username = 'test2' + DateTime.now().getTime() + '@test.com';
        approver2.ITPR_Department__c = 'ITSES - Finance';
        lstUsers.add(approver2);
        
        User approver3 = approver1.clone();
        approver3.username = 'test3' + DateTime.now().getTime() + '@test.com';
        approver3.ITPR_Department__c = 'ITSES - Legal';
        lstUsers.add(approver3);

        User approver4 = approver1.clone();
        approver4.username = 'test4' + DateTime.now().getTime() + '@test.com';
        approver4.ITPR_Department__c = 'ITSES - Vendor Governance';
        lstUsers.add(approver4);
     
     User u5 = new User(Alias = '3stant5', Email='standarduser41@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser491@testorg.com');
      lstUsers.add(u5);  
     User u6 = new User(Alias = '3stant5', Email='standarduser51@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser4912@testorg.com');
      lstUsers.add(u6);
     
     User u7 = new User(Alias = '3stant5', Email='standarduser61@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser4921@testorg.com');
      lstUsers.add(u7); 
     
       User u8 = new User(Alias = '3stant5', Email='standarduser71@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser4922@testorg.com');
      lstUsers.add(u8);               
      User u9 = new User(Alias = '3stant5', Email='standarduser81@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser4944@testorg.com');
      lstUsers.add(u9);
       User u10 = new User(Alias = '3stant5', Email='standarduser91@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser48455@testorg.com');
      lstUsers.add(u10);
       User u11 = new User(Alias = '3stant5', Email='standarduser111@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser474@testorg.com');
      lstUsers.add(u11);
       User u12 = new User(Alias = '3stant5', Email='standarduser561@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser463@testorg.com');
      lstUsers.add(u12);
       User u13 = new User(Alias = '3stant5', Email='standarduser781@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing5', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser4522@testorg.com');
      lstUsers.add(u13);
       User u14 = new User(Alias = '3stant5', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing6', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Procurement'),ITPR_Department__c =  'ITSES - Procurement', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser44@testorg.com');
      lstUsers.add(u14);
       User u15 = new User(Alias = '3stant5', Email='standarduser891@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing7', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Vendor Governance'), ITPR_Department__c =  'ITSES - Vendor Governance',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser4322@testorg.com');
      lstUsers.add(u15);
       User u16 = new User(Alias = '3stant5', Email='standarduser871@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing8', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser42@testorg.com');
      lstUsers.add(u16);
       User u17 = new User(Alias = '3stant5', Email='standarduser661@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing9', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'), ITPR_Department__c =  'ITSES - Legal',
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser41@testorg.com');
      lstUsers.add(u17);
      
       User u18 = new User(Alias = '3stant5', Email='standarduser551@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing12', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Vendor Governance'),ITPR_Department__c =  'ITSES - Vendor Governance', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser419@testorg.com');
      lstUsers.add(u18);
      User u19 = new User(Alias = '3stant5', Email='standarduser551@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing13', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser418@testorg.com');
      lstUsers.add(u19);
      User u20 = new User(Alias = '3stant5', Email='standarduser551@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing14', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = mapPNames.get('ITSES - Legal'),ITPR_Department__c =  'ITSES - Legal', 
      TimeZoneSidKey='America/Los_Angeles', UserName='4standarduser4199@testorg.com');
      lstUsers.add(u20);
      insert lstUsers;
          Account supplier = new Account(Name = 'TestSupplier');
        insert supplier;
     
                      ITPR__c itpr2 = new ITPR__c(
                      Submitted_By_Phone_Number__c ='12312321213',
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
            
            If_Yes_Explain1__c = 'test',
            If_Yes_Explain2__c = 'test',
            If_Yes_Explain3__c = 'test',
            If_yes_Explain4__c = 'test',
            
            Organization__c = 'CONA',
            Primary_Assignee__c = 'Jackie Wang',
            Procurement_Assignee__c = approver1.Id,
            Finance_Assignee__c = approver2.Id,
           Legal_Assignee__c = approver3.Id,
            Vendor_Governance__c = approver4.Id,
            Request_Type__c = 'New Master',
            Standard_Indemnifications_Including_IP__c = 'Yes',
            Standard_Representations_Warranties__c = 'Yes',
            Status__c = System.Label.ITPR_Submitted_Status,
            Supplier_Contact_Email__c = 'test@infy.com',
            Supplier_Contact_Name__c = 'test',
            Supplier_Contact_Phone_Number__c = '1111111111',
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
   
            
            Wave1_Approved__c = FALSE,
            Wave1_Approver_1__c = u5.Id,
            Wave1_Rejected__c = TRUE,
            Wave2_Approved__c = FALSE,
            Wave2_Approver_1__c = u6.Id,
            Wave2_Rejected__c = TRUE,
            Wave3_Approver_1__c = u7.Id,
            Wave3_Rejected__c = TRUE,
            Will_Supplier_Retain_Rights_To_New_IP__c = 'Yes',
            ownerId = approver4.Id,
            CAPEX1__c = 100
        );
        insert itpr2 ;
     //Constructing the standard controller instance
          PageReference pagref1= Page.ITPR_Addl_Attachment_New_Page;
          Test.setCurrentPage(pagref1);
          System.currentPageReference().getParameters().put('id', itpr2.id);
          ApexPages.currentPage().getParameters().put('retURL', itpr2.id);
          ApexPages.StandardController controller = new ApexPages.StandardController(itpr2); 
          ITSES_ViewAttachments AddlAttchmntController = new ITSES_ViewAttachments(controller);
          PageReference pgRf10 = AddlAttchmntController .NewPage();  
     
         List <ITSES_Additional_Attachment__c> addl_att = new list<ITSES_Additional_Attachment__c>();
         
         ITSES_Additional_Attachment__c addl_att1 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='Samplwe Testing',
          IT_SES_Request__c=itpr2.id
           );
           
           addl_att.add(addl_att1);
           
           ITSES_Additional_Attachment__c addl_att2 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='Sample Testing',
          IT_SES_Request__c=itpr2.id
           );
           addl_att.add(addl_att2);
           
             ITSES_Additional_Attachment__c addl_att3 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='UAT Testing',
          IT_SES_Request__c=itpr2.id
           );
           addl_att.add(addl_att3);
           
             ITSES_Additional_Attachment__c addl_att4 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='UAT Testing',
          IT_SES_Request__c=itpr2.id
           );
           addl_att.add(addl_att4);
           ITSES_Additional_Attachment__c addl_att5 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='UAT Testing',
          IT_SES_Request__c=itpr2.id
           );
           addl_att.add(addl_att5);
          
           ITSES_Additional_Attachment__c addl_att6 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='SIT Testing',
          IT_SES_Request__c=itpr2.id
           );
          addl_att.add(addl_att6);
          
           ITSES_Additional_Attachment__c addl_att7 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='SIT Testing',
          IT_SES_Request__c=itpr2.id
           );
           addl_att.add(addl_att7);
           
           ITSES_Additional_Attachment__c addl_att8 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='SIT Testing',
          IT_SES_Request__c=itpr2.id
           );
           addl_att.add(addl_att8);
           
           ITSES_Additional_Attachment__c addl_att9 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='SIT Testing',
          IT_SES_Request__c=itpr2.id
           );
           addl_att.add(addl_att9);
           
           ITSES_Additional_Attachment__c addl_att10 =new ITSES_Additional_Attachment__c(
          Attachment_Type__c = 'Normal Attachment',
          Description__c ='SIT Testing',
          IT_SES_Request__c=itpr2.id
           );
           addl_att.add(addl_att10);
          
          insert addl_att;
       
              
          /*List<ITSES_Additional_Attachment__c> addAtch = new List<ITSES_Additional_Attachment__c>([Select Id,IT_SES_Request__c from ITSES_Additional_Attachment__c 
                    where Attachment_Type__c = 'Normal Attachment']);*/
                   
         /* List<ID> itprID = new List<ID>();
          for(ITSES_Additional_Attachment__c obj : addAtch )
          itprID.add(obj.IT_SES_Request__c);
          List< ITPR__c> sampleData = new List< ITPR__c>([SELECT ID FROM ITPR__c  WHERE ID IN: itpr2.id LIMIT 8]);*/
          /*PageReference pagref1= Page.ITPR_Final_Attachment_New_Page;
          Test.setCurrentPage(pagref1);*/
          //for(ITPR__c sample : itpr2 ){
             /* System.currentPageReference().getParameters().put('id', itpr2.id);
              ApexPages.currentPage().getParameters().put('retURL', itpr2.id);
              ApexPages.StandardController controller = new ApexPages.StandardController(itpr2); 
              ITSES_Final_ViewAttachments AddlAttchmntController = new ITSES_Final_ViewAttachments(controller);
*/
           
             Boolean itpr10 = AddlAttchmntController .IsUploadAllowed;
              Boolean itpr20 = AddlAttchmntController .IsDeleteAllowed;
              String pdfContent = 'This is a test string';
              List<Attachment> attchmnts1 = AddlAttchmntController.getAttachments();
              
              Attachment att1 =new Attachment(
             OwnerId = approver1.Id,    
             ParentId = addl_att1.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att1);
             
             Attachment att2 =new Attachment(
             OwnerId = approver2.Id,    
             ParentId = addl_att2.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att2);
             
             Attachment att3 =new Attachment(
             OwnerId = approver2.Id,    
             ParentId = addl_att3.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att3);
             
             Attachment att4 =new Attachment(
             OwnerId = approver2.Id,    
             ParentId = addl_att4.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att4);
             
             Attachment att5 =new Attachment(
             OwnerId = approver1.Id,    
             ParentId = addl_att5.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att5);
             
             Attachment att6 =new Attachment(
             OwnerId = approver3.Id,    
             ParentId = addl_att6.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att6);
             
              Attachment att7 =new Attachment(
             OwnerId = approver3.Id,    
             ParentId = addl_att7.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att7);
             
              Attachment att8 =new Attachment(
             OwnerId = approver3.Id,    
             ParentId = addl_att8.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att8);
             
              Attachment att9 =new Attachment(
             OwnerId = approver3.Id,    
             ParentId = addl_att9.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att9);
             
              Attachment att10 =new Attachment(
             OwnerId = approver3.Id,    
             ParentId = addl_att10.Id,
             Body = blob.toPDF(pdfContent),
             Name =supplier.Name+'.pdf' );
             attchmnts1.add(att10);
          
          
             insert attchmnts1 ;
              
             AddlAttchmntController .attachment.Name = supplier.Name+'.pdf' ; 
             AddlAttchmntController .attachment.body = blob.toPDF(pdfContent) ;         
              
               //attchmnts1.OwnerId = approver2.Id;
              PageReference pgRf5 = AddlAttchmntController.upload();
              
               
            AddlAttchmntController.BindAttachments();
        if(AddlAttchmntController.hasNextFind == True)
           {
          Boolean itpr30 = AddlAttchmntController.hasNextFind; 
     
    	   }   else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error fetching records.'));
        } 

             
     
     PageReference pgRf1 = AddlAttchmntController.NextPage();
               AddlAttchmntController.BindAttachments();
        if(AddlAttchmntController.hasPreviousFind == True)
        {
             Boolean itpr40 = AddlAttchmntController.hasPreviousFind;
        }  else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error fetching records.'));
        } 
             PageReference pgRf2 = AddlAttchmntController.PreviousPage();
                 /*  public id DeleteId= AddlAttchmntController .AttachId;
                  List<Attachment> Lst_DelAttach = [SELECT Id FROM Attachment where Id = :DeleteId];*/
          
             PageReference pgRf4 = AddlAttchmntController.DeleteAttachment();              
                        
            
              PageReference pgRf6 = AddlAttchmntController.cancel();
      
         // }
   Test.stopTest();
}
}

/*
 static testMethod void test01(){
    Test.startTest();
    Profile p = [Select Id From Profile where Name like '%ITSES%' limit 1];
    //PageReference pagref= Page.ITPR_Final_Attachment_New_Page; 
     //Test.setCurrentPage(pagref);
    //Create Approver 1
        User u1= new User(
            username = 'test' + DateTime.now().getTime() + '@test.com',
            alias = 'test1111',
            email = 'test@test.com',
            firstName = 'test',
            lastName = 'Procurement',
             ITPR_Department__c = 'ITSES - Procurement',
            profileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
          insert u1;
     
          
                
          List<ITSES_Additional_Attachment__c> addAtch = new List<ITSES_Additional_Attachment__c>([Select Id,IT_SES_Request__c from ITSES_Additional_Attachment__c 
                    where Attachment_Type__c = 'Normal Attachment']);
          List<ID> itprID = new List<ID>();
          for(ITSES_Additional_Attachment__c obj : addAtch)
              itprID.add(obj.IT_SES_Request__c);
          List< ITPR__c> sampleData = new List< ITPR__c>([SELECT ID FROM ITPR__c WHERE ID IN: itprID LIMIT 8]);
          PageReference pagref1= Page.ITPR_Addl_Attachment_New_Page;
          Test.setCurrentPage(pagref1);
          for(ITPR__c sample : sampleData){
              System.currentPageReference().getParameters().put('id', sample.id);
              ApexPages.currentPage().getParameters().put('retURL', sample.id);
              ApexPages.StandardController controller = new ApexPages.StandardController(sample); 
              ITSES_ViewAttachments viewAttchmntController = new ITSES_ViewAttachments(controller);
              Boolean itpr1 = viewAttchmntController.IsUploadAllowed;
              Boolean itpr2 = viewAttchmntController.IsDeleteAllowed;
              List<Attachment> attchmnts1 = viewAttchmntController.getAttachments();
              Boolean itpr3 = viewAttchmntController.hasNextFind;
              Boolean itpr4 = viewAttchmntController.hasPreviousFind;
              PageReference pgRf1 = viewAttchmntController.PreviousPage();
              PageReference pgRf2 = viewAttchmntController.NextPage();
              PageReference pgRf3 = viewAttchmntController.NewPage();
              PageReference pgRf4 = viewAttchmntController.DeleteAttachment();
              PageReference pgRf5 = viewAttchmntController.upload();
              PageReference pgRf6 = viewAttchmntController.cancel();
          }
          Test.stopTest();
}
}*/