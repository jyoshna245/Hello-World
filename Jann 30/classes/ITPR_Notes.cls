/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_Notes
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 14/03/2014
 *  Assumptions      : N/A 
 *  Description      : This class is written to capture the status and comments entered when a request is transferred from one status 
                       to another.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
public class ITPR_Notes{
    /*variable declaration*/
    public Id id1;
    public string id2;
    public ITPR__c check;
    public Boolean rend{get;set;}
    public Boolean rend1{get;set;}
    public string test;
    Public String id3{get;set;}
    public String loggedInUserID {get; set;}
    public Boolean readOnlyUser{get; set;}
    public ITPR__c objITPR {get; set;}
    private RequestNotes__c cntr;  
    /*end of variable declaration*/
    
    //controllers
    private ApexPages.StandardController controller {get; set;}
    
    public ITPR_Notes(ApexPages.StandardController controller) {
        //fetch the parameters passed from the URL
        id1 = ApexPages.currentPage().getParameters().get('param1');
        id2 = ApexPages.currentPage().getParameters().get('param2');
        id3 = ApexPages.currentPage().getParameters().get('strarg');
        readOnlyUser = false;
        this.controller = controller;
        cntr= (RequestNotes__c)controller.getRecord();
        
        if(id1 == null){
        try{
            objITPR = [SELECT Id,CreatedByID,Status__c,Delegated_Requestor__c,Procurement_Assignee__c,Legal_Assignee__c,Finance_Assignee__c,Vendor_Governance__c from ITPR__c where Id = :cntr.ITPR__c];
           }catch(Exception e){
           
           }
           loggedInUserID = UserInfo.getUserId();
         /*   String publicGroupId = [select Id, Name From Group where Name =: System.Label.ITPR_Business_Admin].Id;
      // system.debug(publicGroupId+'group id-----');
       List<GroupMember> g = [select Id,GroupId,UserOrGroupId from GroupMember where GroupId = :publicGroupId and UserOrGroupId =: loggedInUserID];
       if(g != null && g.size() > 0){
           userIds.add(g.UserOrGroupId);
           }*/
            //system.debug(loggedInUserID + 'logged in user id-----'+objITPR.Procurement_Assignee__c+'-------');
            //system.debug(objITPR.Legal_Assignee__c+'------values----'+objITPR.Finance_Assignee__c+'----'+objITPR.Vendor_Governance__c);
            String strProfileID = UserInfo.getProfileId();
            String loggedInUserProfile = [select Id,name,Profile.Name from User where Id = :loggedInUserID].Profile.Name;
            //String loggedInUserDept = [select id,ITPR_Department__c from User where id=:UserInfo.getUserId()].ITPR_Department__c; //new dept changes
            
            if(objITPR != null){
            //new dept changes
             if(loggedInUserID == objITPR.Procurement_Assignee__c || loggedInUserID == objITPR.Legal_Assignee__c || loggedInUserID == objITPR.Finance_Assignee__c || loggedInUserID == objITPR.Vendor_Governance__c || loggedInUserProfile =='System Administrator' || loggedInUserProfile =='ITSES - VendorGovernance Business Administrator' || loggedInUserProfile =='ITSES - Procurement Business Administrator' || loggedInUserProfile =='ITSES - Legal Business Administrator' || loggedInUserProfile =='ITSES - Finance Business Administrator' || loggedInUserID == objITPR.CreatedByID || loggedInUserID == objITPR.Delegated_Requestor__c) 
             //(loggedInUserProfile != 'System Administrator')
             {
                system.debug('enter');
                readOnlyUser = False;
             }/*else{
                // if(objITPR.Status__c == System.Label.ITPR_Submitted_Status || objITPR.Status__c == System.Label.ITPR_Assigned_Status || objITPR.Status__c == System.Label.ITPR_In_Process_Status){
                    readOnlyUser = True;
                //}else{
                   //  readOnlyUser = true;
               // }
             } */  
            }else{
                check = new ITPR__c(); 
            } 
        }else{
           check = [select Id,Status__c,Procurement_Assignee__c,Legal_Assignee__c,Finance_Assignee__c,Vendor_Governance__c from ITPR__c where Id =:id1]; 
        }
       // check = (id1 == null) ? new ITPR__c():[select Id,Status__c,Procurement_Assignee__c,Legal_Assignee__c,Finance_Assignee__c,Vendor_Governance__c from ITPR__c where Id =:id1];
        system.debug('%%%%%%%%%%%%%%%%' + id1);
        
        
       
    }
    //renders the save button
    public Boolean show{
        get {
            Boolean chk = true;
            system.debug('%%%%%%%%%%%%%%%%' + id1);
            chk = chk && (id1 != null);
            return chk;
        }
    }
    
