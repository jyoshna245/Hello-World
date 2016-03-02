@isTest
private class CRS_TestComponentMultiSelectController {
	
	static testMethod void testController() {
        CRS_ComponentMultiSelectController controller = new CRS_ComponentMultiSelectController();
        
        // Test empty names.
        controller.objectType = 'Contact';
        controller.fieldValue = '';
        
        String namesResult = controller.getNames();
        System.assert(namesResult == '', 'Result should be an empty string, but actually it is \'' + namesResult + '\'');
        
        
        // Test not empty names.
        CRS_Brand__c brand1 = new CRS_Brand__c();
        brand1.Name = 'Brand1';
        insert brand1;
        
        CRS_Brand__c brand2 = new CRS_Brand__c();
        brand2.Name = 'Brand2';
        insert brand2;
        
        controller.objectType = 'CRS_Brand__c';
        controller.fieldValue = brand1.Id + ';' + brand2.Id;
        
        namesResult = controller.getNames();
        System.assert(namesResult == 'Brand1; Brand2; ', 'Result should be \'Brand1; Brand2; \', but actually it is \'' + namesResult + '\'');
	}
}