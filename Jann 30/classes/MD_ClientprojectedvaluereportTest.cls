@isTest(seeAllData = true)
public class MD_ClientprojectedvaluereportTest{
    
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
                opp.Client_Lead__c=u.id;
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
                quo.Internal_Cost__c=10;
                insert quo; 
                system.debug('new acc'+ quo.AccountId); 

                List<QuoteLineItem> quoLIList = new List<QuoteLineItem>();
                QuoteLineItem quoLI = new QuoteLineItem();
                quoLI.QuoteId = quo.Id;
                quoLI.Product2Id = prod.id;
                quoLI.PricebookEntryId = pbe.id;
                quoLI.Quantity = 2;
                quoLI.UnitPrice = 20.00;
                quoLI.Fair_Market_Value_Price__c=10;
                quoLI.Product_Category__c='Media';
                quoLI.Credits__c=10;
                quoLI.Internal_Cost__c=11;   
                quoLI.Delivery_Cost__c=12; 
                quoLI.Start_Date__c=Date.today();
                quoLI.End_Date__c=Date.today()+7;
                quoLIList.add(quoLI);
                
                QuoteLineItem quoLI2 = new QuoteLineItem();
                quoLI2.QuoteId = quo.Id;
                quoLI2.Product2Id = prod.id;
                quoLI2.PricebookEntryId = pbe.id;
                quoLI2.Quantity = 3;
                quoLI2.UnitPrice = 10.00;
                quoLI2.Fair_Market_Value_Price__c=15;
                quoLI2.Product_Category__c='Capability';
                quoLI2.Credits__c=10;
                quoLI2.Internal_Cost__c=11;   
                quoLI2.Delivery_Cost__c=12; 
                quoLI2.Start_Date__c=Date.today();
                quoLI2.End_Date__c=Date.today()+7;
                quoLIList.add(quoLI2);
                
                QuoteLineItem quoLI3 = new QuoteLineItem();
                quoLI3.QuoteId = quo.Id;
                quoLI3.Product2Id = prod.id;
                quoLI3.PricebookEntryId = pbe.id;
                quoLI3.Quantity = 3;
                quoLI3.UnitPrice = 10.00;
                quoLI3.Fair_Market_Value_Price__c=15;
                quoLI3.Product_Category__c='Data';
                quoLI3.Credits__c=10;
                quoLI3.Internal_Cost__c=11;   
                quoLI3.Delivery_Cost__c=12;
                quoLI3.Start_Date__c=Date.today();
                quoLI3.End_Date__c=Date.today()+7; 
                quoLIList.add(quoLI3);                
                insert quoLIList;
                
                
                Attachment attach=new Attachment();    
                attach.Name='Unit Test Attachment';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                attach.parentId=quo.id;
                insert attach;
                
              //  List<Attachment> attachments=[select id, name from Attachment where parent.id=:quo.id];
                
                
                
                
                
                
                
                
            //Data setup ends
            
            
            
        Test.startTest();
        Test.setCurrentPage(Page.MD_ClientprojectedvaluereportPage);
        ApexPages.currentPage().getParameters().put('id',quo.id);
       
        ApexPages.StandardController ctrl = new ApexPages.StandardController(quo);
        MD_Clientprojectedvaluereport extn = new MD_Clientprojectedvaluereport(ctrl); 
        
        extn.save();
        extn.saveInternalReport();
        extn.saveTeamReport();
                    
        Test.stopTest();       
            
            }
            }
          
            
            
            
            }