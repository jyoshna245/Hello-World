/****************************************************************************************************************************************
****************************************************************************************************************************************    
*  Class            : RFA_VFC04_ApprovalProcessController extends RFA_Util_SecurityMatrix
*  Author           : Accenture
*  Version History  : 1.0
*  Creation         : 4/6/2012 
*  Assumptions      : N/A
*  Description      : This class contains logic for taking approval recommendation from the approvers/agents.
****************************************************************************************************************************************
****************************************************************************************************************************************/
public class RFA_VFC04_ApprovalProcessController extends RFA_Util_SecurityMatrix
{
    // instance variable for UserAccess set in RFA_Util_SecurityMatrix
    private UserAccess uAccess;
    
    // instance variable of RFAuserRole__c
    public RFAUserRole__c appWorkItem{get;set;}
    
    // variable for selected approval workitem
    public String selectedWorkItem{get; set;}
    
    // variable for storing the recommendation selected by the user
    public String selectedRecommendation{get;set;}
    
    // instance variable of RFA__c
    public RFA__c rfaObj{get; private set;}
    
    // variable for storing the approval comments provided by the user
    public String approvalComments{get;set;}
    
    // instance list variable for workitem options
    public List<SelectOption> workItemOptions{get;set;}
    
    // identifier variable for transaction failure
    public boolean hasError{get;private set;}
    
    // list variable of workitem list with approver/agent details
    public static List<RFAUserRole__c> onBehalfList = new List<RFAUserRole__c>();
    
    // constructor for the class.  
    public RFA_VFC04_ApprovalProcessController(ApexPages.StandardController controller)
    {
        // call parent class constructor
        super(controller);  
        // set rfaobj
        this.rfaObj = (RFA__c)controller.getRecord();
        // get UserAccess security settings
        uAccess = getRFAUserAccess();
        
        if(uAccess.isApprover() || uAccess.isAgent())
            prepareWorkItem();            
    }
    
    /*@Method <getter and setter method to check if the logged in user is agent>
@param <None> 
@return <boolean>
*/
    public boolean isAgent{
        get{
            return uAccess.isAgent();
        }
        private set;
    }
    
    
    /*@Method <getter and setter method to check if the logged in user is approve>
@param <None> 
@return <boolean>
*/
    public boolean isApprover{
        get{
            return uAccess.isApprover();
        }
        private set;
    }
    
