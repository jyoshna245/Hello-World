/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_AP05_RFATrigger
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 05/14/2012
 *  Assumptions      : N/A
 *  Description      : To - Do
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
public class RFA_AP05_RFATrigger{
    
    private static Map<Id, String> recordTypeIdsMap =    new Map<ID, String>();
    private static Map<String, List<RFACapitalExpenditure__c>> capitalExpentureMap=new Map<String, List<RFACapitalExpenditure__c>>();  
    
    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP = RFAGlobalConstants.RECORDTYPESMAP;
    // variable for storing the SObject Record type mapping
    public static Map<String, RecordType> approverRecordTypeMap = RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
    
    public static Map<String, RecordType> rfaRecordTypeMap = RECORDTYPESMAP.get(Schema.sObjectType.RFA__c.getName());
    
    public static boolean isFirstRun = true;
    
    public rfa_Ap02_Shareutil shareUtil=new rfa_Ap02_Shareutil();
      
    
      //WrapperCapitalExpenditure
      public class wrapperCapitalExpenditure
      {
            public String recordTypeName;
            
      
      }
      
      
      // constructor for the class
      public RFA_AP05_RFATrigger()
      {
            recordTypeIdsMap = RFA_Util_RecordTypeHelper.getRecordTypeName(Schema.sObjectType.RFA__c.getName());
      } 
  
  
  /* New Validation function @validateRFAPPC has been created based on the enhancement. */
    public static Set<String> validateRFAPPC(RFA__c rfaObj, RFA__c oldRFAObj, boolean flag)
    {
        Set<String> errorSet = new Set<String>();
     if(oldRFAObj.LevelStage__c != null && oldRFAObj.LevelStage__c == 'Draft' && 
       rfaObj.LevelStage__c != 'Draft' && rfaObj.LevelStage__c != null && flag == true)
       {
            errorSet.add('Please add Primary Point of Contact User');
       }
  
    return errorSet;
    }
 /* Validation function @validateRFAPPC has been ended */
                
      
    //For RFA Policy Exemption Request default policy center is Dummy profit center - Roy Castillo
    // Aug 27,2013
                
    public void processRFADummyProfitCenter(list<RFA__C> rfaList)

       
    {
        for(RFA__c rfa : rfaList)
        {

            if(rfa.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id) 
            {
             (rfa.ProfitCenterNumber__c = System.Label.RFA_CL148);
            
                    }                
       
      }
      }
     
     //For RFA Policy Exemption Request no change or record type - Roy Castillo
    // Aug 27,2013
    public static boolean NoChangePolicyExemption(RFA__c rfa, RFA__c oldrfa )
    {
        Set<String> errorSet = new Set<String>();
        if ((rfa.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id))                               
        {
            system.debug('***'+ rfa.RecordTypeId );
    
            if(oldrfa.RecordTypeID != System.Label.RFA_CL155)
            {
                system.debug('*** Record Type' + rfa.RecordTypeID );
                system.debug('*** Label ID' + System.Label.RFA_CL155);
    
    
                errorSet.add(System.Label.RFA_CL153);
                rfa.adderror(System.Label.RFA_CL154);
                return true;
                
            }
        }
        else
        {
           system.debug('***'+ rfa.RecordTypeId );
    
            if(oldrfa.RecordTypeID == System.Label.RFA_CL155)
            {
                system.debug('*** Record Type' + rfa.RecordTypeID );
                system.debug('*** Label ID' + System.Label.RFA_CL155);
    
    
                //errorSet.add(System.Label.RFA_CL153);
                rfa.adderror(System.Label.RFA_CL154);
                return true;
            }
        
        }
          
   // return errorSet;
       return false;

    }
     
   //--------- For Policy Exemption Trigger Validation Fields - ROY Aug 30, 2013
     public static Set<String> validatePolicyExemptionRFA(RFA__c rfaObj, RFA__c oldRFAObj)
    {
        Set<String> errorSet = new Set<String>();
        
        //RFA_VR01_HighlyRestrictedRFAValidation
        if((rfaObj.Level__c <> oldRFAObj.Level__c || rfaObj.Stage__c <> oldRFAObj.Stage__c) && rfaObj.Stage__c <> 'Draft')
        {
            
                if(rfaObj.DataClassification__c == 'Highly Restricted')
                {
                    errorSet.add(System.Label.RFA_CL106);
                }
                
          
  /****************The system will validate that a Primary Point of Contact user has been added to 
                                the RFA upon the RFA leaving the Draft Level/Stage********************/                
           if(oldRFAObj.LevelStage__c != null && oldRFAObj.LevelStage__c == 'Draft' && 
            rfaObj.LevelStage__c != 'Draft' && rfaObj.LevelStage__c != null)
               {
               List<RFAUserRole__c> RFA_UR = [select id from RFAUserRole__c 
                                                where (RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id) 
                                                and RFA__c = :rfaObj.id ];//Checking records in Child object with respect to expected RT.
                   if (!(RFA_UR.size()>0)){
                        errorSet.add(System.Label.RFA_CL0133);
                   }
               }  
                
                
           //RFA_VR22_RequestSummaryRequired
                // validate if request type is Policy Exemption and Request Sumaary Field is Blank
                // FR1.11 - Roy Castillo - Aug 23, 2013
                

                if(RFAGlobalConstants.isBlank(rfaObj.Request_Summary__c))
                {
                    errorSet.add(System.Label.RFA_FR1_90);
                }
                
                
                
                 //RFA_VR23_ObjectRationaleRequired
                 // validate if request type is Policy Exemption and Object Rationale Field is Blank
                 // FR1.11 - Roy Castillo - Aug 23, 2013
                
               
                if(RFAGlobalConstants.isBlank(rfaObj.ObjectiveRationale__c))
                {
                    errorSet.add(System.Label.RFA_FR1_91);
                }
               
       
                //RFA_VR24_RiskCompensatingRequired
                 // validate if request type is Policy Exemption and Risk & Compensating Controls Field is Blank
                 // FR1.11 - Roy Castillo - Aug 23, 2013
                
                if(RFAGlobalConstants.isBlank(rfaObj.Risk_Compensating_Controls__c))

                {
                    errorSet.add(System.Label.RFA_FR1_92);
                }
                

                
                //RFA_VR25_FinancialImpactRequired
                 // validate if request type is Policy Exemption and Financial Impact Field is Blank
                 // FR1.11 - Roy Castillo - Aug 23, 2013
                

                if(RFAGlobalConstants.isBlank(rfaObj.Financial_Impact__c))

                {
                    errorSet.add(System.Label.RFA_FR1_93);
                }
                


                //RFA_VR26_PolicyExcerptImpactRequired
                // validate if request type is Policy Exemption and Policy Excerpt Field is Blank
                // FR1.10 - Roy Castillo - Aug 29, 2013
                
                 if(RFAGlobalConstants.isBlank(rfaObj.Policy_Excerpt__c))

                {
                    errorSet.add(System.Label.RFA_FR1_94);
                }


                //RFA_VR27_ExpirationDateRequired
                // validate if request type is Policy Exemption and Expiration Date Field is Blank
                //only when Policy Category Field value is not "Volume & Beverage Product Conversion" or "Unit Case Sales & Gallon Sales"
                // FR1.10 - Roy Castillo - Aug 29, 2013
                

                //if((rfaObj.Expiration_Date__c == null)&& (!RFAGlobalConstants.isBlank(rfaObj.Policy_Category__c )&&(rfaObj.Policy_Category__c != '3.6 - Unit Case Sales & Gallon Sales' ) && (rfaObj.Policy_Category__c != '3.4 - Volume & Beverage Product Conversion' )))
                // client's request to validate if expiration date comments is blank regardless of policy category value - RLC - April 30, 2014
               // if((rfaObj.Expiration_Date__c == null)&& (!RFAGlobalConstants.isBlank(rfaObj.Policy_Category__c )&&(rfaObj.Policy_Category__c != System.Label.RFA_FR1_98 ) && (rfaObj.Policy_Category__c != System.Label.RFA_FR1_99 ))) 
                    if((rfaObj.Expiration_Date__c == null)&& (!RFAGlobalConstants.isBlank(rfaObj.Policy_Category__c ))) 


                {
                    errorSet.add(System.Label.RFA_FR1_95);
                }
                

                //RFA_VR28_PolicyGroupRequired
                // validate if request type is Policy Exemption and Policy Ggroup Field is Blank
                //only when Policy Category Field value is not "Volume & Beverage Product Conversion" or "Unit Case Sales & Gallon Sales"
                // FR1.10 - Roy Castillo - Aug 29, 2013
                


                if(RFAGlobalConstants.isBlank(rfaObj.Policy_Group_Name__c))

                {
                    errorSet.add(System.Label.RFA_FR1_96);
                }
                
                
                //RFA_VR29_PolicyCategoryRequired
                // validate if request type is Policy Exemption and Polciy Category  Field is Blank
                // FR1.10 - Roy Castillo - Sept 5, 2013
                


                if(RFAGlobalConstants.isBlank(rfaObj.Policy_Category__c))

                {
                    errorSet.add(System.Label.RFA_FR1_97);
                }
                
                // RFA_VR30_ExpirationDateCommentRequired 
                // validate if Expiration Date Comment is blank Regardless of the value of Policy Category - RLC April 30, 2014 FR1_10
                
                 if(RFAGlobalConstants.isBlank(rfaObj.Comments_aboutr__c))

                {
                    errorSet.add(System.Label.RFA_CL1_10);
                }


           }     
                
        
        return errorSet;



    }
    //---------------- eol
     
     
  public static Set<String> validateRFA(RFA__c rfaObj, RFA__c oldRFAObj)
    {
        Set<String> errorSet = new Set<String>();
  
        //RFA_VR01_HighlyRestrictedRFAValidation
        if((rfaObj.Level__c <> oldRFAObj.Level__c || rfaObj.Stage__c <> oldRFAObj.Stage__c) && rfaObj.Stage__c <> 'Draft')
        {
            
                if(rfaObj.DataClassification__c == 'Highly Restricted')
                {
                    errorSet.add(System.Label.RFA_CL106);
                }
                
                 //RFA_VR05_DataClassificationRequired - commented out by BSA 02-April-2013 for REQ0412274 - Change Data Classification field on all RFA forms               
                 //if(RFAGlobalConstants.isBlank(rfaObj.DataClassification__c))
                //{
                //    errorSet.add(System.Label.RFA_CL110);
                //}
                
                
                   
                //RFA_VR02_RequestAmountRequired
                //Requirement #FR1.11
                //Description #skip this validation if Policy Exemption Request 
                //History     #Modified (Else To Else If) by Roy Castillo on Aug 15, 2013 
                
                if ((rfaObj.RecordTypeId != rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id))                
                {
                if(rfaObj.RequestAmountFunctionalCurrency__c == null)
                {
                    errorSet.add(System.Label.RFA_CL107);
                }
                }
                
                //RFA_VR03_FunctionalCurrencyRequired
                 //Requirement #FR1.11
                //Description #skip this validation if Policy Exemption Request 
                //History     #Modified (Else To Else If) by Roy Castillo on Aug 15, 2013 

                if ((rfaObj.RecordTypeId != rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id))                
                {
                if(RFAGlobalConstants.isBlank(rfaObj.Functional_Currency__c))
                {
                    errorSet.add(System.Label.RFA_CL108);
                }   
                }
                //RFA_VR04_AREMonthRequired
                // skip this validation if request type is Policy Exemption FR1.11
                
                if ((rfaObj.RecordTypeId != rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id))
                {

                if(RFAGlobalConstants.isBlank(rfaObj.AREMonth__c)||rfaObj.AREMonth__c=='Select ARE')
                {
                    errorSet.add(System.Label.RFA_CL109);
                }
                }
                
                
              
                                
                //RFA_VR06_InitialBudgetYearRequired
                if(RFAGlobalConstants.isBlank(rfaObj.InitialBudgetYear__c) 
                   && (rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_GROUP_CONSOLIDATED_PLAN).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPPR_REQUEST).Id))
                {
                    errorSet.add(System.Label.RFA_CL111);
                }
                