    public Boolean notshow{
        get {
            Boolean chk = true;
            system.debug('%%%%%%%%%%%%%%%%' + id1);
            chk = chk && (id1 == null);
            return chk;
        }
        
    }
    //functionality to save the status and comments on click of save
    public Pagereference Save1()
    {
        //check for the status and change status accordingly.
        if((id2=='pendingmoreinfo') && (check.Status__c == System.Label.ITPR_Submitted_Status)){
            check.Status__c = System.Label.ITPR_Pending_More_Info_Needed_Status;
        }else if((id2=='pendingbudget')&& (check.Status__c == System.Label.ITPR_In_Process_Status)){
            check.Status__c = System.Label.ITPR_Pending_Project_Final_Budget_Status;
        }else if((id2=='onhold')&& (check.Status__c == System.Label.ITPR_In_Process_Status)){
            check.Status__c = System.Label.ITPR_On_Hold_Status;
        }else if(id2=='cancel'){
            if((check.status__c == System.Label.ITPR_Pending_More_Info_Needed_Status) || (check.status__c == System.Label.ITPR_Pending_Project_Final_Budget_Status)|| (check.status__c == System.Label.ITPR_In_Process_Status)){
                check.Status__c = System.Label.ITPR_Cancelled_Status;
            }
        }else if((id2=='complete')&&(check.status__c == System.Label.ITPR_In_Process_Status)){
            check.Status__c = System.Label.ITPR_Complete_Status;
        }else if((id2=='notexecuted')&&(check.status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status)){
            check.Status__c = System.Label.ITPR_Not_executed_and_Closed_Status;
        //Capgemini:Status Reopen is not defined to write the status notes for reopen case,regarding with story #25
        }else if((id2=='Reopen')&&(check.status__c == System.Label.ITPR_Complete_Status) || (check.status__c == System.Label.ITPR_All_Digital_Initials_Obtained_Status)|| (check.Status__c == System.Label.ITPR_Cancelled_Status)){
            check.Status__c = System.Label.ITPR_In_Process_Status;
            }
        //update the status notes object with the new values and return the page rendered with updated values
        try{
            update check;
            RequestNotes__c newSkill = new RequestNotes__c();
            newSkill.Comments__c = cntr.comments__c;
            newSkill.Title__c = cntr.comments__c;
            newSkill.ITPR__c = cntr.ITPR__c;
            insert newSkill;
            PageReference newocp = new PageReference('/'+ id1);
            newocp.setRedirect(true);
            return newocp;
        }catch(DmlException ex){
            ApexPages.addMessages(ex); 
            return null;           
       }
    }
    public Pagereference Save2(){    
     try{
          
            RequestNotes__c newSkill = new RequestNotes__c();
            newSkill.Comments__c = cntr.comments__c;
            newSkill.Title__c = cntr.comments__c;
            newSkill.ITPR__c = cntr.ITPR__c;
            insert newSkill;
            
            PageReference newocp = new PageReference('/'+newSkill.id);
            newocp.setRedirect(true);
            return newocp;
        }catch(DmlException ex){
            ApexPages.addMessages(ex); 
            return null;           
       }
     }  
}
/*********************************************END*****************************************************************************************************************/