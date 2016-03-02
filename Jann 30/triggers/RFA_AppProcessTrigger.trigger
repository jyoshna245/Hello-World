/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Trigger          : RFA_AppProcessTrigger 
 *  Author           : Accenture
 *  Version History  : 2.0
 *  Creation         : 5/31/2012
 *  Assumptions      : N/A
 *  Description      : Trigger contains business logic to process RFA for its different Stages/level
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
 
 
trigger RFA_AppProcessTrigger on ApprovalProcess__c (after update, after insert) {
   
    List<RFA__c> rfaUpdateList = new List<RFA__c>();   
    
    RFA_AP03_ApprovalProcessHelper processhelper = new RFA_AP03_ApprovalProcessHelper();
    
    for(ApprovalProcess__c appProcess : Trigger.new)
    {
        system.debug(appProcess.Status__c+'appProcess.Status__c');
        if(appProcess.Status__c == RFAGlobalConstants.PROCESS_COMPLETED )
        {
                         
             RFA__c rfaUpdate = new RFA__c(Id = appProcess.RFA__c);
             rfaUpdate.Stage__c = RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE; 
             rfaUpdateList.add(rfaUpdate);           
        }
        else if(appProcess.Status__c == RFAGlobalConstants.PROCESS_IN_PROGRESS)
        {
             RFA__c rfaUpdate = new RFA__c(Id = appProcess.RFA__c);
             rfaUpdate.Stage__c = RFAGlobalConstants.RFA_CIRCULATION_STAGE; 
             rfaUpdateList.add(rfaUpdate);  
        
        }
        System.debug('\n rfa update list :'+rfaUpdateList);
    }
    
    if(!rfaUpdateList.isEmpty())
    {
           try{
                update rfaUpdateList; 
           }catch(DMLException dme)
           {
             Trigger.new[0].addError(dme.getMessage());
           }
                  
    }

}