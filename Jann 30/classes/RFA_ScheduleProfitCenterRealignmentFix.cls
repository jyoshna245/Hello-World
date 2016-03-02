Global class RFA_ScheduleProfitCenterRealignmentFix implements Schedulable{ 
/**
  *  execute  method
  *  @param Crone Time
  *  @return null    
  */
   global void execute(SchedulableContext sc) {
       Set<id> profitCenterIds=new Set<Id>(); 
       List<ProfitCenter__c> profitCenterList = [Select Id,name from ProfitCenter__c where NeedRecalculation__c = true and ActiveInactive__c='Active'];
       for(ProfitCenter__c profitCenterObj : profitCenterList){
           profitCenterIds.add(profitCenterObj.Id);
       }
       String Query = 'Select profitCenterNumber__c,id,Level__c, PreviousLevel__c, Stage__c from RFA__c where profitCenterNumber__c IN :profitCenterIds and Level__c !=null';
       Integer batchSize = 100;
       RFA_BatchProfitCenterRealignmentFix batchController = new RFA_BatchProfitCenterRealignmentFix(Query,profitCenterIds);
       database.executebatch(batchController , batchSize);
   }
}