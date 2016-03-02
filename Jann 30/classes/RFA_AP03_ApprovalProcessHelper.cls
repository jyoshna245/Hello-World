/*
    Author           : Accenture
    Date Created  : 05/08/2012
    Description     : This class contains methods required for the processing of process instances and workitems
    Version          : 1.0 
*/


public class RFA_AP03_ApprovalProcessHelper {
    
    // Map containing List of Approval process for a given RFA. Cache
    public static Map<Id, List<ApprovalProcess__c>> rfaApprovalList = new Map<Id, List<ApprovalProcess__c>>();
        
    // Mapp containing List of Approvers for a given Approval process. Cache
    public static Map<Id, List<RFAUserRole__c>> processApproverList = new Map<Id, List<RFAUserRole__c>>();
    
    // variable for maintaining the cache if process instance approver list
    public static List<RFAUserRole__c> approverList = new List<RFAUserRole__c>();
    
    // variable for maintaining the cache of Approval processes.
    public static List<ApprovalProcess__c> processInstanceList = new List<ApprovalProcess__c>();
    
    // variable for maintaining the cache of act on behalf approver list
    public static List<RFAUserRole__c> actOnBehalfApproverList = new List<RFAUserRole__c>();   
    
    // variable for storing the SObject Record type mapping
    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP = 
        RFA_Util_RecordTypeHelper.createRecordTypesMap(new String[]{Schema.sObjectType.RFAUserRole__c.getName()}, new String[]{RFAGlobalConstants.APPROVER_RECORDTYPE, RFAGlobalConstants.RECORDTYPE_INFOONLY, RFAGlobalConstants.RECORDTYPE_CO_CREATOR, RFAGlobalConstants.RECORDTYPE_PRIMARY_POC});
    
