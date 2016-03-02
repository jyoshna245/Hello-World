/****************************************************************************************************************************************
****************************************************************************************************************************************    
*  Class            : RFA_VFC03_OverrideController
*  Author           : Accenture
*  Version History  : 1.0
*  Creation         : 05/15/2012
*  Assumptions      : N/A
*  Description      : This class is called from the visualforce page RFA_VFP02_Override and contains logic to


****************************************************************************************************************************************
****************************************************************************************************************************************/

public class RFA_VFC03_OverrideController extends RFA_Util_SecurityMatrix {
    
    /*~~~~Start of Variable Initialization~~~~*/
    public RFA__c rfaObj{get;set;}
    
    public Id profitCenterId{get;set;}
    
    public String selectedStage{get;set;}
    
    public String selectedLevel{get;set;}
    
    private Boolean allowAccess=false;
    
    public boolean hasError{get;private set;}
    
    public String returnReason{get;set;}
    
    private String currentLevel;
    
    private String currentStage;
    
    private String lc; //Added by BSA for INC0346541 - 14-Feb-2013
    
    //added by mpsacua@coca-cola.com Aug 28,2013 for FR1.5 Q3
    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP = RFAGlobalConstants.RECORDTYPESMAP;
    public static Map<String, RecordType> rfaRecordTypeMap = RECORDTYPESMAP.get(Schema.sObjectType.RFA__c.getName());
    public Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap {get;set;}
    //public List<ProfitCenter__c> pcList {get;set;}
    /*~~~~End of Variable Initialization~~~~*/
    
    
    // constructor for the class.
    public RFA_VFC03_OverrideController(ApexPages.StandardController controller) 
    {
        super(controller);
        this.rfaObj=(RFA__c)controller.getRecord();
        List<RFA__c> rfaList = [SELECT Id, Name, Level__c, Stage__c, ProfitCenterNumber__c, ReturnReason__c, RecordTypeId FROM RFA__c WHERE Id =: this.rfaObj.Id LIMIT 1];
        if(rfaList.size() > 0){
            this.rfaObj = rfaList[0];
        }
        this.profitCenterMap = new Map<Id, List<ProfitCenterUserRole__c>>();
        //this.pcList = new List<ProfitCenter__c>();
        if(this.rfaObj.Id <> null)
        {
            this.currentLevel = rfaObj.Level__c;
            
            this.currentStage = rfaObj.Stage__c;
            
        }
    }
    
