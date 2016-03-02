public with sharing class CRS_CRSTriggerHandler {
    public string recordtype {get;set;}
    public boolean Current_reviewer_FL {get;set;}
    public boolean Current_reviewer_SRA{get;set;}
    public boolean Current_reviewer_FGD {get;set;}
    public boolean Current_reviewer_PAC {get;set;} 
    public string Current_Reviewers {get;set;}
    public Map<Id,ProcessInstance> mapProcesses;
    public Set<id> listOfCRSIds = new Set<id>();
    public List<ProcessInstanceStep> lstProcesses = new List<ProcessInstanceStep>();
    public Map<String,Id> mapEmail=new Map<String,Id>();  //store a map emailtemplate name & id---by Ranjan
    public Set<String> listOfCorpPublicGroups=new Set<String>();
    List<Contact> tempContactforCorpUsers=new List<Contact>();
    public Set<Id> setITPRIds = new Set<Id>();

    public static final String APPROVAL_STEP_BULEGAL = 'BU Legal Approver';
    public static final String APPROVAL_STEP_FIELDSRA = 'Field SRA Approver';
    public static final String APPROVAL_STEP_CORPFORMULAGOVERN = 'Corp Formula Govern Approver';
    public static final String APPROVAL_STEP_CORPFOODLAW = 'Corporate Food Law Approver';
    public static final String APPROVAL_STEP_CORPSRA = 'Corporate SRA Approver';
    public static final String APPROVAL_STEP_VPCHIEF = 'VP-Chief Sc and Reg Officer';
    public static final String APPROVAL_STEP_VPSCIENCEDIVISION = 'VP-Science Division';
    
    public static final String Choose_Send_Corp_Form_Gov = 'Choose_Send_Corp_Form_Gov';
    public static final String CRS_Choose_PAC_Required = 'CRS_Choose_PAC_Required';
    public static final String CRS_Choose_Send_Corp_Form_Gov_and_PAC ='CRS_Choose_Send_Corp_Form_Gov_and_PAC';
    public static final String Choose_Send_VP_Science = 'Choose_Send_VP_Science';
    public static final String Choose_Send_VP_Science_Division = 'Choose_Send_VP_Science_Division';
    public static final String Choose_Send_VP_Science_gvw = 'Choose_Send_VP_Science_gvw';
    public static final String Corporate_Level_Attention = 'Corporate_Level_Attention';
    public static final String Corporate_Level_Attention_gvw = 'Corporate_Level_Attention_gvw';
    public static final String CRS_Neglected = 'CRS_Neglected';
    public static final String CRS_Status_Change = 'CRS_Status_Change';
    public static final String CRS_Status_Change_for_gvw = 'CRS_Status_Change_for_gvw';
    
    private static Map<String, List<String>> emailAlerts = new Map<String, List<String>> {
        CRS_Choose_Send_Corp_Form_Gov_and_PAC=> new List<String> {'CAR_Corporate_SRA_Approver'},
        CRS_Choose_PAC_Required=> new List<String> {'CAR_Corporate_SRA_Approver'},
        Choose_Send_Corp_Form_Gov => new List<String> {'CAR_Corporate_SRA_Approver'},
        Choose_Send_VP_Science => new List<String> {'CAR_Corporate_SRA_Approver'},
        Choose_Send_VP_Science_Division => new List<String> {'CAR_Corporate_Formula_Governance'},
        Choose_Send_VP_Science_gvw => new List<String> {'CAR_GVW_Corporate_SRA_Approver'},
        Corporate_Level_Attention => new List<String> {'CAR_Corporate_Food_Law_Approver', 'CAR_Corporate_Formula_Governance', 'CAR_Corporate_SRA_Approver'},
        Corporate_Level_Attention_gvw => new List<String> {'CAR_GVW_Corporate_Food_Law_Approver', 'CAR_GVW_Corporate_SRA_Approver'},
        CRS_Neglected => new List<String> {'CRS_Business_Admin', 'CRS_Owner'},
        CRS_Status_Change => new List<String> {'CRS_Business_Admin', 'CRS_Corporate_Level', 'CRS_Owner'},
        CRS_Status_Change_for_gvw => new List<String> {'CRS_Business_Admin', 'gvwCRS_Corporate_Level', 'CRS_Owner'}
    };

    private Integer getNumberFromName(List<CRS__c> lastCrs, Boolean isGvw){
        Integer idNum = 0;
        if(!lastCrs.isEmpty()){
            Pattern p = Pattern.compile('(\\d{6})');
            Matcher m = p.matcher(lastCrs[0].Name);
            if(m.find()){
                idNum = Integer.valueOf(m.group(1)) + 1;
                System.debug('~~~:' + m.group(1)); 
            }
        }
        if(isGvw){
            if(idNum < 7000){
                idNum = 7000;
            }
        } else {
            if(idNum < 10000){
                idNum = 10000;
            }
        }
        return idNum;
    }

    private Integer countIndividualCRS(CRS__c crs){
        Integer countCRS = 0;
        System.debug('~~~~');
        for(String fName : Schema.sObjectType.CRS__c.fields.getMap().keySet()){
            if(fName.contains('individual_crs_') || fName.contains('document_title')){
                if(crs.get(fName) != null && crs.get(fName) != ''){
                    countCRS++;
                }
            }
        }  
        return countCRS; 
    }
    
    public void BeforeInsert(CRS__c[] newCrs){
        Id crsGvwRecordTypeId = [Select Id, Name From RecordType where sObjectType='CRS__c' and name='glaceau vitaminwater CRS'][0].Id;
        Integer lastGvwId = getNumberFromName([Select Name From CRS__c where RecordTypeId = :crsGvwRecordTypeId and Name like 'ATLgvw%' order by Name desc limit 1], true);
        Integer lastNoGvwId = getNumberFromName([Select Name From CRS__c where RecordTypeId != :crsGvwRecordTypeId and Name like 'ATL%' order by Name desc limit 1], false);
        for(CRS__c crs : newCrs){
            if(crs.RecordTypeId == crsGvwRecordTypeId){
                crs.Name = 'ATLgvw'+ '0'.repeat(6 - String.valueOf(lastGvwId).length()) + lastGvwId++;
            } else {
                crs.Name = 'ATL'+ '0'.repeat(6 - String.valueOf(lastNoGvwId).length()) + lastNoGvwId++;
            }
            crs.Total_CRS__c = countIndividualCRS(crs);
        }
    }
    
    public void BeforeUpdate(CRS__c[] newCrs){
        List<CRS_Review__c> reviews = new List<CRS_Review__c>();
        for(CRS__c crs : newCrs){
            crs.Total_CRS__c = countIndividualCRS(crs);
            if (crs.Active__c=='No' && crs.CRS_Review__c != null){
                reviews.add(new CRS_Review__c(Id=crs.CRS_Review__c, Active__c='No'));
            }
        }
        update reviews;
    }
    
    //CRS_enhancement
    public void AfterInsert(CRS__c[] newCrs){
        List<CRS_Dossier__c> lstDossier = new List<CRS_Dossier__c>();
        for (CRS__c crs : newCrs) {        
                lstDossier.add(new CRS_Dossier__c (CRSDossierToCRS__c = crs.Id));
        } 
      insert lstDossier;
        
    }
    
    public void AfterUpdate(CRS__c[] newCrs, Map<Id, CRS__c> oldMap){       
        system.debug('insiode calsss+'); 
        List<RecordType> lstCRSRec = [SELECT Id,DeveloperName from RecordType WHERE SobjectType='CRS__c'];
        map<string,Id> mapCRSRec=new Map<string,id>();
        for(RecordType objrec : lstCRSRec){
            mapCRSRec.put(objrec.DeveloperName, objrec.Id);
        }
        
        //CRS review record type
        List<RecordType> lstCRSReviewRec = [SELECT Id,DeveloperName from RecordType WHERE SobjectType='CRS_Review__c'];
        map<string,Id> mapCRSReviewRec=new Map<string,id>();
        for(RecordType objRevrec : lstCRSReviewRec){
            mapCRSReviewRec.put(objRevrec.DeveloperName, objRevrec.Id);
        }
        
        list<CRS_Review__c> crsReviewToInserted =  new list<CRS_Review__c>();
        
        id crsReviewRT;
        for(CRS__c crs : newCrs) {
            CRS__c oldCRS = oldMap.get(crs.Id);
            if(crs.CRS_Review__c == null){
                if(oldCRS.Status__c == 'In Process' && crs.Status__c == 'Under Review'){
                    if(crs.RecordTypeId == mapCRSRec.get('CRS_submission')){
                        crsReviewRT =  mapCRSReviewRec.get('CRS_Review');
                    }else{
                        crsReviewRT =  mapCRSReviewRec.get('gvwCRS_Review');
                    }
                    
                    //++ crs enahancement, frr12
                    Current_reviewer_FL = false;
                    Current_reviewer_SRA = false;
                    Current_reviewer_FGD =  false;
                    Current_reviewer_PAC =  false;
                    // for workflow 1
                    if(crs.Process_Flow__c == CRS_CRSReview.PROCESS_FLOW_NOTIFICATION){
                        Current_reviewer_FL = false;
                        Current_reviewer_SRA = false;
                        Current_reviewer_FGD =  false;
                        Current_reviewer_PAC =  false;
                        Current_Reviewers = '';
                    }
                    // for workflow 2
                    if(crs.Process_Flow__c == CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_NON_COKE || crs.Process_Flow__c == CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_NOTIFICATION){
                        Current_reviewer_FL = true;
                        Current_reviewer_SRA = true;
                        Current_reviewer_FGD =  false;
                        Current_reviewer_PAC =  false;
                        Current_Reviewers = 'FL,SRA';
                    }
                    
                    // for work flow 3
                    if(crs.Process_Flow__c == CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_COKE){
                        Current_reviewer_FL = true;
                        Current_reviewer_SRA = true;
                        Current_reviewer_FGD =  true;
                        Current_reviewer_PAC =  false;
                        Current_Reviewers = 'FL,SRA,FGD';
                    }
                    
                    // for work flow 4 
                    if(crs.Process_Flow__c == CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC || crs.Process_Flow__c == CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE){
                        Current_reviewer_FL = true;
                        Current_reviewer_SRA = true;
                        Current_reviewer_PAC =  true;
                        Current_reviewer_FGD =  false;
                        Current_Reviewers = 'FL,SRA,PAC';
                    }
                    
                    // work flow 5
                    if(crs.Process_Flow__c == CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_PAC_COKE){
                        Current_reviewer_FL = true;
                        Current_reviewer_SRA = true;
                        Current_reviewer_FGD =  true;
                        Current_reviewer_PAC =  true;
                        Current_Reviewers = 'FL,SRA,FGD,PAC';
                    }
                    
                    // for gvw workflow
                    if(crs.Process_Flow__c == CRS_CRSReview.PROCESS_FLOW_GVW_FULL_REVIEW){
                        Current_reviewer_FL = true;
                        Current_reviewer_SRA = true;
                        Current_reviewer_FGD =  false;
                        Current_reviewer_PAC =  false;
                        Current_Reviewers = 'FL,SRA';
                    }
                    
                    
                    CRS_Review__c crsReview = new CRS_Review__c(CRS_Tracking__c=crs.Id
                                                    ,Name=crs.Name + 'rvw'
                                                    ,Active__c=crs.Active__c
                                                    ,Beverage_Category__c=crs.CRS_Beverage_Category__c
                                                    ,CRS_Brand__c=crs.CRS_Brand__c
                                                    ,CRS_Business_Unit__c=crs.CRS_Business_Unit__c
                                                    ,CRS_Country_Names__c=crs.CRS_Country_Names__c
                                                    ,CRS_Type_Names__c=crs.CRS_Type_Names__c
                                                    ,CRS_Flavor_Names__c=crs.CRS_Flavor_Names__c
                                                    ,CRS_Group__c=crs.CRS_Group__c
                                                    ,Initiated_By__c=crs.Initiated_By__c
                                                    ,CRS_Media_Type_Names__c=crs.CRS_Media_Type_Names__c
                                                    ,CRS_Package_Type_Names__c=crs.CRS_Package_Type_Names__c
                                                    ,CRS_Product_Name__c=crs.CRS_Product_Name__c
                                                    ,Review_Status__c=CRS_CRSEdit.CRS_Status_UnderReview
                                                    ,RecordTypeId = crsReviewRT
                                                    ,Current_reviewer_FL__c = Current_reviewer_FL
                                                    ,Current_reviewer_SRA__c = Current_reviewer_SRA
                                                    ,Current_reviewer_FGD__c = Current_reviewer_FGD
                                                    ,Current_reviewer_PAC__c = Current_reviewer_PAC
                                                    ,Current_Reviewers__c = Current_Reviewers
                                                    );
                         
                    crsReviewToInserted.add(crsReview);     
                }
            }            
        }
        if(crsReviewToInserted.size() > 0){
            insert crsReviewToInserted;
        }
        
 String OldCRSStatus='';
       for(CRS__c crs : newCrs) {
           listOfCRSIds.add(crs.Id);
        }
        
        List<CRS__c> crs = [SELECT Id, Internal_Status__c, Status__c, CRS_BU_Legal_Approver__c, CRS_Field_SRA_Approver__c,
                        CRS_Corp_Formula_Governance__c, CRS_Corp_Food_Law_Approver__c, CRS_Corp_SRA_Approver__c,
                        CRS_VP_Chief_Scientific_Regulatory__c, CRS_VP_Science_Division__c, Internal_Status2__c,
                        Process_Flow__c, RecordTypeId, OwnerId, Owner.Email, Owner.LastName
                        FROM CRS__c WHERE Id in: listOfCRSIds];
         List<String> alertNames = new List<String>();
        for(CRS__c cr :crs)
        {        
       
        String RecordTypeName = CRS_MailingRecordTypeHelper.getRecTypeNameById(cr.RecordTypeId);
        if(cr.Status__c == 'Under Review') {
            if (cr.Internal_Status__c == 'Field SRA Approver'){
                if (RecordTypeName == 'CRS submission'
                    && (cr.Internal_Status2__c == 'Wait2')
                    && ((cr.Process_Flow__c == 'Full Review Non-Coke Branded Product')|| (cr.Process_Flow__c == 'Full Review & Notification')) 
                    ) {
                    alertNames.add(Corporate_Level_Attention);
                    alertNames.add(CRS_Status_Change);
                } 
                    else if (RecordTypeName == 'glaceau vitaminwater CRS' ) {
                    alertNames.add(Corporate_Level_Attention_gvw);
                }
                               
                if (cr.Process_Flow__c == 'Full Review Coke Branded Product') {
                   if(cr.Internal_Status2__c == 'Wait2')
                    alertNames.add(Corporate_Level_Attention);
                    alertNames.add(CRS_Status_Change);
                }        
            }
              if (cr.Internal_Status__c == 'Corporate PAC Approver'){
              if (RecordTypeName == 'CRS submission'
                    && (cr.Internal_Status2__c == 'Wait')
                    && ((cr.Process_Flow__c == 'Full Review Non-Coke Branded Product & PAC')|| (cr.Process_Flow__c == 'Full Review Coke Branded Product & PAC') || (cr.Process_Flow__c == 'Full Review & Notification & PAC')) 
                    ) {
                    alertNames.add(Corporate_Level_Attention);
                    alertNames.add(CRS_Status_Change);
                }
                }
         }
             if(cr.Status__c == 'In Process') {
            if (RecordTypeName == 'CRS submission'
                    && (cr.Internal_Status2__c == 'Wait2') &&(cr.Internal_Status__c == 'Corporate PAC Approver')
                    && ((cr.Process_Flow__c == 'Full Review Non-Coke Branded Product & PAC')||(cr.Process_Flow__c == 'Full Review & Notification & PAC')) 
                    ) {
                    alertNames.add(Choose_Send_Corp_Form_Gov);
                }
                }   
     }
     
        system.debug('@@@@@@@@@@@@@@@@' + alertNames);
        for(String alert: alertNames) {
        //ID emailTemplateId = FindEmailTemplateIDByDeveloperName(getEmailTemplateDeveloperName(alert));
        //system.debug('$$$$$$$$$$$$$$44' + emailTemplateId);
           // List<String> groupNames = emailAlerts.get(alert);
            //List<Contact> contacts = getContactsForGroupNames(groupNames, crs, alert);
           // List<User> contacts1 = getContactsForGroupNames(groupNames, crs, alert);
            //sendEmail(contacts1, emailTemplateId, crs);
        }
     }   /*
        private static Boolean sendEmail(List<User> contacts, ID emailTemplateId, List<crs__C>objectId) {
        //insert contacts;

        List<Messaging.SingleEmailMessage>  emails = new List<Messaging.SingleEmailMessage>();
        for (User contact: contacts){
        for(crs__c c:objectId){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(contact.Id);
            //mail.setWhatId(c.Id);
            mail.setTemplateId(emailTemplateId);
            mail.setSaveAsActivity(false);
            emails.add(mail);
        }
        }
        /*Messaging.SendEmailResult [] results = Messaging.sendEmail(emails);
        system.debug('*******' + results);
        for ( Messaging.SendEmailResult result : results) {
            if ( !results[0].isSuccess () ) {
                return false;
            }
        }*/
       // delete contacts;
      //  return true;
    //}
    
    /*
    private static List<User> getContactsForGroupNames(List<String> names, List<CRS__c> crs, String alertName) {
        List<String> gNames = new List<String>();
        Contact owner = null;
        for(String name: names) {
            if(name != 'CRS_Owner') {
                gNames.add(name);
            } else {
            for(crs__c c:crs)
            {
               // owner = new Contact(Email = c.Owner.Email, LastName = c.Owner.LastName);
            }
            }
        }
        
        List<GroupMember> gm = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN (SELECT Id FROM Group WHERE DeveloperName IN :gNames)];
        List<ID> uids = new List<ID>();
        for(GroupMember tgm : gm) {
            uids.add(tgm.UserOrGroupId);
        }
        List<User> usersRecipientList = [SELECT Id, Email, LastName, Do_not_receive_CLA_notification__c FROM User WHERE Id IN :uids];
        
        List<Contact> contacts = new List<Contact>();
        List<User> use = new List<User>();
        for (User user : usersRecipientList) {
            if((alertName == Corporate_Level_Attention || alertName == Corporate_Level_Attention_gvw) && user.Do_not_receive_CLA_notification__c){
                continue;
            }
            /*Contact tempContact = new Contact();
            tempContact.Email = user.Email;
            tempContact.LastName = 'temp_contact:' + user.id;
            contacts.add(tempContact);*/
         // use.add(user);
        //}
        /*if(owner != null){
            contacts.add(owner);
        }*///system.debug('%%%%%%%%%%%%%%%' + contacts);
        //return contacts;
        //return use;
         
    //}
    /*
        public static ID FindEmailTemplateIDByDeveloperName(string DeveloperName) {
   
          id EmailTemplateID;
          
             
          Map <String, id> EmailTemplateResults; 
          
          if (EmailTemplateResults==null) {
            
            EmailTemplateResults = new Map<String, id>();
    
            List<EmailTemplate> EmailTemplates = [SELECT Id, Name, DeveloperName, IsActive FROM EmailTemplate];        
            if (EmailTemplates.size() > 0) {
            for(EmailTemplate emailTemplate: EmailTemplates) {
                if (emailTemplate.IsActive == true) {
                    EmailTemplateResults.put(emailTemplate.DeveloperName, emailTemplate.Id);
                }
            }
            
            }
          }
            System.debug('#################' + DeveloperName );
          if (DeveloperName != null) {
            EmailTemplateID = EmailTemplateResults.get(DeveloperName);
          }
        
          return EmailTemplateID;
     }
    
    public string getEmailTemplateDeveloperName(String emailAlertName) {
        if(emailAlertName == Choose_Send_Corp_Form_Gov) {
            return 'Choose_Send_Corp_Form_Gov2';
        }
        
        if(emailAlertName == CRS_Choose_PAC_Required) {
        system.debug('entered PAC');
            return 'CRS_Choose_PAC_Required';
        }
        if(emailAlertName == CRS_Choose_Send_Corp_Form_Gov_and_PAC) {
            return 'CRS_Choose_Send_Corp_Form_Gov_and_PAC';
        }
        if(emailAlertName == Choose_Send_VP_Science) {
            return 'Choose_Send_VP_Chief_Sc_Reg';
        }
        if(emailAlertName == Choose_Send_VP_Science_Division) {
            return 'Choose_Send_VP_Science_Division';
        }
        if(emailAlertName == Choose_Send_VP_Science_gvw) {
            return 'Choose_Send_VP_Chief_Sc_Reg';
        }
        if(emailAlertName == Corporate_Level_Attention) {
            return 'Corporate_Level_Attention2';
        }
        if(emailAlertName == Corporate_Level_Attention_gvw) {
            return 'Corporate_Level_Attention2';
        }
        if(emailAlertName == CRS_Neglected) {
            return 'CRS_Template';
        }
        if(emailAlertName == CRS_Status_Change) {
            return 'CRS_Status_Change';
        }
        if(emailAlertName == CRS_Status_Change_for_gvw) {
            return 'CRS_Status_Change';
        }
        return null;
    }    */  
 
 
     
     public void UnderReviewApprovalValidation(List<CRS__c> newitpr, Map<Id, CRS__c> oldMapITPR){
      for(CRS__c itprObj: newitpr)
     {
        setITPRIds.add(itprObj.Id);
     }
     List<ProcessInstance> pr = [select Id,targetObjectId from ProcessInstance where targetObjectId in:setITPRIds];
     system.debug('$$$$$$$$$$$' + pr);
     if(pr.size()>0)
     {
      lstProcesses = [SELECT Id,ProcessInstanceId,stepstatus from ProcessInstanceStep where ProcessInstanceId in: pr and stepstatus != 'Pending'];
      }
      system.debug('^^^^^^^^^' + lstProcesses);
      if(lstProcesses.size()>0)
      {
      for(CRS__c itprObj :newitpr)
      {
         for(ProcessInstanceStep po: lstProcesses)
         {
         CRS__c ls = oldMapITPR.get(itprObj.Id);        
         system.debug('********' + po.Stepstatus);
         if(po.Stepstatus != 'Pending')
         {
         if((ls.Status__c =='Under Review') && (itprObj.UnderReviewApprovalValidationCheck__c !=false) && (itprObj.status__c =='Under Review' || itprObj.status__c =='In Process')){
         itprObj.addError('Cannot Approve or reject when status is Under Review');
         }
         }
         }
      
      }
      }
      
 
    
   /* for(CRS__c itprObj :newitpr) {
      CRS__c ls = oldMapITPR.get(itprObj.Id);
      String errorMessage = '';
      if((ls.Status__c =='Under Review') && (itprObj.status__c =='Under Review' || itprObj.status__c =='In Process')){
      if(mapProcesses != null && mapProcesses.size() > 0){
      if(mapProcesses.containsKey(itprObj.Id) && (mapProcesses.get(itprObj.Id).status == 'Approved' || mapProcesses.get(itprObj.Id).status == 'Rejected')){
     itprObj.addError('Cannot Approve or reject when status is Underreview');
     }  
    }
   } 
   }*/
   }    
 }