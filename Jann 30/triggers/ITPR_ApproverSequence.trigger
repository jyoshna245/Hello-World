/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Trigger          : ITPR_ApproverSequence
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 
 *  Assumptions      : N/A 
 *  Description      : This trigger performs the following actions:
                       1. For each Wave, re-arranges the selected approvers in such a way that there are no populated approver fields
                          in between two populated approver lookups.
                          E.g. if the user populates Wave1_Approver_1__c and Wave1_Approver_4__c fields, this trigger will move the
                          user selected in Wave1_Approver_4__c to Wave1_Approver_2__c
                       2. Check if the record is 'In Approvals', then only System/Business Adminitrator or a user whose approval is pending
                          should be able to edit the record (Since there are multiple approval processes defined for the object, 
                          once the Wave 1 approvers approve the record, it becomes unlocked and is editable by the Wave 1 approvers.
                          This check prevents that).
                       3. Validates that the same user should not be selected as an approver in more than one fields (including all waves).
                       4. Validates that all selected approvers must belong to a dept corresponding to the 'ITPR' application.                                 
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
 
trigger ITPR_ApproverSequence on ITPR__c (before insert, before update) {
    /*~~~~Start of Initialization~~~~*/
    Map<Id, Boolean> mapUniqueApprovers = new Map<Id, Boolean>();
    String userDeptName = null;
    String userProfileName = null;
    List<Id> lstPopulatedW1= new List<Id>();
    String w1prefix = 'wave1_approver_';
    
    List<Id> lstPopulatedW2= new List<Id>();
    String w2prefix = 'wave2_approver_';
    
    List<Id> lstPopulatedW3= new List<Id>();
    String w3prefix = 'wave3_approver_';
    
    String suffix = '__c';
    /*~~~~End of Initialization~~~~*/
    
    //Get Current User's Dept Name new dept changes
    User currentUser = [Select Id, ITPR_Department__c,Profile.Name From User where Id = :UserInfo.getUserId()];
    userDeptName = currentUser.ITPR_Department__c;
    userProfileName = currentUser.Profile.Name;   
    for(ITPR__c itpr : trigger.new){
        mapUniqueApprovers.clear();
        lstPopulatedW1.clear();
        lstPopulatedW2.clear();
        lstPopulatedW3.clear();
        
        /***** Start of Duplicate Approver Check *****/
        
        /* Keep populating the mapUniqueApprovers map to keep track of all approvers selected.
           For each approver selected on the record, check if it already exists in the map.
           If exists, then add error to that record otherwise add the approver id to the map. */
           
        //Check If duplicate approver exists in Wave 1 Approvers
        for(Integer i = 0; i < 5; i++){
            String fieldName = w1prefix + (i + 1) + suffix;
            Id approver = (Id) itpr.get(fieldName);
            if(approver != null){
                Boolean exists = mapUniqueApprovers.get(approver);
                if(exists == null || exists == false){
                    mapUniqueApprovers.put(approver, true);
                }else{
                    itpr.addError('Same approver cannot be assigned more than once.');
                }
            }
        }   
        
        //Check If duplicate approver exists in Wave 2 Approvers
        for(Integer i = 0; i < 5; i++){
            String fieldName = w2prefix + (i + 1) + suffix;
            Id approver = (Id) itpr.get(fieldName);
            if(approver != null){
                Boolean exists = mapUniqueApprovers.get(approver);
                if(exists == null || exists == false){
                    mapUniqueApprovers.put(approver, true);
                }else{
                    itpr.addError('Same approver cannot be assigned more than once.');
                }
            }
        }        
        
        //Check If duplicate approver exists in Wave 3 Approvers
        for(Integer i = 0; i < 5; i++){
            String fieldName = w3prefix + (i + 1) + suffix;
            Id approver = (Id) itpr.get(fieldName);
            if(approver != null){
                Boolean exists = mapUniqueApprovers.get(approver);
                if(exists == null || exists == false){
                    mapUniqueApprovers.put(approver, true);
                }else{
                    itpr.addError('Same approver cannot be assigned more than once.');
                }
            }
        }
        
        /***** End of Duplicate Approver Check *****/        
        
        /***** Start of Approver Sequence Correction *****/
        
        /* A different list is maintained for each wave. For each wave,
           add the selected users' Ids to the list. After that, erase all selected approvers
           from the record and copy the approvers back from the list. This removes blank fields,
           if any, in between selected approvers. */
        
        //Copy approvers for Wave 1 fields   
        if (itpr.wave1_approver_1__c != null) lstPopulatedW1.add(itpr.wave1_approver_1__c);
        if (itpr.wave1_approver_2__c != null) lstPopulatedW1.add(itpr.wave1_approver_2__c);
        if (itpr.wave1_approver_3__c != null) lstPopulatedW1.add(itpr.wave1_approver_3__c);
        if (itpr.wave1_approver_4__c != null) lstPopulatedW1.add(itpr.wave1_approver_4__c);
        if (itpr.wave1_approver_5__c != null) lstPopulatedW1.add(itpr.wave1_approver_5__c);

        //Copy approvers for Wave 2 fields   
        if (itpr.wave2_approver_1__c != null) lstPopulatedW2.add(itpr.wave2_approver_1__c);
        if (itpr.wave2_approver_2__c != null) lstPopulatedW2.add(itpr.wave2_approver_2__c);
        if (itpr.wave2_approver_3__c != null) lstPopulatedW2.add(itpr.wave2_approver_3__c);
        if (itpr.wave2_approver_4__c != null) lstPopulatedW2.add(itpr.wave2_approver_4__c);
        if (itpr.wave2_approver_5__c != null) lstPopulatedW2.add(itpr.wave2_approver_5__c);
        
        //Copy approvers for Wave 3 fields   
        if (itpr.wave3_approver_1__c != null) lstPopulatedW3.add(itpr.wave3_approver_1__c);
        if (itpr.wave3_approver_2__c != null) lstPopulatedW3.add(itpr.wave3_approver_2__c);
        if (itpr.wave3_approver_3__c != null) lstPopulatedW3.add(itpr.wave3_approver_3__c);
        if (itpr.wave3_approver_4__c != null) lstPopulatedW3.add(itpr.wave3_approver_4__c);
        if (itpr.wave3_approver_5__c != null) lstPopulatedW3.add(itpr.wave3_approver_5__c);
        
        //Erase all approvers
        itpr.wave1_approver_1__c = null;
        itpr.wave1_approver_2__c = null;
        itpr.wave1_approver_3__c = null;
        itpr.wave1_approver_4__c = null;
        itpr.wave1_approver_5__c = null; 
        
        itpr.wave2_approver_1__c = null;
        itpr.wave2_approver_2__c = null;
        itpr.wave2_approver_3__c = null;
        itpr.wave2_approver_4__c = null;
        itpr.wave2_approver_5__c = null;
         
        itpr.wave3_approver_1__c = null;
        itpr.wave3_approver_2__c = null;
        itpr.wave3_approver_3__c = null;
        itpr.wave3_approver_4__c = null;
        itpr.wave3_approver_5__c = null; 
        
        //Copy approvers back for Wave 1 fields
        for(Integer i = 0; i < lstPopulatedW1.size(); i++){
            Id approver = lstPopulatedW1.get(i);
            
            String fieldName = w1prefix + (i + 1) + suffix;
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>> fieldName: ' + fieldName);
            
            itpr.put(fieldName, lstPopulatedW1[i]);
        }
        
        //Copy approvers back for Wave 2 fields
        for(Integer i = 0; i < lstPopulatedW2.size(); i++){
            Id approver = lstPopulatedW2.get(i);
            
            String fieldName = w2prefix + (i + 1) + suffix;
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>> fieldName: ' + fieldName);
            
            itpr.put(fieldName, lstPopulatedW2[i]);
        }
        
        //Copy approvers back for Wave 3 fields
        for(Integer i = 0; i < lstPopulatedW3.size(); i++){
            Id approver = lstPopulatedW3.get(i);
            
            String fieldName = w3prefix + (i + 1) + suffix;
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>> fieldName: ' + fieldName);
            
            itpr.put(fieldName, lstPopulatedW3[i]);
        }        
    }
    
    /***** End of Approver Sequence Correction *****/
    
    /***** Start of Approver dept Check and 'In Approvals' Access Check *****/
    
    //Get dept name of each approver in a map
    Map<Id, User> mapUserIdVsDept = new Map<Id, User>();
    for(User u : [Select Id, Name, ITPR_Department__c From User where Id IN :mapUniqueApprovers.keySet()]){
        mapUserIdVsDept.put(u.id, u);
    }
  
    //Also get a list of Approvers who's approval is pending for this record.
    Map<Id, List<ProcessInstanceHistory>> mapIdVsProcessHist = new Map<Id, List<ProcessInstanceHistory>>();
    for(ITPR__c itpr : trigger.new){
        if(itpr.status__c == System.Label.ITPR_In_Approvals_Status){
            for(ProcessInstance pi : [SELECT Id, TargetObjectId, (SELECT ActorId, OriginalActorId, stepstatus FROM StepsAndWorkitems where stepstatus = 'Pending')
                                        FROM ProcessInstance where TargetObjectId IN :trigger.newMap.keySet()]){
                if(pi.StepsAndWorkitems != null && pi.StepsAndWorkitems.size() > 0){
                    mapIdVsProcessHist.put(pi.TargetObjectId, pi.StepsAndWorkitems);
                }
            }
        }
    }
        
    //Get the id of each approver. Then get the dept Name from the mapUserIdVsDept map.
    //If the dept does not belong to ITPR application, then add an error.
    for(ITPR__c itpr : trigger.new){
        //Check Wave 1 Approvers
        for(Integer i = 0; i < 5; i++){
            String fieldName = w1prefix + (i + 1) + suffix;
            Id approver = (Id) itpr.get(fieldName);
            if(approver != null){
                User approverUser = mapUserIdVsDept.get(approver);
                if(approverUser != null && approverUser.ITPR_Department__c != null && !approverUser.ITPR_Department__c.contains('ITSES')){
                    itpr.addError('Only ITSES users can be added as an approver: ' + approverUser.Name);
                }
            }
        }
        //Check Wave 2 Approvers
        for(Integer i = 0; i < 5; i++){
            String fieldName = w2prefix + (i + 1) + suffix;
            Id approver = (Id) itpr.get(fieldName);
            if(approver != null){
                User approverUser = mapUserIdVsDept.get(approver);
                if(approverUser != null && approverUser.ITPR_Department__c != null && !approverUser.ITPR_Department__c.contains('ITSES')){
                    itpr.addError('Only ITSES users can be added as an approver: ' + approverUser.Name);
                }
            }
        }
        //Check Wave 3 Approvers
        for(Integer i = 0; i < 5; i++){
            String fieldName = w3prefix + (i + 1) + suffix;
            Id approver = (Id) itpr.get(fieldName);
            if(approver != null){
                User approverUser = mapUserIdVsDept.get(approver);
                if(approverUser != null && approverUser.ITPR_Department__c != null && !approverUser.ITPR_Department__c.contains('ITSES')){
                    itpr.addError('Only ITSES users can be added as an approver: ' + approverUser.Name);
                }
            }
        }
        
        system.debug('userDeptName: ' + userDeptName + ' -- status: ' + itpr.status__c);

        //Check if the current record is In Approvals and if the current updating user has not yet approved the record
        //Do not allow update if no Pending approval action is remaining from the current user.
        if(userDeptName!= null && userProfileName!= '' && !userProfileName.contains('Administrator') && itpr.status__c == System.Label.ITPR_In_Approvals_Status){
            Boolean isPending = false;
            List<ProcessInstanceHistory> lstApprovalHistory = mapIdVsProcessHist.get(itpr.Id);
            if(lstApprovalHistory != null){
                for(ProcessInstanceHistory pih : lstApprovalHistory){
                 if(pih.OriginalActorId == UserInfo.getUserId() || pih.ActorId == UserInfo.getUserId()){
                        isPending = true;
                        break;
                    }
                }
                if(!isPending){
                    itpr.addError('Editing the record is not allowed after it has been approved.');
                }
            }
        }
    }
    
    /***** End of Approver dept Check and 'In Approvals' Access Check *****/
}