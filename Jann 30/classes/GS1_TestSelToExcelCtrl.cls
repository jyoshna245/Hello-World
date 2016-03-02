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
private class GS1_TestSelToExcelCtrl {

    static testMethod void myUnitTest() {
        Test.startTest();        
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){             
            String[] ids = new list<String>();
            GS1_Request__c[] reqs = GS1_TestHelper.createRequest(10, GS1_TestHelper.REQUEST_CUDU);
            for (GS1_Request__c r : reqs) {
                ids.add(string.valueOf(r.id));
            }
            
            Pagereference pg = Page.GS1_SelToExcel;    
              
            pg.getParameters().put('sf','name');      
            pg.getParameters().put('so','descending');
            pg.getParameters().put('ids', string.join(ids,','));
            Test.setCurrentPage(pg);
            GS1_SelToExcelCtrl controller = new GS1_SelToExcelCtrl();
        }
        Test.stopTest();
    }
}