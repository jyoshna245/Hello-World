/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 05/03/2014
 *  Assumptions      : N/A 
 *  Description      : This class is the controller for the inline visualforce page which was emebedded on an ITPR object
                       This controls the functionalities of buttons on the VF page ITPR.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
public class ITPR {
        /*Variable declaration and initialization*/
        private ITPR__c check;
        public Id id {get;set;}
        private ITPR__c cntr;
        public boolean visible=FALSE;
        public Boolean refreshPage {get; set;} 
        public List<ITPR__c> lst = new List<ITPR__c>();
        public boolean checking ;
        public List<GroupMember> g;
        public String strException{get;set;}
        public Boolean hasMessages { get { return ApexPages.hasMessages(ApexPages.Severity.ERROR); }}

        
    public User loggedInUser = [
                    select Profile.Name,ITPR_Department__c
                    from User
                    where Id = :Userinfo.getUserId() limit 1
                   ];
    public String userProfileName {
        get {
            return loggedInUser.Profile.Name;
        }
    }
    public String userDeptName {
        get {
            return (loggedInUser.ITPR_Department__c != null)? loggedInUser.ITPR_Department__c : null;
        }
    }
    public Id rectype {
        get {
            return [
                    select Id from RecordType where Name = 'In Process' and SobjectType = 'ITPR__c' limit 1
                   ].id;
        }
    }
    
        public boolean getVisibile1()
    {
        if((userinfo.getName() == check.Primary_Assignee__c)||
         (userProfileName != null && userProfileName == System.Label.ITPR_System_Admin)) //new dept changes
        {
             visible=TRUE;
        }
        else
        {
             visible=FALSE;  
        }
        return visible;
    }
    
   public boolean getVisibile()
   {
        if((Userinfo.getName() == check.Submitted_by__c) || (userProfileName != null && userProfileName == System.Label.ITPR_System_Admin) || (Userinfo.getUserId() == check.Submitted_on_behalf_of__c)||(Userinfo.getUserId() == check.Manager__c)|| (Userinfo.getUserId() == check.Delegated_Requestor__c)|| (Userinfo.getUserId() == check.transfered_Requestor__c)) //new dept changes
        {
             visible=TRUE;
        }
        else
        {
             visible=FALSE;  
        }
        return visible;
    }
    
    public boolean getVisibile2()
    {
        if(((userinfo.getUserId() == check.Vendor_Governance__c) ||(userProfileName != null && userProfileName == System.Label.ITPR_System_Admin)) && ((check.Status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status)|| (check.Status__c == System.Label.ITPR_Executed_and_Filed_Status))) //new dept changes
        {
             visible=TRUE;
        }
        else
        {
             visible=FALSE;  
        }
        return visible;
    }
    
    public boolean getVisibile4()
    {
        If((userinfo.getUserId() != check.Vendor_Governance__c)&& (userinfo.getName() != check.Primary_Assignee__c)&& (Userinfo.getName() != check.Submitted_by__c) && (userProfileName != null && userProfileName != System.Label.ITPR_System_Admin) && (Userinfo.getUserId() != check.Submitted_on_behalf_of__c)&&(Userinfo.getUserId() != check.Manager__c)&& (Userinfo.getUserId() != check.Delegated_Requestor__c)&& (Userinfo.getUserId() != check.transfered_Requestor__c)) //new dept changes
        {
             visible=TRUE;
        }
        else
        {
             visible=FALSE;  
        }
        return visible;
    }
    
    public boolean getVisibile3()
    {
        if(g.size() >0)
        {
        if((userinfo.getName() != check.Primary_Assignee__c)&&(userProfileName != null && userProfileName != System.Label.ITPR_System_Admin)) //new dept changes
        {
             visible=TRUE;
        }
        }
        else
        {
             visible=FALSE;  
        }
        return visible;
    }
    
