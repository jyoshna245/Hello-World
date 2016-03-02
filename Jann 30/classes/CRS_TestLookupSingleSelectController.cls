/**
 * Test class for CRS_LookupSingleSelectController
 */
@isTest
private class CRS_TestLookupSingleSelectController {
	private static final String OBJECT_TYPE = 'CRS_CRS_Product__c';

    /**
     * Common test for searching, sorting, etc. 
     */
    static testMethod void testCommon() {
        CRS_CRS_Product__c prod1 = new CRS_CRS_Product__c();
        prod1.Name = 'Test Prod1';
        insert prod1;
        
        CRS_CRS_Product__c prod2 = new CRS_CRS_Product__c();
        prod2.Name = 'Test Prod2';
        insert prod2;
        
        PageReference pageRef = Page.CRS_LookupMultiSelect;
        pageRef.getParameters().put('objType', OBJECT_TYPE);
        pageRef.getParameters().put('fieldValue', prod1.Id+';');
        Test.setCurrentPage(pageRef);
        
        insertCommonSettings();
        
        CRS_LookupSingleSelectController testController = new CRS_LookupSingleSelectController();
        
        // Just coverage
        testController.getFormTag();
        testController.getTextBox();
        
        // All products are shown
        List<SObject> results = testController.getResults();
        System.assert(results.size() == 2);
        
        // All products are shown        
        testController.searchString = 'test';
        testController.search();
        results = testController.getResults();
        System.assert(results.size() == 2);
        
        // 1 product is shown
        testController.searchString = 'Prod1';
        testController.search();
        results = testController.getResults();
        System.assert(results.size() == 1);
        
        // Default page size
        System.assert(testController.pageSize == CRS_LookupSingleSelectController.DEFAULT_PAGE_SIZE);
        
        // Set page size
        testController.pageSize = 1;
        System.assert(testController.pageSize == 1);
        
        // Total pages
        testController.searchString = '';
        testController.search();
        System.assert(testController.getTotalPages() == 2);
        
        // Navigation between pages
        testController.previous();
        testController.next();
        
        testController.first();
        System.assert(!testController.getHasPrevious());
        
        testController.last();
        System.assert(!testController.getHasNext());
        
        // Set page number
        testController.pageNumberTxt = '2';
        String pageNum = testController.pageNumberTxt;
        System.assert(pageNum == '2');
        
        testController.pageNumberTxt = '5';
        pageNum = testController.pageNumberTxt;
        System.assert(pageNum == '2');
        
        testController.pageNumberTxt = '1';
        pageNum = testController.pageNumberTxt;
        System.assert(pageNum == '1');
        
        testController.pageNumberTxt = '-5';
        pageNum = testController.pageNumberTxt;
        System.assert(pageNum == '1');
        
        // Sort order
        System.assert(testController.sortDir == CRS_LookupSingleSelectController.ASCENDING_ORDER);
        testController.sortField = 'Name';
        System.assert(testController.sortDir == CRS_LookupSingleSelectController.DESCENDING_ORDER);
        
        testController.sort();
        results = testController.getResults();
        System.assert(results[0].get('Name') == 'Test Prod2');
    }    
    
    private static void insertCommonSettings() {
    	CRS_LookupSettings__c settings = new CRS_LookupSettings__c();
        settings.Name = OBJECT_TYPE;
        settings.FieldNames__c = 'Name,LastModifiedDate';
        settings.HasActiveField__c = true;
        settings.FieldLabels__c = 'Custom Label,-';
        settings.HasGvwFlag__c = true;
        insert settings;
    }
    
    /**
     * Test for CRS_LookupSingleSelectController.submitProduct()
     * when Product name is empty. 
     */  
    static testMethod void testSubmitProduct1() {
        PageReference pageRef = Page.CRS_LookupSingleSelect;
        pageRef.getParameters().put('objType', OBJECT_TYPE);
        Test.setCurrentPage(pageRef);
        CRS_LookupSingleSelectController testController = new CRS_LookupSingleSelectController();
        
        testController.inputProductName = '';
        testController.submitProduct();
        
        // There should be an error message...
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        
        // ...and only one.
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(messages.size() == 1);
    }
    
    /**
     * Test for CRS_LookupSingleSelectController.submitProduct()
     * when Business Admin email is not configured. 
     */
    static testMethod void testSubmitProduct2() {
        PageReference pageRef = Page.CRS_LookupSingleSelect;
        pageRef.getParameters().put('objType', OBJECT_TYPE);
        Test.setCurrentPage(pageRef);
        CRS_LookupSingleSelectController testController = new CRS_LookupSingleSelectController();
        
        testController.inputProductName = 'Test Product';
        testController.submitProduct();
        
        // There should be an error message...
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        
        // ...and only one.
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(messages.size() == 1);
    }

    /**
     * Test for CRS_LookupSingleSelectController.submitProduct()
     * when everything is OK. 
     */
    static testMethod void testSubmitProduct3() {
        PageReference pageRef = Page.CRS_LookupSingleSelect;
        pageRef.getParameters().put('objType', OBJECT_TYPE);
        Test.setCurrentPage(pageRef);
        CRS_LookupSingleSelectController testController = new CRS_LookupSingleSelectController();
        
        CRS_NameValueSetup__c setup = new CRS_NameValueSetup__c();
        setup.Name = CRS_LookupSingleSelectController.BUSINESS_ADMIN_EMAIL_SETTING_KEY;
        setup.Value__c = 'test@test.test';
        insert setup;
        
        //Name longer than CRS_LookupSingleSelectController.MAX_NAME_LENGTH
        testController.inputProductName = 'TestProduct0123456789012345678901234567890123456789012345678901234567890123456789';
        testController.submitProduct();
        
        // There should be an info message that request is fine...
        System.assert(ApexPages.hasMessages(ApexPages.Severity.INFO));
        
        // ...and only one message.
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(messages.size() == 1);
    }    
    
}