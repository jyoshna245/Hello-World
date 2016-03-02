trigger ITPR_SubmitApprovalValidation on ITPR__c (before update) {
 public String errorMessage = '';
 LIST<ITSES_Additional_Attachment__c> AttachId =new LIST<ITSES_Additional_Attachment__c>();
 List <Attachment> FinalAttachmentCount = new LIST<Attachment>();

for(ITPR__c t: Trigger.new){
    ITPR__c ls = trigger.oldMap.get(t.Id);
     AttachId = [SELECT Id from ITSES_Additional_Attachment__c where IT_SES_Request__c = :t.Id  and Attachment_Type__c = 'Final Attachment'];                    
   FinalAttachmentCount = [SELECT Attachment.Id FROM Attachment where Attachment.ParentId =: AttachId] ;

    if (t.Status__c == 'In Approvals' && ls.Status__c == 'All Digital Initials Obtained' && t.Additional_Approval_Complete__c == true)
    {
       errorMessage += 'Request cannot be submitted for approval because it has already completed Wave Approvals & Additional Approval Process. Click on the back button in the browser to go back to the Request';    
    }
    else if(t.Status__c == 'In Approvals' && t.Final_Budget_Validated__c == False && ls.Status__c == 'Pending Project Final Budget' && ((t.Request_Type__c != 'RFI') && (t.Request_Type__c != 'RFP')))
            {
            // t.addError('Please ensure Final budget validated is checked before sending the request for approval. Click on the back button in the browser to go back to the Request');
            errorMessage += 'Please ensure Final budget validated is checked before sending the request for approval. Click on the back button in the browser to go back to the Request';
            } else if(t.Status__c == 'In Approvals' && ls.Status__c == 'Pending Project Final Budget' && ((t.Request_Type__c != 'RFI') && (t.Request_Type__c != 'RFP')) && ((t.If_Required_Has_The_TRB_Approved__c == 'No') || (t.If_Required_Has_The_TRB_Approved__c == NULL) || (t.If_Rqd_Has_Hosting_Cert_Team_Approved__c == 'No') || (t.If_Rqd_Has_Hosting_Cert_Team_Approved__c == NULL)))
                        {
                        errorMessage += 'Before submitting for approval, you must have all necessary approvals from the Hosting Cert. Team and TRB. Click on the back button in the browser to go back to the Request';
                        } else if(t.Status__c == 'In Approvals' && ls.Status__c == 'In Process' && ((t.Request_Type__c == 'NDA') ||(t.Request_Type__c == 'Other Legal') ||(t.Request_Type__c == 'Eval Agreement') || (t.Request_Type__c == 'Letter Of Termination')|| (t.Request_Type__c == 'Network Access Agreement')))
                          { 
                           If(FinalAttachmentCount.size() <= 0) { errorMessage += 'Please ensure there is an attachment in the Final Attachments section before sending the request for approval. Click on the back button in the browser to go back to the Request';   } 
                          } 


/*if((t.Status__c == 'In Approvals') && (ls.Status__c == 'Pending Project Final Budget') && ((t.Request_Type__c == 'RFI') ||(t.Request_Type__c == 'RFP'))){
   // t.addError('You cannot send RFx request types for approval');
    errorMessage += 'You cannot send RFx request types for approval';
    } */
    
    if(errorMessage != '')   { t.addError(errorMessage);      }   
  }
}