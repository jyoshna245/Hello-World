/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     A (controller) class used to manipulate request view mode entities (i.e. buttons hide-when)
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*
*/
public with sharing class GS1_RequestCtrl {
    Id requestId = null;
    GS1_Request__c req = null;
    GS1_RequestAttribute ra = null;
    public GS1_RequestCtrl(ApexPages.StandardController controller) {
        this.requestId = controller.getRecord().id;
        //this.req = [select id, status__c, EAN_Code__c, Product_Type__c from GS1_Request__c where id=:this.requestId limit 1];
        this.req = [select id, Country__c, Flavour__c, Long_Short__c, Request_type__c, Design__c, Promotion_type__c, Promo_Quantity__c, Product_Type__c, Promo_Amount__c, Promo_Other__c, Promo_Currency__c, EAN_Code__c, BBN__c, BBN__r.code__c, Status__c, Packs_Case__c, Material__c, Capacity__c, Units_Pack__c, Unit__c, Trademark__c, Multipack__c, Multipack_Type__c,Pallet_Material__c, Pallet_Design__c, Number_of_Layers__c, Count_per_Pallet__c from GS1_Request__c where id=:this.requestId limit 1];
        ra = new GS1_RequestAttribute (this.req);
    }    
    
    public List<GS1_Request__c>getSimilarRequests() {
        GS1_Request__c[] reqs = GS1_AppWebHelperJSCtrl.findSameRequests(this.req);
        if ( !(reqs.size()>0)) {
            reqs = null;
        } 
        return reqs; 
    }
    
    public string getDialogTextWarning() {
        return GS1_Constants.DIALOG_TITLE_WARN;
    }
    
    public string getDialogTextInformation() {
        return GS1_Constants.DIALOG_TITLE_INFO;
    }
    
    public string getDialogTextError() {
        return GS1_Constants.DIALOG_TITLE_ERROR;
    }        
    
    public boolean getHideSubmit() {
        return !ra.userCanSubmit;
    }
        
    public boolean getHideAllocateEAN() {
        return !ra.userCanAllocateEAN;
    }

    public boolean getHideWithdraw() {
        return !ra.userCanWithdraw;
    }   
    
    public boolean getHideReactivate() {
        return !ra.userCanReactivate;
    } 
    
    public boolean getHideCreateNewCopy() {
        return !ra.userCanCreateCopy;       
    }
    
    public boolean getHideEdit() {
        return !ra.userCanEdit;
    }
    
    public boolean getHideShortLongAlloc() {
        return !ra.userCanAllocateShortLong;
    }
    
    public boolean getCancelRequest() {
        return !ra.userCanCancel;
    }
}