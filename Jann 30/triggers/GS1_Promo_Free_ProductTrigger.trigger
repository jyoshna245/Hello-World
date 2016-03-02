/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     Trigger for GS1_Promo_Free_Product__c object. Refer to GS1_ObjectsTriggerProcessor class for the complete code
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*/
trigger GS1_Promo_Free_ProductTrigger on GS1_Promo_Free_Product__c (before insert, after insert, before update, after update, before delete, after delete) {
 final String errMsg = 'Same item already exists!';
  if (trigger.isBefore && (trigger.isUpdate || trigger.isInsert)) {
    GS1_ObjectsTriggerProcessor.trapDuplicate(trigger.New, trigger.OldMap, 'Name', trigger.isInsert, errMsg );    
  }  

}