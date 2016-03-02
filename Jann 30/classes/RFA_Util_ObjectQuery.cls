/*
    Author           : Accenture
    Date Created  : 05/15/2012
    Description     : This class determines the logged in user's access level on the RFA.
                           This class is extended by the Other classes to inherit the security of the logged in user to perform actions.
    Version History: 1.0
*/
public class RFA_Util_ObjectQuery
{


    /* @Method <This method return the details of an Attchment given the SFDC Id of attachment as Input>
        @param <Id - SFDC Id of the Atatchment> 
        @return Attachment - Return data of sObjetc type Attachment
        @Called from - <RFA_WS05>
    */
    public  Attachment getAttachment(Id attId)
    {
         return [SELECT Id,Name,BodyLength,Body,ContentType,Description FROM Attachment where Id=:attId Limit 1];
    }
    
    /* @Method <This method return the details of an RFA__c along with related Child records given the SFDC Id of RFA as Input>
        @param <Id - SFDC Id of the RFA> 
        @return Attachment - Return data of sObjetc type RFA__c along with childs Three Year Cash Spend, Attachments, RFA User Role
        @Called from - 
    */
    public RFA__c getRFAwChilds(Id rfaId)
    {
        return [Select Id,PrimaryReportingUnitName__c, PrimaryReportingUnitNumber__r.Name, PrimaryReportingUnitNumber__c,
               ThirdReportingUnitName__c, ThirdReportingUnitNumber__r.Name, ThirdReportingUnitNumber__c ,SecondReportingUnitName__c, 
               SecondReportingUnitNumber__r.Name, SecondReportingUnitNumber__c,CreatedDate, CreatedById, CreatedBy.Name,CreatedBy.FederationIdentifier, CreatedBy.Email ,Level__c,
               BudgetType__c,RecordType.name, RequestTitle__c ,ControlNumber__c ,RequestAmountFunctionalCurrency__c ,
               RequestAmountUSD__c ,Functional_Currency__c ,ProfitCenterName__c,ProfitCenterNumber__c, ProfitCenterNumber__r.Name ,
               ExecutiveSummary__c , Group__c, IsthisanAnnualCapitalPlanrequest__c ,BusinessCase__c ,PrimaryDOACategorySubCategory__c,
               SecondDOACategorySubCategory__c,ThirdDOACategorySubCategory__c,Owner.Name,ExpectedCommitmentDate__c,Functional_Currency__r.Name, 
               NumberofUnitsofEquipment__c, TermoftheAgreementYears__c, PerformanceReportingPeriodMonths__c, EquipmentPlacementPeriodYears__c, 
               BottlerParticipation__c, BottlerParticipationAmountUSD__c, BottlerIRR__c, BottlerNPVUSD__c, BottlerDiscPaybackPeriodYears__c, BottlerInvestmentDepreciationYears__c, 
               BottlerWACC__c, BottlerLocalEffectiveTaxRate__c, BottlerROINPVCAPPr__c, CompanyParticipation__c, CompanyParticipationAmountUSD__c, CompanyIRR__c, CompanyNPVUSD__c, 
               CompanyDiscountPaybackPeriodYears__c, CompanyInvestmentAmortizationYears__c, CashflowAnalysisYears__c, CompanyWACC__c, CompanyLocalEffectiveTaxRate__c, 
               CompanyROINPVCAPPr__c, (Select id,X3YearCashSpendFunc__c,X3YearCashSpendUSD__c, Year__c from Three_Year_Cash_Spend__r),
               (Select Level__c,id, UserName__c, UserName__r.Name, UserName__r.Email,UserName__r.FederationIdentifier, Agent1__c, Agent1__r.Name, Agent2__c, Agent2__r.Name, Agent3__c, 
               Agent3__r.Name, ApprovalProcess__c, RecordType.DeveloperName, TECH_IsComplete__c, ApprovalRecommendation__c, ApprovalRecievedDateTime__c, 
               ApprovedBy__c, ApprovedBy__r.Name, ApprovedBy__r.email,ApprovedBy__r.FederationIdentifier, ApprovalComments__c from RFA_User_Roles__r ORDER BY Level__c DESC NULLS LAST ),
               (Select id,name from Attachments) FROM RFA__c where Id = :rfaId Limit 1];
    }
    
    /* @Method <This method return the details of an RFAUserRole__c record given the SFDC Id of UserRoleRecordId as Input>
        @param <Id - SFDC Id of the RFAUserRole__c> 
        @return RFAUserRole__c - Return data of sObjetc type RFAUserRole__c
        @Called from - <RFA_WS04>
    */
    
    public RFAUserRole__c getUserRole(id workItemId)
    {
        return [Select id,ApprovalRecievedDateTime__c,TECH_IsComplete__c,RFA__c, RFA__r.Level__c, RFA__r.Stage__c, ApprovalRecommendation__c,ApprovalComments__c from RFAUserRole__c where Id =:workItemId];
        
    }
    /* @Method <This method return the details of an User record given the SFDC federation Id of as Input>
        @param <String - SFDC federationId of the User Object> 
        @return User - Return data of sObjetc type User
        @Called from - <RFA_WS04>
    */
    
    public User getUserDetails(String federatedId)
    {
        return [Select id,Email,FederationIdentifier from user where FederationIdentifier=:federatedId limit 1];
        
    }
    
    
    /* @Method <This method return grouped Approvers based on the RFA Ids and Status>
        @param <Set - RFA Ids, String - Status of Approval process.> 
        @return AggregateResult
        @Called from - 
    */
    public List<AggregateResult> getGroupedApprovers(Set<Id> rfaIds, String status)
    {
        AggregateResult[] results = [Select Max(ApprovalOrder__c) maxOrder, RFA__c rfa,ApprovalProcess__c processInstance                                                                                                           
                                     FROM RFAUserRole__c
                                     WHERE ApprovalProcess__r.Status__c = : status
                                     AND RFA__c IN : rfaIds
                                     GROUP BY RFA__c, ApprovalProcess__c                                  
                                     LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())];
                                     
        return results;                              
    }

    
    /*  @Method <This method return RFA details with user role object which will having approval awating status >
         
         @return <List - RFA__c>
         @Called from - WS02 
    */ 
    public List<RFA__c> getAllRFADetailsForAwaitingApprovers()
    {
        List<RFA__c> rfalist=[Select id,Level__C,RequestTitle__c ,CreatedDate, Stage__c, (Select id from Attachments),(Select id,UserName__C,UserName__r.Email,UserName__r.FederationIdentifier,Agent1__c,Agent2__c,Agent3__c,Agent1__r.Email,Agent1__r.FederationIdentifier,Agent2__r.Email,Agent2__r.FederationIdentifier,Agent3__r.Email,Agent3__r.FederationIdentifier from RFA_User_Roles__r where ApprovalRecommendation__c='Awaiting Approval') from RFA__c where Stage__c='Circulation' LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())];
        
        return rfaList; 
                                              
                                              
    }
    
    
     
       
}