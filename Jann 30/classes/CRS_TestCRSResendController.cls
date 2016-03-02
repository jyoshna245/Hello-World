/*
	Test for CRS_CRSResendController.
*/
@isTest
public with sharing class CRS_TestCRSResendController {
	
	private static String CRS_ID_KEY = 'idCRS';
	
	testMethod static void testDoSendMessage() {

		CRS__c crs = new CRS__c();
		insert crs;
		
		PageReference pageRef = Page.CRS_CRSResendMessage;
		pageRef.getParameters().put(CRS_ID_KEY, crs.Id);
		Test.setCurrentPage(pageRef);
		
		CRS_Message__c message = new CRS_Message__c();
		insert message;
		
		CRS_CRSResendController controller = new CRS_CRSResendController(new ApexPages.StandardController(message));
		PageReference resultRef = controller.sendMessage();
		
		System.assert(resultRef.getUrl() == '/' + crs.Id, resultRef.getUrl() + ' != ' + crs.Id);
	}
}