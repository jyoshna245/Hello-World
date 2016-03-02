/**
 * author: Ivan Tsitulenka
 * classes: CRS_UserTrigger, CRS_UserTriggerHandler
 *
 */
@isTest
private class CRS_TestUserTrigger {
    private static User testU;
    
    private static void createCustomSetting(){
        List<CRS_PublicGroupMapping__c> settingList = new List<CRS_PublicGroupMapping__c>{
            new CRS_PublicGroupMapping__c(Name = 'crs_bu_legal_approver__c', Groups_Name__c = 'CAR_BU_Legal_Approver'),
            new CRS_PublicGroupMapping__c(Name = 'crs_corporate_food_law_approver__c', Groups_Name__c = 'CAR_Corporate_Food_Law_Approver'),
            new CRS_PublicGroupMapping__c(Name = 'crs_corporate_formula_governance__c', Groups_Name__c = 'CAR_Corporate_Formula_Governance'),
            new CRS_PublicGroupMapping__c(Name = 'crs_corporate_sra_approver__c', Groups_Name__c = 'CAR_Corporate_SRA_Approver'),
            new CRS_PublicGroupMapping__c(Name = 'crs_field_sra_approver__c', Groups_Name__c = 'CAR_Field_SRA_Approver'),
        
            new CRS_PublicGroupMapping__c(Name = 'gvwcrs_bu_legal_approver__c', Groups_Name__c = 'CAR_GVW_BU_Legal_Approver'),
            new CRS_PublicGroupMapping__c(Name = 'gvwcrs_corporate_food_law_approver__c', Groups_Name__c = 'CAR_GVW_Corporate_Food_Law_Approver'),
            new CRS_PublicGroupMapping__c(Name = 'gvwcrs_corporate_sra_approver__c', Groups_Name__c = 'CAR_GVW_Corporate_SRA_Approver'),
            new CRS_PublicGroupMapping__c(Name = 'gvwcrs_field_sra_approver__c', Groups_Name__c = 'CAR_GVW_Field_SRA_Approver'),
            new CRS_PublicGroupMapping__c(Name = 'gvwcrs_vp_chief_scientific__c', Groups_Name__c = 'CAR_GVW_VP_Chief_Scientific_Regulatory'),
    
            new CRS_PublicGroupMapping__c(Name = 'crs_vp_chief_scientific_regulatory__c', Groups_Name__c = 'CAR_VP_Chief_Scientific_Regulatory'),
            new CRS_PublicGroupMapping__c(Name = 'crs_vp_science_division__c', Groups_Name__c = 'CAR_VP_Science_Division'),
        
            new CRS_PublicGroupMapping__c(Name = 'crs_corporate_level__c', Groups_Name__c = 'CRS_Corporate_Level'),
            
            new CRS_PublicGroupMapping__c(Name = 'gvwcrs_corporate_level__c', Groups_Name__c = 'gvwCRS_Corporate_Level')
        };
        insert settingList;
    }
    
    private static void getTestUser(){
        testU = [Select Id, crs_bu_legal_approver__c, crs_field_sra_approver__c,
        gvwcrs_corporate_food_law_approver__c, gvwcrs_field_sra_approver__c,
        crs_vp_chief_scientific_regulatory__c, crs_vp_science_division__c,
        TimeZoneSidKey, LocaleSidKey, 
        EmailEncodingKey, ProfileId, LanguageLocaleKey, LastName,
        Alias, Email, CommunityNickname, UserRoleId
         from User where LastName like 'test' limit 1];
         System.debug('~~~~!! Alias = '+ testU.Alias + ' Email = ' + testU.Email +
            ' UserRoleId = ' + testU.UserRoleId + ' TimeZoneSidKey = ' + testU.TimeZoneSidKey +
            ' LocaleSidKey = ' + testU.LocaleSidKey + ' EmailEncodingKey = ' + testU.EmailEncodingKey +
            ' ProfileId = ' + testU.ProfileId + ' LanguageLocaleKey = ' +testU.LanguageLocaleKey);
    }
    
    private static void activateGroups(){
        testU.CRS_BU_Legal_Approver__c = 'Yes';
        testU.CRS_Field_SRA_Approver__c = 'Yes';
        testU.CRS_VP_Chief_Scientific_Regulatory__c = 'Yes';
        testU.gvwCrs_Corporate_food_law_approver__c = 'Yes';
        testU.gvwcrs_field_sra_approver__c = 'Yes';    }
    
    private static void deactivateGroups(){
        testU.CRS_BU_Legal_Approver__c = 'No';
        testU.CRS_VP_Chief_Scientific_Regulatory__c = 'No';
        testU.gvwcrs_field_sra_approver__c = 'No';
        update testU;
    }
    
    private static void clearGroups(){
        testU.CRS_BU_Legal_Approver__c = 'No';
        testU.CRS_Field_SRA_Approver__c = 'No';
        testU.CRS_VP_Chief_Scientific_Regulatory__c = 'No';
        testU.gvwCrs_Corporate_food_law_approver__c = 'No';
        testU.gvwcrs_field_sra_approver__c = 'No';
        delete [select Id, GroupId, UserOrGroupId from GroupMember where UserOrGroupId = :testU.Id];
    }

    private static User createUser(String name){
        Profile testProf = [select Id from Profile where Name = 'CRS (crs & gvw) Standard User'];
        UserRole testRole = [select Id from UserRole where DeveloperName = 'CRS_gvwCRS'];
        User test2 = new User(
            LastName = 'test', Alias = 'ttest', Email = 'mail@mail.com',
            username = name, CommunityNickname = name,
            UserRoleId = testRole.Id, TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1',
            ProfileId = testProf.Id, LanguageLocaleKey = 'en_US'
        );
        return test2;
    }

    static testMethod void insertUserTestAddGroups() {
        createCustomSetting();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            testU = createUser('testo123@testo.com');
            activateGroups();
            insert testU;
            System.assert(([select Id, GroupId, UserOrGroupId from GroupMember where UserOrGroupId = :testU.Id].size()) == 5);
        }
    }
    
    static testMethod void updateUserTestChangeGroups() {
        createCustomSetting();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            testU = createUser('testo123@testo.com');
            activateGroups();
            insert testU;
            deactivateGroups();
            update testU;
            //System.assert(([select Id, GroupId, UserOrGroupId from GroupMember where UserOrGroupId = :testU.Id].size()) == 2);
        }
    }
    
    static testMethod void insertUserListTest(){
        createCustomSetting();
        List<User> uList = new List<User>();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            testU = createUser('testtesttest1124@test.com');
            activateGroups();
            uList.add(testU);
            testU = createUser('testtest2221@test.com');
            activateGroups();
            uList.add(testU);
            insert uList;
            System.assert(([select Id, GroupId, UserOrGroupId from GroupMember where UserOrGroupId in (:uList[0].Id, :uList[1].Id)].size()) == 10);
        }
    }
}