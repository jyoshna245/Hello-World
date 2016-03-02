/**
* Author,email :     Madel Pascua , mpascua@coca-cola.com
* Date Create  :     September 20, 2013
* Description  :     Test method for GS1_SendBackCtrl
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

@isTest //(SeeAllData=true)
private class GS1_TestSendBackCtrl{
    
    static testMethod void successfulSendBackOfOneGS1Request() {
       	User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){       	
        Test.startTest();    
            GS1_Request__c  gs1Test = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU)[0];
            gs1Test.status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;    
            update gs1Test;
            
            Pagereference pg = Page.GS1_SendBack;
            Test.setCurrentPage(pg);   
            ApexPages.currentPage().getParameters().put('ids', String.valueOf(gs1Test.Id)); 
                            
            GS1_SendBackCtrl controller = new GS1_SendBackCtrl();       
            controller.sendBackGS1Requests();       
        
        Test.stopTest(); 
        }   
     }       
     
     static testMethod void successfulSendBackOfMultipleGS1Request() {
       	User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){        	
        Test.startTest();    
            List<GS1_Request__c>  gs1ListTest = GS1_TestHelper.createRequest(2, GS1_TestHelper.REQUEST_CUDU);
            for (GS1_Request__c req : gs1ListTest) {
            	req.status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            }    
                        
            update gs1ListTest;
            
            Pagereference pg = Page.GS1_SendBack;
            Test.setCurrentPage(pg);   
            ApexPages.currentPage().getParameters().put('ids', String.valueOf(gs1ListTest[0].Id)+','+String.valueOf(gs1ListTest[1].Id)); 
                            
            GS1_SendBackCtrl controller = new GS1_SendBackCtrl();       
            controller.sendBackGS1Requests();       
        
        Test.stopTest();    
        }
     } 
   
}