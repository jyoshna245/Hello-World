/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Trigger          : ITPR_SubmitForApproval
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 
 *  Assumptions      : N/A 
 *  Description      : This trigger performs the following actions:
                       1. If Wave 1 approval process is complete, then check if Wave 2 section has any approver selected.
                          a. If Wave 2 section has an approver selected, then submit the record for approval.
                          b. If Wave 2 section has no approver selected, then check if Wave 3 section has any approver selected.
                             If Wave 3 has an approver selected, then update the Wave2_Approved__c flag to true.
                             This will enable the application to submit the record for approval to a Wave 3 approver.
                          c. If no approver is selected in Wave 2 as well as Wave 3 sections, then update the status of the
                             record to 'All Digital Initials Obtained'.
                       2. If Wave 2 approval process is complete, then check if Wave 3 section has any approver selected.
                          a. If Wave 3 section has an approver selected, then submit the record for approval.
                          b. If Wave 3 section has no approver selected, then update the status of the
                             record to 'All Digital Initials Obtained'.
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
 
trigger ITPR_SubmitForApproval on ITPR__c (before Update,after update) {


if(trigger.isAfter)
{

String x;
    //Add all records that should be submitted for approval to a list and submit the list in one DML operation
    List<Approval.ProcessSubmitRequest> lstApprovalsToSubmit = new List<Approval.ProcessSubmitRequest>();
    //Add all records that need to be updated and update the list in one DML operation
    List<ITPR__c> lstItprToUpdate = new List<ITPR__c>();
    
    for (Integer i = 0; i < Trigger.new.size(); i++) {
        //Check if the Wave1_Approved__c flag has changed from false to true.
        //This indicates that Wave 1 approval process is complete
        if (Trigger.old[i].Wave1_Approved__c == false && Trigger.new[i].Wave1_Approved__c == true && Trigger.new[i].Do_you_want_additional_approver__c == false) {
            //Check if Wave2_Approver_1__c is populated
            if(Trigger.new[i].Wave2_Approver_1__c != null){
                //create the new approval request to submit
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('All Wave 1 approvals obtained');
                req.setObjectId(Trigger.new[i].Id);
                
                lstApprovalsToSubmit.add(req);
            }else{
                //Wave 2 has no approvers selected. Check if Wave3_Approver_1__c is populated
                if(Trigger.new[i].Wave3_Approver_1__c != null){
                    //Wave 2 section has no approvers selected but Wave 3 section has approvers selected.
                    //Automatically set the flag Wave2_Approved__c = true to allow next approval process to begin.
                    ITPR__c itpr = new ITPR__c(Id = Trigger.new[i].Id, Wave2_Approved__c = true);
                    lstItprToUpdate.add(itpr);
                }else{
                    //No more approvers are remaining. Change the status
                    //ITPR__c itpr = new ITPR__c(Id = Trigger.new[i].Id, Status__c = System.Label.ITPR_All_Digital_Initials_Obtained_Status);
                    //lstItprToUpdate.add(itpr);
                }
            } 
        }
        //Check if the Wave2_Approved__c flag has changed from false to true.
        //This indicates that Wave 2 approval process is complete
        else if(Trigger.old[i].Wave2_Approved__c == false && Trigger.new[i].Wave2_Approved__c == true && Trigger.new[i].Do_you_want_additional_approver__c == false){
        
        system.debug('enter inside');
            //Check if Wave3_Approver_1__c is populated
            if(Trigger.new[i].Wave3_Approver_1__c!=null){
            
            system.debug('enter inside');
                //create the new approval request to submit
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('All Wave 2 approvals obtained');
                req.setObjectId(Trigger.new[i].Id);
                
                lstApprovalsToSubmit.add(req); 
            }else{
                //No more approvers are remaining. Change the status
               // ITPR__c itpr = new ITPR__c(Id = Trigger.new[i].Id, Status__c = System.Label.ITPR_All_Digital_Initials_Obtained_Status);
                //lstItprToUpdate.add(itpr);
            }   
        }
    }
    
    //Submit the records for approval
    if(lstApprovalsToSubmit != null && lstApprovalsToSubmit.size() > 0){
        Approval.ProcessResult[] lstResult = Approval.process(lstApprovalsToSubmit);
    }
    
    //Update the records that need to be updated
    if(lstItprToUpdate != null && lstItprToUpdate.size() > 0){
       update lstItprToUpdate;
    }
    }
    
    if(trigger.isbefore){
    for(ITPR__c it:Trigger.new){
    if(it.Status__c == System.Label.ITPR_In_Approvals_Status){
    if(((it.Wave1_Approved__c == true)&&(it.Wave2_Approver_1__c == null)&&(it.Wave3_Approver_1__c == null)&& (it.Do_you_want_additional_approver__c == false))
    ||((it.Wave1_Approved__c == true)&&(it.Wave2_Approved__c == true)&&(it.Wave3_Approver_1__c == null))&& (it.Do_you_want_additional_approver__c == false)){
    it.Status__c = System.Label.ITPR_All_Digital_Initials_Obtained_Status;
   }
    /*if(it.Wave1_Approved__c == true && it.Wave2_Approver_1__c == null && it.Wave3_Approver_1__c != null){
    it.Wave2_Approved__c = true;
     system.debug('#################' + it.Wave2_Approved__c);
    }*/
   }
  }
 }
}