    // variable for storing the SObject Record type mapping
    public static Map<String, RecordType> approverRecordTypeMap = RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());    
    
   //  
    //public static Map<>
    // To -Do: Evaluate if this can be moved to custom settings. 
    // Note : Caution - this is being used in the webservices.
    public static final Map<String, String> levelAbbrMap = new Map<String, String>{
        '1. Key Operations'     => 'KO',
        '2. Business Unit'      => 'BU',
        '3. Group'              => 'Group',
        '4. Corporate'          => 'Corporate',
        '5. Executive'          => 'Exec',
        '6. Senior Executive'   => 'Sr.Exec'
    };
    
    /*  @Method <This method updates the Approval Process with the status value>
        @param <SObject> - ApprovalProcess__c, <String> - Status 
        @return <void>
     */
    public static void updateApprovalProcess(ApprovalProcess__c processInstance, String status)
    {
        processInstance.Status__c = status;
        update processInstance; 
    }
    
    /*  @Method <This method resets the approval work items for a given approval process once the approval process is overriden and no more in 
                 circulation stage>
        @param <Map> - Id, ApprovalProcess__c
        @return <void>
     */
    public static void resetApprovalWorkItems(Map<Id, ApprovalProcess__c> approvalProcessMap)
    {
        
        List<RFAUserRole__c> resettedApprovers = new List<RFAUserRole__c>();
        
        List<ApprovalProcess__c> resettedProcessInstances = new List<ApprovalProcess__c>();
       
        for(RFAUserRole__c approver : [Select Id, ApprovalRecommendation__c, ApprovalProcess__c FROM RFAUserRole__c
                                       WHERE ApprovalProcess__c IN: approvalProcessMap.keySet()
                                       AND ApprovalRecommendation__c != : RFAGlobalConstants.PROCESS_IN_PROGRESS
                                       AND TECH_IsComplete__c = 'false'
                                       AND RecordTypeId = :approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id])
        {
            approver.ApprovalRecommendation__c = '';
            resettedApprovers.add(approver);    
        }
        
        for(ApprovalProcess__c process : approvalProcessMap.values())
        {
            process.Status__c = RFAGlobalConstants.PROCESS_NOT_COMPLETED;
            resettedProcessInstances.add(process);
        }
        if(!resettedProcessInstances.isEmpty()) update resettedProcessInstances;
        if(!resettedApprovers.isEmpty()) update resettedApprovers;
        
        
    }
    
     /* @Method <This method queries the RFAUserRole__c table and returns the associated approvers for a given RFA level >
        @param <SObject> - RFA__c 
        @return <list> - RFAUserRole__c
     */
    public static List<RFAUserRole__c>  getApprovers(RFA__c rfaObj, Set<String> levelSet)
    {
        System.debug('\n Level set :'+levelSet);
        if(approverList.isEmpty())
        {
            approverList = [Select UserName__r.Name, Level__c, ApprovalOrder__c, ApprovalRecommendation__c,TECH_IsComplete__c
                            FROM RFAUserRole__c
                            Where Level__c IN: levelSet
                            AND TECH_IsComplete__c = 'false'
                            AND RecordTypeId = :approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id
                            AND UserName__r.IsActive = true
                            AND RFA__c = :  rfaObj.Id ORDER BY CreatedDate];    
        }
        return approverList;
    }
    
    /* @Method <This method queries the RFAUserTable and return Agents and original actors>
       @param <String> - userId, <SObject> - RFA__c 
       @return <list> - RFAUserRole__c
     */
    public static List<RFAUserRole__c> getActOnBehalfApprovers(String userId, RFA__c rfaObj)
    {
        if(actOnBehalfApproverList.isEmpty())
        {
            actOnBehalfApproverList = [Select Id, UserName__c, UserName__r.Name, Level__c, ApprovalRecommendation__c, Agent1__r.Name, Agent2__r.Name, Agent3__r.Name
                                        FROM RFAUserRole__c 
                                        WHERE RFA__c =: rfaObj.Id
                                        AND TECH_IsComplete__c = 'false'
                                        AND ApprovalRecommendation__c = 'Awaiting Approval'
                                        AND (UserName__c =: userId
                                        OR Agent1__c =: userId
                                        OR Agent2__c =: userId
                                        OR Agent3__c =: userId)
                                        AND RecordTypeId =: approverRecordTypeMap.get('Approver').Id];
        }       
        return actOnBehalfApproverList;
    }
    
    /* @Method <This method queries the RFAUserTable and return Agents and original actors>
       @param <String> - userId, <SObject> - RFA__c 
       @return <list> - RFAUserRole__c
     */
    public static List<RFAUserRole__c> getApproversForProcess(String userId, RFA__c rfaObj)
    {
        if(actOnBehalfApproverList.isEmpty())
        {
            actOnBehalfApproverList = [Select Id, UserName__c, UserName__r.Name, Level__c, ApprovalRecommendation__c, Agent1__r.Name, Agent2__r.Name, Agent3__r.Name
                                        FROM RFAUserRole__c 
                                        WHERE RFA__c =: rfaObj.Id
                                        /*AND TECH_IsComplete__c = 'false'*/
                                        AND ApprovalRecommendation__c = 'Awaiting Approval'
                                        AND (ApprovalRecommendation__c != '')                                        
                                        AND (UserName__c =: userId
                                        OR Agent1__c =: userId
                                        OR Agent2__c =: userId
                                        OR Agent3__c =: userId)
                                        AND RecordTypeId =: approverRecordTypeMap.get('Approver').Id
                                        AND ApprovalProcess__r.Status__c = 'In Progress'];
        }         
        return actOnBehalfApproverList;
    }
    
     /* @Method <This method queries the ApprovalProcess object related to an RFA and return the detail >
        @param <sObject> - RFA__c 
        @return <List> - List of Approval Processes.
     */
    public static List<ApprovalProcess__c> getProcessInstance(RFA__c rfaObj)
    {
        if(processInstanceList.isEmpty())
        {
            processInstanceList = [Select Id, Name, Status__c, ApprovalProcessLevel__c 
                                   FROM ApprovalProcess__c
                                   where RFA__c =: rfaObj.Id
                                   AND ApprovalProcessLevel__c=: rfaObj.Level__c];
        }   
        
        return processInstanceList;
    }
    
    /* @Method <This method returns all the active approval processes for a given rfa>
        @param <String> - Id of RFA
        @return <Map> - Id, ApprovalProcess__c
     */
    public static Map<Id, ApprovalProcess__c> getActiveProcessInstances(Set<String> rfaIds)
    {
        Map<Id, ApprovalProcess__c> approvalProcessMap = new Map<Id, ApprovalProcess__c>([Select Id, Name, Status__c, ApprovalProcessLevel__c 
                                                                                        FROM ApprovalProcess__c
                                                                                        WHERE RFA__c IN: rfaIds
                                                                                        AND Status__c =: RFAGlobalConstants.PROCESS_IN_PROGRESS]);
        return approvalProcessMap;                                                                                       
    }
    
   
    /* @Method <This method commits the approval process for start receiving approval recommendations from the associated Approvers>
       @param <SObject> - ApprovalProcess__c, <SObject> - RFA__c 
       @return <ApprovalProcessHelper.ProcessResult>
     */
    public static Database.UpsertResult submitForApproval(ApprovalProcess__c processInstance, RFA__c rfaObj)
    {
        
        //ProcessResult pResult;  
        List<ApprovalProcess__c> processList = new List<ApprovalProcess__c>();
        processInstance.Status__c = RFAGlobalConstants.PROCESS_IN_PROGRESS;
        processInstance.RFA__c = rfaObj.Id;
        processInstance.ApprovalProcessLevel__c = rfaObj.Level__c;
        //processList.add(processInstance);
        Database.UpsertResult upsertResult = Database.upsert(processInstance);
       
        return upsertResult;
    }
    
    /* @Method <This method commits the approval process for start receiving approval recommendations from the associated Approvers>
       @param <SObject> - ApprovalProcess__c, <SObject> - RFA__c 
       @return <ApprovalProcessHelper.ProcessResult>
     */
    public static Database.UpsertResult submitForApproval(ApprovalProcess__c processInstance, RFA__c rfaObj, boolean hasNoApprover)
    {
        
        //ProcessResult pResult;  
        List<ApprovalProcess__c> processList = new List<ApprovalProcess__c>();
        processInstance.Status__c = RFAGlobalConstants.PROCESS_COMPLETED;
        processInstance.RFA__c = rfaObj.Id;
        processInstance.ApprovalProcessLevel__c = rfaObj.Level__c;
        //processList.add(processInstance);
        Database.UpsertResult upsertResult = Database.upsert(processInstance);
         
        /*for(Database.UpsertResult result : upsertResult)
        {
            if(result.isSuccess())
            {
                
                pResult = new ProcessResult(true, result.getId());
            }else
            {
                
                pResult = new ProcessResult(false, null);
            }   
        }*/
        return upsertResult;
    }
    
    /*  @Method <This method queries the RFAUserRole__c table and returns info Only copy users for a given RFA level >
        @param <sObject> - RFA__c 
        @return <List> - RFAUserRole__c
     */
    public static List<RFAUserRole__c> getInfoCopyUsers(RFA__c rfaObj)
    {
		// Code has been commented out By Accenture due to req change. Used when RFA Level should match Info Only level
        return [Select Id, UserName__c, Level__c, NotifyUsers__c FROM RFAUserRole__c 
                WHERE RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id              
                AND RFA__c =: rfaObj.Id
                AND UserName__r.IsActive = true
                AND Level__c =: rfaObj.Level__c];
                
        /* GA 5/13/2013: Commented out for 2013 Q1 FR1.91 fix/enhancement. The following is used when ignoring level
        return [Select Id, UserName__c, Level__c, NotifyUsers__c FROM RFAUserRole__c 
                WHERE RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id              
                AND RFA__c =: rfaObj.Id
                AND UserName__r.IsActive = true];   
        */
        
        //GA 5/13/2013: Was added for 2013 Q1 FR1.91 fix/enhancement. Used to compare Info Only at level or below
        /*rfa_Ap02_Shareutil shareUtil=new rfa_Ap02_Shareutil(); 
        //Boolean returnBlankList = true;
        List<RFAUserRole__c> toReturn = new List<RFAUserRole__c>();
		
		for(RFAUserRole__c userRole: [SELECT Id, Level__c, RFA_Level__c, ApprovalProcess__c, NotifyUsers__c FROM RFAUserRole__c
								WHERE RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id              
				                AND RFA__c =: rfaObj.Id
				                AND UserName__r.IsActive = true] )
    	{
    		// if Info Only user is at same level of RFA
    		if (shareUtil.compareRFALevel(userRole.Level__c, userRole.RFA_Level__c) == 0)
    		{
    			toReturn.add(userRole);
    		}
    		
    		// if Info Only user is at level below RFA Level and does not have an ApprovalProcess record associated to it
    		else if (shareUtil.compareRFALevel(userRole.Level__c, userRole.RFA_Level__c) < 0 && userRole.ApprovalProcess__c != null)
            {
            	// add user to list toReturn in order for system to associate an ApprovalProcess record to it.
            	// Records added to list will not be process for ApprovalProcess association if InfoOnly
            	toReturn.add(userRole);
            } 		
    	}
    	
	    return toReturn;*/
    } 
    
    
     /* @Method <This method queries the RFAUserRole__c table and returns Co - Creator users for a given RFA>
        @param <sObject> - RFA__c 
        @return <List<RFAUserRole__c>>
     */
    public static List<RFAUserRole__c> getCoCreator(RFA__c rfaObj)
    {
        return [Select Id, UserName__c, Level__c, NotifyUsers__c FROM RFAUserRole__c 
                WHERE RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id
                AND UserName__r.IsActive = true              
                AND RFA__c =: rfaObj.Id];
    }
    
    
    /* @Method <This method queries the RFAUserRole__c table and returns Co - Creator users for a given RFA>
       @param <Set<String>> 
       @return <List<RFAUserRole__c>>
     */
    public static List<RFAUserRole__c> getCoCreator(Set<String> rfaIds)
    {
        return [Select Id, UserName__c, Level__c, NotifyUsers__c FROM RFAUserRole__c 
                WHERE RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id 
                AND UserName__r.IsActive = true             
                AND RFA__c IN: rfaIds];
    }
    
    
    /* @Method <This method queries the RFAUserRole__c table and returns Primary Point of Contact users for a given RFA>
       @param <RFA__c> 
       @return <List<RFAUserRole__c>>
     */
    public static List<RFAUserRole__c> getPrimaryPointOfContact(RFA__c rfaObj)
    {
        return [Select Id, UserName__c, Level__c, NotifyUsers__c FROM RFAUserRole__c 
                WHERE RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id
                AND UserName__r.IsActive = true 
                AND RFA__c =: rfaObj.Id];
    }
    
    /* @Method <This method queries the RFAUserRole__c table and returns Primary Point of Contact users for a given RFA>
       @param <Set<String>> 
       @return <List<RFAUserRole__c>>
     */
    public static List<RFAUserRole__c> getPrimaryPointOfContact(Set<String> rfaIds)
    {
        return [Select Id, UserName__c, Level__c, NotifyUsers__c FROM RFAUserRole__c 
                WHERE RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id 
                AND UserName__r.IsActive = true             
                AND RFA__c IN: rfaIds];
    }
    
    /*  @Method <This method updates the field NotifyInfoUsers__c field for the info only users(RFAUserRole__c) so as to satisfy the workflow condition for sending out email notifications >
        @param <List> - RFAUserRole__c, <Boolean> - notify 
        @return <void>
     */
    public static void notifyInfoCopyUsers(List<RFAUserRole__c> reviewers, boolean notify, Id processId)    
    {
        List<RFAUserRole__c> reviewersForUpdate = new List<RFAUserRole__c>();
        for(RFAUserRole__c reviewer : reviewers)
        {
            if(reviewer.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id)
            	reviewer.ApprovalProcess__c = processId;
            //GA 5/13/2013: removed for 2013 Q1 FR1.91 Enhancement/fix. The NotifyUsers flag is now updated by RFA Triggers and RFA User Role Triggers for Info Only. Update NotifyUsers flag for other record types (Primary POC & Co-Creator)
            if(reviewer.RecordTypeId != approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id)
            	reviewer.NotifyUsers__c = notify;
            
            reviewersForUpdate.add(reviewer);
        }
        if(!reviewersForUpdate.isEmpty()) update reviewersForUpdate;    
    }

   
    /*  
    public class ProcessResult
    {
        public boolean isSuccess;
        public Id processId;
        
        
        
        public ProcessResult(boolean isSuccess, Id processId)
        {
            this.isSuccess = isSuccess;
            this.processId = processId;
        }
        
        public boolean getSuccess()
        {
            return isSuccess;
        }
        
        public String getProcessInstance()
        {
            return processId;
        }
    }    
*/

}