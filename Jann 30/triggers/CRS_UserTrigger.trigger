trigger CRS_UserTrigger on User (after insert, after update) {
	CRS_UserTriggerHandler handler = new CRS_UserTriggerHandler();
	
	if(Trigger.isInsert){
		handler.onAfterInsert(Trigger.new);	
	} else if(Trigger.isUpdate){
		handler.onAfterUpdate(Trigger.old, Trigger.new);
	}
}