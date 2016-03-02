/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC11_ReportingUnitRecalculation
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 04/28/2013
 *  Assumptions      : N/A
 *  Description      : Class for calling the schedule function for sharing recalculation from RFA_VFP11_ReportingUnitRecalculation. 
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

public class RFA_VFC11_ReportingUnitRecalculation {
    
    /*~~~~Start of Variable Initialization~~~~*/ 
    public ReportingUnit__c reportingUnit{get;set;}
    public String Query;
    /*~~~~End of Variable Initialization~~~~*/
    
    /**
     * Constructor
     */
    public RFA_VFC11_ReportingUnitRecalculation (ApexPages.StandardController stdController) {
    reportingUnit = (ReportingUnit__c)stdController.getRecord ();
    }
    
    /**
     *  pageReference method
     *  @param 
     *  @return pageReference   
     */
            
    public pageReference callRecalculationMethod()
    {
    /*Query='Select Id ,name from ReportingUnit__c where Id=\''+reportingUnit.Id+'\' and NeedRecalculation__c=true and ActiveInactive__c=\'Active\' ';
    System.debug(Query);
    RFA_AP20_ReportingUnitRealignment controller = new RFA_AP20_ReportingUnitRealignment(Query);
    Integer batchSize = 200;
    */
    Set<id> reportingUnitIds = new Set<Id>(); 
        List<ReportingUnit__c> reportingUnitList = [Select Id ,name from ReportingUnit__c where NeedRecalculation__c=true and ActiveInactive__c='Active'];
        for(ReportingUnit__c reportingUnitObj : reportingUnitList)
            reportingUnitIds.add(reportingUnitObj.Id);
        String Query = 'Select PrimaryReportingUnitNumber__c,SecondReportingUnitNumber__c,ThirdReportingUnitNumber__c,id,Level__c, PreviousLevel__c from RFA__c where ' 
          +'PrimaryReportingUnitNumber__c IN :reportingUnitIds OR SecondReportingUnitNumber__c IN :reportingUnitIds OR ThirdReportingUnitNumber__c IN :reportingUnitIds '
          +'ORDER BY CreatedDate DESC';
   	RFA_AP20_ReportingUnitRealignmentFix controller = new RFA_AP20_ReportingUnitRealignmentFix(Query,reportingUnitIds) ;
    Integer batchSize = 100;      
    database.executebatch(controller , batchSize);
    pageReference pref;
    ApexPages.StandardController sc = new ApexPages.StandardController(reportingUnit);
    pref = sc.view();
    pref.setRedirect(true);
    return pref;
    }
    

}