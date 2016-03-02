//
//
// Test class for MD_AddProduct class
//
// 16 Oct 2015  Priyanka Mukherjee
//

@isTest(seeAllData = true)
public class MD_AddProductTest {
    
    public static Account acc;
    public static Opportunity opp;
    public static List<Product2> listOfProducts;
    public static Product2 prod2;
    public static Product2 prod3;
    public static Product2 prod4;
    public static Product2 prod5;
    public static Product2 prod6;
    public static Product2 prod7;
    public static Product2 prod8;
    public static OpportunityLineItem oppLI;
    public static OpportunityLineItem oppLI2;
    public static PricebookEntry pbe;
    static
    {
        acc = new Account();
        acc.RecordTypeId = [select id, Name, SobjectType from RecordType where Name LIKE 'Media Desk' and SobjectType = 'Account' LIMIT 1].id;
        acc.Name = 'Test Account';
        insert acc;
        system.debug('old acc'+ acc.id);
        
        opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.CloseDate = Date.today();
        opp.StageName = 'Qualification';
        insert opp;
        
        listOfProducts = new List<Product2>();
        prod2 = new Product2();
        prod2.Name = 'Test Prod 1';
        prod2.IsActive = true;
        prod2.State__c = 'Arizona';
        prod2.DMA__c = '123';
        prod2.ZIP__c = '3456';
        prod2.Product_Category__c = 'Enabling Capability';
        prod2.Total_Cost__c = 20.00;        
        listOfProducts.add(prod2);      
        
        prod3 = new Product2();
        prod3.Name = 'Test Prod 2';
        prod3.IsActive = true;
        prod3.State__c = 'Odisha';
        prod3.DMA__c = '1345';
        prod3.ZIP__c = '34567';
        prod3.Product_Category__c = 'Data';
        prod3.Total_Cost__c = 30.00;
        listOfProducts.add(prod3);
        
        prod4 = new Product2();
        prod4.Name = 'Test Prod 3';
        prod4.IsActive = true;
        prod4.State__c = 'Odisha';
        prod4.DMA__c = '1345';
        prod4.ZIP__c = '34567';
        prod4.Product_Category__c = 'Media';
        prod4.Product_Type__c = 'CCIV';
        prod4.Total_Cost__c = 30.00;
        prod4.Day_Part__c = 'Day Part: 11:00a -1:59p';
        listOfProducts.add(prod4);
        
        prod5 = new Product2();
        prod5.Name = 'Test Prod 4';
        prod5.IsActive = true;
        prod5.State__c = 'Odisha';
        prod5.DMA__c = '1345';
        prod5.ZIP__c = '34567';
        prod5.Product_Category__c = 'Media';
        prod5.Product_Type__c = 'CCIV';
        prod5.Total_Cost__c = 30.00;
        prod5.Day_Part__c = 'Day Part: 12:00a -11:59p';
        listOfProducts.add(prod5);
        
        prod6 = new Product2();
        prod6.Name = 'Test Prod 5';
        prod6.IsActive = true;
        prod6.State__c = 'Odisha';
        prod6.DMA__c = '1345';
        prod6.ZIP__c = '34567';
        prod6.Product_Category__c = 'Media';
        prod6.Product_Type__c = 'OOH';
        prod6.Total_Cost__c = 30.00;
        prod6.Day_Part__c = 'Day Part: 11:00a -1:59p';
        listOfProducts.add(prod6);
        
        prod7 = new Product2();
        prod7.Name = 'Test Prod 6';
        prod7.IsActive = true;
        prod7.State__c = 'Odisha';
        prod7.DMA__c = '1345';
        prod7.ZIP__c = '34567';
        prod7.Product_Category__c = 'Media';
        prod7.Product_Type__c = 'Transit';
        prod7.Total_Cost__c = 30.00;
        prod7.Day_Part__c = 'Day Part: 11:00a -1:59p';
        listOfProducts.add(prod7);
        
        prod8 = new Product2();
        prod8.Name = 'Test Prod 7';
        prod8.IsActive = true;
        prod8.State__c = 'Odisha';
        prod8.DMA__c = '1345';
        prod8.ZIP__c = '34567';
        prod8.Product_Category__c = 'Media';
        prod8.Product_Type__c = 'Cinema';
        prod8.Total_Cost__c = 30.00;
        prod8.Day_Part__c = 'Day Part: 11:00a -1:59p';
        listOfProducts.add(prod8);
        insert listOfProducts;
        
        Pricebook2 standard = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Standard Price Book';
        pb.IsActive = true;
        insert pb;    
        
        pbe = new PricebookEntry();
        pbe.Pricebook2Id = pb.id;
        pbe.Product2Id = prod2.Id;
        pbe.IsActive = true;
        pbe.UnitPrice = 80.00;
        //pbe.UseStandardPrice = false;
        insert pbe;        
        
        List<OpportunityLineItem> oppLIList = new List<OpportunityLineItem>();
        oppLI = new OpportunityLineItem();              
        oppLI.UnitPrice = pbe.UnitPrice;                    
        oppLI.Opportunity = opp;
        oppLI.OpportunityId = opp.id;
        oppLI.pricebookentryid = pbe.id;
        oppLI.Quantity = 2;
        oppLI.UnitPrice = 20.00;
        oppLIList.add(oppLI);
        
        oppLI2 = new OpportunityLineItem();             
        oppLI2.UnitPrice = pbe.UnitPrice;                   
        oppLI2.Opportunity = opp;
        oppLI2.OpportunityId = opp.id;
        oppLI2.pricebookentryid = pbe.id;
        oppLI2.Quantity = 3;
        oppLI2.UnitPrice = 10.00;
        oppLIList.add(oppLI2);
        insert oppLIList;       
    }
    
