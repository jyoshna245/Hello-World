/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC04_CompletionMemoController
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 4/6/2012 
 *  Assumptions      : N/A
 *  Description      : Class for sending email to group of people chosen by the user when the RFA is either Approved or Rejected 
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

public class RFA_VFC04_CompletionMemoController {
    
    // instance of RFA__c
    public RFA__c rfaObj{get;set;}
    
    // List of type selectOption for available list of org recipients
    public list<user> toList{get;set;}

    // List of type selectOption for available list of org recipients
    public SelectOption[] selectableRecipients{get;set;}
    
    // List of type SelectOption for list of selected recipients from the visualforce page.
    public SelectOption[] selectedRecipients{get;set;}
    
    // String variable for user inputed CC list of recipients.        
    public String selectedCCusers{get; set;}    

    // boolean variable used as identifier for any failures.
    public boolean hasError{get; private set;}
    public boolean hideOKButton{get;set;}
    public Boolean isRFAPolicy{get;set;} //added mpascua 10/14/2013 for checking if rfa type  is policy exemption
  
    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP = RFAGlobalConstants.RECORDTYPESMAP;
    public static Map<String, RecordType> toLstRecordTypeMap = RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
    //for FR 1.26 Q3 RLC
    public static Map<String, RecordType> rfaRecordTypeMap = RECORDTYPESMAP.get(Schema.sObjectType.RFA__c.getName());
    Apexpages.StandardController ctlr = null;

    // constructor for the class            
    public RFA_VFC04_CompletionMemoController(ApexPages.StandardController controller) {
        this.hideOKButton = true;
        this.rfaObj = (RFA__c)controller.getRecord();
        ctlr= controller;
        
        if(rfaObj.Id <> null)
        {
            this.rfaObj = [Select Id, Subject__c, Thefollowingitem__c, ProfitCenterNumber__c,
                       ProfitCenterName__c, ControlNumber__c, Functional_Currency__c, Functional_Currency__r.Name,
                       Theapprovalstatusofyourrequestis__c, CommentsConditions__c,
                       ApprovalLetterComments__c, Business_Unit__c, RequestTitle__c,   
                       LocalReferenceNumber__c, RequestAmountFunctionalCurrency__c, RequestAmountUSD__c,
                       toEmailAddressCM__c,ccEmailAddressCM__c, CreatedById, RecordTypeId, Stage__c, Expiration_Date__c, Comments_aboutr__c  
                       FROM RFA__c 
                       WHERE Id =: rfaObj.Id];
        
            //---Added by mpasccua@coca-cola.com Aug 22, 2013 for FR 1.32
            if(this.rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id) {
                 this.isRFAPolicy = true;
            }else{
                 this.isRFAPolicy = false;
            }

            ApexPages.Message rfaStageMessage = new ApexPages.Message(ApexPages.Severity.INFO, 'RFA has been successfully '+this.rfaObj.Stage__c + '. Complete the form below to send a Completion Memo.');
            ApexPages.addmessage(rfaStageMessage);
            //-----------------
         /*         
         Requirement #FR1.89
         Description #On Completion Memo, To have default value as "Not Applicable" in the ApprovalLetterComments__c picklist.
         History     #Added by ASHWANI KAUSHIK on 03-May-2013
         */
         if(rfaObj.ApprovalLetterComments__c==NULL) rfaObj.ApprovalLetterComments__c=Label.RFA_FR1_89;                   
         
         /*
         Requirement #FR1.26
         Description #To populate Comments/Condition field with Approver comments and recommendations if the approval is (Conditionally Approved OR Rejected).
         History     #Added by ASHWANI KAUSHIK on 03-May-2013
         */
         list<RFAUserRole__c> rfaUserList = [Select Id,UserName__r.name,ApprovalRecommendation__c,ApprovalComments__c FROM RFAUserRole__c 
                                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id ) 
                                   and (ApprovalRecommendation__c=:Label.RFA_CL058 OR ApprovalRecommendation__c=:Label.RFA_CL059) 
                                   and RFA__c =: rfaObj.Id];
                                   
          // For Defect 26 comments not always showing up - Roy Castillo Nov 4, 2013
          // Original Code =  if(rfaObj.CommentsConditions__c ==NULL && rfaUserList.size()>0)
               
        // if(rfaObj.CommentsConditions__c ==NULL || rfaObj.CommentsConditions__c !=NULL)
         //{      
                        
        //if(rfaUserList.size()>0)- COMMENTED FOR DEBUGGING PURPOSES - ROY FEB 3, 2014
        if(rfaObj.CommentsConditions__c ==NULL && rfaUserList.size()>0)

            {
            String defaultComments= '';
            
            
             Integer TextLimit=Schema.SObjectType.RFA__c.fields.CommentsConditions__c.getLength();
            
            
                for(RFAUserRole__c ur:rfaUserList)
                if (!string.isblank(ur.ApprovalComments__c) ) // added this line not to include null comments
                {
                  defaultComments+=ur.UserName__r.name+' - '+ur.ApprovalRecommendation__c+' - '+ur.ApprovalComments__c+'\n\n';

                }
                
                
                system.debug('Value of the comments field '+defaultComments.length());
              
              if(defaultComments.length() > TextLimit )
                {
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Comments/Conditions has been truncated as the text size exceeded the maximum allowed character limit i.e. '+TextLimit+' Characters');
                   ApexPages.addmessage(myMsg);
                   rfaObj.CommentsConditions__c=defaultComments.substring(0,TextLimit);
                }
                else
                {
                    rfaObj.CommentsConditions__c=defaultComments ;
                } 
            }                           
              
           //   }                     
        //End               
                 
                 
           
                 
                       
                       
        }
        selectedRecipients = new List<SelectOption>();
        
