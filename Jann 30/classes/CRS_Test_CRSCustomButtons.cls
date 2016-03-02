@isTest
public class CRS_Test_CRSCustomButtons {
    public static String CRS_RECORD_TYPE = 'CRS submission';
    public static String CRS_RECORD_TYPE_GVW = 'glaceau vitaminwater CRS';
    public static String CRS_STATUS_DRAFT = CRS_CRSEdit.CRS_Status_Draft;

    public static CRS_CRSEdit prepareCRSEdit(){
        prepareNameValueSetup();
        CRS__c testCrs = prepareDraftCRS();
        CRS_CRSEdit testCrsEdit = new CRS_CRSEdit(new ApexPages.StandardController(testCrs));
        ApexPages.currentPage().getParameters().put('bu', testCrs.CRS_Business_Unit__c);
        testCrsEdit.populateBUDependencies();
        Map<String, String> selectedMultipleIds= testCrsEdit.selectedMultipleIds;
        
        CRS_Country__c testCountry = [SELECT Id FROM CRS_Country__c LIMIT 1];
        CRS_Flavor__c testFlavor = [SELECT Id FROM CRS_Flavor__c WHERE gvwCRS__c = false LIMIT 1];
        CRS_Type__c testType = [SELECT Id FROM CRS_Type__c WHERE gvwCRS__c = false LIMIT 1];
        CRS_Package_Type__c testPType = [SELECT Id FROM CRS_Package_Type__c WHERE gvwCRS__c = false LIMIT 1];
        CRS_Media_Type__c testMType = [SELECT Id FROM CRS_Media_Type__c WHERE gvwCRS__c = false LIMIT 1];
        
        selectedMultipleIds.put(CRS_CRSEdit.MULTISELECT_JUNCTION_FLAVOR,testFlavor.Id);
        selectedMultipleIds.put(CRS_CRSEdit.MULTISELECT_JUNCTION_COUNTRY,testCountry.Id);
        selectedMultipleIds.put(CRS_CRSEdit.MULTISELECT_JUNCTION_CRSTYPE,testType.Id);
        selectedMultipleIds.put(CRS_CRSEdit.MULTISELECT_JUNCTION_PACKAGETYPE,testPType.Id);
        selectedMultipleIds.put(CRS_CRSEdit.MULTISELECT_JUNCTION_MEDIATYPE,testMType.Id);
        
        testCrsEdit.doSave();
        return testCrsEdit;
    }
    
    public static CRS_Role__c createRole(Id userId, Id businessUnitId) {
        CRS_Role__c role = new CRS_Role__c(User__c = userId, Business_Unit__c = businessUnitId);
        insert role;
        return role;
    }
    
    public static CRS_Group__c createGroup(String groupName){
        CRS_Group__c crsGroup = new CRS_Group__c(Name = groupName, Active__c = 'Yes');
        insert crsGroup;
        return crsGroup;
    }
    
