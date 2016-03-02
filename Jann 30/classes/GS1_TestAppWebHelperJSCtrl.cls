/**
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     September 26, 2013
* Description  :     Test method for GS1_ApprovalProcess 
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

@isTest //(SeeAllData=true)
private class GS1_TestAppWebHelperJSCtrl {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();            
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){            
            GS1_Request__c request = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU)[0];
            Id cId = request.Country__c;                
            GS1_AppWebHelperJSCtrl clss = new GS1_AppWebHelperJSCtrl();
            GS1_EAN__c barcode = GS1_TestHelper.createBarcodes(true, false, 4567891, 4567891)[0];
            GS1_request__c request2 = new GS1_Request__c();
            request2.RecordTypeId = request.RecordTypeId;
            request2.Country__c = request.Country__c;
            request2.Trademark__c = request.trademark__c;
            request2.Flavour__c = request.Flavour__c;
            request2.Unit__c = request.Unit__c;
            request2.Capacity__c = request.Capacity__c;
            request2.BBN__c = request.BBN__c;
            request2.Multipack__c = request.Multipack__c; 
            request2.Units_Pack__c = request.Units_Pack__c;
            request2.Packs_Case__c = 10;
            request2.Material__c = request.Material__c;
            request2.design__c = request.design__c;       
            request2.Pallet_Material__c = request.Pallet_Material__c;
            request2.Pallet_Design__c = request.Pallet_Design__c;
            request2.Promo_Other__c = request.Promo_Other__c;
            request2.Promo_Amount__c = 1000;
            request2.Promo_Currency__c = request.Promo_Currency__c;
            request2.Promo_Quantity__c = request.Promo_Quantity__c;       
            request2.requestedByUserId__c = system.Userinfo.getUserId();       
            request2.EAN_Code__c = barcode.id;
            request2.status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;      
            insert request2;  
            
            request.Country__c = null;
            update request;
            
            request = [select id, Country__c, Flavour__c, Long_Short__c, Request_type__c, Design__c, Promotion_type__c, Promo_Quantity__c, Product_Type__c, Promo_Amount__c, Promo_Other__c, Promo_Currency__c, EAN_Code__c, BBN__c, BBN__r.code__c, Status__c, Packs_Case__c, Material__c, Capacity__c, Units_Pack__c, Unit__c, Trademark__c, Multipack__c, Multipack_Type__c,Pallet_Material__c, Pallet_Design__c, Number_of_Layers__c, Count_per_Pallet__c from GS1_Request__c where id =:request.id limit 1];
            
            
            GS1_EAN__c[] allBarcodes = new list<GS1_EAN__c>();
            GS1_EAN__c[] barcodes;
            barcodes = GS1_TestHelper.createBarcodes(false, false, 1000001, 1000001);
            allBarcodes.addAll(barcodes);
            
            barcodes = GS1_TestHelper.createBarcodes(true,  false, 1000011, 1000011);
            allBarcodes.addAll(barcodes);       
            
            barcodes = GS1_TestHelper.createBarcodes(true,  true,  1000021, 1000021);
            allBarcodes.addAll(barcodes);       
            
            barcodes = GS1_TestHelper.createBarcodes(false, true,  1000031, 1000031);
            allBarcodes.addAll(barcodes);                       
                    
            barcodes = GS1_TestHelper.createBarcodes(false, false, long.valueOf('100001000001'), long.valueOf('10000100001'));      
            allBarcodes.addAll(barcodes);
            
            barcodes = GS1_TestHelper.createBarcodes(true,  false, long.valueOf('100001000011'), long.valueOf('100001000011'));
            allBarcodes.addAll(barcodes);       
            
            barcodes = GS1_TestHelper.createBarcodes(true,  true,  long.valueOf('100001000021'), long.valueOf('100001000021'));
            allBarcodes.addAll(barcodes);       
            
            barcodes = GS1_TestHelper.createBarcodes(false, true,  long.valueOf('100001000031'), long.valueOf('100001000031'));
            allBarcodes.addAll(barcodes);         
            
            GS1_AppWebHelperJSCtrl.findDuplicateRequest('');
            GS1_AppWebHelperJSCtrl.submitRequest('', null);
            GS1_AppWebHelperJSCtrl.findAllowableEAN('');
            GS1_AppWebHelperJSCtrl.findAllowableEANSpecial('','Long');
            GS1_AppWebHelperJSCtrl.allocateEAN('','',false);
            
            GS1_AppWebHelperJSCtrl.findDuplicateRequest(String.valueOf(request.Id));
            request.Country__c = cId;
            update request;        
            
            GS1_AppWebHelperJSCtrl.findDuplicateRequest(String.valueOf(request.Id));
                    
            Map<String, Object> ss = (Map<String, Object>)json.deserializeUntyped(GS1_AppWebHelperJSCtrl.submitRequest(String.valueOf(request.Id), null));
            System.assert(ss.get('status') == 'ok');
            Map<String, Object> cs = (Map<String, Object>)json.deserializeUntyped(GS1_AppWebHelperJSCtrl.findAllowableEAN(String.valueOf(request.Id)));
            if (cs.get('status') == 'ok') {
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), '', true);
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), string.valueOf(cs.get('eanId')), true);
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), string.valueOf(cs.get('eanId')), false);
            } else {
                
            }
            
            cs = (Map<String, Object>)JSON.deserializeUntyped(GS1_AppWebHelperJSCtrl.findAllowableEANSpecial(String.valueOf(request.Id),''));
            if (cs.get('status') == 'ok') {
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), '', true);
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), string.valueOf(cs.get('eanId')), true);
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), string.valueOf(cs.get('eanId')), false);
            } else {
                
            }         
            
            GS1_AppWebHelperJSCtrl.findSameRequests(request);
        }
        Test.stopTest();
    }
    
    static testMethod void test1() {
        // TO DO: implement unit test
        Test.startTest();        
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){        
            GS1_Request__c request = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU)[0];                
            GS1_AppWebHelperJSCtrl clss = new GS1_AppWebHelperJSCtrl();
            
            request.status__c = GS1_Constants.REQUEST_STATUS_APPROVED;
            update request;        
                    
            request = [select id, Country__c, Flavour__c, Long_Short__c, Request_type__c, Design__c, Promotion_type__c, Promo_Quantity__c, Product_Type__c, Promo_Amount__c, Promo_Other__c, Promo_Currency__c, EAN_Code__c, BBN__c, BBN__r.code__c, Status__c, Packs_Case__c, Material__c, Capacity__c, Units_Pack__c, Unit__c, Trademark__c, Multipack__c, Multipack_Type__c,Pallet_Material__c, Pallet_Design__c, Number_of_Layers__c, Count_per_Pallet__c from GS1_Request__c where id =:request.id limit 1];
            
            
            GS1_EAN__c[] allBarcodes = new list<GS1_EAN__c>();
            GS1_EAN__c[] barcodes;
            barcodes = GS1_TestHelper.createBarcodes(false, false, 1000001, 1000001);
            allBarcodes.addAll(barcodes);
            
            barcodes = GS1_TestHelper.createBarcodes(true,  false, 1000011, 1000011);
            allBarcodes.addAll(barcodes);       
            
            barcodes = GS1_TestHelper.createBarcodes(true,  true,  1000021, 1000021);
            allBarcodes.addAll(barcodes);       
            
            barcodes = GS1_TestHelper.createBarcodes(false, true,  1000031, 1000031);
            allBarcodes.addAll(barcodes);                       
                    
            barcodes = GS1_TestHelper.createBarcodes(false, false, long.valueOf('100001000001'), long.valueOf('10000100001'));      
            allBarcodes.addAll(barcodes);
            
            barcodes = GS1_TestHelper.createBarcodes(true,  false, long.valueOf('100001000011'), long.valueOf('100001000011'));
            allBarcodes.addAll(barcodes);       
            
            barcodes = GS1_TestHelper.createBarcodes(true,  true,  long.valueOf('100001000021'), long.valueOf('100001000021'));
            allBarcodes.addAll(barcodes);       
            
            barcodes = GS1_TestHelper.createBarcodes(false, true,  long.valueOf('100001000031'), long.valueOf('100001000031'));
            allBarcodes.addAll(barcodes);         
            
            GS1_AppWebHelperJSCtrl.findDuplicateRequest('');
            GS1_AppWebHelperJSCtrl.submitRequest('', null);
            GS1_AppWebHelperJSCtrl.findAllowableEAN('');
            GS1_AppWebHelperJSCtrl.findAllowableEANSpecial('','Long');
            GS1_AppWebHelperJSCtrl.allocateEAN('','',false);
            
            GS1_AppWebHelperJSCtrl.findDuplicateRequest(String.valueOf(request.Id));
                    
            GS1_AppWebHelperJSCtrl.submitRequest(String.valueOf(request.Id), null);
            //GS1_AppWebHelperJSCtrl.CallStatus cs = (GS1_AppWebHelperJSCtrl.CallStatus)JSON.deserialize(GS1_AppWebHelperJSCtrl.findAllowableEAN(String.valueOf(request.Id)),GS1_AppWebHelperJSCtrl.CallStatus.class);
            Map<String, Object> cs = (Map<String, Object>)JSON.deserializeUntyped(GS1_AppWebHelperJSCtrl.findAllowableEANSpecial(String.valueOf(request.Id),''));
            if (cs.get('status') == 'ok') {
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), '', true);
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), string.valueOf(cs.get('eanId')), true);
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), string.valueOf(cs.get('eanId')), false);
            } else {
                
            }
            
            //cs = (GS1_AppWebHelperJSCtrl.CallStatus)JSON.deserialize(GS1_AppWebHelperJSCtrl.findAllowableEANSpecial(String.valueOf(request.Id),'Long'),GS1_AppWebHelperJSCtrl.CallStatus.class);
            cs = (Map<String, Object>)json.deserializeUntyped(GS1_AppWebHelperJSCtrl.findAllowableEAN(String.valueOf(request.Id)));
            if (cs.get('status') == 'ok') {
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), '', true);
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), string.valueOf(cs.get('eanId')), true);
                GS1_AppWebHelperJSCtrl.allocateEAN(String.valueOf(request.Id), string.valueOf(cs.get('eanId')), false);
            } else {
                
            }         
            
            GS1_AppWebHelperJSCtrl.findSameRequests(request);
        }
        Test.stopTest();
    }    
    
    static testMethod void test2() { 
        Test.startTest();        
        GS1_AppWebHelperJSCtrl clss = new GS1_AppWebHelperJSCtrl();
        GS1_AppWebHelperJSCtrl.getGS1ObjectIds();
        GS1_AppWebHelperJSCtrl.getObjectPrefix('GS1_Request__c');
        clss.getIsGS1Admin();
        clss.getRequestObjectPrefix();                  
        Test.stopTest();
    }
    
    static testMethod void test3() {
        Test.startTest();        
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){
            GS1_Request__c request = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU)[0];                
            GS1_AppWebHelperJSCtrl clss = new GS1_AppWebHelperJSCtrl();
            GS1_AppWebHelperJSCtrl.cancelRequest(String.valueOf(request.Id));
            GS1_AppWebHelperJSCtrl.cancelRequest('');
        }
        Test.stopTest();
    }
    
    static testMethod void test4v1() {
        Test.startTest();        
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){    
            GS1_Request__c request = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU)[0];                
            GS1_AppWebHelperJSCtrl clss = new GS1_AppWebHelperJSCtrl();
            
            GS1_EAN__c barcode = GS1_TestHelper.createBarcodes(true, false, 4567891, 4567891)[0];
            GS1_request__c request2 = new GS1_Request__c();
            request2.RecordTypeId = request.RecordTypeId;
            request2.Country__c = request.Country__c;
            request2.Trademark__c = request.trademark__c;
            request2.Flavour__c = request.Flavour__c;
            request2.Unit__c = request.Unit__c;
            request2.Capacity__c = request.Capacity__c;
            request2.BBN__c = request.BBN__c;
            request2.Multipack__c = request.Multipack__c; 
            request2.Units_Pack__c = request.Units_Pack__c;
            request2.Packs_Case__c = 10;
            request2.Material__c = request.Material__c;
            request2.design__c = request.design__c;       
            request2.Pallet_Material__c = request.Pallet_Material__c;
            request2.Pallet_Design__c = request.Pallet_Design__c;
            request2.Promo_Other__c = request.Promo_Other__c;
            request2.Promo_Amount__c = 1000;
            request2.Promo_Currency__c = request.Promo_Currency__c;
            request2.Promo_Quantity__c = request.Promo_Quantity__c;       
            request2.requestedByUserId__c = system.Userinfo.getUserId();       
            request2.EAN_Code__c = barcode.id;      
            insert request2;                  
            
            request.Status__c = GS1_Constants.REQUEST_STATUS_REQUESTED;
            update request;        
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest(String.valueOf(request.Id));        
            
            request.Status__c = GS1_Constants.REQUEST_STATUS_APPROVED;
            update request;        
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest(String.valueOf(request.Id));
                    
            GS1_AppWebHelperJSCtrl.sendDuplicateRequestEmail(String.valueOf(request.Id));
            
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest('');
            GS1_AppWebHelperJSCtrl.sendDuplicateRequestEmail('');
        }
        Test.stopTest();
    }
    
    static testMethod void test4v2() {
        Test.startTest();        
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){    
            GS1_Request__c request = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU_OTHER)[0];                
            GS1_AppWebHelperJSCtrl clss = new GS1_AppWebHelperJSCtrl();
            
            GS1_EAN__c barcode = GS1_TestHelper.createBarcodes(true, false, 4567891, 4567891)[0];
            GS1_request__c request2 = new GS1_Request__c();
            request2.RecordTypeId = request.RecordTypeId;
            request2.Country__c = request.Country__c;
            request2.Trademark__c = request.trademark__c;
            request2.Flavour__c = request.Flavour__c;
            request2.Unit__c = request.Unit__c;
            request2.Capacity__c = request.Capacity__c;
            request2.BBN__c = request.BBN__c;
            request2.Multipack__c = request.Multipack__c; 
            request2.Units_Pack__c = request.Units_Pack__c;
            request2.Packs_Case__c = 10;
            request2.Material__c = request.Material__c;
            request2.design__c = request.design__c;       
            request2.Pallet_Material__c = request.Pallet_Material__c;
            request2.Pallet_Design__c = request.Pallet_Design__c;
            request2.Promo_Other__c = request.Promo_Other__c;
            request2.Promo_Amount__c = 1000;
            request2.Promo_Currency__c = request.Promo_Currency__c;
            request2.Promo_Quantity__c = request.Promo_Quantity__c;       
            request2.requestedByUserId__c = system.Userinfo.getUserId();       
            request2.EAN_Code__c = barcode.id;      
            insert request2;
            
            GS1_AppWebHelperJSCtrl.findDuplicateRequest(String.valueOf(request.id));                  
            
            request.Status__c = GS1_Constants.REQUEST_STATUS_REQUESTED;
            update request;        
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest(String.valueOf(request.Id));        
            
            request.Status__c = GS1_Constants.REQUEST_STATUS_APPROVED;
            update request;        
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest(String.valueOf(request.Id));
                    
            GS1_AppWebHelperJSCtrl.sendDuplicateRequestEmail(String.valueOf(request.Id));
            
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest('');
            GS1_AppWebHelperJSCtrl.sendDuplicateRequestEmail('');
        }
        Test.stopTest();
    }    
    
   static testMethod void test4v3() {
        Test.startTest();        
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){    
            GS1_Request__c request = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU_QUANT)[0];                
            GS1_AppWebHelperJSCtrl clss = new GS1_AppWebHelperJSCtrl();
            
            GS1_EAN__c barcode = GS1_TestHelper.createBarcodes(true, false, 4567891, 4567891)[0];
            GS1_request__c request2 = new GS1_Request__c();
            request2.RecordTypeId = request.RecordTypeId;
            request2.Country__c = request.Country__c;
            request2.Trademark__c = request.trademark__c;
            request2.Flavour__c = request.Flavour__c;
            request2.Unit__c = request.Unit__c;
            request2.Capacity__c = request.Capacity__c;
            request2.BBN__c = request.BBN__c;
            request2.Multipack__c = request.Multipack__c; 
            request2.Units_Pack__c = request.Units_Pack__c;
            request2.Packs_Case__c = 10;
            request2.Material__c = request.Material__c;
            request2.design__c = request.design__c;       
            request2.Pallet_Material__c = request.Pallet_Material__c;
            request2.Pallet_Design__c = request.Pallet_Design__c;
            request2.Promo_Other__c = request.Promo_Other__c;
            request2.Promo_Amount__c = 1000;
            request2.Promo_Currency__c = request.Promo_Currency__c;
            request2.Promo_Quantity__c = request.Promo_Quantity__c;       
            request2.requestedByUserId__c = system.Userinfo.getUserId();       
            request2.EAN_Code__c = barcode.id;      
            insert request2;
            
            GS1_AppWebHelperJSCtrl.findDuplicateRequest(String.valueOf(request.id));                  
            
            request.Status__c = GS1_Constants.REQUEST_STATUS_REQUESTED;
            update request;        
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest(String.valueOf(request.Id));        
            
            request.Status__c = GS1_Constants.REQUEST_STATUS_APPROVED;
            update request;        
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest(String.valueOf(request.Id));
                    
            GS1_AppWebHelperJSCtrl.sendDuplicateRequestEmail(String.valueOf(request.Id));
            
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest('');
            GS1_AppWebHelperJSCtrl.sendDuplicateRequestEmail('');
        }
        Test.stopTest();
    }   
    
    static testMethod void test4v4() {
        Test.startTest();        
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){    
            GS1_Request__c request = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_PALLET)[0];                
            GS1_AppWebHelperJSCtrl clss = new GS1_AppWebHelperJSCtrl();
            
            GS1_EAN__c barcode = GS1_TestHelper.createBarcodes(true, false, 4567891, 4567891)[0];
            GS1_request__c request2 = new GS1_Request__c();
            request2.RecordTypeId = request.RecordTypeId;
            request2.Country__c = request.Country__c;
            request2.Trademark__c = request.trademark__c;
            request2.Flavour__c = request.Flavour__c;
            request2.Unit__c = request.Unit__c;
            request2.Capacity__c = request.Capacity__c;
            request2.BBN__c = request.BBN__c;
            request2.Multipack__c = request.Multipack__c; 
            request2.Units_Pack__c = request.Units_Pack__c;
            request2.Packs_Case__c = 10;
            request2.Material__c = request.Material__c;
            request2.design__c = request.design__c;       
            request2.Pallet_Material__c = request.Pallet_Material__c;
            request2.Pallet_Design__c = request.Pallet_Design__c;
            request2.Promo_Other__c = request.Promo_Other__c;
            request2.Promo_Amount__c = 1000;
            request2.Promo_Currency__c = request.Promo_Currency__c;
            request2.Promo_Quantity__c = request.Promo_Quantity__c;       
            request2.requestedByUserId__c = system.Userinfo.getUserId();       
            request2.EAN_Code__c = barcode.id;      
            insert request2;                  
            
            GS1_AppWebHelperJSCtrl.findDuplicateRequest(String.valueOf(request.id));
            
            request.Status__c = GS1_Constants.REQUEST_STATUS_REQUESTED;
            update request;        
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest(String.valueOf(request.Id));        
            
            request.Status__c = GS1_Constants.REQUEST_STATUS_APPROVED;
            update request;        
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest(String.valueOf(request.Id));
                    
            GS1_AppWebHelperJSCtrl.sendDuplicateRequestEmail(String.valueOf(request.Id));
            
            GS1_AppWebHelperJSCtrl.cancelDuplicateRequest('');
            GS1_AppWebHelperJSCtrl.sendDuplicateRequestEmail('');
        }
        Test.stopTest();
    }     
        
    static testMethod void test5() {
        Test.startTest();        
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){    
            GS1_Request__c request = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU)[0];
            GS1_EAN__c barcode = GS1_TestHelper.createBarcodes(true, false, 4567891, 4567891)[0];
            GS1_AppWebHelperJSCtrl.freeBarcode(barcode.id);
                   
            request.EAN_Code__c = barcode.id;        
            request.status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            update request;
                            
            GS1_AppWebHelperJSCtrl clss = new GS1_AppWebHelperJSCtrl();
            
            GS1_AppWebHelperJSCtrl.withdrawRequest(String.valueOf(request.Id));
            GS1_AppWebHelperJSCtrl.reactivateRequest(String.valueOf(request.Id));
            GS1_AppWebHelperJSCtrl.freeBarcode(barcode.id);
            
            GS1_AppWebHelperJSCtrl.withdrawRequest(String.valueOf(request.Id));
            GS1_AppWebHelperJSCtrl.freeBarcode(barcode.id);
    
            GS1_AppWebHelperJSCtrl.withdrawRequest('');
            GS1_AppWebHelperJSCtrl.reactivateRequest('');      
            
            GS1_AppWebHelperJSCtrl.sendDuplicateRequestEmail(String.valueOf(request.Id));  
        }
        Test.stopTest();
    }          

    static testMethod void test6() {
        Test.startTest();        
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){    
            GS1_Request__c request = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU)[0];
            GS1_EAN__c barcode = GS1_TestHelper.createBarcodes(true, false, 4567891, 4567891)[0];
                              
            GS1_AppWebHelperJSCtrl.submitRequest(request.Id, null);
            GS1_AppWebHelperJSCtrl.allocateEAN(request.Id, barcode.id, false);
        }
        Test.stopTest();
    }                
}