global class CRS_EveryDayEvents implements Schedulable{
	global void execute(SchedulableContext SC){
		CRS_CRSSchedulerEvents.deleteAllAttachments();
	}
}