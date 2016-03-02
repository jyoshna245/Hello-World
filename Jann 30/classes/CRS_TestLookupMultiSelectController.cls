/**
 * Test class for CRS_LookupMultiSelectController
 */
@isTest
private class CRS_TestLookupMultiSelectController {
    private static final String OBJECT_TYPE = 'CRS_CRS_Product__c';

    /**
     * Common test for searching, sorting, selecting, etc. 
     */
    static testMethod void testCommon() {
        CRS_CRS_Product__c prod1 = new CRS_CRS_Product__c();
        prod1.Name = 'Test Prod1';
        prod1.KO_Product__c = 'Yes';
        insert prod1;
        
        CRS_CRS_Product__c prod2 = new CRS_CRS_Product__c();
        prod2.Name = 'Test Prod2';
        prod2.KO_Product__c = 'Yes';
        insert prod2;
        
        CRS_CRS_Product__c prod3 = new CRS_CRS_Product__c();
        prod3.Name = 'Test Prod3';
        prod3.KO_Product__c = 'No';
        insert prod3;
        
        PageReference pageRef = Page.CRS_LookupMultiSelect;
        pageRef.getParameters().put('objType', OBJECT_TYPE);
        pageRef.getParameters().put('fieldValue', prod1.Id+';');
        pageRef.getParameters().put('filterField', 'KO_Product__c');
        pageRef.getParameters().put('filterValue', 'Yes');
        Test.setCurrentPage(pageRef);
        
        insertCommonSettings();
        
        CRS_LookupMultiSelectController testController = new CRS_LookupMultiSelectController();
        
        // Just coverage
        testController.getFormTag();
        testController.getTextBox();
        testController.goToPage();
        
        // All products are shown
        List<CRS_LookupMultiSelectController.SelectableSObject> results = testController.results;
        System.assert(results.size() == 2);
        
        // All products are shown        
        testController.searchString = 'test';
        testController.search();
        results = testController.results;
        System.assert(results.size() == 2);
        
        // 1 product is shown
        testController.searchString = 'Prod1';
        testController.search();
        results = testController.results;
        System.assert(results.size() == 1);
        
        // Default page size
        System.assert(testController.pageSize == CRS_LookupSingleSelectController.DEFAULT_PAGE_SIZE);
        
        // Set page size
        testController.pageSize = 1;
        testController.changePageSize();
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
        results = testController.results;
        System.assert(results[0].obj.get('Name') == 'Test Prod2');
        
        // Apply selected items
        testController.applySelection();
        System.assert(testController.readyForProcess);
        
        // Select items
        testController.clearSelected();
        testController.searchString = '';
        testController.pageSize = CRS_LookupSingleSelectController.DEFAULT_PAGE_SIZE;
        testController.search();
        for (CRS_LookupMultiSelectController.SelectableSObject selectableItem : testController.results) {
        	selectableItem.selected = true;
        }
        testController.applySelection();
        System.assert(testController.selectedIds.split(';').size() == 2);
        
        // Unselect items
        for (CRS_LookupMultiSelectController.SelectableSObject selectableItem : testController.results) {
            selectableItem.selected = false;
        }
        testController.applySelection();
        System.assert(testController.selectedIds == '');
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
     * Test for CRS_LookupMultiSelectController.submitFlavor()
     * when flavor name is empty. 
     */  
    static testMethod void testSubmitFlavor1() {
        PageReference pageRef = Page.CRS_LookupMultiSelect;
        pageRef.getParameters().put('objType', OBJECT_TYPE);
        Test.setCurrentPage(pageRef);
        CRS_LookupMultiSelectController testController = new CRS_LookupMultiSelectController();
        
        testController.inputFlavorName = '';
        testController.submitFlavor();
        
        // There should be an error message...
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        
        // ...and only one.
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(messages.size() == 1);
    }
    
    /**
     * Test for CRS_LookupMultiSelectController.submitFlavor()
     * when Business Admin email is not configured. 
     */
    static testMethod void testSubmitFlavor2() {
        PageReference pageRef = Page.CRS_LookupMultiSelect;
        pageRef.getParameters().put('objType', OBJECT_TYPE);
        Test.setCurrentPage(pageRef);
        CRS_LookupMultiSelectController testController = new CRS_LookupMultiSelectController();
        
        testController.inputFlavorName = 'Test Flavor';
        testController.submitFlavor();
        
        // There should be an error message...
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        
        // ...and only one.
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(messages.size() == 1);
    }

    /**
     * Test for CRS_LookupMultiSelectController.submitFlavor()
     * when everything is OK. 
     */
    static testMethod void testSubmitFlavor3() {
        PageReference pageRef = Page.CRS_LookupMultiSelect;
        pageRef.getParameters().put('objType', OBJECT_TYPE);
        Test.setCurrentPage(pageRef);
        CRS_LookupMultiSelectController testController = new CRS_LookupMultiSelectController();
        
        CRS_NameValueSetup__c setup = new CRS_NameValueSetup__c();
        setup.Name = CRS_LookupSingleSelectController.BUSINESS_ADMIN_EMAIL_SETTING_KEY;
        setup.Value__c = 'test@test.test';
        insert setup;
        
        //Name longer than CRS_LookupMultiSelectController.MAX_NAME_LENGTH
        testController.inputFlavorName = 'TestFlavor0123456789012345678901234567890123456789012345678901234567890123456789_';
        testController.submitFlavor();
        
        // There should be an info message that request is fine...
        System.assert(ApexPages.hasMessages(ApexPages.Severity.INFO));
        
        // ...and only one message.
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(messages.size() == 1);
    }    

    /**
     * Test for Users filtering
     * when everything is OK. 
     */  
    static testMethod void testUsersFiltering1() {
        PageReference pageRef = Page.CRS_LookupMultiSelect;
        pageRef.getParameters().put('objType', 'User');
        pageRef.getParameters().put('fieldValue', '');
        
        Test.setCurrentPage(pageRef);

        CRS_NameValueSetup__c roleSetup = new CRS_NameValueSetup__c();
        roleSetup.Name = CRS_LookupMultiSelectController.APPROVERS_TOP_ROLE_SETTING_KEY;
        roleSetup.Value__c = 'topRole';
        insert roleSetup;

        User currentUser = [select Id from User where Id = :UserInfo.getUserId()];

        System.runAs(currentUser) {
            UserRole topRole = new UserRole();
            topRole.Name = 'topRole';
            topRole.DeveloperName = 'topRole';
            insert topRole;
        
            UserRole role1 = new UserRole();
            role1.Name = 'role1';
            role1.DeveloperName = 'role1';
            role1.ParentRoleId = topRole.Id;
            insert role1;
        
            UserRole role2 = new UserRole();
            role2.Name = 'role2';
            role2.DeveloperName = 'role2';
            role2.ParentRoleId = role1.Id;
            insert role2;
        
            /* Existing Profiles are accessible in test code
               so we don't need to create them in code
               but we need to create them in the target org 
               before deployment.
            */
            CRS_LookupMultiSelectController testController = new CRS_LookupMultiSelectController();

                //Select u.Profile.Name, u.ProfileId From User u
                //Select u.UserRole.DeveloperName, u.UserRole.Name, u.UserRoleId From User u
        
            List<Id> userIds= new List<Id>();
            for (CRS_LookupMultiSelectController.SelectableSObject wrapper : testController.results) {
                userIds.add((Id) wrapper.obj.get('Id'));
            }
            
            List<User> searchedUsers =
                    [SELECT Id,
                            Profile.Name,
                            ProfileId,
                            UserRole.DeveloperName,
                            UserRole.Name,
                            UserRoleId 
                    FROM User WHERE Id IN :userIds];
                    
            for (User user : searchedUsers) {
                String userRole = user.UserRole.Name;
                String profileName = user.Profile.Name;
                
                Boolean isSuitableUser = 
                        userRole == 'topRole'
                        || userRole == 'role1'
                        || userRole == 'role2'
                        || profileName == CRS_CRSEdit.getSAProfileName()
                        || profileName == CRS_CRSEdit.getBAProfileName();
                System.assert(isSuitableUser);        
            }          
        }
    }

    /**
     * Test for Users filtering
     * when filtering is not configured.
     */  
    static testMethod void testUsersFiltering2() {
        PageReference pageRef = Page.CRS_LookupMultiSelect;
        pageRef.getParameters().put('objType', 'User');
        pageRef.getParameters().put('fieldValue', '');
        
        Test.setCurrentPage(pageRef);
        
        CRS_LookupMultiSelectController testController = new CRS_LookupMultiSelectController();
        
        // There should be an error message...
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        
        ApexPages.Message[] messages = ApexPages.getMessages();
        // ... and only one message...
        System.assert(messages.size() == 1);
        
        // ... and correct message.
        System.assert(messages[0].getSummary() == Label.CRS_Approvers_filtering_by_Role_and_Profile_failed);
    }

}