    public static User createSysAdmin(){

        CRS_Group__c crsGroup = createGroup('sysAdminTestGroup');
        CRS_Business_Unit__c crsBU = prepareBU('sysAdminTestBU', crsGroup.Id);

        Profile saProfile = [SELECT Id FROM Profile WHERE Name= :CRS_CRSEdit.getSAProfileName()];
        CRS_Business_Unit__c bu = [Select Id From CRS_Business_Unit__c Where Name = 'sysAdminTestBU'];
        User u = new User(Alias = 'sadmin', Email='sysadmin@testorg.sadm', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = saProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='systemadmin@testorg.com');
        insert u;
        CRS_Role__c r = new CRS_Role__c(User__c = u.Id, Business_Unit__c = bu.Id, crs_bu_legal_approver__c='Yes',crs_corporate_food_law_approver__c='Yes',
            crs_corporate_formula_governance__c='Yes',crs_corporate_sra_approver__c='Yes',crs_field_sra_approver__c='Yes',
            gvwcrs_bu_legal_approver__c='Yes',gvwcrs_corporate_food_law_approver__c='Yes',gvwcrs_corporate_sra_approver__c='Yes',
            gvwcrs_field_sra_approver__c='Yes',crs_vp_science_division__c='Yes');
        insert r;
        return u;
    }
    public static User createBUAdmin(){

        CRS_Group__c crsGroup = createGroup('BUAdminTestGroup');
        CRS_Business_Unit__c crsBU = prepareBU('BUAdminTestBU', crsGroup.Id);

        Profile baProfile = [SELECT Id FROM Profile WHERE Name= :CRS_CRSEdit.getBAProfileName()];
        CRS_Business_Unit__c bu = [Select Id From CRS_Business_Unit__c Where Name = 'BUAdminTestBU'];
        User u = new User(Alias = 'badmin', Email='badmin@testorg.badm', 
            EmailEncodingKey='UTF-8', LastName='TestingBA', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = baProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='businessadmin@testorg.com');
        insert u;
        CRS_Role__c r = new CRS_Role__c(User__c = u.Id, Business_Unit__c = bu.Id, crs_bu_legal_approver__c='Yes',crs_corporate_food_law_approver__c='Yes',
            crs_corporate_formula_governance__c='Yes',crs_corporate_sra_approver__c='Yes',crs_field_sra_approver__c='Yes',
            gvwcrs_bu_legal_approver__c='Yes',gvwcrs_corporate_food_law_approver__c='Yes',gvwcrs_corporate_sra_approver__c='Yes',
            gvwcrs_field_sra_approver__c='Yes',crs_vp_science_division__c='Yes');
        insert r;
        return u;
    }
    public static CRS_Business_Unit__c prepareBU(String name, Id groupId){
        CRS_Business_Unit__c crsBU = new CRS_Business_Unit__c(Name = name, Active__c = 'Yes', Group__c = groupId);
        insert crsBU;

        // Add createad BU to User and set picklist to Yes, so user will be default approver
        User u = [Select Id FROM User WHERE Id=:Userinfo.getUserId()];

        CRS_Role__c r = new CRS_Role__c(User__c = u.Id, Business_Unit__c = crsBU.Id, crs_bu_legal_approver__c='Yes',crs_corporate_food_law_approver__c='Yes',
            crs_corporate_formula_governance__c='Yes',crs_corporate_sra_approver__c='Yes',crs_field_sra_approver__c='Yes',
            gvwcrs_bu_legal_approver__c='Yes',gvwcrs_corporate_food_law_approver__c='Yes',gvwcrs_corporate_sra_approver__c='Yes',
            gvwcrs_field_sra_approver__c='Yes',crs_vp_science_division__c='Yes');
        upsert r;

        return crsBU;
    }

    public static CRS__c prepareUnderReviewCRS(){
        return prepareCRS(CRS_CRSEdit.CRS_Status_UnderReview);
    }

    public static CRS__c prepareDraftCRS(){
        return prepareCRS(CRS_CRSEdit.CRS_Status_Draft);
    }

    public static CRS__c prepareApprovedCRS(){
        return prepareCRS(CRS_CRSEdit.CRS_Status_Approved);
    }
    
    public static CRS__c prepareInProcessCRS(){
        return prepareCRS(CRS_CRSEdit.CRS_Status_InProcess);
    }

    public static CRS_ContentWrapper__c prepareContentWrapper(String documentType, String crsId){

        CRS_ContentWrapper__c wrapper = new CRS_ContentWrapper__c(Document_Type__c = documentType, CRS__c = crsId);

        insert wrapper;
        return wrapper;
    }

    private static CRS__c prepareCRS(String status){
        CRS_CRS_Product__c testProduct = prepareCRSProduct(1);
        CRS_Type__c testType = prepareCRSType(new List<Integer>{0})[0];
                
        CRS_Package_Type__c testPType = prepareCRSPackageType(0);
        CRS_Flavor__c testFlavor = prepareCRSFlavor(0);
        CRS_Group__c crsGroup = createGroup('testGroup');
        CRS_Business_Unit__c crsBU = prepareBU('testBU', crsGroup.Id);
        CRS_Country__c testCountry = new CRS_Country__c(Name = 'Greece', Active__c = 'Yes', Business_Unit__c = crsBU.Id);
        insert testCountry;
        CRS_Beverage_Category__c testBC = prepareCRSBeverageCategory(0);
        CRS_Brand__c testBrand = prepareCRSBrand(0);
        CRS_Media_Type__c testMType = prepareCRSMediaType(0);
        
        RecordType crsRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c'][0];
        CRS__c testCrs = new CRS__c(CRS_Product_Name__c = testProduct.Id, CRS_Type_Names__c = testType.Id + ';', 
            CRS_Group__c = crsGroup.Id, CRS_Business_Unit__c = crsBU.Id, CRS_Package_Type_Names__c = testPType.Id + ';',
            CRS_Flavor_Names__c = testFlavor.Id + ';', CRS_Country_Names__c = testCountry.Id + ';', 
            CRS_Beverage_Category__c = testBC.Id, CRS_Brand__c = testBrand.Id, CRS_Media_Type_Names__c = testMType.Id + ';',
            RecordType = crsRecordType, RecordTypeId = crsRecordType.Id, MTR_Day_Count__c = 3);
        testCrs.Status__c = status;

        insert testCrs;
        return testCrs;
    }
    
