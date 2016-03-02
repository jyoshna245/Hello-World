/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     Trigger for GS1_Multipack_Value__c   object. Refer to GS1_ObjectsTriggerProcessor class for the complete code
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*/
trigger GS1_MultiPackValueTrigger on GS1_Multipack_Value__c  (before insert, after insert, before update, after update, before delete, after delete) {
 final String errMsg = 'That value already exists in this Multipack!';
  if (trigger.isBefore && trigger.isUpdate) {
    GS1_ObjectsTriggerProcessor.trapChangeValueIfUsedInRequest(trigger.New, trigger.OldMap, 'Name', 'Units_Pack__c', GS1_Constants.ERRMSG_CANNOT_CHANGE_VALUE);
    GS1_ObjectsTriggerProcessor.trapDuplicate(trigger.New, trigger.OldMap, 'UniqueKey__c', trigger.isInsert, errMsg );    
  }  
  
  if (trigger.isBefore && trigger.isInsert) {
    GS1_ObjectsTriggerProcessor.trapDuplicate(trigger.New, trigger.OldMap, 'UniqueKey__c', trigger.isInsert, errMsg );    
  }    
}