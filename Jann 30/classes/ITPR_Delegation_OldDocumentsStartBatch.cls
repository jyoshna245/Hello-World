/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_Delegation_OldDocumentsStartBatch
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 01/04/2014
 *  Assumptions      : N/A 
 *  Description      : This class is written to populate the delegated requestors based on the start date of the delegated request and
                       gives the permissions to the delegated requestor.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
global class ITPR_Delegation_OldDocumentsStartBatch implements Database.Batchable<sObject>
{
    /*variable declaration*/
    public string query;
    public set<id> ds = new set<id>();
    List<ITPR__c> lt = new List<ITPR__c>();
    /*end of variable declaration*/

    //fetching the delegation records which have start date as one day on which the batch runs   
    public List<ITPRDelegation__c> lstDelegation = new List<ITPRDelegation__c>([Select Start_Date__c,End_Date__c,Reset__c,Delegate_To__c,CreatedById from ITPRDelegation__c where Reset__c = False and Start_Date__c = TODAY]);
    
    //overridden start method of Batchable interface which returns the query
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        for(ITPRDelegation__c i: lstDelegation )
        {
            ds.add(i.CreatedById);
        }
        List<String> lstStatus = new List<String>();
        lstStatus.add(System.Label.ITPR_Complete_Status);
        lstStatus.add(System.Label.ITPR_All_Digital_Initials_Obtained_Status);
        lstStatus.add(System.Label.ITPR_Not_executed_and_Closed_Status);
        lstStatus.add(System.Label.ITPR_Executed_and_Filed_Status);
        lstStatus.add(System.Label.ITPR_Cancelled_Status);
        
        //fetch the ITPR records(with status other than complete) where the assignees/requestors are the ones who created the ITPR Delegation records
        query = 'SELECT id,Status__c,Delegated_Requestor__c,Delegated_Finance_Assignee__c,Delegated_Vendor_Governance_User__c,Delegated_Requestor_check__c,Delegated_Legal_Assignee__c,Procurement_Assignee__c,Delegated_Procurement_Assignee__c,CreatedById,Legal_Assignee__c,Finance_Assignee__c,Vendor_Governance__c FROM ITPR__c WHERE Status__c not in :lstStatus and (Procurement_Assignee__c IN:ds or Legal_Assignee__c IN :ds or Finance_Assignee__c IN:ds or Vendor_Governance__c IN:ds or CreatedById IN: ds)';
        system.debug(query+'query------');
        return Database.getQueryLocator(query);
        
    }
    
    //covers the logic for populating the delegated requestors on the IT-SES records
    global void execute(Database.BatchableContext BC,  List<ITPR__c> scope)
    { 

        Map<Id, Id> mapInitial = new Map<Id, Id>();
        for(ITPRDelegation__c itprDel : lstDelegation){
            mapInitial.put(itprDel.CreatedById, itprDel.Delegate_To__c);
        }

        Map<Id, Id> mapFinal = new Map<Id, Id>();
        
        for(ITPRDelegation__c itprDel : lstDelegation){
            mapFinal.put(itprDel.CreatedById, itprDel.Delegate_To__c);
            Id delId = mapInitial.get(itprDel.Delegate_To__c);
            if(delId != null){
                id delId2 = delId;
                //Keep checking the map again and again until the new Delegated Id is not found to be set as Created By Id
                while(delId2 != null){
                    delId2 = mapInitial.get(delId2);
                    if(delId2 != null){
                        delId = delId2;
                        if(delId2 == itprDel.CreatedById){
                            delId2 = null;
                        }
                    }
                }
                mapFinal.put(itprDel.CreatedById, delId);
            }
       }
       
       if(lstDelegation .size()>0)
       {
            for(ITPR__c itpr : scope)
            {
                for(Id id1: mapFinal.keySet())
                { 
                    //checks for the crresponding requestor/assignee
                    if(itpr.CreatedById == id1)
                    {                          
                        //populate the delegated requestor fields
                        itpr.Delegated_Requestor__c = mapFinal.get(id1);
                        itpr.Delegated_Requestor_check__c = True;
                    }
                    
                }
                lt.add(itpr);
            }
 
        }
        
        //update the ITPR records
        if(lt.size() >0)
        {
            update lt;
        }
    }
    
    //overridden method of batchable interface
    global void finish(Database.BatchableContext BC)
    {
        
    }
}
/*********************************************END*****************************************************************************************************************/