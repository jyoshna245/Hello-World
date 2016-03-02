/*
    * author: Rajani Kant
    * class: CRS_DaysInProcAfterBUAppr
    * method: recountDaysInProcessAfterBUApproval, recountTotalDaysSinceInitiated
    */
@isTest
private class CRS_TestCRS_DaysInProcAfterBUAppr {

 private static void prepareDataForDaysInProcAfterBUAppr(){
        CRS_CRS_Product__c testProduct = new CRS_CRS_Product__c(Name = 'Test Product2', Active__c = 'Yes', 
                Beverage_Product_Name__c = 'Test002', KO_Product__c = 'No');
        insert testProduct;
        testProduct = [select Id, Name from CRS_CRS_Product__c where Name = :testProduct.Name];
        
        CRS_Type__c testType = new CRS_Type__c(Name = 'Test Type1', Active__c = 'Yes', 
                CRS_Type_Name__c = 'ttt1', Review_Type__c = 'Notification');
        insert testType;
        testType = [select Id, Name from CRS_Type__c where Name = :testType.Name];
        
        CRS_Group__c crsGroup = new CRS_Group__c(Name = 'test1', Active__c = 'Yes');
        insert crsGroup;
        crsGroup = [select Id, Name from CRS_Group__c where Name = :crsGroup.Name];
        
        CRS_Business_Unit__c crsBU = new CRS_Business_Unit__c(Name = 'test2', Active__c = 'Yes', Group__c = crsGroup.Id);
        insert crsBU;
        crsBU = [select Id, Name from CRS_Business_Unit__c where Name = :crsBU.Name];
        
        CRS_Package_Type__c testPType = new CRS_Package_Type__c(Name = 'Live Positively', Active__c = 'Yes', 
                gvwCRS__c = false);
        insert testPType;
        testPType = [select Id, Name from CRS_Package_Type__c where Name = :testPType.Name];
        
        CRS_Flavor__c testFlavor = new CRS_Flavor__c(Name = 'Honey Orange', Active__c = 'Yes', 
                gvwCRS__c = false);
        insert testFlavor;
        testFlavor = [select Id, Name from CRS_Flavor__c where Name = :testFlavor.Name];
        
        CRS_Country__c testCountry = new CRS_Country__c(Name = 'Greece', Active__c = 'Yes', Business_Unit__c = crsBU.Id);
        insert testCountry;
        testCountry = [select Id, Name from CRS_Country__c where Name = :testCountry.Name];
        
        CRS_Beverage_Category__c testBC = new CRS_Beverage_Category__c(Name = 'General Communication Claims', Active__c = 'Yes', 
                gvwCRS__c = false);
        insert testBC;
        testBC = [select Id, Name from CRS_Beverage_Category__c where Name = :testBC.Name];
        
        CRS_Brand__c testBrand = new CRS_Brand__c(Name = 'Birds Nest', Active__c = 'Yes', gvwCRS__c = false);
        insert testBrand;
        testBrand = [select Id, Name from CRS_Brand__c where Name = :testBrand.Name];
        System.debug('~~~'+testBrand);
        
        CRS_Media_Type__c testMType = new CRS_Media_Type__c(Name = 'Trade Direct', Active__c = 'Yes', 
                gvwCRS__c = false);
        insert testMType;
        testMType = [select Id, Name from CRS_Media_Type__c where Name = :testMType.Name];
        /*
        DossierConfiguration__c testDossConfig = new DossierConfiguration__c(CRS_Type__c = 'TYPO',Field_Label__c = 'Label');
        insert testDossConfig ;
        testDossConfig = [select Id, Name from DossierConfiguration__c where Name = :testDossConfig.Name];
        System.debug('~~~'+testDossConfig);
         
        CRS_Dossier__c testDossier = new CRS_Dossier__c(Section_1_1__c = 'Section1'+ ';',
                Section_1_2__c ='Sec2',Section_2_0__c = 'Sec20',Section_3_0__c = 'Sec30',Section_3_1__c = 'Sec31' + ';',
                Section_3_2__c = 'Sec32', Section_4_1__c = 'Sec41',Section_4_2__c = 'Sec42',Section_4_3__c = 'Sec43',Section_4_4__c = 'Sec44' + ';',
                Section_4_5__c = 'Sec45',Section_4_6__c = 'Sec46',Section_4_7__c = 'Sec47',Section_4_8__c = 'Sec48',Section_5_1__c = 'Sec51' + ';',
                Section_6_1__c = 'Sec61',Section_6_2__c = 'Sec62',Section_6_3__c = 'Sec63',Section_6_4__c = 'Sec64',Section_6_5__c = 'Sec65' + ';',
                Section_6_6__c = 'Sec66', Section_7_1__c = 'Sec71', Section_7_2__c = 'Sec72', Section_8_0__c = 'Sec80', Section_9_0__c = 'Sec90' + ';',
                CRSDossierToCRS__c = 'DossierCRS', Section_10_1__c = 'Sec101' , Section_10_2__c = 'Sec102',Section_11_0__c = 'Sec110');
        insert  testDossier;
        testDossier = [select Id, Name from CRS_Dossier__c where Name = :testDossier.Name];       
        System.debug('~~~'+testDossier);
        */
        RecordType crsRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c'][0];
        CRS__c testCrs = new CRS__c(CRS_Product_Name__c = testProduct.Id, CRS_Type_Names__c = testType.Id + ';', 
            CRS_Group__c = crsGroup.Id, CRS_Business_Unit__c = crsBU.Id, CRS_Package_Type_Names__c = testPType.Id + ';',
            CRS_Flavor_Names__c = testFlavor.Id + ';', CRS_Country_Names__c = testCountry.Id + ';', 
            CRS_Beverage_Category__c = testBC.Id, CRS_Brand__c = testBrand.Id, CRS_Media_Type_Names__c = testMType.Id + ';',
            Status__c = CRS_CRSEdit.CRS_Status_InProcess,CreatedDate = date.parse('08/01/2014'), CRS_Prior_Status__c = CRS_CRSEdit.CRS_Status_UnderReview , CRS_Title__c = CRS_CRSEdit.CRS_Title , RecordType = crsRecordType, RecordTypeId = crsRecordType.Id);
        insert testCrs;
    }
    
