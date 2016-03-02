@isTest
private class CRS_TestCRSEdit {
    
    /*
    * author: Ivan_Tsitulenka
    * class: CRS_CRSEdit
    * method: updateProcessFlow
    */
    
    static private void startProcessFlowTests(String typeName, Integer productNum, Integer[] typeNum, String result){
        CRS_TestHelper.prepareNameValueSetup();
        CRS_TestHelper.prepareProductDependentFields();
        RecordType crsGvwRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c' and name = :typeName][0];
        CRS__c testCrs = new CRS__c(Status__c = CRS_CRSEdit.CRS_Status_Draft, RecordType = crsGvwRecordType, RecordTypeId = crsGvwRecordType.Id);
        CRS_CRSEdit testCrsEdit = new CRS_CRSEdit(new ApexPages.StandardController(testCrs));
        if(productNum > -1){
            testCrs.CRS_Product_Name__c = CRS_TestHelper.prepareCRSProduct(productNum).id;
        }
        String typeIds = '';
        for(CRS_Type__c types : CRS_TestHelper.prepareCRSType(typeNum)){
            typeIds += types.Id + ';';
        }
        
        if(!''.equals(typeIds)){
            testCrsEdit.selectedMultipleIds.put('CRS_Type_to_CRS__c',typeIds);
        }
        testCrsEdit.updateProcessFlow(false);
        System.assert(testCrs.Process_Flow__c == result);
    }
    
    static private void preparedDataForAllProduct(Integer i){
        CRS_TestHelper.prepareNameValueSetup();
        CRS_TestHelper.prepareProductDependentFields();
        CRS_TestHelper.prepareCRSProduct(i);
        CRS_TestHelper.prepareCRSType(new List<Integer>{i});
        CRS_TestHelper.prepareCRSBeverageCategory(i);
        CRS_TestHelper.prepareCRSBrand(i);
        CRS_TestHelper.prepareCRSFlavor(i);
        CRS_TestHelper.prepareCRSMediaType(i);
        CRS_TestHelper.prepareCRSPackageType(1);
    }
    
    static testMethod void testUpdateProcessFlowGvw() {
        Integer[] index = new List<Integer>{};
        startProcessFlowTests('glaceau vitaminwater CRS',1,index,'Full Review (for gvwCRS Only)');
    }
    
    static testMethod void testUpdateProcessFlowNoGvwPOYes() {
        Integer[] index = new List<Integer>{};      
        startProcessFlowTests('CRS submission',0,index,'Full Review Coke Branded Product');
    }   
       
    static testMethod void testUpdateProcessFlowNoGvwPONoTypeFull() {
        Integer[] index = new List<Integer>{4};
        startProcessFlowTests('CRS submission',3,index,'Full Review Non-Coke Branded Product');
    }
   
    static testMethod void testUpdateProcessFlowNoGvwPONoTypeNotification() {
        Integer[] index = new List<Integer>{0};
        startProcessFlowTests('CRS submission',3,index,'Notification');
    }
   
    static testMethod void testUpdateProcessFlowNoGvwPONoTypeNotificationFull() {
        Integer[] index = new List<Integer>{0,1};
        startProcessFlowTests('CRS submission',3,index,'Full Review & Notification');
    }
   
    static testMethod void testUpdateProcessFlowNoGvwPONoTypeNotNotification() {
        Integer[] index = new List<Integer>{1,2};
        startProcessFlowTests('CRS submission',1,index,'Full Review Non-Coke Branded Product');
    }
    
