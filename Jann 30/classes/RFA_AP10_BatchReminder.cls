/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_AP10_BatchReminder
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/05/2012
 *  Assumptions      : N/A
 *  Description      : This batch class implements the Database.Batchable and Database.stateful interfaces. The querylocator returns
 					   all the pening approval requests and notifies its actor of its pending status. 	
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

global class RFA_AP10_BatchReminder implements
		Database.Batchable<SObject>, Database.Stateful{ 
	
	// Query String passed to the Database querylocator to return the records to be processed
	global final String query;
	
	// Map variable to store the pending approval requests per user in the system	
	// This instance member variable will maintain state across multiple transactions.
	global Map<String, Set<String>> approverRFAIdsMap = new Map<String, Set<String>>();
	
	// Unique set of RFAs with pending approval processes.
	// This instance member variable will maintain state across multiple transactions.
	global Set<Id> rfaIds = new Set<Id>();
	
	//constructor for the class.
	// ***********************************QUERY STRING *******************************************/
	// Select Agent1__c, Agent2__c, Agent3__c, UserName__c, RFA__c, ApprovalProcess__c FROM RFAUserRole__c WHERE
	// RecordType.Name = 'Approver' AND ApprovalRecommendation__c = 'Awaiting Approval' ORDER BY UserName__c
	global RFA_AP10_BatchReminder(String query)
	{
		// set the query string
		this.query = query;
	}
	
	/**
     *  Start Method
     *  @param Database.BatchableContext ctx
     */
	global Database.queryLocator start(Database.BatchableContext ctx)
	{ 
		return Database.getQueryLocator(query);											
	}
	
	
	/**
     *  Execute Method
     *  @param Database.BatchableContext ctx, List<Sobject> scope
     */
	global void execute(Database.BatchableContext ctx, List<Sobject> scope)
	{
		List<RFAUserRole__c> approvers = (List<RFAUserRole__c>)scope;
		
		if(!approvers.isEmpty())
		{
			prepareEmailRecipients(approvers);	
		}	
	}
	
	 /**
     *  prepareEmailRecipients
     *  @param List<RFAUserRole__c>
     */
	global void prepareEmailRecipients(List<RFAUserRole__c> approvers)
	{		
		
		// iterate over list of approver records
		for(RFAUserRole__c approver : approvers)
		{
			// if UserName is not null
			if(approver.UserName__c <> null)
			{
				// check if user reference already available in the map
				if(approverRFAIdsMap.containsKey(approver.UserName__c))
				{
					// add the rfa to its existing list
					approverRFAIdsMap.get(approver.UserName__c).add(approver.RFA__c);			
				}else
				{
					// instantiate a new set
					Set<String> rfaSet = new Set<String>();
					// add to set
					rfaSet.add(approver.RFA__c);
					// add the user as key and add the set.
					approverRFAIdsMap.put(approver.UserName__c, rfaSet);
				}	
			} 
			
			// if Agent1 is not null
			if(approver.Agent1__c <> null)
			{
				// check if user reference already available in the map
				if(approverRFAIdsMap.containsKey(approver.Agent1__c))
				{
					// add the rfa to its existing list
					approverRFAIdsMap.get(approver.Agent1__c).add(approver.RFA__c);			
				}else
				{
					// instantiate a new set
					Set<String> rfaSet = new Set<String>();
					// add to set
					rfaSet.add(approver.RFA__c);
					// add the user as key and add the set.
					approverRFAIdsMap.put(approver.Agent1__c, rfaSet);
				}	
			} 
			
			// if Agent2 is not null
			if(approver.Agent2__c <> null)
			{
				if(approverRFAIdsMap.containsKey(approver.Agent2__c))
				{
					// check if user reference already available in the map
					approverRFAIdsMap.get(approver.Agent2__c).add(approver.RFA__c);			
				}else
				{
					// instantiate a new set
					Set<String> rfaSet = new Set<String>();
					// add to set
					rfaSet.add(approver.RFA__c);
					// add the user as key and add the set.
					approverRFAIdsMap.put(approver.Agent2__c, rfaSet);
				}	
			} 
			
			// if Agent3 is not null
			if(approver.Agent3__c <> null)
			{
				if(approverRFAIdsMap.containsKey(approver.Agent3__c))
				{
					// check if user reference already available in the map
					approverRFAIdsMap.get(approver.Agent3__c).add(approver.RFA__c);			
				}else
				{
					// instantiate a new set
					Set<String> rfaSet = new Set<String>();
					// add to set
					rfaSet.add(approver.RFA__c);
					// add the user as key and add the set.
					approverRFAIdsMap.put(approver.Agent3__c, rfaSet);
				}	
			} 
			rfaIds.add(approver.RFA__c);	
		}
		
	}
	
	
	 /**
     *  prepareEmailMessage
     *  @param None
     */
	global List<Messaging.SingleEmailMessage> prepareEmailMessage() 
	{
		RFA_AP12_ReminderEmailUtil emailUtil = new RFA_AP12_ReminderEmailUtil();
		
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		
		Map<Id, RFA__c> rfaIdDetailMap = new Map<Id, RFA__c>();
		
		//Map<Id, RFA__c> rfaIdDetailMap = new Map<Id, RFA__c>([Select Id, ControlNumber__c FROM RFA__c WHERE Id IN : rfaIds]);
		
		for(List<RFA__c> rfaList : [Select Id, ControlNumber__c, RequestTitle__c FROM RFA__c WHERE Id IN : rfaIds LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())])
		{
			for(RFA__c rfa : rfaList)
			{
				rfaIdDetailMap.put(rfa.Id, rfa);	
			}
		}
		
		for(String approver : approverRFAIdsMap.keySet())
		{
			List<String> associatedRFAs = new List<String>();
			
			associatedRFAs.addAll(approverRFAIdsMap.get(approver));
			
			String htmlBody;
			
			htmlBody = emailUtil.prepareEmailBody(associatedRfAs, rfaIdDetailMap, htmlBody);
			
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			
			mail.setTargetObjectId(approver);
			
			mail.setHtmlBody(htmlBody);
			
			mail.saveAsActivity = false;
			
			mail.setSubject(emailUtil.EMAIL_SUBJECT_AP10);
			
			mails .add(mail);	
		}	
		
		return mails;
	}
	
	/**
     *  Finish Method
     *  @param Database.BatchableContext ctx
     */
	global void finish(Database.BatchableContext ctx)
	{
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		if(!approverRFAIdsMap.isEmpty())
		{
			mails = prepareEmailMessage();	
		}	
		if(!mails.isEmpty()) Messaging.sendEmail(mails);
	}
}