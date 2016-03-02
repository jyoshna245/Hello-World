/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 20, 2013
* Description  :     Test class for GS1_Constants class
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
@isTest  //(seeAllData=true)
private class GS1_TestCustomSearchCtrl {
    static Id countryId;
    static void createSearchData() {
        GS1_AuthorProfile__c au = GS1_TestHelper.createAuthor( System.Userinfo.getUserId());
        au = [select Active__c, Id from GS1_AuthorProfile__c where User__c=:System.Userinfo.getUserId() limit 1];      	
    	
        GS1_Request__c[] reqs = GS1_TestHelper.createRequest(200, GS1_TestHelper.REQUEST_CUDU);
        GS1_Country__c ctry = GS1_TestHelper.createCountry(1)[0];
        ctry.Name = 'BELGIUM' + String.valueOf(System.currentTimeMillis());
        update ctry;
        
        GS1_CountryAuthor__c cau = new GS1_CountryAuthor__c();
        cau.AuthorProfile__c = au.id;
        cau.Country__c = ctry.id;
        insert cau;   
        
        for(GS1_Request__c req : reqs) {
            req.Country__c = ctry.id;
        }
        
        update reqs;
        
        GS1_TestCustomSearchCtrl.countryId = ctry.id;       
    }
    
    static void testSearch(String srcView) {
        Pagereference pg = Page.GS1_CustomSearchPage;    
        Test.setCurrentPage(pg);
        GS1_Request__c input = new GS1_Request__c();
        pg.getParameters().put('v', srcView);
        ApexPages.StandardController sc = new ApexPages.StandardController(input);    
        GS1_CustomSearchCtrl controller = new GS1_CustomSearchCtrl(sc);         
        
        input.Country__c = GS1_TestCustomSearchCtrl.countryId;
        controller.execSearch();
        
        controller.getSortFieldsList();
        controller.getStatusList();
                
        controller.execSearch();

        controller.getSearchResult();
        controller.getResultCount();
        
        controller.startOver();     
    }   
    
    static testMethod void test1() {
        Test.startTest();           
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            GS1_TestCustomSearchCtrl.createSearchData();
            GS1_TestCustomSearchCtrl.testSearch('For Barcode Allocation');
            GS1_TestCustomSearchCtrl.testSearch('To Send Back');
            GS1_TestCustomSearchCtrl.testSearch('By Approval Date');
            GS1_TestCustomSearchCtrl.testSearch('CU/DU Normal');
        }
        Test.stopTest();
    }
    
    static testMethod void test5() {
        Test.startTest();           
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
        	GS1_TestCustomSearchCtrl.createSearchData();
            GS1_TestCustomSearchCtrl.testSearch('CU/DU Promotion');
            GS1_TestCustomSearchCtrl.testSearch('Pallet Normal');
            GS1_TestCustomSearchCtrl.testSearch('Pallet Promotion');
            GS1_TestCustomSearchCtrl.testSearch('Drafts');
        }
        Test.stopTest();
    }
    
    static testMethod void test6() {
        Test.startTest();           
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
        	GS1_TestCustomSearchCtrl.createSearchData();
            GS1_TestCustomSearchCtrl.testSearch('Waiting Approval');
            GS1_TestCustomSearchCtrl.testSearch('Rejected');
            GS1_TestCustomSearchCtrl.testSearch('Withdrawn');
        }
        Test.stopTest();
    }        
    
    static testMethod void test2() {
        Test.startTest();           
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            GS1_TestCustomSearchCtrl.createSearchData();
            
            Pagereference pg = Page.GS1_CustomSearchPage;    
            Test.setCurrentPage(pg);
            GS1_Request__c input = new GS1_Request__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(input);    
            GS1_CustomSearchCtrl controller = new GS1_CustomSearchCtrl(sc);
            
            controller.isAdminUser=true;
            controller.getAvailableCountryList();
            
            controller.isAdminUser=false;
            controller.getAvailableCountryList();            
            
            input.Country__c = GS1_TestCustomSearchCtrl.countryId;          
            
            controller.unitsPerCase = 'xxxx';
            controller.sortField = '';
            controller.sortOrder = 'Descending';
            controller.execSearch();
        }
        Test.stopTest();
    }    
    
    static testMethod void test3() {
        Test.startTest();           
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            GS1_TestCustomSearchCtrl.createSearchData();
            
            Pagereference pg = Page.GS1_CustomSearchPage;    
            Test.setCurrentPage(pg);
            GS1_Request__c input = new GS1_Request__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(input);    
            GS1_CustomSearchCtrl controller = new GS1_CustomSearchCtrl(sc);
            
            input.Country__c = GS1_TestCustomSearchCtrl.countryId;          
            
            controller.sortField = 'Status__c';
            controller.sortOrder = 'Descending';
            controller.unitsPerCase = '10';
            controller.getSortFieldsList();
            controller.getStatusList();
                    
            controller.execSearch();
    
            controller.getSearchResult();
            controller.getResultCount();
            
            controller.startOver();        
        }
        Test.stopTest();
    }
    
    static testMethod void test4() {
        Test.startTest();           
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            GS1_TestCustomSearchCtrl.createSearchData();
            
            Pagereference pg = Page.GS1_CustomSearchPage;    
            Test.setCurrentPage(pg);
            GS1_Request__c input = new GS1_Request__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(input);    
            GS1_CustomSearchCtrl controller = new GS1_CustomSearchCtrl(sc);
            
            controller.sortField = 'Status__c';
            controller.sortOrder = 'Descending';
            controller.getSortFieldsList();
            controller.getStatusList();
                    
            controller.execSearch();
    
            controller.getSearchResult();
            controller.getResultCount();
            
            controller.startOver();        
        }
        Test.stopTest();
    }            
}