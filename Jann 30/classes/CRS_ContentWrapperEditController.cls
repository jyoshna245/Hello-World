/**
 * "Without sharing" class to allow Corporate User to change
 * Document Type of CRS Attachments for CRS with "In Process" status
 */
public without sharing class CRS_ContentWrapperEditController {
    private ApexPages.StandardController stdController;
    
    public CRS_ContentWrapperEditController(ApexPages.StandardController stdController) {
        this.stdController = stdController; 
    }
    
    public PageReference doSave() {
        PageReference result = null;
        CRS_ContentWrapper__c record = (CRS_ContentWrapper__c) stdController.getRecord();
        try {
           update record;
           result = new PageReference('/'+record.CRS__c);
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        return result;
    }
}