@isTest(seeAllData=false)
private class autoCompleteControllerNameTest
{

 private static testMethod void validateFindSObjects()
{

Test.startTest();
autoCompleteControllerName.findSObjects('Product2','select name from product2 group by name','name','System Administrator');
Test.stopTest();

}
}