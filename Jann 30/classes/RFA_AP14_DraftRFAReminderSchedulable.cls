/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_AP14_DraftRFAReminderSchedulable
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/11/2012
 *  Assumptions      : N/A
 *  Description      : This class implements the schedulable interface and schedules Draft RFA batchable class to run quarterly.
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
 

global class RFA_AP14_DraftRFAReminderSchedulable implements Schedulable{
    
    global static String CRON_EXP = '0 0 0 3 9 ? 2022';
    
    global string baseQuery = 'Select ProfitCenterNumber__c, Id, CreatedById, ControlNumber__c, Stage__c, RequestTitle__c FROM RFA__c WHERE';
     
    global RFA_AP14_DraftRFAReminderSchedulable()
    {
        
        //this.baseQuery = baseQuery + ' ' + 'createdDate > LAST_QUARTER';
        //this.baseQuery = baseQuery + ' ' + 'createdDate < NEXT_N_DAYS:1';
        this.baseQuery = baseQuery + ' ' + 'Stage__c =' + '\'' + RFAGlobalConstants.RFA_STAGE_DRAFT + '\'';    
        this.baseQuery = baseQuery + ' ' + ' ' + 'ORDER BY CreatedById';    
        
        
    }
    
      /**
     *  execute Method
     *  @param SchedulableContext sc
     */
    global void execute(SchedulableContext sc)
    {
        System.debug('\n Query prepared :'+baseQuery); 
        // create a new instance of RFA_AP10_BatchReminder
        RFA_AP15_RFADraftReminderBatchable draftBatchReminder = new RFA_AP15_RFADraftReminderBatchable(baseQuery);
        //execute batch
        database.executebatch(draftBatchReminder);       
    }

}