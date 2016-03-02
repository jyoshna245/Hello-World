public with sharing class CRS_ItemsToApprove {
   public Map<ID,ID> mapRecentApprover{get;set;}
   public Map<ID,String> mapRecentApproverName{get;set;}
   public Map<ID,String> mapRecentCRSRecords{get;set;}
   public Set<Id> userIds{get;set;}
 
 public List<ProcessInstanceWorkitem> getResults(){
        
        // get the queues which the user belongs to 
        List<GroupMember> queues = [SELECT GroupId FROM GroupMember where UserOrGroupId  = :userInfo.getUserID()];
        List<String> users = new List<String>();
        users.add(userInfo.getUserID());
        //add the queues to which the user belongs 
        for( GroupMember grp : queues){
           users.add(grp.GroupId);
        }
        
              
        // get the list of all approval process item to approve the for the user/the group user belongs to
        List<ProcessInstanceWorkItem> workItemList = [Select Id,ProcessInstance.Status,ProcessInstance.LastActorId,ProcessInstance.TargetObjectId,ProcessInstanceId,OriginalActorId,ActorId, SystemModstamp From ProcessInstanceWorkitem where actorid in :users order by SystemModstamp desc];
        
        List<ProcessInstance> lstPI=[SELECT Id,TargetObjectId,(SELECT Id ,ActorId,SystemModstamp  FROM StepsAndWorkitems where StepStatus='Approved' order by SystemModstamp desc) FROM ProcessInstance where status='Approved'  order by SystemModstamp desc ];
       
        //get List of items before first step of submission is approved
        List<ProcessInstance> lstPI2=[SELECT Id,Status,TargetObjectId,(Select Id,StepStatus,ActorId From Steps where StepStatus='Started' order by SystemModstamp desc) FROM ProcessInstance where status='Pending'  order by SystemModstamp desc ];
        
        system.debug('Most Recent Approver'+lstPI.size());
        
       //getting CRS Records and mapping id with Name
        mapRecentCRSRecords=new map<Id,string>();
        list<CRS__c> lstCRS=[select Id,Name from CRS__c where Status__c NOT IN('Approved','Abandoned','Conditionally Approved','Approved-Obsolete') limit 50000];
        for(CRS__c crs:lstCRS){
          mapRecentCRSRecords.put(crs.Id,crs.Name);
        }
        
         userIds=new Set<ID>();
         mapRecentApprover=new Map<ID,ID>();
         mapRecentApproverName=new Map<ID,String>();
         
         for(ProcessInstance pi:lstPI){
            List<ProcessInstanceHistory> swi=pi.StepsAndWorkitems;
            system.debug('History'+swi);
               for(ProcessInstanceHistory hist:swi){
                   mapRecentApprover.put(pi.TargetObjectId,hist.ActorId);
                   system.debug('Mapper'+mapRecentApprover);
                   userIds.add(hist.ActorId);
           }
        }
        
        //First Step after submission
       for(ProcessInstance pi:lstPI2){
            List<ProcessInstanceStep> stps=pi.Steps;
            system.debug('Step'+stps);
               for(ProcessInstanceStep stp:stps){
                   mapRecentApprover.put(pi.TargetObjectId,stp.ActorId);
                   system.debug('Mapper2'+mapRecentApprover);
                   userIds.add(stp.ActorId);
           }
        }
        
        map<Id,string> mapGetUserNameWithId = new map<Id,string>();
        list<User> lstuser = [select Id,FirstName,LastName from User where id in:userIds limit 50000];
        for(user objUser : lstuser){
                mapGetUserNameWithId.put(objUser.Id,objUser.LastName+','+'  '+objUser.FirstName);
                mapRecentApproverName.put(objUser.Id,mapGetUserNameWithId.get(objUser.Id));
        }
      
        return  workItemList;
     
 } 
 
}