// 
// (c) 2014 Appirio, Inc.
// 
// CaseTriggerHnadler
// Handler class for Case trigger
// T-295612
//
// 14 July 2014     Ashish Goyal(JDC)       Original
//
public class CaseTriggerHnadler {
    
    /*
    * Method Name: beforeInsertUpdate
    * Description: Updating the E&C Manager and Lead Investigator
    * Passing param: List of Case
    * Return Type: void
    */
    
    public CaseTriggerHnadler() {


    }


    public void beforeInsert(List<Case> newCaseList){
                                        
        Map<Id, Case> userIdCaseObjMap = new Map<Id, Case>();
        
        // Checking whether Owner of case start with '00G' or not and preparing a map of OwnerId and Case
        for(Case c : newCaseList) {
            if(String.valueOf(c.OwnerId).startsWith('005')) {
                userIdCaseObjMap.put(c.OwnerId, c);
            }
        }
        
        // If map size is greater than 0, then process
        if(userIdCaseObjMap.size() > 0){
            
            // retrieving list of User who's id is listed in Map and Updating the Case E&C Manager and Lead Investigator
            for(User caseOwner : [Select Id,FirstName,LastName,UserRole.Name FROM User WHERE Id IN : userIdCaseObjMap.keyset()]){
                system.debug('-----------------------------'+caseOwner.UserRole.Name);
                if(caseOwner.UserRole.Name == 'Ethics & Compliance Manager') {
                    userIdCaseObjMap.get(caseOwner.Id).E_C_Manager__c = caseOwner.Id;    
                }
            }
        }
    } 

