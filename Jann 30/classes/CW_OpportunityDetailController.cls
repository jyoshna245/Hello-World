public class CW_OpportunityDetailController {

    public Integer indexNumber{get;set;}
   // public id orgid{get;set;}   
   // public List<Opportunity> listPartMarket{get;set;} 
    public List<OpportunityLineItem> listProd{get;set;}
    public List<OpportunityLineItem> listECProd{get;set;} //satti
    public List<OpportunityLineItem> listDataProd{get;set;}//satti
    public Opportunity opp{get;set;}   
    public class MyException extends Exception{}
    //public Boolean showQuoteButton{get;set;}
    public Opportunity oppIns{get;set;}
    public Decimal mediaESTImpressions{get;set;}
    public Decimal mediaDelCost{get;set;}
    public Decimal mediaCost{get;set;}
    public Decimal mediaValue{get;set;}
    public String mediaESTImpressionsString{get;set;}
    public String mediaDelCostString{get;set;}
    public String mediaCostString{get;set;}
    public String mediaValueString{get;set;}
    public Decimal eCESTImpressions{get;set;}
    public Decimal eCDelCost{get;set;}
    public Decimal eCCost{get;set;}
    public Decimal eCValue{get;set;}
    public String eCESTImpressionsString{get;set;}
    public String eCDelCostString{get;set;}
    public String eCCostString{get;set;}
    public String eCValueString{get;set;}
    public Decimal dataESTImpressions{get;set;}
    public Decimal dataDelCost{get;set;}
    public Decimal dataCost{get;set;}
    public Decimal dataValue{get;set;}
    public String dataESTImpressionsString{get;set;}
    public String dataDelCostString{get;set;}
    public String dataCostString{get;set;}
    public String dataValueString{get;set;}
    public Decimal totalESTImpressions{get;set;}
    public Decimal totalDelCost{get;set;}
    public Decimal totalCost{get;set;}
    public Decimal totalValue{get;set;}
    public String totalESTImpressionsString{get;set;}
    public String totalDelCostString{get;set;}
    public String totalCostString{get;set;}
    public String totalValueString{get;set;}
    
    public CW_OpportunityDetailController(ApexPages.StandardController controller)
     {

        indexNumber = 0;
        opp = (Opportunity)controller.getRecord(); 
        oppIns = [select id, ownerId, CloseDate, Name, StageName, AccountId, Funding_Source__c, Probability from Opportunity where id =: opp.id];   
        listProd = new List<OpportunityLineItem>();
        listECProd=new List<OpportunityLineItem>();
        listDataProd=new List<OpportunityLineItem>();
        mediaESTImpressions = 0;
        mediaDelCost = 0;
        mediaCost = 0;
        mediaValue = 0;
        eCESTImpressions = 0;
        eCDelCost = 0;
        eCCost = 0;
        eCValue = 0;
        dataESTImpressions = 0;
        dataDelCost = 0;
        dataCost = 0;
        dataValue = 0;
        totalESTImpressions = 0;
        totalDelCost = 0;
        totalCost = 0;
        totalValue = 0;
   
         listProd=[select id,Name,Product_Category__c,Product_Type__c,Quantity,ListPrice,UnitPrice,Delivery_Cost_2__c,Est_Impressions__c, DMA__c, State__c, Description from OpportunityLineItem where OPPORTUNITYID =: opp.id AND Product_Category__c='Media'];          
         listECProd=[select id,Name,Product_Category__c,Product_Type__c,Quantity,ListPrice,UnitPrice,Delivery_Cost_2__c,Est_Impressions__c, DMA__c, State__c, Description from OpportunityLineItem where OPPORTUNITYID =: opp.id AND Product_Category__c='Enabling Capability'];
         listDataProd=[select id,Name,Product_Category__c,Product_Type__c,Quantity,ListPrice,UnitPrice,Delivery_Cost_2__c,Est_Impressions__c, DMA__c, State__c, Description from OpportunityLineItem where OPPORTUNITYID =: opp.id AND Product_Category__c='Data'];
         
         //Priyanka start - 9/18/2015
         for(OpportunityLineItem OpportunityLineItem : listProd)  
         {
            if(OpportunityLineItem.Est_Impressions__c != null)
                mediaESTImpressions += OpportunityLineItem.Est_Impressions__c;
            if(OpportunityLineItem.Delivery_Cost_2__c != null)
                mediaDelCost += OpportunityLineItem.Delivery_Cost_2__c;
            if(OpportunityLineItem.UnitPrice != null)
                mediaCost += OpportunityLineItem.UnitPrice;
            if(OpportunityLineItem.ListPrice != null)
                mediaValue += OpportunityLineItem.ListPrice;
         }
         if(mediaESTImpressions == 0)
         {
            mediaESTImpressions = null;
            mediaESTImpressionsString = null;
         }
         else
         {
            mediaESTImpressionsString = ''+String.valueOf(mediaESTImpressions);
         }
         
        if(mediaDelCost == 0)
        {
            mediaDelCost = null;
            mediaDelCostString = null;
        }
        else
         {
            mediaDelCostString = '$'+String.valueOf(mediaDelCost);
         }
         
        if(mediaCost == 0)
        {
            mediaCost = null;
            mediaCostString = null;
        }
        else
         {
            mediaCostString = '$'+String.valueOf(mediaCost);
         }
        
        if(mediaValue == 0)
        {
            mediaValue = null;
            mediaValueString = null;
        }
        else
         {
            mediaValueString = '$'+String.valueOf(mediaValue);
         }
            
        for(OpportunityLineItem OpportunityLineItem : listECProd)  
         {
            if(OpportunityLineItem.Est_Impressions__c != null)
                eCESTImpressions += OpportunityLineItem.Est_Impressions__c;
            if(OpportunityLineItem.Delivery_Cost_2__c != null)
                eCDelCost += OpportunityLineItem.Delivery_Cost_2__c;
            if(OpportunityLineItem.UnitPrice != null)
                eCCost += OpportunityLineItem.UnitPrice;
            if(OpportunityLineItem.ListPrice != null)
                eCValue += OpportunityLineItem.ListPrice;
         }
         if(eCESTImpressions == 0)
         {
            eCESTImpressions = null;
            eCESTImpressionsString = null;
         }
         else
         {
            eCESTImpressionsString = ''+String.valueOf(eCESTImpressions);
         }
         
        if(eCDelCost == 0)
        {
            eCDelCost = null;
            eCDelCostString = null;
        }
        else
         {
            eCDelCostString = '$'+String.valueOf(eCDelCost);
         }
        
        if(eCCost == 0)
        {
            eCCost = null;
            eCCostString = null;
        }
        else
         {
            eCCostString = '$'+String.valueOf(eCCost);
         }
        
        if(eCValue == 0)
        {
            eCValue = null;
            eCValueString = null;
        }
        else
         {
            eCValueString = '$'+String.valueOf(eCValue);
         }
            
        for(OpportunityLineItem OpportunityLineItem : listDataProd)  
         {
            if(OpportunityLineItem.Est_Impressions__c != null)
                dataESTImpressions += OpportunityLineItem.Est_Impressions__c;
            if(OpportunityLineItem.Delivery_Cost_2__c != null)
                dataDelCost += OpportunityLineItem.Delivery_Cost_2__c;
            if(OpportunityLineItem.UnitPrice != null)
                dataCost += OpportunityLineItem.UnitPrice;
            if(OpportunityLineItem.ListPrice != null)
                dataValue += OpportunityLineItem.ListPrice;
         }
         if(dataESTImpressions == 0)
         {
            dataESTImpressions = null;
            dataESTImpressionsString = null;
         }
         else
         {
            dataESTImpressionsString = ''+String.valueOf(dataESTImpressions);
         }
         
        if(dataDelCost == 0)
        {
            dataDelCost = null;
            dataDelCostString = null;
        }
        else
         {
            dataDelCostString = '$'+String.valueOf(dataDelCost);
         }
        
        if(dataCost == 0)
        {
            dataCost = null;
            dataCostString = null;
        }
        else
         {
            dataCostString = '$'+String.valueOf(dataCost);
         }
        
        if(dataValue == 0)
        {
            dataValue = null;
            dataValueString = null;
        }
        else
         {
            dataValueString = '$'+String.valueOf(dataValue);
         }
         
        if(mediaESTImpressions != null)
            totalESTImpressions += mediaESTImpressions;
        if(eCESTImpressions != null)
            totalESTImpressions += eCESTImpressions;
        if(dataESTImpressions != null)
            totalESTImpressions += dataESTImpressions;
            
        if(mediaDelCost != null)
            totalDelCost += mediaDelCost;
        if(eCDelCost != null)
            totalDelCost += eCDelCost;
        if(dataDelCost != null)
            totalDelCost += dataDelCost;
        
        if(mediaCost != null)
            totalCost += mediaCost;
        if(eCCost != null)
            totalCost += eCCost;
        if(dataCost != null)
            totalCost += dataCost;
            
        if(mediaValue != null)
            totalValue += mediaValue;
        if(eCValue != null)
            totalValue += eCValue;
        if(dataValue != null)
            totalValue += dataValue;
        
        if(totalESTImpressions == 0)
        {
            totalESTImpressions = null;
            totalESTImpressionsString = null;
        }
        else
         {
            totalESTImpressionsString = ''+String.valueOf(totalESTImpressions);
         }
         
         if(totalDelCost == 0)
        {
            totalDelCost = null;
            totalDelCostString = null;
        }
        else
         {
            totalDelCostString = '$'+String.valueOf(totalDelCost);
         }
         
         if(totalCost == 0)
        {
            totalCost = null;
            totalCostString = null;
        }
        else
         {
            totalCostString = '$'+String.valueOf(totalCost);
         }
         
         if(totalValue == 0)
        {
            totalValue = null;
            totalValueString = null;
        }
        else
         {
            totalValueString = '$'+String.valueOf(totalValue);
         }
        
         
          //Priyanka end - 9/18/2015  
  
       }
       
       
       public PageReference edit()
       {
       Pagereference redirectPage = new Pagereference('/apex/CW_NewOpportunity3?id='+opp.id);
       redirectPage.setRedirect(true);
       return redirectPage;
       }
       
       public PageReference generateQuoteReport()
       {
       Pagereference redirectPage = new Pagereference('/apex/CW_QuoteValueReport?id='+opp.id);
       redirectPage.setRedirect(true);
       return redirectPage;
       }
       
       
       

}