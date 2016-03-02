/*
    Author              : Accenture
    Date Created        : 6/11/2012
    Description         : This class will be called from the visualforce page <RFA_VFP03_ApprovalRouting>. This class contains logic to order approvers
                          and submit them for the approval process  
    Version             : 2.0 
*/ 

public class RFA_VFC02_ApprovalRoutingController{
    
    // variable for holding the approval process detail in context
    public ApprovalProcess__c processInstance{get;set;}
    // variable for holding the RFA Object related to the Approval process.
    public RFA__c rfaObj{get;private set;}
    // List variable for holding the list of ApprovalSequence
    public List<AppproverSequence> sequenceList{get;set;}
    // static variable for holding the default approval status
    private static final String DEFAULT_STATUS_APPROVAL = 'Not Started';
    
    private static final String INPROGRESS_STATUS_APPROVAL = 'In Progress';
    // boolean variable to designate active approval process
    public boolean activeAppProcess{get;private set;}
    // boolean variable to flag errors./Being used for stoping JS parent script call in case of rollback.
    public boolean hasError{get; private set;}
    // list variable for storing all the notification users which are required to be flagged for email communoication
    private List<RFAUserRole__c> notificationUsers = new List<RFAUserRole__c>();
    // list of Info Only Copy User.
    private List<RFAUserRole__c> levelInfoCopyUsers = new List<RFAUserRole__c>();
    // Set containing level value for current and below.
    private rfa_AP02_Shareutil shareUtil = new rfa_AP02_Shareutil();
    
    // constructor for the class.    
    public RFA_VFC02_ApprovalRoutingController(ApexPages.StandardController controller) {
        // get RFA Obj     
        rfaObj = (RFA__c)controller.getRecord(); 
        
        // get the process instance for the level if it has already been submitted for recommendations.
        ApprovalProcess__c[] processes = RFA_AP03_ApprovalProcessHelper.getProcessInstance(rfaObj);
        
        // if processInstance is not available for the current RFA level, create a new instance
        if(processes.isEmpty())
        {
             
            processInstance = new ApprovalProcess__c();
            processInstance.ApprovalProcessLevel__c = rfaObj.Level__c;
            processInstance.Status__c = DEFAULT_STATUS_APPROVAL;    
            activeAppProcess = false;
        
            
        }
        else
        {
            // create a new instance of approval process.
            processInstance = processes[0];
            activeAppProcess = (processes[0].Status__c == INPROGRESS_STATUS_APPROVAL)? true : false;
            
        }
        
        sequenceList = new List<AppproverSequence>(); 
        
        Set<String> levelSet = new Set<String>();
        levelSet = getLevelSet(levelSet);
        // get Info Only Copy users from the user role table related to the rfa
        getInfoOnlyUsers();
        // get co- creator users from the user role table related to the rfa
        getCoCreatorUsers();
        // Get primary POC users from the user role table related to the rfa
        getPrimaryPOCUsers();
        // get existing approvers from the user role table related to the rfa
        sequenceApprover(levelSet);
                
    }
    
    public Set<String> getLevelSet(Set<String> levelSet)
    {   
        Integer currentLevel = RFAGlobalConstants.LEVEL_ORDER_MAP.get(rfaObj.Level__c);
        for(Integer levelNumber = 1; levelNumber <= currentLevel; levelNumber ++)
        {
            levelSet.add(RFAGlobalConstants.ORDERED_LEVEL_MAP.get(levelNumber));    
        }
        return levelSet;
    }
    
    /* @Method <This method queries the RFAUserRole table for info only users and adds them to the list infoCopyUsers >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */
    public void getInfoOnlyUsers()
    {
        notificationUsers.clear();
        notificationUsers.addAll(RFA_AP03_ApprovalProcessHelper.getInfoCopyUsers(rfaObj));
        levelInfoCopyUsers.addAll(notificationUsers);    
    }
    
    /* @Method <This method queries the RFAUserRole table for co-creator users and adds them to the list infoCopyUsers >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */
    public void getCoCreatorUsers()
    {
        notificationUsers.addAll(RFA_AP03_ApprovalProcessHelper.getCoCreator(rfaObj));
    }
    
    /* @Method <This method queries the RFAUserRole table for primary POC users and adds them to the list infoCopyUsers >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */
    public void getPrimaryPOCUsers()
    {
        notificationUsers.addAll(RFA_AP03_ApprovalProcessHelper.getPrimaryPointOfContact(rfaObj));
    }
    
