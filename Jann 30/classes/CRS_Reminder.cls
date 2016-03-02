public with sharing class CRS_Reminder{
public Boolean showAlertForCorpSRA{get;set;}
public Boolean showAlertForCorpFGD{get;set;}
public Boolean showAlertForSysAdmin{get;set;}
public Boolean showAlertForBusinessAdmin{get;set;}
public static String BAProfileName='CRS Business Admin';
public static String SAProfileName='System Administrator';
  public Static String type{get;set;}
static Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.CRS__c.getRecordTypeInfosById();
public CRS_Reminder(ApexPages.StandardController stdController)
 {
 CRS__c crs = (CRS__c) stdController.getRecord();
    showAlertForCorpSRA = false;
    showAlertForCorpFGD = false;
    showAlertForBusinessAdmin=false;
    showAlertForSysAdmin=false;
 if(crs.id!=null){
     List<CRS__c > ApproverIds=[select CRS_Corp_SRA_Approver__c,CRS_Corp_Formula_Governance__c from CRS__c where id=:crs.id];
     String loggedInUserId=UserInfo.getUserId();
     if(ApproverIds.size()!=0 && !ApproverIds.isEmpty()){
     String ListOfSraApprover=String.valueOf(ApproverIds[0].CRS_Corp_SRA_Approver__c);
     String ListOfFgdApprover=String.valueOf(ApproverIds[0].CRS_Corp_Formula_Governance__c);
     if(ListOfSraApprover!=null && ListOfSraApprover!=''){
       String [] splittSraApprover=ListOfSraApprover.split(';');
       for(String str:splittSraApprover){
         if(str.contains(loggedInUserId))
             showAlertForCorpSRA=true;
         }
     }
     if(ListOfFgdApprover!=null && ListOfFgdApprover!=''){
       String [] splittFgdApprover=ListOfFgdApprover.split(';');
       for(String str:splittFgdApprover){
         if(str.contains(loggedInUserId))
             showAlertForCorpFGD=true;
         }
     }
     }
  }
  Profile currentProfile = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()];
  if(currentProfile!=null){
    if(currentProfile.Name==BAProfileName){
      showAlertForBusinessAdmin=true;
    }
    if(currentProfile.Name==SAProfileName){
      showAlertForSysAdmin=true;
    }
  }
  type = rtMap.get(crs.RecordTypeId).getName();
 }
}