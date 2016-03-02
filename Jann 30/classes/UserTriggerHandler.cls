/***********************************************************************
Class Name  : UserTriggerHandler
Created By      : Kirti Agarwal
Created Date    : 3rd Dec, 2013
Purpose         : Update the multiselect picklist on Deal object
Task            : T-216705
************************************************************************/
public class UserTriggerHandler {

    public static void afterInsertAndUpdate(List<User> userList, map<id,User> oldMap) {

        list<User> userListWithDeal = new list<User>();
        set<String> OtherAssociateField = new set<String>();
		    Boolean setPicklist = false;
		    for(User usr : userList){
		        if((oldMap == null && usr.Deal_Management_User__c) ||
		            (oldMap != null && oldMap.get(usr.id).Deal_Management_User__c != usr.Deal_Management_User__c)) {
		            setPicklist = true;
		            break;
		        }
		    }
		    if(setPicklist) {
		            userListWithDeal = [select id,FirstName,LastName
		            										from User
		            										where Deal_Management_User__c = true];

		            for(User usr : userListWithDeal){
		                OtherAssociateField.add(usr.FirstName + ' ' + usr.LastName);
		            }
		              UpdatePicklistField(OtherAssociateField,UserInfo.getSessionId());
		    }

    }

    @future(callout=true)
    public static void UpdatePicklistField(set<String> OtherAssociateField,String sessionId)
    {
        MetadataService.MetadataPort service = createService(sessionId);
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = 'Deal__c.Other_Associates__c';
        customField.label = 'Other Associates';
        customField.type_x = 'MultiselectPicklist';
        customField.visibleLines = 3;
        metadataservice.Picklist pt = new metadataservice.Picklist();
        pt.sorted = false;
        pt.picklistValues = new list<metadataservice.PicklistValue>();

         if(OtherAssociateField.size() > 0) {
            for(String value : OtherAssociateField) {
                metadataservice.PicklistValue plValue = new metadataservice.PicklistValue();
                plValue.fullName = value;
                plValue.default_x = false ;
                pt.picklistValues.add(plValue);
            }
         }

        else{
          metadataservice.PicklistValue pl = new metadataservice.PicklistValue();
            pl.fullName = 'None';
            pl.default_x = false ;
            pt.picklistValues.add(pl);
        }
        customField.picklist = pt ;
        MetadataService.UpdateMetadata ut = new MetadataService.UpdateMetadata();
        ut.currentName = 'Deal__c.Other_Associates__c';
        ut.metadata= customField;
        if(!Test.isRunningTest()){
         MetadataService.AsyncResult[] results = service.updateMetadata(new List<MetadataService.updateMetadata> {ut});
        }
    }


public static MetadataService.MetadataPort createService(String sessionId)
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = sessionId;
        return service;
    }

}