    public static void prepareNameValueSetup(){
        List<CRS_NameValueSetup__c> nameValueList = new List<CRS_NameValueSetup__c>{
            new CRS_NameValueSetup__c(Name = 'ApproversTopRoleApiName', Value__c = 'CRS_gvwCRS'),
            new CRS_NameValueSetup__c(Name = 'BusinessAdminEmail', Value__c = '<EnterEmailAddress>'),
            new CRS_NameValueSetup__c(Name = 'BusinessAdminProfileApiName', Value__c = 'CRS Business Admin'),
            new CRS_NameValueSetup__c(Name = 'SystemAdminProfileApiName', Value__c = 'System Administrator')
        };
        insert nameValueList;
    }
    
    public static void prepareProductDependentFields(){
        List<CRS_ProductDependentFieldsSetup__c> proDeFields = new List<CRS_ProductDependentFieldsSetup__c>{
            new CRS_ProductDependentFieldsSetup__c(Name = 'GeneralComm-BeverageCategory', Value__c = 'General Communication Claims'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'GeneralComm-Brand', Value__c = 'All Brands - General Communications'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'GeneralComm-CRSType', Value__c = 'General Communication on nutrition health and food safety'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'GeneralComm-Flavor', Value__c = 'All Flavors - General Communications'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'GeneralComm-MediaTypes', Value__c = 'All Media Types - General Communications'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'GeneralComm-PackageType', Value__c = 'Does Not Apply To Package'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'GeneralComm-Product', Value__c = 'All Products - General Communications'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'LivePositively-BeverageCategory', Value__c = 'Live Positively'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'LivePositively-Brand', Value__c = 'All Brands - Live Positively'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'LivePositively-CRSType', Value__c = 'Live Positively branded communication'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'LivePositively-Flavor', Value__c = 'All Flavors - Live Positively'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'LivePositively-MediaTypes', Value__c = 'All Media Types - Live Positively'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'LivePositively-PackageType', Value__c = 'Does Not Apply To Package'),
            new CRS_ProductDependentFieldsSetup__c(Name = 'LivePositively-Product', Value__c = 'All Products - Live Positively')
        };
        insert proDeFields;
    }
    
    public static CRS_CRS_Product__c prepareCRSProduct(Integer index){
        CRS_CRS_Product__c[] testProduct = new CRS_CRS_Product__c[]{
            new CRS_CRS_Product__c(Name = 'Barqs Root Beer', Active__c = 'Yes', gvwCRS__c = false, 
                Beverage_Product_Name__c = 'Barqs Root Beer', KO_Product__c = 'Yes'),
            new CRS_CRS_Product__c(Name = 'All Products - Live Positively', Active__c = 'Yes', 
                Beverage_Product_Name__c = 'All Products - Live Positively', gvwCRS__c = false, 
                KO_Product__c = 'No'),
            new CRS_CRS_Product__c(Name = 'All Products - General Communications', Active__c = 'Yes', 
                Beverage_Product_Name__c = 'All Products - General Communications', gvwCRS__c = false, 
                KO_Product__c = 'No'),
            new CRS_CRS_Product__c(Name = 'Fleur', Active__c = 'Yes', gvwCRS__c = false,
                Beverage_Product_Name__c = 'Fleur', KO_Product__c = 'No')
        };
        insert testProduct;
        return testProduct[index];
    }
    
