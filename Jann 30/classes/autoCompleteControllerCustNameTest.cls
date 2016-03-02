@isTest(seeAllData=false)
private class autoCompleteControllerCustNameTest
{

 private static testMethod void validateFindSObjects()
{

Test.startTest();
autoCompleteControllerCustName.findSObjects('Product2','select Customer_Name__c from product2 group by Customer_Name__c','Customer_Name__c','System Administrator');
Test.stopTest();
}
}