@isTest
private class CRS_TestCRSTrigger {
	/*
	* author: Ivan_Tsitulenka
	* class: CRS_CRSTrigger, CRS_CRSTriggerHandler
	* method: BeforeInsert, getNumberFromName
	*/
	private static CRS__c createCRS(String typeName, Id crsBUId){
		RecordType crsGvwRecordType = [Select Id, Name From RecordType where sObjectType='CRS__c' and name = :typeName][0];
		CRS__c testCrs = new CRS__c(Status__c = CRS_CRSEdit.CRS_Status_Draft, RecordType = crsGvwRecordType, RecordTypeId = crsGvwRecordType.Id, CRS_Business_Unit__c = crsBUId, CRS_Document_Title__c = 'testTitle');
		return testCrs;
	}

	private static Id prepareData(){
		CRS_Group__c crsGroup = new CRS_Group__c(Name = 'test1', Active__c = 'Yes');
		insert crsGroup;
		CRS_Business_Unit__c crsBU = new CRS_Business_Unit__c(Name = 'test2', Active__c = 'Yes', Group__c = crsGroup.Id);
		insert crsBU;
		return crsBU.Id;
	}

    static testMethod void testCreatedGvw() {
		Id crsbu = prepareData();
		CRS__c testCrs = createCRS('glaceau vitaminwater CRS', crsbu);
		System.debug('~+~'+testCRS.Name);
		insert testCrs;
		CRS__c testCrs2 = [select Name from CRS__c where Id = :testCrs.Id];
		System.debug('~~~'+testCRS2.Name);
		System.assert('ATLgvw007000' == testCrs2.Name);
		testCrs.Name = 'ATLgvw107001';
		update testCrs;
		testCrs = createCRS('glaceau vitaminwater CRS', crsbu);
		System.debug('~+~'+testCRS.Name);
		insert testCrs;
		testCrs2 = [select Name from CRS__c where Id = :testCrs.Id];
		System.debug('~~~'+testCRS2.Name);
		System.assert('ATLgvw107002' == testCrs2.Name);
    }
    
    static testMethod void testCreatedNoGvw() {
		Id crsbu = prepareData();
		CRS__c testCrs = createCRS('CRS submission', crsbu);
		insert testCrs;
		CRS__c testCrs2 = [select Name from CRS__c where Id = :testCrs.Id];
		System.assert('ATL010000' == testCrs2.Name);
		testCrs.Name = 'ATL123456';
		update testCrs;
		testCrs = createCRS('CRS submission', crsbu);
		insert testCrs;
		testCrs2 = [select Name from CRS__c where Id = :testCrs.Id];
		System.assert('ATL123457' == testCrs2.Name);
    }
    
    
    static testMethod void testAfterUpdate1(){
    	CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
		crs.Process_Flow__c = CRS_CRSReview.PROCESS_FLOW_NOTIFICATION;
		crs.Status__c = 'In Process';
		update crs;
		crs.Status__c = 'Under Review';
		update crs;
    }
    static testMethod void testAfterUpdate2(){
    	CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
		crs.Process_Flow__c = CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_NON_COKE;
		crs.Status__c = 'In Process';
		update crs;
		crs.Status__c = 'Under Review';
		update crs;
    }
    static testMethod void testAfterUpdate3(){
    	CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
		crs.Process_Flow__c = CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_COKE;
		crs.Status__c = 'In Process';
		update crs;
		crs.Status__c = 'Under Review';
		crs.Internal_Status__c = 'Field SRA Approver';
		update crs;
    }
    static testMethod void testAfterUpdate4(){
    	CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
		crs.Process_Flow__c = CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC;
		crs.Status__c = 'In Process';
		update crs;
		crs.Status__c = 'Under Review';
		update crs;
    } 
    static testMethod void testAfterUpdate5(){
    	CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
		crs.Process_Flow__c = CRS_CRSReview.PROCESS_FLOW_FULL_REVIEW_PAC_COKE;
		crs.Status__c = 'In Process';
		update crs;
		crs.Status__c = 'Under Review';
		update crs;
    }  
    static testMethod void testAfterUpdate6(){
    	CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
		crs.Process_Flow__c = CRS_CRSReview.PROCESS_FLOW_GVW_FULL_REVIEW;
		crs.Status__c = 'In Process';
		
		update crs;
		crs.Status__c = 'Under Review';
		update crs;
    }     
}