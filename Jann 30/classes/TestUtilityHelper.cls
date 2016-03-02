// 
// (c) 2014 Appirio, Inc.
// 
// TestUtilityHelper
// Test class to create test data
// T-295612
//
// 14 July 2014     Ashish Goyal(JDC)       Original
//
public with sharing class TestUtilityHelper {
    
    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }    
   
    /*
    @Method Name : createUser
    @description : Method to get User
    @parameters  : String, String, String, String, String
    @returns     : Sobject
    */
    public static User createUser(String alias, String pfId, String nickName, String email){
        User us = new User();
        us.FirstName = 'Test';
        us.LastName = 'Appirio';
        us.Username = generateRandomString(10)+'@test.com';
        us.Alias = alias;
        us.LocaleSidKey = 'en_US';
        us.LanguageLocaleKey = 'en_US';
        us.ProfileId = pfId;
        us.EmailEncodingKey = 'ISO-8859-1';
        us.CommunityNickname = nickName;
        us.TimeZoneSidKey = 'America/Chicago';
        us.Email = email;
        us.IsActive = true;
        return us;
    }   
   
    /*
    @Method Name : createUser
    @description : Method to get User
    @parameters  : String, String, String, String, String
    @returns     : Sobject
    */
    public static User createUser(String username, String alias, String pfId, String nickName, String email){
        User us = new User();
        us.FirstName = 'Test';
        us.LastName = 'Appirio';
        us.Username = username;
        us.Alias = alias;
        us.LocaleSidKey = 'en_US';
        us.LanguageLocaleKey = 'en_US';
        us.ProfileId = pfId;
        us.EmailEncodingKey = 'ISO-8859-1';
        us.CommunityNickname = nickName;
        us.TimeZoneSidKey = 'America/Chicago';
        us.Email = email;
        us.IsActive = true;
        return us;
    }
    
   
   public static void createNAAccount() {
        Account a = new Account(Name='N/A');
        insert a;
    }
   
    /*
    @Method Name : createCase
    @description : Method to get Case
    @parameters  : String
    @returns     : Sobject
    */
    public static Case createCase(String managerId){
        Case cs = new Case();
        cs.Status = 'In Progress';
        cs.Subject = 'Test case';
        cs.E_C_Manager__c = managerId;
        cs.SBU__c = 'Coca-Cola Refreshments';
        cs.Group__c = 'Bottling Investments';
        cs.Business_Unit_Bottling_Company__c = 'CCR Canada';
        cs.Case_Reported_Date__c = date.today();
        return cs;
    }
    
    
    /*
    @Method Name : createInvestigationActivity
    @description : Method to create the record of Investigation_Activity__c object
    @parameters  : Id, boolean
    @returns     : SObject
    */
    public static Investigation_Activity__c createInvestigationActivity(Id caseId, boolean isInsert){
        Investigation_Activity__c invest = new Investigation_Activity__c();
        invest.RecordTypeId = TestUtilityHelper.getRecordTypeId('Investigation_Activity__c', 'Approval Reporting');
        invest.Case__c = caseId;
        if(isInsert){
            insert invest;
        }
        return invest;
    }
    
    
    /*
    @Method Name : getRecordTypeId
    @description : Method to get the record type id for given object and record type name
    @parameters  : String, String
    @returns     : Id
    */
    public static Id getRecordTypeId(String objType, String name) {
        SObject obj;
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objType);
        if (targetType != null) {
            obj = targetType.newSObject();
            Schema.DescribeSObjectResult d = obj.getSObjectType().getDescribe();
            if (d != null) {
                Map<String,Schema.RecordTypeInfo> rtMap = d.getRecordTypeInfosByName();
                if (rtMap != null) {
                    Schema.RecordTypeInfo rtInfo = rtMap.get(name);
                    if (rtInfo != null) {
                        return rtInfo.getRecordTypeId();
                    }
                }
            }
        }
        return null;
    }
}