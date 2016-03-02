/*
    Author           : Accenture
    Date Created     :  5/18/2012 
    Description      : This class is called from the trigger and contains logic required for the processing of workitems (RFA User Roles) post insertion and updation
    Version          : 1.0 
*/
public class RFA_AP04_ApprovalWorkItemHelper
{
    /*~~~~Start of Variable Initialization~~~~*/
    // Map of UserRole Id and RFA User Role for update
    private static Map<Id, RFAUserRole__c> approversForUpdate = new Map<Id, RFAUserRole__c>();
    
    // List of completed Approval Processes
    private static List<ApprovalProcess__c> completedProcesses = new List<ApprovalProcess__c>();
    
    // List of RFA Share records for insert
    private static List<RFA__Share> rfaShareForInsert = new List<RFA__Share>();
    
    // List of Approval Processes for update
    List<ApprovalProcess__c> processesForupdate = new list<ApprovalProcess__c>();
    
    private RFA_Util_ObjectQuery objectQuery;
    
    public static Map<String, RecordType> approverRecordTypeMap = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
    /*~~~~End of Variable Initialization~~~~*/
    
    // constructor for the class.   
    public RFA_AP04_ApprovalWorkItemHelper()
    {
        this.objectQuery = new RFA_Util_ObjectQuery(); 
    }
    
