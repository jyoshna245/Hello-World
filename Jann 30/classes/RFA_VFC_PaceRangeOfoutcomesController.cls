public class RFA_VFC_PaceRangeOfoutcomesController {
 
    //jyoshna code start
    public boolean editable{get;set;}
    public boolean displayBusinessCaseFinancial {get;set;}
    public RFA__c rfaobj{get;set;}
    public ProfitCenter__c pcobj {get;set;}
    public ApexPages.StandardController stdController { get; set; }
    public Boolean refreshPage { get; set; }
    
    public RFA_VFC_PaceRangeOfoutcomesController(ApexPages.StandardController controller) {
        displayBusinessCaseFinancial = true;
        stdController = controller;
        rfaObj = (RFA__c)controller.getRecord();
        rfaObj=[select id, ProfitCenterNumber__c, EconomicProfitUSD__c, CashflowYears__c, TaxRate__c,
                        CapitalizedInterestUSD__c, WACC__c,
                        Upside_Internal_Rate_Of_Return__c,Expected_Discounted_Payback_Years__c,IRR__c,Downside_Internal_Rate_Of_Return__c,Upside_NPV_WACC__c,NPVUSD__c,Downside_NPV_WACC__c,Upside_NPV_Investment__c,Expected_NPV_Investment__c,
                Downside_NPV_Investment__c,Upside_Discounted_Payback_Years__c,DiscountedPaybackPeriodYears__c,Downside_Discounted_Payback_Years__c from RFA__c where Id=:rfaObj.Id];
        List<ProfitCenter__c> listProfitCenters = [select id,Profit_Center_Type__c from ProfitCenter__c where Id = : rfaobj.ProfitCenterNumber__c];                
        if(listProfitCenters.size()>0) {
            pcobj = listProfitCenters.get(0);
            if(pcobj!=null && pcobj.Profit_Center_Type__c=='CCR') {
                displayBusinessCaseFinancial = false;
            }
        }
        editable=false;
        system.debug('ProfitCenter Type is:'+pcobj.Profit_Center_Type__c);
        system.debug('Boolean Value is:'+displayBusinessCaseFinancial);
    }
    
    public pageReference editpacerangefields() {
        if(editable)        
        editable = false;
        else
         editable = true;   
        return null;
    }
    
    public pageReference savepacerangefields() {       
        rfaobj.NPVUSD__c = rfaobj.Expected_NPV_Investment__c;
        update rfaobj; 
        editable = false;
        //refreshPage = true;
        return null;
        
    }
      
    public pageReference cancelpacerangefields()
    {
        
            editable=false;
           // refreshPage = true;
        
        return null;
    }
}