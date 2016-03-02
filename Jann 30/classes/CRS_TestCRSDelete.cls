/*
    * author: Soika_Andrei
    * class: CRS_CRSDelete
    * method: deleteCRS
    */

@isTest
private class CRS_TestCRSDelete {

    static testMethod void myUnitTest() {
      Profile saProfile = [SELECT Id FROM Profile WHERE Name= :CRS_CRSEdit.getSAProfileName()];
      
      User systemAdmin = new User(Alias = 'sadmin', Email='sysadmin@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = saProfile.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin1@testorg.com');

      Profile p = [SELECT Id FROM Profile WHERE Name='CRS (crs only) Standard User']; 
      
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='haahhaah@rambler.ru');
      
      User u2 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='haahhaah1@rambler.ru');
      User u3 = [SELECT Id FROM User WHERE Id=:Userinfo.getUserId()];
      
      //Delete by user self
      System.debug('#$% Test 1 ');
      test(u,u,null,true);
      
      System.runAs(u){CRS_TestHelper.prepareUnderReviewCRS();}
      List<CRS__c> crs = [select Id, Name, MTR_Day_Count__c, Status__c from CRS__c limit 1];
      //User can not delete own CRS in "Under Review" Status
      System.debug('#$% Test 2 ');
      test(u,u,crs[0],false);
     
      //Other user can not delete CRS of the user
      System.debug('#$% Test 3 ');
      test(u,u2,null,false);
      
      //System Admin can delete any CRS
      System.debug('#$% Test 4 ');
      test(u,systemAdmin,null,true);
    }
    
    //User u - creator of crs record
    //User u2 - deleter of crs record
    //CRS__c crs - if you want pass other crs record
    //Boolean result - expected result of test
    static private void test(User u, User u2, CRS__c crs, Boolean result){
      System.runAs(u) {
        CRS__c  testCrs = crs;
        if (testCrs==null) {
            RecordType crsGvwRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c' and name = :CRS_TestHelper.CRS_RECORD_TYPE][0];
            testCrs = new CRS__c(Status__c = CRS_TestHelper.CRS_STATUS_DRAFT, RecordType = crsGvwRecordType, RecordTypeId = crsGvwRecordType.Id);
            testCrs.Initiated_By__c = u.Id;
            testCrs.OwnerId = u.Id;
            insert testCrs;
        }
        insert (new CRS_Review__c(CRS_Tracking__c = testCrs.Id));
        List<CRS__c> rCrs1 = [SELECT Id FROM CRS__c WHERE Id=:testCrs.Id];
        System.debug('#~#~#~1 '+rCrs1);
        System.runAs(u2){
            //ApexPages.currentPage().getParameters().put('delId', testCrs.Id);
            CRS_CRSDelete testCrsDelete = new CRS_CRSDelete(new ApexPages.StandardController(testCrs));
            System.debug('%%@@%% '+u+' -- '+u2+' === '+testCrs);
            testCrsDelete.deleteCRS();
        }
        List<CRS__c> rCrs = [SELECT Id FROM CRS__c WHERE Id=:testCrs.Id];
        System.debug('#~#~#~2 '+rCrs);
        System.assert(rCrs.isEmpty()==result);
      }
    }
}