    /* @Method <This method queries the RFAUserRole table and gets the associated approvers for that RFA Level >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */
    public void sequenceApprover(Set<String> levelSet)
    {
        sequenceList.clear();          
        for(RFAUserRole__c app : getApprovers(levelSet))
        {
              sequenceList.add(new AppproverSequence(app.ApprovalOrder__c, app, app.Level__c));
                             
        }      
     
    }
    
    /*
        Class Type     : Inner Class (AppproverSequence)
        Date Created   : 6/11/2012
        Description    : This is our wrapper/container Inner class to display the Approvers (RFAUserRole__c) with approval order.
        Version        : 1.0 
    */   
    public class AppproverSequence
    {
        public Integer sequence{get;set;}
        public String strSequence{get;set;}
        public RFAUserRole__c approver{get;set;}
        public String level{get;set;}
        
        // constructor for the inner class.
        public AppproverSequence(Decimal order, RFAUserRole__c approver, String level)
        {
                this.sequence = Integer.valueOf(order);
                this.approver = approver;
                this.level = level;
                this.strSequence =String.valueOf(sequence);
        }
    }
    
    /* @Method <This method queries the RFAUserRole table and gets the associated approvers for that RFA Level >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */   
    public List<RFAUserRole__c> getApprovers(Set<String> levelSet)
    
    {
        //return [Select UserName__r.Name, Level__c, ApprovalOrder__c FROM RFAUserRole__c Where Level__c =: processInstance.ApprovalProcessLevel__c AND RecordType.Name = :'Approver' AND RFA__c = :  rfaObj.Id ORDER BY CreatedDate];
        return RFA_AP03_ApprovalProcessHelper.getApprovers(rfaObj, levelSet);
    }
    
