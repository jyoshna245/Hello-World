@isTest
public with sharing class CRS_TestEditDossier {
	static testMethod void prepareDataForDossier(){
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
        
        CRS_Package_Type__c testPType = new CRS_Package_Type__c(Name = 'Natural Claim', Active__c = 'Yes', 
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
        
        DossierConfiguration__c sec1_1 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c =1.1, Tool_Tip__c= 'test tooltip');
        insert sec1_1 ;
        DossierConfiguration__c sec1_2 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=1.2, Tool_Tip__c= 'test tooltip');
        insert sec1_2 ;
        DossierConfiguration__c sec2_0 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=2.0, Tool_Tip__c= 'test tooltip');
        insert sec2_0 ;
        DossierConfiguration__c sec3_0 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=3.0, Tool_Tip__c= 'test tooltip');
        insert sec3_0 ;
        DossierConfiguration__c sec3_1 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=3.1, Tool_Tip__c= 'test tooltip');
        insert sec3_1 ;
        DossierConfiguration__c sec3_2 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=3.2, Tool_Tip__c= 'test tooltip');
        insert sec3_2 ;
        DossierConfiguration__c sec4_1 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=4.1, Tool_Tip__c= 'test tooltip');
        insert sec4_1 ;
        DossierConfiguration__c sec4_2 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=4.2, Tool_Tip__c= 'test tooltip');
        insert sec4_2 ;
        DossierConfiguration__c sec4_3 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=4.3, Tool_Tip__c= 'test tooltip');
        insert sec4_3 ;
        DossierConfiguration__c sec4_4 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=4.4, Tool_Tip__c= 'test tooltip');
        insert sec4_4 ;
        DossierConfiguration__c sec4_5 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=4.5, Tool_Tip__c= 'test tooltip');
        insert sec4_5 ;
        DossierConfiguration__c sec4_6 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=4.6, Tool_Tip__c= 'test tooltip');
        insert sec4_6 ;
        DossierConfiguration__c sec4_7 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=4.7, Tool_Tip__c= 'test tooltip');
        insert sec4_7 ;
        DossierConfiguration__c sec4_8 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=4.8, Tool_Tip__c= 'test tooltip');
        insert sec4_8 ;
        DossierConfiguration__c sec5_1 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=5.1, Tool_Tip__c= 'test tooltip');
        insert sec5_1 ;
        DossierConfiguration__c sec5_2 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=5.2, Tool_Tip__c= 'test tooltip');
        insert sec5_2 ;
        DossierConfiguration__c sec6_1 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=6.1, Tool_Tip__c= 'test tooltip');
        insert sec6_1 ;
        DossierConfiguration__c sec6_2 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=6.2, Tool_Tip__c= 'test tooltip');
        insert sec6_2 ;
        DossierConfiguration__c sec6_3 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=6.3, Tool_Tip__c= 'test tooltip');
        insert sec6_3 ;
        DossierConfiguration__c sec6_4 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=6.4, Tool_Tip__c= 'test tooltip');
        insert sec6_4 ;
        DossierConfiguration__c sec6_5 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=6.5, Tool_Tip__c= 'test tooltip');
        insert sec6_5 ;
        DossierConfiguration__c sec6_6 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=6.6, Tool_Tip__c= 'test tooltip');
        insert sec6_6 ;
        DossierConfiguration__c sec7_1 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=7.1, Tool_Tip__c= 'test tooltip');
        insert sec7_1 ;
        DossierConfiguration__c sec7_2 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=7.2, Tool_Tip__c= 'test tooltip');
        insert sec7_2 ;
        DossierConfiguration__c sec8_0 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=8.0, Tool_Tip__c= 'test tooltip');
        insert sec8_0 ;
        DossierConfiguration__c sec9_0 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=9.0, Tool_Tip__c= 'test tooltip');
        insert sec9_0 ;
        DossierConfiguration__c sec10_1 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=10.1, Tool_Tip__c= 'test tooltip');
        insert sec10_1 ;
        DossierConfiguration__c sec10_2 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=10.2, Tool_Tip__c= 'test tooltip');
        insert sec10_2 ;
        DossierConfiguration__c sec11_0 = new DossierConfiguration__c(CRS_Type__c = 'Natural Claim',Field_Label__c = 'test label', Options__c = 'Mandatory', Dossier_Field__c=11.0, Tool_Tip__c= 'test tooltip');
        insert sec11_0 ;
        
		
        
        RecordType crsRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c'][0];
        CRS__c testCrs = new CRS__c(CRS_Product_Name__c = testProduct.Id, CRS_Type_Names__c = testType.Id + ';', 
            CRS_Group__c = crsGroup.Id, CRS_Business_Unit__c = crsBU.Id, CRS_Package_Type_Names__c = testPType.Id + ';',
            CRS_Flavor_Names__c = testFlavor.Id + ';', CRS_Country_Names__c = testCountry.Id + ';', 
            CRS_Beverage_Category__c = testBC.Id, CRS_Brand__c = testBrand.Id, CRS_Media_Type_Names__c = testMType.Id + ';',
            Status__c = CRS_CRSEdit.CRS_Status_InProcess,CreatedDate = date.parse('08/01/2014'), CRS_Prior_Status__c = CRS_CRSEdit.CRS_Status_UnderReview , CRS_Title__c = CRS_CRSEdit.CRS_Title , RecordType = crsRecordType, RecordTypeId = crsRecordType.Id);
        insert testCrs;
        
        CRS_Dossier__c objDossier = [select id,CRSDossierToCRS__c from CRS_Dossier__c where CRSDossierToCRS__c =: testCrs.Id];
        
        CRS_EditDossier objClass = new CRS_EditDossier(new ApexPages.StandardController(objDossier));
        objClass.CRSRecordId = testCrs.Id;
        objClass.recordId = objDossier.Id;
        objClass.CRSType = 'Natural Claim';
        objClass.SetVisiblity('Natural Claim');
        objClass.EditDossier();
        objClass.cancelDossier();
        objClass.objDossier = objDossier ;
        objClass.saveCloseDossier();
        objClass.saveDossier();
        //insert objDossier;
        
    }
}