    public List<SelectOption> getStages()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption(RFAGlobalConstants.PRE_CIRCULATION,RFAGlobalConstants.PRE_CIRCULATION));
        options.add(new SelectOption(RFAGlobalConstants.POST_CIRCULATION,RFAGlobalConstants.POST_CIRCULATION));
        //options.add(new SelectOption(RFAGlobalConstants.RETURN_TO_SENDER,RFAGlobalConstants.RETURN_TO_SENDER));        
        return options;    
    }    
    
    public List<SelectOption> getLevel()
    {
        List<SelectOption> options = new List<SelectOption>();
        Set<String> uniqueLevel = new Set<String>();
        
        //added by mpsacua@coca-cola.com Aug 28,2013 for FR1.33 Level should be taken from Profit Center
        //moved Sept 6, 2013 mpascua@coca-cola.com
        this.profitCenterId = rfaObj.ProfitCenterNumber__c;  
        //this.pcList = [Select Id, name from ProfitCenter__c where Id =: profitCenterId LIMIT 1]; 
        List<ProfitCenterUserRole__c> pcauList = new List<ProfitCenterUserRole__c>();  
        pcauList = [Select id,UserName__c,Level__c,Usertype__c FROM ProfitCenterUserRole__c where UserType__c='Location Coordinator' AND ProfitCenter__c =: this.profitCenterId LIMIT 1000];
        this.profitCenterMap.put(this.profitCenterId, pcauList);            
        //-----------
        
        for(ProfitCenterUserRole__c tempMap: this.profitCenterMap.get(rfaObj.profitCenterNumber__c) )
        {
            if(tempMap.Level__c != null){
                if(uniqueLevel.isEmpty()){
                    uniqueLevel.add(tempMap.Level__c);    
                    options.add(new SelectOption(tempMap.Level__c, tempMap.Level__c));
                }else{
                    
                    if(!(uniqueLevel.contains(tempMap.Level__c))){
                        options.add(new SelectOption(tempMap.Level__c, tempMap.Level__c));
                        uniqueLevel.add(tempMap.Level__c);
                    }  
                }
            }  
        }
        
        options.add(new SelectOption('Return To Sender', 'Return To Sender'));
        options.add(new SelectOption('Capital Management Hold', 'Capital Management Hold'));
        if(rfaObj.RecordTypeId != rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id){
            options.add(new SelectOption('Pending Board Review', 'Pending Board Review'));
        }
        
        options.sort();        
        return options; 
    }
    
    
    
    public pageReference updateRFA()
    {
        System.savepoint sp = Database.setSavepoint();
        
        //FOR REQ 23.3 This is set to True for validation of the level whether RFA has to skip the level (If no location coordinator is present)
        RFAStaticVariables.doskiplevelProcess=true;
        
        try
        {
            //reset error variable
            hasError = false;
            User usr=[Select Profile.Name, id from User where id=:UserInfo.getUserId() Limit 1]; // User query to fetch profile Name for logged In user to bypass the custom validation
            String UserNameProfile=usr.Profile.Name;
            System.debug('\n Selected level :'+selectedLevel + RFAGlobalConstants.RETURN_TO_SENDER);
            System.debug('\n Selected Stage :'+selectedStage);
            System.debug('\n returned reason from db :'+rfaObj.ReturnReason__c);
            System.debug('\n returned reason from ui :'+returnReason);
            if(!selectedlevel.equalsIgnoreCase(RFAGlobalConstants.RETURN_TO_SENDER)
               && !selectedLevel.equalsIgnoreCase(RFAGlobalConstants.CAPITAL_MGMT_HOLD)
               && !selectedLevel.equalsIgnoreCase(RFAGlobalConstants.PENDING_BOARD_REVIEW)
               && (selectedStage == null || selectedStage.equalsIgnoreCase('--None--')))
            {
                rfaObj.addError('Please select a stage for overriding the RFA');
                hasError = true;
                return null;
            }
            //moved to constructor Sept 6, 2013 mpascua@coca-cola.com
            //this.profitCenterId = rfaObj.ProfitCenterNumber__c; 
            
            //Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap=new Map<Id, List<ProfitCenterUserRole__c>>();
            
            //for(ProfitCenter__c profitCenter: [Select Id, (Select id,UserName__c,Level__c,Usertype__c from Profit_Center_Associated_Users__r where UserType__c='Location Coordinator'),name from ProfitCenter__c where Id =: profitCenterId ])
            //{
            //   profitCenterMap.put(profitCenter.Id, profitCenter.Profit_Center_Associated_Users__r);        
            //}
            //-----------
            
            if((selectedLevel.equalsIgnoreCase(RFAGlobalConstants.PENDING_BOARD_REVIEW) ) && UserNameProfile!=Label.RFA_CL052 && UserNameProfile!=Label.RFA_CL053 && UserNameProfile!=Label.RFA_CL054 && UserNameProfile!=Label.Rfa_CL055)
            {
                rfaObj.addError(Label.RFA_CL102);
                hasError = true;
                return null;
            }
            if(!selectedlevel.equalsIgnoreCase(RFAGlobalConstants.RETURN_TO_SENDER)
               && !selectedLevel.equalsIgnoreCase(RFAGlobalConstants.PENDING_BOARD_REVIEW)&& ((UserNameProfile!=Label.RFA_CL053 &&  UserNameProfile!=Label.RFA_CL052 && UserNameProfile!=Label.RFA_CL054 && UserNameProfile!=Label.RFA_CL055)))// Bypass for System Admin profile
            { 
                validateOperation(this.profitCenterMap);
            }
            if(ApexPages.hasMessages()) 
            {
                hasError = true;
                return null;                                       
            }
            if(currentStage == RFAGlobalConstants.RFA_CIRCULATION_STAGE)
            {
                Map<Id, ApprovalProcess__c> approvalProcessMap = RFA_AP03_ApprovalProcessHelper.getActiveProcessInstances(new Set<String>{rfaObj.Id});
                
                if(!approvalProcessMap.isEmpty()) RFA_AP03_ApprovalProcessHelper.resetApprovalWorkItems(approvalProcessMap);
            }
            
            if(selectedLevel == RFAGlobalConstants.PENDING_BOARD_REVIEW || selectedLevel == RFAGlobalConstants.CAPITAL_MGMT_HOLD || selectedlevel == RFAGlobalConstants.RETURN_TO_SENDER)
            {
                rfaObj.Level__c = selectedLevel;    
                if(selectedlevel == RFAGlobalConstants.RETURN_TO_SENDER)
                {
                    //rfaObj.PreviousLevel__c = currentLevel;
                    rfaObj.ReturnReason__c = returnReason;    
                }
                rfaObj.Stage__c = '';
            }else{
                rfaObj.Stage__c = selectedStage;
                rfaObj.Level__c = selectedLevel;    
            }
            
            update rfaObj;
            
            
            //Database.Saveresult result = Database.update(rfaObj);
            
            
        }catch(Exception ex)
        {
            System.debug('\n Exception caught');
            hasError = true;
            if(!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))              
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
            Database.rollback(sp);
            
            return null;
            
        }
        return null;
        // new PageReference('/'+rfaObj.Id);
    }
    
    
    public void validateOperation(Map<Id, List<ProfitCenterUserRole__c>> pCenterMap)
    {
        
        //<Start> - Added by BSA for INC0346541 - 14-Feb-2013
        lc=null;
        ProfitCenter__c pc= [SELECT Id, Name, (Select id,UserName__c,Level__c,Usertype__c from Profit_Center_Associated_Users__r where UserType__c='Location Coordinator' AND Level__c=: selectedLevel AND UserName__c = :UserInfo.getUserId() Limit 1)
                             FROM ProfitCenter__c
                             WHERE Id=:profitCenterId];
        List<ProfitCenterUserRole__c> locCoordinator  = pc.Profit_Center_Associated_Users__r;
        
        if(locCoordinator.size()>0)
        {
            ProfitCenterUserRole__c lc = locCoordinator.get(0);
        }
        else
        {
            lc='';
        } 
        //<End> - Added by BSA for INC0346541 - 14-Feb-2013
        
        
        for(ProfitCenterUserRole__c tempMap: pCenterMap.get(rfaObj.profitCenterNumber__c) )
        {
            
            
            if(tempMap.UserName__C==UserInfo.getUserId())// UserInfo.getProfileId()!='00ed00000012gBs'  )
            {
                allowAccess=True;             
            }
            
            if(tempMap.UserName__C==UserInfo.getUserId() && tempMap.UserType__c!='Location Coordinator')// UserInfo.getProfileId()!='00ed00000012gBs'  )
            {
                hasError = true; 
                rfaObj.addError(Label.RFA_CL100);
                
            }   
            
            else if(tempMap.UserName__C==UserInfo.getUserId() && selectedLevel=='6. Senior Executive' && (tempMap.Level__c=='1. Key Operations' || tempMap.Level__c=='2. Business Unit' || tempMap.Level__c=='3. Group' || rfaObj.Level__c=='4. Corporate' || rfaObj.Level__c=='5. Executive' ) )// UserInfo.getProfileId()!='00ed00000012gBs'  )
            {
                if(lc <>'') //<Start> - Added this if condition by BSA for INC0346541 - 14-Feb-2013
                {
                    //continue allow override..
                } 
                else
                {
                    hasError = true;
                    rfaObj.addError(RFAGlobalConstants.EXCEPTION_HIGHER_LEVEL);
                }
            }  
            else if(tempMap.UserName__C==UserInfo.getUserId() && selectedLevel=='5. Executive' && (tempMap.Level__c=='1. Key Operations' || tempMap.Level__c=='2. Business Unit' || tempMap.Level__c=='3. Group' || tempMap.Level__c=='4. Corporate' ) )// UserInfo.getProfileId()!='00ed00000012gBs'  )
            {
                if(lc <>'') //<Start> - Added this if condition by BSA for INC0346541 - 14-Feb-2013
                {
                    //continue allow override..
                } 
                else
                {
                    hasError = true;
                    rfaObj.addError(RFAGlobalConstants.EXCEPTION_HIGHER_LEVEL);
                }
                
            } 
            
            else if(tempMap.UserName__C==UserInfo.getUserId() && selectedLevel=='4. Corporate' && ( tempMap.Level__c=='1. Key Operations' || tempMap.Level__c=='2. Business Unit' || tempMap.Level__c=='3. Group'))
            {
                
                if(lc <>'') //<Start> - Added this if condition by BSA for INC0346541 - 14-Feb-2013
                {
                    //continue allow override..
                } 
                else
                {
                    hasError = true;
                    rfaObj.addError(RFAGlobalConstants.EXCEPTION_HIGHER_LEVEL);
                }
                
            } 
            else if(tempMap.UserName__C==UserInfo.getUserId() && selectedLevel=='3. Group' && ( tempMap.Level__c=='1. Key Operations' || tempMap.Level__c=='2. Business Unit' ))
            {
                if(lc <>'') //<Start> - Added this if condition by BSA for INC0346541 - 14-Feb-2013
                {
                    //continue allow override..
                } 
                else
                {
                    hasError = true;
                    rfaObj.addError(RFAGlobalConstants.EXCEPTION_HIGHER_LEVEL);
                }
                
            } 
            else if(tempMap.UserName__C==UserInfo.getUserId() && selectedLevel=='2. Business Unit' && (   tempMap.Level__c=='1. Key Operations') )// UserInfo.getProfileId()!='00ed00000012gBs'  )
            {
                if(lc <>'') //<Start> - Added this if condition by BSA for INC0346541 - 14-Feb-2013
                {
                    //continue allow override..
                } 
                else
                {
                    hasError = true;
                    rfaObj.addError(RFAGlobalConstants.EXCEPTION_HIGHER_LEVEL);
                }
                
            }
        }
        
        if(allowAccess==false)rfaObj.addError(RFAGlobalConstants.EXCEPTION_NOT_PART_OF_PC);
        
    }
    
    
    
}