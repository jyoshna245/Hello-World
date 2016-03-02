/**
 * Test class fot CRS_RolesEditController class
 */
@isTest
public with sharing class CRS_TestRolesEditController {

    private static final Integer FIRST_OPTION = 0;
    
    private static List<CRS_Role__c> getRoles(Id userId) {
        return [SELECT id,
                       Name
               FROM CRS_Role__c
               WHERE User__c = :userId];
    }

    private static CRS_RolesEditController prepareRolesEditController(String userId) {

        PageReference pageRef = Page.CRS_RolesEdit;
        pageRef.getParameters().put('userId', userId);

        Test.setCurrentPage(pageRef);
    
        return new CRS_RolesEditController();
    }

    testMethod static void testDoSave() {

        CRS_Group__c testGoup = CRS_TestHelper.createGroup('testRoleEditGoup');
        CRS_Business_Unit__c testBU = CRS_TestHelper.prepareBU('testRoleEditBU', testGoup.Id);
        User user = CRS_TestHelper.createSysAdmin();
        CRS_Role__c role = CRS_TestHelper.createRole(user.Id, testBU.Id);

        CRS_RolesEditController testController = prepareRolesEditController(user.Id);
        
        List<CRS_Role__c> roles = getRoles(user.Id);
        Integer roleSize = roles.size();
        
        testController.activeRolesMap.put(testBU.Id, false);
        testController.doSave();
        
        System.assert(getRoles(user.Id).size() == (roleSize - 1), roles.size());

    }
    
    testMethod static void testDoCancel() {

        User user = CRS_TestHelper.createSysAdmin();
        CRS_RolesEditController testController = prepareRolesEditController(user.Id);

        testController.doCancel();
        System.assert(testController.doCancel().getUrl() == '/' + user.Id + '?noredirect=1', TestController.doCancel().getUrl());
    }
    
    testMethod static void testGetItems() {

        CRS_Group__c testGoup = CRS_TestHelper.createGroup('testRoleEditGoup');
        CRS_Business_Unit__c testBU = CRS_TestHelper.prepareBU('testRoleEditBU', testGoup.Id);
        User user = CRS_TestHelper.createSysAdmin();
        CRS_Role__c role = CRS_TestHelper.createRole(user.Id, testBU.Id);

        CRS_RolesEditController testController = prepareRolesEditController(user.Id);
        List<SelectOption> optionList = testController.getItems();
        
        SelectOption option = null;
        
        for (SelectOption op: optionList) {
            if (op.getValue() == testBU.id) {
                option = op;
            }
        }

        System.assert(option != null);
        System.assert(option.getLabel() == testBU.Name, '' + option.getLabel() + ' != ' + testBU.Name);
    }
    
    testMethod static void testDoChange() {
        
        CRS_Group__c testGoup1 = CRS_TestHelper.createGroup('testRoleEditGoup1');
        CRS_Business_Unit__c testBU1 = CRS_TestHelper.prepareBU('testRoleEditBU1', testGoup1.Id);
        CRS_Group__c testGoup2 = CRS_TestHelper.createGroup('testRoleEditGoup2');
        CRS_Business_Unit__c testBU2 = CRS_TestHelper.prepareBU('testRoleEditBU2', testGoup2.Id);
        User user = CRS_TestHelper.createSysAdmin();
        CRS_Role__c role1 = CRS_TestHelper.createRole(user.Id, testBU1.Id);
        CRS_Role__c role2 = CRS_TestHelper.createRole(user.Id, testBU2.Id);
        CRS_RolesEditController testController = prepareRolesEditController(user.Id);
        
        
        testController.currentRole = role1;
        testController.currentRoleId = testBU2.Id;
        testController.doChange();
        System.assert(testController.currentRole.Id == role2.Id, '' + testController.currentRole.Id + ' != ' +role2.Id);

    }
}