@isTest(seeAllData=true)
public with sharing class CRS_TestHistoryComponentController {
	static testmethod void testCOMHistory(){
        	test.startTest();
            for(CRS__c crs : [select id 
                            from CRS__c where id in (select parentId from CRS__History) limit 1]){
					            crs.Status__c = 'Draft';
					            update crs;
					            CRS_HistoryComponentController obj = new CRS_HistoryComponentController();
					            CRS_HistoryComponentController.strObjectId = crs.id;
					            obj.myObject = crs;
					            obj.getObjectHistory();
					            CRS_HistoryComponentController.strObjectId = null;
					            obj.getObjectHistory();
					            
					            CRS_HistoryComponentController obj1 = new CRS_HistoryComponentController();
					            CRS_HistoryComponentController.strObjectId = crs.id;
					            obj1.myObject = crs;
					            obj1.getObjectHistory();

                            }
            test.stopTest();
    }
}