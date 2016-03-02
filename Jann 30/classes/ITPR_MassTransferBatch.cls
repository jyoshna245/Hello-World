/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_MassTransferBatch
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 01/04/2014
 *  Assumptions      : N/A 
 *  Description      : This class is written to transfer the requests from one primary assignee to another.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
global class ITPR_MassTransferBatch implements Database.Batchable<sObject>{
    /*declaration of variables*/
    public string query;
    public set<id> setUserIds = new set<id>();
    List<ITPR__c> lt = new List<ITPR__c>();
    /*end declaration of variables*/    
    public List<ITPR_Mass_Transfer__c> lstMassTransferRecords = new List<ITPR_Mass_Transfer__c>([Select Mass_Transfer_To__c,Mass_Transfer_To__r.Id,Select_User__c,Mass_Transfer_To__r.Name,Transferred__c from ITPR_Mass_Transfer__c where Transferred__c = false]);

    //overridden method of batchable interface which returns the query to be processed
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
            for(ITPR_Mass_Transfer__c itprMassTransferObj : lstMassTransferRecords )
            {
                setUserIds.add(itprMassTransferObj.Select_User__c);
            }
            query = 'SELECT id,name,Status__c,primary_assignee__c,Procurement_Assignee__c,Legal_Assignee__c FROM ITPR__c WHERE Procurement_Assignee__c IN :setUserIds or Legal_Assignee__c IN :setUserIds';
            system.debug('query-----'+query);
            return Database.getQueryLocator(query);
    }
    
    //transfers the requests from a primary assignee to another based on the mass transfer records created, with transferred checkbox as false.
    global void execute(Database.BatchableContext BC,  List<ITPR__c> scope)
    { 
             
             List<ITPR__c> lstITPRTobeUpdated = new List<ITPR__c>();
           
             for(sObject s : scope){
                 ITPR__c objITPR = (ITPR__c)s;
                 system.debug('objitpr---'+objitpr.Name);
                 for(ITPR_Mass_Transfer__c selectedITPRMassTransfer : lstMassTransferRecords){
                    //checks if a procurement assignee exists from whom the requests are to be transferred and updates the procurement assignee and the 
                    //primary assignee with the new assignee from mass transfer records
                    if(objITPR.Procurement_Assignee__c != null && objITPR.Procurement_Assignee__c == selectedITPRMassTransfer.Select_User__c){
                       system.debug('enter if-----'+objITPR.Procurement_Assignee__c);
                       objITPR.Procurement_Assignee__c = selectedITPRMassTransfer.Mass_Transfer_To__r.Id;
                       objItpr.primary_assignee__c = selectedITPRMassTransfer.Mass_Transfer_To__r.Name;
                       system.debug(objITPR.Procurement_Assignee__c+'after----');
                       lstITPRTobeUpdated .add(objITPR);
                       selectedITPRMassTransfer.Transferred__c = true;
                    }
                    //checks if a legal assignee exists from whom the requests are to be transferred and updates the legal assignee and the 
                    //primary assignee with the new assignee from mass transfer records
                    else if(objITPR.Legal_Assignee__c != null && objITPR.Legal_Assignee__c == selectedITPRMassTransfer.Select_User__c){
                       objITPR.Legal_Assignee__c = selectedITPRMassTransfer.Mass_Transfer_To__r.Id;
                       objitpr.primary_assignee__c = selectedITPRMassTransfer.Mass_Transfer_To__r.Name;
                       lstITPRTobeUpdated .add(objITPR);
                       selectedITPRMassTransfer.Transferred__c = true;
                    }
                     
                 }
              }
              //update the ITPR requests which satisfy the above condition
             if(lstITPRTobeUpdated != null && lstITPRTobeUpdated.size() >0){
                try{
                        system.debug('size end----'+lstITPRTobeUpdated.size());
                        ITPR_Validator_cls.setAlreadyDone();
                        system.debug(ITPR_Validator_cls.hasAlreadyDone()+'ITPR_Validator_cls.hasAlreadyDone()------');
                        update lstITPRTobeUpdated;
                        system.debug('size end new----'+lstITPRTobeUpdated.size());
                        for(ITPR__c itpr : lstITPRTobeUpdated){
                             system.debug(itpr.procurement_assignee__c+'procure assignee new-----'+itpr.name);
                        }
                }catch(Exception e){
              
                }
             }
             //update the mass transfer records by setting transfeered checkbox to true, indicating that the mass transfer happened
             if(lstMassTransferRecords!= null && lstMassTransferRecords.size() >0){
                try{
                    update(lstMassTransferRecords);
                }catch(Exception e){
                }
             }
  }
  
  //overridden method of Batchable interface
  global void finish(Database.BatchableContext BC)
  {
  
  }
}
/*********************************************END*****************************************************************************************************************/