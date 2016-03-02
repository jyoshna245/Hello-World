/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     Trigger for GS1_Unit_Capacity__c object. Refer to GS1_ObjectsTriggerProcessor class for the complete code
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*/
trigger GS1_Unit_CapacityTrigger on GS1_Unit_Capacity__c (before insert, after insert, before update, after update, before delete, after delete) {
  final String errMsg = 'That capacity already exists in this Unit!';
  if (trigger.isBefore && trigger.isUpdate) {
    GS1_ObjectsTriggerProcessor.trapChangeValueIfUsedInRequest(trigger.New, trigger.OldMap, 'Name', 'Capacity__c', GS1_Constants.ERRMSG_CANNOT_CHANGE_VALUE);
    GS1_ObjectsTriggerProcessor.trapDuplicate(trigger.New, trigger.OldMap, 'UniqueKey__c', trigger.isInsert, errMsg );    
  }  
  
  if (trigger.isBefore && trigger.isInsert) {
    GS1_ObjectsTriggerProcessor.trapDuplicate(trigger.New, trigger.OldMap, 'UniqueKey__c', trigger.isInsert, errMsg );    
  }
}