/*
    Author           : Accenture
    Date Created     : 06/29/2012
    Description      : This class is called from the trigger for reporting unit users
    Version          : 1.0 
*/ 
public class RFA_AP08_ReportingUnitUsersTrigger {


/* @Method <This method is used for processed all the records which are inserting or updating >
       @param <list> - list of reporting nit users records 
       @return null
       @throws exception - <Throwing Query Exception>
    */
    
    public void processRecords(List<ReportingUnitUserRole__c> usersList) 
    {
        /*~~~~Start of Initialization~~~~*/
        Set<Id> reportingUnitIds=new Set<Id>();
        List<ReportingUnit__c> reportingUnitList=new List<ReportingUnit__c>();
        
        /*~~~~End of Initialization~~~~*/
        
        /********fetching all the reproting unit Ids**/
        for(ReportingUnitUserRole__c reportingUnitUser: usersList)
        {
            reportingUnitIds.add(reportingUnitUser.ReportingUnit__c);
        }
    
            /*****************Add Recalculation flag to reporting unit block starts here**********************/
        
        for(Id reportingUnitId :reportingUnitIds )
        {
                ReportingUnit__c reportingUnit=new ReportingUnit__c(id=reportingUnitId);
                reportingUnit.NeedRecalculation__c=true;  // update the flag to ture for recalculation the sharing model
                reportingUnitList.add(reportingUnit);
        }
        
        if(!reportingUnitList.IsEmpty())
        {
            Database.SaveResult[] results = Database.Update (reportingUnitList,false); //Updating the Reporting Unit records
            if (results != null)
            {
                for (Database.SaveResult result : results) 
                {
                    if (!result.isSuccess()) 
                    {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs)
                            System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                    }
                }
            }
        }
        /*****************Add Recalculation flag to reporting unit block ends here**********************/
        
        
    
    }

}