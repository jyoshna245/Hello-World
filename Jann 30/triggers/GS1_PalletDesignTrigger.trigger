/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     Trigger for GS1_Pallet_Design__c object. Refer to GS1_ObjectsTriggerProcessor class for the complete code
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*/
trigger GS1_PalletDesignTrigger on GS1_Pallet_Design__c (before insert, after insert, before update, after update, before delete, after delete) {
  final String errMsg = 'Pallet Design Code already exists in the specified Pallet Material!';
  if (trigger.isBefore && trigger.isUpdate) {
    GS1_ObjectsTriggerProcessor.trapDuplicate(trigger.New, trigger.OldMap, 'UniqueKey__c', trigger.isInsert, errMsg );    
  }  
  
  if (trigger.isBefore && trigger.isInsert) {
    GS1_ObjectsTriggerProcessor.trapDuplicate(trigger.New, trigger.OldMap, 'UniqueKey__c', trigger.isInsert, errMsg );    
  }

}