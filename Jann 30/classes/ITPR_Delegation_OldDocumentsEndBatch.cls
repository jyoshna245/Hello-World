/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_Delegation_OldDocumentsEndBatch
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 22/03/2014
 *  Assumptions      : N/A 
 *  Description      : This class is written to clear off the delegated requestors based on the end date of the delegated request and
                       removes the permissions off the delegated requestor.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
global class ITPR_Delegation_OldDocumentsEndBatch implements Database.Batchable<sObject>
{
    /*Variable declaration*/
    public string query;
    public set<id> ds = new set<id>();
    List<ITPR__c> lt = new List<ITPR__c>();
    Date dt = Date.Today() - 1;
    /*End of variable declaration*/
    
    //fetch the delegation records which have end date as one daye prior to the day on which the batch is run   
    public List<ITPRDelegation__c> lstDelegation = new List<ITPRDelegation__c>([Select Start_Date__c,End_Date__c,Reset__c,Delegate_To__c,CreatedById from ITPRDelegation__c where End_Date__c = :dt]);
    
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
        query = 'SELECT id,Status__c,Delegated_Requestor__c,Delegated_Finance_Assignee__c,Delegated_Vendor_Governance_User__c,Delegated_Requestor_check__c,Delegated_Legal_Assignee__c,Procurement_Assignee__c,Delegated_Procurement_Assignee__c,CreatedById,Legal_Assignee__c,Finance_Assignee__c,Vendor_Governance__c FROM ITPR__c WHERE Status__c not in :lstStatus and CreatedById IN: ds';
        return Database.getQueryLocator(query);
    }
    
    //covers the logic for clearing off the delegated requests from the delegators
    global void execute(Database.BatchableContext BC,  List<ITPR__c> scope)
    {    
           
        if(lstDelegation .size()>0)
        {
            for(ITPR__c itpr : scope)
            {
                for(ITPRDelegation__c dl: lstDelegation )
                { 
                    //checks for the crresponding requestor/assignee
                    if(itpr.CreatedById == dl.CreatedById)
                    {                          
                        //clears off the delegated requestor fields
                        itpr.Delegated_Requestor__c = null;
                        itpr.Delegated_Requestor_check__c = False;
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