/***********************************************************************
Trigger Name  	: UserTrigger
Created By   	: Kirti Agarwal
Created Date 	: 3rd Dec, 2013
Purpose      	: Update the multiselect picklist on Deal object
Task         	: T-216705
************************************************************************/
trigger UserTrigger on User (after insert, after update) {
	
	if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
		
			UserTriggerHandler.afterInsertAndUpdate(Trigger.New, Trigger.oldMap);
	}
}