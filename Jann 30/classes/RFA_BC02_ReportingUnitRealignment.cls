/**
* Class Name: RFA_BC02_ReportingUnitRealignment
* Author: Accenture
* Date: 05-08-2013
* Project Name: Coke-RFA
* Requirement Description: This is schedule batch which will call the RFA_AP20_ReportingUnitRealignment class.
 
 **/
global class RFA_BC02_ReportingUnitRealignment implements Schedulable{
    
    /**
     *  execute  method
     *  @param Crone Time
     *  @return null    
     */
    global void execute(SchedulableContext sc) {
        String Query='Select Id ,name from ReportingUnit__c where NeedRecalculation__c=true and ActiveInactive__c=\'Active\'';
        RFA_AP20_ReportingUnitRealignment controller = new RFA_AP20_ReportingUnitRealignment(Query) ;
        Integer batchSize = 200;
        database.executebatch(controller , batchSize);
   }

}