trigger CRS_CRSReviewTrigger on CRS_Review__c (before insert, after insert, after update) {
    
    CRS_CRSReviewTriggerHandler handler = new CRS_CRSReviewTriggerHandler();
    if(Trigger.isInsert && Trigger.isBefore){
        handler.beforeInsert(Trigger.new);
    }
    
    IF(Trigger.isInsert && Trigger.isAfter){
        handler.AfterInsert(Trigger.new);
    }
    IF(Trigger.isUpdate && Trigger.isAfter){
        handler.AfterUpdate(Trigger.new);
    }
}