     public boolean getVisibile5()
    {
    //changes made by capgemini for displaying the complete button for legal and legal BA  profile 
        if((userProfileName == System.Label.ITSES_Legal || userProfileName == System.Label.ITSES_Legal_Business_Administrator )&&       
        ((check.Request_Type__c == System.Label.ITPR_Request_Type_NDA) || (check.Request_Type__c == System.Label.ITPR_Request_Type_Other_Legal)
         || (check.Request_Type__c == System.Label.ITPR_Request_Type_Letter_Of_Termination) || (check.Request_Type__c == System.Label.ITPR_Request_Type_Eval_Agreement) || (check.Request_Type__c == System.Label.ITSES_Network_Access_Agreement)) )
          {
             visible=TRUE;
        }
        else
        {
             visible=FALSE;  
        }
     return visible;
    }
    
    
    public boolean submitbtn{
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_Status) ||(check.status__c == System.Label.ITPR_Pending_More_Info_Needed_Status);
            return chk;
        }
    }
    
    
    
    public Boolean accept{
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_Submitted_Status)||(check.status__c == System.Label.ITPR_Assigned_Status);
            return chk;
        }
    }
    
    public Boolean pendingmoreinfo{
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_Submitted_Status);
            return chk;
        }
    }
    
    public Boolean pendingbudget{
        get { 
                if((check.Request_Type__c != System.Label.ITPR_Request_Type_RFI) && (check.Request_Type__c != System.Label.ITPR_Request_Type_RFP))
                {
                Boolean chk = true;
                chk = chk & (check.status__c == System.Label.ITPR_In_Process_Status) ;
                return chk;
                }
                else
                {
                        Boolean chk = false;
                        return chk;
                }
        }
    }
    
     public Boolean onhold {
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_In_Process_Status);
            return chk;
        }
    }
      public Boolean reactivate{
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_On_Hold_Status);
            return chk;
        }
    }
    
    public Boolean cancel{
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_Pending_More_Info_Needed_Status) || (check.status__c == System.Label.ITPR_Pending_Project_Final_Budget_Status)|| (check.status__c == System.Label.ITPR_In_Process_Status);
            return chk;
        }
    }
    
    public Boolean complete1{
        get {
       
            if((check.Request_Type__c == System.Label.ITPR_Request_Type_RFI) || (check.Request_Type__c == System.Label.ITPR_Request_Type_RFP))
            {
                Boolean chk = true;
                chk = chk && (check.status__c == System.Label.ITPR_In_Process_Status);
                return chk;         
            }
            else
            {
                Boolean chk = false;
                return chk;
            }
        }
    }
    
     public Boolean complete2{
        get {
       
            /*if((check.Request_Type__c == System.Label.ITPR_Request_Type_NDA) || (check.Request_Type__c == System.Label.ITPR_Request_Type_Other_Legal) || (check.Request_Type__c == System.Label.ITPR_Request_Type_Letter_Of_Termination) || (check.Request_Type__c == System.Label.ITPR_Request_Type_Eval_Agreement) || (check.Request_Type__c == System.Label.ITSES_Network_Access_Agreement))
            {
                Boolean chk = true;
                chk = chk && (check.status__c == System.Label.ITPR_In_Process_Status);
                return chk;         
            }
            else
            {
                Boolean chk = false;
                return chk;
            }*/
            
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_In_Process_Status);
            return chk;
        }
    }
    
    
    
     public Boolean printcoversheet{
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status) || (check.Status__c == System.Label.ITPR_Complete_Status)||(check.status__c == System.Label.ITPR_Executed_and_Filed_Status);
            return chk;
        }
    }
     public Boolean printcoversheet2{
        get {
                if(userProfileName != null && userProfileName != System.Label.ITPR_System_Admin)
                {
                Boolean chk = true;
                chk = chk && (check.status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status) || (check.Status__c == System.Label.ITPR_Complete_Status)||(check.status__c == System.Label.ITPR_Executed_and_Filed_Status);
                return chk;
                }
                else
                {
                        Boolean chk = false;
                        return chk;
                }
        }
    }
    
    public Boolean ExecutedandFiled{
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status);
            return chk;
        }
    }
    public Boolean NotExecutedandClosed{
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status);
            return chk;
        }
    } 
     
    public Boolean ReOpen{
        get {
            Boolean chk = true;
            chk = chk && (check.status__c == System.Label.ITPR_Cancelled_Status) || (check.status__c == System.Label.ITPR_Complete_Status)||(check.status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status);
            return chk;
        }
    }
    /*end variable declaration and initialization*/
    
    //controllers
    private ApexPages.StandardController controller {get; set;}
        public ITPR(ApexPages.StandardController controller) {
         cntr= (ITPR__c)controller.getRecord();
         id = ApexPages.currentPage().getParameters().get('id');
                check = (id == null) ? new ITPR__c():[select Id,Year_1__c,Year_2__c,Year_3__c,Year_4__c,Year_5__c,Thereafter__c,Status__c,transfered_requestor__c,Long_Term_Commitments_Obligations__c,Guarantees__c,SFAS_133_Embedded_Derivatives__c,Standard_Indemnifications_Including_IP__c,Will_Supplier_Retain_Rights_To_New_IP__c,If_Yes_Explain2__c,If_Yes_Explain1__c,If_No_Explain2__c,Any_Noteworthy_Exceptional_Risk__c,If_No_Explain3__c,Standard_Representations_Warranties__c,RecordTypeId,Request_Type__c,New_Supplier_Financial_Analysis_Done__c,If_No_Explain1__c,If_Yes_Explain3__c,Engagement_Of_A_New_Supplier__c,Are_There_Exceptions_To_LoL__c,Expiration_Date__c,Are_There_Fees_For_Early_Termination__c,Manager__c,CAPEX1__c,CAPEX2__c,CAPEX3__c,OPEX1__c,OPEX2__c,OPEX3__c,Wave1_Approver_1__c,Wave3_Approver_1__c,Primary_Assignee__c,Vendor_Governance__c,Finance_Assignee__c,Submitted_By__c,Delegated_Requestor__c,Submitted_On_Behalf_Of__c,Agreement_ID__c,Cost_Avoidance__c,If_Rqd_Has_Hosting_Cert_Team_Approved__c,If_Required_Has_IT_Security_Approved__c,Labor_Services_Checklist_Completed__c,New_Master_COA_Logged_In_Contract_DB__c,New_COA__c,New_Master__c,Savings__c,Spelling_And_Formatting_Checked__c,Is_System_Participation_Allowed__c,If_Required_Has_The_TRB_Approved__c from ITPR__c where Id =:id];
                strException= 'null';  
       String publicGroupId = [select Id, Name From Group where Name =: System.Label.ITPR_Business_Admin].Id;
      // system.debug(publicGroupId+'group id-----');
       g = [select GroupId,UserOrGroupId from GroupMember where GroupId = :publicGroupId and UserOrGroupId =: userinfo.getuserId()];
       // g = [select GroupId,UserOrGroupId from GroupMember where GroupId = :'00G11000000WgD6EAK' and UserOrGroupId =: userinfo.getuserId()];
                system.debug('######################' + g);
    }
    //called on submit--changes the status to Submitted
    public void Submit()
        {
                system.debug(check.Status__c+'test value------'+System.Label.ITPR_Status);
                if(check.Status__c == System.Label.ITPR_Status || check.Status__c == System.Label.ITPR_Pending_More_Info_Needed_Status) {
                    system.debug(check.CAPEX1__c+'capex--------');
                    if(check.CAPEX1__c!=null || check.CAPEX2__c!=null || check.CAPEX3__c!=null || check.OPEX1__c!=null || check.OPEX2__c!=null || check.OPEX3__c!=null){
        
                        check.Status__c = System.Label.ITPR_Submitted_Status;
                        try{
                                strException ='null';
                                update check;
                        }catch(DmlException ex){
                                strException = 'error';
                                ApexPages.addMessages(ex);           
                        }
                   }
                }                
        }
    //called on accept--changes the status to In Process
        public void Accept()
        {
                if((check.Status__c == System.Label.ITPR_Submitted_Status) || (check.Status__c == System.Label.ITPR_Assigned_Status))
                {
                        check.Status__c = System.Label.ITPR_In_Process_Status;
                        try{
                                strException ='null';
                                update check;
                }catch(DmlException ex){
                        strException = 'error';
                                ApexPages.addMessages(ex);            
                }
                }
        }
        
            public void PendingFinalBudget()
        {
                if(check.Status__c == System.Label.ITPR_In_Process_Status)
                { 
                   List<ITSES_Additional_Attachment__c> finalAttach = [Select Id from ITSES_Additional_Attachment__c where IT_SES_Request__c = :id and Attachment_Type__c = 'Final Attachment'];
                   system.debug('##########finalAttach###########' + finalAttach);
                     List <Attachment> FinalAttachmentCount = [SELECT Attachment.Id FROM Attachment where Attachment.ParentId in: finalAttach ] ;       
                   system.debug('##########FinalAttachmentCount###########' + FinalAttachmentCount);
                        try{
                              if(FinalAttachmentCount .size() <= 0){
                           ApexPages.Message ex = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot move the request forward without adding at least one final attachment in the Final Attachments section.');
                           system.debug('##########FinalAttachmentCountex###########' + ex);
                           ApexPages.addMessage(ex);
                } else {         
                        check.Status__c = System.Label.ITPR_Pending_Project_Final_Budget_Status;
                      
                                strException ='null';
                                 refreshPage=true; 
                                //check.Wave1_Approver_1__c = check.Finance_Assignee__c;
                                update check;
                }
               } catch(DmlException ex){
                        strException = 'error';
                                ApexPages.addMessages(ex);     
                                //return null;       
                }
                }
                //String strURL = '/'+ITPR__c.id; 
                //PageReference pgRef = new PageReference(strURL);
                //return pgRef;
        }

   //called on reopen--changes the status back to In Process
        public void Reopen()
        {
                if((check.Status__c == System.Label.ITPR_Cancelled_Status) ||(check.Status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status)|| (check.Status__c == System.Label.ITPR_Complete_Status))
                {
                        check.Status__c = System.Label.ITPR_In_Process_Status;
            try{
                                strException ='null';
                                update check;
                }catch(DmlException ex){
                        strException = 'error';
                                ApexPages.addMessages(ex);            
                }
                }
        }
    //called on reopen--changes the status back to In Process
        public void Reactivate()
        {
                if(check.Status__c == System.Label.ITPR_On_Hold_Status)
                {
                        check.Status__c = System.Label.ITPR_In_Process_Status;
                }
                try{
                        strException ='null';
                        update check;
        }catch(DmlException ex){
                strException = 'error';
                        ApexPages.addMessages(ex);            
        }
        }

    //called on ExecutedAndFiled--changes the status to Executed and Filed
        public void ExecutedAndFiled()
        {
                if(check.Status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status)
                {
                        check.Status__c = System.Label.ITPR_Executed_and_Filed_Status;
                        try{
                                strException ='null';
                                update check;
                }catch(DmlException ex){
                        strException = 'error';
                                ApexPages.addMessages(ex);            
                }
                }
        }
        
       //Called on Save Additional Approvers 
        public Pagereference saveApprovers(){   
             if(cntr.Additional_Approver_1__c == null && cntr.Additional_Approver_2__c == null && cntr.Additional_Approver_3__c == null)
             {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'You should must select at least one Additional Approver.'));
                 return null;
             }      
            else if((cntr.Additional_Approver_1__c == cntr.Additional_Approver_2__c || cntr.Additional_Approver_1__c == cntr.Additional_Approver_3__c || cntr.Additional_Approver_2__c == cntr.Additional_Approver_3__c) && 
                    ((cntr.Additional_Approver_1__c != null && cntr.Additional_Approver_2__c != null) || (cntr.Additional_Approver_1__c != null && cntr.Additional_Approver_3__c != null ) || (cntr.Additional_Approver_2__c != null && cntr.Additional_Approver_3__c != null))
                   )
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Same Approver cannot be selected more than once.'));
                 return null;
                }
                else {
             check.Additional_Approver_1__c = cntr.Additional_Approver_1__c;
             check.Additional_Approver_2__c = cntr.Additional_Approver_2__c;
             check.Additional_Approver_3__c = cntr.Additional_Approver_3__c;
             try{
                   strException ='null';
                   update check;
                }
                catch(DmlException ex)
                {
                        strException = 'error';
                         ApexPages.addMessages(ex);            
                }
                
                  PageReference addApproverPage = new PageReference('/'+check.id);
                  addApproverPage .setRedirect(true);
                  return addApproverPage ;
            }

      

     } 



        
}
/*********************************************END*****************************************************************************************************************/