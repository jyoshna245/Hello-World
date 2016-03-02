/****************************************************************************************************************************************
****************************************************************************************************************************************    
*  Trigger          : RFA_RFATrigger
*  Author           : Accenture
*  Version History  : 2.0
*  Creation         : 5/11/2012
*  Assumptions      : N/A
*  Description      : Trigger contains business logic to process RFA for its different Stages/level
  change Hsitory    : Do not Move RFA to next Level If coordinator is not assigned for that level
   

****************************************************************************************************************************************
****************************************************************************************************************************************/

trigger RFA_RFATrigger on RFA__c (after insert, after Update, before update, before insert) { 
    
    //RFA_AP05_RFATriggerHelper rfaHelper2 = new RFA_AP05_RFATriggerHelper();
    
    RFA_AP05_RFATrigger rfaHelper = new RFA_AP05_RFATrigger(); // Instantiating the Processor class
    
    List<Rfa__c> rfaList=new List<RFA__c>(); // List of RFAs for update
    
    List<Rfa__c> rfaFunctionAREList=new List<RFA__c>(); // List of RFAs for update after its functional Currency reference is changed
    
    Map<Id, Id> rfaSharetoDelete=new Map<Id,Id>(); // List of RFA records for which the Share records are to be deleted after the profit center reference has been changed.
    
    Map<String, String> rfaMapForReturnToSender = new Map<String, String>(); // Map variable for Storing RFA Id and RFa profit Center during RFA Stage of "Return To Sender"
    
    Set<ID> rfaSetForCompletedRFAs = new Set<ID>(); // Set variable for Storing RFA Id and RFA Profit Center if RFA is completed (Approved,Rejected,Closed) - Added by Ashwani for FR1.70 on 27 June 2013
    
    Map<String, String> rfaMapForPreviousReturnToSender = new Map<String, String>(); // Map variable for Storing RFA Id and RFa profit Center during previous RFA Stage of "Return To Sender"
    
    Map<String, String> rfaMapForPreCirculation = new Map<String, String>(); // Map variable for Storing RFA Id and RFa Object during RFA Stage of "Pre-Circulation"
    
    Map<String, String> rfaMapForPostCirculation = new Map<String, String>(); // Map variable for storing RFA Id and RFA Object during RFA Stage of "Post-Circulation"
    
    Map<String, RFA__c> rfaMapForPendingBoardReview = new Map<String, RFA__c>(); // Map variable for Storing RFA Id and RFA Object when RFA level is "Pending Board Review"
    
    Map<Id, String> levelMap = new Map<Id, String>(); // Map for storing Unique list of Level for which the RFA is processed.
    
    Set<Id> rfaIdsForDeleteCapitalExpenditure=new Set<Id>(); // Set of RFA ids which will delete from capital expenditure table.
    
    Set<Id> rfaIdsRecordTypeChange=new Set<Id>(); // Set of RFA ids where the RFA record type is changed.
    
    Set<Id> rfaIdsInitialBudgetYearChange = new Set<Id>(); // If RFA.Initial Budget Year field updated 
    
    List<RFA__c> rfaListRecordTypeChange=new List<RFA__c>(); // If record type change
    
    List<RFA__c> rfaLstLvlStsChange =  New List<RFA__c>(); // List To store the RFA records for which the Level or Stage has been updated
    
    Map<Id, RFA__c> rfaLstLvlStsChangeOld =  New Map<Id, RFA__c>(); // Map To store the old copy of RFA records for which the Level or Stage has been updated
    
    Set<Id> rfaIdsLvlStsChange = New Set<Id>(); // Set to store the RFA records for which the Level has been updated
    
    List<RFA__Share> rfaShareForUpdateList = new List<RFA__Share>(); //List of RFA Share Object
    
    Map<Id,Set<Id>> rfaReportingUnitMap=new Map<Id,Set<id>>(); // Map to store RFAId and reporting unit
    
    Set<Id> rfaReportingUnitsIds=new Set<Id>(); // Set to store the reporting unit ids
    
    Set<String> rfaIdsForSharingDeletion = new Set<String>();// Set to store unique set of RFA Ids which has been changed from "Draft" OR "Return To Sender" Stage.
    
    rfa_Ap02_Shareutil shareUtilCls=new rfa_Ap02_Shareutil();
    
    Set<Id> rfaIdsPendingReview=new Set<Id>();   // Store RFA ids in case of pending board review
    
    Map<Id,Id> rfaShareDeleteLvl=new Map<Id,Id>(); // Store RFAId, ProfitCenterID Old id
    
    List<RFA__c> rfaListLvlChange=new List<RFA__c>();
    
    List<Rfa__c> rfaListforReportingUnit=new List<RFA__c>(); // List of RFAs - Use in reporting Unit
    
    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP = RFAGlobalConstants.RECORDTYPESMAP;
    
    public static Map<String, RecordType> rfaRecordTypeMap = RECORDTYPESMAP.get(Schema.sObjectType.RFA__c.getName());
    
    if(!(trigger.new.size()>1)) {
        /************************************** BEFORE BLOCK STARTS ****************************************/        
        if(trigger.IsBefore)
        {
            
            /************************************ BEFORE INSERT BLOCK STARTS *****************************************/
            
            if(trigger.IsInsert) 
            {
                // set Initial RFA level on insertion. Minimum value for the RFA is fetched from the associated Profit Center
                // Set Initial ARE value for the RFA upon insertion based on the functional currency selected on the RFA Level.
                //For Dummy Profit Center - RLC Aug 27, 2013 Q3 Requirements
                rfaHelper.processRFADummyProfitCenter(Trigger.New);
                
                
                rfaHelper.processRFABeforeInsert(Trigger.new);
                
                for(RFA__c rfa : Trigger.new)
                {
                    if(rfa.Stage__c == 'Draft') rfa.LevelStage__c = rfa.Stage__c;
                }
                
            }
            
            /*********************************** BEFORE  INSERT BLOCK ENDS ********************************************/
            
            /*********************************** BEFORE UPDATE BLOCK STARTS ******************************************/
            if(trigger.isUpdate)
                
            {
                try{
                    
                    
                    for(RFA__c rfa: trigger.new)
                    {
                        
                        //For Policy Exemption Request - RLC Aug 27, 2013 Q3 Requirements  
                        
                        
                        //Set<String> errorSetPolicy = RFA_AP05_RFATrigger.NoChangePolicyExemption(rfa, Trigger.oldMap.get(rfa.Id));
                        
                        //if(!errorSetPolicy.isEmpty()) throw new RFA_AP19_RFAValidationException(errorSetPolicy);
                        system.debug('rfa level in 119'+rfa.level__c);
                        if (RFA_AP05_RFATrigger.NoChangePolicyExemption(rfa, Trigger.oldMap.get(rfa.Id)))continue;
                        
                        
                        
                        
                        // Added mpascua
                        if(rfa.Stage__c == 'Draft Closed'){
                            //do nothing
                            
                        }else{
                            
                            //
                            // Set RFA Are when the Functional currency reference is changed for the RFA
                            if(rfa.Functional_Currency__c!=Null && rfa.AREMonth__c!=null && ( rfa.Functional_Currency__c!= trigger.oldmap.get(rfa.id).Functional_Currency__c ||  rfa.AREMonth__c!=trigger.oldmap.get(rfa.id).AREMonth__c))
                            {
                                rfaFunctionAREList.add(rfa);                           
                            }
                            
                            /* Added by Accenture for 2013 Q1 enhancement FR1.79*/
                            // If Profit Center Number has changed when the RFA is NOT in Circulation stage     
                            if( rfa.ProfitCenterNumber__c <> Trigger.oldmap.get(rfa.id).profitCenterNumber__c && 
                               rfa.ProfitCenterNumber__c <> null &&
                               rfa.Stage__c != RFAGlobalConstants.RFA_CIRCULATION_STAGE)
                            {  
                                // Always update RFA Level to new Profit Center Min Level when RFA is in Draft - 2013 Q1 FR1.52
                                system.debug('rfa ProfitCenterMinLevel'+rfa.ProfitCenterMinLevel__c);
                                if (rfa.Stage__c==RFAGlobalConstants.RFA_STAGE_DRAFT) 
                                {
                                    rfa.Level__c = rfa.ProfitCenterMinLevel__c;
                                    
                                }   
                                
                                // If RFA Level is Return to Sender, Capital Management Hold or Pending Board Review...
                                else if (rfa.Level__c==RFAGlobalConstants.RETURN_TO_SENDER || 
                                         rfa.Level__c==RFAGlobalConstants.CAPITAL_MGMT_HOLD || 
                                         rfa.Level__c==RFAGlobalConstants.PENDING_BOARD_REVIEW)
                                {
                                    // And if RFA Previous Level is less than new Profit Center Min level, update RFA Previous Level to profit center min level
                                    if ( shareUtilCls.compareRFALevel(rfa.PreviousLevel__c, rfa.ProfitCenterMinLevel__c) < 0 )
                                        rfa.PreviousLevel__c = rfa.ProfitCenterMinLevel__c;
                                }
                                else // all other RFA Levels
                                {
                                    // if RFA Level is less than new Profit Center Min level, update RFA Level to profit center min level, stage = pre-circulation
                                    system.debug('other levels '+ rfa.ProfitCenterMinLevel__c);
                                    if (shareUtilCls.compareRFALevel(rfa.Level__c, rfa.ProfitCenterMinLevel__c) < 0)
                                    {
                                        
                                        rfa.Level__c = rfa.ProfitCenterMinLevel__c;
                                        
                                        rfa.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
                                    }
                                }
                            }
                            
                            
                            // Check whether Level/ Stage has been Updated
                            if(rfa.Stage__c != trigger.oldmap.get(rfa.id).Stage__c || rfa.Level__c != trigger.oldmap.get(rfa.id).Level__c)
                            {
                                
                                // Create a list of the updated RFA if the Stage or Level of the RFA is Updated
                                rfaLstLvlStsChange.add(rfa); // Current Values
                                rfaLstLvlStsChangeOld.put(rfa.Id, trigger.oldmap.get(rfa.Id));  // Old Values                
                                
                            } 
                            
                            
                            /**********************Previous level update when level changes*******************/
                            if(rfa.Level__c <> RFAGlobalConstants.RETURN_TO_SENDER && rfa.Level__c <> RFAGlobalConstants.PENDING_BOARD_REVIEW && rfa.Level__c <> RFAGlobalConstants.CAPITAL_MGMT_HOLD )
                            {
                                
                                rfa.PreviousLevel__c = rfa.Level__c;
                            }
                            
                            /*****************************Level Stage Update logic Starts here***************************/
                            
                            if(rfa.Stage__c==RFAGlobalConstants.RFA_STAGE_DRAFT)
                            {
                                rfa.LevelStage__c = rfa.Stage__c;
                            }
                            
                            //----------- Added by mpascua Aug 15, 2015 for new Requirement Close Draft
                            else if(rfa.Stage__c== 'Draft Closed')
                            {
                                rfa.LevelStage__c = rfa.Stage__c;
                                //rfa.Level__c = rfa.Stage__c;
                                
                            }
                            //------------
                            
                            else if((rfa.level__C==RFAGlobalConstants.CAPITAL_MGMT_HOLD || rfa.Level__c == RFAGlobalConstants.RETURN_TO_SENDER || rfa.Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW)&& (rfa.Stage__c!= RFAGlobalConstants.RFA_STAGE_CLOSED && rfa.Stage__c!= RFAGlobalConstants.RFA_STAGE_APPROVED && rfa.Stage__c!= RFAGlobalConstants.RFA_STAGE_REJECTED))
                            { 
                                rfa.LevelStage__c = rfa.Level__c; 
                            }
                            else if((rfa.level__C==RFAGlobalConstants.CAPITAL_MGMT_HOLD || rfa.Level__c == RFAGlobalConstants.RETURN_TO_SENDER || rfa.Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW)&& (rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_CLOSED || rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_APPROVED || rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_REJECTED))
                            {
                                rfa.LevelStage__c = rfa.PreviousLevel__c.subString(3,rfa.PreviousLevel__c.length()) + ' ' + rfa.Stage__c;
                            }
                            else if(rfa.Level__c <> RFAGlobalConstants.RETURN_TO_SENDER && rfa.Level__c <> RFAGlobalConstants.PENDING_BOARD_REVIEW && rfa.Level__c <> RFAGlobalConstants.CAPITAL_MGMT_HOLD)
                            { 
                                rfa.LevelStage__c = rfa.Level__c.subString(3,rfa.Level__c.length()) + ' ' + rfa.Stage__c;
                            }
                            if((rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_CLOSED || rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_APPROVED || rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_REJECTED) && Trigger.oldMap.get(rfa.Id).Stage__c <> rfa.Stage__c)
                            {
                                rfa.CompletionDate__c = System.now();
                            }
                            
                            
                            // Added by mpascua@coca-cola.com Aug 15, 2013
                            if(rfa.Stage__c== 'Draft Closed'){
                                //skip validations
                            }else{
                                //-----
                                
                                
                                // ********************** captureEmailTempValues() Capture Primary Contact, CO-CREATOR, Approver, Agents & Location Coordinator  ********************/
                                
                                //************************ Stage EQUALS: "Return To Sender" ******************************/
                                // Notify Local Coordinator of RFA current level once the RFA is returned to Sender
                                if(rfa.Level__c == RFAGlobalConstants.RETURN_TO_SENDER
                                   && rfa.Level__c <> Trigger.oldMap.get(rfa.Id).Level__c
                                   && RFA_AP05_RFATrigger.isFirstRun)
                                {                    
                                    if(rfa.PreviousLevel__c <> null)levelMap.put(rfa.Id, rfa.PreviousLevel__c); 
                                }  
                                
                                //*********************** Previous Level EQUALS : "Return To Sender" *********************/
                                // Notify Local coordinator that the RFA update has been completed and RFA has resumed from "Return To Sender"
                                
                                
                                if(Trigger.oldMap.get(rfa.Id).Level__c == RFAGlobalConstants.RETURN_TO_SENDER
                                   && rfa.Level__c <> Trigger.oldMap.get(rfa.Id).Level__c) 
                                {
                                    if(rfa.Level__c <> null)levelMap.put(rfa.Id, rfa.Level__c);     
                                } 
                                
                                
                                //************************ Stage EQUALS: "Pre-Circulation" ******************************/
                                // Notify Local Coordinator of RFA current level once the RFA is sent to Pre-Circulation stage
                                
                                if(rfa.Stage__c == RFAGlobalConstants.PRE_CIRCULATION
                                   && RFA_AP05_RFATrigger.isFirstRun
                                   && Trigger.oldMap.get(rfa.Id).Level__c <> RFAGlobalConstants.RETURN_TO_SENDER // added by Ashwani for FR1.80 on May 13  
                                   && (rfa.Level__c <> RFAGlobalConstants.CAPITAL_MGMT_HOLD || rfa.Level__c <> RFAGlobalConstants.RETURN_TO_SENDER || rfa.Level__c <> RFAGlobalConstants.PENDING_BOARD_REVIEW))
                                {                    
                                    
                                    levelMap.put(rfa.Id, rfa.Level__c);
                                    
                                }
                                
                                //*********************** Stage EQUALS: "Post-Circulation" *****************************/
                                // Notify Local coordinator of RFA current level once the RFA is sent to Post Circulation Stage
                                if(rfa.Stage__c == RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE
                                   && RFA_AP05_RFATrigger.isFirstRun
                                   && (rfa.Level__c <> RFAGlobalConstants.CAPITAL_MGMT_HOLD || rfa.Level__c <> RFAGlobalConstants.RETURN_TO_SENDER || rfa.Level__c <> RFAGlobalConstants.PENDING_BOARD_REVIEW))
                                {   
                                    
                                    levelMap.put(rfa.Id, rfa.Level__c);
                                     
                                }
                                
                                rfaHelper.captureEmailTempValues(rfa, levelMap);
                                
                                /*****************************Level Stage Update logic Ends here***************************/
                                
                                //********************* VALIDATION CHECK ***************************************//
                                if(rfa.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id)
                                {
                                    Set<String> errorSet = RFA_AP05_RFATrigger.validatePolicyExemptionRFA(rfa, Trigger.oldMap.get(rfa.Id));
                                    if(!errorSet.isEmpty()) throw new RFA_AP19_RFAValidationException(errorSet);
                                }else{
                                    Set<String> errorSet = RFA_AP05_RFATrigger.validateRFA(rfa, Trigger.oldMap.get(rfa.Id));
                                    if(!errorSet.isEmpty()) throw new RFA_AP19_RFAValidationException(errorSet);
                                    
                                }
                                //-- Added mpascua@coca-cola.com Aug 15, 2013
                            }
                            //-----
                        }  
                        
                        //Added mpascua
                    }
                    
                    
                    // -------
                }
                catch(RFA_AP19_RFAValidationException validationEx)
                {
                    //rfa.addError(validationEx);
                    Trigger.new[0].addError(validationEx.getSerializedErrMsg());
                    system.debug('validationEx.getMessage()+++'+validationEx.getMessage());
                    //Trigger.new[0].addError(validationEx.getMessage());
                }
                
                
                /*
if(!rfaLstLvlStsChange.isEmpty())
rfaHelper.validateAmount(rfaLstLvlStsChange); // Call method to check whether Request amount, Three Year Cash Spend Total, Capital Expenditure Total are equal          
*/
                if(!rfaFunctionAREList.isEmpty())
                {
                    // call method for popualating ARE value for the selected Functional Currency
                    rfaHelper.processRecordsForFunctionalCurrency(rfaFunctionAREList);
                    
                }
                
                if (!rfaSharetoDelete.isEmpty())
                {
                    rfaHelper.processRFABeforeShare(rfaSharetoDelete); 
                }
                
                
                if(!rfaLstLvlStsChange.isEmpty() && !rfaLstLvlStsChangeOld.isEmpty())
                    rfaHelper.rfaAgingCalculation(rfaLstLvlStsChange, rfaLstLvlStsChangeOld);
                
                // calling Delete Function for capitalExpenditure
                
            }
            
            /************************************* BEFORE UPDATE BLOCK ENDS *******************************************/
            // Clear All List
            rfaList.clear();
            rfaFunctionAREList.clear();
            rfaSharetoDelete.clear();
            rfaMapForPreCirculation.clear();
            rfaMapForPostCirculation.clear();
            levelMap.clear();
            rfaIdsRecordTypeChange.clear();
            rfaIdsForDeleteCapitalExpenditure.clear();
            rfaIdsInitialBudgetYearChange.clear();
            rfaListRecordTypeChange.clear();
            rfaLstLvlStsChange.clear();
            rfaShareForUpdateList.clear();
            rfaLstLvlStsChangeOld.clear();
            
            
        }
        
        /****************************************** BEFORE BLOCK ENDS **********************************************/
        
        /****************************************** AFTER BLOCK STARTS *********************************************/    
        if(trigger.IsAfter)
        {  
            /********************************** AFTER INSERT BLOCK STARTS ****************************************/
            
            if(trigger.IsInsert)
            {
                rfaHelper.processRFAAfterInsert(Trigger.new);
                rfaHelper.processRFAAfterInsertForCapitalExpenditure(Trigger.new);
                
                rfaHelper.processRFAOwnerShare(Trigger.New);
                rfaHelper.processRFAProfitCenterShare(Trigger.New);
                rfaHelper.processRFAReportingUnitShare(Trigger.New);
                
            } 
            
            /********************************** AFTER INSERT BLOCK ENDS *****************************************/
            
            /********************************** AFTER UPDATE BLOCK STARTS ***************************************/
            
            if (trigger.IsUpdate)
            {
                
                for(Rfa__c rfa: Trigger.New)
                {
                    
                    
                    // Added by mpascua@coca-cola.com Aug 15, 2013                        
                    if(rfa.Stage__c== 'Draft Closed'){  
                        //skip validations     
                    }else{              
                        //-----      
                        
                        // *********************** RFA level has changed ***********************/
                        // Populate rfaSetLvlChange & process info only notification.
                        if(rfa.Level__c != trigger.oldmap.get(rfa.id).Level__c || rfa.Stage__c != trigger.oldmap.get(rfa.id).Stage__c)
                        {
                            rfaIdsLvlStsChange.add(rfa.Id);
                        }
                        
                        /*
                        //FOR REQ 23.3 Do not Move RFA to next Level If coordinator is not assigned for that level
                         
                        Id id=null;
                        
                        if((rfa.stage__C==RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE||rfa.stage__C==RFAGlobalConstants.RETURN_TO_SENDER) && RFAStaticVariables.skiplevel==false)
                        {
                            RFA_VFC_SkipLevelController rfaskip = new RFA_VFC_SkipLevelController();
                            
                            id = rfaskip.validationOfskipLevel();
                        }
                        if(id!=null)
                        {
                            rfa=[select id,SecondReportingUnitNumber__c,ThirdDOACategorySubCategory__c ,PrimaryDOACategorySubCategory__c,SecondDOACategorySubCategory__c ,ThirdReportingUnitNumber__c, PreviousLevel__c ,InitialBudgetYear__c,RecordTypeId,PrimaryReportingUnitNumber__c,level__c,Stage__c,ProfitCenterNumber__c from RFA__C where id=:id limit 1];
                        }  
						 */
                        
                        // *********************** RFA Profit Center Reference has changed ***********************/
                        // Populate rfaList & recalculate share permission after the RFA profit center reference has been changed.
                        // Modified for FR1.93 by Gary Arsenian on 7/1/2013
                        if((rfa.ProfitCenterNumber__c <> Trigger.oldmap.get(rfa.id).profitCenterNumber__c && rfa.ProfitCenterNumber__c <> null && rfa.level__c!=RFAGlobalConstants.RETURN_TO_SENDER && rfa.Level__c!=RFAGlobalConstants.CAPITAL_MGMT_HOLD && rfa.Level__c!=RFAGlobalConstants.PENDING_BOARD_REVIEW)|| // If Profit Center Number has changed on the RFA OR 
                           (rfa.Level__c<>Trigger.oldMap.get(rfa.Id).level__c && rfa.level__c!=RFAGlobalConstants.RETURN_TO_SENDER && rfa.Level__c!=RFAGlobalConstants.CAPITAL_MGMT_HOLD && rfa.Level__c!=RFAGlobalConstants.PENDING_BOARD_REVIEW)|| // If RFA Level has changed on the RFA OR 
                           (rfa.RecordTypeId<>Trigger.oldMap.get(rfa.Id).RecordTypeId && rfa.level__c!=RFAGlobalConstants.RETURN_TO_SENDER && rfa.Level__c!=RFAGlobalConstants.CAPITAL_MGMT_HOLD && rfa.Level__c!=RFAGlobalConstants.PENDING_BOARD_REVIEW) || // If Record Type has changed on the RFA OR
                           ( (Trigger.oldMap.get(rfa.Id).Stage__c == RFAGlobalConstants.RFA_STAGE_CLOSED || Trigger.oldMap.get(rfa.Id).Stage__c == RFAGlobalConstants.RFA_STAGE_APPROVED || Trigger.oldMap.get(rfa.Id).Stage__c== RFAGlobalConstants.RFA_STAGE_REJECTED) && 
                            (rfa.Stage__c != RFAGlobalConstants.RFA_STAGE_CLOSED && rfa.Stage__c != RFAGlobalConstants.RFA_STAGE_APPROVED && rfa.Stage__c != RFAGlobalConstants.RFA_STAGE_REJECTED) ) )// if RFA Stage changes from a Closed Stage to an open RFA stage)
                        {
                            rfaSharetoDelete.put(rfa.Id,Trigger.oldmap.get(rfa.id).profitCenterNumber__c);
                            rfaList.add(rfa);
                        }
                        ///else if added by Ashwani for FR1.86
                        else if( rfa.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_GENERAL_REQUEST).Id && ((rfa.PrimaryDOACategorySubCategory__c <> Trigger.oldMap.get(rfa.Id).PrimaryDOACategorySubCategory__c) || (rfa.SecondDOACategorySubCategory__c <> Trigger.oldMap.get(rfa.Id).SecondDOACategorySubCategory__c) || (rfa.ThirdDOACategorySubCategory__c <> Trigger.oldMap.get(rfa.Id).ThirdDOACategorySubCategory__c))  && rfa.level__c!=RFAGlobalConstants.RETURN_TO_SENDER && rfa.Level__c!=RFAGlobalConstants.CAPITAL_MGMT_HOLD && rfa.Level__c!=RFAGlobalConstants.PENDING_BOARD_REVIEW)
                        {
                            rfaSharetoDelete.put(rfa.Id,Trigger.oldmap.get(rfa.id).profitCenterNumber__c);
                            rfaList.add(rfa);
                        }
                        // *********************** Stage EQUALS : "Closed" OR "Approved" OR "Rejected"************/
                        // generate PDF after RFA Stage is "Closed" or "Approved" Or "Rejected"
                        if((rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_CLOSED || rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_APPROVED || rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_CLOSED) && trigger.new.Size()==1 && rfa.Stage__c <> Trigger.oldMap.get(rfa.Id).Stage__c)
                        {
                            RFA_WS01_PDFGenerator.PDFGenerator(rfa.Id,UserInfo.getSessionId());
                            
                        }
                        
                        // *********************** RFA level has changed to pending board review***********************/
                        // Populate rfaList & recalculate share permission for all location coordinator at read only.
                        
                        if(rfa.Level__c==RFAGlobalConstants.PENDING_BOARD_REVIEW)
                        {
                            rfaIdsPendingReview.add(rfa.Id);
                        }
                        
                        // *********************** RFA level has changed to RETURN to SENDER or Capital Hold***********************/
                        // Populate rfaList & recalculate share permission for all location coordinator .
                        if(rfa.Level__c == RFAGlobalConstants.RETURN_TO_SENDER || rfa.Level__c==RFAGlobalConstants.CAPITAL_MGMT_HOLD)
                        {
                            rfaShareDeleteLvl.put(rfa.Id,Trigger.oldmap.get(rfa.id).profitCenterNumber__c);
                            rfaListLvlChange.add(rfa);
                            
                        } 
                        // ********************** RFA ReportingUnitNumber reference has changed ******************/    
                        // Populate rfaList & recalculate share permission after the RFA reporting unit reference has been changed.
                        System.debug('\n Primary reporting unit for new :'+rfa.PrimaryReportingUnitNumber__c);
                        System.debug('\n primary reporting unit for old :'+ Trigger.oldmap.get(rfa.id).PrimaryReportingUnitNumber__c);
                        if((rfa.PrimaryReportingUnitNumber__c <> Trigger.oldmap.get(rfa.id).PrimaryReportingUnitNumber__c  )|| (rfa.SecondReportingUnitNumber__c <> Trigger.oldmap.get(rfa.id).SecondReportingUnitNumber__c  )|| (rfa.ThirdReportingUnitNumber__c <> Trigger.oldmap.get(rfa.id).ThirdReportingUnitNumber__c ))
                        {
                            if(rfa.PrimaryReportingUnitNumber__c<>null)
                                rfaReportingUnitsIds.add(rfa.PrimaryReportingUnitNumber__c);
                            if(rfa.SecondReportingUnitNumber__c<>null)
                                rfaReportingUnitsIds.add(rfa.SecondReportingUnitNumber__c);
                            if(rfa.ThirdReportingUnitNumber__c<>null)
                                rfaReportingUnitsIds.add(rfa.ThirdReportingUnitNumber__c);
                            
                            rfaReportingUnitMap.put(rfa.Id,rfaReportingUnitsIds);
                            rfaListforReportingUnit.add(rfa);
                        }
                        //************************ Stage EQUALS: "Approved" OR "Rejected" OR "Closed"***********************/
                        //Added by Ashwani for FR1.93
                        // Add RFA to list of Completed RFAs to set all Location Coordinator access level to Read Only 
                        if((rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_CLOSED || rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_APPROVED || rfa.Stage__c== RFAGlobalConstants.RFA_STAGE_REJECTED))
                        {
                            rfaSetForCompletedRFAs.add(rfa.id);
                            
                        }
                        //************************ Stage EQUALS: "Return To Sender" ******************************/
                        // Notify Local Coordinator of RFA current level once the RFA is returned to Sender
                        // Commented by Ashwani for Additional FR related for FR1.54
                        
                        if(rfa.Level__c == RFAGlobalConstants.RETURN_TO_SENDER
                           && rfa.Level__c <> Trigger.oldMap.get(rfa.Id).Level__c
                           && RFA_AP05_RFATrigger.isFirstRun)
                        {                    
                            if(rfa.ProfitCenterNumber__c <> null)rfaMapForReturnToSender.put(rfa.Id, rfa.ProfitCenterNumber__c);  
                            if(rfa.PreviousLevel__c <> null)levelMap.put(rfa.Id, rfa.PreviousLevel__c); 
                        }  
                        
                        //*********************** Previous Level EQUALS : "Return To Sender" *********************/
                        // Notify Local coordinator that the RFA update has been completed and RFA has resumed from "Return To Sender"
                        
                        if(Trigger.oldMap.get(rfa.Id).Level__c == RFAGlobalConstants.RETURN_TO_SENDER
                           && rfa.Level__c <> Trigger.oldMap.get(rfa.Id).Level__c) 
                        {
                            if(rfa.ProfitCenterNumber__c <> null) rfaMapForPreviousReturnToSender.put(rfa.Id, rfa.ProfitCenterNumber__c);
                            if(rfa.Level__c <> null)levelMap.put(rfa.Id, rfa.Level__c);     
                        }                 
                        
                        // hash key for RFA current Stage and level
                        String newStageLevelKey = rfa.Stage__c + rfa.Level__c;
                        
                        /// hash key for RFA old Stage and level
                        String oldStagelevelKey = Trigger.oldMap.get(rfa.Id).Stage__c + Trigger.oldMap.get(rfa.Id).Level__c;
                        
                        //************************ Stage EQUALS: "Pre-Circulation" ******************************/
                        // Notify Local Coordinator of RFA current level once the RFA is sent to Pre-Circulation stage
                        if(rfa.Stage__c == RFAGlobalConstants.PRE_CIRCULATION
                           && (newStageLevelKey <> oldStagelevelKey || rfa.ProfitCenterNumber__c != Trigger.oldMap.get(rfa.id).ProfitCenterNumber__c) //Added by Ashwani for FR1.79 - July 1, 2013
                           && RFA_AP05_RFATrigger.isFirstRun
                           && Trigger.oldMap.get(rfa.Id).Level__c <> RFAGlobalConstants.RETURN_TO_SENDER // added by Ashwani for FR1.80 on May 13
                           && (rfa.Level__c <> RFAGlobalConstants.CAPITAL_MGMT_HOLD || rfa.Level__c <> RFAGlobalConstants.RETURN_TO_SENDER || rfa.Level__c <> RFAGlobalConstants.PENDING_BOARD_REVIEW)
                          )
                        {                    
                            rfaMapForPreCirculation.put(rfa.Id, rfa.ProfitCenterNumber__c);
                            levelMap.put(rfa.Id, rfa.Level__c);
                            
                        }
                        
                        //*********************** Stage EQUALS: "Post-Circulation" *****************************/
                        // Notify Local coordinator of RFA current level once the RFA is sent to Post Circulation Stage
                        if(rfa.Stage__c == RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE
                           && (newStageLevelKey <> oldStagelevelKey || rfa.ProfitCenterNumber__c != Trigger.oldMap.get(rfa.id).ProfitCenterNumber__c) //Added by Ashwani for FR1.79 - July 1, 2013
                           && RFA_AP05_RFATrigger.isFirstRun
                           && (rfa.Level__c <> RFAGlobalConstants.CAPITAL_MGMT_HOLD || rfa.Level__c <> RFAGlobalConstants.RETURN_TO_SENDER || rfa.Level__c <> RFAGlobalConstants.PENDING_BOARD_REVIEW))
                        {                    
                            rfaMapForPostCirculation.put(rfa.Id, rfa.ProfitCenterNumber__c);
                            levelMap.put(rfa.Id, rfa.Level__c);
                            
                        }
                        
                        
                        //*********************** Stage EQUALS: "Pending Board Review" **************************/
                        if(rfa.Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW && rfa.Level__c <> Trigger.oldMap.get(rfa.Id).Level__c)
                        {
                            rfaMapForPendingBoardReview.put(rfa.Id, rfa);   
                        }
                        
                        //*********************** Stage EQUALS: "Draft" OR "Return To Sender" *******************/
                        // Reset the accesslevel for KOrequester, Co-Creator or Primary point of contact to "Read" Access once the RFA Stage is 
                        // no longer "Draft" OR "Return To Sender"
                        if((rfa.Stage__c <> Trigger.oldMap.get(rfa.Id).Stage__c && Trigger.oldMap.get(rfa.Id).Stage__c == RFAGlobalConstants.RFA_STAGE_DRAFT)
                           || (Trigger.oldMap.get(rfa.Id).Level__c == RFAGlobalConstants.RETURN_TO_SENDER && rfa.Level__c <> Trigger.oldMap.get(rfa.Id).Level__c))
                        {
                            rfaIdsForSharingDeletion.add(rfa.Id);   
                        }
                        
                        // ********************** RFA Record Type reference has been changed ********************/
                        // Populate rfaListRecordTypeChange List if the RFA record Type reference has been changed
                        // Delete RFA old Capital Expenditure
                        if(rfa.RecordTypeId!=trigger.OldMap.get(rfa.Id).RecordTypeId  )
                        {
                            rfaListRecordTypeChange.add(rfa);
                            rfaIdsForDeleteCapitalExpenditure.add(rfa.id);
                            rfaIdsRecordTypeChange.add(rfa.id);
                            
                        }
                        
                        // ********************** RFA Initial Budget Year field value has been changed ********************/
                        // Populate rfaIdsInitialBudgetYearChange List if the RFA Initial Budget Year field value has been changed and not null
                        if(rfa.InitialBudgetYear__c!=trigger.OldMap.get(rfa.Id).InitialBudgetYear__c && rfa.InitialBudgetYear__c <> null)
                        {
                            rfaIdsInitialBudgetYearChange.add(rfa.id);
                        }
                    }
                    
                    // evaluate if info only users should receive notification
                    if(rfaIdsLvlStsChange.size()>0)
                    {
                        rfaHelper.processInfoOnlyNotificationFlag(rfaIdsLvlStsChange, trigger.oldMap);
                    }
                    
                    // update RFA Three Year Cash Spend related records after the RFA Initial Budget Year field is changed and not null
                    if(rfaIdsInitialBudgetYearChange.size()>0)
                    {
                        rfaHelper.rfaThreeYearCashSpendUpdate(rfaIdsInitialBudgetYearChange);
                    }
                    else if(rfaIdsRecordTypeChange.size()>0)
                    {
                        rfaHelper.rfaThreeYearCashSpendUpdate(rfaIdsRecordTypeChange);
                    }
                    
                    // update RFA capital expenditure after the RFA record type is changed
                    if(rfaListRecordTypeChange.size()>0)
                    {
                        
                        rfaHelper.processRFABeforeUpdateForCapitalExpenditure(rfaIdsForDeleteCapitalExpenditure);
                        rfaHelper.processRFAAfterInsertForCapitalExpenditure(rfaListRecordTypeChange);
                    }
                    // process RFA share delete permission
                    if (!rfaSharetoDelete.isEmpty())
                    {
                        rfaHelper.processRFABeforeShare(rfaSharetoDelete); 
                    }
                    system.debug('rfaReportingUnitMap'+rfaReportingUnitMap);
                    // process share records if reporting unit has been chaged
                    if(!rfaReportingUnitMap.isEmpty())
                    {
                        shareUtilCls.rfaReportingUnitChangeDelete(rfaReportingUnitMap); 
                    }
                    // Process RFA Share after update
                    if(rfaList.size()>0)
                    {
                        rfaHelper.processRFAProfitCenterShare(rfaList);
                    } 
                    
                    if(!rfaIdsForSharingDeletion.isEmpty())
                    {
                        rfaHelper.restrictAccessForKORequester(rfaIdsForSharingDeletion);       
                    }
                    if(!rfaShareDeleteLvl.IsEmpty())
                    {
                        shareUtilCls.rfaProfitCenterUpdateDeleteOldProfitCenter(rfaShareDeleteLvl);
                        
                    }
                    if(rfaSetForCompletedRFAs.size()>0) // Added by Ashwani for FR1.93
                    {
                        shareUtilCls.ModifyLocationCoordinatorAccess(rfaSetForCompletedRFAs);
                    }
                    if(!rfaListLvlChange.IsEmpty())
                    {
                        rfaHelper.processRFAProfitCenterShare(rfaListLvlChange);  
                    }
                    if(rfaListforReportingUnit.size()>0)
                    {
                        rfaHelper.processRFAReportingUnitShare(rfaListforReportingUnit);
                    } 
                    
                    if(!rfaMapForPreCirculation.isEmpty())
                    {
                        
                        // To -Do : Code logic for sending map as a param for sending out email communication to the local coordinators
                        rfaHelper.notifyLocalCoordinator(levelMap, rfaMapForPreCirculation);
                        RFA_AP05_RFATrigger.isFirstRun = false;
                    }
                    
                    if(!rfaMapForPostCirculation.isEmpty())
                    {
                        rfaHelper.notifyLocalCoordinator(levelMap, rfaMapForPostCirculation);  
                        RFA_AP05_RFATrigger.isFirstRun = false;
                    }  
                    
                    if(!rfaMapForPreviousReturnToSender.isEmpty())
                    {
                        rfahelper.notifyLocalCoordinatorAfterReturnToSender(levelMap, rfaMapForPreviousReturnToSender);
                    }
                    // Notify Local coordinator when the RFA Stage is "Return to Sender"
                    // Give edit permission to users with RowCause "KORequester__c"
                    system.debug('********* DEBUG ROYCASTILLO 111');
                    if(!rfaMapForReturnToSender.isEmpty())
                    {
                        // notify local coordinator of current level
                        
                        //commented by Ashwani for FR1.54 (Not to send email notification to Location Coordinator when RFA enters "Return to Sender" stage.)
                        //requirement FR1.37 Q3 Requirement - added this line to email Local Cooordinator if RFA enters "Return to Sender" - Roy Castillo Nov 6, 2013
                        system.debug('********* DEBUG ROYCASTILLO 2222');
                        system.debug('********* DEBUG rfaMapForReturnToSender :' + rfaMapForReturnToSender );
                        system.debug('********* DEBUG levelMap :' +levelMap );
                        system.debug('********* DEBUG calling  RFATriggerHelperClass.notifyLocalCoordinator2');
                        RFATriggerHelperClass.notifyLocalCoordinator2(levelMap, rfaMapForReturnToSender);
                        
                        // Notify Associated Co-creator and Primary Point of contact
                        rfaHelper.notifyRelatedUsers(rfaMapForReturnToSender.keySet()); 
                        // rowcause for KO requester
                        String koRequestRowCause = Schema.RFA__Share.RowCause.KORequestor__c;
                        
                        // iterate over RFA share records
                        for(RFA__Share shareRec : [Select ParentId, RowCause, AccessLevel From RFA__Share where ParentId IN: rfaMapForReturnToSender.keySet() AND rowcause = : koRequestRowCause])
                        {
                            // assign edit permission
                            shareRec.AccessLevel = 'Edit';
                            // add to list for bulk update
                            rfaShareForUpdateList.add(shareRec);
                        }
                        // Close in progress Approval provesses
                        Map<Id, ApprovalProcess__c> approvalProcessMap = RFA_AP03_ApprovalProcessHelper.getActiveProcessInstances(rfaMapForReturnToSender.keySet()); 
                        // reset Approval Workitems after the approval process is closed.   
                        if(!approvalProcessMap.isEmpty()) RFA_AP03_ApprovalProcessHelper.resetApprovalWorkItems(approvalProcessMap);                
                        
                        if(!rfaShareForUpdateList.isEmpty()) update rfaShareForUpdateList;
                        
                        // flag variable to false to prevent second run
                        RFA_AP05_RFATrigger.isFirstRun = false;
                    }
                    
                    // Notify Associated Co-creator and Primary POC when the RFA enters pending board Review
                    if(!rfaMapForPendingBoardReview.isEmpty())
                    {
                        rfaHelper.notifyRelatedUsers(rfaMapForPendingBoardReview.keySet());    
                    }
                    if(!rfaIdsPendingReview.IsEmpty())
                    {
                        shareUtilCls.rfaSharePendingBoardeview(rfaIdsPendingReview);
                    }
                    
                }// End of Else mpascua@coca-cola.com  
                
                
                
            }
            /******************************* AFTER UPDATE BLOCK ENDS *************************************/
            // Clear All List (Cache)
            rfaList.clear();
            rfaFunctionAREList.clear();
            rfaSharetoDelete.clear();
            rfaMapForPreCirculation.clear();
            rfaMapForPostCirculation.clear();
            levelMap.clear();
            rfaIdsForDeleteCapitalExpenditure.clear();
            rfaIdsRecordTypeChange.clear();
            rfaIdsInitialBudgetYearChange.clear();
            rfaListRecordTypeChange.clear();
            rfaLstLvlStsChange.clear();
            rfaShareForUpdateList.clear();
            rfaIdsPendingReview.clear();
            rfaSetForCompletedRFAs.clear();
            
        }
        /**************************************** AFTER BLOCK ENDS ************************************/
    }
    //added bulkify trigger update - Roy Castillo -Sept 2, 2013 for Policy Exemption Request
    else{
            if(trigger.IsBefore)
            {
                
                /************************************ BEFORE INSERT BLOCK STARTS *****************************************/
                
                if(trigger.IsInsert) 
                {
                    
                    //For Dummy Profit Center - RLC Aug 27, 2013 Q3 Requirements
                    rfaHelper.processRFADummyProfitCenter(Trigger.New);
                }
                
            }   
    }
    
}