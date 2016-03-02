/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_AP15_RFADraftReminderBatchable
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/11/2012
 *  Assumptions      : N/A
 *  Description      : This class implements a batchable and stateful interface, execute method of this batch class returns all the 
                       RFAs which are in Draft Stage, Consolidates RFA records for each of the system users and sends a reminder email.     
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

global class RFA_AP15_RFADraftReminderBatchable implements
        Database.Batchable<SObject>, Database.Stateful {
            
    global String queryString;
    
    global Map<Id, List<RFA__c>> requesterRFAsMap = new Map<Id, List<RFA__c>>();
    
    global RFA_AP15_RFADraftReminderBatchable(String queryString)
    {
        this.queryString = queryString;     
    }   
    
    /**
     *  Start Method
     *  @param Database.BatchableContext ctx
     */
    global Database.queryLocator start(Database.BatchableContext ctx)
    { 
        return Database.getQueryLocator(queryString);                                           
    }
    
    /**
     *  Execute Method
     *  @param Database.BatchableContext ctx, List<Sobject> scope
     */
    global void execute(Database.BatchableContext ctx, List<Sobject> scope)
    {
        
        List<RFA__c> draftReminders = (List<RFA__c>)scope;
        
        for(RFA__c rfa : draftReminders)
        {
            if(requesterRFAsMap.containsKey(rfa.CreatedById))
            {
                requesterRFAsMap.get(rfa.CreatedById).add(rfa); 
            }
            else
            {
                List<RFA__c> rfaTempList = new List<RFA__c>();
                rfaTempList.add(rfa);
                requesterRFAsMap.put(rfa.CreatedById, rfaTempList);
            }       
        }
            
    }
    
    /**
     *  Finish Method
     *  @param Database.BatchableContext ctx
     */
    global void finish(Database.BatchableContext ctx)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if(!requesterRFAsMap.isEmpty())
        {
            RFA_AP12_ReminderEmailUtil emailUtil = new RFA_AP12_ReminderEmailUtil();
                    
            for(String creator : requesterRFAsMap.keySet())
            {
                String htmlBody;
                
                htmlBody = emailUtil.prepareEmailBody(requesterRFAsMap, htmlBody, creator);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setTargetObjectId(creator);
            
                mail.setHtmlBody(htmlBody);
            
                mail.saveAsActivity = false;
            
                mail.setSubject(emailUtil.EMAIL_SUBJECT_AP15);
            
                mails .add(mail);   
            }   
        }
        
        if(!mails.isEmpty())
        {
            Messaging.sendEmail(mails);
        }       
    }

}