@isTest
private class CRS_TestSelectApproversController {

    static testMethod void testController() {
        CRS_SelectApproversController controller = new CRS_SelectApproversController();
        // Test empty names.
        controller.fieldValue = '';
        String namesResult = controller.getUserNames();
        System.assert(namesResult == '', 'Result should be an empty string, but actually it is \'' + namesResult + '\'');
    }
}