/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_Delegation_StartBatchSchedule
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 01/04/2014
 *  Assumptions      : N/A 
 *  Description      : This class is written to schedule the batch class which assigns the requests from one primary assignee to another.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
global class ITPR_MassTransferScheduler implements Schedulable{
    //method written to start the batch class for mass transfers
    global void execute(SchedulableContext sc){
         Database.executeBatch(new ITPR_MassTransferBatch(),100);
    }
}
/*********************************************END*****************************************************************************************************************/