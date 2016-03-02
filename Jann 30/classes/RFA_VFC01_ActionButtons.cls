/****************************************************************************************************************************************
****************************************************************************************************************************************    
*  Class            : RFA_VFC01_ActionButtons extends RFA_Util_SecurityMatrix
*  Author           : Accenture
*  Version History  : 2.0
*  Creation         : 05/15/2012
*  Assumptions      : N/A
*  Description      : Controller Class for the RFA_VFP01_ActionButtons visualforce page. This class will determine the button Label for the Send to 
Circulation Button and also the Button Rendering logic based on Logged in User's Role on the RFA
The class extends the RFA_Util_SecurityMatrix class to check the Logged in User's access level and permission on RFA.

* Change History    : Method performAction() and innerClass ErrorDisplay have been depricated and moved to other class (Applied On 7/18/2012) 

* Author            : mpascua@coca-cola.com
* Date of Change    : Aug 2, 2013
* Description       : Added boolean variable displayCloseDraftRFA to control the display of Close RFA button for Draft RFAs.

* Author            : Infosys
* Date of Change    : Dec 29, 2015
* Description       : Added boolean variable displayInfoMsgReturnToSender to control the display of message to 'Approvers' and 'Info copy' users
*                      when RFA is returned to sender
*                   : Added a method getRFACordinatordetails to get the Count of location coordinators present in the profit center at each level

****************************************************************************************************************************************
****************************************************************************************************************************************/