    public void beforeUpdate(List<Case> newCaseList, Map<Id, Case> oldCaseMap){
                                        
        Map<Id, Case> userIdCaseObjMap = new Map<Id, Case>();
        Map<Id, Case> addErrorCaseMap = new Map<Id, Case>();
        
        // Checking whether Owner of case start with '00G' or not and preparing a map of OwnerId and Case
        for(Case c : newCaseList) {
            if(String.valueOf(c.OwnerId).startsWith('005')) {
                userIdCaseObjMap.put(c.OwnerId, c);
            }
            //System.debug(c.IsClosed);
            //System.debug(!oldCaseMap.get(c.Id).IsClosed);
            //System.debug((c.Type == 'Centrally Managed' || (c.Type == 'Locally Managed' && c.Code_Violation_Picklist__c == 'Yes')));
            //User currentUser = [SELECT Id,Alias FROM User WHERE id = :UserInfo.getUserId()];
            //Boolean isS2S = UserInfo.getUserName().equalsIgnoreCase('Connection User');
            //System.debug(isS2S);
            //System.debug(currentUser);
            if(c.Status == 'Closed' && !oldCaseMap.get(c.Id).IsClosed && (c.Type == 'Centrally Managed' || (c.Type == 'Locally Managed' && c.Code_Violation_Picklist__c == 'Yes'))){
                
                //addErrorCaseMap.put(c.Id, oldCaseMap.get(c.Id));
                addErrorCaseMap.put(c.Id, c);

            }
        }
        /*
        //System.debug(userIdCaseObjMap);
        // If map size is greater than 0, then process
        if(userIdCaseObjMap.size() > 0){
            
            // retrieving list of User who's id is listed in Map and Updating the Case E&C Manager and Lead Investigator
            for(User caseOwner : [Select Id,FirstName,LastName,UserRole.Name FROM User WHERE Id IN : userIdCaseObjMap.keyset()]){
                system.debug('-----------------------------'+caseOwner.UserRole.Name);
                if(caseOwner.UserRole.Name == 'Ethics & Compliance Manager') {
                    userIdCaseObjMap.get(caseOwner.Id).E_C_Manager__c = caseOwner.Id;    
                }
                else if(caseOwner.UserRole.Name == 'Ethics & Compliance User') {
                    userIdCaseObjMap.get(caseOwner.Id).Lead_Investigator__c = (!String.isBlank(caseOwner.FirstName) ? caseOwner.FirstName + ' ':'') + caseOwner.LastName;
                }
            }
        }
        */
        if(addErrorCaseMap.size() > 0){
            System.debug('add error');
            addErrorOnCase(addErrorCaseMap);
        }
    } 
    
public void beforeUpdate2(List<Case> newCaseList, Map<Id, Case> oldCaseMap){
                                        
        Map<Id, Case> userIdCaseObjMap = new Map<Id, Case>();
        Map<Id, Case> addErrorCaseMap = new Map<Id, Case>();
        Map<id,case> newCaseMap = new Map<Id,Case>();
        // Checking whether Owner of case start with '00G' or not and preparing a map of OwnerId and Case
        Set<Id> userIds = new Set<Id>();
        for(Case c : newCaseList) {
            newCaseMap.put(c.Id,c);
            if(String.valueOf(c.OwnerId).startsWith('005')) {
                userIdCaseObjMap.put(c.OwnerId, c);
                userIds.add(c.OwnerId);
            }
            //System.debug(c.IsClosed);
            //System.debug(!oldCaseMap.get(c.Id).IsClosed);
            //System.debug((c.Type == 'Centrally Managed' || (c.Type == 'Locally Managed' && c.Code_Violation_Picklist__c == 'Yes')));
            //User currentUser = [SELECT Id,Alias FROM User WHERE id = :UserInfo.getUserId()];
            //Boolean isS2S = UserInfo.getUserName().equalsIgnoreCase('Connection User');
            //System.debug(isS2S);
            //System.debug(currentUser);
            //if(c.Status == 'Closed' && !oldCaseMap.get(c.Id).IsClosed && (c.Type == 'Centrally Managed' || (c.Type == 'Locally Managed' && c.Code_Violation_Picklist__c == 'Yes'))){
                
                //addErrorCaseMap.put(c.Id, oldCaseMap.get(c.Id));
                //addErrorCaseMap.put(c.Id, c);

            
        }
        Map<Id,User> userMap = new Map<Id,User>([Select Id,FirstName,LastName,UserRole.Name FROM User WHERE Id IN :userIds]);
        for(Case c : newCaseList) {
            boolean changedOwner = c.OwnerId != oldCaseMap.get(c.Id).OwnerId;
            boolean changedECManager = c.E_C_Manager__c != oldCaseMap.get(c.Id).E_C_Manager__c;
            if(userMap.containsKey(c.OwnerId)) {
                User caseOwner = userMap.get(c.OwnerId);   
                if(caseOwner.UserRole.Name == 'Ethics & Compliance Manager' && !changedECManager && changedOwner) {
                    userIdCaseObjMap.get(caseOwner.Id).E_C_Manager__c = caseOwner.Id;    
                }
                else if(caseOwner.UserRole.Name == 'Ethics & Compliance User' && changedOwner) {
                    userIdCaseObjMap.get(caseOwner.Id).Lead_Investigator__c = (!String.isBlank(caseOwner.FirstName) ? caseOwner.FirstName + ' ':'') + caseOwner.LastName;
                }                 
            }
            
        }
        //System.debug(userIdCaseObjMap);
        // If map size is greater than 0, then process
        /*
        if(userIdCaseObjMap.size() > 0){
            
            // retrieving list of User who's id is listed in Map and Updating the Case E&C Manager and Lead Investigator
            for(User caseOwner : [Select Id,FirstName,LastName,UserRole.Name FROM User WHERE Id IN : userIdCaseObjMap.keyset()]){
                
                system.debug('-----------------------------'+caseOwner.UserRole.Name);
                if(caseOwner.UserRole.Name == 'Ethics & Compliance Manager' &&) {
                    userIdCaseObjMap.get(caseOwner.Id).E_C_Manager__c = caseOwner.Id;    
                }
                else if(caseOwner.UserRole.Name == 'Ethics & Compliance User' &&) {
                    userIdCaseObjMap.get(caseOwner.Id).Lead_Investigator__c = (!String.isBlank(caseOwner.FirstName) ? caseOwner.FirstName + ' ':'') + caseOwner.LastName;
                }
            }
        }*/
        
        
    }     
    /*
    * @method Name: afterInsert
    * @description: Creating contact and case contact role for inserted Case Record
    * @param: List of Case
    * @return: void
    * Task: T-306967
    */
    public void afterInsert(List<Case> newCaseList) {
        string DEFAULT_ACCOUNT_ID = [SELECT Id FROM Account WHERE Name = 'N/A' LIMIT 1].Id;
        // variables
        Map<Id, Contact> newAffectedContacts = new Map<Id, Contact>();
        Map<Id, Contact> newContectingContacts = new Map<Id, Contact>();
        List<Contact> newContacts = new List<Contact>();        
    
        // Creating contact for the inserted new case record
        for(Case c : newCaseList) {            
            if(!String.isBlank(c.Affected_Employee_Last_Name__c) && !String.isBlank(c.Contacting_Employee_Last_Name__c)) {
                system.debug('==========case contact role======================================');
                Contact affected = new Contact();
                Contact contacting = new Contact();
                
                affected.FirstName = c.Affected_Employee_First_Name__c;
                affected.LastName = c.Affected_Employee_Last_Name__c;
                affected.Title = c.Affected_Employee_Job_Title__c;
                affected.DOH__c  = c.Affected_Employee_Hire_Date__c;
                affected.AccountId = DEFAULT_ACCOUNT_ID;
                newAffectedContacts.put(c.Id, affected);         
                
                contacting.FirstName = c.Contacting_Employee_First_Name__c;
                contacting.LastName = c.Contacting_Employee_Last_Name__c;
                contacting.AccountId = DEFAULT_ACCOUNT_ID;
                newContectingContacts.put(c.Id, contacting);                
            }
        }
        
        // Inserting the reocrds
        if(newAffectedContacts.size() > 0){
            newContacts.addAll(newAffectedContacts.values());
            newContacts.addAll(newContectingContacts.values());
            try{
                insert newContacts;
                system.debug('==========case contact role===================record inserted===================');
            } catch(Exception e){
                system.debug('=============exception is===='+e);
            }
            
            // Calling method to create Case Contact Role
            createCaseContactRole(newAffectedContacts, newContectingContacts);
        }
        
        
        List<Id> caseIds = new List<Id>{};

        for (Case theCase:newCaseList) caseIds.add(theCase.Id);
        

        String managerRoleId = [SELECT Id FROM UserRole WHERE Name = 'Ethics & Compliance Manager' LIMIT 1][0].Id;
        System.debug(managerRoleId);
        System.debug(UserInfo.getUserRoleId());
        List<Case> casesToAssign = new List<Case>{}; 
        for(Case c : [Select Id,OwnerId,E_C_Manager__c,RecordType.Name,Status from Case where Id in :caseIds])
        {
            if((String.isBlank(c.E_C_Manager__c) || c.E_C_Manager__c != c.OwnerId) && c.RecordType.Name != 'Other' && c.Status != 'Closed' && UserInfo.getUserRoleId() != managerRoleId ) {
                Database.DMLOptions dmo = new Database.DMLOptions();
     
                dmo.assignmentRuleHeader.useDefaultRule = true;
                c.setOptions(dmo);
                
                casesToAssign.add(c);
            }
        }

        if(casesToAssign.size() > 0) Database.upsert(casesToAssign);

    }
    
    
    /*
    * Method Name: afterUpdate
    * Description: Updating the Case Short Description of Investigation Activity Record
    * Passing param: List of Case, Map of Case and case Id
    * Return Type: void
    * Task: T-301209
    */
    public void afterUpdate(List<Case> newCaseList, Map<Id, Case> oldMap){
        
        Map<Id, Case> caseIdCaseObjMap = new Map<Id, Case>();
        List<Investigation_Activity__c> listToBeUpdate = new List<Investigation_Activity__c>();
        
        // Checking whether Case Short description of case is changed or not
        for(Case c : newCaseList) {
            if(c.Case_Short_Description__c != oldMap.get(c.Id).Case_Short_Description__c){
                caseIdCaseObjMap.put(c.Id, c);
            }
        }
        
        // Updating the case short description of Invetigation Activity record
        for(Investigation_Activity__c investActObj : [SELECT Id, Case__c, Case_Short_Description__c 
                                                        from Investigation_Activity__c 
                                                        Where Case__c IN :caseIdCaseObjMap.keySet()])
        {
            if(caseIdCaseObjMap.containsKey(investActObj.Case__c)){
                investActObj.Case_Short_Description__c = caseIdCaseObjMap.get(investActObj.Case__c).Case_Short_Description__c;
                listToBeUpdate.add(investActObj);
            }
        }
        
        // Updating the record
        if(listToBeUpdate.size() > 0){
            Database.upsert(listToBeUpdate);
        }
        
        //System.debug(this.hasRunAssignment);
        if(StateUtility.runOnce()) {
            
            List<Id> caseIds = new List<Id>{};

            for (Case theCase:newCaseList) caseIds.add(theCase.Id);
            
            List<Case> casesToAssign = new List<Case>{}; 
            for(Case c : [Select Id,OwnerId,Status,Business_Unit_Bottling_Company__c,CCR_Approval_Status__c from Case where Id in :caseIds])
            {
                boolean assignCase = (c.CCR_Approval_Status__c != 'Rejected' && c.CCR_Approval_Status__c != 'Approved' && oldMap.get(c.Id).OwnerId == c.OwnerId);
                if(assignCase) {
                    Database.DMLOptions dmo = new Database.DMLOptions();
         
                    dmo.assignmentRuleHeader.useDefaultRule = true;
                    c.setOptions(dmo);
                    
                    casesToAssign.add(c);
                }
            }

            Database.upsert(casesToAssign);
             
        }           
    }
    
    
    /*
    * @method Name: createCaseContactRole
    * @description: Creating case contact role for inserted Case Record
    * @param: Map of Case Id and Conatct, Map of Case Id and Conatct
    * @return: void
    * Task: T-306967
    */
    
