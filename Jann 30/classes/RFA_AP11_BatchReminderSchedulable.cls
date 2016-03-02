/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_AP11_BatchReminderSchedulable
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/05/2012
 *  Assumptions      : N/A
 *  Description      : This class implements the Schedulable interface. This class is scheduled from Salesforce.com interface and executes
                       the batch class RFA_AP10_BatchReminder
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
 
global class RFA_AP11_BatchReminderSchedulable implements Schedulable{
    
    // base query String
    global String queryString = 'Select Agent1__c, Agent2__c, Agent3__c, UserName__c, RFA__c, ApprovalProcess__c FROM RFAUserRole__c WHERE' + ' ';
    
    global static final Integer scope = 400;
    
    global static String CRON_EXP = '0 0 0 3 9 ? 2022';
    
    private String REMINDER_THRESHOLD = RFA_BatchReminder__c.getInstance('Approval Reminder').ReminderThreshold__c;    
    
    
    //constructor for the class 
    global RFA_AP11_BatchReminderSchedulable() 
    {   
    	if(Test.isRunningTest())
    	{
    		this.queryString = queryString + 'RecordType.Name=' +'\'' + RFAGlobalConstants.APPROVER_RECORDTYPE + '\'';
    		this.queryString = queryString + ' ' + 'AND ApprovalRecommendation__c=' + '\'' + RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION + '\'';
    		this.queryString = queryString + ' ' + 'ORDER BY UserName__c LIMIT 20';		
    	}
    	else
    	{
    		this.queryString = queryString + 'RecordType.Name=' +'\'' + RFAGlobalConstants.APPROVER_RECORDTYPE + '\'';
	        this.queryString = queryString + ' ' + 'AND ApprovalRecommendation__c=' + '\'' + RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION + '\'';
	        this.queryString = queryString + ' ' + 'AND ApprovalRequestedOn__c < NEXT_N_DAYS:' + REMINDER_THRESHOLD ;
	        this.queryString = queryString + ' ' + 'ORDER BY UserName__c';   
	        System.debug('\n Query prepared :'+queryString);	
    	}
                                     
    }
    
    /**
     *  execute Method
     *  @param SchedulableContext sc
     */
    global void execute(SchedulableContext sc)
    {
        System.debug('\n Query prepared :'+queryString); 
        // create a new instance of RFA_AP10_BatchReminder
        RFA_AP10_BatchReminder batchReminder = new RFA_AP10_BatchReminder(queryString);
        //execute batch
        database.executebatch(batchReminder);       
    }
}