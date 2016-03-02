@isTest
public with sharing class CRS_TestApprovalHistoryController {
	 static testMethod void Test1() {
        CRS__c crs = CRS_TestHelper.prepareDraftCRS();
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submit request ');
        req1.setObjectId(crs.Id);
        req1.setNextApproverIds(new Id[] {userInfo.getUserID()});
        Approval.ProcessResult result = Approval.process(req1);
        
        PageReference pageRef = Page.CRS_ApprovalHistory;
		Test.setCurrentPage(pageRef);
		ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(crs);
		ApexPages.currentPage().getParameters().put('Id',crs.id);
        CRS_ApprovalHistoryController obj = new CRS_ApprovalHistoryController(sc);
        
    	
        obj.recordId = crs.Id;
        obj.approveRj();
        obj.goto();
        obj.Recall();
        obj.getResults();
        obj.getApprovalProcesslist();
    }
	
}