    // variable for storing the approver list size.
    public Integer approverSize{
        get{
             return sequenceList.size();
        }
        private set;
    }

    
    /* @Method <This method submits the approval process for approval >
       @param <None>
       @return <PageReference>
    */
    public void submitForApproval()
    {
        this.hasError = false;
        System.debug('\n user inouted sequence list :'+sequenceList);
        //--- added mpascua@coca-cola.com Nov-6-2013
           for(AppproverSequence s : sequenceList){
               try{
                   Long tempLong = Long.valueOf(s.strSequence);
                   Long quotient = Math.Mod(tempLong , 1);
                   if(quotient > 0){
                      this.hasError = true;
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid value for Approver Order. Must not include alphabets or decimals.'));  
                      return;
                    }else{
                      s.sequence = Integer.valueOf(tempLong);
                    }
               }catch (Exception e){
                      this.hasError = true;
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid value for Approver Order. Must not include alphabets or decimals.'));  
                      return;

               }

           }

       //----
        validateApprovalSequence(sequenceList);
        System.Savepoint sp = Database.setSavepoint(); 
        
       // RFA_AP03_ApprovalProcessHelper.ProcessResult result;      
        
        List<RFAUserRole__c> approverForUpdateList = new List<RFAUserRole__c>();  
        List<ApprovalProcess__c> processList = new List<ApprovalProcess__c>();
        Database.UpsertResult result;
        //reset error variable
        
        Integer initialOrder = 1;
        try{
            if(!ApexPages.hasMessages())
            {
                 
                if(processInstance.Status__c == INPROGRESS_STATUS_APPROVAL) throw new ApprovalRoutingException(RFAGlobalConstants.EXCEPTION_PROCESSHASBEEN_SUBMITTED);
                 
                if(!sequenceList.isEmpty())
                {
                    result = RFA_AP03_ApprovalProcessHelper.submitForApproval(processInstance, rfaObj); 
                }
                else if(sequenceList.isEmpty() && !levelInfoCopyUsers.isEmpty())
                {
                    System.debug('\n inside post circulation bl0ck');
                    result = RFA_AP03_ApprovalProcessHelper.submitForApproval(processInstance, rfaObj, true);
                } 
                System.debug('\n result object returned :'+result); 
                //if(!result[0].isSuccess()) throw new ApprovalRoutingException('Exception occured while saving the record.');
                
                 if(result!=null&&result.isSuccess())
                {
                    //updateRFAStage();
                    Id processId = result.getId();
                    //List<RFAUserRole__c> approverList = getApprovers();
                    System.debug('\n Sequence list' +sequenceList);
                    for(AppproverSequence appSequence : sequenceList)
                    {
                            
                        RFAUserRole__c approver = appSequence.approver;
                        approver.ApprovalOrder__c = appSequence.sequence;
                        approver.ApprovalProcess__c = processId;
                        approver.ApprovalRecommendation__c = (Integer.valueOf(approver.ApprovalOrder__c) == initialOrder ? 'Awaiting Approval' : ' ');
                        approver.ApprovalRequestedOn__c  = (Integer.valueOf(approver.ApprovalOrder__c) == initialOrder ? System.now() : null);
                        approverForUpdateList.add(approver);                    
                    }
                    
                    
                    if(!notificationUsers.isEmpty())RFA_AP03_ApprovalProcessHelper.notifyInfoCopyUsers(notificationUsers, true, processId);
                } 
                    else
                    {
                    throw new ApprovalRoutingException(result.getErrors()); 
                    }
                  }
                 
                
               // if(!approverForUpdateList.isEmpty()) RFA_Util_PerformDML.performUpdOperation(approverForUpdateList);
                  System.debug('\n approver list' +approverForUpdateList);  
                  if(!approverForUpdateList.isEmpty()) update approverForUpdateList;
                
            }
         catch(ApprovalRoutingException routingEx)
        {
            hasError = true;
            System.debug('\n Exception caught in routing Exception :'+routingEx.getErrorMessages());    
            Database.rollback(sp); 
            for(String errString : routingEx.getErrorMessages())
            {
                if(!errString.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errString));   
            }
        }
        catch(Exception ex)
        { 
           hasError = true;
           System.debug('\n Exception caught :'+ex.getMessage());        
           Database.rollback(sp); 
           if(!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))               
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));      
        }
    }
    
  
    /* @Method <This method validates all the approvers for proper data and sequence>
       @param <List> - List of ApproverSequence
       @return <None>
    */  
    public void validateApprovalSequence(List<AppproverSequence> approverSequence)
    {
        
        try{
            
            System.debug('\n Approver sequence size :'+approverSequence.size());
            System.debug('\n info copy users :'+levelInfoCopyUsers.size());
            Map<Integer, AppproverSequence> orderApproverMap = new Map<Integer, AppproverSequence>();

            rfaobj=[select ProfitCenterNumber__c,level__c from RFA__C where id=:rfaobj.id limit 1];
            List<ProfitCenterUserRole__c> profitCenterlevelList=[select id,Level__c from ProfitCenterUserRole__c where ProfitCenter__c=:rfaObj.ProfitCenterNumber__c];
            system.debug('list'+profitCenterlevelList);
            Boolean IsLevelInprofitcenter=false;

            if(profitCenterlevelList!=null&&profitCenterlevelList.size()>0)
            {
                for(ProfitCenterUserRole__c pc:profitCenterlevelList)
                {
                    if(pc.Level__c==rfaobj.level__c)
                    {
                        IsLevelInprofitcenter = true;
                        break;
                    }
                    
                }
            }
            if(approverSequence.isEmpty() && levelInfoCopyUsers.isEmpty() &&  IsLevelInprofitcenter == true) throw new ApprovalRoutingException(RFAGlobalConstants.EXCEPTION_NO_APPROVERS_REVIEWERS);
            
            if(!approverSequence.isEmpty())
            {
                for(AppproverSequence appSequence : approverSequence)
                {
                    System.debug('\n Approver sequence :'+appSequence.sequence);
                     orderApproverMap.put(appSequence.sequence, appSequence);
                          
                }
                
                    Integer order = 1;
                    
                    for(Integer oSequence : orderApproverMap.keySet())
                    {
                              if(oSequence != order) throw new ApprovalRoutingException(RFAGlobalConstants.EXCEPTION_LIST_ORDER);
                              order = order + 1;
                    }   
            }
                              
        }catch(Exception ex)
        {
               hasError = true;

               if(!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))               
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
                    
               //pageMessages = ApexPages.getMessages();        
         }
                  
    }
      
    public class ApprovalRoutingException extends Exception{
    
        List<String> exMessages = new List<String>();
        
        public ApprovalRoutingException(List<Database.Error> errorList)
        {
            for(Database.Error err : errorList)
            {
                exMessages.add(err.getMessage());   
            }
        }  
        
        public List<String> getErrorMessages()
        {
            return exMessages;
        }   
        
    }
      

}