    /** @Method <This method adds Approvers for in-progress approvals and specifies tge default order for them>
       @param <List<RFAUserRole__c> approvers, Set<Id> processIds>
       @return Boolean - void
    */ 
    public void processWorkITemBeforeInsert(List<RFAUserRole__c> approvers, Set<Id> rfaIds)
    {
        // Map variable for holding ApprovalProcess__c
        Map<String, ActiveProcessInstance> instanceMap = new Map<String, ActiveProcessInstance>(); 
        // Query ApprovalProcess for matching rfaIds and Status = "In Progress"  
        ApprovalProcess__c[] processes = [Select Id, RFA__c, ApprovalProcessLevel__c, Status__c, 
                                         (Select ApprovalRecommendation__c, ApprovalOrder__c
                                          From Approvers__r WHERE TECH_IsComplete__c = : 'false' ORDER BY ApprovalOrder__c DESC LIMIT 1) //'added WHERE clause to fix INC0112735 - BSA Nov 9, 2012
                                          FROM ApprovalProcess__c
                                          Where RFA__c IN : rfaIds
                                          AND Status__c = : RFAGlobalConstants.PROCESS_IN_PROGRESS];
        
        // iterate over processes
        for(ApprovalProcess__c processInstance : processes)
        {
            // hash key map of RFA__c and ApprovalProcessLevel
            String key = processInstance.RFA__c + ':' + processInstance.ApprovalProcessLevel__c;
            system.debug('\n RSAS-0 value of key: ' +key);
            // List of approvers related to the Approval Process
            List<RFAUserRole__c> userRoleList = processInstance.Approvers__r;
            
            if(!userRoleList.isEmpty())
            {
                ActiveProcessInstance w;
                // check for available Approver of latest order and create a new ActiveProcessInstance
                if((userRoleList[0].ApprovalRecommendation__c <> null || userRoleList[0].ApprovalRecommendation__c <> '')
                   && userRoleList[0].ApprovalRecommendation__c == RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION)
                {
                    system.debug('\n RSAS-1:' + userRoleList[0].ApprovalRecommendation__c);
                    w = new ActiveProcessInstance(userRoleList[0].ApprovalRecommendation__c, userRoleList[0].ApprovalOrder__c, processInstance.Id);   
                }else{
                    system.debug('\n RSAS-1a');
                    w = new ActiveProcessInstance(null, userRoleList[0].ApprovalOrder__c, processInstance.Id); //original code   
                      
                }
                // populate map
                instanceMap.put(key, w);     
            }
        }   
        
        if(!instanceMap.isEmpty())
        {
            // iterate over the list of approvers
            for(RFAUserRole__c approver : approvers)
            {
                if(approver.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id)
                {
                    system.debug('\n RSAS-2');
                    String key = approver.RFA__c + ':' + approver.Level__c;
                    system.debug('\n RSAS-2a value of key: '+key);
                    // Get value by ey
                    if(instanceMap.get(key) <> null)
                    {
                        system.debug('\n RSAS-3');
                        approver.ApprovalRecommendation__c = instanceMap.get(key).recommendation <> null?instanceMap.get(key).recommendation: '';
                        approver.ApprovalOrder__c = instanceMap.get(key).maxOrder;
                        approver.ApprovalProcess__c =  instanceMap.get(key).processInstance;
                        
                        system.debug('\n RSAS-4 value of approver.ApprovalRecommendation__c :' + approver.ApprovalRecommendation__c);
                        // Create RFA Share record since the approver is added for an in progress Approval Process.
                        // create share record for actual share record
                        if(instanceMap.get(key).recommendation <> null)
                        {
                            //Modified the Access Level from 'Edit' to 'Read' for PRB0003969 - Need to fix Approver's Access Rights in RFA when added during Circulation - BSA 01-July-2013
                            if(approver.UserName__c <> null) rfaShareForInsert.add(new RFA__Share(parentId = approver.RFA__c, AccessLevel = 'Read', UserOrGroupId = approver.UserName__c, RowCause = Schema.RFA__Share.RowCause.Approver__c));
                            // create share record for Agent 1
                            if(approver.Agent1__c <> null)  rfaShareForInsert.add(new RFA__Share(parentId = approver.RFA__c, AccessLevel = 'Read', UserOrGroupId = approver.Agent1__c, RowCause = Schema.RFA__Share.RowCause.Approver__c));
                            // create share record for Agent 2
                            if(approver.Agent2__c <> null)  rfaShareForInsert.add(new RFA__Share(parentId = approver.RFA__c, AccessLevel = 'Read', UserOrGroupId = approver.Agent2__c, RowCause = Schema.RFA__Share.RowCause.Approver__c));
                            // create share record for Agent 3
                            if(approver.Agent3__c <> null)  rfaShareForInsert.add(new RFA__Share(parentId = approver.RFA__c, AccessLevel = 'Read', UserOrGroupId = approver.Agent3__c, RowCause = Schema.RFA__Share.RowCause.Approver__c));
                        }
                        
                    }else
                    {
                        system.debug('\n RSAS-5');
                        // variable storing the current level Order
                        Integer currentApprovalLevel = RFAGlobalConstants.LEVEL_ORDER_MAP.get(approver.Level__c);
                        
                        system.debug('\n RSAS-6 value of currentApprovalLevel: ' +currentApprovalLevel);
                        // iterate and check for higher level while the current level is less than available levels in Ordered level map
                        for(Integer level = currentApprovalLevel + 1; level <= RFAGlobalConstants.ORDERED_LEVEL_MAP.size() ; level ++)
                        {
                           
                            String hashKey = approver.RFA__c + ':' + RFAGlobalConstants.ORDERED_LEVEL_MAP.get(level);
                            // if match exists
                            system.debug('\n RSAS-6 value of hashKey: ' +hashKey);
                            
                            if(instanceMap.get(hashKey) <> null)
                            {
                                 system.debug('\n RSAS-7');
                                // populate approver detail
                                approver.ApprovalRecommendation__c = instanceMap.get(hashKey).recommendation <> null?instanceMap.get(hashKey).recommendation: '';
                                approver.ApprovalOrder__c = instanceMap.get(hashKey).maxOrder;
                                approver.ApprovalProcess__c =  instanceMap.get(hashKey).processInstance;
                                
                                system.debug('\n RSAS-8 value of approver.ApprovalRecommendation__c: ' +approver.ApprovalRecommendation__c );
                                system.debug('\n RSAS-9 value of approver.ApprovalOrder__c: ' +approver.ApprovalOrder__c );
                                system.debug('\n RSAS-10 value of approver.ApprovalProcess__c: ' +approver.ApprovalProcess__c );
                                
                                
                                if(instanceMap.get(hashKey).recommendation <> null)
                                {
                                    // create RFA Share record since the approver is added for an in progress Approval Process
                                    // creat share record for User
                                    //Modified the Access Level from 'Edit' to 'Read' for PRB0003969 - Need to fix Approver's Access Rights in RFA when added during Circulation - BSA 01-July-2013
                                    if(approver.UserName__c <> null) rfaShareForInsert.add(new RFA__Share(parentId = approver.RFA__c, AccessLevel = 'Read', UserOrGroupId = approver.UserName__c, RowCause = Schema.RFA__Share.RowCause.Approver__c));
                                    // create share record for Agent 1
                                    if(approver.Agent1__c <> null)  rfaShareForInsert.add(new RFA__Share(parentId = approver.RFA__c, AccessLevel = 'Read', UserOrGroupId = approver.Agent1__c, RowCause = Schema.RFA__Share.RowCause.Approver__c));
                                    // create share record for Agent 2
                                    if(approver.Agent2__c <> null)  rfaShareForInsert.add(new RFA__Share(parentId = approver.RFA__c, AccessLevel = 'Read', UserOrGroupId = approver.Agent2__c, RowCause = Schema.RFA__Share.RowCause.Approver__c));
                                    // create share record for Agent 3
                                    if(approver.Agent3__c <> null)  rfaShareForInsert.add(new RFA__Share(parentId = approver.RFA__c, AccessLevel = 'Read', UserOrGroupId = approver.Agent3__c, RowCause = Schema.RFA__Share.RowCause.Approver__c));                                 
                                }
                                
                                break;
                            }
                        }
                    }
                   
                }

                /*else // info only user
                {
                    // variable storing the current level Order
                    Integer currentInfoOnlyLevel = RFAGlobalConstants.LEVEL_ORDER_MAP.get(approver.Level__c);
                    
                    for(Integer level = currentInfoOnlyLevel; level <= RFAGlobalConstants.ORDERED_LEVEL_MAP.size() ; level ++)
                    {
                        String infohashKey = approver.RFA__c + ':' + RFAGlobalConstants.ORDERED_LEVEL_MAP.get(level);
                        // if match exists
                        if(instanceMap.get(infohashKey) <> null)
                        {
                            // associate approval process record to Info Only User record           
                            approver.ApprovalProcess__c =  instanceMap.get(infohashKey).processInstance;
                            
                            /* GA 5/9/2013 - Remove per 2013 Q1 FR 1.75 & FR 1.91 
                            *  The functionality in the following else block would add a sharing rule to the parent RFA for an Info Only RFA User record upon insert if approval process is in progress (the RFA is in circulation) for at level of info only or higher
                            *  New functionality will add sharing rule immediately if info only user is added at level or below current level of RFA.*//*
                            // create RFA Share record since the approver is added for an in progress Approval Process
                            // creat share record for User
                            //if(approver.UserName__c <> null) rfaShareForInsert.add(new RFA__Share(parentId = approver.RFA__c, AccessLevel = 'Edit', UserOrGroupId = approver.UserName__c, RowCause = Schema.RFA__Share.RowCause.Reviewer__c));
                            
                            
                            break;
                        }
                   }
                }*/
                
            }   
        }
        
         // insert RFA Share records
        if(!rfaShareForInsert.isEmpty()) insert rfaShareForInsert;
        // clear List (Cache of records)
        rfaShareForInsert.clear();                                      
    }
    
