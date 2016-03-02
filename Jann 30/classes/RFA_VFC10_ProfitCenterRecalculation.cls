/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC10_ProfitCenterRecalculation
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/10/2012
 *  Assumptions      : N/A
 *  Description      : Class for calling the schedule function for sharing recalculation from RFA_VFP10_ProfitCenterRecalculation. 
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

public class RFA_VFC10_ProfitCenterRecalculation {
    
    /*~~~~Start of Variable Initialization~~~~*/ 
    public ProfitCenter__c profitCenter{get;set;}
    public String Query;   
    /*~~~~End of Variable Initialization~~~~*/
    
    /**
     * Constructor
     */
    public RFA_VFC10_ProfitCenterRecalculation (ApexPages.StandardController stdController) {
    profitCenter = (ProfitCenter__c)stdController.getRecord ();
    }
    
    /**
     *  pageReference method
     *  @param 
     *  @return pageReference   
     */
            
    public pageReference callRecalculationMethod()
    {
    /*Query='Select Id ,name from ProfitCenter__c where Id=\''+profitCenter.Id+'\' and NeedRecalculation__c=true and ActiveInactive__c=\'Active\' ';
    System.debug(Query);
    RFA_AP09_Realignment controller = new RFA_AP09_Realignment(Query) ;
    Integer batchSize = 200;
    database.executebatch(controller , batchSize);*/
    Set<id> profitCenterIds=new Set<Id>(); 
    List<ProfitCenter__c> profitCenterList = [Select Id,name from ProfitCenter__c where Id =: profitCenter.Id and NeedRecalculation__c = true and ActiveInactive__c='Active'];
    for(ProfitCenter__c profitCenterObj : profitCenterList){
         profitCenterIds.add(profitCenterObj.Id);
    }
    String Query = 'Select profitCenterNumber__c,id,Level__c, PreviousLevel__c, Stage__c from RFA__c where profitCenterNumber__c IN :profitCenterIds and Level__c !=null';
    Integer batchSize = 100;
    RFA_BatchProfitCenterRealignmentFix batchController = new RFA_BatchProfitCenterRealignmentFix(Query,profitCenterIds);
    database.executebatch(batchController , batchSize);
    pageReference pref;
    ApexPages.StandardController sc = new ApexPages.StandardController(profitCenter);
    pref = sc.view();
    pref.setRedirect(true);
    return pref;
    }
    

}