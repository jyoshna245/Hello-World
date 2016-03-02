@isTest
private class GS1_TestRequestCSVReport {

    static testMethod void test1() {
        Test.startTest();
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){          
            GS1_RequestCSVReport clas = new GS1_RequestCSVReport();
            
            GS1_EAN__c ean = GS1_TestHelper.createBarcodes(true, true, 1122331, 1122331)[0];
            GS1_Request__c[] reqs = GS1_TestHelper.createRequest(10, GS1_TestHelper.REQUEST_CUDU);
            GS1_Country__c ctry = GS1_TestHelper.createCountry(1)[0];
            ctry.Name = 'BELGIUM';
            update ctry;
            
            for(GS1_Request__c req : reqs) {
                req.Country__c = ctry.id;
                req.EAN_Code__c = ean.Id;
            }
            
            update reqs;
            
            clas.execute(null);
        }    
        Test.stopTest();
    }
}