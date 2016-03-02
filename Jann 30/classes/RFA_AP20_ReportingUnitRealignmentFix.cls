/**
* Class Name: RFA_AP20_ReportingUnitRealignmentFix
* Author: Accenture
* Date: 01-03-2014
* Project Name: Coke-RFA
 * Requirement Description: This batch is used for realignment for security of Reporting Unit.
 **/


global class RFA_AP20_ReportingUnitRealignmentFix implements Database.Batchable<SObject>{

    // Variables
    global string query;
    public Static String errorString;
    Public Set<id> reportingUnitIds;
    
    /**
     * Constructor
     */
      public RFA_AP20_ReportingUnitRealignmentFix (String query,Set<id> reportingUnitObjIds)
      {
            this.query=query;
            this.reportingUnitIds = reportingUnitObjIds;
      }
      
      /**
     *  start method
     *  @param Database.BatchableContext
     *  @return Database.Querylocator
     */
    global Database.Querylocator start(Database.BatchableContext bc){
        return DataBase.getQueryLocator(query);
    }
    
    /**
     *  execute method
     *  @param Database.BatchableContext
     *  @param List<SObject>
     */
    global void execute(Database.BatchableContext bC, List<RFA__c> RFAObjectList){
      Map<Id, Set<Id>> reportingUnitMap=new Map<Id, Set<Id>>(); // RFAId, Set of (potentially three) Reporting Unit ID on the RFA
      Set<id> reportingUnitSet; // set of (potentially three) Reporting Unit ID on the RFA
      List<ReportingUnit__c> reportingUnitUpdateList=new List<ReportingUnit__c>(); // used to reset NeedRecalculation flag
      RFA_AP02_Shareutil shareUtil=new RFA_AP02_Shareutil(); //Instantiate ShareUtil class
      
      for(RFA__c rfaRecord:RFAObjectList)
      {
          reportingUnitSet=new Set<Id>();
        
          if(rfaRecord.PrimaryReportingUnitNumber__c<>null)
                reportingUnitSet.add(rfaRecord.PrimaryReportingUnitNumber__c);
            if(rfaRecord.SecondReportingUnitNumber__c<>null)
                reportingUnitSet.add(rfaRecord.SecondReportingUnitNumber__c);
            if(rfaRecord.ThirdReportingUnitNumber__c<>null)
                reportingUnitSet.add(rfaRecord.ThirdReportingUnitNumber__c);
            reportingUnitMap.put(rfaRecord.id,reportingUnitSet);
        
        // confirm what this looks like in the system debug
        System.debug('reportingUnitMap <RFA Id, ReportingUnitSet>: ' + reportingUnitMap);
        }
        
        if(!reportingUnitMap.IsEmpty())
        {
            shareUtil.rfaReportingUnitChangeDelete(reportingUnitMap);
            shareUtil.reportingUnitCreteShare(reportingUnitMap);
        }
        
        // Reset NeedRecalculation field flag on Profit Center to False
        for(Id reportingUnitId:reportingUnitIds) 
        {
            ReportingUnit__c reportingUnit=new ReportingUnit__c(id=reportingUnitId);
            reportingUnit.NeedRecalculation__c=false;
            reportingUnitUpdateList.add(reportingUnit);
                
        }
        
        if(!reportingUnitUpdateList.IsEmpty())
        {
            update reportingUnitUpdateList;
        }
    }
   
    /**
     *  finish method
     *  @param Database.BatchableContext
     */
    global void finish(Database.BatchableContext BC){
           
    }
     
}