    /*@Method Prepare ACT ON BEHALF select list for the usert>
@param <None> 
@return <void>
*/    
    public void prepareWorkItem()
    {
        String loggedInUser = UserInfo.getUserId();
        onBehalfList = RFA_AP03_ApprovalProcessHelper.getApproversForProcess(loggedInUser, rfaObj);  
        workItemOptions = new List<SelectOption>();
        
        for(RFAUserRole__c wi : onBehalfList)
        {
            if(wi.UserName__c == loggedInUser)
            {
                workItemOptions.add(new SelectOption(wi.Id, wi.UserName__r.Name));  
            }
            else if(wi.Agent1__c == loggedInUser)
            {
                workItemOptions.add(new SelectOption(wi.Id, wi.UserName__r.Name));  
            }
            else if(wi.Agent2__c == loggedInUser)
            {
                workItemOptions.add(new SelectOption(wi.Id, wi.UserName__r.Name)); 
            }
            else if(wi.Agent3__c == loggedInUser)
            {
                workItemOptions.add(new SelectOption(wi.Id, wi.UserName__r.Name)); 
            }
        }                          
    }
    
    
    /*@Method <Action method executed when the user clicks on "Submit" button, method contains logic to insert recommendation>
@param <None> 
@return <pagereference>
*/
    public pageReference submitRecommendation()
    {
        try{
            hasError = false;
             
            if(selectedRecommendation == '--Select Recommendation--') throw new ApprovalException('Please provide a Recommendation');
            if(selectedRecommendation == 'Conditionaly Approved' && approvalComments == ' ') throw new ApprovalException('Please enter comments');  
            
            
            // Gary Arsenian 8/19: Validation to check user is updated and RFA Approver/User record which is pending recommendation.
            List<RFAUserRole__c> RFAUserRoleList = [Select ApprovalRecommendation__c From RFAUserRole__c Where id = :selectedWorkItem];
            for (RFAUserRole__c RFAUserRole: RFAUserRoleList)
                if (RFAUserRole.ApprovalRecommendation__c != RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION) throw new ApprovalException('Approval Recommendation has already been submitted by this user for this RFA');
            
            System.debug('\n Selected Approval workitem :'+selectedWorkItem);
            RFAUserRole__c approval = new RFAUserRole__c(Id=selectedWorkItem);
            approval.ApprovedBy__c = UserInfo.getUserId();
            approval.ApprovalRecievedDateTime__c = DateTime.now();
            approval.ApprovalComments__c = approvalComments;
            approval.ApprovalRecommendation__c = selectedRecommendation;
            update approval;
            
            //---- added by mpascua@coca-cola.com Aug 23, 2013
            if(selectedRecommendation == 'Rejected'){
                List<String> toAddresses = new List<String>();                
                List<String> ccdUsers = new List<String>();
                
                if(rfaObj.Id <> null)        {          
                    this.rfaObj = [Select Id, Level__c,ProfitCenterNumber__c,ProfitCenterName__c,ProfitCenterNumber__r.name                       
                                   FROM RFA__c WHERE Id =: rfaObj.id];        
                }                 
                // commented For REQ 23(12) "AND Level__c =: this.rfaObj.Level__c"
                // This populates the list of all level coordinators in the profit center
                List<ProfitCenterUserRole__c> locationCoordinatorsList = [SELECT ProfitCenter__c,UserName__r.name,UserName__r.email,UserName__c,Level__c,UserType__c                                  
                                                                          FROM ProfitCenterUserRole__c WHERE ProfitCenter__c=:rfaObj.ProfitCenterNumber__c  AND userType__c=:Label.RfA_Cl065                                
                                                                          order by Level__c limit :1000];
                System.debug('locationCoordinatorsList'+locationCoordinatorsList);
                Id targetObject = null; //added 21.feb
                for(ProfitCenterUserRole__c pc : locationCoordinatorsList){
                    
                    if (string.isblank(targetObject )){
                        targetObject = pc.UserName__c;
                        System.debug('targetObject Email id'+pc.UserName__r.Email);
                    }
                    else{
                        System.debug('adding Email id'+pc.UserName__r.email);
                        toAddresses.add(pc.UserName__r.email);
                    }
                    
                    //targetObject = pc.UserName__c; // add 21.feb
                }
                System.debug('toAddresses'+toAddresses);
                sendEmailNotification(toAddresses, ccdUsers, targetObject, rfaObj.Id, Label.RFA_CL147);
                //  sendEmailNotification(toAddresses, ccdUsers, UserInfo.getUserId(), rfaObj.Id, Label.RFA_CL147); - Orig Code
                
            }
            //-----
        }
        catch(ApprovalException appEx)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, appEx.getMessage()));
            hasError = true;
            return null;    
        } 
        catch(Exception ex)
        {
            if(!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))              
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
            system.debug('ex.getMessage()'+ex.getMessage());                          
            hasError = true;
            return null;
        }  
        return null;
    }
    
    
    /*@Method <getter and setter method for approval recommendation option>
@param <None> 
@return <List<SelectOption>>
*/
    public List<SelectOption> recommendationOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            List<Schema.PicklistEntry> ple = RFAUserRole__c.ApprovalRecommendation__c.getDescribe().getPicklistvalues();
            options.add(new SelectOption('--Select Recommendation--', '--Select Recommendation--'));
            for(Schema.PicklistEntry schemaPle : ple)
            {
                if(!schemaPle.getLabel().contains('Awaiting Approval'))  
                    options.add(new SelectOption(schemaPle.getLabel(), schemaPle.getValue()));
            }
            return options;
            
        }
        private set;
    }
    
    // Custom Exception class extending Exception.
    public class ApprovalException extends Exception{}
    
    
    /*    
@Method <This method sends email notification to target recepients in TO and CC list>        
@param <List<String>, List<String>, String, String>         
@return <pagereference>     
*/    
    public void sendEmailNotification(List<String> toAddresses, List<String> ccAddresses, String targetObjectId, String whatId, String strTemplateId){        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();        
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();        
        
        if(ToAddresses.size() > 0) mail.setToAddresses(toAddresses); 
        mail.setTemplateId(strTemplateId);               
        //mail.setTemplateId(Label.RFA_CL147);        
        
        if(ccAddresses.size() > 0) mail.setCcAddresses(ccAddresses);        
        mail.setWhatId(whatId);        
        mail.setTargetObjectId(targetObjectId);        
        mail.saveAsActivity = false;                
        mail.orgWideEmailAddressId=Label.RFA_CL131; 
        mails.add(mail);        
        Messaging.sendEmail(mails);                 
    }
}