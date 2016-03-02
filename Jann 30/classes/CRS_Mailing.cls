global with sharing class CRS_Mailing {
    public static final String APPROVAL_STEP_BULEGAL = 'BU Legal Approver';
    public static final String APPROVAL_STEP_FIELDSRA = 'Field SRA Approver';
    public static final String APPROVAL_STEP_CORPFORMULAGOVERN = 'Corp Formula Govern Approver';
    public static final String APPROVAL_STEP_CORPFOODLAW = 'Corporate Food Law Approver';
    public static final String APPROVAL_STEP_CORPSRA = 'Corporate SRA Approver';
    public static final String APPROVAL_STEP_VPCHIEF = 'VP-Chief Sc and Reg Officer';
    public static final String APPROVAL_STEP_VPSCIENCEDIVISION = 'VP-Science Division';
    public static final String APPROVAL_STEP_BUPAC = 'BU PAC Approver';
    public static final String APPROVAL_STEP_CORPPAC = 'Corporate PAC Approver';
    
    public static final String Choose_Send_Corp_Form_Gov = 'Choose_Send_Corp_Form_Gov';
    public static final String Choose_Send_VP_Science = 'Choose_Send_VP_Science';
    public static final String Choose_Send_VP_Science_Division = 'Choose_Send_VP_Science_Division';
    public static final String Choose_Send_VP_Science_gvw = 'Choose_Send_VP_Science_gvw';
    public static final String Corporate_Level_Attention = 'Corporate_Level_Attention';
    public static final String Corporate_Level_Attention_gvw = 'Corporate_Level_Attention_gvw';
    public static final String CRS_Neglected = 'CRS_Neglected';
    public static final String CRS_Status_Change = 'CRS_Status_Change';
    public static final String CRS_Status_Change_for_gvw = 'CRS_Status_Change_for_gvw';
    
    private static Map<String, List<String>> emailAlerts = new Map<String, List<String>> {
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
    
    
    private static List<String> getEmailAlertsNames(CRS__c crs, boolean isSend) {
        List<String> alertNames = new List<String>();
        String RecordTypeName = CRS_MailingRecordTypeHelper.getRecTypeNameById(crs.RecordTypeId);
        if(crs.Status__c == 'In Process') {
            if (crs.Internal_Status__c == 'Field SRA Approver'){
                if (RecordTypeName == 'CRS submission'
                    && (crs.Internal_Status2__c == 'Wait2' || isSend)
                    && crs.Process_Flow__c != 'Full Review Coke Branded Product' 
                    && crs.Process_Flow__c != 'Notification') {
                    alertNames.add(Corporate_Level_Attention);
                    alertNames.add(Choose_Send_Corp_Form_Gov);
                } else if (RecordTypeName == 'glaceau vitaminwater CRS' && isSend) {
                    alertNames.add(Corporate_Level_Attention_gvw);
                }
                if (crs.Process_Flow__c == 'Full Review Coke Branded Product' && isSend) {
                    alertNames.add(Corporate_Level_Attention);
                }
            }
            
            // Resends an alert on the third step of The Approval Process #1b, #2.
            if (crs.Internal_Status__c == 'Corporate Food Law Approver' && !isSend) {
                if (RecordTypeName == 'glaceau vitaminwater CRS') {
                    alertNames.add(Corporate_Level_Attention_gvw);
                }
                if (crs.Process_Flow__c == 'Full Review Coke Branded Product') {
                    alertNames.add(Corporate_Level_Attention);
                }
            }

            if (crs.Internal_Status__c == 'Corporate SRA Approver' && (crs.Internal_Status2__c == 'Wait2' || isSend)) {
                if (RecordTypeName == 'CRS submission') {
                    alertNames.add(Choose_Send_VP_Science);
                } else if (RecordTypeName == 'glaceau vitaminwater CRS') {
                    alertNames.add(Choose_Send_VP_Science_gvw);
                }
            }

            if(crs.Internal_Status__c == 'Corp Formula Govern Approver' && (crs.Internal_Status2__c == 'Wait2' || isSend)
               && crs.Process_Flow__c == 'Full Review Coke Branded Product') {
                alertNames.add(Choose_Send_VP_Science_Division);
            }
        }
        return alertNames;
    }

    private static List<Contact> getContactsForGroupNames(List<String> names, CRS__c crs, String alertName) {
        List<String> gNames = new List<String>();
        Contact owner = null;
        for(String name: names) {
            if(name != 'CRS_Owner') {
                gNames.add(name);
            } else {
                owner = new Contact(Email = crs.Owner.Email, LastName = crs.Owner.LastName);
            }
        }
        
        List<GroupMember> gm = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN (SELECT Id FROM Group WHERE DeveloperName IN :gNames)];
        List<ID> uids = new List<ID>();
        for(GroupMember tgm : gm) {
            uids.add(tgm.UserOrGroupId);
        }
        List<User> usersRecipientList = [SELECT Id, Email, LastName, Do_not_receive_CLA_notification__c FROM User WHERE Id IN :uids];
        
        List<Contact> contacts = new List<Contact>();
        for (User user : usersRecipientList) {
            if((alertName == Corporate_Level_Attention || alertName == Corporate_Level_Attention_gvw) && user.Do_not_receive_CLA_notification__c){
                continue;
            }
            Contact tempContact = new Contact();
            tempContact.Email = user.Email;
            tempContact.LastName = 'temp_contact:' + user.id;
            contacts.add(tempContact);
        }
        if(owner != null){
            contacts.add(owner);
        }
        return contacts;
    }
    
    private static String getEmailTemplateDeveloperName(String emailAlertName) {
        if(emailAlertName == Choose_Send_Corp_Form_Gov) {
            return 'Choose_Send_Corp_Form_Gov2';
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
    }
    
    private static String getFieldNameWithApprovers(String internalStatus){
        if (internalStatus==APPROVAL_STEP_BULEGAL){
            return 'CRS_BU_Legal_Approver__c';
        } else if (internalStatus==APPROVAL_STEP_FIELDSRA){
            return 'CRS_Field_SRA_Approver__c';
        } else if (internalStatus==APPROVAL_STEP_CORPFORMULAGOVERN){
            return 'CRS_Corp_Formula_Governance__c';
        } else if (internalStatus==APPROVAL_STEP_CORPFOODLAW){
            return 'CRS_Corp_Food_Law_Approver__c';
        } else if (internalStatus==APPROVAL_STEP_CORPSRA){
            return 'CRS_Corp_SRA_Approver__c';
        } else if (internalStatus==APPROVAL_STEP_VPCHIEF){
            return 'CRS_VP_Chief_Scientific_Regulatory__c';
        } else if (internalStatus==APPROVAL_STEP_VPSCIENCEDIVISION){
            return 'CRS_VP_Science_Division__c';
        } 
        //#crs enahncement modification, 26 nov 2014
        else if (internalStatus==APPROVAL_STEP_BUPAC){   
            return 'CRS_BU_PAC_Approver__c';
        } else if (internalStatus==APPROVAL_STEP_CORPPAC){
            return 'CRS_Corporate_PAC_Approver__c';
        }
        return null;
    }
    
    @RemoteAction
    webService static void sendEmailAlert(String crsName, String priority, boolean isSend) {
        CRS__c crs = [SELECT Id, Internal_Status__c, Status__c, CRS_BU_Legal_Approver__c, CRS_Field_SRA_Approver__c,
                        CRS_Corp_Formula_Governance__c, CRS_Corp_Food_Law_Approver__c, CRS_Corp_SRA_Approver__c,
                        CRS_VP_Chief_Scientific_Regulatory__c, CRS_VP_Science_Division__c, Internal_Status2__c,
                        Process_Flow__c, RecordTypeId, OwnerId, Owner.Email, Owner.LastName
                        FROM CRS__c WHERE Name=:crsName limit 1];
        List<String> emailAlertsList = getEmailAlertsNames(crs, isSend);
        if(emailAlertsList == null) {
            return;
        } 
        if(priority == ''){priority = null;}
        for(String alert: emailAlertsList) {
            ID emailTemplateId = FindEmailTemplateIDByDeveloperName(getEmailTemplateDeveloperName(alert));
            List<String> groupNames = emailAlerts.get(alert);
            List<Contact> contacts = getContactsForGroupNames(groupNames, crs, alert);
            sendEmail(contacts, emailTemplateId, crs.Id, priority);
        }
    } 
    
    @RemoteAction
    webService static String showReSendLink(String crsId, String apprGrp) {
        CRS__c crs = [select Initiated_By__c, Status__c, Internal_Status__c, OwnerId, Internal_Status2__c from CRS__c where id=:crsId LIMIT 1];
        Id userId = UserInfo.getUserId();
        List<GroupMember> lastApprs = [select Id from GroupMember where GroupId = :apprGrp and UserOrGroupId = :userId];
        if(crs != null && (crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess || crs.Status__c==CRS_CRSEdit.CRS_Status_NewSubmission) && crs.Internal_Status2__c != 'NotStarted'){
            if(!([select Id from Profile where Id=:UserInfo.getProfileId() 
                   and (Name = :CRS_CRSEdit.getBAProfileName() or Name = :CRS_CRSEdit.getSAProfileName())].isEmpty())
               || crs.Initiated_By__c == userId || crs.OwnerId == userId || !lastApprs.isEmpty()) {
                List<CRS_Message__c> crsMessage = [select Id from CRS_Message__c where CRS__c = :crs.Id];
                return crsMessage.isEmpty()?'new':crsMessage[0].Id;
            }
        }
        return 'false';
    }
    
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
           
           
          if (DeveloperName != null) {
            EmailTemplateID = EmailTemplateResults.get(DeveloperName);
          }
         
          return EmailTemplateID;
     }
     
    private static List<Contact> getContacts(CRS__c crs) {
        String approversField = getFieldNameWithApprovers(crs.Internal_Status__c);
        if (approversField == null){
            return null;
        }
        String ids = ((String)crs.get(approversField));
        List<String> approverIds = ids.split(';');
        List<User> usersRecipientList = [SELECT Id, Email, LastName FROM User WHERE Id IN :approverIds];
        List<Contact> contacts = new List<Contact>();
        
        
        for (User user : usersRecipientList) {
            Contact tempContact = new Contact();
            tempContact.Email = user.Email;
            tempContact.LastName = 'temp_contact:' + user.id;
            contacts.add(tempContact);
        }
        return contacts;
    }

    private static Boolean sendEmail(List<Contact> contacts, ID emailTemplateId, Id objectId, String priority) {
        insert contacts;

        List<Messaging.SingleEmailMessage>  emails = new List<Messaging.SingleEmailMessage>();
        for (Contact contact: contacts){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(contact.Id);
            mail.setWhatId(objectId);
            mail.setTemplateId(emailTemplateId);
            mail.setSaveAsActivity(false);
            if(priority != null) {
                mail.setEmailPriority(priority);
            }
            emails.add(mail);
        }
        Messaging.SendEmailResult [] results = Messaging.sendEmail(emails);
        for ( Messaging.SendEmailResult result : results) {
            if ( !results[0].isSuccess () ) {
                return false;
            }
        }
        delete contacts;
        return true;
    }

    @RemoteAction
    webService static void resendEmail(String crsName){
        CRS__c crs = [SELECT Id, Internal_Status__c, Status__c, CRS_BU_Legal_Approver__c, CRS_Field_SRA_Approver__c,
                        CRS_Corp_Formula_Governance__c, CRS_Corp_Food_Law_Approver__c, CRS_Corp_SRA_Approver__c,
                        CRS_VP_Chief_Scientific_Regulatory__c, CRS_VP_Science_Division__c, Internal_Status2__c, CRS_BU_PAC_Approver__c,CRS_Corporate_PAC_Approver__c  
                        FROM CRS__c WHERE Name=:crsName limit 1];
        List<CRS_Message__c> crsMessage = [select Id, High_Priority__c,CreatedDate  from CRS_Message__c where CRS__c = :crs.Id order by CreatedDate desc limit 1]; //added for Defect 41(12/4/2014)               
        if(!crsMessage.isEmpty()) {
            List<ProcessInstance> approvals = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :crs.Id AND Status = 'Pending'];
            String priority = crsMessage[0].High_Priority__c?'High':null;
            sendEmailAlert(crsName, priority, false);
            if(!approvals.isEmpty()){
                List<Contact> contacts = getContacts(crs);
                ID emailTemplateId = FindEmailTemplateIDByDeveloperName('CRS_Assign_Approval_Resend');
                sendEmail(contacts, emailTemplateId, crsMessage[0].Id, priority);
            }
        }
    }

    @RemoteAction
    webService static void sendEmailAlertByCRSName(String crsName) {
        sendEmailAlert(crsName, null, true);
    }

    /**
     *  wrapper getContactsForGroupNames for testing.
     */
    public static List<Contact> testGetContactsForGroupNames(List<String> names, CRS__c crs, String alertName) {

        if (!Test.isRunningTest()){
            throw new CRS_TestException('This method can only be called from a test.');
        }

        return CRS_Mailing.getContactsForGroupNames(names, crs, alertName);
    }

    /**
     *  wrapper getContacts for testing.
     */
    public static List<Contact> testGetContacts(CRS__c crs) {
        
        if (!Test.isRunningTest()){
            throw new CRS_TestException('This method can only be called from a test.');
        }

        return CRS_Mailing.getContacts(crs);
    }
}