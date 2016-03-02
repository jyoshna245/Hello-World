/**
* Author,email :     Madel Pascua , mpascua@coca-cola.com
* Date Create  :     September 26, 2013
* Description  :     Test method for GS1_EAN_CodeGenCtrl
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

@isTest //(SeeAllData=true)
private class GS1_TestEAN_CodeGenCtrl{ 
	
    static testMethod void test1(){
        Test.startTest();    
            Pagereference pg = Page.GS1_EANGeneratorPage;
            Test.setCurrentPage(pg); 
            GS1_EAN__c ean = new GS1_EAN__c();
            ean.Property_2__c = 'CU/DU';
            ean.Property_3__c = 'Normal';
            ApexPages.StandardController sc = new ApexPages.StandardController(ean);
            GS1_EAN_CodeGenCtrl controller = new GS1_EAN_CodeGenCtrl(sc);
            GS1_EAN_CodeGenCtrl con = new GS1_EAN_CodeGenCtrl();
            
            controller.startNum = 1000001;
            controller.endNum = 1000010;            
            controller.generateEANCodes();
            controller.getEANCodes();
            controller.startOver();            
            
            controller.startNum = long.valueOf('100000100001');
            controller.endNum =   long.valueOf('100000100010');            
            controller.generateEANCodes();
            controller.getEANCodes();
            controller.startOver();            
            
            //duplicate check: many
            controller.startNum = 1000001;
            controller.endNum = 1000010;            
            controller.generateEANCodes();
            controller.getEANCodes();
            controller.startOver(); 
            
            
		Test.StopTest();
    }	
    
    static testMethod void test2(){
        Test.startTest();    
            Pagereference pg = Page.GS1_EANGeneratorPage;
            Test.setCurrentPage(pg); 
            GS1_EAN__c ean = new GS1_EAN__c();
            ean.Property_2__c = 'CU/DU';
            ean.Property_3__c = 'Normal';
            ApexPages.StandardController sc = new ApexPages.StandardController(ean);
            GS1_EAN_CodeGenCtrl controller = new GS1_EAN_CodeGenCtrl(sc);
            GS1_EAN_CodeGenCtrl con = new GS1_EAN_CodeGenCtrl();
            
            controller.startNum = 2000001;
            controller.endNum = 2000010;            
            controller.generateEANCodes();
            controller.getEANCodes();
            controller.startOver();            
            
            //duplicate check: one
            controller.startNum = 2000010;
            controller.endNum = 2000010;            
            controller.generateEANCodes();
            controller.getEANCodes();
            controller.startOver();                   
            
		Test.StopTest();
    }	    
	
    static testMethod void test3(){
        Test.startTest();    
            Pagereference pg = Page.GS1_EANGeneratorPage;
            Test.setCurrentPage(pg); 
            GS1_EAN__c ean = new GS1_EAN__c();
            ean.Property_2__c = 'CU/DU';
            ean.Property_3__c = 'Normal';
            ApexPages.StandardController sc = new ApexPages.StandardController(ean);
            GS1_EAN_CodeGenCtrl controller = new GS1_EAN_CodeGenCtrl(sc);
            GS1_EAN_CodeGenCtrl con = new GS1_EAN_CodeGenCtrl();
            
            //too much
            controller.startNum = (1000001);
            controller.endNum =   (8000001);            
            controller.generateEANCodes();
            controller.startOver();
            
            //not equal number of digits
            controller.startNum = long.valueOf('10000010001');
            controller.endNum =   long.valueOf('100000100010');            
            controller.generateEANCodes();
            controller.startOver();            
               
            controller.startNum = long.valueOf('100000100010');
            controller.endNum =   long.valueOf('10000010001');            
            controller.generateEANCodes();
            controller.startOver();            
            
            controller.startNum = long.valueOf('10000010001');
            controller.endNum =   long.valueOf('10000010001');            
            controller.generateEANCodes();
            controller.startOver();            
            
            //higher range start
            controller.startNum = long.valueOf('100000100010');
            controller.endNum =   long.valueOf('100000100001');            
            controller.generateEANCodes();
            controller.startOver();            
            
            controller.goBack();


      Test.stopTest();    
    }
    
    static testMethod void testComputeDigit(){
        Test.startTest();    
            Pagereference pg = Page.GS1_EANCCDigitPage;
            Test.setCurrentPage(pg); 
            ApexPages.StandardController sc = new ApexPages.StandardController(new GS1_EAN__c());
            GS1_EAN_CodeGenCtrl controller = new GS1_EAN_CodeGenCtrl(sc);
            GS1_EAN_CodeGenCtrl con = new GS1_EAN_CodeGenCtrl();           
            
            controller.startNum = long.valueOf('100000100010');
            controller.computeCheckDigit();            
            
            controller.startNum = 1000001;
            controller.computeCheckDigit();               
            
            controller.startNum = 7;
            controller.computeCheckDigit();            
      

      Test.stopTest();    
    }              
}