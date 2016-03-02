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
private class GS1_TestObjectsTriggerProcessor{ 
    
   static testMethod void countryTriggerTest() {
        
        Test.startTest();
        //country object
        List<GS1_Country__c> countries = new List<GS1_Country__c>();
        GS1_Country__c c = GS1_TestHelper.createCountry(1)[0];
        GS1_Country__c c1 = new GS1_Country__c();
        c1.Code__c = 'TEST123';
        c1.Name = 'TEST123';
        countries.add(c1);
                
        c1 = new GS1_Country__c();
        c1.Code__c = 'TEST123';
        c1.Name = 'TEST123';
        countries.add(c1);      
        
        c1 = new GS1_Country__c();
        c1.code__c = c.code__c;
        c1.name = c.name;
        countries.add(c1);
        
        c = GS1_TestHelper.createCountry(1)[0];
        c.name = c.name + 'x';
        countries.add(c);
        
        try { upsert countries; } catch (Exception ex) {}
        
        Test.stopTest();
        
   }    
   
    static testMethod void requestTriggerTest() {
        
        Test.startTest();
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            GS1_TestHelper.createAuthor( system.Userinfo.getUserId());
            
            GS1_AuthorProfile__c au = [select Active__c, Id from GS1_AuthorProfile__c where User__c=:System.Userinfo.getUserId() limit 1];
            au.Active__c = true;
            update au;
            
            GS1_Request__c[] reqs = GS1_TestHelper.createRequest(10, GS1_TestHelper.REQUEST_PALLET);
            GS1_Unit_Capacity__c uc = [select name from GS1_Unit_Capacity__c where id=:reqs[0].Capacity__c limit 1];
            uc.name = String.valueOf(integer.valueOf(uc.name)+1);
            try { update uc;} catch (Exception ex) {}
            
            au.Active__c = false;
            update au;
            
            //update reqs[0];
            try { update reqs[0];} catch (Exception ex) {}
            
            au.Active__c = true;
            update au;
            
            reqs[1].Status__c = GS1_Constants.REQUEST_STATUS_NEW;
            reqs[2].Status__c = GS1_Constants.REQUEST_STATUS_REQUESTED;
            reqs[3].Status__c = GS1_Constants.REQUEST_STATUS_REQUESTED;
            reqs[4].Status__c = GS1_Constants.REQUEST_STATUS_NEW;
            reqs[5].Status__c = GS1_Constants.REQUEST_STATUS_APPROVED;
            reqs[6].Status__c = GS1_Constants.REQUEST_STATUS_REQUESTED;
            reqs[7].Status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            reqs[8].Status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;
            reqs[9].Status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;
            try { update reqs;} catch (Exception ex) {}
            
            reqs[1].Status__c = GS1_Constants.REQUEST_STATUS_REQUESTED;     
            reqs[2].Status__c = GS1_Constants.REQUEST_STATUS_APPROVED;
            reqs[3].Status__c = GS1_Constants.REQUEST_STATUS_REJECTED;
            reqs[4].Status__c = GS1_Constants.REQUEST_STATUS_CANCELLED;
            reqs[5].Status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            reqs[6].Status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            reqs[7].Status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;
            reqs[8].Status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            reqs[9].Status__c = GS1_Constants.REQUEST_STATUS_INACTIVE;
            try { update reqs;} catch (Exception ex) {}
            
            delete reqs;    
        }
        Test.stopTest();        
    }   
    
    static testMethod void authorTriggerTest() {
        
        //author object
        List<GS1_AuthorProfile__c> authors = new List<GS1_AuthorProfile__c>();
        GS1_AuthorProfile__c auth = GS1_TestHelper.createAuthor( System.Userinfo.getUserId());
        GS1_AuthorProfile__c authx = GS1_TestHelper.createAuthor( System.Userinfo.getUserId());
        GS1_AuthorProfile__c au1 = new GS1_AuthorProfile__c ();
        au1.User__c = System.Userinfo.getUserId();
        authors.add(au1);
        
        au1 = new GS1_AuthorProfile__c ();
        au1.User__c = System.Userinfo.getUserId();
        authors.add(au1);
        
        try { insert authors;} catch (Exception ex) {}      
        
        //triggers tests        
        //User u = [select id from User where profile.userlicense.name='Salesforce Platform' AND IsActive=true limit 1];
        User u = GS1_TestHelper.createTestUser();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs( thisUser ) {
            GS1_AuthorProfile__c testAuthor = GS1_TestHelper.createAuthor(u.id);
            
            GS1_AuthorProfile__c au = GS1_TestHelper.createAuthor( System.Userinfo.getUserId());
            au = [select Active__c, Id from GS1_AuthorProfile__c where User__c=:System.Userinfo.getUserId() limit 1];           
            
            GS1_Country__c[] countries = new List<GS1_Country__c>();
            countries = GS1_TestHelper.createCountry(10);
            
            GS1_CountryAuthor__c[] cauthors = new List<GS1_CountryAuthor__c>();
            for (GS1_Country__c cntry : countries) {
                GS1_CountryAuthor__c cau = new GS1_CountryAuthor__c();
                cau.AuthorProfile__c = au.id;
                cau.Country__c = cntry.id;
                cauthors.add(cau);
            }
            
            for (GS1_Country__c cntry : countries) {
                GS1_CountryAuthor__c cau = new GS1_CountryAuthor__c();
                cau.AuthorProfile__c = testAuthor.id;
                cau.Country__c = cntry.id;
                cauthors.add(cau);
            }       
            
            try {insert cauthors;} catch (Exception e) {}
            
            for (GS1_CountryAuthor__c cau : cauthors) {
                cau.Country_Reader__c = true;
            }
            
            try {update cauthors;} catch (Exception e) {}
            
            try {update countries;} catch (Exception e) {}
            
            testAuthor.Active__c = false;
            try {update testAuthor;} catch (Exception e) {}
            
            testAuthor.Active__c = true;
            try {update testAuthor;} catch (Exception e) {}
        
            Test.startTest();   
            try {delete cauthors;} catch (Exception e) {}    
            try {delete countries;} catch (Exception e) {}  
            try {delete testAuthor;} catch (Exception e) {}
            Test.stopTest();
        }
        
    }    
    
    static testMethod void lookupTableTriggerTest() {
        Test.startTest();
        
        GS1_Trademark__c[] tm = GS1_TestHelper.createTrademark(10);
        GS1_Flavour__c[] fl = GS1_TestHelper.createFlavour(tm[0], 10);
        GS1_Material__c[] mt = GS1_TestHelper.createMaterial(10);
        GS1_Design__c[] ds = GS1_TestHelper.createDesign(mt[0], 10);
        GS1_Multipack__c[] mp = GS1_TestHelper.createMultipack(10);
        GS1_Multipack_Value__c[] mv = GS1_TestHelper.createMultipackValue(mp[0], 10);
        GS1_Pallet_Material__c[] pm = GS1_TestHelper.createPalletMaterial(10);
        GS1_Pallet_Design__c[] pd = GS1_TestHelper.createPalletDesign(pm[0], 10);
        GS1_BBN__c[] bbn = GS1_TestHelper.createBBN(fl[0], 10);
        GS1_Currency__c[] ccy = GS1_TestHelper.createCurrency(10);
        GS1_Promo_Free_Product__c[] fp = GS1_TestHelper.createPromoFreeProduct(10);
        GS1_Promo_Other__c[] po = GS1_TestHelper.createPromoOthers(10);
        
        update tm;
        update fl;
        update mt;
        update ds;
        update mp;
        update mv;
        update pm;
        update pd;
        update bbn;
        update ccy;
        update fp;
        update po;
                
        delete ds;
        delete mt;
        delete mv;      
        delete mp;      
        delete pd;
        delete pm;
        delete bbn;
        delete ccy;
        delete fp;
        delete po;      
        delete fl;
        delete tm;              
        
        Test.stopTest();            
    }
    
    static testMethod void barcodeTest() {
        Test.startTest();
        GS1_EAN__c[] allBarcodes = new List<GS1_EAN__c>();
        
        GS1_EAN__c[] barcodes;
        barcodes = GS1_TestHelper.createBarcodes(false, false, 1000001, 1000010);
        allBarcodes.addAll(barcodes);
        
        barcodes = GS1_TestHelper.createBarcodes(true,  false, 1000011, 1000020);
        allBarcodes.addAll(barcodes);       
        
        barcodes = GS1_TestHelper.createBarcodes(true,  true,  1000021, 1000030);
        allBarcodes.addAll(barcodes);       
        
        barcodes = GS1_TestHelper.createBarcodes(false, true,  1000031, 1000040);
        allBarcodes.addAll(barcodes);                       
                
        barcodes = GS1_TestHelper.createBarcodes(false, false, long.valueOf('100001000001'), long.valueOf('100001000010'));     
        allBarcodes.addAll(barcodes);
        
        barcodes = GS1_TestHelper.createBarcodes(true,  false, long.valueOf('100001000011'), long.valueOf('100001000020'));
        allBarcodes.addAll(barcodes);       
        
        barcodes = GS1_TestHelper.createBarcodes(true,  true,  long.valueOf('100001000021'), long.valueOf('100001000030'));
        allBarcodes.addAll(barcodes);       
        
        barcodes = GS1_TestHelper.createBarcodes(false, true,  long.valueOf('100001000031'), long.valueOf('100001000040'));
        allBarcodes.addAll(barcodes);       
        
        for (GS1_EAN__c ean : allBarcodes) {
            ean.Status__c = 'Allocated';
        }
        
        GS1_EAN__c bc = new GS1_EAN__c();
        bc.Name = '1';
        try {
            insert bc;
        } catch (Exception e) {}
        
        
        update allBarcodes;
        
        for (GS1_EAN__c ean : allBarcodes) {
            ean.Status__c = 'Free';
        }
        update allBarcodes;   
        
        delete allBarcodes;
        Test.stopTest();    
    }
    static testMethod void shortLongAssignmentTest() {
        Test.startTest();
        //request short-long test
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            List<sOBject> slo = new List<sObject>();
            GS1_Unit__c[] unitCode = [select id from GS1_Unit__c where Code__c='2'];
            if (!(unitcode!=null && unitCode.size()>0)) {
                unitCode = GS1_TestHelper.createUnitOfMeasurement(1);
                unitCode[0].Code__c = '2';
                slo.add(unitCode[0]);
            }
            
            GS1_Trademark__c[] trademark = [select id from GS1_Trademark__c where Code__c='90'];
            if (!(trademark!=null && trademark.size()>0)) {
                trademark = GS1_TestHelper.createTrademark(1);
                trademark[0].Code__c = '90';
                slo.add(trademark[0]);
            }       
            
            GS1_Material__c[] mat1 = [select id from GS1_Material__c where Code__c='1'];
            if (!(mat1!=null && mat1.size()>0)) {
                mat1 = GS1_TestHelper.createMaterial(1);
                mat1[0].Code__c = '1';
                slo.add(mat1[0]);
            }
            
            GS1_Material__c[] mat2 = [select id from GS1_Material__c where Code__c='2'];
            if (!(mat2!=null && mat2.size()>0)) {
                mat2 = GS1_TestHelper.createMaterial(1);
                mat2[0].Code__c = '2';
                slo.add(mat2[0]);
            }       
    
            GS1_Material__c[] mat3 = [select id from GS1_Material__c where Code__c='3'];
            if (!(mat3!=null && mat3.size()>0)) {
                mat3 = GS1_TestHelper.createMaterial(1);
                mat3[0].Code__c = '3';
                slo.add(mat3[0]);
            }       
            
            GS1_Material__c[] mat4 = [select id from GS1_Material__c where Code__c='4'];
            if (!(mat4!=null && mat4.size()>0)) {
                mat4 = GS1_TestHelper.createMaterial(1);
                mat4[0].Code__c = '4';
                slo.add(mat4[0]);
            }
            
            if (slo.size()>0) {
                update slo;
            }
            
            GS1_Unit__c code = GS1_TestHelper.createUnitOfMeasurement(1)[0];
            GS1_Unit_Capacity__c cp1 = new GS1_Unit_Capacity__c();
            cp1.Unit__c = code.id;
            cp1.Name = '150';
            
            GS1_Unit_Capacity__c cp2 = new GS1_Unit_Capacity__c();
            cp2.Unit__c = unitCode[0].id;
            cp2.Name = '150';       
                    
            insert cp1;     
            
            GS1_Request__c[] req = GS1_TestHelper.createRequest(6, GS1_TestHelper.REQUEST_CUDU);
    
            req[0].unit__c = unitCode[0].id;
            req[0].capacity__c = cp2.id;
            
            req[1].trademark__c = trademark[0].id;
            req[1].flavour__c = GS1_TestHelper.createFlavour(trademark[0], 1)[0].id;
                            
            req[2].unit__c = code.id;
            req[2].capacity__c = cp1.id;
            req[2].material__c = mat1[0].id;
            req[2].design__c = GS1_TestHelper.createDesign(mat1[0], 1)[0].id;
            
            req[3].unit__c = code.id;
            req[3].capacity__c = cp1.id;
            req[3].material__c = mat3[0].id;
            req[3].design__c = GS1_TestHelper.createDesign(mat3[0], 1)[0].id;   
            
            req[4].unit__c = code.id;
            req[4].capacity__c = cp1.id;
            req[4].material__c = mat4[0].id;
            req[4].design__c = GS1_TestHelper.createDesign(mat4[0], 1)[0].id;
            
            update req;
        }
        Test.stopTest();            
    } 
}