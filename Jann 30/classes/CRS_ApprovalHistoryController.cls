public with sharing class CRS_ApprovalHistoryController {
List<ProcessInstance> lstdlt=new List<ProcessInstance>();
private final CRS__c objCrs;
public Id recordId {get;set;}
public Id ProcessId {get;set;}
public string crsTrackingNumber {get;set;}
public boolean isRender {get;set;}
public boolean isShowResendLink {get;set;}
public boolean isShowApproveLink {get;set;}
transient Boolean isCRSSA=false;
transient Boolean isCRSBA=false;
public static String BAProfileName='CRS Business Admin';
public static String SAProfileName='System Administrator';
public string Status {get;set;}
public boolean visible {get;set;}
public string crsstatus {get;set;}
public datetime NOW {get;set;} 
public String myDate {get;set;}

public CRS_ApprovalHistoryController(ApexPages.StandardController stdController){
    
    recordId = ApexPages.currentPage().getParameters().get('Id');
    if(recordId != null){
        crsTrackingNumber = [select name from CRS__c where Id=:recordId].name;
        crsstatus = [select Status__c from CRS__c where Id=:recordId].Status__c;
        Crs__c Owner=[select Owner.Id from CRS__c where Id=:recordId]; //added 21 to 58 for defect #40
        
        Profile currentProfile = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()];
         isCRSBA = (currentProfile.Name == BAProfileName);
        
         isCRSSA = (currentProfile.Name == SAProfileName);
         
         Set<String> users = new Set<String>();
         List<ProcessInstanceWorkItem> workItemList=[Select Id,ProcessInstance.TargetObjectId,OriginalActorId,ActorId From ProcessInstanceWorkitem where ProcessInstance.TargetObjectId=:recordId];
         String GroupIdAssignedApprovers='';
         if(workItemList.size()!=0 && !workItemList.isEmpty()){
               for(ProcessInstanceWorkItem pwi:workItemList){
                GroupIdAssignedApprovers=pwi.OriginalActorId;
                
             }
         }
         if(GroupIdAssignedApprovers!=''){
             List<GroupMember> queues=[SELECT UserOrGroupId  FROM GroupMember where GroupId= :GroupIdAssignedApprovers];
             for(GroupMember gm:queues){
               users.add(gm.UserOrGroupId);
              
             }
             
         }
       
        if(Owner.OwnerId!=null){
        
          if(Owner.OwnerId==UserInfo.getUserId() || !users.contains(UserInfo.getUserId())){
             isShowApproveLink=false;
             
          }
          if(isCRSSA || isCRSBA || users.contains(UserInfo.getUserId())){
             isShowApproveLink=true;
          }
          
        }
      
    }
    
    NOW = system.now();
    Timezone tz = UserInfo.getTimeZone();
    String zone = tz.getId();  
    myDate = NOW.format('EEE, MMM d yyyy HH:mm:ss', zone);
    
    lstdlt=[SELECT Id,Status,CompletedDate,ProcessDefinition.name,(SELECT Id, StepStatus,OriginalActorId ,ActorId, Comments,SystemModstamp FROM StepsAndWorkitems order by SystemModstamp desc, StepStatus) FROM ProcessInstance where TargetObjectId =: recordId order by SystemModstamp desc];

        if(lstdlt.size() > 0){
                isRender = true;
                 Status=lstdlt[0].Status;
        }  
         if(Status=='Pending'){
        visible= True;
        }
     //Added for REsend link functionality
        
        if(recordId !=null){
            String crsId=recordId;
            String groupIds='';
            List<ProcessInstance> lstdltPreviousApprover=new List<ProcessInstance>();
            lstdltPreviousApprover=[SELECT Id,TargetObjectId,(SELECT Id ,OriginalActorId,ActorId,SystemModstamp  FROM StepsAndWorkitems where StepStatus='Approved' order by SystemModstamp desc) FROM ProcessInstance where status='Approved' and TargetObjectId =: recordId order by SystemModstamp desc limit 1];
                for(ProcessInstance pi:lstdltPreviousApprover){
                    List<ProcessInstanceHistory> swi=pi.StepsAndWorkitems;
                    system.debug('History'+swi);
                    for(ProcessInstanceHistory hist:swi){
                        groupIds=hist.OriginalActorId;
                        system.debug('groupIds'+groupIds);
                    }
                       
                }
            String showLink=CRS_Mailing.showReSendLink(crsId,groupIds); 
            system.debug('showLink'+showLink);
            if(showLink!='false'){
              isShowResendLink =true;
            }
            else{
              isShowResendLink =false;
            }
        }
            
     
}

public List<ProcessInstance> getResults(){
       // lstdlt=[SELECT Id,Status,CompletedDate,ProcessDefinition.name,(SELECT Id, StepStatus,OriginalActorId ,ActorId, Comments,SystemModstamp FROM StepsAndWorkitems order by SystemModstamp desc, StepStatus) FROM ProcessInstance where TargetObjectId =: recordId order by SystemModstamp desc];
        return lstdlt;
}

public PageReference approveRj(){
        List<ProcessInstanceWorkItem> workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :recordId]; 
        if(workItemList.size() > 0){
                ProcessId = workItemList[0].Id;
        }
        
        String partialURL = '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + ProcessId; 
        PageReference pageRef = new PageReference(partialURL);
        pageRef.setRedirect(true);
        return pageRef;
}

public PageReference goto() {
    PageReference pageRef = Page.CRS_ApprovalProcessHistoryList;
    pageRef.setRedirect(true);
    pageRef.getParameters().put('Id',recordId); 
            
    return pageRef;
} 


public PageReference Recall(){

        List<ProcessInstanceWorkItem> workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :recordId]; 
        if(workItemList.size() > 0){
                ProcessId = workItemList[0].Id;
        }
     visible= False;
        String partialURLrecall = '/' + ProcessId + '/e?et=REMOVE&retURL=%2F' + recordId; 
        PageReference pageRef = new PageReference(partialURLrecall);
        pageRef.setRedirect(true);
        return pageRef;
}

public List<ProcessInstanceStep> getApprovalProcesslist(){
        list<ProcessInstanceStep> lstprocesslist= [SELECT Id, StepStatus,OriginalActorId ,ActorId, Comments,SystemModstamp FROM ProcessInstanceStep where ProcessInstance.TargetObjectId =:recordId order by SystemModstamp ];
        return lstprocesslist;
}




}