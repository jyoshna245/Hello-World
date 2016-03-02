//
//
// Test class for MD_CreateOrderAndLineItems trigger
//
// 15 Oct 2015  Priyanka Mukherjee
//

@isTest(seeAllData = true)
public class MD_CreateOrderAndLineItemsHandlerTest {
    
    static testMethod void testQuoteUpdate() {
        
            //Data setup starts
                User u = [select id from User where id=: UserInfo.getUserId()];
                //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
                system.runAs(u){
                Pricebook2 pb = new Pricebook2();
                pb.Name = 'Standard Price Book';
                pb.IsActive = true;
                insert pb;              
                
                Account acc = new Account();
                acc.RecordTypeId = [select id, Name, SobjectType from RecordType where Name LIKE 'Media Desk' and SobjectType = 'Account' LIMIT 1].id;
                acc.Name = 'Test Account';
                insert acc;
                system.debug('old acc'+ acc.id);
            
                Opportunity opp = new Opportunity();
                opp.Name = 'Test Opp';
                opp.AccountId = acc.id;
                opp.CloseDate = Date.today();
                opp.StageName = 'Qualification';
                insert opp;
                
                Product2 prod = new Product2();
                prod.Name = 'Test Prod';
                prod.IsActive = true;
                prod.Total_Cost__c=100;
                insert prod;
                
                //PricebookEntry pbe = [select id, Product2Id, UnitPrice,IsActive from PricebookEntry where Pricebook2Id  =: pb.id LIMIT 1];
                //pbe.Product2Id = prod.Id;
                //update pbe;
                PricebookEntry pbe = new PricebookEntry();
                pbe.Pricebook2Id = pb.id;
                pbe.Product2Id = prod.Id;
                pbe.IsActive = true;
                pbe.UnitPrice = 80.00;
                //pbe.UseStandardPrice = false;
                insert pbe;
                
                List<OpportunityLineItem> oppLIList = new List<OpportunityLineItem>();
                OpportunityLineItem oppLI = new OpportunityLineItem();              
                oppLI.UnitPrice = pbe.UnitPrice;                    
                oppLI.Opportunity = opp;
                oppLI.OpportunityId = opp.id;
                oppLI.pricebookentryid = pbe.id;
                oppLI.Quantity = 2;
                oppLI.UnitPrice = 20.00;
                oppLIList.add(oppLI);
                
                OpportunityLineItem oppLI2 = new OpportunityLineItem();             
                oppLI2.UnitPrice = pbe.UnitPrice;                   
                oppLI2.Opportunity = opp;
                oppLI2.OpportunityId = opp.id;
                oppLI2.pricebookentryid = pbe.id;
                oppLI2.Quantity = 3;
                oppLI2.UnitPrice = 10.00;
                oppLIList.add(oppLI2);
                insert oppLIList;       
                
                Quote quo = new Quote();
                quo.Name = 'Test Quote';
                //quo.Account = acc;
                quo.Pricebook2Id = pb.id;
                quo.OpportunityId = opp.Id;
                insert quo; 
                system.debug('new acc'+ quo.AccountId); 

                List<QuoteLineItem> quoLIList = new List<QuoteLineItem>();
                QuoteLineItem quoLI = new QuoteLineItem();
                quoLI.QuoteId = quo.Id;
                quoLI.Product2Id = prod.id;
                quoLI.PricebookEntryId = pbe.id;
                quoLI.Quantity = 2;
                quoLI.UnitPrice = 20.00;
                quoLIList.add(quoLI);
                
                QuoteLineItem quoLI2 = new QuoteLineItem();
                quoLI2.QuoteId = quo.Id;
                quoLI2.Product2Id = prod.id;
                quoLI2.PricebookEntryId = pbe.id;
                quoLI2.Quantity = 3;
                quoLI2.UnitPrice = 10.00;
                quoLIList.add(quoLI2);
                insert quoLIList;
            //Data setup ends
            
            test.startTest();
                quo.Status = 'Accepted';
                try{
                    update quo;
                }
                catch(Exception ex)
                {
                    system.debug(ex);
                }
            test.stopTest();
            }
    }
    
}