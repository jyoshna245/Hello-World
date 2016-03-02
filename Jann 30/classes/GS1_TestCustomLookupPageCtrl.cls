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
@isTest //(seeAllData=true)
private class GS1_TestCustomLookupPageCtrl {

    static testMethod void test1() {
        Test.startTest();           
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            Pagereference pg = Page.GS1_CustomLookupPage;
            
            GS1_TestHelper.createRequest(200, GS1_TestHelper.REQUEST_PALLET);
            
            //GS1_LookupDefinitions__c[] lus = [select id from GS1_LookupDefinitions__c];
            //delete lus;
            GS1_LookupDefinitions__c  ludef = new GS1_LookupDefinitions__c();
            ludef.Active__c = true;
            ludef.Name = 'GS1_Request__c';
            luDef.Display_Fields__c = 'Name,Id';
            luDef.Fixed_Filter_Expression__c = 'Name!=null';
            ludef.Variable_Filter_Expression__c = 'Name!=null';
            insert ludef;
            
            String CurrentObjectId = GS1_CommonFunctions.getObjectPrefix('GS1_Country__c');         
              
            pg.getParameters().put('ObjectPrefix',GS1_CommonFunctions.getObjectPrefix('GS1_Request__c'));
            pg.getParameters().put('CurrentObjectId',CurrentObjectId);
            pg.getParameters().put('CountPerFetch','100');
            pg.getParameters().put('dlgHeight','100');
            pg.getParameters().put('dlgWidth','100');
            pg.getParameters().put('FilterValues','["x","y"]');
                  
            Test.setCurrentPage(pg);
            GS1_CustomLookupPageCtrl controller = new GS1_CustomLookupPageCtrl();
            controller.getFieldOptions();
            controller.getHTML();
            controller.getLetterButtonsHTML();
            controller.queryByLetter();
            controller.queryBySearchKey();
            controller.nextPage();
            controller.previousPage();
            controller.refresh();
            controller.resetSearch();
            
        }
        Test.stopTest();
    }
    
    static testMethod void test2() {
        Test.startTest();           
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            Pagereference pg = Page.GS1_CustomLookupPage;
            
            GS1_TestHelper.createRequest(200, GS1_TestHelper.REQUEST_PALLET);
            
            //GS1_LookupDefinitions__c[] lus = [select id from GS1_LookupDefinitions__c];
            //delete lus;
            /*GS1_LookupDefinitions__c  ludef = new GS1_LookupDefinitions__c();
            ludef.Active__c = true;
            ludef.Name = 'GS1_Request__c';
            luDef.Display_Fields__c = 'Name,Id';
            luDef.Fixed_Filter_Expression__c = 'Name!=null';
            ludef.Variable_Filter_Expression__c = 'Name!=null';
            insert ludef;*/
            
            String CurrentObjectId = GS1_CommonFunctions.getObjectPrefix('GS1_Country__c');         
              
            pg.getParameters().put('ObjectPrefix','StandardUserLookup');
            pg.getParameters().put('CurrentObjectId',CurrentObjectId);
            pg.getParameters().put('CountPerFetch','100');
            pg.getParameters().put('dlgHeight','100');
            pg.getParameters().put('dlgWidth','100');
            pg.getParameters().put('FilterValues','["x","y"]');
                  
            Test.setCurrentPage(pg);
            GS1_CustomLookupPageCtrl controller = new GS1_CustomLookupPageCtrl();
            controller.getFieldOptions();
            controller.getHTML();
            controller.getLetterButtonsHTML();
            controller.queryByLetter();
            controller.queryBySearchKey();
            controller.nextPage();
            controller.previousPage();
            controller.refresh();
            controller.resetSearch();
            
        }
        Test.stopTest();
    }    
    
    static testMethod void test3() {
        Test.startTest();          
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){           
            Pagereference pg = Page.GS1_CustomLookupPage;
            
            GS1_TestHelper.createRequest(200, GS1_TestHelper.REQUEST_PALLET);
            
            //GS1_LookupDefinitions__c[] lus = [select id from GS1_LookupDefinitions__c];
            //delete lus;
            GS1_LookupDefinitions__c  ludef = new GS1_LookupDefinitions__c();
            ludef.Active__c = false;
            ludef.Name = 'GS1_Request__c';
            luDef.Display_Fields__c = 'Name,Id';
            luDef.Fixed_Filter_Expression__c = 'Name!=null';
            ludef.Variable_Filter_Expression__c = 'Name!=null';
            insert ludef;
            
            String CurrentObjectId = GS1_CommonFunctions.getObjectPrefix('GS1_Country__c');         
              
            pg.getParameters().put('ObjectPrefix',GS1_CommonFunctions.getObjectPrefix('GS1_Request__c'));
            pg.getParameters().put('CurrentObjectId',CurrentObjectId);
            pg.getParameters().put('CountPerFetch','100');
            pg.getParameters().put('dlgHeight','100');
            pg.getParameters().put('dlgWidth','100');
            pg.getParameters().put('FilterValues','["x","y"]');
                  
            Test.setCurrentPage(pg);
            GS1_CustomLookupPageCtrl controller = new GS1_CustomLookupPageCtrl();
            controller.getFieldOptions();
            controller.getHTML();
            controller.getLetterButtonsHTML();
            controller.queryByLetter();
            controller.queryBySearchKey();
            controller.nextPage();
            controller.previousPage();
            controller.refresh();
            controller.resetSearch();
        }

        Test.stopTest();
    }    
    
    static testMethod void test4() {
        Test.startTest();           
            Pagereference pg = Page.GS1_CustomLookupPage;
            
            //GS1_TestHelper.createRequest(200, GS1_TestHelper.REQUEST_PALLET);
            
            //GS1_LookupDefinitions__c[] lus = [select id from GS1_LookupDefinitions__c];
            //delete lus;
            GS1_LookupDefinitions__c  ludef = new GS1_LookupDefinitions__c();
            ludef.Active__c = true;
            ludef.Name = 'GS1_Request__c';
            luDef.Display_Fields__c = 'Name,Id';
            luDef.Fixed_Filter_Expression__c = 'Name!=null';
            ludef.Variable_Filter_Expression__c = 'Name!=null';
            insert ludef;
            
            String CurrentObjectId = GS1_CommonFunctions.getObjectPrefix('GS1_Country__c');         
              
            pg.getParameters().put('ObjectPrefix',GS1_CommonFunctions.getObjectPrefix('GS1_Request__c'));
            pg.getParameters().put('CurrentObjectId',CurrentObjectId);
            pg.getParameters().put('CountPerFetch','100');
            pg.getParameters().put('dlgHeight','100');
            pg.getParameters().put('dlgWidth','100');
            pg.getParameters().put('FilterValues','["x","y"]');
                  
            Test.setCurrentPage(pg);
            GS1_CustomLookupPageCtrl controller = new GS1_CustomLookupPageCtrl();
            controller.getFieldOptions();
            controller.getHTML();
            controller.getLetterButtonsHTML();
            controller.queryByLetter();
            controller.queryBySearchKey();
            controller.nextPage();
            controller.previousPage();
            controller.refresh();
            controller.resetSearch();
            

        Test.stopTest();
    }    
}