    static testMethod void testConstructor()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        MD_AddProduct.WrapperForproductsAndCheckbox wrapCheck= new MD_AddProduct.WrapperForproductsAndCheckbox();
        MD_AddProduct.WrapperForLineItemAndProdName  wrapProd= new MD_AddProduct.WrapperForLineItemAndProdName ();              
        test.stopTest();        
    }
    
    static testMethod void testFetchProductsForNullName()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Capability';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        //prod.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.fetchproducts();
        test.stopTest();        
    }
    
    static testMethod void testFetchProductsForNotNullName()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        //prod.Product_Category__c = 'Enabling Capability';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.fetchproducts();
        extension.dynamicFetch();
        test.stopTest();        
    }
    
    static testMethod void testFetchProductsForECAndData()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Capability';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.fetchproducts();
        test.stopTest();        
    }
    
    static testMethod void testPrevNext()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Capability';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.totalRecs  = 10;
        //extension.previous();
        extension.next();
        extension.getprev();
        extension.getnxt();
        test.stopTest();        
    }
    
    static testMethod void testPrevNextForHigherIndex()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Capability';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.totalRecs  = 1000;
        //extension.previous();
        //extension.next();
        extension.getprev();
        extension.getnxt();
        test.stopTest();        
    }
    
    static testMethod void testMediaCCIV()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        extension.prod.Product_Type__c = 'CCIV';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.fetchproducts();
        test.stopTest();        
    }
    
    static testMethod void testMediaOOH()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        extension.prod.Product_Type__c = 'OOH';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.fetchproducts();
        test.stopTest();        
    }
    
    static testMethod void testMediaTransit()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        extension.prod.Product_Type__c = 'Transit';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.fetchproducts();
        test.stopTest();        
    }
    
    static testMethod void testMediaCinema()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        extension.prod.Product_Type__c = 'Cinema';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.fetchproducts();
        test.stopTest();        
    }
    
    static testMethod void testOnlyMedia()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        //extension.prod.Product_Type__c = 'Cinema';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.fetchproducts();
        test.stopTest();        
    }
    
    static testMethod void testOnlyName()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        //extension.prod.Product_Category__c = 'Media';
        //extension.prod.Product_Type__c = 'Cinema';
        extension.prod.Day_Part__c = 'Day Part: 12:00a -11:59p';
        extension.prod.Start_Date__c = Date.today();
        extension.prod.End_Date__c = Date.today();
        extension.prod.Number_of_Slots__c = '2';
        extension.prodName = 'Test Prod 1';
        extension.asstName = 'Test Prod 1';
        extension.selectedContacts = new List<SelectOption>();
        extension.selectedContacts.add(new SelectOption(prod2.id,prod2.State__c));                 
        extension.selectedDMA = new List<SelectOption>();
        extension.selectedDMA.add(new SelectOption(prod2.id,prod2.DMA__c));
        extension.selectedZIP = new List<SelectOption>();
        extension.selectedZIP.add(new SelectOption(prod2.id,prod2.ZIP__c));
        extension.fetchproducts();
        test.stopTest();        
    }
    
    static testMethod void testSelectedProducts()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        //List<MD_AddProduct.WrapperForProductsAndCheckbox>  wrapProdList= new List<MD_AddProduct.WrapperForProductsAndCheckbox>();   
        MD_AddProduct.WrapperForProductsAndCheckbox wrapProd1 = new MD_AddProduct.WrapperForProductsAndCheckbox();
        MD_AddProduct.WrapperForProductsAndCheckbox wrapProd2 = new MD_AddProduct.WrapperForProductsAndCheckbox();
        wrapProd1.prodInstance = prod2;
        wrapProd1.checkBox = true;
        wrapProd2.prodInstance = prod3;
        wrapProd2.checkBox = true;
        extension.listWrap = new List<MD_AddProduct.WrapperForProductsAndCheckbox>();
        extension.listWrap.add(wrapProd1);
        extension.listWrap.add(wrapProd2);
        extension.listToBeSentToOpp = new List<Product2>();
        extension.selectProducts();
        test.stopTest();
    }
    
    static testMethod void testRenderFieldsForData()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Data';
        extension.renderFields();
        test.stopTest();
    }
    
    static testMethod void testRenderFieldsForMedia()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        extension.renderFields();
        test.stopTest();
    }
    
    static testMethod void testRenderMediaCCIV()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        extension.prod.Product_Type__c = 'CCIV';
        extension.renderMedia();
        test.stopTest();
    }
    
    static testMethod void testRenderMediaOOH()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        extension.prod.Product_Type__c = 'OOH';
        extension.renderMedia();
        test.stopTest();
    }
    
    static testMethod void testRenderMediaTransit()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        extension.prod.Product_Type__c = 'Transit';
        extension.renderMedia();
        test.stopTest();
    }
    
    static testMethod void testRenderMediaCinema()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Media';
        extension.prod.Product_Type__c = 'Cinema';
        extension.renderMedia();
        test.stopTest();
    }
    
    static testMethod void testRenderMediaElseClause()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.prod.Product_Category__c = 'Data';
        extension.prod.Product_Type__c = 'Cinema';
        extension.renderMedia();
        test.stopTest();
    }
    
    static testMethod void testSaveOppLineItem()
    {
        
        User u = [select id from User where id=: UserInfo.getUserId()];
        //Pricebook2 pb = [select id,name from pricebook2 where isStandard= true limit 1];
        test.startTest();                   
        MD_AddProduct extension = null;
        ApexPages.StandardController standardController = null;
        standardController = new ApexPages.standardController(opp);
        extension = new MD_AddProduct(standardController);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        MD_AddProduct ins = new MD_AddProduct();
        extension.prod = new Product2();
        extension.listWrapLI = new List<MD_AddProduct.WrapperForLineItemAndProdName>();
        MD_AddProduct.WrapperForLineItemAndProdName ins1 = new MD_AddProduct.WrapperForLineItemAndProdName();
        MD_AddProduct.WrapperForLineItemAndProdName ins2 = new MD_AddProduct.WrapperForLineItemAndProdName();
        OpportunityLineItem oppLItem1 = new OpportunityLineItem();                
        oppLItem1.UnitPrice = 20.00;                    
        oppLItem1.Opportunity = opp;
        oppLItem1.OpportunityId = opp.id;
        oppLItem1.pricebookentryid = pbe.id;
        oppLItem1.Quantity = 2;                
        ins1.prodName = 'Prod 1';
        ins1.oppLineItem = oppLItem1;
        OpportunityLineItem oppLItem2 = new OpportunityLineItem();                
        oppLItem2.UnitPrice = pbe.UnitPrice;                    
        oppLItem2.Opportunity = opp;
        oppLItem2.OpportunityId = opp.id;
        oppLItem2.pricebookentryid = pbe.id;
        oppLItem2.Quantity = 2;
        oppLItem2.UnitPrice = 20.00;                
        ins2.oppLineItem = oppLItem2;
        ins2.prodName = 'Prod 2';
        extension.listWrapLI.add(ins1);
        extension.listWrapLI.add(ins2);
        extension.saveOppLineItem();
        test.stopTest();
    }
    
}