trigger CRS_CRSTrigger on CRS__c (before insert, before update, after insert, after update) {


    CRS_CRSTriggerHandler handler = new CRS_CRSTriggerHandler();
    if(Trigger.isInsert && Trigger.isBefore){
        handler.BeforeInsert(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
        handler.BeforeUpdate(Trigger.new);
        handler.UnderReviewApprovalValidation(Trigger.new,Trigger.oldmap);
    }
    
    //CRS_enhancement
    if(Trigger.isAfter && Trigger.isInsert){
        handler.AfterInsert(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        handler.AfterUpdate(Trigger.new, Trigger.oldMap); 
    }
    
}