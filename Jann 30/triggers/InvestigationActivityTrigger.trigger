// 
// (c) 2014 Appirio, Inc.
// 
// InvestigationActivityTrigger
// Trigger on Investigation_Activity__c on before insert to update the Case short description
// T-301209
//
// 18 July 2014     Ashish Goyal(JDC)       Original
//
trigger InvestigationActivityTrigger on Investigation_Activity__c (before insert) {
    InvestigationActivityTriggerHandler.updateInvestigationActivityRecord(Trigger.new);
}