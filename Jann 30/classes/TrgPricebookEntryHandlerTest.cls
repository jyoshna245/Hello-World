@isTest(seeAllData = true)
public class TrgPricebookEntryHandlerTest {
    
    static testMethod void testProductInsert() {
        
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
                
                
                }
                }
                }