        selectableRecipients = getSelectableUsers();

        toList = new list<user>();
        toList = gettoList();
        
    }
    //---- added by mpascua@coca-cola.com Aug 22, 2013
    public pageReference cancelSendEmail()
    {
                    
        ApexPages.Message rfaStageMessage = new ApexPages.Message(ApexPages.Severity.INFO, 'RFA Completion Memo has not been sent. Contact Corporate Capital Management if RFA Completion Memo is needed.');
        ApexPages.addmessage(rfaStageMessage);
        
        hideOKButton = false;
        return null;
    }
    
    //---------
    
     /* @Method <This method sends completion memo to selected list of recipients in TO and CC list>
        @param <None> 
        @return <pagereference>
     */
    public pageReference sendEmail()
    {   
        //reset the error variable
        hasError = false;   
        Database.Saveresult[] result;   
        
        Savepoint sp = Database.setSavepoint();
        
        List<String> toAddresses = new List<String>();
        
        List<String> ccdUsers = new List<String>();
        String toEmailAddressCM, ccEmailAddressCM;
        
        try{
                        
            System.debug('\n Selected CCd users :'+selectedCCusers);
            
            System.debug('\n selected recipients :' +selectedRecipients);
                        
           /*if(selectedCCusers <> null || selectedCCusers <> '')
            {
                if(selectedCCusers.contains(';'))ccdUsers.addAll(selectedCCusers.split(';',0));
                else if(!RFAGlobalConstants.isBlank(selectedCCusers))ccdUsers.add(selectedCCusers);
            }*/
            /*if(selectedRecipients.isEmpty()) throw new CompletionMemoException('Please select recipients in To Addresses');*/
            
            /*for(SelectOption option : selectedRecipients)
            {
                toAddresses.add(option.getValue()); 
            }*/
            for(User toUser : toList){
                toAddresses.add(toUser.Email); 
                if(toEmailAddressCM!=null){toEmailAddressCM = toEmailAddressCM+','+toUser.Name;}
                else{toEmailAddressCM = toUser.Name;}
                
            }
            for(SelectOption option : selectedRecipients)
            {
                ccdUsers.add(option.getValue()); 
                if(ccEmailAddressCM!=null){ccEmailAddressCM = ccEmailAddressCM+','+option.getLabel();}
                else{ccEmailAddressCM = option.getLabel();}
            }            
            
            
            if((rfaObj.Thefollowingitem__c == null || rfaObj.Thefollowingitem__c == '') && !(this.isRFAPolicy)) throw new CompletionMemoException('Please Select a value for This Request was Circulated To:');
            
            if(rfaObj.Theapprovalstatusofyourrequestis__c == null || rfaObj.Theapprovalstatusofyourrequestis__c == '') throw new CompletionMemoException('Please select Final Approval Status for the Request');
            // - added && condition in following line by Ashwani on 22 Apr 2013 for FR1.88
            if((rfaObj.CommentsConditions__c == null || rfaObj.CommentsConditions__c == '') && (rfaObj.Theapprovalstatusofyourrequestis__c!=Label.RFA_CL057)) throw new CompletionMemoException('Please Add Comments/Conditions');
            
            if((rfaObj.ApprovalLetterComments__c == null || rfaObj.ApprovalLetterComments__c == '') && !(this.isRFAPolicy)) throw new CompletionMemoException('Please select Followup: Approver Comments/Conditions');
            
           
            /****/
            rfaObj.toEmailAddressCM__c=null; //assigning null value before updating.
            rfaObj.ccEmailAddressCM__c=null; //assigning null value before updating.
                if(toEmailAddressCM!=null)rfaObj.toEmailAddressCM__c = toEmailAddressCM;
                if(ccEmailAddressCM!=null)rfaObj.ccEmailAddressCM__c = ccEmailAddressCM;
            
            /****/
                

            result = Database.update(new List<RFA__c>{rfaObj});
            
            if(result[0].isSuccess())
            {
                sendCompletionMemoEmail(toAddresses, ccdUsers, UserInfo.getUserId(), rfaObj.Id);            
                RFA_WS04_PDFGeneratorCM.PDFGenerator(rfaObj.Id,UserInfo.getSessionId());
            }
          
            
      }
        catch(Exception ex)
        {
            Database.rollback(sp);
            hasError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            
            return null;
        }
        
        //ApexPages.StandardController sc = new ApexPages.StandardController(rfaObj);
        
        //return sc.view();
        ApexPages.Message rfaStageMessage = new ApexPages.Message(ApexPages.Severity.INFO, 'RFA Completion Memo has been sent. Click OK to close this message.');
        ApexPages.addmessage(rfaStageMessage);
        hideOKButton = false;

        return null;
    }
    
    
    /* @Method <This method sends completion memo to selected list of recipients in TO and CC list>
        @param <List<String>, List<String>, String, String> 
        @return <pagereference>
     */
    public void sendCompletionMemoEmail(List<String> toAddresses, List<String> ccAddresses, String targetObjectId, String whatId)
    {
        System.debug('\n To recipient address :'+toAddresses);
        System.debug('\n To CCD address :'+ccAddresses);
           
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        mail.setToAddresses(toAddresses);
        // for Completion memo - Policy Exemption Request FR 1.26 Q3 Release RLC
        //if (rfaobj.RecordType == Label.RFA_FR_1_11)
         system.debug('*****rfaObj.RecordTypeId : ' + rfaObj.RecordTypeId );
        system.debug('*****rfaRecordTypeMap.get :' +  rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id);

        if ((rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id)) {
            system.debug('*****inside if');
            mail.setTemplateId(Label.RFA_CL146);
        } else {
            mail.setTemplateId(Label.RFA_CL048);
        }
        system.debug('*****Line 225');
        if(ccAddresses.size() > 0)mail.setCcAddresses(ccAddresses);
        mail.setWhatId(whatId);
        mail.setTargetObjectId(targetObjectId);
        mail.saveAsActivity = false;
        
        mail.orgWideEmailAddressId=Label.RFA_CL131; //-added by RSAS 11-Oct-2012 for INC0075225
        
        mails.add(mail);
        Messaging.sendEmail(mails);      
       
    }
      
    public List<SelectOption> getSelectableUsers()
    {
        List<SelectOption> options = new List<SelectOption>();
        Set<String> associatedUsersIds = new Set<String>();
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.User;
        String userKeyPrefix = d.getKeyPrefix();  
                                     
        for(RFA__Share rfaShare : [Select ParentId, RowCause, UserOrGroupId FROM RFA__Share WHERE ParentId = : rfaObj.Id LIMIT 1000])
        {
            String userAssociated = rfaShare.UserOrGroupId;
            if(userAssociated.substring(0,3) == userKeyPrefix)
                associatedUsersIds.add(rfaShare.UserOrGroupId); 
        }
               
        for(User user : [Select Id, Name, FirstName, LastName, Email From User where isActive = true AND Id IN: associatedUsersIds ORDER BY FirstName LIMIT 1000])
        {
            //if(user.Id <> userInfo.getUserId())
            //{
            if(user.Name <> 'RFA System')
                options.add(new SelectOption(user.Email, user.Name));
           // }
        }
        
        return options;                                                 
    }

