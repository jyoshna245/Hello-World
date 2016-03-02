/*
    Author           : Accenture
    Date Created  : 06/29/2012
    Version          : 1.0 
*/
trigger RUU_ReportingUsersTrigger on ReportingUnitUserRole__c (after insert, after update, after Delete) {
 
   /*~~~~Start of Initialization~~~~*/
   RFA_AP08_ReportingUnitUsersTrigger reportingUnitcls=new RFA_AP08_ReportingUnitUsersTrigger();
   List<ReportingUnitUserRole__c> rURoleLst = New List<ReportingUnitUserRole__c>(); 
   /*~~~~End of Initialization~~~~*/
   
   if(trigger.IsAfter)
    {
        /**********************************Trigger before insert block starts here***************************/
        if(trigger.IsInsert) 
        {
             reportingUnitcls.processRecords(trigger.New);    // Update parent record for sharing recalulation 
        }
        /**********************************Trigger before insert block Ends here***************************/
        
        /**********************************Trigger before update block starts here***************************/
        if(trigger.isUpdate)
        {
            for(ReportingUnitUserRole__c rURole : trigger.new)
            {
            	// GA 5/8/13: Changed if statement. Old if statement as follows:
            	// if(rURole.ReportingUnit__c <> trigger.oldMap.get(rURole.Id).ReportingUnit__c && rURole.ReportingUnit__c <> trigger.oldMap.get(rURole.Id).ReportingUnit__c)
                if(rURole.ReportingUnit__c <> trigger.oldMap.get(rURole.Id).ReportingUnit__c || rURole.User__c <> trigger.oldMap.get(rURole.Id).User__c)
                    rURoleLst.add(rUrole);
            }
            if(!rURoleLst.IsEmpty())
                reportingUnitcls.processRecords(rURoleLst);    // Update parent record for sharing recalulation            
        }
        /**********************************Trigger before update block ends here***************************/
        
        if(trigger.isDelete)
        {
            reportingUnitcls.processRecords(trigger.old);
        }        
    }
}