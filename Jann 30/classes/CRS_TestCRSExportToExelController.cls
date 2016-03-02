@isTest
public with sharing class CRS_TestCRSExportToExelController {

	static testMethod void testGetBaseLink() {

		ApexPages.StandardSetController standardController = new ApexPages.StandardSetController(new List<CRS__c>());
		CRS_ExportToExelController controller = new CRS_ExportToExelController(standardController);
		String url = controller.getBaseLink();
		System.assert(url != null, url + ' == null');
	}
}