                //RFA_VR08_BudgetTypeRequired
                
                if(RFAGlobalConstants.isBlank(rfaObj.BudgetType__c) 
                   && (rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPPR_REQUEST).Id))
                {
                    errorSet.add(System.Label.RFA_CL113);
                }
                
                //RFA_VR07_CapitalPlanIndicatorRequired
                
                if(RFAGlobalConstants.isBlank(rfaObj.IsthisanAnnualCapitalPlanrequest__c)
                   && (rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPPR_REQUEST).Id))
                {
                    
                    errorSet.add(System.Label.RFA_CL112);
                }      
                
                //RFA_VR09_ExecutiveSummaryRequired
                
                //skip this validation if Policy Exemption Request FR1.11
               // system.debug('*****record type: ' + rfaObj.RecordTypeId );
                //system.debug('*****rfa map: ' + rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id);
                if ((rfaObj.RecordTypeId != rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id))
                {
                                
                if(RFAGlobalConstants.isBlank(rfaObj.ExecutiveSummary__c))
                {
                    errorSet.add(System.Label.RFA_CL114);
                }
                }
                // RFA_VR10_PrimaryDOAMandatory
                //skip this validation if Policy Exemption Request FR1.11

                if ((rfaObj.RecordTypeId != rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id))
                {

                if(RFAGlobalConstants.isBlank(rfaObj.PrimaryDOACategorySubCategory__c))
                {
                    errorSet.add(System.Label.RFA_CL115);
                }
                }
                //RFA_VR11_DOACategoryUniqueness
                
                if(!RFAGlobalConstants.isBlank(rfaObj.PrimaryDOACategorySubCategory__c) && !RFAGlobalConstants.isBlank(rfaObj.SecondDOACategorySubCategory__c))
                {
                    if(rfaObj.PrimaryDOACategorySubCategory__c == rfaObj.SecondDOACategorySubCategory__c)
                    {
                        errorSet.add(System.Label.RFA_CL116);   
                    }
                }
                
                else if(!RFAGlobalConstants.isBlank(rfaObj.SecondDOACategorySubCategory__c) && !RFAGlobalConstants.isBlank(rfaObj.ThirdDOACategorySubCategory__c))
                {
                    if(rfaObj.SecondDOACategorySubCategory__c == rfaObj.ThirdDOACategorySubCategory__c)
                    {
                            errorSet.add(System.Label.RFA_CL116);
                    }
                }
                
                else if(!RFAGlobalConstants.isBlank(rfaObj.ThirdDOACategorySubCategory__c) && !RFAGlobalConstants.isBlank(rfaObj.PrimaryDOACategorySubCategory__c))
                {
                    if(rfaObj.ThirdDOACategorySubCategory__c == rfaObj.PrimaryDOACategorySubCategory__c)
                    {
                            errorSet.add(System.Label.RFA_CL116);
                    }
                }
                //RFA_VR12_CapitalDOACategoryRestriction
                /* - commented DOA Category uniqueness validation rule by Ashwani on 26 Apr 2013 as per the requirement FR1.58
                if(!RFAGlobalConstants.isBlank(rfaObj.PrimaryDOACategorySubCategory__c) && !RFAGlobalConstants.isBlank(rfaObj.SecondDOACategorySubCategory__c))
                {
                    if(rfaObj.PrimaryDOACategorySubCategory__c.contains('Capital Expenditures') && rfaObj.SecondDOACategorySubCategory__c.contains('Capital Expenditures'))
                    {
                        errorSet.add(System.Label.RFA_CL117);   
                    }
                }
                
                else if(!RFAGlobalConstants.isBlank(rfaObj.PrimaryDOACategorySubCategory__c) && !RFAGlobalConstants.isBlank(rfaObj.ThirdDOACategorySubCategory__c))
                {
                    if(rfaObj.PrimaryDOACategorySubCategory__c.contains('Capital Expenditures') && rfaObj.ThirdDOACategorySubCategory__c.contains('Capital Expenditures'))
                    {
                        errorSet.add(System.Label.RFA_CL117);   
                    }
                }
                
                else if(!RFAGlobalConstants.isBlank(rfaObj.SecondDOACategorySubCategory__c) && !RFAGlobalConstants.isBlank(rfaObj.ThirdDOACategorySubCategory__c))
                {
                    if(rfaObj.SecondDOACategorySubCategory__c.contains('Capital Expenditures') && rfaObj.ThirdDOACategorySubCategory__c.contains('Capital Expenditures'))
                    {
                        errorSet.add(System.Label.RFA_CL117);   
                    }
                }
                */
                
                //RFA_VR15_UpdateCordAdmFields
                
                if(rfaObj.Level__c == 'Return To Sender'
                   && (rfaObj.CapitalManagementAdministered__c  <> oldRFAObj.CapitalManagementAdministered__c
                       || rfaObj.Ratification__c  <> oldRFAObj.Ratification__c 
                       || rfaObj.Comments__c  <> oldRFAObj.Comments__c
                       || rfaObj.IncludeInCapitalReports__c  <> oldRFAObj.IncludeInCapitalReports__c))
                {
                    errorSet.add(System.Label.RFA_CL118);
                    
                }       
                String rfaRecordTypeName=recordTypeIdsMap.get(rfaObj.RecordTypeId);
                System.debug('Three year cash spent total :'+rfaObj.ThreeYearCashSpendTotalFC__c);
                System.debug('RFA Request Amount total :'+rfaObj.RequestAmountFunctionalCurrency__c);

                // GA 5/13/2013: Added Stage != RFA_CL039 for FR1.83 enhancement during 2013 Q1 release
                if( (rfaRecordTypeName== System.Label.RFA_CL050  || rfaRecordTypeName == System.Label.RFA_CL051) &&
                    rfaObj.Stage__c != System.Label.RFA_CL039) // RFA_CL039 = Post-Circulation
                {
                    if (rfaObj.ThreeYearCashSpendTotalFC__c < rfaObj.RequestAmountFunctionalCurrency__c)
                    {                               
                        errorSet.add(System.Label.RFA_CL094 +' ' + (rfaObj.RequestAmountFunctionalCurrency__c - rfaObj.ThreeYearCashSpendTotalFC__c)+' ' + System.Label.RFA_CL096);
                    }
                    else if(rfaObj.ThreeYearCashSpendTotalFC__c > rfaObj.RequestAmountFunctionalCurrency__c)
                    {                               
                        errorSet.add(System.Label.RFA_CL094 +' '+ (rfaObj.ThreeYearCashSpendTotalFC__c - rfaObj.RequestAmountFunctionalCurrency__c)+' ' + System.Label.RFA_CL097);
                    }
                    
                    if (rfaObj.CapitalExpenditureTotalFC__c < rfaObj.RequestAmountFunctionalCurrency__c)
                    {                               
                        errorSet.add(System.Label.RFA_CL095 +' '+ (rfaObj.RequestAmountFunctionalCurrency__c - rfaObj.CapitalExpenditureTotalFC__c ) +' '+ System.Label.RFA_CL096);
                    }
                    else if(rfaObj.CapitalExpenditureTotalFC__c > rfaObj.RequestAmountFunctionalCurrency__c)
                    {                               
                        errorSet.add(System.Label.RFA_CL095 +' ' +(rfaObj.CapitalExpenditureTotalFC__c - rfaObj.RequestAmountFunctionalCurrency__c)+' ' + System.Label.RFA_CL097);
                    }
                } 
                /*
                Requirement #FR1.48
                Description #To bypass Request Amount (fc) Vs Three Year Cash Specnd validation for General Request RFAs.
                History     #Modified (Else To Else If) by ASHWANI KAUSHIK on 03-May-2013
                */ 
             
                else if (rfaRecordTypeName != System.Label.RFA_CL122 && rfaObj.Stage__c != System.Label.RFA_CL039)
                {
                    System.debug('Three year cash spent total :'+rfaObj.ThreeYearCashSpendTotalFC__c);
                    System.debug('RFA Request Amount total :'+rfaObj.RequestAmountFunctionalCurrency__c);
                    if (rfaObj.ThreeYearCashSpendTotalFC__c < rfaObj.RequestAmountFunctionalCurrency__c)
                    {                               
                        errorSet.add(System.Label.RFA_CL094 +' '+ (rfaObj.RequestAmountFunctionalCurrency__c - rfaObj.ThreeYearCashSpendTotalFC__c)+' ' + System.Label.RFA_CL096);
                    }
                    else if(rfaObj.ThreeYearCashSpendTotalFC__c > rfaObj.RequestAmountFunctionalCurrency__c)
                    {                               
                        errorSet.add( System.Label.RFA_CL094 +' '+ (rfaObj.ThreeYearCashSpendTotalFC__c - rfaObj.RequestAmountFunctionalCurrency__c) +' '+ System.Label.RFA_CL097);
                    }   
                }
            /****************The system will validate that a Primary Point of Contact user has been added to 
                                the RFA upon the RFA leaving the Draft Level/Stage********************/                
           if(oldRFAObj.LevelStage__c != null && oldRFAObj.LevelStage__c == 'Draft' && 
            rfaObj.LevelStage__c != 'Draft' && rfaObj.LevelStage__c != null)
               {
               List<RFAUserRole__c> RFA_UR = [select id from RFAUserRole__c 
                                                where (RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id) 
                                                and RFA__c = :rfaObj.id ];//Checking records in Child object with respect to expected RT.
                   if (!(RFA_UR.size()>0)){
                        errorSet.add(System.Label.RFA_CL0133);
                   }
               }
            /******************Draft Level/Stage validation End's here*****************************************/                
            
        }
        
        return errorSet;      
    }
    
    /**
      *  @ Description : method to process RFAs post insert operation. This method is called from Trigger.
      *  @ param : list<RFA__c>
      *  @ return : void
      */    
    public void processRFAAfterInsert(List<RFA__c> rfaInsertList)
    {
          // List of 3 year cash spent records for insert       
        List<ThreeYearCashSpend__c> threeYearCashSpendForInsert = new List<ThreeYearCashSpend__c>();
        // String variable to hold Additional Year text from custom label
        String additionalYears = System.label.RFA_CL070;
        for(RFA__c rfa : rfaInsertList)
        {
        
        // Added by mpascua@coca-cola.com for FR1.9 Policy Excemption does not generate Three Year Cash Spend
            // and does not Generate CAP expenditure chart
            if(rfa.RecordTypeId != rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id)
            {
            //----


            Date d =  Date.today();
            Integer year;
           
            /*
            Requirement #FR1.35
            Description #Three Year Cash Spend Table year must start with initial budget year.
            History     #Added by ASHWANI KAUSHIK on 18-Apr-2013
            */
            
            //Integer year = d.year();  - Commented by ASHWANI KAUSHIK on 18-Apr-2013 for FR1.35            
            // if(recordTypeIdsMap.get(rfa.RecordTypeId)!=System.label.RFA_CL122)
            //   {
               
               if(rfa.InitialBudgetYear__c!=null) year=Integer.Valueof(rfa.InitialBudgetYear__c);
                else year = d.year();
            // }            
            // else year = d.year();
            /* End */ 
            
            // Cash spent record for current Year
            threeYearCashSpendForInsert.add(new ThreeYearCashSpend__c(RFA__c= rfa.Id, Year__c=String.valueOf(year)));
            
            // Cash spent record for Current year + 1
            threeYearCashSpendForInsert.add(new ThreeYearCashSpend__c(RFA__c= rfa.Id, Year__c=String.valueOf(year + 1)));
            
            // Cash spent record for current year + 2
            threeYearCashSpendForInsert.add(new ThreeYearCashSpend__c(RFA__c= rfa.Id, Year__c=String.valueOf(year + 2)));
            
            // cash spent record for additional years.
            threeYearCashSpendForInsert.add(new ThreeYearCashSpend__c(RFA__c= rfa.Id, Year__c= additionalYears));
            
                
        
            if(!threeYearCashSpendForInsert.isEmpty())
            {
                Database.Saveresult [] result = RFA_Util_PerformDML.performInsOperation(threeYearCashSpendForInsert);
                
                for(Database.SaveResult saveResult : result)
                {
                    // To -Do : Define code logic for this block if(!result.isSuccess) throw Exception;
                }
                
            } 
         }     
        }
    }
    
    /**
      *  @ Description : method to update the year value on RFA Three Year Cash Spend related records. This method is called from Trigger.
      *  @ param : list<RFA__c>
      *  @ return : void
      */    
    public void rfaThreeYearCashSpendUpdate(Set<Id> rfaIdsInitialBudgetYearChange)
    {
        // List of 3 year cash spent records to update       
        List<ThreeYearCashSpend__c> threeYearCashSpendToUpdate = new List<ThreeYearCashSpend__c>();
        // String variable to hold Additional Year text from custom label
        String additionalYears = System.label.RFA_CL070;

        Date d =  Date.today();
        Integer year, i;


        for(RFA__c rfa : [Select ID, InitialBudgetYear__c,RecordTypeId, (Select Year__c From Three_Year_Cash_Spend__r WHERE Year__c != :additionalYears ORDER BY Year__c asc) From RFA__c r WHERE ID IN :rfaIdsInitialBudgetYearChange])
        {
            i = 0; // counter for year incrementation
            
            if(recordTypeIdsMap.get(rfa.RecordTypeId)!=System.label.RFA_CL122)
                  { 
                      if(rfa.InitialBudgetYear__c!=null) 
                               year=Integer.Valueof(rfa.InitialBudgetYear__c);
                     else 
                               year = d.year();
                  }
            else
                   year = d.year();
            
            //Assuming Three Year Cash Spend is ascending order by Year and does not include additional year based on for loop rfa object SOQL filter  
            //Update Three_Year_Cash_Spend__r.Year__c field value starting with RFA Initial Budget Year value and incrementing year accordingly.
            for (ThreeYearCashSpend__c TYCS: rfa.Three_Year_Cash_Spend__r)
            {
                TYCS.Year__c = String.valueOf(year + i++);
                threeYearCashSpendToUpdate.add(TYCS);
            }
        
            if(!threeYearCashSpendToUpdate.isEmpty())
            {
                Database.Saveresult [] result = RFA_Util_PerformDML.performUpdOperation(threeYearCashSpendToUpdate);
                
                for(Database.SaveResult saveResult : result)
                {
                    // To -Do : Define code logic for this block if(!result.isSuccess) throw Exception;
                }
                
            }   
        }
    }
 
    
    /**
      *  @ Description : method to process RFAs post insert operation for capital expenditure. This method is called from Trigger.
      *  @ param : list<RFA__c>
      *  @ return : void
      */    
    public void processRFAAfterInsertForCapitalExpenditure( List<RFA__c> rfaInsertList)
    {
         List<Capital_Expenditure__c> capitalExpenditureForInsert=new List<Capital_Expenditure__c>();
        for(RFA__c rfa : rfaInsertList)
        {
            // Added by mpascua@coca-cola.com for FR1.9 Policy Excemption does not generate Three Year Cash Spend
            // and does not Generate CAP expenditure chart
            if(rfa.RecordTypeId != rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id)
            {
            //----

            /************************************Capital Expenditure Entry **********************************************/
            String rfaRecordTypeName=recordTypeIdsMap.get(rfa.RecordTypeId);
            capitalExpentureMap=createCapitalExpenditure();
                  system.debug(rfa.RecordType.Name+'----record name--'+rfaRecordTypeName);
                  system.debug('\n capitalExpentureMap :'+capitalExpentureMap);
                  if(rfaRecordTypeName ==Label.RFA_CL051)
                  {                       
                        for(RFACapitalExpenditure__c tempMap:capitalExpentureMap.get(Label.RFA_CL051))              
                        {
                            capitalExpenditureForInsert.add(new Capital_Expenditure__c(RecordTypeId=tempMap.RecordTypeId__c ,Amount__c=0,AssetCategory__c=tempMap.AssetCategory__c,InvestmentObjectiveCategory__c=tempMap.InvestmentObjective__c,RFA__c=rfa.Id));
                            
                        }      
                       
                        
                  }
                  else if(rfaRecordTypeName ==Label.RFA_CL050)
                  {
                         
                          for(RFACapitalExpenditure__c tempMap:capitalExpentureMap.get(Label.RFA_CL050))              
                            {
                                capitalExpenditureForInsert.add(new Capital_Expenditure__c(RecordTypeId=tempMap.RecordTypeId__c ,Amount__c=0,AssetCategory__c=tempMap.AssetCategory__c,InvestmentObjectiveCategory__c=tempMap.InvestmentObjective__c,RFA__c=rfa.Id));
                                
                            }
                       
                  }
            
             }//---eol
            }
        
            if(!capitalExpenditureForInsert.isEmpty())
            {
                  Database.Saveresult [] result = RFA_Util_PerformDML.performInsOperation(capitalExpenditureForInsert);
                  
                  for(Database.SaveResult saveResult : result)
                  {
                        // To -Do : Define code logic for this block if(!result.isSuccess) throw Exception;
                  }
                 
            } 
    }
    
     /**
      *  @ Description : method to process RFAs if record type change at RFA level then delete the capital expenditure table. This method is called from Trigger.
      *  @ param : list<RFA__c>
      *  @ return : void
      */    
    public void processRFABeforeUpdateForCapitalExpenditure(Set<Id> rfaUpdateListIds)
    {
        List<Capital_Expenditure__c> capitalExpenditureForDelete=new List<Capital_Expenditure__c>();
        Set<Id> rfaIds=new Set<Id>();
        capitalExpenditureForDelete=[Select id from Capital_Expenditure__c where rfa__c IN: rfaUpdateListIds];
        System.debug('capitalExpenditureForDelete::::'+capitalExpenditureForDelete);
        if(!capitalExpenditureForDelete.isEmpty())
            {
                  Database.DeleteResult [] result = RFA_Util_PerformDML.performDelOperation(capitalExpenditureForDelete);
                  
                  for(Database.DeleteResult DeleteResult : result)
                  {
                        // To -Do : Define code logic for this block if(!result.isSuccess) throw Exception;
                  }
                 
            } 
        
    }

     /**
      *  @ Description : method to Capture Primary Contact, CO-CREATOR, Approver, Agents & Location Coordinator. This method is called from Trigger.
      *  @ param : RFA__c
      *  @ return : void
      */    
    
    public void captureEmailTempValues(RFA__c rfa, Map<Id, String> levelMap){
    // ********************** RFA Capture Primary Contact, CO-CREATOR, Approver, Agents & Location Coordinator  ********************/
    // Capture Primary Point of Contct Names Exist on current RFA record.
    // Capture Co-Creator Names Exist on current RFA record.
    // Capture Approver Names Exist on current RFA record.
    // Capture Agents Names Exist on current RFA record from respective RFA Approvers.
    set<ID> rtID = new set<ID>();
    rtID.add(approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id);
    rtID.add(approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id);
    rtID.add(approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id);
    set<String> uniqueLevels = new Set<String>();
    uniqueLevels.addAll(levelMap.values());
    
    
    string POC, CoCre, Approver, Agents, LocCoor;
    set<Id> UniqeVal = new set<Id>(); //Uniqe value of Creator, Co-Creator, and Primary Point of Contact
    UniqeVal.add(rfa.CreatedById);
    for(RFAUserRole__c rfaUser : [Select UserName__c, UserName__r.Name, Agent1__c, Agent1__r.Name, Agent2__c, Agent2__r.Name, 
                                   Agent3__c, Agent3__r.Name, RecordTypeId FROM RFAUserRole__c 
                                   where (RecordTypeId in: rtID ) and RFA__c =: rfa.Id])
    {
        if(rfaUser.RecordTypeId==approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id){
            Boolean res = UniqeVal.contains(string.valueof(rfaUser.UserName__c).substring(0,15));
            system.debug(' Set Comp Res ++' +res);
            system.debug(' Set Values ++' +UniqeVal);
              if(rfaUser.UserName__c!=null){// && !(UniqeVal.contains(string.valueof(rfaUser.UserName__c).substring(0,15)))){
                   if(POC==null){POC=rfaUser.UserName__r.Name;}
                   else{ POC = POC+', '+rfaUser.UserName__r.Name;}
                   UniqeVal.add(rfaUser.UserName__c);
              }
        }
        if(rfaUser.RecordTypeId==approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id){
              if(rfaUser.UserName__c!=null){// && !(UniqeVal.contains(string.valueof(rfaUser.UserName__c).substring(0,15)))){
                   if(CoCre==null){CoCre=rfaUser.UserName__r.Name;}
                   else{ CoCre = CoCre+', '+rfaUser.UserName__r.Name;}
                   UniqeVal.add(rfaUser.UserName__c);
              }
        }
        if(rfaUser.RecordTypeId==approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id){
              if(rfaUser.UserName__c!=null){
                   if(Approver==null){Approver=rfaUser.UserName__r.Name;}
                   else{ Approver = Approver+', '+rfaUser.UserName__r.Name;}
                   
                   if(rfaUser.Agent1__c!= null){
                          if(Agents==null){Agents=rfaUser.Agent1__r.Name;}
                          else{ Agents = Agents+', '+rfaUser.Agent1__c;}
                      }
                      if(rfaUser.Agent2__c!= null){
                          if(Agents==null){Agents=rfaUser.Agent2__r.Name;}
                          else{ Agents = Agents+', '+rfaUser.Agent2__r.Name;}
                      }
                      if(rfaUser.Agent3__c!= null){
                          if(Agents==null){Agents=rfaUser.Agent3__r.Name;}
                          else{ Agents = Agents+', '+rfaUser.Agent3__r.Name;}
                      }
              }
        }
        
    } 
    if(rfa.ProfitCenterName__c!=null)
    {
        for(ProfitCenterUserRole__c PCUR: [select ProfitCenter__c, UserName__c, UserName__r.Name from ProfitCenterUserRole__c 
                                           where Level__c IN: uniqueLevels 
                                           and  ProfitCenter__c =:rfa.ProfitCenterNumber__c 
                                           and  UserType__c ='Location Coordinator'])
        {
            if(PCUR.UserName__c!=null)
            {
                           if(LocCoor==null){LocCoor=PCUR.UserName__r.Name;}
                           else{ LocCoor = LocCoor+', '+PCUR.UserName__r.Name;}
            }
        }
    } 

    rfa.POC_Name__c = null;
    rfa.CO_CREATOR_Name__c = null;
    rfa.Approver_Name__c = null;
    rfa.Agents_Name__c = null;
    rfa.LOC_Name__c = null;
                      
    if(POC!=null)rfa.POC_Name__c = POC;
    if(CoCre!=null)rfa.CO_CREATOR_Name__c = CoCre;
    if(Approver!=null)rfa.Approver_Name__c = Approver;
    if(Agents!=null)rfa.Agents_Name__c = Agents;
    if(LocCoor!=null)rfa.LOC_Name__c = LocCoor;
    
    // ********************** RFA Capture Primary Contact, CO-CREATOR, Approver,Agents & Location Coordinator logic End here  ********************/
    }
    
    
    /**
      *  @ Description : This method contains logic to notify local ccordinator when the RFA has resumed from "Return To Sender"                    
      *  @ param : Set<String>, Map<String, RFA__c>
      *  @ return : void
      */
    public void notifyLocalCoordinatorAfterReturnToSender(Map<Id, String> levelMap,  Map<String, String> rfaMap)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        Set<String> profitCenterNumbers = new Set<String>();
        
        set<String> uniqueLevels = new Set<String>();
        
        profitCenterNumbers.addAll(rfaMap.values());
        
        uniqueLevels.addAll(levelMap.values());
        
        ProfitCenterUserRole__c[] profitCenterUserRoles = [Select Id, UserName__c, UserType__c, ProfitCenter__c, Level__c FROM ProfitCenterUserRole__c WHERE Level__c IN: uniqueLevels AND ProfitCenter__c IN: profitCenterNumbers AND UserType__c = 'Location Coordinator'];                                
        String breakString = '<BR/>';
        
        //************ PCLocationCoordinatorBU__c => 2. Business Unit ******************/
        //************ PCLocationCoordinatorCorporate__c => 4. Corporate ***************/
        //************ PCLocationCoordinatorExec__c => 5. Executive ********************/
        //************ PCLocationCoordinatorGroup__c => 3. Group ***********************/
        //************ PCLocationCoordinatorKO__c => 1. Key Operations *****************/
        //************ PCLocationCoordinatorSrExec__c => 6. Senior Executive ***********/
        for(String rfaId : rfaMap.keySet())
        {   
        
            for(ProfitCenterUserRole__c profitCenter : profitCenterUserRoles)
            {
                if(rfaMap.get(rfaId) == profitCenter.ProfitCenter__c && levelMap.get(rfaId).contains(profitCenter.Level__c))
                {
                    Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
               
                    mail.setTargetObjectId(profitCenter.UserName__c);
                    
                    mail.setWhatId(rfaId);
                    
                     System.debug('\ROYCASTILLO inside RETURN_TO_SENDER 123');    

                     mail.setTemplateId(RFAGlobalConstants.TEMPLATE_RFA_RESUMED_FROM_RETURNTOSENDER);

                    
                    mail.saveAsActivity = false;
                    
                    mail.orgWideEmailAddressId=Label.RFA_CL131; //-added by RSAS 11-Oct-2012
                    
                    mails.add(mail);    
                }
            }
        }                            
            if(!mails.isEmpty()) Messaging.sendEmail(mails);   
    }
    
        
     /**
      *  @ Description : This method contains logic to notify local ccordinator when the RFA Stage is set to
      *                  "Return To Sender" or "Pre-Circulation"                    
      *  @ param : Set<String>, Map<String, RFA__c>
      *  @ return : void
      */
    public void notifyLocalCoordinator(Map<Id, String> levelMap,  Map<String, String> rfaMap)
    {
        System.debug('\n level map :'+levelMap);
        System.debug('\n rfa map :'+rfaMap);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        Set<String> profitCenterNumbers = new Set<String>();
        Set<String> uniqueLevels = new Set<String>();
         
        //=========================START of Fix for INC0073461========================================== 
        RFA__c currRFA=[SELECT Id, Stage__c, LevelStage__c from RFA__c WHERE Id=:rfaMap.keyset() LIMIT 1];
        System.debug('\n RSAS currRFA ID:'+currRFA.Id);
        System.debug('\n RSAS currRFA LevelStage:'+currRFA.LevelStage__c);

        //=========================END of Fix for INC0073461==========================================                                      
                                              
        profitCenterNumbers.addAll(rfaMap.values());
        uniqueLevels.addAll(levelMap.values());
        
        System.debug('\n rowcause for the share :'+levelMap);
        System.debug('\n Rfa map :'+rfaMap);
        System.debug('\n Profit center set :'+profitCenterNumbers);
                                             
        ProfitCenterUserRole__c[] profitCenterUserRoles = [Select Id, UserName__c, UserType__c, ProfitCenter__c, Level__c FROM ProfitCenterUserRole__c WHERE Level__c IN: uniqueLevels AND ProfitCenter__c IN: profitCenterNumbers AND UserType__c = 'Location Coordinator'];                                
        String breakString = '<BR/>';
        
        //************ PCLocationCoordinatorBU__c => 2. Business Unit ******************/
        //************ PCLocationCoordinatorCorporate__c => 4. Corporate ***************/
        //************ PCLocationCoordinatorExec__c => 5. Executive ********************/
        //************ PCLocationCoordinatorGroup__c => 3. Group ***********************/
        //************ PCLocationCoordinatorKO__c => 1. Key Operations *****************/
        //************ PCLocationCoordinatorSrExec__c => 6. Senior Executive ***********/
        for(String rfaId : rfaMap.keySet())
        {   
            
                
            for(ProfitCenterUserRole__c profitCenter : profitCenterUserRoles)
            {
                if(rfaMap.get(rfaId) == profitCenter.ProfitCenter__c && levelMap.get(rfaId).contains(profitCenter.Level__c))
                {
                    Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
               
                    mail.setTargetObjectId(profitCenter.UserName__c);
                    mail.setWhatId(rfaId);
                     
                    //=========================START of Fix for INC0073461==========================================
                    System.debug('\n RSAS value of levelMap.get(rfaId): ' +levelMap.get(rfaId) ) ;           
                    System.debug('\n RSAS value of currRFA Stage:'+currRFA.Stage__c); 
                   
                    if(levelMap.get(rfaId) == RFAGlobalConstants.RETURN_TO_SENDER)
                    {
                         System.debug('\ROYCASTILLO inside RETURN_TO_SENDER');    
                         //mail.setTemplateId(RFAGlobalConstants.RETURN_TO_SENDER2);
                         mail.setTemplateId(RFAGlobalConstants.TEMPLATE_RETURN_TO_SENDER); 
                         mail.saveAsActivity = false; 
                    }                       
                       //else if(levelMap.get(rfaId) == RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE) //- orig code commented out by RSAS 10-Oct-2012
                       else if(currRFA.Stage__c== RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE) 
                        {
                        System.debug('\n RSAS inside RFA_POST_CIRCULATION_STAGE');   
                        mail.setTemplateId(Label.RFA_CL043);
                        mail.saveAsActivity = false; //-added by RSAS 10-Oct-2012
                        }
                    else 
                    { 
                    
                     System.debug('\n RSAS inside else TEMPLATE_PRE_CIRCULATION') ;  
                     mail.setTemplateId(RFAGlobalConstants.TEMPLATE_PRE_CIRCULATION);
                     mail.saveAsActivity = false;
                    }
                    mail.orgWideEmailAddressId=Label.RFA_CL131; //-added by RSAS 11-Oct-2012 for INC0075225
                    mails.add(mail); 
                    //=========================END of Fix for INC0073461========================================== 
                }
            }
        }                            
            if(!mails.isEmpty()) Messaging.sendEmail(mails);   
    }
   
    
    
    
     public void processRFABeforeShare(Map<Id,Id> rfaList)
    {
        rfa_Ap02_Shareutil shareUtilCls=new rfa_Ap02_Shareutil();
        shareUtilCls.rfaProfitCenterUpdateDeleteOldProfitCenter(rfaList); 
    
    }
  
    
    
     /**
      *  @ Description : This method contains logic to notify Co-Creator and Primary POC when the RFA Stage is set to
      *                  "Return To Sender"                 
      *  @ param : Set<String>, Map<String, RFA__c>
      *  @ return : void
      */
    public void notifyRelatedUsers(Set<String> rfaId)
    {
        List<RFAUserRole__c> userRolesForUpdate = new List<RFAUserRole__c>();
        for(RFAUserRole__c userRole : [Select Id, UserName__c, Level__c, NotifyUsers__c FROM RFAUserRole__c 
                                       WHERE (RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id
                                       OR RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)                                                  
                                       AND RFA__c IN: rfaId ])
        {
            userRole.NotifyUsers__c = true;
            userRolesForUpdate.add(userRole);
        }
        if(!userRolesForUpdate.isEmpty()) update userRolesForUpdate;
    }
  
  
    public void processInfoOnlyNotificationFlag(Set<Id> rfaIds, Map<Id, RFA__c> oldRFAMap)
    {
        List<RFAUserRole__c> infoOnlyForUpdate = new List<RFAUserRole__c>();
        for(RFAUserRole__c userRole: [SELECT Id, RFA__c, Level__c, RFA_Level__c, NotifyUsers__c, RFAStage__c, RFA_Current_Level__c FROM RFAUserRole__c
                                        WHERE RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id AND
                                        Notifyuserfirsttime__c = false AND 
                                        RFA_Level__c != :RFAGlobalConstants.CAPITAL_MGMT_HOLD AND
                                        RFA_Level__c != :RFAGlobalConstants.RETURN_TO_SENDER AND
                                        RFAStage__c != :RFAGlobalConstants.RFA_STAGE_DRAFT AND
                                        RFA__c IN :rfaIds])
        {
            // Obtain old RFA Stage value
            String oldRFAStage = oldRFAMap.get(userRole.RFA__c).Stage__c;
            String oldRFALevel = oldRFAMap.get(userRole.RFA__c).Level__c;
            
            // if RFA Level/Stage did not change from Draft and not from Return to Sender and not from Capital Management Hold and...
            // ( if RFA Level = Info Only Level and Stage != Pre-Circulation and != null or if Info Only level is less than RFA level)
            // mark Info Only record to send notification 
            if ( oldRFAStage != RFAGlobalConstants.RFA_STAGE_DRAFT && oldRFALevel != RFAGlobalConstants.RETURN_TO_SENDER && oldRFALevel != RFAGlobalConstants.CAPITAL_MGMT_HOLD && 
                        ((shareUtil.compareRFALevel(userRole.Level__c, userRole.RFA_Current_Level__c) == 0 && userRole.RFAStage__c != RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE && userRole.RFAStage__c != null) ||
                        shareUtil.compareRFALevel(userRole.Level__c, userRole.RFA_Current_Level__c) < 0 || userRole.RFA_Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW || 
                        userRole.RFAStage__c == RFAGlobalConstants.RFA_STAGE_CLOSED || userRole.RFAStage__c == RFAGlobalConstants.RFA_STAGE_APPROVED || userRole.RFAStage__c == RFAGlobalConstants.RFA_STAGE_REJECTED))
            {
                userRole.NotifyUsers__c = true;
                infoOnlyForUpdate.add(userRole);
            }
        }
        if(!infoOnlyForUpdate.isEmpty()) update infoOnlyForUpdate;
    }
    
    
     /**
      *  @ Description : This method contains logic to flag Co-Creator and primary POC true, so that email communication could be sent
      *  @ param : Set<String>
      *  @ return : void
      */
    public void processRFABeforeInsert(List<RFA__c> rfaInsertList)
    {
        Set<id> profitCenterIds=new Set<Id>();
        Map<Id, String> profitCenterMap=new Map<Id, String>();
        Set<String> functionCurrencyIds=new Set<String>();
         
        for(RFA__c rfa:rfaInsertList)
        {
            profitCenterIds.add(rfa.profitCenterNumber__c);
            
            if(rfa.Functional_Currency__c!=null && rfa.AREMonth__c!=null)
            {
                functionCurrencyIds.add(rfa.Functional_Currency__c);
            }
            
            
        }
        
        for(ProfitCenter__c profitCenter: [Select id, name,MinLevel__c from ProfitCenter__c where id IN: profitCenterIds] )
        {
            profitCenterMap.put(profitCenter.Id, profitCenter.MinLevel__c );
        
        }
        
        for(RFA__c rfa:rfaInsertList)
        {
            rfa.Level__c=profitCenterMap.get(rfa.profitCenterNumber__c);
            rfa.PreviousLevel__c=null;
            System.debug('profitCenterMap.get(rfa.profitCenterNumber__c)++++++++'+profitCenterMap.get(rfa.profitCenterNumber__c));
        }
        
        if(!functionCurrencyIds.isEmpty()) processRecordsForFunctionalCurrency(functionCurrencyIds, rfaInsertList);
    }
    
     
    public void restrictAccessForKORequester(Set<String> rfaIds)
    {
        List<RFA__Share> rfaShareForUpdate = new List<RFA__Share>();    
        for(RFA__Share rfaShare :[Select Id, parentId, UserOrGroupId, Accesslevel FROM RFA__Share Where parentId IN : rfaIds AND RowCause = : Schema.RFA__Share.RowCause.KORequestor__c])
        {
            rfaShare.Accesslevel = 'Read';
            rfaShareForUpdate.add(rfaShare);
        }
        if(!rfaShareForUpdate.isEmpty())update rfaShareForUpdate;
    }
     
    public Map<String,List<RFACapitalExpenditure__c>> createCapitalExpenditure()
    {
        List<RFACapitalExpenditure__c> listSPR=new List<RFACapitalExpenditure__c >();
        List<RFACapitalExpenditure__c> listCPR=new List<RFACapitalExpenditure__c >();
        Map<String, List<RFACapitalExpenditure__c>> tempMap=new map<String,List<RFACapitalExpenditure__c>>();
        listSPR=[Select AssetCategory__c,InvestmentObjective__c,RecordTypeId__c FROM RFACapitalExpenditure__c where name like 'SPR%'];
        listCPR=[Select AssetCategory__c,InvestmentObjective__c,RecordTypeId__c FROM RFACapitalExpenditure__c where name like 'CPR%'];
        if(listSPR.size()>0)
            tempMap.put('Small Project Request',listSPR);
        if(listCPR.size()>0)
            tempMap.put('Capital Project Request',listCPR);
        return tempMap;
    
    }
    
    
    /*public void processRFANewLevel() 
    {
        
    }*/
    public void processRFAProfitCenterShare(List<rfa__c> rfaList)
    {
            rfa_Ap02_Shareutil shareUtilCls=new rfa_Ap02_Shareutil();
            Map<Id, Map<Id,String>> profitCenterUserRolesAccess= new Map<Id, Map<Id,String>>();
            Map<Id,String> profitCenterUserRolesAtRfaLevel= new Map<Id,String>();
            for(RFA__c rfa: rfaList)
            {
                if(rfa.Level__c == RFAGlobalConstants.RETURN_TO_SENDER || rfa.Level__c==RFAGlobalConstants.CAPITAL_MGMT_HOLD)
                    profitCenterUserRolesAtRfaLevel.put(rfa.ProfitCenterNumber__c,rfa.PreviousLevel__c);
                else
                    profitCenterUserRolesAtRfaLevel.put(rfa.ProfitCenterNumber__c,rfa.Level__c);
                if(!profitCenterUserRolesAtRfaLevel.IsEmpty())
                    profitCenterUserRolesAccess.put(rfa.Id, profitCenterUserRolesAtRfaLevel);
                
            }
            system.debug('profitCenterUserRolesAtRfaLevel'+profitCenterUserRolesAtRfaLevel);
            if(!profitCenterUserRolesAccess.IsEmpty())
            {
                //Modified by Ashwani for FR1.86 - added rfaList new parameter
                shareUtilCls.profitCenterAtRfaCreateShare(profitCenterUserRolesAccess);
            }
            
    }
    public void processRFAReportingUnitShare(List<rfa__c> rfaList)
    {
        Map<Id,Set<Id>> reportingUnitMap=new Map<Id,Set<Id>>(); 
        Set<Id> reportingUnitSet=new Set<Id>();
        rfa_Ap02_Shareutil shareUtilCls=new rfa_Ap02_Shareutil();
        for(RFA__c rfa: rfaList)
        {
            if(rfa.PrimaryReportingUnitNumber__c<>null)
                reportingUnitSet.add(rfa.PrimaryReportingUnitNumber__c);
            if(rfa.SecondReportingUnitNumber__c<>null)
                reportingUnitSet.add(rfa.SecondReportingUnitNumber__c);
            if(rfa.ThirdReportingUnitNumber__c<>null)
                reportingUnitSet.add(rfa.ThirdReportingUnitNumber__c);
            reportingUnitMap.put(rfa.id,reportingUnitSet);
        }
        if(reportingUnitMap.size()>0)
        {
            shareUtilCls.reportingUnitCreteShare(reportingUnitMap);
        }   
     
        
    }
    public void processRFAOwnerShare(List<rfa__c> rfaList)
    {
        Map<Id, Id> OwneridAccess=new map<Id,Id>();
        rfa_Ap02_Shareutil shareUtilCls=new rfa_Ap02_Shareutil();
        for(RFA__c rfa: rfaList)
        { 
            OwneridAccess.put(rfa.id,Rfa.CreatedById);
            
        }
        system.debug('KO requestor Class'+OwneridAccess);
        if(OwneridAccess.size()>0)
        {
            shareUtilCls.rfaCreate(OwneridAccess);
        }
       
    }
   
    
    
    
    
    public void processRecordsForFunctionalCurrency(Set<String> functionCurrencyIds, List<RFA__c> rfaList)
    {
        Map<Id,Map<String,Decimal>> functionalCurrencyMap=new Map<Id,Map<String,Decimal>>();
        
        Map<String,Decimal> monthARERecords=new Map<String,Decimal>();
      
        for(ARE_rfa__c ARE: [SELECT April_Rate__c,August_Rate__c,BP_Rate__c,Country__c,December_Rate__c,February_Rate__c,Id,IsDeleted,JanuaryRate__c,July_Rate__c,June_Rate__c,LastModifiedById,LastModifiedDate,March_Rate__c,May_Rate__c,Name,November_Rate__c,October_Rate__c,OwnerId,September_Rate__c FROM ARE_rfa__c where Id IN:functionCurrencyIds ])
        {
            monthARERecords.put('January',ARE.JanuaryRate__c);
            monthARERecords.put('February',ARE.February_Rate__c);
            monthARERecords.put('March',ARE.March_Rate__c);
            monthARERecords.put('April',ARE.April_Rate__c);
            monthARERecords.put('May',ARE.May_rate__c);
            monthARERecords.put('June',ARE.June_Rate__c);
            monthARERecords.put('July',ARE.July_Rate__c);
            monthARERecords.put('August',ARE.August_Rate__c);
            monthARERecords.put('September',ARE.September_Rate__c);
            monthARERecords.put('October',ARE.October_Rate__c);
            monthARERecords.put('November',ARE.November_Rate__c);
            monthARERecords.put('December',ARE.December_Rate__c);
            monthARERecords.put('Business Plan',ARE.BP_Rate__c);
            monthARERecords.put('Select ARE',1.00);
            functionalCurrencyMap.put(ARE.id,monthARERecords);
        }
        for(RFA__c rfa: rfaList)
        {
            if(rfa.Functional_Currency__c!=null && rfa.AREMonth__c!=null)
            {
                rfa.ARERate__c= functionalCurrencyMap.get(rfa.Functional_Currency__c).get(rfa.AREMonth__c);
            }   
        }
        
    }
    
    public void processRecordsForFunctionalCurrency(List<RFA__c> rfaList)
    {

        Set<Id> functionCurrencyIds=new Set<id>();
        Map<Id,Map<String,Decimal>> functionalCurrencyMap=new Map<Id,Map<String,Decimal>>();
        Map<String,Decimal> monthARERecords=new Map<String,Decimal>();
        for(RFA__c rfa: rfaList)
        {
            if(rfa.Functional_Currency__c!=null && rfa.AREMonth__c!=null)
            {
                functionCurrencyIds.add(rfa.Functional_Currency__c);
            }
        }
        
        for(ARE_rfa__c ARE: [SELECT April_Rate__c,August_Rate__c,BP_Rate__c,Country__c,December_Rate__c,February_Rate__c,Id,IsDeleted,JanuaryRate__c,July_Rate__c,June_Rate__c,LastModifiedById,LastModifiedDate,March_Rate__c,May_Rate__c,Name,November_Rate__c,October_Rate__c,OwnerId,September_Rate__c FROM ARE_rfa__c where Id IN:functionCurrencyIds ])
        {
            monthARERecords.put('January',ARE.JanuaryRate__c);
            monthARERecords.put('February',ARE.February_Rate__c);
            monthARERecords.put('March',ARE.March_Rate__c);
            monthARERecords.put('April',ARE.April_Rate__c);
            monthARERecords.put('May',ARE.May_rate__c);
            monthARERecords.put('June',ARE.June_Rate__c);
            monthARERecords.put('July',ARE.July_Rate__c);
            monthARERecords.put('August',ARE.August_Rate__c);
            monthARERecords.put('September',ARE.September_Rate__c);
            monthARERecords.put('October',ARE.October_Rate__c);
            monthARERecords.put('November',ARE.November_Rate__c);
            monthARERecords.put('December',ARE.December_Rate__c);
            monthARERecords.put('Business Plan',ARE.BP_Rate__c);
            monthARERecords.put('Select ARE',1.00);
            functionalCurrencyMap.put(ARE.id,monthARERecords);
        }
        for(RFA__c rfa: rfaList)
        {
            if(rfa.Functional_Currency__c!=null && rfa.AREMonth__c!=null)
            {
                rfa.ARERate__c= functionalCurrencyMap.get(rfa.Functional_Currency__c).get(rfa.AREMonth__c);
            }   
        }
        
    }

    
    
    /**
      *  @ Description : This method contains logic to Update the Time Spent in Each Level/Stage field for RFA and the Last Level/Status Change Date
                                 Takes the List of New RFAs and Map of old instance of the RFA as input argument.             
      *  @ param : List<RFA__c>, Map<Id, RFA__c> 
      *  @ return : void
      */
    public void rfaAgingCalculation(List<RFA__c> rfaLstLvlStsChange, Map<Id, RFA__c> rfaLstLvlStsChangeOld)
    {
        for(RFA__c rfa : rfaLstLvlStsChange)
        {
        
            if (rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Draft')
            {
              //  if(rfa.TECH_TimeInDraft__c != NULL)
                //    rfa.TECH_TimeInDraft__c += (System.Now().getTime() - rfa.CreatedDate.getTime());
               // else
                    rfa.TECH_TimeInDraft__c = (System.Now().getTime() - rfa.CreatedDate.getTime());
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW && (rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == Null || rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c ==''))
            {
                if(rfa.TECH_TimeInPendBoardReview__c != NULL)
                    rfa.TECH_TimeInPendBoardReview__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                else
                    rfa.TECH_TimeInPendBoardReview__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == RFAGlobalConstants.CAPITAL_MGMT_HOLD && (rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == Null || rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c ==''))
            {
                if(rfa.TECH_TimeInCapMgmtHold__c != NULL)
                    rfa.TECH_TimeInCapMgmtHold__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                else
                    rfa.TECH_TimeInCapMgmtHold__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == RFAGlobalConstants.RETURN_TO_SENDER && (rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == Null || rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c ==''))
            {
                if(rfa.TECH_TimeInReturnToSender__c != NULL)
                    rfa.TECH_TimeInReturnToSender__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                else
                    rfa.TECH_TimeInReturnToSender__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '1. Key Operations' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Pre-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInKeyOpsPreCirculation__c != NULL)
                        rfa.TECH_TimeInKeyOpsPreCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInKeyOpsPreCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '1. Key Operations' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInKeyOpsCirculation__c != NULL)
                        rfa.TECH_TimeInKeyOpsCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInKeyOpsCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '1. Key Operations' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Post-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInKeyOpsPostCirculation__c != NULL)
                        rfa.TECH_TimeInKeyOpsPostCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInKeyOpsPostCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '2. Business Unit' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Pre-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInBUPreCirculation__c != NULL)
                        rfa.TECH_TimeInBUPreCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInBUPreCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '2. Business Unit' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInBUCirculation__c != NULL)
                        rfa.TECH_TimeInBUCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInBUCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '2. Business Unit' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Post-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInBUPostCirculation__c != NULL)
                        rfa.TECH_TimeInBUPostCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInBUPostCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '3. Group' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Pre-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInGroupPreCirculation__c != NULL)
                        rfa.TECH_TimeInGroupPreCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInGroupPreCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '3. Group' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInGroupCirculation__c != NULL)
                        rfa.TECH_TimeInGroupCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInGroupCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '3. Group' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Post-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInGroupPostCirculation__c != NULL)
                        rfa.TECH_TimeInGroupPostCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInGroupPostCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '4. Corporate' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Pre-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInCorporatePreCirculation__c != NULL)
                        rfa.TECH_TimeInCorporatePreCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInCorporatePreCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '4. Corporate' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInCorporateCirculation__c != NULL)
                        rfa.TECH_TimeInCorporateCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInCorporateCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '4. Corporate' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Post-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInCorporatePostCirculation__c != NULL)
                        rfa.TECH_TimeInCorporatePostCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInCorporatePostCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '5. Executive' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Pre-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInExecutivePreCirculation__c != NULL)
                        rfa.TECH_TimeInExecutivePreCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInExecutivePreCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '5. Executive' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInExecutiveCirculation__c!=null)
                        rfa.TECH_TimeInExecutiveCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInExecutiveCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    
                }
            }            
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '5. Executive' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Post-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInExecutivePostCirculation__c!=null)
                        rfa.TECH_TimeInExecutivePostCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInExecutivePostCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '6. Senior Executive' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Pre-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {    
                    if(rfa.TECH_TimeInSrExecPreCirculation__c!=null)
                        rfa.TECH_TimeInSrExecPreCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                   else
                       rfa.TECH_TimeInSrExecPreCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '6. Senior Executive' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInSrExecCirculation__c!=null)
                        rfa.TECH_TimeInSrExecCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                   else
                         rfa.TECH_TimeInSrExecCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                   
                }
            }
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '6. Senior Executive' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Post-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInSrExecPostCirculation__c!=null)
                        rfa.TECH_TimeInSrExecPostCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                   else
                       rfa.TECH_TimeInSrExecPostCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                
                }
            }
            
            rfa.TECH_LastStatusChangeDate__c = System.Now();
        }        
    }
    
    /**
      *  @ Description : This method contains logic to Validate whether Request Amount and Three Year Cash Spend Total and/ or Capital Expenditure Total
                                 are equal or not. If not equal throw the error message to the user.         
      *  @ param : List<RFA__c>
      *  @ return : void
      */
      /*
    public void validateAmount(List<RFA__c> rfaLstLvlStsChange)
    {        
        for(RFA__c rfa : rfaLstLvlStsChange)
        {
            String rfaRecordTypeName=recordTypeIdsMap.get(rfa.RecordTypeId);
            
            if (rfa.Stage__c != RFAGlobalConstants.RFA_STAGE_DRAFT)
                    {
                        if(  rfaRecordTypeName== System.Label.RFA_CL050  || rfaRecordTypeName == System.Label.RFA_CL051 )
                        {
                            if (rfa.ThreeYearCashSpendTotalFC__c < rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL094 +' ' + (rfa.RequestAmountFunctionalCurrency__c - rfa.ThreeYearCashSpendTotalFC__c)+' ' + System.Label.RFA_CL096);
                            }
                            else if(rfa.ThreeYearCashSpendTotalFC__c > rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL094 +' '+ (rfa.ThreeYearCashSpendTotalFC__c - rfa.RequestAmountFunctionalCurrency__c)+' ' + System.Label.RFA_CL097);
                            }
                            
                            if (rfa.CapitalExpenditureTotalFC__c < rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL095 +' '+ (rfa.RequestAmountFunctionalCurrency__c - rfa.CapitalExpenditureTotalFC__c ) +' '+ System.Label.RFA_CL096);
                            }
                            else if(rfa.CapitalExpenditureTotalFC__c > rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL095 +' ' +(rfa.CapitalExpenditureTotalFC__c - rfa.RequestAmountFunctionalCurrency__c)+' ' + System.Label.RFA_CL097);
                            }
                            
                        }
                        else
                        {
                            if (rfa.ThreeYearCashSpendTotalFC__c < rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL094 +' '+ (rfa.RequestAmountFunctionalCurrency__c - rfa.ThreeYearCashSpendTotalFC__c)+' ' + System.Label.RFA_CL096);
                            }
                            else if(rfa.ThreeYearCashSpendTotalFC__c > rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError( System.Label.RFA_CL094 +' '+ (rfa.ThreeYearCashSpendTotalFC__c - rfa.RequestAmountFunctionalCurrency__c) +' '+ System.Label.RFA_CL097);
                            }   
                        }
                    }
                }
            }    
       */
}