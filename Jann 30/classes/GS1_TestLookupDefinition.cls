/**
* Author,email :     Madel Pascua , mpascua@coca-cola.com
* Date Create  :     September 24, 2013
* Description  :     Test method for GS1_RequestAttribute
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

@isTest //(SeeAllData=true)
private class GS1_TestLookupDefinition {

    static testMethod void myUnitTest() {
        Test.startTest();
        
        List<String> filterValues = new List<String>();        
        filterValues.add('x');
        filterValues.add('y');        
        
        GS1_LookupDefinition lu = new GS1_LookupDefinition('User','UserName,Profile.Name,alias,alias1');
        lu.getFieldLabel('Username');        
                
        lu.setVarFilter('test', filterValues);        
        lu.getFilterExpression();
        
        lu.setFixedFilterExpression('IsActive=true');
        lu.getFilterExpression();
        lu.getListFields();
        lu.getObjectName();
        lu.getSelectExpression();
        lu.hasField('Username');
        lu.hasField('Username1');
        Test.stopTest();
    }
}