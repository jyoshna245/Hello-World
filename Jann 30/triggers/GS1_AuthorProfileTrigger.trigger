/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     Trigger for GS1_AuthorProfile__c object. Refer to GS1_ObjectsTriggerProcessor class for the complete code
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*/
trigger GS1_AuthorProfileTrigger on GS1_AuthorProfile__c   (before insert, after insert, before update, after update, before delete, after delete) {
    GS1_ObjectsTriggerProcessor.AuthorProfileProcessor proc = new GS1_ObjectsTriggerProcessor.AuthorProfileProcessor();
    
    //add mode
    if (trigger.isBefore && trigger.isInsert) {
        proc.beforeInsert(trigger.new);
    }           
    if (trigger.isAfter && trigger.isInsert) {
        proc.afterInsert(trigger.new);
    }   
    
    //edit mode
    if (trigger.isBefore && trigger.isUpdate) {
        proc.beforeUpdate(trigger.new, trigger.oldMap);
    }    
    if (trigger.isAfter && trigger.isUpdate) {
        proc.afterUpdate(trigger.new, trigger.oldMap);
    }    
    
    //delete mode
    if (trigger.isBefore && trigger.isDelete) {
        proc.beforeDelete(trigger.old);
    }    
    if (trigger.isAfter && trigger.isDelete) {
        proc.afterDelete(trigger.old);
    }   
}