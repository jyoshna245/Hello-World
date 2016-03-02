/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_Delegation_OldDocumentsEndScheduler
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 01/04/2014
 *  Assumptions      : N/A 
 *  Description      : This class is written to schedule the batch job written for clearing off the populated delegated requestors.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

global class ITPR_Delegation_OldDocumentsEndScheduler implements Schedulable {
    //method written to start the batch class for clearing off the delegated requestors from the ITPR records.
    global void execute(SchedulableContext sc){
         database.executeBatch(new ITPR_Delegation_OldDocumentsEndBatch(),50);
    }
}
/*********************************************END*****************************************************************************************************************/