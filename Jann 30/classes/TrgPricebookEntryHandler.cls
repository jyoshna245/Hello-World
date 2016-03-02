public class TrgPricebookEntryHandler
{
  
    
   
    
    
     public static void OnInsert(List<Product2> newProductList)
    {
    list<Product2> lstproduct=new list<Product2>();
list<PricebookEntry> lstPbe=new list<PricebookEntry>();
 if(trigger.isinsert){
    Id StdPrcId=[Select id from PriceBook2 where isStandard=true limit 1].id;    
   for(Product2 objProduct:newProductList)
    {
    PricebookEntry PB=new PricebookEntry(Product2Id=objProduct.id,PriceBook2Id=StdPrcId,UnitPrice=objProduct.Total_Cost__c,IsActive=true,UseStandardPrice=false);
    lstPbe.add(PB);
    }
 try{ 
insert lstPbe;    } catch(Exception e){system.debug('Error :' +e.getMessage());}
 }
    }
    
    }