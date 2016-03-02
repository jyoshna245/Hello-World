/***********************************************************************
Trigger Name  : DealPhaseTrigger
Created By   	: Kirti Agarwal
Created Date 	: 27th Nov,2013
Purpose      	: Update Deal record based on Deal Phase record
Task         	: T-215444
************************************************************************/
trigger DealPhaseTrigger on Deal_Phase__c (after insert, after update) {

 if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)) {
   	DealPhaseTriggerHandler.onAfterInsertUpdate(Trigger.new, trigger.oldMap);        	
  }
  
}