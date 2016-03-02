/***********************************************************************
Trigger Name  : DealTrigger
Created By   	: Kirti Agarwal
Created Date 	: 15th Nov,2013
Purpose      	: Create Deal Tracking History records
Task         	: T-212459
************************************************************************/
trigger DealTrigger on Deal__c (after update, after insert) {
	 
   if(Trigger.isAfter && Trigger.isUpdate) {
   		DealTriggerHandler.onAfterInsert(Trigger.new, trigger.oldMap);        	
   }
   
   if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)) {
   		DealTriggerHandler.onAfterInsertUpdate(Trigger.new, trigger.oldMap);         	
   }
   
}