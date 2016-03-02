@isTest(seeAllData=false)
private class autoCompleteControllerPropertyTest
{

 private static testMethod void validateFindSObjects()
{

Test.startTest();
autoCompleteControllerProperty.findSObjects('Product2','select Property__c from product2 group by name','Property__c','System Administrator');
Test.stopTest();

}
}