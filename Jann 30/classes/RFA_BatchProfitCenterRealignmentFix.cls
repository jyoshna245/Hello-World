/**
* Class Name: RFA_BatchProfitCenterRealignmentFix 
* Author: Accenture
* Date: 12-24-2013
* Project Name: Coke-RFA
 * Requirement Description: This batch is used for realignment for security of Profit Center.
 **/
 
global class RFA_BatchProfitCenterRealignmentFix implements Database.Batchable<SObject>{
    // Variable
    global string query;
    Public Set<id> profitCenterIds;
   
     public Static String errorString;
    /**
     * Constructor
     */
      public RFA_BatchProfitCenterRealignmentFix (String query,Set<id> profitCenterObjIds)
      {
            this.query=query;
            this.profitCenterIds = profitCenterObjIds;
      }
      /**
     *  start method
     *  @param Database.BatchableContext
     *  @return Database.Querylocator
     */
    global Database.Querylocator start(Database.BatchableContext bc){
        return DataBase.getQueryLocator(query);
    }
    /**
     *  execute method
     *  @param Database.BatchableContext
     *  @param List<SObject>
     */
    global void execute(Database.BatchableContext bC, List<RFA__c> RFAObjectList){
      Map<Id, Map<Id,String>> profitCenterMap=new Map<Id, Map<Id,String>>(); // RFAId,Profit Center,rfaLevel
      Map<Id,Id> rfaSharingDeleteMap=new Map<Id,Id>(); // RfaId , ProfitCenterId
      Map<Id,String> rfaLevelMap;//=new Map<Id,String>(); // used to store Profit Center ID, current RFA Level
      Set<Id> rfaCompletedSet=new Set<Id>(); // used to store completed RFA Ids
      List<ProfitCenter__c> profitCenterUpdateList=new List<ProfitCenter__c>(); // used to reset NeedRecalculation flag
      RFA_AP02_Shareutil shareUtil=new RFA_AP02_Shareutil(); //Instantiate ShareUtil class
      for(RFA__c rfaRecord: RFAObjectList)
        {rfaLevelMap=new Map<Id,String>();
        
            // If RFA is not within a circulation stage, assign rfaLevelMap to Profit Center ID, previous RFA level
            if(rfaRecord.Level__c == RFAGlobalConstants.RETURN_TO_SENDER || rfaRecord.Level__c == RFAGlobalConstants.CAPITAL_MGMT_HOLD || rfaRecord.Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW)
            {
                    if(rfaRecord.PreviousLevel__c==null ||rfaRecord.PreviousLevel__c=='' )
                    {   
                        if(errorString==null || errorString=='')
                            errorString=rfaRecord.Id;
                        else    
                            errorString=errorString +' ' +rfaRecord.Id;
                    }
                    else 
                    {
                        rfaLevelMap.put(rfaRecord.profitCenterNumber__c,rfaRecord.PreviousLevel__c);
                    }            
            }
            else // assign rfaLevelMap to Profit Center ID, current RFA level
            {
                    rfaLevelMap.put(rfaRecord.profitCenterNumber__c,rfaRecord.Level__c);
            }
               
           if(!rfaLevelMap.IsEmpty()) 
            {
            profitCenterMap.put(rfaRecord.Id,rfaLevelMap); // put (RFA ID, <RFA Profit Center ID, RFA Level>) in profitCenterMap
            rfaSharingDeleteMap.put(rfaRecord.Id,rfaRecord.profitCenterNumber__c);
            }
            
            // GA - added for 2013 Q2 FR1.93 - Location Coordinator should have read only access on closed RFA
            // if RFA is in a completed stage, add to rfACompletedSet
            if (rfaRecord.Stage__c == RFAGlobalConstants.RFA_STAGE_APPROVED || rfaRecord.Stage__c == RFAGlobalConstants.RFA_STAGE_REJECTED || rfaRecord.Stage__c == RFAGlobalConstants.RFA_STAGE_CLOSED)
              rfaCompletedSet.add(rfaRecord.id);
            
        }
        if(!profitCenterMap.IsEmpty())
        {
            shareUtil.rfaProfitCenterUpdateDeleteOldProfitCenter(rfaSharingDeleteMap);
            shareUtil.profitCenterAtRfaCreateShare(profitCenterMap);
        }
        
        // GA - added for 2013 Q2 FR1.93 - Location Coordinator should have read only access on closed RFA
        // call method to update Coordinator access on completed RFAs
        if (!rfaCompletedSet.IsEmpty())
          shareUtil.ModifyLocationCoordinatorAccess(rfaCompletedSet);
        
        // Reset NeedRecalculation field flag on Profit Center to False
        for(Id profitCenterId : profitCenterIds) 
        {
            ProfitCenter__c profitCenter=new ProfitCenter__c(id=profitCenterId);
            profitCenter.NeedRecalculation__c=false;
            profitCenterUpdateList.add(profitCenter);
                
        }
        if(!profitCenterUpdateList.IsEmpty())
        {
            update profitCenterUpdateList;
        }
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

  //set the email properties
    mail.setToAddresses(new string[] {Label.RFA_CL132}); //Custom label that holds RSAS email address - 12-Oct-2012
    mail.setSenderDisplayName('Batch Job');
    mail.setSubject('Recalculation Batch Job failed for RFA');
    mail.setHtmlBody('RFA Ids are: '+errorString);

    //send the email
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
          
    }
   
    /**
     *  finish method
     *  @param Database.BatchableContext
     */
    global void finish(Database.BatchableContext BC){
           
    }
     
}