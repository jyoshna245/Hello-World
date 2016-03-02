global class CRS_NewYearEvents implements Schedulable{
	global void execute(SchedulableContext SC){
		if(system.today().day() == 1 && system.today().month() == 1){
			CRS_CRSSchedulerEvents.deleteTenYearsOldCRS();
		}
	}
}