    /** @Method <This method adds Info Only to existing Approval Process records>
       @param <List<RFAUserRole__c> Info Only
       @return Boolean - void
    */ 
    public void setInfoOnlyApprovalProcess(List<RFAUserRole__c> infoOnlyUsers, Set<Id> rfaIds)
    {
        // Query ApprovalProcess for matching rfaIds and Status = "In Progress"  
        Map<Id, RFA__c> rfaProcesses = New Map<Id, RFA__c>([Select Id, 
            (Select ApprovalProcessLevel__c From Approval_Processes__r 
            WHERE Status__c = : RFAGlobalConstants.PROCESS_IN_PROGRESS OR Status__c = : RFAGlobalConstants.PROCESS_COMPLETED) 
            FROM RFA__c WHERE Id IN :rfaIds]);
        
        // iterate through infoOnlyUsers
        for(RFAUserRole__c infoOnlyUser :infoOnlyUsers)
        {
            for(ApprovalProcess__c approvalProcess: rfaProcesses.get(infoOnlyUser.RFA__c).Approval_Processes__r)
            {
                if(approvalProcess.ApprovalProcessLevel__c == infoOnlyUser.Level__c)
                {
                    // associate approval process record to Info Only User record           
                    infoOnlyUser.ApprovalProcess__c =  approvalProcess.id;
                    
                    break;
                }
            }
        }
                                              
    }    
    
    
    /**
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to wrap Active Approval Process properties.
        Version          : 2.0 
    */ 
    public class ActiveProcessInstance
    {
        //variable for Approval Recommendation
        String recommendation;
        // variable for maximum Approval order related to an Approval Process
        Decimal maxOrder;
        // ApprovalProcess reference
        String processInstance;
        
