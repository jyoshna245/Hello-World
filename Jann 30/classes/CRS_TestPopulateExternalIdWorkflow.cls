@IsTest
public with sharing class CRS_TestPopulateExternalIdWorkflow {
    /*
    * author: Ivan_Tsitulenka
    * workflow: CRS_Beverage_Category__c, CRS_Brand__c, CRS_Business_Unit__c,
    * CRS_Country__c, CRS_CRS_Product__c, CRS_Flavor__c, CRS_Media_Type__c,
    * CRS_Package_Type__c, CRS_Type__c 
    * rules: CRS_*_Populate_External_Id
    */
    
    private static CRS_Type__c[] createType(){
        CRS_Type__c[] testData = new CRS_Type__c[]{
            new CRS_Type__c(Name = 'Testimonial communication', Active__c = 'Yes', 
                gvwCRS__c = false),
            new CRS_Type__c(Name = 'Natural Claim', Active__c = 'Yes', 
                gvwCRS__c = true)
        };
        insert testData;
        return testData;
    }
    
    private static CRS_Package_Type__c[] createPType(){
        CRS_Package_Type__c[] testData = new CRS_Package_Type__c[]{
            new CRS_Package_Type__c(Name = 'Live Positively', Active__c = 'Yes', 
                gvwCRS__c = false),
            new CRS_Package_Type__c(Name = 'Bottle', Active__c = 'Yes', 
                gvwCRS__c = true)
        };
        insert testData;
        return testData;
    }
    
    private static CRS_Media_Type__c[] createMType(){
        CRS_Media_Type__c[] testData = new CRS_Media_Type__c[]{
            new CRS_Media_Type__c(Name = 'All Media Types - General Communications', Active__c = 'Yes', 
                gvwCRS__c = false),
            new CRS_Media_Type__c(Name = 'Trade Direct', Active__c = 'Yes', 
                gvwCRS__c = true)
        };
        insert testData;
        return testData;
    }
    
    private static CRS_Flavor__c[] createFlavor(){
        CRS_Flavor__c[] testData = new CRS_Flavor__c[]{
            new CRS_Flavor__c(Name = 'Honey Orange', Active__c = 'Yes', 
                gvwCRS__c = false),
            new CRS_Flavor__c(Name = 'All Flavors - General Communications', Active__c = 'Yes', 
                gvwCRS__c = true)
        };
        insert testData;
        return testData;
    }
    
    private static CRS_CRS_Product__c[] createProd(){
        CRS_CRS_Product__c[] testData = new CRS_CRS_Product__c[]{
            new CRS_CRS_Product__c(Name = 'All Products - General Communications', Active__c = 'Yes', 
                gvwCRS__c = false),
            new CRS_CRS_Product__c(Name = 'Ades', Active__c = 'Yes', 
                gvwCRS__c = true)
        };
        insert testData;
        return testData;
    }
    
    private static CRS_Business_Unit__c[] createBU(){
        CRS_Group__c[] testGroups = new CRS_Group__c[]{
            new CRS_Group__c(Name = 'Eurasia & Africa', Active__c = 'Yes'),
            new CRS_Group__c(Name = 'All Corporate Group', Active__c = 'Yes')
        };
        insert testGroups;
        testGroups = [select Id, Name from CRS_Group__c];
        CRS_Business_Unit__c[] testData = new CRS_Business_Unit__c[]{
            new CRS_Business_Unit__c(Name = 'All Eurasia & Africa', Active__c = 'Yes', 
                Group__c = testGroups[0].Id),
            new CRS_Business_Unit__c(Name = 'Corporate', Active__c = 'Yes', 
                Group__c = testGroups[1].Id)
        };
        insert testData;
        return testData;
    }
    
    private static CRS_Country__c[] createCountry(){
        createBU();
        CRS_Business_Unit__c[] listBU = [select Id, Name from CRS_Business_Unit__c];
        CRS_Country__c[] testData = new CRS_Country__c[]{
            new CRS_Country__c(Name = 'Greece', Active__c = 'Yes', 
                Business_Unit__c = listBU[0].Id),
            new CRS_Country__c(Name = 'All Europe', Active__c = 'Yes', 
                Business_Unit__c = listBU[1].Id)
        };
        insert testData;
        return testData;
    }
    
    private static CRS_Beverage_Category__c[] createBC(){
        CRS_Beverage_Category__c[] testBC = new CRS_Beverage_Category__c[]{
            new CRS_Beverage_Category__c(Name = 'General Communication Claims', Active__c = 'Yes', 
                gvwCRS__c = false),
            new CRS_Beverage_Category__c(Name = 'Dairy', Active__c = 'Yes', 
                gvwCRS__c = true)
        };
        insert testBC;
        return testBC;
    }
    
    private static CRS_Brand__c[] createBrand(){
        CRS_Brand__c[] testData = new CRS_Brand__c[]{
            new CRS_Brand__c(Name = 'All Brands - General Communications', Active__c = 'Yes', 
                gvwCRS__c = false),
            new CRS_Brand__c(Name = 'Birds Nest', Active__c = 'Yes', 
                gvwCRS__c = true)
        };
        insert testData;
        return testData;
    }
    //test Brand
    static testMethod void testInsertBrand(){
        CRS_Brand__c[] testData = createBrand();
        CRS_Brand__c testBrand = [select Id, Name, CRS_Brand_External_Id__c 
            from CRS_Brand__c where Name = : testData[0].Name];
        System.assert(testData[0].Name == testBrand.CRS_Brand_External_Id__c);
        testBrand = [select Id, Name, CRS_Brand_External_Id__c 
            from CRS_Brand__c where Name = : testData[1].Name];
        System.assert(('gvw'+testData[1].Name) == testBrand.CRS_Brand_External_Id__c);
    }
    
    static testMethod void testUpdateBrand(){
        CRS_Brand__c[] testData = createBrand();
        CRS_Brand__c testBrand = [select Id, Name, CRS_Brand_External_Id__c 
            from CRS_Brand__c where Name = : testData[0].Name];
        testBrand.gvwCRS__c = true;
        update testBrand;
        testBrand = [select Id, Name, CRS_Brand_External_Id__c 
            from CRS_Brand__c where Name = : testData[0].Name];
        System.assert('gvw'+testData[0].Name == testBrand.CRS_Brand_External_Id__c);
        
        testBrand = [select Id, Name, CRS_Brand_External_Id__c 
            from CRS_Brand__c where Name = : testData[1].Name];
        testBrand.gvwCRS__c = false;
        testBrand.Name = 'testtest123';
        update testBrand;
        testBrand = [select Id, Name, CRS_Brand_External_Id__c 
            from CRS_Brand__c where Name = 'testtest123'];
        System.assert('testtest123' == testBrand.CRS_Brand_External_Id__c);
    }
    //test BC
    static testMethod void testInsertBC(){
        CRS_Beverage_Category__c[] testData = createBC();
        CRS_Beverage_Category__c tempData = [select Id, Name, Beverage_Category_External_ID__c 
            from CRS_Beverage_Category__c where Name = : testData[0].Name];
        System.assert(testData[0].Name == tempData.Beverage_Category_External_ID__c);
        tempData = [select Id, Name, Beverage_Category_External_ID__c 
            from CRS_Beverage_Category__c where Name = : testData[1].Name];
        System.assert(('gvw'+testData[1].Name) == tempData.Beverage_Category_External_ID__c);
    }
    
    static testMethod void testUpdateBC(){
        CRS_Beverage_Category__c[] testData = createBC();
        CRS_Beverage_Category__c tempData = [select Id, Name, Beverage_Category_External_ID__c 
            from CRS_Beverage_Category__c where Name = : testData[0].Name];
        tempData.gvwCRS__c = true;
        update tempData;
        tempData = [select Id, Name, Beverage_Category_External_ID__c 
            from CRS_Beverage_Category__c where Name = : testData[0].Name];
        System.assert('gvw'+testData[0].Name == tempData.Beverage_Category_External_ID__c);
        
        tempData = [select Id, Name, Beverage_Category_External_ID__c 
            from CRS_Beverage_Category__c where Name = : testData[1].Name];
        tempData.gvwCRS__c = false;
        tempData.Name = 'testtest123';
        update tempData;
        tempData = [select Id, Name, Beverage_Category_External_ID__c 
            from CRS_Beverage_Category__c where Name = 'testtest123'];
        System.assert('testtest123' == tempData.Beverage_Category_External_ID__c);
    }
    
    //test CRS_Business_Unit
    static testMethod void testInsertBU(){
        CRS_Business_Unit__c[] testData = createBU();
        CRS_Business_Unit__c tempData = [select Id, Name, Business_Unit_External_Id__c 
            from CRS_Business_Unit__c where Name = : testData[0].Name];
        System.assert(testData[0].Name == tempData.Business_Unit_External_Id__c);
        tempData = [select Id, Name, Business_Unit_External_Id__c 
            from CRS_Business_Unit__c where Name = : testData[1].Name];
        System.assert((testData[1].Name) == tempData.Business_Unit_External_Id__c);
    }
    
    static testMethod void testUpdateBU(){
        CRS_Business_Unit__c[] testData = createBU();
        CRS_Business_Unit__c tempData = [select Id, Name, Business_Unit_External_Id__c 
            from CRS_Business_Unit__c where Name = : testData[0].Name];
        tempData.Name = 'Test_test_1';
        update tempData;
        tempData = [select Id, Name, Business_Unit_External_Id__c 
            from CRS_Business_Unit__c where Name = 'Test_test_1'];
        System.assert('Test_test_1' == tempData.Business_Unit_External_Id__c);
    }
    
    //test CRS_Country__c
    static testMethod void testInsertCountry(){
        CRS_Country__c[] testData = createCountry();
        CRS_Country__c tempData = [select Id, Name, CRS_Country_External_Id__c 
            from CRS_Country__c where Name = : testData[0].Name];
        System.assert(testData[0].Name == tempData.CRS_Country_External_Id__c);
    }
    
    static testMethod void testUpdateCountry(){
        CRS_Country__c[] testData = createCountry();
        CRS_Country__c tempData = [select Id, Name, CRS_Country_External_Id__c 
            from CRS_Country__c where Name = : testData[0].Name];
        tempData.Name = 'testtest123';
        update tempData;
        tempData = [select Id, Name, CRS_Country_External_Id__c 
            from CRS_Country__c where Name = 'testtest123'];
        System.assert('testtest123' == tempData.CRS_Country_External_Id__c);
    }
    
    //test CRS_CRS_Product__c
    static testMethod void testInsertProd(){
        CRS_CRS_Product__c[] testData = createProd();
        CRS_CRS_Product__c tempData = [select Id, Name, CRS_Product_External_ID__c 
            from CRS_CRS_Product__c where Name = : testData[0].Name];
        System.assert(testData[0].Name == tempData.CRS_Product_External_ID__c);
        tempData = [select Id, Name, CRS_Product_External_ID__c 
            from CRS_CRS_Product__c where Name = : testData[1].Name];
        System.assert(('gvw'+testData[1].Name) == tempData.CRS_Product_External_ID__c);
    }
    
    static testMethod void testUpdateProd(){
        CRS_CRS_Product__c[] testData = createProd();
        CRS_CRS_Product__c tempData = [select Id, Name, CRS_Product_External_ID__c 
            from CRS_CRS_Product__c where Name = : testData[0].Name];
        tempData.gvwCRS__c = true;
        update tempData;
        tempData = [select Id, Name, CRS_Product_External_ID__c 
            from CRS_CRS_Product__c where Name = : testData[0].Name];
        System.assert('gvw'+testData[0].Name == tempData.CRS_Product_External_ID__c);
        
        tempData = [select Id, Name, CRS_Product_External_ID__c 
            from CRS_CRS_Product__c where Name = : testData[1].Name];
        tempData.gvwCRS__c = false;
        tempData.Name = 'testtest123';
        update tempData;
        tempData = [select Id, Name, CRS_Product_External_ID__c 
            from CRS_CRS_Product__c where Name = 'testtest123'];
        System.assert('testtest123' == tempData.CRS_Product_External_ID__c);
    }
    
    //test CRS_Flavor__c
    static testMethod void testInsertFlavor(){
        CRS_Flavor__c[] testData = createFlavor();
        CRS_Flavor__c tempData = [select Id, Name, CRS_Flavor_External_ID__c 
            from CRS_Flavor__c where Name = : testData[0].Name];
        System.assert(testData[0].Name == tempData.CRS_Flavor_External_ID__c);
        tempData = [select Id, Name, CRS_Flavor_External_ID__c 
            from CRS_Flavor__c where Name = : testData[1].Name];
        System.assert(('gvw'+testData[1].Name) == tempData.CRS_Flavor_External_ID__c);
    }
    
    static testMethod void testUpdateFlavor(){
        CRS_Flavor__c[] testData = createFlavor();
        CRS_Flavor__c tempData = [select Id, Name, CRS_Flavor_External_ID__c 
            from CRS_Flavor__c where Name = : testData[0].Name];
        tempData.gvwCRS__c = true;
        update tempData;
        tempData = [select Id, Name, CRS_Flavor_External_ID__c 
            from CRS_Flavor__c where Name = : testData[0].Name];
        System.assert('gvw'+testData[0].Name == tempData.CRS_Flavor_External_ID__c);
        
        tempData = [select Id, Name, CRS_Flavor_External_ID__c 
            from CRS_Flavor__c where Name = : testData[1].Name];
        tempData.gvwCRS__c = false;
        tempData.Name = 'testtest123';
        update tempData;
        tempData = [select Id, Name, CRS_Flavor_External_ID__c 
            from CRS_Flavor__c where Name = 'testtest123'];
        System.assert('testtest123' == tempData.CRS_Flavor_External_ID__c);
    }
    
    //test CRS_Media_Type__c
    static testMethod void testInsertMType(){
        CRS_Media_Type__c[] testData = createMType();
        CRS_Media_Type__c tempData = [select Id, Name, CRS_Media_Type_External_ID__c 
            from CRS_Media_Type__c where Name = : testData[0].Name];
        System.assert(testData[0].Name == tempData.CRS_Media_Type_External_ID__c);
        tempData = [select Id, Name, CRS_Media_Type_External_ID__c 
            from CRS_Media_Type__c where Name = : testData[1].Name];
        System.assert(('gvw'+testData[1].Name) == tempData.CRS_Media_Type_External_ID__c);
    }
    
    static testMethod void testUpdateMType(){
        CRS_Media_Type__c[] testData = createMType();
        CRS_Media_Type__c tempData = [select Id, Name, CRS_Media_Type_External_ID__c 
            from CRS_Media_Type__c where Name = : testData[0].Name];
        tempData.gvwCRS__c = true;
        update tempData;
        tempData = [select Id, Name, CRS_Media_Type_External_ID__c 
            from CRS_Media_Type__c where Name = : testData[0].Name];
        System.assert('gvw'+testData[0].Name == tempData.CRS_Media_Type_External_ID__c);
        
        tempData = [select Id, Name, CRS_Media_Type_External_ID__c 
            from CRS_Media_Type__c where Name = : testData[1].Name];
        tempData.gvwCRS__c = false;
        tempData.Name = 'testtest123';
        update tempData;
        tempData = [select Id, Name, CRS_Media_Type_External_ID__c 
            from CRS_Media_Type__c where Name = 'testtest123'];
        System.assert('testtest123' == tempData.CRS_Media_Type_External_ID__c);
    }
    
    //test CRS_Package_Type__c
    static testMethod void testInsertPType(){
        CRS_Package_Type__c[] testData = createPType();
        CRS_Package_Type__c tempData = [select Id, Name, CRS_Package_Type_External_ID__c 
            from CRS_Package_Type__c where Name = : testData[0].Name];
        System.assert(testData[0].Name == tempData.CRS_Package_Type_External_ID__c);
        tempData = [select Id, Name, CRS_Package_Type_External_ID__c 
            from CRS_Package_Type__c where Name = : testData[1].Name];
        System.assert(('gvw'+testData[1].Name) == tempData.CRS_Package_Type_External_ID__c);
    }
    
    static testMethod void testUpdatePType(){
        CRS_Package_Type__c[] testData = createPType();
        CRS_Package_Type__c tempData = [select Id, Name, CRS_Package_Type_External_ID__c 
            from CRS_Package_Type__c where Name = : testData[0].Name];
        tempData.gvwCRS__c = true;
        update tempData;
        tempData = [select Id, Name, CRS_Package_Type_External_ID__c 
            from CRS_Package_Type__c where Name = : testData[0].Name];
        System.assert('gvw'+testData[0].Name == tempData.CRS_Package_Type_External_ID__c);
        
        tempData = [select Id, Name, CRS_Package_Type_External_ID__c 
            from CRS_Package_Type__c where Name = : testData[1].Name];
        tempData.gvwCRS__c = false;
        tempData.Name = 'testtest123';
        update tempData;
        tempData = [select Id, Name, CRS_Package_Type_External_ID__c 
            from CRS_Package_Type__c where Name = 'testtest123'];
        System.assert('testtest123' == tempData.CRS_Package_Type_External_ID__c);
    }
    
    //test CRS_Type__c
    static testMethod void testInsertType(){
        CRS_Type__c[] testData = createType();
        CRS_Type__c tempData = [select Id, Name, CRS_Type_External_ID__c 
            from CRS_Type__c where Name = : testData[0].Name];
        System.assert(testData[0].Name == tempData.CRS_Type_External_ID__c);
        tempData = [select Id, Name, CRS_Type_External_ID__c 
            from CRS_Type__c where Name = : testData[1].Name];
        System.assert(('gvw'+testData[1].Name) == tempData.CRS_Type_External_ID__c);
    }
    
    static testMethod void testUpdateType(){
        CRS_Type__c[] testData = createType();
        CRS_Type__c tempData = [select Id, Name, CRS_Type_External_ID__c 
            from CRS_Type__c where Name = : testData[0].Name];
        tempData.gvwCRS__c = true;
        update tempData;
        tempData = [select Id, Name, CRS_Type_External_ID__c 
            from CRS_Type__c where Name = : testData[0].Name];
        System.assert('gvw'+testData[0].Name == tempData.CRS_Type_External_ID__c);
        
        tempData = [select Id, Name, CRS_Type_External_ID__c 
            from CRS_Type__c where Name = : testData[1].Name];
        tempData.gvwCRS__c = false;
        tempData.Name = 'testtest123';
        update tempData;
        tempData = [select Id, Name, CRS_Type_External_ID__c 
            from CRS_Type__c where Name = 'testtest123'];
        System.assert('testtest123' == tempData.CRS_Type_External_ID__c);
    }
}