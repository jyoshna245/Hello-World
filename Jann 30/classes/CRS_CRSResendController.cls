public with sharing class CRS_CRSResendController {
    public ApexPages.StandardController stdController;
    public CRS__c crs {get;set;}
    public boolean isShowMessageBox {get;set;}
    private PageReference redirectToCRS;
    
    public CRS_CRSResendController(ApexPages.StandardController controller) {
        this.stdController = controller;
        String crsId = ApexPages.currentPage().getParameters().get('idCRS');
        crs = [select Id, Name, OwnerId, CRS_Product_Name__r.Name, Process_Flow__c,
        CRS_Brand__r.Name, CRS_Flavor_Names__c, CRS_Beverage_Category__r.Name, 
        CRS_Package_Type_Names__c, Package_Size__c, CRS_Country_Names__c,
        CRS_Business_Unit__r.Name, CRS_Group__r.Name, Internal_Status2__c, Internal_Status__c from CRS__c where Id = :crsId];
        isShowMessageBox = crs.Internal_Status2__c != 'Wait2';

        CRS_Message__c crsMessage = (CRS_Message__c) stdController.getRecord();
        
        if (crs.Internal_Status__c != 'VP-Chief Sc and Reg Officer') {
        	crsMessage.Notification_Comment__c = '';
        }
        redirectToCRS = new PageReference('/' + crs.Id); 
        redirectToCRS.setRedirect(true);
    }
    
    public PageReference sendMessage(){
        CRS_Message__c crsMessage = (CRS_Message__c) stdController.getRecord();
        crsMessage = fillMessage(crs, crsMessage);
        upsert crsMessage;
        CRS_Mailing.resendEmail(crs.Name);
        return new PageReference('/'+crs.Id);
    }
    
    public static CRS_Message__c fillMessage(CRS__c crs, CRS_Message__c crsMessage){
    	crsMessage.CRS__c = crs.Id;
    	crsMessage.CRS_Name__c = crs.Name;
    	crsMessage.CRS_Product_Name__c = crs.CRS_Product_Name__r.Name;
    	crsMessage.CRS_Process_Flow__c = crs.Process_Flow__c;
        crsMessage.CRS_Brand__c = crs.CRS_Brand__r.Name;
        crsMessage.CRS_Flavor_Names__c = crs.CRS_Flavor_Names__c;
        crsMessage.CRS_Beverage_Category__c = crs.CRS_Beverage_Category__r.Name;
        crsMessage.CRS_Package_Type_Names__c = crs.CRS_Package_Type_Names__c;
        crsMessage.CRS_Package_Size__c = crs.Package_Size__c;
        crsMessage.CRS_Country_Names__c = crs.CRS_Country_Names__c;
        crsMessage.CRS_Business_Unit__c = crs.CRS_Business_Unit__r.Name;
        crsMessage.CRS_Group__c = crs.CRS_Group__r.Name;
        crsMessage.CRS_Link__c = URL.getSalesforceBaseUrl().toExternalForm() + '/' + crs.Id;
        return crsMessage;
    }
    
    public PageReference doCancel() {
        return redirectToCRS;
    }
}