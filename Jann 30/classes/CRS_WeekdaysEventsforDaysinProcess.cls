global class CRS_WeekdaysEventsforDaysinProcess implements Schedulable{
  global void execute(SchedulableContext SC){ 
    CRS_DaysInProcAfterBUAppr.recountDaysInProcessAfterBUApproval();
     CRS_DaysInProcAfterBUAppr.recountTotalDaysSinceInitiated();
  }
}