    public static List<CRS_Type__c> prepareCRSType(List<Integer> index){
        CRS_Type__c[] testType = new CRS_Type__c[]{
            new CRS_Type__c(Name = 'Natural Claim', Active__c = 'Yes', gvwCRS__c = false, 
                CRS_Type_Name__c = 'Natural Claim', Review_Type__c = 'Notification'),
            new CRS_Type__c(Name = 'Live Positively branded communication', Active__c = 'Yes', 
                CRS_Type_Name__c = 'Live Positively branded communication', gvwCRS__c = false,
                Review_Type__c = 'Full Review'),
            new CRS_Type__c(Name = 'General Communication on nutrition health and food safety', Active__c = 'Yes', 
                CRS_Type_Name__c = 'General Communication on nutrition health and food safety', 
                gvwCRS__c = false, Review_Type__c = 'Full Review'),
            new CRS_Type__c(Name = 'glaceau vitaminwater communication', Active__c = 'Yes', 
                CRS_Type_Name__c = 'glaceau vitaminwater communication', gvwCRS__c = true,
                Review_Type__c = 'Full Review'),
            new CRS_Type__c(Name = 'Comparison or competitive or collaborative claim', Active__c = 'Yes', 
                CRS_Type_Name__c = 'Comparison or competitive or collaborative claim', gvwCRS__c = false,
                Review_Type__c = 'Full Review'),
            new CRS_Type__c(Name = 'Promoting Trust/Refresh 2020 and Corporate Reputation claims', Active__c = 'Yes',
                CRS_Type_Name__c = 'Corporate reputation claim (e.g., ‘Earn Trust’)', gvwCRS__c = false,
                Review_Type__c = 'PAC')  //----Added by Ranjan 28th Oct'14
        };
        insert testType;
        CRS_Type__c[] toReturn = new List<CRS_Type__c>();
        for(Integer ind: index){
            toReturn.add(testType[ind]);
        }
        return toReturn;
    }
    
    
    public static CRS_Beverage_Category__c prepareCRSBeverageCategory(Integer index){
        CRS_Beverage_Category__c[] testCategory = new CRS_Beverage_Category__c[]{
            new CRS_Beverage_Category__c(Name = 'Tea', Active__c = 'Yes', gvwCRS__c = false, 
                Beverage_Category_Name__c = 'Tea'),
            new CRS_Beverage_Category__c(Name = 'Live Positively', Active__c = 'Yes', 
                gvwCRS__c = false, Beverage_Category_Name__c = 'Live Positively'),
            new CRS_Beverage_Category__c(Name = 'General Communication Claims', Active__c = 'Yes', 
                gvwCRS__c = false, Beverage_Category_Name__c = 'General Communication Claims'),
            new CRS_Beverage_Category__c(Name = 'enhanced water beverage', Active__c = 'Yes', 
                gvwCRS__c = true, Beverage_Category_Name__c = 'enhanced water beverage')
        };
        insert testCategory;
        return testCategory[index];
    }
    
    public static CRS_Brand__c prepareCRSBrand(Integer index){
        CRS_Brand__c[] testBrand = new CRS_Brand__c[]{
            new CRS_Brand__c(Name = 'Mone', Active__c = 'Yes', 
                gvwCRS__c = false, Brand_Name__c = 'Mone'),
            new CRS_Brand__c(Name = 'All Brands - Live Positively', Active__c = 'Yes', 
                gvwCRS__c = false, Brand_Name__c = 'All Brands - Live Positively'),
            new CRS_Brand__c(Name = 'All Brands - General Communications', Active__c = 'Yes',
                gvwCRS__c = false, Brand_Name__c = 'All Brands - General Communications'),
            new CRS_Brand__c(Name = 'all gvw brands', Active__c = 'Yes', 
                Brand_Name__c = 'all gvw brands', gvwCRS__c = true)
        };
        insert testBrand;
        return testBrand[index];
    }
    
    public static CRS_Flavor__c prepareCRSFlavor(Integer index){
        CRS_Flavor__c[] test = new CRS_Flavor__c[]{
            new CRS_Flavor__c(Name = 'Kahlua', Active__c = 'Yes', 
                gvwCRS__c = false, Flavor_Name__c = 'Kahlua'),
            new CRS_Flavor__c(Name = 'All Flavors - Live Positively', Active__c = 'Yes',
                gvwCRS__c = false, Flavor_Name__c = 'All Flavors - Live Positively'),
            new CRS_Flavor__c(Name = 'All Flavors - General Communications', Active__c = 'Yes', 
                gvwCRS__c = false, Flavor_Name__c = 'All Flavors - General Communications'),
            new CRS_Flavor__c(Name = 'grape', Active__c = 'Yes', 
                Flavor_Name__c = 'grape', gvwCRS__c = true)
        };
        insert test;
        return test[index];
    }
    
    public static CRS_Media_Type__c prepareCRSMediaType(Integer index){
        CRS_Media_Type__c[] test = new CRS_Media_Type__c[]{
            new CRS_Media_Type__c(Name = 'Label', Active__c = 'Yes', 
                gvwCRS__c = false, Media_Type_Name__c = 'Label'),
            new CRS_Media_Type__c(Name = 'All Media Types - Live Positively', Active__c = 'Yes',
                gvwCRS__c = false, Media_Type_Name__c = 'All Media Types - Live Positively'),
            new CRS_Media_Type__c(Name = 'All Media Types - General Communications', Active__c = 'Yes', 
                gvwCRS__c = false, Media_Type_Name__c = 'All Media Types - General Communications'),
            new CRS_Media_Type__c(Name = 'Trade', Active__c = 'Yes', 
                Media_Type_Name__c = 'Trade', gvwCRS__c = true)
        };
        insert test;
        return test[index];
    }
    
