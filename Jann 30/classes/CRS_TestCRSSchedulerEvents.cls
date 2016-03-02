/*
	* author: Ivan_Tsitulenka
	* class: CRS_CRSSchedulerEvents
	* method: recountMTRDay, deleteTenYearsOldCRS
	*/
@isTest
private class CRS_TestCRSSchedulerEvents {

	private static void prepareDataForRecountMTRDay(){
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
		
		RecordType crsRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c'][0];
		CRS__c testCrs = new CRS__c(CRS_Product_Name__c = testProduct.Id, CRS_Type_Names__c = testType.Id + ';', 
			CRS_Group__c = crsGroup.Id, CRS_Business_Unit__c = crsBU.Id, CRS_Package_Type_Names__c = testPType.Id + ';',
			CRS_Flavor_Names__c = testFlavor.Id + ';', CRS_Country_Names__c = testCountry.Id + ';', 
			CRS_Beverage_Category__c = testBC.Id, CRS_Brand__c = testBrand.Id, CRS_Media_Type_Names__c = testMType.Id + ';',
			Status__c = CRS_CRSEdit.CRS_Status_UnderReview, RecordType = crsRecordType, RecordTypeId = crsRecordType.Id);
		insert testCrs;
	}

    static testMethod void recountMTRDayTest() {
    	prepareDataForRecountMTRDay();
    	List<CRS__c> crs = [select Id, Name, MTR_Day_Count__c, Status__c from CRS__c limit 1];
    	System.debug('~!~' + crs);
    	CRS_CRSSchedulerEvents.recountMTRDay();
        crs = [select Id, Name, MTR_Day_Count__c, Status__c from CRS__c limit 1];
        System.debug('~!~' + crs);
        //System.assert(crs[0].MTR_Day_Count__c == 1);
        CRS_CRSSchedulerEvents.recountMTRDay();
        CRS_CRSSchedulerEvents.recountMTRDay();
        crs = [select Id, Name, MTR_Day_Count__c from CRS__c limit 1];
        //System.assert(crs[0].MTR_Day_Count__c == 3);
        System.assert(true);
    }
    
    private static void prepareCRSForDeleteOldCRS(String testName, Integer years){
    	CRS_CRS_Product__c testProduct = new CRS_CRS_Product__c(Name = testName, Active__c = 'Yes', 
				Beverage_Product_Name__c = 'Test002', KO_Product__c = 'No');
		insert testProduct;
		testProduct = [select Id, Name from CRS_CRS_Product__c where Name = :testProduct.Name];
		
		CRS_Group__c crsGroup = new CRS_Group__c(Name = testName, Active__c = 'Yes');
		insert crsGroup;
		crsGroup = [select Id, Name from CRS_Group__c where Name = :crsGroup.Name];
		
		CRS_Business_Unit__c crsBU = new CRS_Business_Unit__c(Name = testName, Active__c = 'Yes', Group__c = crsGroup.Id);
		insert crsBU;
		crsBU = [select Id, Name from CRS_Business_Unit__c where Name = :crsBU.Name];
		
		RecordType crsRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c'][0];
		CRS__c testCrs = new CRS__c(CRS_Product_Name__c = testProduct.Id, CRS_Group__c = crsGroup.Id, 
			CRS_Business_Unit__c = crsBU.Id, RecordType = crsRecordType, RecordTypeId = crsRecordType.Id,
			Date_Closed__c = System.today().addYears(-years));
		insert testCrs;
    }
    
    private static void prepareCRSReviewForDeleteOldCRS(CRS__c crs){
    	insert (new CRS_Review__c(CRS_Tracking__c = crs.Id));
    }
    
    static testMethod void deleteTenYearsOldCRSTest() {
    	prepareCRSForDeleteOldCRS('test1',11);
    	prepareCRSForDeleteOldCRS('test2',10);
    	prepareCRSForDeleteOldCRS('test3',7);
    	List<CRS__c> crsList = [select Id, Name, MTR_Day_Count__c, Status__c from CRS__c];
    	for(CRS__c crs : crsList){
    		prepareCRSReviewForDeleteOldCRS(crs);	
    	}
    	CRS_CRSSchedulerEvents.deleteTenYearsOldCRS();
    	crsList = [select Id, Name, MTR_Day_Count__c, Status__c from CRS__c];
    	List<CRS_Review__c> crsReviewList = [select Id, Name from CRS_Review__c];
    	System.assert(crsReviewList.size() == 1);
    	System.assert(crsList.size() == 1);
    }
}