        // constructor for the class
        public ActiveProcessInstance(String recommendation, Decimal maxOrder, String processInstance)
        {
            this.recommendation = recommendation;
            this.maxOrder = maxOrder;
            this.processInstance = processInstance;
        }
    }
    
    /** @Method <This method processes Approvers which are deleted from an In - Progress Approvsl Process. This methods checks the deletion
                 of last approver from an Active approval process and contains logic to close the approval process upon deletion.>
       @param <List<RFAUserRole__c> deletedApprovers, Set<Id> approvalProcesses.>
       @return Boolean - void
       @CalledFrom : RFA_UserRole Trigger
    */    
    public void processWorkItemsAfterDelete(List<RFAUserRole__c> deletedApprovers, Set<Id> approvalProcesses)
    {
        // List of Approval processes
        List<ApprovalProcess__c> processForCloseList = new List<ApprovalProcess__c>();
        
        // Query ApprovalProcess__c Id matches in available Set<Id> and Status ="In- Progress"
        ApprovalProcess__c[] processes = [Select Id, RFA__c, ApprovalProcessLevel__c, Status__c, 
                                         (Select ApprovalRecommendation__c, ApprovalOrder__c
                                          From Approvers__r
                                          WHERE Id NOT IN: deletedApprovers
                                          AND TECH_IsComplete__c = : 'false')
                                          FROM ApprovalProcess__c
                                          Where Id IN : approvalProcesses
                                          AND Status__c = : RFAGlobalConstants.PROCESS_IN_PROGRESS];    
        
        // iterate over list of Approval Processes                                  
        for(ApprovalProcess__c process : processes)
        {
            List<RFAUserRole__c> approvers = process.Approvers__r;
            
            System.debug('\n Active Approval Work Items :'+approvers);
            
            if(approvers.isEmpty())
            {
                // set process status to "Completed"
                process.Status__c = RFAGlobalConstants.PROCESS_COMPLETED;
                processForCloseList.add(process);              
            }
            
            
        } 
        System.debug('\n Processes for close :'+processForCloseList);
        if(!processForCloseList.isEmpty()) update processForCloseList;                                 
    }    
    
    /**
      * @Description: Processes the Approval Workitem related to a Process Instance
      * @Param: Set<Id> 
      */
      