    static testMethod void daysInProcAfterBUApprTest() {
        prepareDataForDaysInProcAfterBUAppr();
        List<CRS__c> crs = [select Id, Name,CreatedDate, Days_In_Process_After_BU_Approval__c from CRS__c  limit 1];
        System.debug('~!~' + crs);
        CRS_DaysInProcAfterBUAppr.recountDaysInProcessAfterBUApproval();
        crs = [select Id, CreatedDate,Name, Days_In_Process_After_BU_Approval__c from CRS__c  limit 1];
        System.debug('~!~' + crs);
        System.assert(crs[0].Days_In_Process_After_BU_Approval__c == 1);
        CRS_DaysInProcAfterBUAppr.recountDaysInProcessAfterBUApproval();
        CRS_DaysInProcAfterBUAppr.recountDaysInProcessAfterBUApproval();
        crs = [select Id, Name,CreatedDate,  Days_In_Process_After_BU_Approval__c from CRS__c limit 1];
        System.assert(crs[0].Days_In_Process_After_BU_Approval__c == 3);
        System.assert(true);
    }
    
    static testMethod void totalDaysSinceInitiatedTest() {
        prepareDataForDaysInProcAfterBUAppr();
        List<CRS__c> crs = [select Id, CreatedDate, Total_Days_Since_Initiated__c  from CRS__c  limit 1];
        System.debug('~!~' + crs);
        CRS_DaysInProcAfterBUAppr.recountTotalDaysSinceInitiated();
        crs = [select Id, CreatedDate, Total_Days_Since_Initiated__c  from CRS__c limit 1];
        System.debug('~!~' + crs);
        System.assert(crs[0].Total_Days_Since_Initiated__c  == 1);
        CRS_DaysInProcAfterBUAppr.recountTotalDaysSinceInitiated();
        CRS_DaysInProcAfterBUAppr.recountTotalDaysSinceInitiated();
        crs = [select Id, CreatedDate, Total_Days_Since_Initiated__c  from CRS__c limit 1];
        System.assert(crs[0].Total_Days_Since_Initiated__c  == 3);
        System.assert(true);
    }

}