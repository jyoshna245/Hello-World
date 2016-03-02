global class CRS_WeekdaysEvents implements Schedulable{
    global void execute(SchedulableContext SC){
        CRS_CRSSchedulerEvents.recountMTRDay();
    }
}