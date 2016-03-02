/***********************************************************************
Class Name      : DealDatabaseMonthlyReport_Test
Created By      : Kirti Agarwal
Created Date    : 13th Jan, 2014
Purpose         : Test class for DealDatabaseMonthlyReport class
************************************************************************/
@isTest
private class DealDatabaseMonthlyReport_Test {

   static testmethod void  DealDatabaseMonthlyReport_Test(){

     Deal__c dealRec = createDealRec('test deal', 'Group1', 'Type1', 'Active', true);
     Deal__c dealRec1 = createDealRec('test deal', 'Group2', 'Type1', 'Active', true);
     Deal__c dealRec2 = createDealRec('test deal', 'Group1', 'Type2', 'Active', true);
     Deal__c dealRec3 = createDealRec('test deal', 'Group2', 'Type2', 'Active', true);
     Deal__c dealRec4 = createDealRec('test deal', 'Group1', 'Type2', 'Closed', true);
     Deal__c dealRec5 = createDealRec('test deal1', 'Group1', 'Type1', 'Active', true);

   	 Test.startTest();
   	   DealDatabaseMonthlyReport objDealDatabaseMonthlyReport = new DealDatabaseMonthlyReport();
   	   system.assert(objDealDatabaseMonthlyReport.listOfGroup.size() > 1);
   	   system.assert(objDealDatabaseMonthlyReport.listOfClosedProject.size() > 0);
   	   system.assert(objDealDatabaseMonthlyReport.mapOfGroupAndType.size() > 0);
   	   system.assert(objDealDatabaseMonthlyReport.mapOfDeal.size() > 0);
   	 Test.stopTest();
   }

   static Deal__c createDealRec(String name, string grp, string typeOfDeal, String status, boolean isInsert){
   	Deal__c deal = new Deal__c();
   	deal.Deal_Status__c = status;
   	deal.Name = name;
   	deal.Target__c = 'test target';
   	deal.Current_Status_Date__c = Date.today().addDays(-2);
   	deal.Close_Date__c = Date.today();
   	deal.Group__c = grp;
   	deal.Type_of_Deal__c = typeOfDeal;
   	deal.RecordTypeId = getRecordTypeId('Transactions', 'Deal__c');
   	if(isInsert){
   	  insert deal;
   	}
   	return deal;
   }

    /**
    * This method is used to create the recordtype id
    */
    public static Id getRecordTypeId(String recordType, String objectType) {
        Map<String,Schema.RecordTypeInfo> rtMapByName = null;
        if(rtMapByName == null) {
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
      Schema.SObjectType ctype = gd.get(objectType);
        Schema.DescribeSObjectResult d1 = ctype.getDescribe();
        rtMapByName = d1.getRecordTypeInfosByName();
      }
      Schema.RecordTypeInfo recordTypeDetail = rtMapByName.get(recordType);
      if(recordTypeDetail != null) {
        return recordTypeDetail.getRecordTypeId();
      } else {
        return null;
      }
    }


}