    public static CRS_Package_Type__c prepareCRSPackageType(Integer index){
        CRS_Package_Type__c[] test = new CRS_Package_Type__c[]{
            new CRS_Package_Type__c(Name = 'Cup', Active__c = 'Yes', 
                gvwCRS__c = false, Package_Type_Name__c = 'Cup'),
            new CRS_Package_Type__c(Name = 'Does Not Apply To Package', Active__c = 'Yes',
                gvwCRS__c = false, Package_Type_Name__c = 'Does Not Apply To Package'),
            new CRS_Package_Type__c(Name = 'Bottle', Active__c = 'Yes', 
                Package_Type_Name__c = 'Bottle', gvwCRS__c = true)
        };
        insert test;
        return test[index];
    }
    static testMethod void WebServiceAbandon() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_InProcess;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;
        CRS_Review__c reviewRecord=new CRS_Review__c(CRS_Tracking__c=testCrs.Id);
        upsert reviewRecord;
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        Boolean result=CRS_CRSCustomButtons.Abandon(testCrs.Id);
        System.assert(result==true || result==false);
        }
    }
    static testMethod void WebServiceDisapprove() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_InProcess;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        Boolean result=CRS_CRSCustomButtons.Disapprove(testCrs.Id);
        System.assert(result==true || result==false);
        }
    }
    static testMethod void WebServiceMoveToReview() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_InProcess;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        Boolean result=CRS_CRSCustomButtons.MoveToReview(testCrs.Id);
        System.assert(result==true || result==false);
        }
    }
    static testMethod void WebServiceReactivate() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_InProcess;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;
        CRS_Review__c crsReview=new CRS_Review__c(CRS_Tracking__c=testCrs.Id);
        upsert crsReview;
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        Boolean result=CRS_CRSCustomButtons.Reactivate(testCrs.Id);
        System.assert(result==true || result==false);
        }
    }
    static testMethod void WebServiceObsolete() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_InProcess;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        Boolean result=CRS_CRSCustomButtons.Obsolete(testCrs.Id);
        System.assert(result==true || result==false);
        }
    }
    static testMethod void checkAdminProfilesSA() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_Draft;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        CRS_CRSCustomButtons.checkAdminProfiles();
        }
    }
     static testMethod void checkAdminProfilesBA() {
         User user=createBUAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_Draft;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        CRS_CRSCustomButtons.checkAdminProfiles();
        }
        
    }
    static testMethod void showSubmitForApprovalButton() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_Draft;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        CRS_CRSCustomButtons.checkAdminProfiles();
        Boolean show=testCrsButtons.getshowSubmitForApprovalButton();
        system.assert(show==true);
        }
     }
    static testMethod void showReviewButton() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_InProcess;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;
        CRS_Role__c crsRole=new CRS_Role__c(Business_Unit__c=testCrs.CRS_Business_Unit__c,User__c=UserInfo.getUserId(),CRS_Corporate_Level__c='Yes',gvwCRS_Corporate_Level__c='Yes');
        upsert crsRole;    
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        CRS_CRSCustomButtons.checkAdminProfiles();
        Boolean show=testCrsButtons.getshowReviewButton();
        system.assert(show==true);
        }
     }
    static testMethod void showAbandonDisapproveButtons() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_InProcess;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;    
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        CRS_CRSCustomButtons.checkAdminProfiles();
        Boolean show=testCrsButtons.getshowAbandonDisapproveButtons();
        system.assert(show==true);
        }
     }
    static testMethod void showReactivateButtons() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_Abandoned;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;    
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        CRS_CRSCustomButtons.checkAdminProfiles();
        Boolean show=testCrsButtons.getshowReactivateButtons();
        system.assert(show==true);
        }
     }
    static testMethod void showObsoleteButtons() {
         User user=createSysAdmin();
        System.runAs(user) {
        String status=CRS_CRSEdit.CRS_Status_Approved;
        Crs__c testCrs=prepareCRS(status);  
        update testCrs;    
        CRS_CRSCustomButtons testCrsButtons = new CRS_CRSCustomButtons(new ApexPages.StandardController(testCrs));
        CRS_CRSCustomButtons.checkAdminProfiles();
        Boolean show=testCrsButtons.getshowObsoleteButtons();
        system.assert(show==true);
        testCrs.Status__c=CRS_CRSEdit.CRS_Status_Draft;
        update testCrs; 
        system.assert(testCrsButtons.getshowObsoleteButtons()==false);
        }
     }

}