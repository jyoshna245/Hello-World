/**
* Author,email :     Madel Pascua , mpascua@coca-cola.com
* Date Create  :     September 26, 2013
* Description  :     Test method for GS1_RequestCtrl
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

@isTest //(SeeAllData=true)
private class GS1_TestRequestCtrl{ 
    static testMethod void successfulTest(){    
        Test.startTest();
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){        
            GS1_EAN__c ean = GS1_TestHelper.createBarcodes(true, true, 1000000, 1000000)[0];    
            List<GS1_Request__c>  gs1ListTest = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU);
            GS1_Request__c req = new GS1_Request__c();
            req.RecordTypeId = gs1ListTest[0].RecordTypeId;
            req.Country__c = gs1ListTest[0].Country__c;
            req.Trademark__c = gs1ListTest[0].trademark__c;
            req.Flavour__c = gs1ListTest[0].Flavour__c;
            req.Unit__c = gs1ListTest[0].Unit__c;
            req.Capacity__c = gs1ListTest[0].Capacity__c;
            req.BBN__c = gs1ListTest[0].BBN__c;
            req.Multipack__c = gs1ListTest[0].Multipack__c; 
            req.Units_Pack__c = gs1ListTest[0].Units_Pack__c;
            req.Packs_Case__c = 10;
            req.Material__c = gs1ListTest[0].Material__c;
            req.design__c = gs1ListTest[0].design__c;       
            req.Pallet_Material__c = gs1ListTest[0].Pallet_Material__c;
            req.Pallet_Design__c = gs1ListTest[0].Pallet_Design__c;
            req.Promo_Other__c = gs1ListTest[0].Promo_Other__c;       
            req.Promo_Amount__c = gs1ListTest[0].Promo_Amount__c;
            req.Promo_Currency__c = gs1ListTest[0].Promo_Currency__c;
            req.Promo_Quantity__c = gs1ListTest[0].Promo_Quantity__c;
            req.RequestedByUserId__c = system.Userinfo.getUserId();       
            req.EAN_Code__c = ean.id;
            insert req;      
          
            Pagereference pg = Page.GS1_Product_ViewMode;    
            Test.setCurrentPage(pg);    
            ApexPages.StandardController sc = new ApexPages.StandardController(gs1ListTest[0]);    
            GS1_RequestCtrl controller = new GS1_RequestCtrl(sc);
          
            controller.getSimilarRequests();
            controller.getCancelRequest();
            controller.getDialogTextError();
            controller.getDialogTextInformation();
            controller.getDialogTextWarning();
            controller.getHideAllocateEAN();
            controller.getHideCreateNewCopy();
            controller.getHideEdit();
            controller.getHideReactivate();
            controller.getHideShortLongAlloc();
            controller.getHideSubmit();
            controller.getHideWithdraw();
        }
        Test.stopTest();    
    }     
}