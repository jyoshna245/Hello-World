/**
 * Test class for CRS_ContentWrapperEditController class
 */
@isTest
public with sharing class CRS_TestContentWrapperEditController {
    
    /**
     * Test for CRS_ContentWrapperEditController.doSave() method.
     * Positive scenario.
     */ 
    testMethod static void testDoSave1() {
        CRS__c crs = new CRS__c();
        insert crs;
        
        CRS_ContentWrapper__c wrapper = new CRS_ContentWrapper__c();
        wrapper.CRS__c = crs.Id; 
        insert wrapper;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(wrapper);
        CRS_ContentWrapperEditController testController = new CRS_ContentWrapperEditController(stdController);
        
        PageReference result = testController.doSave();

        System.assert(!ApexPages.hasMessages(ApexPages.Severity.ERROR));
        System.assert(result.getUrl() == '/' + wrapper.CRS__c);
    }
    
    /**
     * Test for CRS_ContentWrapperEditController.doSave() method.
     * Negative scenario.
     */
    testMethod static void testDoSave2() {
        CRS__c crs = CRS_TestHelper.prepareApprovedCRS();

        CRS_ContentWrapper__c wrapper = new CRS_ContentWrapper__c();
        wrapper.CRS__c = crs.Id; 
        insert wrapper;

        ApexPages.StandardController stdController = new ApexPages.StandardController(wrapper);
        CRS_ContentWrapperEditController testController = new CRS_ContentWrapperEditController(stdController);

        testController.doSave();

        //System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR)); - commented out for  INC0867675: CI: CRS (Salesforce)--Business Admin are unable to change document type
    }
}