    public void processWorkItems(Set<Id> processIds)
    {
           
        Map<Integer, List<RFAUserRole__c>> approverPerOrderMap = new Map<Integer, List<RFAUserRole__c>>();
                                              
        List<ApprovalProcess__c> processes = [SELECT ApprovalProcessLevel__c, ApprovalProcessRouting__c, Status__c, 
                                             (SELECT ApprovalOrder__c, level__c, ApprovalRecommendation__c, UserName__c, TECH_IsComplete__c , RFAStage__c
                                              FROM Approvers__r
                                              WHERE RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id 
                                              ORDER BY ApprovalOrder__c) 
                                              FROM ApprovalProcess__c
                                              WHERE Id IN : processIds LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())]; 
                                             
        if(!processes.isEmpty())
        {
            for(ApprovalProcess__c processInstance : processes)
            {
                // List of approvers associated to the process
                List<RFAUserRole__c> approvers = processInstance.Approvers__r;
                
                System.debug('\n approvers for the process :'+approvers);
                
                List<RFAUserRole__c> approvrList = new List<RFAUserRole__c>();
                // This variable stores the order sequence
                Integer sequenceOrder = 0; 
                // Iterate over the list of approverrs
                for(RFAUserRole__c approver : approvers)      
                {
                    // first time entry or order sequence has changed
                    if(Integer.valueOf(approver.ApprovalOrder__c) <> sequenceOrder || sequenceOrder == 0)
                    {
                        // add it to collection
                        system.debug('\n RSAS-12 value of sequenceOrder:' + sequenceOrder);	
                        if(sequenceOrder <> 0) approverPerOrderMap.put(sequenceOrder, approvrList);
                        // new List of approvers
                        approvrList = new List<RFAUserRole__c>();
                    }
                     system.debug('\n RSAS-13 value of approver: '+approver );
                    // add approvers to list
                    approvrList.add(approver);
                    // record the change in order reference.                        
                    sequenceOrder = Integer.valueOf(approver.ApprovalOrder__c); 
                    system.debug('\n RSAS-14 value of sequenceOrder: '+sequenceOrder);
                }
                // add the last set of approvers and sequence to the collection.
                if(sequenceOrder <> 0)approverPerOrderMap.put(sequenceOrder, approvrList);
                
                System.debug('\n order map prepared : '+approverPerOrderMap);
                
                if(!approverPerOrderMap.isEmpty())
                {
                    
                    boolean isAppCompleteForPreviousOrder; //Added by BSA Aug 19 2013 for INC0875245
                    boolean isAppCompleteForNextOrder; //BSATEST
                    
                    for(Integer sequence : approverPerOrderMap.keySet())
                    {
                        
                        List<RFAUserRole__c> approversForThisOrder = approverPerOrderMap.get(sequence);
                       
                        boolean isAppCompleteForCurrentOrder = true;
                    	
                        for(RFAUserRole__c app : approversForThisOrder)
                        {
                            system.debug('\n RSAS-15 value of sequence:' + sequence);
                            system.debug('\n RSAS-16 value of Recommendation: ' +app.ApprovalRecommendation__c);
                            
                            if(app.TECH_IsComplete__c.trim().equalsIgnoreCase('false'))
                            {
                                //orderAtComplete = sequence;
                                isAppCompleteForCurrentOrder = false;
                                //break;
                                isAppCompleteForPreviousOrder=false; //Added by BSA Aug 19 2013 for INC0875245
                             
                             }
                             
                            //<start> added for INC1454846 / CHG0071721 by BSA 26-March-2014
                            //
                            else if (app.RFAStage__c==RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE || app.RFAStage__c==RFAGlobalConstants.RFA_STAGE_APPROVED)
                          	{
                          	  isAppCompleteForCurrentOrder = false;
                          	  isAppCompleteForPreviousOrder=false;
                          	}
                                                   	
                            //<end> added for INC1454846 / CHG0071721 by BSA 26-March-2014
                             
                       }      
							
							//<<fix Start - Added by BSA Aug 19 2013 for INC0875245>>               
                          	system.debug('\n RSAS-17 value of isAppCompleteForPreviousOrder:' + isAppCompleteForPreviousOrder);
                            
                            if(approverPerOrderMap.get(sequence + 1) == null && isAppCompleteForCurrentOrder)
                       		 {
                            		if( isAppCompleteForPreviousOrder==false)
                            		{
                            		//.. do nothing since there is still open approval from previous sequence
                            		}	
                            		else
                            		{
                            			closeProcessInstance(processInstance);
                            			isAppCompleteForPreviousOrder=null;
                            			break;
                            			                            			                            			                         		
                            		}
                        	}
                        	
                        	else if(isAppCompleteForCurrentOrder) 
                        	{
                            isAppCompleteForCurrentOrder = false;
                            system.debug('\n RSAS-19 value of (approverPerOrderMap.get(sequence + 1):' + approverPerOrderMap.get(sequence + 1));
                            activateApproversForNextOrder(approverPerOrderMap.get(sequence + 1));
                            //break;
                       		 }
                           //<<fix End - Added by BSA Aug 19 2013 for INC0875245>>
                  
                       //<<orig code Start-commented out by BSA Aug 19 2013 for INC0875245>>
                      /* system.debug('\n RSAS-18 value of isAppCompleteForCurrentOrder:' + isAppCompleteForCurrentOrder);
                        
                       if(approverPerOrderMap.get(sequence + 1) == null && isAppCompleteForCurrentOrder)
                        {
                            system.debug('\n RSAS-16 value of sequence:' + sequence);
                            closeProcessInstance(processInstance);
                            break;
                        }
                        else if(isAppCompleteForCurrentOrder) 
                        {
                            isAppCompleteForCurrentOrder = false;
                            system.debug('\n RSAS-17 value of (approverPerOrderMap.get(sequence + 1):' + approverPerOrderMap.get(sequence + 1));
                            activateApproversForNextOrder(approverPerOrderMap.get(sequence + 1));
                            //break;
                        }         */           
                    //<<orig code End-commented out by BSA Aug 19 2013 for INC0875245>>
                    }
                }
            }   
        }   
        System.debug('\n Approval processes to be closed :'+completedProcesses);
        
