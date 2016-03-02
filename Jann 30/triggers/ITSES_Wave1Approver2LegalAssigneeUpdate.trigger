/****************************************************************************************************************************************
****************************************************************************************************************************************    

 *  Trigger          : ITSES_Wave1Approver2LegalAssigneeUpdate 
 *  Author           : CAPGEMINI
 *  Version History  : 1.0
 *  Creation         : 18/12/2014
 *  Assumptions      : N/A
 *  Description      : Trigger contains logic to update the Legal Assignee value into the Wave1 Approval name if not selected.

****************************************************************************************************************************
****************************************************************************************************************************************/
trigger ITSES_Wave1Approver2LegalAssigneeUpdate on ITPR__c (after insert) {

    List<ITPR__c> ITPR_List = new List<ITPR__c>();    
    
    for(ITPR__c j :[SELECT id, Wave1_Approver_1__c,Wave1_Approver_2__c,Wave1_Approver_3__c,Wave1_Approver_4__c,Wave1_Approver_5__c,Finance_Assignee__c ,Legal_Assignee__c FROM ITPR__c  WHERE ID IN:Trigger.new]){

system.debug('*** In for ***');
system.debug('*** In for ***' + j.Finance_Assignee__c);
        
system.debug('*** W1A1 ***' + j.Wave1_Approver_1__c);
system.debug('*** FA ***' + j.Finance_Assignee__c);
    
    if( j.Wave1_Approver_1__c != j.Legal_Assignee__c  || j.Wave1_Approver_2__c != j.Legal_Assignee__c  || j.Wave1_Approver_3__c != j.Legal_Assignee__c  || j.Wave1_Approver_4__c != j.Legal_Assignee__c  || j.Wave1_Approver_5__c != j.Legal_Assignee__c )
    {
        
system.debug('*** j.Wave1_Approver_1__c ***' + j.Wave1_Approver_1__c);
system.debug('*** j.Finance_Assignee__c ***' + j.Finance_Assignee__c);

        
        if(j.Wave1_Approver_1__c == null && j.Finance_Assignee__c == null){
        
system.debug('*** j.Wave1_Approver_1__c ***' + j.Wave1_Approver_1__c);
system.debug('*** j.Legal_Assignee__c ***' + j.Legal_Assignee__c);
            
            j.Wave1_Approver_1__c = j.Legal_Assignee__c;
        }
        else if(j.Wave1_Approver_2__c == null){
system.debug('*** j.Legal_Assignee__c ***' + j.Legal_Assignee__c);
            j.Wave1_Approver_2__c = j.Legal_Assignee__c;
        }
        else if(j.Wave1_Approver_3__c == null){
                j.Wave1_Approver_3__c = j.Legal_Assignee__c;
        }
        else if(j.Wave1_Approver_4__c == null){
                j.Wave1_Approver_4__c = j.Legal_Assignee__c;            
        }
        else if( j.Wave1_Approver_5__c == null){
            j.Wave1_Approver_5__c = j.Legal_Assignee__c;
        }
    }
    ITPR_List.add(j);   
    }
    if(!ITPR_List.isempty()){ 
        update ITPR_List; 
    } 
}