@isTest
public with sharing class CRS_TestCRSReminder {
        
    static testmethod void testCRSReminderMethod()
    {
       
       CRS__c crs = CRS_TestHelper.prepareDraftCRS();
       crs.CRS_Corp_SRA_Approver__c = 'test user1;test user2';
       crs.CRS_Corp_Formula_Governance__c = 'test user1;test user2';
       update crs;
       ApexPages.StandardController sc = new ApexPages.standardController(crs);
       CRS_Reminder controller = new CRS_Reminder(sc); 
    }
      
 
}