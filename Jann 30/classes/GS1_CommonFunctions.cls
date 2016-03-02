/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     A class containing shareable, generic functions
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*
*/
public without sharing class GS1_CommonFunctions {
    public static String getObjectPrefix(String objectName) {
        String oName = objectName.toUpperCase();
        String ret = '';
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        
        for(String sObj : gd.keySet()){
           Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
           if (r.getName() == oName ) {
               ret = r.getKeyPrefix();
               break;
           }
        }
        return ret;
   }
   
   public static String getObjectNameByPrefix(String prefix) {
        String ret = '';
        String prep;
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        
        for(String sObj : gd.keySet()){
           Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
           prep = r.getKeyPrefix();
           if (prep!=null) {           
               if (prep.equals(prefix)) {
                   ret = r.getName();
                   break;
               }
           }
        }
        return ret;     
   }
   
   public static ApexPages.PageReference navigateToRecordList(String objectName) {
       String id = getObjectPrefix(objectName);
       if (String.isBlank(id)) {
           return null;
       }
       
       return new ApexPages.PageReference('/' + id );
   }
    
    public static boolean isGS1Admin(Id userId) {
        Id grpId = label.GS1_AdminGroupID;
        GroupMember[] mem = [select id from GroupMember where ((GroupId=:grpId) AND (UserOrGroupId=:userId)) limit 1];
        return (mem.size()>0);
    }    
   
    public static Messaging.Singleemailmessage composeEmailFromTemplate(String templateId, String objectId) {
        Messaging.Singleemailmessage email;
        email = new Messaging.Singleemailmessage();
        email.setTemplateId(templateId);
        email.setWhatId(objectId);    
        email.setSaveAsActivity(false);        
        return email;
    }   
    
    public static boolean isSystemAdministrator() {
    	Id userProfileId = Id.valueOf(UserInfo.getProfileId());
    	Id SysAdminId = Id.valueOf(Label.GS1_SystemAdministratorId);
    	return (userProfileId == SysAdminId);    	
    }
    
}