/**
 * Test class fot CRS_RolesViewController class
 */
@isTest
public with sharing class CRS_TestRolesViewController {
	
	testMethod static void testCreationRolesViewController() {
		
		PageReference pageRef = Page.CRS_RolesView;
		Test.setCurrentPage(pageRef);
		User u = CRS_TestHelper.createSysAdmin();
		
		CRS_RolesViewController controller = new CRS_RolesViewController(new ApexPages.StandardController(u));
		CRS_Role__c[] roles = controller.roleList;
		System.assert(!roles.isEmpty(), 'List of role is empty');
	}
}