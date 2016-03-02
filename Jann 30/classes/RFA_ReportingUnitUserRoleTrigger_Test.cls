/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class RFA_ReportingUnitUserRoleTrigger_Test {

    static testMethod void TestReportingUnitUserRoleInsert() {
        RFATestData testData = new RFATestData();
        
        // build Reporting Unit and insert Reporting Unit User Role
        testData.buildReportingUnit();
        
        // Retreive Reporting Unit with list of Reporting Unit User Role child records
        ReportingUnit__c testReportingUnit = [SELECT (Select Id, IsDeleted, Name, ReportingUnit__c, User__c From ReportingUnitUserRoles__r), NeedRecalculation__c From ReportingUnit__c WHERE id = :RFATestData.testReportingUnit.id];
        
        System.assert(testReportingUnit.ReportingUnitUserRoles__r.size() > 0, 'Failed to Insert Reporting Unit User Role');
        System.assert(testReportingUnit.NeedRecalculation__c, 'System failed to flag ReportingUnit__c.NeedRecalculation__c field flag');
    }
    
    static testMethod void TestReportingUnitUserRoleUpdate() {
        RFATestData testData = new RFATestData();
        
        // build Reporting Unit and insert Reporting Unit User Role
        testData.buildReportingUnit();
        
        // Retreive Reporting Unit with list of Reporting Unit User Role child records
        ReportingUnit__c testReportingUnit = [SELECT (Select Id, IsDeleted, Name, ReportingUnit__c, User__c From ReportingUnitUserRoles__r), NeedRecalculation__c From ReportingUnit__c WHERE id = :RFATestData.testReportingUnit.id];
        
        System.assert(testReportingUnit.ReportingUnitUserRoles__r.size() > 0, 'Failed to Insert Reporting Unit User Role');

        //reset NeedRecalculation Flag
        testReportingUnit.NeedRecalculation__c = false;
        update testReportingUnit;
        
        System.assert(testReportingUnit.NeedRecalculation__c == false, 'Test Method failed to set ReportingUnit__c.NeedRecalculation__c field flag to false');
        
        // create new user
        User reportingUnitUser2 = new User();
    	reportingUnitUser2 = testData.createUser(RFATestData.rfaStandardUserProfile, 'reUser2', 'rlast2', reportingUnitUser2);
        
        // update existing Reporting Unit User
        List <ReportingUnitUserRole__c> testReportingUnitUsers = testReportingUnit.ReportingUnitUserRoles__r;
        if (testReportingUnitUsers.size() > 0)
        {
        	ReportingUnitUserRole__c testReportingUnitUser = testReportingUnitUsers[0];
        	testReportingUnitUser.User__c = reportingUnitUser2.id;
        	update testReportingUnitUser;
        }
        
        // check need recalculation flag
        testReportingUnit = [SELECT (Select Id, IsDeleted, Name, ReportingUnit__c, User__c From ReportingUnitUserRoles__r), NeedRecalculation__c From ReportingUnit__c WHERE id = :RFATestData.testReportingUnit.id];
        System.assert(testReportingUnit.NeedRecalculation__c == true, 'System Failed to set ReportingUnit__c.NeedRecalculation__c field flag to true');
    }
    
    static testMethod void TestReportingUnitUserRoleDelete() {
        RFATestData testData = new RFATestData();
        
        // build Reporting Unit and insert Reporting Unit User Role
        testData.buildReportingUnit();
        
        // Retreive Reporting Unit with list of Reporting Unit User Role child records
        ReportingUnit__c testReportingUnit = [SELECT (Select Id, IsDeleted, Name, ReportingUnit__c, User__c From ReportingUnitUserRoles__r), NeedRecalculation__c From ReportingUnit__c WHERE id = :RFATestData.testReportingUnit.id];
        
        System.assert(testReportingUnit.ReportingUnitUserRoles__r.size() > 0, 'Failed to Insert Reporting Unit User Role');

        //reset NeedRecalculation Flag
        testReportingUnit.NeedRecalculation__c = false;
        update testReportingUnit;
        
        System.assert(testReportingUnit.NeedRecalculation__c == false, 'Test Method failed to set ReportingUnit__c.NeedRecalculation__c field flag to false');
        
        // Delete Reporting Unit user
        User reportingUnitUser2 = new User();
    	reportingUnitUser2 = testData.createUser(RFATestData.rfaStandardUserProfile, 'reUser2', 'rlast2', reportingUnitUser2);
        
        // delete existing Reporting Unit User
        List <ReportingUnitUserRole__c> testReportingUnitUsers = testReportingUnit.ReportingUnitUserRoles__r;
        integer ReportingUnitUsersSize = testReportingUnitUsers.size();
        
        if (testReportingUnitUsers.size() > 0)
        {
        	delete testReportingUnitUsers[0];
        }
        
        // check need recalculation flag and reporting unit user role was deleted successfully
        testReportingUnit = [SELECT (Select Id, IsDeleted, Name, ReportingUnit__c, User__c From ReportingUnitUserRoles__r), NeedRecalculation__c From ReportingUnit__c WHERE id = :RFATestData.testReportingUnit.id];
        System.assertEquals(testReportingUnit.ReportingUnitUserRoles__r.size(), (ReportingUnitUsersSize-1), 'Test Method failed to delete a Reporting Unit User Role');
        System.assert(testReportingUnit.NeedRecalculation__c, 'System Failed to set ReportingUnit__c.NeedRecalculation__c field flag to true');
        
    }
}