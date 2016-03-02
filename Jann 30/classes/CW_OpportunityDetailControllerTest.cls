@isTest(seeAllData=true)
private class CW_OpportunityDetailControllerTest 
{

static testmethod void TestOpportunity() 
 
 {       
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
                oppLI.Product_Category__c='Media';
                oppLI.Product_Type__c='CCIV';
                oppLI.DMA__c='GA';
                oppLI.State__c='ANDHRA';
                oppLIList.add(oppLI);
              
                
                OpportunityLineItem oppLI2 = new OpportunityLineItem();             
                oppLI2.UnitPrice = pbe.UnitPrice;                   
                oppLI2.Opportunity = opp;
                oppLI2.OpportunityId = opp.id;
                oppLI2.pricebookentryid = pbe.id;
                oppLI2.Quantity = 3;
                oppLI2.UnitPrice = 10.00;
                oppLI2.Product_Category__c='Data';
                oppLI2.Product_Type__c='Cinema';
                oppLI2.DMA__c='AP';
                oppLI2.State__c='ANDHRA';
                oppLI2.Est_Impressions__c=100;
       //       oppLI2.Delivery_Cost_2__c=200;
                oppLIList.add(oppLI2);
                
                
                OpportunityLineItem oppLI3 = new OpportunityLineItem();             
                oppLI3.UnitPrice = pbe.UnitPrice;                   
                oppLI3.Opportunity = opp;
                oppLI3.OpportunityId = opp.id;
                oppLI3.pricebookentryid = pbe.id;
                oppLI3.Quantity = 3;
                oppLI3.UnitPrice = 10.00;
                oppLI3.Product_Category__c='Enabling Capability';
                oppLI3.Product_Type__c='OOH';
                oppLI3.DMA__c='TN';
                oppLI3.State__c='ANDHRA';
                oppLI3.Est_Impressions__c=100;
      //        oppLI3.Delivery_Cost_2__c=200;
                oppLIList.add(oppLI3);
                insert oppLIList;       
                
                
        Test.startTest();
        
        Test.setCurrentPage(Page.CW_OpportunityDetailPage);
        ApexPages.currentPage().getParameters().put('id',opp.id);
       
        ApexPages.StandardController ctrl = new ApexPages.StandardController(opp);
        CW_OpportunityDetailController extn = new CW_OpportunityDetailController(ctrl); 
        
        extn.mediaESTImpressions = 10;
        extn.edit();
        extn.generateQuoteReport();
        
        Test.stopTest();       
    }        
          
       
       
           
       
       
       
       }
       
       
       
       
       
       
       
         
       
       
      }