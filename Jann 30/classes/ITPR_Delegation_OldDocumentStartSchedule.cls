/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_Delegation_OldDocumentStartSchedule
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 01/04/2014
 *  Assumptions      : N/A 
 *  Description      : This class is written to schedule the batch job written for assigning the ITPR requests to the delegated requestors.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

global class ITPR_Delegation_OldDocumentStartSchedule implements Schedulable {
    
    //method written to start the batch class to assign the requestes to the delegated requestors.
    global void execute(SchedulableContext sc){
         Database.executeBatch(new ITPR_Delegation_OldDocumentsStartBatch(),50);
    }
}