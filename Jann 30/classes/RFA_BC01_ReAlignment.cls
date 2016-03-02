/**
* Class Name: RFA_BC01_ReAlignment
* Author: Accenture
* Date: 04-07-2012
* Project Name: Coke-RFA
 * Requirement Description: This is schedule batch which will call the RFA_AP09_Alignment class.
 
 **/
global class RFA_BC01_ReAlignment implements Schedulable{
    
    /**
     *  execute  method
     *  @param Crone Time
     *  @return null    
     */
    global void execute(SchedulableContext sc) {
        String Query='Select Id ,name from ProfitCenter__c where NeedRecalculation__c=true and ActiveInactive__c=\'Active\'';
        RFA_AP09_Realignment controller = new RFA_AP09_Realignment(Query) ;
        Integer batchSize = 200;
        database.executebatch(controller , batchSize);
   }

}