        System.debug('\n next level approvers to be activated :'+approversForUpdate);
        
        if(!approversForUpdate.isEmpty())
        {
            if(approversForUpdate.size() + Limits.getDMLRows() > Limits.getLimitDMLRows())
            {
                System.debug('\n Error Message from TRIGGER : please process with fewer records'); 
            }
            else
            {
                update approversForUpdate.values(); 
            }   
                
        }
        
        if(!completedProcesses.isEmpty())
        {
            if(completedProcesses.size() + Limits.getDMLRows() > Limits.getLimitDMLRows())
            {
                System.debug('\n Error Message from TRIGGER : please process with fewer records'); 
            }
            else
            {
                update completedProcesses;  
            }   
        }
         
        // reset the list
        approversForUpdate.clear();
        // reset list
        completedProcesses.clear();
        
    }
    
    /**
      * @Description: Set next Set of Approver's Approval recommendation to "Awaiting Approval" and activate them
      * @Param: Set<Id> 
      */
    public void activateApproversForNextOrder(List<RFAUserRole__c> approvers)
    {
        for(RFAUserRole__c approver : approvers)
        {
            if(approver.TECH_IsComplete__c.trim().equalsIgnoreCase('false'))
            {
                approver.ApprovalRecommendation__c = System.Label.RFA_CL056; // Awaiting Approval
                approver.ApprovalRequestedOn__c  = System.Now();
                approversForUpdate.put(approver.Id, approver);  
            }
            
            
        }
        //approversForUpdate.addAll(approvers);
    }
    
    /**
      * @Description: Close an In progress approval process.
      * @Param: Set<Id> 
      */
    public void closeProcessInstance(ApprovalProcess__c processInstance)
    {
        processInstance.Status__c = 'Completed';
        completedProcesses.add(processInstance);        
    }
}