/*
Function for ToList user's
*/

    public List<user> gettoList()
    {
        List<User> toListVal = new List<User>();
        Set<String> associatedUsersIds = new Set<String>();
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.User;
        String userKeyPrefix = d.getKeyPrefix();  
                                     
        /*for(RFA__Share rfaShare : [Select ParentId, RowCause, UserOrGroupId FROM RFA__Share WHERE ParentId = : rfaObj.Id LIMIT 1000])
        {
            String userAssociated = rfaShare.UserOrGroupId;
            if(userAssociated.substring(0,3) == userKeyPrefix)
                associatedUsersIds.add(rfaShare.UserOrGroupId); 
        }*/
        set<string> AppRec = new set<string>();
        AppRec.add('Unconditionally Approved');
        AppRec.add('Conditionally Approved');
        AppRec.add('Rejected'); //add for defect 17 to add Group Coordinator when request is Rejected - RLC Nov 21, 2013
        set<string> AppLevel = new set<string>();
        appLevel.add('3. Group');
        AppLevel.add('4. Corporate');
        AppLevel.add('5. Executive');
        AppLevel.add('6. Senior Executive');
        
        associatedUsersIds.add(rfaObj.CreatedById);
        associatedUsersIds.add(UserInfo.getUserId());
        
        
        /*****************************************************************************/
           list<RFAUserRole__c> rfaUserList = [Select Id FROM RFAUserRole__c 
                                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id ) 
                                   and RFA__c =: rfaObj.Id
                                   and ApprovalRecommendation__c in : AppRec
                                   and Level__c in: AppLevel];
                if(rfaUserList.size()>0 && rfaObj.ProfitCenterName__c!=null)
                {
                    for(ProfitCenterUserRole__c PCUR: [select ProfitCenter__c, UserName__c, UserName__r.Name from ProfitCenterUserRole__c 
                                                       where  ProfitCenter__c =:rfaObj.ProfitCenterNumber__c 
                                                       and  UserType__c ='Location Coordinator'
                                                       and Level__c='3. Group'])
                    {   
                        if(PCUR.UserName__c!=null)
                        {
                           associatedUsersIds.add(PCUR.UserName__c);
                        }
                    }
                } 
        /*****************************************************************************/
         set<ID> rtID = new set<ID>();
         rtID.add(toLstRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id);
         rtID.add(toLstRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id);
         for(RFAUserRole__c rfaUser : [Select UserName__c FROM RFAUserRole__c where (RecordTypeId in: rtID ) and RFA__c =: rfaObj.Id])
        {
            String userAssociated = rfaUser.UserName__c;
            if(userAssociated.substring(0,3) == userKeyPrefix)
                associatedUsersIds.add(rfaUser.UserName__c); 
        }


        for(User user : [Select Id, Name, FirstName, LastName, Email From User where isActive = true AND Id IN: associatedUsersIds ORDER BY FirstName LIMIT 1000])
        {
            //if(user.Id <> userInfo.getUserId())
            //{
            if(user.Name <> 'RFA System')
                toListVal.add(user);
           // }
        }
        return toListVal;                                                 
    }



    public String notNull(String check)
    {
        String returnString = ' ';
        if(check <> null) returnString = check;
        return returnString ;
    }
    
    public Class CompletionMemoException extends Exception{}
   
 }