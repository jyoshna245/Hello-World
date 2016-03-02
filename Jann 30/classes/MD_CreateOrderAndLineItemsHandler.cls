public class MD_CreateOrderAndLineItemsHandler
{

    
   
    
    
     public static void OnAfterUpdate(List<Quote> newQuoteList)
    {
    List<Order> listOfOrderToInsert = new List<Order>();
    Set<Id> setOfQuoteIds = new Set<Id>();  
    List<Opportunity> oppList = new List<Opportunity>();
    Set<Id> oppSetForUpdate = new Set<Id>();
    Pricebook2 pb =[select id,name from pricebook2 where isStandard= true limit 1];
    
    for(Quote quo : newQuoteList)
    {    
        setOfQuoteIds.add(quo.Id);
        if(quo.Status == 'Accepted')
        {
            Order ord = new Order();
            ord.AccountId = quo.AccountId;
            ord.OpportunityId = quo.OpportunityId;
            ord.QuoteId = quo.id;
            ord.EffectiveDate = Date.today();
            ord.Status = 'Open';
            ord.pricebook2id = pb.id;
            listOfOrderToInsert.add(ord);
            oppSetForUpdate.add(quo.OpportunityId);            
        }
    }
    oppList = [select id, StageName, AccountId from Opportunity where id IN: oppSetForUpdate];
    if(oppList != null && oppList.size() != 0)
    {
        for(Opportunity opp : oppList)
        {
            opp.StageName = 'Won';
        }
        update oppList;
    }   
    if(listOfOrderToInsert != null && listOfOrderToInsert.size() != 0)
    {
        for(Opportunity opp : oppList)
        {
            for(Order ord : listOfOrderToInsert)
            {
                if(ord.OpportunityId == opp.id && ord.AccountId == null)
                    ord.AccountId = opp.AccountId;
            }
        }
        insert listOfOrderToInsert;
        //Map<Id, List<QuoteLineItem>> mapOfIdAndQLI = new Map<Id, List<QuoteLineItem>>([select id,(select id, Credits__c, Delivery_Cost__c, DMA__c, End_Date__c, Est_Impressions__c, Fair_Market_Value_Price__c, Product_Category__c, Product_Type__c, Start_Date__c, State__c, ZIP__c from QuoteLineItems) from Quote where id IN: setOfQuoteIds]);
        List<QuoteLineItem> quoLIList = new List<QuoteLineItem>(); 
        quoLIList = [select id, QuoteId, Credits__c, Delivery_Cost__c, UnitPrice,pricebookentryid, Quantity, DMA__c, End_Date__c, Est_Impressions__c, Fair_Market_Value_Price__c, Product_Category__c, Product_Type__c, Start_Date__c, State__c, ZIP__c from QuoteLineItem where QuoteId IN : setOfQuoteIds];
        List<OrderItem> listOfOrderItemToInsert = new List<OrderItem>();   
        for(Order o : listOfOrderToInsert)
        {
            for(Quote quo : newQuoteList)
            {
                if(o.QuoteId == quo.Id && quo.Status == 'Accepted')
                {
                    //quoLIList.clear();
                    if(quoLIList != null && quoLIList.size() != 0)
                    {
                        for(QuoteLineItem qli : quoLIList)
                        {
                            if(qli.QuoteId == quo .id)
                            {
                                OrderItem ordItem = new OrderItem();
                                ordItem.OrderId = o.Id;
                                ordItem.QuoteLineItemId = qli.Id;
                                ordItem.Credits__c = qli.Credits__c;
                                ordItem.Delivery_Cost__c = qli.Delivery_Cost__c;
                                ordItem.DMA__c = qli.DMA__c;
                                ordItem.End_Date__c = qli.End_Date__c;
                                ordItem.Est_Impressions__c = qli.Est_Impressions__c;
                                ordItem.Fair_Market_Value_Price__c = qli.Fair_Market_Value_Price__c;
                                ordItem.Product_Category__c = qli.Product_Category__c;
                                ordItem.Product_Type__c = qli.Product_Type__c;
                                ordItem.Start_Date__c = qli.Start_Date__c;
                                ordItem.State__c = qli.State__c;
                                ordItem.ZIP__c = qli.ZIP__c;
                                ordItem.pricebookentryid = qli.pricebookentryid;
                                ordItem.Quantity = qli.Quantity;
                                ordItem.UnitPrice = qli.UnitPrice;
                                listOfOrderItemToInsert.add(ordItem);
                            }
                        }
                    }
                }
            }
        }
        
                           
        if(listOfOrderItemToInsert != null && listOfOrderItemToInsert.size() != 0){
            try {
                  insert listOfOrderItemToInsert;
            }
            catch(Exception ex){
                system.debug(ex);
            }
        }
            
            
    }
    



}


}