global class RFA_VFC01_ActionButtons extends RFA_Util_SecurityMatrix{
    /*~~~~Intializing Variables~~~~*/
    public List<RFA_AP07_PageButtonWrapper>     pageButtonList{get;private set;}
    public RFA__c                               rfaObj{get; private set;}
    public RFA__c Levelstg {get;set;}
    // public boolean enableselappvrbtn {get; private set;}  
    public String                               labelClicked{get;set;}  
    public boolean                              displaypushCirculationButton{get;private set;}
    public boolean                              displayOverridePopup{get;private set;}
    public boolean                              displayCompletionMemo{get;private set;}
    public boolean                              displayCompleteRFA{get;private set;}
    public boolean                              displayRecomButton{get; private set;}
    public boolean                              displayNotesAndAttachment{get; private set;} //added by Ashwani for FR1.70
    public boolean                              displayInfoMsgReturnToSender{get;private set;} // added for REQ 23.6
    
    
    //added by mpascua@coca-cola,com for closing RFA drafts
    public boolean                              displayCloseDraftRFA {get; private set;} 
    public boolean                              displayReopenRFA {get; private set;}
    //----------
    public integer                              rfastrtlvelappvrs {get;set;}    
    private String                              currentLevel;
    private String                              previousLevel;
    private String                              nextLevel;
    private UserAccess                          uAccess;
    public string                              startLevelofPC {get;set;}
    Set<Id> UserAccessSet=new Set<Id>();
    public static Map<String,Integer> LocationCordinatorsList=null;
    
    public static Map<String, String> stagemap = new Map<String, String>();       
    public static Map<String, String> nextLevelMap = new Map<String, String>{
        System.Label.RFA_CL001 => System.Label.RFA_CL002,
            System.Label.RFA_CL002 => System.Label.RFA_CL003,
            System.Label.RFA_CL003 => System.Label.RFA_CL004,
            System.Label.RFA_CL004 => System.Label.RFA_CL005,
            System.Label.RFA_CL005 => System.Label.RFA_CL006
            };
                
                
                
                private static Map<String, String> previousLevelMap = new Map<String, String>{
                    System.Label.RFA_CL002 =>System.Label.RFA_CL001 ,
                        System.Label.RFA_CL003 =>System.Label.RFA_CL002 ,
                        System.Label.RFA_CL004 =>System.Label.RFA_CL003,
                        System.Label.RFA_CL005 =>System.Label.RFA_CL004,
                        System.Label.RFA_CL006 =>System.Label.RFA_CL005
                        };
                            
                            /*~~~~End of Variable Intialization~~~~*/
                            
                            //Constructor for the Class
                            //Start of Constructor
                   public RFA_VFC01_ActionButtons(ApexPages.StandardController controller) 
                        {
                            super(controller);                                   
                            this.rfaObj = (RFA__c)controller.getRecord();
                            this.pageButtonList = new List<RFA_AP07_PageButtonWrapper>();        
                            
                            if(rfaObj.Id <> null)
                            { 
                                
                                for(RFA__Share rfs:[select UserorGroupid,accesslevel from RFA__Share where parentid=:rfaobj.Id and (accesslevel='Edit' or accesslevel='All')])
                                {
                                    if(rfs <> null) UserAccessSet.add(rfs.UserorGroupid);
                                }
                                
                                if(UserAccessSet.size()>0 && UserAccessSet.contains(UserInfo.getUserId()) || (RFA_WS07_CheckRFAUser.isRFAAdmin()) )  displayNotesAndAttachment=true;            
                                
                                rfaObj = getRFADetails(rfaObj); 
                                
                                if(rfaObj.Level__c.contains(System.Label.RFA_CL001)) 
                                { 
                                    
                                    System.debug('######## Inside key operations if condition block ########');
                                    currentLevel = System.Label.RFA_CL001;
                                    nextLevel = nextLevelMap.get(currentLevel); 
                                }
                                else if(rfaObj.Level__c.contains(System.Label.RFA_CL002))
                                { 
                                    
                                    currentLevel = System.Label.RFA_CL002;
                                    nextLevel = nextLevelMap.get(currentLevel);
                                }
                                else if(rfaObj.Level__c.contains(System.Label.RFA_CL003))
                                {                                    
                                    currentLevel = System.Label.RFA_CL003;
                                    nextLevel = nextLevelMap.get(currentLevel);
                                }
                                else if(rfaObj.Level__c.contains(System.Label.RFA_CL004) )
                                {
                                    currentLevel = System.Label.RFA_CL004; 
                                    nextLevel = nextLevelMap.get(currentLevel);
                                }
                                else if(rfaObj.Level__c.contains(System.Label.RFA_CL005) && !rfaObj.Level__c.contains(System.Label.RFA_CL006))
                                {
                                    currentLevel = System.Label.RFA_CL005; 
                                    nextLevel = nextLevelMap.get(currentLevel);
                                }
                                else if(rfaObj.Level__c.contains(System.Label.RFA_CL006) )
                                {
                                    currentLevel = System.Label.RFA_CL006;  
                                    nextLevel = nextLevelMap.get(currentLevel);
                                }
                                
                                if(rfaObj.PreviousLevel__c <> null)
                                {
                                    if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL001) )
                                    {
                                        
                                        System.debug('######## Inside key operations if condition block ########');
                                        previousLevel = System.Label.RFA_CL001;
                                        //nextLevel = nextLevelMap.get(currentLevel); 
                                    }
                                    else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL002))
                                    {
                                        
                                        previousLevel = System.Label.RFA_CL002;
                                        //nextLevel = nextLevelMap.get(currentLevel);
                                    }
                                    else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL003))
                                    {
                                        
                                        previousLevel = System.Label.RFA_CL003;
                                        //nextLevel = nextLevelMap.get(currentLevel);
                                    }
                                    else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL004))
                                    { 
                                        previousLevel = System.Label.RFA_CL004; 
                                        //nextLevel = nextLevelMap.get(currentLevel);
                                    }
                                    else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL005) && !rfaObj.level__C.contains(System.Label.RFA_CL006))
                                    { 
                                        previousLevel = System.Label.RFA_CL005; 
                                        //nextLevel = nextLevelMap.get(currentLevel);
                                    }
                                    else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL006))
                                    {
                                        
                                        previousLevel = System.Label.RFA_CL006;  
                                        //nextLevel = nextLevelMap.get(currentLevel);
                                    }
                                    
                                } 
                                
                                uAccess = getRFAUserAccess();          
                                actionGate();
                            }
                        }
    
    public RFA__c getRFADetails(RFA__c rfaObj)
    { 
        return [SELECT Comments__c, ControlNumber__c,DataClassification__c,LevelStage__c,Level__c,LocalReferenceNumber__c,Name,OwnerId,
                PreviousLevel__c, ProfitCenterName__c,ProfitCenterNumberName__c,ProfitCenterNumber__c,RecordTypeId,RequestAmountFunctionalCurrency__c,RequestAmountUSD__c,
                Stage__c, WACC__c  FROM RFA__c WHERE Id = : rfaObj.Id LIMIT 1];                  
    }
    //Below method gets the Number of coordinators present on the Profit center at each level    
    public static Map<String,Integer> getRFACordinatordetails(RFA__c rfaobj)
    {
        
        List <AggregateResult> aggrs =
            [SELECT Level__c,count(id) PFUsersCount from ProfitCenterUserRole__c WHERE ProfitCenter__c =:rfaObj.ProfitCenterNumber__c
             GROUP BY Level__c];
        LocationCordinatorsList= new  Map<String,Integer>();
        
        for (AggregateResult res : aggrs)
        {            
            String level=(String)res.get('Level__c');
            Integer userCount=(Integer)res.get('PFUsersCount');
            LocationCordinatorsList.put(level.substring(3,level.length()),userCount );
        }
        return LocationCordinatorsList;
    }
    public pageReference actionGate()
    {        
        System.debug('\n User Access from the security matrix : '+uAccess);
        System.debug('\n Is local coordinator :'+uAccess.isLocalCoordinator());
        System.debug('\n IS Approver :'+uAccess.isApprover());
        System.debug('\n IS Agent :'+uAccess.isAgent());
        System.debug('\n IS Admin :'+uAccess.isAdmin());
        System.debug('\n IS Requester :'+uAccess.isRequester());
        System.debug('\n Current level of the RFA :'+currentLevel);
        System.debug('\n Next level of the RFA :'+nextlevel);
        System.debug('\n Previous level of the RFA :'+previousLevel);
        
        // reset all boolean variables for the display of button
        this.displaypushCirculationButton = false;
        this.displayOverridePopup = false;
        this.displayCompletionMemo = false;
        this.displayCompleteRFA = false;
        this.displayRecomButton = false;
        //added for REQ 23.6
        this.displayInfoMsgReturnToSender = false;        
        //Added by mpascua@coca-cola.com Aug 2, 2013
        this.displayCloseDraftRFA = false;        
        //****************** RFA IN DRAFT STAGE ***************************
        if(rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_DRAFT)
        {
            if(uAccess.isLocalCoordinator()|| uAccess.isAdmin() || uAccess.isRequester())
            {
                pageButtonList.add(new RFA_AP07_PageButtonWrapper('Select Approvers', '_top', true, true));
                pageButtonList.add(new RFA_AP07_PageButtonWrapper('Send to' + ' ' +currentLevel+ ' '+ 'Coordinator', '_top', true, true));                
                //Added by mpascua@coca-cola.com Aug 2, 2013
                this.displayCloseDraftRFA = true;
               
                
            }
            
            if(uAccess.isLocalCoordinator()|| uAccess.isAdmin())    
                this.displayOverridePopup = true;
            
            
        }
        // Added mpascua@coca-cola.com Aug 16, 2013
        else if(rfaObj.Stage__c == 'Draft Closed')
        {
            this.displayReopenRFA = true;
        }
        //-----
        
        // **************** RFA IN PRE-CIRCULATION STAGE *****************
        
        else if(rfaObj.Stage__c == RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE)
        {   
            
            if(uAccess.isLocalCoordinator() || uAccess.isAdmin())
            {
                pageButtonList.add(new RFA_AP07_PageButtonWrapper('Select Approvers', '_top', true, true));
                this.displaypushCirculationButton = true;
                this.displayCompleteRFA = true;
                this.displayOverridePopup = true;
            } 
            
        }
        // **************** RFA IN CIRCULATION STAGE *********************
        else if(rfaObj.Stage__c == RFAGlobalConstants.RFA_CIRCULATION_STAGE)
        {
            
            if(uAccess.isLocalCoordinator() || uAccess.isAdmin())
            {  
                pageButtonList.add(new RFA_AP07_PageButtonWrapper('Select Approvers', '_top', true, true));
                this.displaypushCirculationButton = false;
                this.displayCompleteRFA = true;
                this.displayOverridePopup = true;   
                this.displayCompletionMemo = false;     
                this.displayCompleteRFA = false; 
                
            }
            
            if(uAccess.isApprover() || uAccess.isAgent())
            {
                system.debug('this user is approver:');
                this.displayRecomButton = true;                  
            }
        }
        // *************** RFA IN POST-CIRCULATION STAGE ******************
        else if(rfaObj.Stage__c == RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE)
        {
            
            if(uAccess.isLocalCoordinator()  || uAccess.isAdmin())
            {               
                pageButtonList.add(new RFA_AP07_PageButtonWrapper('Select Approvers', '_top', true, true));
                this.displayOverridePopup = true;
                this.displayCompleteRFA = true;
                this.displayCompletionMemo = false;
                this.displayRecomButton = false;
                this.displaypushCirculationButton = false;
                //added
                String skippedlevel=null;
                Boolean hascoord=false;
                Integer IsLocationCoord=null;
                Boolean LastLevelCoordinators= true;
                while(hascoord==false){ 
                   Map<String,Integer> CoordinaorsList = getRFACordinatordetails(rfaObj);
                    //If profit center users are not present for the nextLevel, then fetch the next level from pcnextLevelMap
                     
                    IsLocationCoord = CoordinaorsList.get(nextLevel);
                    if(IsLocationCoord ==null)
                    {                    
                        
                        //To stop from looping after the last level
                        System.debug('nextLevel is..'+nextLevel);
                         
                         if(nextLevel==RFAStaticVariables.Level6||nextLevel==null)
                        {
                            System.debug('Im senior exec');
                            LastLevelCoordinators = false;
                            hascoord=true;   
                        }
                        else{
                       	 	nextLevel=nextLevelMap.get(nextLevel); 
                            System.debug('nextLevelMap'+nextLevelMap);
                            System.debug('fetching next level.. '+nextlevel);
                        }
                         
                        
                    }  
                    else{
                        hascoord=true;                   
                    } 
                }
                
                //added
                 if(LastLevelCoordinators == true)
                 {
                	if(nextLevel <> null)pageButtonList.add(new RFA_AP07_PageButtonWrapper('Send to' + ' ' +nextLevel + ' '+ 'Coordinator', '_top', true, true));
                 }
                
            }   
        }
        // *************** RFA IS APPROVED OR REJECTED OR CLOSED *********
        else if(rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_APPROVED || rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_REJECTED || rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_CLOSED)
        {
            
            if(uAccess.isLocalCoordinator() || uAccess.isAdmin())
            {
                pageButtonList.add(new RFA_AP07_PageButtonWrapper('Select Approvers', '_top', true, true));
                this.displayOverridePopup = true;
                this.displayCompleteRFA = false;  
                this.displayCompletionMemo = true; 
                this.displayRecomButton = false;    
                this.displaypushCirculationButton = false;              
            }       
        }
        // ************** RFA IS IN PENDING BOARD REVIEW *****************              
        
        if(rfaObj.Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW)
        {
           
            if(uAccess.isAdmin())
            {
                 pageButtonList.add(new RFA_AP07_PageButtonWrapper('Select Approvers', '_top', true, true));
                this.displayRecomButton = false; 
                this.displayOverridePopup = true;
                if(rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_APPROVED || rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_REJECTED || rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_CLOSED)
                {
                    this.displayCompleteRFA  = false;
                    this.displayCompletionMemo = true;  
                }
                else
                {
                    this.displayCompleteRFA  = true;
                    this.displayCompletionMemo = false;  
                    
                }
                this.displaypushCirculationButton = false;
            }
            
        }
        // ************** RFA IN CAPITAL MANAGEMENT HOLD ****************
        else if(rfaObj.Level__c == RFAGlobalConstants.CAPITAL_MGMT_HOLD)
        {
           
            if(uAccess.isAdmin() || uAccess.isLocalCoordinator())
            {
                 pageButtonList.add(new RFA_AP07_PageButtonWrapper('Select Approvers', '_top', true, true));
                this.displayOverridePopup = true;               
                this.displayRecomButton = false;                 
                this.displayCompletionMemo = false;  
                this.displayCompleteRFA  = false;   
                this.displaypushCirculationButton = false;      
            }
        } 
        // **************** RFA IN RETURN TO SENDER **********************
        else if(rfaObj.Level__c == RFAGlobalConstants.RETURN_TO_SENDER)
        {
            
            
            if(uAccess.isLocalCoordinator()|| uAccess.isAdmin() || uAccess.isRequester())
            {
                pageButtonList.add(new RFA_AP07_PageButtonWrapper('Select Approvers', '_top', true, true));                
                pageButtonList.add(new RFA_AP07_PageButtonWrapper('Send to' + ' ' +previousLevel+ ' '+ 'Coordinator', '_top', true, true));
             }
            
            
            if(uAccess.isLocalCoordinator()|| uAccess.isAdmin())
                
                this.displayOverridePopup = true; 
            
        } 
        
        //added for REQ 23.6         
        if(rfaobj.LevelStage__c == RFAGlobalConstants.RETURN_TO_SENDER)        
        {            
            List<RFAUserRole__c> isApproverlist= [select UserName__c from RFAUserRole__c where RFA__c=:rfaobj.id AND ApprovalRecommendation__c = null];
            Map<Id, Schema.RecordTypeInfo> rectype_map = Schema.getGlobalDescribe().get('RFAUserRole__c').getDescribe().getRecordTypeInfosById();
            
            if(isApproverlist!=null)
            { 
                for(RFAUserRole__c rfarole:isApproverlist )
                { 
                    
                    if(rectype_map.get(rfarole.recordTypeID)!=null&&((rectype_map.get(rfarole.recordTypeID).getName().containsIgnoreCase('Approver')||rectype_map.get(rfarole.recordTypeID).getName().containsIgnoreCase('Info Copy Only'))&&userinfo.getUserId()==rfarole.UserName__c)){
                        {
                            
                            this.displayInfoMsgReturnToSender = true;
                            break;
                        }
                    }
                }
                
            }        
        }
        System.debug('\n ******************Page Button List :'+pageButtonList);
        return null;          
    }
    
    public Integer pageButtonListSize{
        get{
            return pageButtonList.size();
        }
        private set;
    }
    
}