/***********************************************************************
Class Name  : DealRecordTypeUpdateScheduler
Created By      : Kirti Agarwal
Created Date    : 3rd Dec, 2013
Purpose         : Update the record type on Deal object
Task            : T-216705
************************************************************************/
global class DealRecordTypeUpdateScheduler implements Schedulable {

    global static void execute(SchedulableContext SC) { 
            DealRecordTypeUpdateInBatch reassign = new DealRecordTypeUpdateInBatch();
						ID batchprocessid = Database.executeBatch(reassign);
   }
   
 
}