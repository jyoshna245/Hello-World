/**
* Class Name: RFA_BC02_ReportingUnitRealignmentFix
* Author: Accenture
* Date: 01-03-2014
* Project Name: Coke-RFA
* Requirement Description: This is schedule batch which will call the RFA_AP20_ReportingUnitRealignment class.
 
 **/
global class RFA_BC02_ReportingUnitRealignmentFix implements Schedulable{
    
    /**
     *  execute  method
     *  @param Crone Time
     *  @return null    
     */
    global void execute(SchedulableContext sc) {
        Set<id> reportingUnitIds = new Set<Id>(); 
        List<ReportingUnit__c> reportingUnitList = [Select Id ,name from ReportingUnit__c where NeedRecalculation__c=true and ActiveInactive__c='Active'];
        for(ReportingUnit__c reportingUnitObj : reportingUnitList)
            reportingUnitIds.add(reportingUnitObj.Id);
        String Query = 'Select PrimaryReportingUnitNumber__c,SecondReportingUnitNumber__c,ThirdReportingUnitNumber__c,id,Level__c, PreviousLevel__c from RFA__c where ' 
          +'PrimaryReportingUnitNumber__c IN :reportingUnitIds OR SecondReportingUnitNumber__c IN :reportingUnitIds OR ThirdReportingUnitNumber__c IN :reportingUnitIds '
          +'ORDER BY CreatedDate DESC';
        RFA_AP20_ReportingUnitRealignmentFix controller = new RFA_AP20_ReportingUnitRealignmentFix(Query,reportingUnitIds) ;
        Integer batchSize = 100;
        database.executebatch(controller , batchSize);
   }

}