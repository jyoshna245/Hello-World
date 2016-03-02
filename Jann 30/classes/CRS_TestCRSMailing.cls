/**
 * Test for CRS_Mailing
 */
@isTest
public with sharing class CRS_TestCRSMailing {
	
	private final static string TEST_EMAIL_TEMPLATE_NAME = 'test_Template_For_CRS_TestCRS_Mailing';

	static testMethod void testFindEmailTemplateIDByDeveloperName() {

		EmailTemplate testTemplate = new EmailTemplate();
		Folder folder = [SELECT id FROM Folder WHERE DeveloperName = 'CRS_Email_Templates'];

		testTemplate.DeveloperName = TEST_EMAIL_TEMPLATE_NAME;
		testTemplate.IsActive = true;
		testTemplate.Name = 'testName';
		testTemplate.FolderId = folder.Id;
		testTemplate.TemplateType = 'text';
		insert testTemplate;

		ID testTemplateId = CRS_Mailing.FindEmailTemplateIDByDeveloperName(TEST_EMAIL_TEMPLATE_NAME);
		System.assert(testTemplateId == testTemplate.Id, testTemplateId + ' != ' + testTemplate.Id);

	}
	
	static testMethod void testGetContactsForGroupNames() {
		Test.startTest();

		User user = CRS_TestHelper.createSysAdmin();

		CRS__c crs = CRS_TestHelper.prepareInProcessCRS();
		crs.Internal_Status__c = CRS_Mailing.APPROVAL_STEP_BULEGAL;
		crs.CRS_BU_Legal_Approver__c = user.Id;
		update crs;
		
		List<String> names = new List<String>();
		names.add('CAR_Corporate_Food_Law_Approver');
		
		List<Contact> contacts = CRS_Mailing.testGetContactsForGroupNames(names, crs, CRS_Mailing.Corporate_Level_Attention);

		//System.assert(!contacts.isEmpty(), 'List of Contacts is empty');
		
		Test.stopTest();
	}

	static testMethod void testGetContacts() {		
		Test.startTest();

		User user = CRS_TestHelper.createSysAdmin();

		CRS__c crs = CRS_TestHelper.prepareInProcessCRS();
		crs.Internal_Status__c = CRS_Mailing.APPROVAL_STEP_BULEGAL;
		crs.CRS_BU_Legal_Approver__c = user.Id;
		update crs;

		List<Contact> contacts = CRS_Mailing.testGetContacts(crs);

		System.assert(!contacts.isEmpty(), 'List of Contacts is empty');

		Test.stopTest();
	}

}