    private static CRS__c populateAllProduct(String prodName){
        Id crsProductId = [select Id from CRS_CRS_Product__c where Name = :prodName limit 1].Id;
        RecordType crsGvwRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c' and name = 'CRS submission'][0];

        CRS_Business_Unit__c crsBU = createBU('testBU');

        CRS__c testCrs = new CRS__c(Status__c = CRS_CRSEdit.CRS_Status_Draft, RecordType = crsGvwRecordType,
        RecordTypeId = crsGvwRecordType.Id, Date_Initiated__c = System.today(),
        Initiated_By__c = UserInfo.getUserId());
        CRS_CRSEdit testCrsEdit = new CRS_CRSEdit(new ApexPages.StandardController(testCrs));
        PageReference pageRef = Page.CRS_CRSEdit;
        pageRef.getParameters().put('product', crsProductId);
        pageRef.getParameters().put('bu', crsBU.Id);
        Test.setCurrentPage(pageRef);
        testCrsEdit.populateBUDependencies();
        testCrsEdit.processBeverageProductChange();
        testCrsEdit.doSave();
        return [select Id, CRS_Type_Names__c, CRS_Beverage_Category__c, CRS_Brand__c, 
            CRS_Flavor_Names__c, CRS_Media_Type_Names__c, CRS_Package_Type_Names__c 
            from CRS__c limit 1];
    }
    
    static private String getPDNameFor(String settingName) {
        String result = null;
        CRS_ProductDependentFieldsSetup__c setting = CRS_ProductDependentFieldsSetup__c.getInstance(settingName);
        if (setting != null) {
             result = setting.Value__c;
        }
        return result;
    }
    
    static testMethod void testAllProductsGC(){
        preparedDataForAllProduct(1);
        CRS__c testCrs = populateAllProduct('All Products - General Communications');
        System.assert(testCrs.CRS_Beverage_Category__c == 
            [select Id from CRS_Beverage_Category__c where 
                Name = :getPDNameFor(CRS_CRSEdit.BEVERAGE_CATEGORY_NAME_GENERAL_COMMUNICATIONS) limit 1].Id);
        System.assert(testCrs.CRS_Brand__c == 
            [select Id from CRS_Brand__c where 
                Name = :getPDNameFor(CRS_CRSEdit.BRAND_NAME_GENERAL_COMMUNICATIONS) limit 1].Id);
        System.assert(testCrs.CRS_Type_Names__c == getPDNameFor(CRS_CRSEdit.CRS_TYPE_NAME_GENERAL_COMMUNICATIONS)+';');
        System.assert(testCrs.CRS_Flavor_Names__c == getPDNameFor(CRS_CRSEdit.FLAVOR_NAME_GENERAL_COMMUNICATIONS)+';');
        System.assert(testCrs.CRS_Media_Type_Names__c == getPDNameFor(CRS_CRSEdit.MEDIA_TYPE_NAME_GENERAL_COMMUNICATIONS)+';');
        System.assert(testCrs.CRS_Package_Type_Names__c == getPDNameFor(CRS_CRSEdit.PACKAGE_TYPE_NAME_GENERAL_COMMUNICATIONS)+';');
    }
    
    static testMethod void testAllProductsLP(){
        preparedDataForAllProduct(2);
        CRS__c testCrs = populateAllProduct('All Products - Live Positively');
        System.assert(testCrs.CRS_Beverage_Category__c == 
            [select Id from CRS_Beverage_Category__c where 
                Name = :getPDNameFor(CRS_CRSEdit.BEVERAGE_CATEGORY_NAME_LIVE_POSITIVELY) limit 1].Id);
        System.assert(testCrs.CRS_Brand__c == 
            [select Id from CRS_Brand__c where 
                Name = :getPDNameFor(CRS_CRSEdit.BRAND_NAME_LIVE_POSITIVELY) limit 1].Id);
        System.assert(testCrs.CRS_Type_Names__c == getPDNameFor(CRS_CRSEdit.CRS_TYPE_NAME_LIVE_POSITIVELY)+';');
        System.assert(testCrs.CRS_Flavor_Names__c == getPDNameFor(CRS_CRSEdit.FLAVOR_NAME_LIVE_POSITIVELY)+';');
        System.assert(testCrs.CRS_Media_Type_Names__c == getPDNameFor(CRS_CRSEdit.MEDIA_TYPE_NAME_LIVE_POSITIVELY)+';');
        System.assert(testCrs.CRS_Package_Type_Names__c == getPDNameFor(CRS_CRSEdit.PACKAGE_TYPE_NAME_LIVE_POSITIVELY)+';');
    }
    
