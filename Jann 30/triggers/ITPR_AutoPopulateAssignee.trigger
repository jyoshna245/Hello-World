/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Trigger          : ITPR_AutoPopulateAssignee
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 03/02/2014
 *  Assumptions      : N/A
 *  Description      : Trigger contains logic to pass the Request Paramaters to the ITPR_PopulateAssignees class where the
                       Business Logic is calculated.This Trigger also flushes the Sharing for all users before recalculating in the
                       ITPR_PopulateAssignees class.
                         
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

trigger ITPR_AutoPopulateAssignee on ITPR__c (before insert,before update,after insert,after update) {

/**********************Storing the public variables for RequestType,Category and Organization,ITSES Old values*********/

Public List<ITPR__c> lst = new List<ITPR__c>();
Public Set<string> cat = new Set<string>();    
Public Set<string> Org = new Set<string>();  
Public Set<string> Req = new Set<string>();
public ITPR__c oldassign;
public ITPR__c newassign;

if(Trigger.isBefore){

   /*************Storing the Category,request type and Org from new ITSES******************/
    for(ITPR__c i :Trigger.new)
    { 
    
    cat.add(i.Category__c);
    Org.add(i.Organization__c);
    Req.add(i.Request_Type__c); 
    }
    /**********************Fetch the Assignees based on Dynamic Logic Rules*********/
  
    Map<Id, Assignment_Routing_Rules__c> assignrules= new Map<Id, Assignment_Routing_Rules__c>([SELECT Id,Procurement_Assignee__c,Vendor_Governance_User__c,Procurement_Assignee__r.Name,Legal_Assignee__c,Legal_Assignee__r.Name from Assignment_Routing_Rules__c WHERE 
    Category__c IN :cat AND Organization__c IN :Org AND Request_Type__c IN :Req]); 
 
    if (Trigger.isInsert) {
        if(!ITPR_Validator_cls.hasAlreadyDone()){    
           ITPR_PopulateAssignees assign = new ITPR_PopulateAssignees(); 
           
           assign.AssigneeInsert(trigger.new, assignrules);
           ITPR_Validator_cls.setAlreadyDone();
           
        }
    }
    
    /**********************Send the ITSES Old request paramaters into ITPR_PopulateAssignees class*********/ 
    if(Trigger.Isupdate){ 
        if(!ITPR_Validator_cls.hasAlreadyDone()){        
           ITPR_PopulateAssignees assign = new ITPR_PopulateAssignees(); 
           assign.AssigneeUpdate(trigger.New,assignrules,Trigger.oldMap);
           ITPR_Validator_cls.setAlreadyDone();
        }
    }
 
} 
 if(Trigger.isAfter){

    /**********************Fetching the Manual Sharing records from ITSES Share*********/
    if(trigger.isUpdate){
        List<ITPR__Share> sharesToDelete = [SELECT Id 
                                                FROM ITPR__Share 
                                                WHERE ParentId IN :trigger.newMap.keyset() 
                                                AND (RowCause = 'Manual')];

    /**********************Flushing the Manual Sharing and sending the new ITSES to ITPR_PopulateAssignees class*********/                                                                           
    if(!sharesToDelete.isEmpty()){
        Database.Delete(sharesToDelete, false);
    }

    /***********************Passing the new ITSES Values in method which calculates the sharing for Assignees,Requestors and Approvers********/                              

    ITPR_PopulateAssignees assign = new ITPR_PopulateAssignees(); 
    assign.ITPR_Share(trigger.new);

                            sharesToDelete = [SELECT Id 
                                                FROM ITPR__Share 
                                                WHERE ParentId IN :trigger.newMap.keyset() 
                                                AND RowCause = :Schema.ITPR__Share.RowCause.Departmental_User_Sharing__c];

    /**********************Flushing the Manual Sharing and sending the new ITSES to ITPR_PopulateAssignees class*********/                                                                           
    if(!sharesToDelete.isEmpty()){
        Database.Delete(sharesToDelete, false);
    }
    
    //ITPR_PopulateAssignees assign = new ITPR_PopulateAssignees(); 
    assign.DSU_ITPR_Share(trigger.new);

   }
   
   /**********************Fetching the Departmental user Sharing records from ITSES Share*********/
    if(trigger.isInsert){
        List<ITPR__Share> sharesToDelete = [SELECT Id 
                                                FROM ITPR__Share 
                                                WHERE ParentId IN :trigger.newMap.keyset() 
                                                AND RowCause = :Schema.ITPR__Share.RowCause.Departmental_User_Sharing__c];

    /**********************Flushing the Manual Sharing and sending the new ITSES to ITPR_PopulateAssignees class*********/                                                                           
    if(!sharesToDelete.isEmpty()){
        Database.Delete(sharesToDelete, false);
    }
    
    ITPR_PopulateAssignees assign = new ITPR_PopulateAssignees(); 
    assign.DSU_ITPR_Share(trigger.new);
  }
 }   

}