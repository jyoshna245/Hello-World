/*
    Class Name     : WebService for getRFADetail    
    Date Created   : 06/09/2012
    Description      : This is our WebService Class to send the RFA Details ALong with Approver and Previous Recommendation
    Version           : 3.0
*/
global class RFA_WS03_KOApprove_getRFADetails  {
   
    // WebService to get RFADeatils for given rfaId
    WebService static rfaWrapperDetails getDetails(Id rfaId, String federationId) 
    {
            /*~~~~Start of Variable Initialization~~~~*/
            rfaWrapperDetails result=new rfaWrapperDetails();
            StatusMessageWrapper message=new StatusMessageWrapper();
            RFA_Util_ObjectQuery qry = New RFA_Util_ObjectQuery(); // Instance of the Util class to call the query methods
            String statusCode;
            String statusDescription;
            RFA__c rfaObj;
            List<YearAmountList> yearAmountList=new List<YearAmountList>();
            List<ThreeYearCashSpend> threeYearCashSpend=new List<ThreeYearCashSpend>();
            List<String> users = new List<String>();
            System.debug('URL.getSalesforceBaseUrl().toExternalForm()'+URL.getSalesforceBaseUrl().toExternalForm());
            Set<String> pocs = new Set<String>();
            List<PointOfContacts> rfaPointsOfContact=new List<PointOfContacts>();
            List<ReportingUnits> reportingUnits = new List<ReportingUnits>();
            List<ReportingUnit> reportingUnit=new list<ReportingUnit>();
            List<DOACategories> doaCategories=new List<DOACategories>();
            String nameTitle=Label.RFA_CL025;
            String rfaURLInstance=Label.RFA_CL103;
            RFADeepLinkWrapper  deepLink=new RFADeepLinkWrapper ();
            List<RFAWrappersInternalAttachments> rfaAttachmentsRecords=new list<RFAWrappersInternalAttachments>();
            List<RFAWrappersAttachments> rfaAttachments=new list<RFAWrappersAttachments>();
            Id userId;
            List<ApproversInfo>  ApproversInfo=new List<ApproversInfo>();
            ApproverRecommendations rfaApproverRecommendations=new ApproverRecommendations();
            List<ApproversAndRecommendation> rfaApprovers=new List<ApproversAndRecommendation>();
            List<ApprovalHistory> ApprovalHistory = new List<ApprovalHistory>();
            List<PreviousApproval> previousApproval=new list<previousApproval>(); 
            OpDetailsCompBot operationDetailsCompanyBottler = new OpDetailsCompBot();
            BottlerFinancialDetails bottlerFinancialDetails = new BottlerFinancialDetails();
            CompanyFinancialDetails companyFinancialDetails = new CompanyFinancialDetails();        
            /*~~~~End of Variable Initialization~~~~*/
            
            if(rfaId==null || federationId.trim()==null || federationId.trim()=='') // Mandatory Input Argument Check
            {
                message.code=Label.RFA_CL034; // RFA Id and logged in user's email is mandatory while requesting the RFA details - Error
                message.description=Label.RFA_CL014; // Error Description
                result.message=message;
                return result;
            }
            else
            {
                 try // Querying the RFA record with related childs
                 {       
                    rfaObj = qry.getRFAwChilds(rfaId);
                 }catch(QueryException e)
                 {
                     message.code=Label.RFA_CL034; // Exception in Query - Error
                     message.description=label.RFA_CL015; // Error Description
                     result.message=message;
                     return result;
                 }
                 Catch(Exception e)
                 {
                     message.Code=Label.RFA_CL034;
                     message.Description=e.getMessage();
                     result.message=message;
                     return result;
                 }   
                 
                 if(rfaObj != NULL)
                 {
                      /**** Start of Adding Three Year Cash spend to the Wrapper ****/
                      for(ThreeYearCashSpend__c tempCash: rfaObj.Three_Year_Cash_Spend__r)
                      {
                          yearAmountList.add(
                          new YearAmountList(String.valueof(tempCash.Year__c),String.valueof(tempCash.X3YearCashSpendFunc__c),String.valueof(tempCash.X3YearCashSpendUSD__c)));
                      }
                     
                      if(!yearAmountList.isEmpty())
                         threeYearCashSpend.add(new ThreeYearCashSpend(yearAmountList));
                         
                    /**** End of Adding Three Year Cash spend to the Wrapper ****/
                 
                    /**** Adding rfa Points Of contct -- List the creator and the current coordinator ****/
                    users.add(rfaObj.CreatedBy.Name+ '( '+rfaObj.CreatedBy.FederationIdentifier+' )'); // Assigning the Requestor
                    for(RFAUserRole__c poc : rfaObj.RFA_User_Roles__r) // Getting Co-Creator and Primary Point Of Contact
                    {
                        if (poc.RecordType.DeveloperName.equalsIgnoreCase('RUR_CoCreator') || poc.RecordType.DeveloperName.equalsIgnoreCase('RUR_PrimaryPointofContact'))
                            users.add(poc.UserName__r.Name+ '( '+poc.UserName__r.FederationIdentifier+' )');
                    }
                    // Assigning the Location Coordinators
                    if(rfaObj.ProfitCenterNumber__c != NULL)
                    {
                        for(ProfitCenterUserRole__c pcUR : [Select UserName__c, UserName__r.Name,UserName__r.FederationIdentifier ,UserName__r.Email, Level__c, ProfitCenter__c, UserType__c from ProfitCenterUserRole__c where ProfitCenter__c =: rfaObj.ProfitCenterNumber__c AND UserType__c =: RFAGlobalConstants.PC_USERTYPE_LC AND Level__c =: rfaObj.Level__c ])
                        {
                            pocs.add(pcUR.UserName__r.Name + '( '+pcUR.UserName__r.FederationIdentifier+' )');
                        }
                    }
                    if(!pocs.isEmpty())
                        users.addAll(pocs);                    
                    if(!users.isEmpty())
                        rfaPointsOfContact.add(new PointOfContacts(users)); // Assign to the Point Of Contacts Wrapper
                    
                    /**** End of adding rfa Points Of contact -- List the Requestor, Co-Creator,  Point Of Contact and the Current Coordinators ****/
                    
                    /**** Adding Reporting unit detail ****/
                    if(rfaObj.PrimaryReportingUnitName__c!=null)
                        reportingUnit.add(new ReportingUnit (rfaObj.PrimaryReportingUnitName__c,String.valueof(rfaObj.PrimaryReportingUnitNumber__r.Name)));
                    if(rfaObj.SecondReportingUnitName__c!=null)
                        reportingUnit.add(new ReportingUnit (rfaObj.SecondReportingUnitName__c,String.valueof(rfaObj.SecondReportingUnitNumber__r.Name)));
                    if(rfaObj.ThirdReportingUnitName__c!=null)
                        reportingUnit.add(new ReportingUnit(rfaObj.ThirdReportingUnitName__c,String.valueof(rfaObj.ThirdReportingUnitNumber__r.Name))); 
                    
                    reportingUnits.add(new ReportingUnits(reportingUnit)); // adding to the Reporting Unit Wrapper
            
                    /**** End of Adding Reporting unit detail ****/
                   
                    // Adding DOA Categories
                    doaCategories.add( new DOACategories(rfaObj.PrimaryDOACategorySubCategory__c,rfaObj.SecondDOACategorySubCategory__c,rfaObj.ThirdDOACategorySubCategory__c));
                    
                    // Adding RFA Deeplink to view RFA on browser
                    deepLink=new RFADeepLinkWrapper (nameTitle,rfaURLInstance+'/'+rfaObj.Id);
                    
                    /**** Start of Adding Attachments to wrapper. ****/   
                    
                    for(Attachment tempAttachment: rfaObj.Attachments)
                    {
                        rfaAttachmentsRecords.add( new RFAWrappersInternalAttachments(tempAttachment.Name, tempAttachment.Id));
                    }
                    
                    rfaAttachments.add( new RFAWrappersAttachments(rfaAttachmentsRecords));
                    /**** End of Adding Attachments to wrapper. ****/
                    
                    try
                    {
                        User user=qry.getUserDetails(federationId); //Query in User Object
                        userId= user.id;
                    }catch(QueryException e)
                    {
                    message.Code=Label.RFA_CL034; // No matching User in System
                    message.Description=label.RFA_CL015; // Error Description
                    result.message=message;
                    return result;
                    }
                    Catch(Exception e)
                    {
                        message.Code=Label.RFA_CL034;
                        message.Description=e.getMessage();
                        result.message=message;
                        return result;
                    }
                    
                    if(userId != NULL)
                    {
                        /**** Start of Adding Approvers with recommendation Options ****/
                        for(RFAUserRole__c approvers : rfaObj.RFA_User_Roles__r)
                        {
                            if (approvers.RecordType.DeveloperName == 'RUR_Approver' && approvers.ApprovalProcess__c!=NULL && !approvers.TECH_IsComplete__c.equalsIgnoreCase('true') && approvers.ApprovalRecommendation__c <> NULL && approvers.ApprovalRecommendation__c.equalsIgnoreCase('Awaiting Approval'))
                            {
                                if(approvers.UserName__c == userId || approvers.Agent1__c == userId || approvers.Agent2__c == userId || approvers.Agent3__c ==userId)
                                    ApproversInfo.add( new ApproversInfo (String.valueof(approvers.Id), approvers.UserName__r.Name + '( '+approvers.UserName__r.FederationIdentifier+' )') );
                            }
                        }                 
                        if(!ApproversInfo.isEmpty())
                        {
                            Schema.DescribeFieldResult fieldResult = RFAUserRole__c.ApprovalRecommendation__c.getDescribe();
                            for(Schema.PicklistEntry pe : fieldResult.getPicklistValues())
                            {
                                if(/*!pe.getLabel().equalsIgnoreCase('No Longer Needed') &&*/ !pe.getLabel().equalsIgnoreCase('Awaiting Approval'))
                                    rfaApproverRecommendations.rec.add(pe.getLabel());
                            }
                            rfaApprovers.add(new ApproversAndRecommendation(ApproversInfo,rfaApproverRecommendations));
                            /**** End of Adding Approvers with recommendation Options ****/
                        } 
                        else
                        {
                            message.Code=Label.RFA_CL031; // Error - Approval Is Not Requied
                            message.Description=Label.RFA_CL042; // Error Description - Approver Removed
                            result.message=message;
                            return result;
                        }
                    
                        /*** Approval Histrory detail*/
                        
                        
                        for(RFAUserRole__c prevRec : rfaObj.RFA_User_Roles__r)
                        {   system.debug(prevRec+'@@######################');
                            if (prevRec.RecordType.DeveloperName == 'RUR_Approver' && prevRec.ApprovalProcess__c!=NULL && prevRec.TECH_IsComplete__c.equalsIgnoreCase('true') && (prevRec.ApprovalRecommendation__c.equalsIgnoreCase('No Longer Needed') ||  prevRec.ApprovalRecommendation__c.equalsIgnoreCase('Unconditionally Approved') ||  prevRec.ApprovalRecommendation__c.equalsIgnoreCase('Conditionally Approved') || prevRec.ApprovalRecommendation__c.equalsIgnoreCase('Rejected') || prevRec.ApprovalRecommendation__c.equalsIgnoreCase('Ratification')))
                            {
                                system.debug(prevRec+'@@@@@@@@@@');
                                previousApproval.add( new previousApproval(prevRec.Level__c, prevRec.UserName__r.Name + '( '+prevRec.UserName__r.FederationIdentifier+' )', prevRec.ApprovedBy__r.Name + '( '+prevRec.ApprovedBy__r.FederationIdentifier+' )', Date.ValueOf(prevRec.ApprovalRecievedDateTime__c), prevRec.ApprovalRecommendation__c, prevRec.ApprovalComments__c ));
                            }
                        }
        
                        ApprovalHistory.add(new ApprovalHistory(previousApproval));
                        /*** Approval Histrory detail Ends here*/                
                    
                        if(message != NULL || message.Code != '')
                        {
                            message.Code=Label.RFA_CL028; // SUCCESS
                            message.Description=label.RFA_CL028; // SUCCESS
                            result.message=message;
                            companyFinancialDetails = new CompanyFinancialDetails(rfaObj.CompanyParticipation__c, rfaObj.CompanyParticipationAmountUSD__c, rfaObj.CompanyIRR__c, rfaObj.CompanyNPVUSD__c, rfaObj.CompanyDiscountPaybackPeriodYears__c, rfaObj.CompanyInvestmentAmortizationYears__c, rfaObj.CashflowAnalysisYears__c, rfaObj.CompanyWACC__c, rfaObj.CompanyLocalEffectiveTaxRate__c, rfaObj.CompanyROINPVCAPPr__c);
                            bottlerFinancialDetails = new BottlerFinancialDetails(rfaObj.BottlerParticipation__c, rfaObj.BottlerParticipationAmountUSD__c, rfaObj.BottlerIRR__c, rfaObj.BottlerNPVUSD__c, rfaObj.BottlerDiscPaybackPeriodYears__c, rfaObj.BottlerInvestmentDepreciationYears__c, rfaObj.BottlerWACC__c, rfaObj.BottlerLocalEffectiveTaxRate__c, rfaObj.BottlerROINPVCAPPr__c);
                            
                            operationDetailsCompanyBottler = new OpDetailsCompBot(rfaObj.NumberofUnitsofEquipment__c, rfaObj.TermoftheAgreementYears__c, rfaObj.PerformanceReportingPeriodMonths__c, rfaObj.EquipmentPlacementPeriodYears__c);
                        result=new rfaWrapperDetails(rfaObj.Id,rfaObj.recordType.Name, rfaObj.RequestTitle__c, rfaObj.ControlNumber__c, rfaObj.RequestAmountFunctionalCurrency__c,rfaObj.Functional_Currency__r.Name, rfaObj.RequestAmountUSD__c, rfaObj.Group__c, rfaObj.ProfitCenterNumber__r.Name, rfaObj.ProfitCenterName__c, String.valueof(rfaObj.IsthisanAnnualCapitalPlanrequest__c), rfaObj.BudgetType__c,rfaObj.ExpectedCommitmentDate__c, rfaObj.ExecutiveSummary__c,rfaObj.BusinessCase__c,rfaObj.CreatedDate,  ApprovalHistory,doaCategories, reportingUnits,threeYearCashSpend,rfaPointsOfContact, rfaAttachments, rfaApprovers, deepLink,message, bottlerFinancialDetails, operationDetailsCompanyBottler);  
                      //  result=new rfaWrapperDetails(rfaObj.Id,rfaObj.recordType.Name, rfaObj.RequestTitle__c, rfaObj.ControlNumber__c, rfaObj.RequestAmountFunctionalCurrency__c,rfaObj.Functional_Currency__r.Name, rfaObj.RequestAmountUSD__c, rfaObj.Group__c, rfaObj.ProfitCenterNumber__r.Name, rfaObj.ProfitCenterName__c, String.valueof(rfaObj.IsthisanAnnualCapitalPlanrequest__c), rfaObj.BudgetType__c,rfaObj.ExpectedCommitmentDate__c, rfaObj.ExecutiveSummary__c,rfaObj.BusinessCase__c,  ApprovalHistory,doaCategories, reportingUnits,threeYearCashSpend,rfaPointsOfContact, rfaAttachments, rfaApprovers, deepLink,message, bottlerFinancialDetails, operationDetailsCompanyBottler);
                        }
                        
                        return result;                                                      
                    }
                    else
                    {
                        message.Code=Label.RFA_CL034; // Error - No Matching User 
                        message.Description=label.RFA_CL015; // Error Description
                        result.message=message;
                        return result;
                    }
                }
                
                return result; // Returning the Final Response       
            }
    }
   
    
    
    
    /* Wrapper used in RFA GetDetails for KO approve ******************/

   
    /**** Final RFA Wrapper result Set****/
   
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send the RFA Details Response along with other informations
       Version        : 1.0
    */
    global class rfaWrapperDetails
    {
      /*~~~~Start of Variable Initialization~~~~*/   
        WebService String rfaId;  // Id of the RFA
        WebService String typeOfRequest; // Type (Record Type Name) of the Request
        WebService String requestTitle; // Title of the RFA
        WebService String controlNumber; // Control Number of teh RFA
        WebService Decimal requestAmount; // Request Amount of RFA in Functional Currency
        WebService String functionalCurrency;  // Functional Currency Name
        WebService Decimal usdAmount; // RFA Request Amount in USD
        WebService String rfaGroup; // Business Unit Group Name of the RFA
        WebService String profitCenter; // Profit Center Number of the RFA
        WebService String profitCenterName; // RFA Profit Center Name
        WebService String isAnnualCapitalPlanRequest; // Indicator whether RFA Annual Capital Plan Request or not
        WebService String budgetStatus; // RFA Budget Type
        Webservice Date expetedCommitmentDate; // RFA Expected Commitment Date
        WebService String executiveSummary; // RFA Executive Summary
        WebService String businessCaseSummary; // RFA Business Case Summary
        WebService DateTime activeSync; // RFA CreateDate
        Webservice List<ApprovalHistory> approvalHistory;
        WebService List<DOACategories> doaCategories;  // RFA DOA Categories name
        Webservice List<ReportingUnits> reportingUnits; // RFA Reporting Unit
        WebService List<ThreeYearCashSpend> threeYearCashSpend;
        WebService List<PointOfContacts> rfaPointsOfContact;
        WebService List<RFAWrappersAttachments> attachments;
        WebService List<ApproversAndRecommendation> actAsApprover;
        WebService RFADeepLinkWrapper  deepLink;
        WebService StatusMessageWrapper message; // Message Wrapper
        Webservice OpDetailsCompBot operationDetailsCompanyBottler;
        Webservice BottlerFinancialDetails bottlerFinancialDetails; 
        
        /*~~~~End of Variable Initialization~~~~*/
     
      public rfaWrapperDetails(){} // Default Constructor
       
          // Constructor Overloading to pass the RFA related details
          public rfaWrapperDetails(String rfaId, String typeOfRequest, String requestTitle, String controlNumber, Decimal requestAmount,String functionalCurrency, Decimal usdAmount, String rfaGroup, String profitCenter, String profitCenterName, String isAnnualCapitalPlanRequest, String budgetStatus, Date expetedCommitmentDate, String executiveSummary, String businessCaseSummary, DateTime activeSync,List<ApprovalHistory> approvalHistory, List<DOACategories> doaCategories, list<ReportingUnits> reportingUnits, List<ThreeYearCashSpend> threeYearCashSpend, List<PointOfContacts> rfaPointsOfContact, List<RFAWrappersAttachments> attachments, List<ApproversAndRecommendation> actAsApprover, RFADeepLinkWrapper  deepLink, StatusMessageWrapper message, BottlerFinancialDetails bottlerFinancialDetails, OpDetailsCompBot operationDetailsCompanyBottler )  
        //  public rfaWrapperDetails(String rfaId, String typeOfRequest, String requestTitle, String controlNumber, Decimal requestAmount,String functionalCurrency, Decimal usdAmount, String rfaGroup, String profitCenter, String profitCenterName, String isAnnualCapitalPlanRequest, String budgetStatus, Date expetedCommitmentDate, String executiveSummary, String businessCaseSummary, List<ApprovalHistory> approvalHistory, List<DOACategories> doaCategories, list<ReportingUnits> reportingUnits, List<ThreeYearCashSpend> threeYearCashSpend, List<PointOfContacts> rfaPointsOfContact, List<RFAWrappersAttachments> attachments, List<ApproversAndRecommendation> actAsApprover, RFADeepLinkWrapper  deepLink, StatusMessageWrapper message, BottlerFinancialDetails bottlerFinancialDetails, OpDetailsCompBot operationDetailsCompanyBottler )  
          
          {
              this.rfaId=rfaId;
              this.typeOfRequest =typeOfRequest ;
              this.requestTitle=requestTitle;
              this.controlNumber=controlNumber;
              this.requestAmount =requestAmount ;
              this.functionalCurrency  =functionalCurrency  ;
              this.usdAmount =usdAmount ;
              this.rfaGroup =rfaGroup ;
              this.profitCenter =profitCenter ;
              this.profitCenterName =profitCenterName ;
              this.isAnnualCapitalPlanRequest =isAnnualCapitalPlanRequest ;
              this.budgetStatus =budgetStatus ;
              this.expetedCommitmentDate =expetedCommitmentDate ;
              this.executiveSummary =executiveSummary ;
              this.businessCaseSummary =businessCaseSummary ;
              this.activeSync=activeSync;
              this.approvalHistory=approvalHistory;
              this.doaCategories=doaCategories;
              this.reportingUnits=reportingUnits;
              this.threeYearCashSpend=threeYearCashSpend;
              this.rfaPointsOfContact =rfaPointsOfContact ;
              this.attachments=attachments;
              this.actAsApprover=actAsApprover;
              this.deepLink=deepLink;
              this.message=message;
              this.bottlerFinancialDetails = bottlerFinancialDetails;
              this.operationDetailsCompanyBottler = operationDetailsCompanyBottler;
              
              
          }
    }
    
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send the CAPPr Financial Details for Bottler
        Version        : 1.0
    */
    global class CompanyFinancialDetails
    {
        WebService Decimal companyParticipationPercent; // Company Participation (%)   
        WebService Decimal companyParticipationAmountUSD; // Company Investment Depreciation Years    
        WebService Decimal companyIRRPercent; // Company Participation Amount (USD $)     
        WebService Decimal companyNPVUSD; // Company WACC (%)     
        WebService Decimal companyDiscPaybackPeriodYears; // Company IRR (%)  
        WebService Decimal companyInvestmentDepreciationYears; // Company Local Effective Tax Rate (%)     
        Webservice Decimal cashflowAnalysisYears; // Cashflow Analysis Years
        WebService Decimal companyWACCPercent; // Company NPV (USD $)      
        WebService Decimal companyLocalEffectiveTaxRatePercent; // Company Disc. Payback Period-Years
        WebService Decimal companyROI; //Company ROI (NPV/CAPPr %)
        
        public CompanyFinancialDetails(){} // Default Constructor
        public CompanyFinancialDetails(Decimal companyParticipationPercent, Decimal companyParticipationAmountUSD, Decimal companyIRRPercent, Decimal companyNPVUSD, Decimal companyDiscPaybackPeriodYears, Decimal companyInvestmentDepreciationYears, Decimal cashflowAnalysisYears, Decimal companyWACCPercent, Decimal companyLocalEffectiveTaxRatePercent, Decimal companyROI)// Constructor Overloading to pass the CAPPr Financial Details for Company
        {
            this.companyParticipationPercent = companyParticipationPercent; 
            this.companyParticipationAmountUSD = companyParticipationAmountUSD;
            this.companyIRRPercent = companyIRRPercent;
            this.companyNPVUSD =  companyNPVUSD;
            this.companyDiscPaybackPeriodYears = companyDiscPaybackPeriodYears;
            this.companyInvestmentDepreciationYears = companyInvestmentDepreciationYears;
            this.cashflowAnalysisYears = cashflowAnalysisYears;
            this.companyWACCPercent = companyWACCPercent;
            this.companyLocalEffectiveTaxRatePercent = companyLocalEffectiveTaxRatePercent;
            this.companyROI = companyROI;
        }
    }
    
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send the CAPPr Financial Details for Bottler
        Version        : 1.0
    */
    global class BottlerFinancialDetails
    {
        WebService Decimal bottlerParticipationPercent; // Bottler Participation (%)   
        WebService Decimal bottlerParticipationAmountUSD; // Bottler Participation Amount (USD $)      
        WebService Decimal bottlerIRRPercent; // Bottler IRR (%)  
        WebService Decimal bottlerNPVUSD;  // Bottler NPV (USD $)       
        WebService Decimal bottlerDiscPaybackPeriodYears; // Bottler Disc. Payback Period-Years
        WebService Decimal bottlerInvestmentDepreciationYears; // Bottler Investment Depreciation Years      
        WebService Decimal bottlerWACCPercent; // Bottler WACC (%)   
        WebService Decimal bottlerLocalEffectiveTaxRatePercent; // Bottler Local Effective Tax Rate (%)
        WebService Decimal bottlerROI; // Bottler ROI (NPV/CAPPr %) 
        
        public BottlerFinancialDetails(){} // Default Constructor
        public BottlerFinancialDetails(Decimal bottlerParticipationPercent, Decimal bottlerParticipationAmountUSD, Decimal bottlerIRRPercent, Decimal bottlerNPVUSD, Decimal bottlerDiscPaybackPeriodYears, Decimal bottlerInvestmentDepreciationYears, Decimal bottlerWACCPercent, Decimal bottlerLocalEffectiveTaxRatePercent, Decimal bottlerROI)// Constructor Overloading to pass the CAPPr Financial Details for Bottler
        {
            this.bottlerParticipationPercent = bottlerParticipationPercent; 
            this.bottlerParticipationAmountUSD = bottlerParticipationAmountUSD;
            this.bottlerIRRPercent = bottlerIRRPercent;
            this.bottlerNPVUSD =  bottlerNPVUSD;
            this.bottlerDiscPaybackPeriodYears = bottlerDiscPaybackPeriodYears;
            this.bottlerInvestmentDepreciationYears = bottlerInvestmentDepreciationYears;
            this.bottlerWACCPercent = bottlerWACCPercent;
            this.bottlerLocalEffectiveTaxRatePercent = bottlerLocalEffectiveTaxRatePercent;
            this.bottlerROI = bottlerROI;
        }
    }
    
    
    
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send the Operational Details for Company and Bottler
        Version        : 1.0
    */
    global class OpDetailsCompBot
    {
        WebService Decimal nbUnitsEquipment; // Number of Units of Equipment
        WebService Decimal termOfAgreementYrs; // Term of the Agreement (Years)
        WebService Decimal performanceReportingPeriodMonths; // Performance Reporting Period (Months)
        WebService Decimal equipmentPlacementPeriodYrs; // Equipment Placement Period (Years)
        
        public OpDetailsCompBot(){} // Default Constructor
        public OpDetailsCompBot(Decimal nbUnitsEquipment, Decimal termOfAgreementYrs, Decimal performanceReportingPeriodMonths, Decimal equipmentPlacementPeriodYrs)// Constructor Overloading to pass the Operational deatils for Company and Bottler
        {
            this.nbUnitsEquipment = nbUnitsEquipment;
            this.termOfAgreementYrs = termOfAgreementYrs;
            this.performanceReportingPeriodMonths = performanceReportingPeriodMonths;
            this.equipmentPlacementPeriodYrs = equipmentPlacementPeriodYrs;
        }
    }
    
    
        

    
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send all the Previous Approval Recommendation History
        Version        : 1.0
    */
    global class ApprovalHistory
    {
        WebService list<PreviousApproval> previousApproval; //
       
        public ApprovalHistory(list<PreviousApproval> previousApproval)// Constructor Overloading to
        {
            this.previousApproval = previousApproval;    
        }
    }

    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send details of a Previous Approval Recommendations
                              - Assigned Approver, Approval Level, Recommendation Given By, Recommendation Date, Recommendation, Comments
        Version        : 1.0
    */   
    global class PreviousApproval
    { 
        /*~~~~Start of Variable Initialization~~~~*/
        WebService String level; //
        WebService String approver; //
        WebService String recordedBy;
        Webservice Date approvalDate;
        WebService String recommendation;
        WebService String comment;
        /*~~~~End of Variable Initialization~~~~*/
       
        public PreviousApproval(String level,String approver, String recordedBy, Date approvalDate, String recommendation, String comment)// Constructor Overloading to pass
        {
            this.level = level;
            this.approver = approver;
            this.recordedBy = recordedBy;
            this.approvalDate = approvalDate;
            this.recommendation = recommendation;
            this.comment = comment;
        }
    }
   
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send all the Reporting Unit Details
        Version        : 1.0
    */    
    global class ReportingUnits
    {
        WebService list<ReportingUnit> reportingUnit; //List of Reporting Units
        public ReportingUnits(){}
        public ReportingUnits(list<ReportingUnit> reportingUnit)// Constructor Overloading to pass
        {
            this.reportingUnit=reportingUnit;
        }
    }
    
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send the details of a Reporting Unit - Reporting Unit Name and Number
        Version        : 1.0
    */   
    global class ReportingUnit
    { 
        /*~~~~Start of Variable Initialization~~~~*/
        WebService String reportingUnitName; //
        WebService String reportingUnitNumber; //
        /*~~~~End of Variable Initialization~~~~*/
       
            public ReportingUnit(String reportingUnitName,String reportingUnitNumber)// Constructor Overloading to pass
        {
            this.reportingUnitName = reportingUnitName;
            this.reportingUnitNumber = reportingUnitNumber;
        }
    }
   
    
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send all the Approvers (along with work item Id)
                               details for whom logged in user need to provide recommendation for the given RFA and all
                               possible recommendation options
        Version        : 1.0
    */
    global class ApproversAndRecommendation
    {
        /*~~~~Start of Variable Initialization~~~~*/
        WebService List<ApproversInfo> approverInfo; 
        WebService ApproverRecommendations recommendations;
        /*~~~~End of Variable Initialization~~~~*/
        public ApproversAndRecommendation(List<ApproversInfo> approverInfo,ApproverRecommendations recommendations) // Constructor Overloading to pass all the
                                                                                                                                                                       // approvers (act on behalf) and recommendation options
        {
            this.approverInfo=approverInfo;
            this.recommendations=recommendations;
        }
    }
    /**** End of ActAsApprovers Wrapper (Inner) Class ****/
   
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send all the possible recommendation options
        Version        : 1.0
    */
    global class ApproverRecommendations
    {
        WebService List<String> rec; // Variable initialization to pass the recommendation options
        public ApproverRecommendations() // Constructor
        {
            rec=new List<String>();
        }
    }
    /**** End of Recommendation Options Wrapper (Inner) Class ****/
   
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send Approver and Work Item Details
        Version        : 1.0
    */
    global class ApproversInfo
    {
        /*~~~~Start of Variable Initialization~~~~*/
        WebService String key; // WorkItemId
        Webservice String approver; // Approver User Name
        /*~~~~End of Variable Initialization~~~~*/
        public ApproversInfo(String key, String approver) // Constructor Overloading to pass the approver details
        {
            this.key=key;
            this.approver=approver;
        }
    }
    /**** End of Approver Wrapper (Inner) Class ****/
  
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to send the DOA categories
        Version        : 1.0
    */
    global class DOACategories
    {
        /*~~~~Start of Variable Initialization~~~~*/
        WebService String Primary; //Primary DOA Category
        WebService String Secondary; //Secondary DOA Category
        WebService String Third; //Third DOA Category
        /*~~~~End of Variable Initialization~~~~*/
       
        public DOACategories(){}
        public DOACategories(String primary,String Secondary,String third) // Constructor Overloading to pass the DOA Categories
        {
            this.primary=primary;
            this.secondary=secondary;
            this.third=third;
        }
    }
    /**** End of DOA Categories Wrapper (Inner) Class ****/
  
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to display the Requestor and the Location Coordinators of current Level
        Version        : 1.0
    */
    global class PointOfContacts
    {
        WebService List<String> user; //List of String variable initialization to store user Names
      
            public PointOfContacts(List<String> user) // Constructor Overloading to pass the list of point of contacts
        {
            this.user=user;
        }
    }
    /**** End of PointOfContacts Wrapper (Inner) Class ****/
   
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to display 3 Year Cash spends.
        Version        : 1.0
    */
    global class ThreeYearCashSpend
    {
        WebService list<YearAmountList> yearAmount; //List of yearly cash spend variable initialization
       
        public ThreeYearCashSpend(list<YearAmountList> yearAmount)// Constructor Overloading to pass the 3 year cash spend
        {
            this.yearAmount=yearAmount;
        }
    }
    /**** End of ThreeYearCashSpend Wrapper (Inner) Class ****/
   
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to display the cash spend for each year.
        Version        : 1.0
    */
    global class YearAmountList
    { 
        /*~~~~Start of Variable Initialization~~~~*/
        WebService String year; //Year Value
        WebService String functionalAmount; // Amount spend in Functional Currency
        WebService String usdAmount; // Amount spend in USD
        /*~~~~End of Variable Initialization~~~~*/
       
            public YearAmountList(String Year,String functionalAmount,String usdAmount)// Constructor Overloading to pass the Year, cash spent in Functional Currency and USD
        {
            this.usdAmount=usdAmount;
            this.year=year;
            this.functionalAmount=functionalAmount;
        }
    }
    /****End of YearCashSpend Wrapper (Inner) Class ****/
   
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to display all the attachment under the attachments group.
        Version        : 1.0
    */
    global class RFAWrappersAttachments
    {
        WebService list<RFAWrappersInternalAttachments> attachment; //List Attachment Variable Initialization
  
      public RFAWrappersAttachments(list<RFAWrappersInternalAttachments> attachment)// Constructor Overloading to pass the List of Attachments
        {
            this.attachment=attachment;
        }
    }
    /****End of All Attachments Wrapper (Inner) Class ****/
   
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to display link and name of individual attachment.
        Version        : 1.0
    */
    global class RFAWrappersInternalAttachments
    {
        /*~~~~Start of Variable Initialization~~~~*/
        WebService String name; // Attachment Name
        WebService String url; // SFDC Attachment Id
        /*~~~~End of Variable Initialization~~~~*/
   
        public RFAWrappersInternalAttachments(String name,String url)// Constructor Overloading to pass the name and SFDC id of Atatchment
        {
            this.name=name;
            this.url=url;
            }
    }
    /****End of Attachment Wrapper (Inner) Class ****/
   
    /*
        Class Type     : Inner Class
        Date Created   : 06/09/2012
        Description    : This is our wrapper/container Inner class to display the url and Label for the RFA SFDC URL.
                         The wrapper class contains the 2 string values to display the label and url.
        Version        : 1.0
    */
    global class RFADeepLinkWrapper 
    {
        /*~~~~Start of Variable Initialization~~~~*/
        WebService String name; // Click to open in Browser
        WebService String url; // URL of the RFA
        /*~~~~End of Variable Initialization~~~~*/
        public RFADeepLinkWrapper (){} // Default Constructor
        public RFADeepLinkWrapper (String name, String url)// Constructor Overloading to pass the url and label
        {
            this.name=name;
            this.url=url;
        }
    }
      /****End of RFA Deep Link Wrapper (Inner) Class ****/
     
      /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to display the code and description Service StatusMessage.
                          The wrapper class contains the 2 string values to display the code and description of the Status.
        Version          : 1.0
    */
   
    global class StatusMessageWrapper
    {
       /*~~~~Start of Variable Initialization~~~~*/
        WebService String description; // Status Description
        WebService String code; // Status Code
        /*~~~~End of Variable Initialization~~~~*/
       
        /*~~~~Constructors~~~~*/
        public StatusMessageWrapper(){} // Default Constructor
       
        // Constructor Overloading to pass the Status Code and Description
        public StatusMessageWrapper(String code, String description)
        {
            this.code=code;
            this.description=description;
        }
    }
    /*~~~~END of Status Message Wrapper (Inner) Class~~~~*/   
    
}