    private static CRS_Business_Unit__c createBU(String buName){
        CRS_Group__c crsGroup = new CRS_Group__c(Name = buName, Active__c = 'Yes');
        insert crsGroup;
        
        CRS_Business_Unit__c crsBU = new CRS_Business_Unit__c(Name = buName, Active__c = 'Yes', Group__c = crsGroup.Id);
        insert crsBU;
        return crsBU;
    } 
    
    /*private static User createUser(String name, String BUName){
        Profile prof = [select Id from Profile where Name = 'System Administrator'];
        UserRole uRole = [select Name, Id from UserRole where Name = 'Top Level' limit 1];
        User test2 = new User(
            LastName = name+'test', Alias = name.substring(0, 3), Email = name+'@mail.com',
            username = name+'@mail.com', CommunityNickname = name,
            UserRoleId = uRole.Id, TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', ProfileId = prof.Id, 
            LanguageLocaleKey = 'en_US'
        );
        test2.CRS_BU_Legal_Approver__c='Yes'; 
        test2.CRS_Field_SRA_Approver__c='Yes';
        test2.CRS_Corporate_SRA_Approver__c='Yes'; 
        test2.CRS_Corporate_Food_Law_Approver__c='Yes';
        test2.CRS_Corporate_Formula_Governance__c='Yes'; 
        test2.CRS_VP_Chief_Scientific_Regulatory__c='Yes';
        test2.Business_Unit__c = BUName;
        insert test2;
        return test2;
    }*/
    /*static testMethod void testPopulateBUDependencies() {
        CRS_CRSEdit editExtController = CRS_TestHelper.prepareCRSSubmission1();
        CRS__c crs = (CRS__c) editExtController.stdController.getRecord();
        crs = crs.clone(true, true);
        System.assert(crs.CRS_Business_Unit__c == null);
        editExtController.populateBUDependencies();
        CRS__c crs2 = (CRS__c) editExtController.stdController.getRecord();
        System.assertEquals(crs, crs2);
        
        CRS_Business_Unit__c crsBU = createBU('testBU');
        createUser('uTest', crsBU.Name);
        
        CRS_Business_Unit__c bu = CRS_TestHelper.findBU();
        crs2.CRS_Business_Unit__c = bu.Id;
        editExtController.populateBUDependencies();
        System.assert(crs2.CRS_Business_Unit__c != null);
        System.assert(crs2.CRS_Group__c != null);
        System.assert(crs2.CRS_BU_Legal_Approver__c != null);
        System.assert(crs2.CRS_Field_SRA_Approver__c != null);
        System.assert(crs2.CRS_Corp_SRA_Approver__c != null);
        System.assert(crs2.CRS_Corp_Food_Law_Approver__c != null);
        System.assert(crs2.CRS_Corp_Formula_Governance__c != null);
        System.assert(crs2.CRS_VP_Chief_Scientific_Regulatory__c != null);
    }*/
    
    static testMethod void testFinishClone(){
        CRS_TestHelper.prepareUnderReviewCRS();
        CRS__c testCrs = [select Id, Name, OwnerId, Send_Corp_Form_Gov__c,
            Send_VP_Science__c, Send_VP_Chief__c, RecordTypeId,
            Total_Page_Count__c, MTR_Day_Count__c, Date_Closed__c, CRS_Review__c, 
            Internal_Status2__c, Internal_Status__c, Audit_Status__c, Date_Initiated__c,
            Initiated_By__c, Status__c,Process_Flow__c,CRS_Business_Unit__c from CRS__c limit 1];
        PageReference pageRef = Page.CRS_CRSEdit;
        pageRef.getParameters().put('clone', '1');
        Test.setCurrentPage(pageRef);
        CRS_CRSEdit testCrsEdit = new CRS_CRSEdit(new ApexPages.StandardController(testCrs));
        //testCrsEdit.finishClone(testCrs);
        System.assert(testCrs.Name == '');
        System.assert(testCrs.Status__c == CRS_CRSEdit.CRS_Status_Draft);
        System.assert(testCrs.MTR_Day_Count__c == 0);
    }
   
}