    //Updated 9/11/14 to use Individual__c instead of CaseContactRole by Erik Golden
    private static void createCaseContactRole(Map<Id, Contact> newAffectedContacts, Map<Id, Contact> newContectingContacts){
        
        List<Individual__c> newIndividuals = new List<Individual__c>();
        //system.debug('==========case contact role======================================');
        // Initialising the case contact role record with the data 
        for(Id caseId : newAffectedContacts.keySet()){
            Individual__c affectedRole = new Individual__c(Contact__c = newAffectedContacts.get(caseId).Id,Individual_Type__c = 'Subject of Investigation',Case__c = caseId);
            Individual__c contactingRole = new Individual__c(Contact__c = newContectingContacts.get(caseId).Id, Individual_Type__c = 'Claimant',Case__c = caseId);
            newIndividuals.add(affectedRole);
            newIndividuals.add(contactingRole);
        }   
        
        // Inserting the record
        try {
            insert newIndividuals;
            system.debug('==========case contact role=============================record inserted=========');
        }catch(Exception ex){
            system.debug('====================exception is======='+ex);
        }
    }
    
    
    /*
    * @method Name: addErrorOnCase
    * @description: Creating case contact role for inserted Case Record
    * @param: Map of Case Id and Conatct, Map of Case Id and Conatct
    * @return: void
    * Task: T-307873
    */
    private static void addErrorOnCase(Map<Id, Case> newIdOldCaseObjMap){
        
        String individualRT = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND Name = 'Individual Investigation' LIMIT 1].Id;
        Map<Id, Investigation_Activity__c> caseIdInvestObjMap = new Map<Id, Investigation_Activity__c>(); 
        // Invetigation Activity record
        for(Investigation_Activity__c investActObj : [SELECT Id, Case__c from Investigation_Activity__c 
                                                        Where Case__c IN :newIdOldCaseObjMap.keySet() AND RecordType.Name = 'Approval Reporting'])
        {
            if(!caseIdInvestObjMap.containsKey(investActObj.Case__c)){
                caseIdInvestObjMap.put(investActObj.Case__c, investActObj);
            }
        }        
        
        for(Case caseObj : newIdOldCaseObjMap.values()){
            if(!caseIdInvestObjMap.containsKey(caseObj.Id) && caseObj.RecordTypeId != individualRT){
                caseObj.addError(System.Label.Case_Article_Record_Type_Error);
            }
        }
        
        
            
        
    }

}