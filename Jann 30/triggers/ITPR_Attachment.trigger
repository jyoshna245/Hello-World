trigger ITPR_Attachment on Attachment (before insert, before delete) {
public set<Id> st = new Set<Id>();
    List<Attachment> AttachmentsToDelete = new List<Attachment>();
    List<ITPR__c> itpr = new List<ITPR__c>(); 
if(trigger.isdelete){
for (Attachment attachment :Trigger.old)
    {       
        st.add(attachment.ParentId);       
    }  
   itpr = [SELECT Id,Status__c from ITPR__C where ID IN: st]; 
   if(itpr.size() >0)
   {
   for (Attachment attachment :Trigger.old)
    {
     for(ITPR__c itpr1: itpr)
     {         
     if(itpr1.Status__c!=System.Label.ITPR_Status && itpr1.Status__c!=System.Label.ITPR_Submitted_Status &&
           itpr1.Status__c!=System.Label.ITPR_Assigned_Status && itpr1.Status__c!=System.Label.ITPR_In_Process_Status && itpr1.Status__c!=System.Label.ITPR_Pending_More_Info_Needed_Status && itpr1.Status__c!=System.Label.ITPR_Pending_Project_Final_Budget_Status){
        attachment.addError('Cannot Delete Attachments When Status is '+itpr1.Status__c) ;
    } 
  }   
 }
 }
 }
 
 
 if(trigger.isinsert){
  for (Attachment attachment :Trigger.new)
    {       
        st.add(attachment.ParentId);       
    }  
      itpr = [SELECT Id,Status__c from ITPR__C where ID IN: st]; 
   if(itpr.size()>0)
   {
   for (Attachment attachment :Trigger.new)
    {
    for(ITPR__c itpr1:itpr)
    {          
     if(itpr1.Status__c!=System.Label.ITPR_Status && itpr1.Status__c!=System.Label.ITPR_Submitted_Status &&
           itpr1.Status__c!=System.Label.ITPR_Assigned_Status && itpr1.Status__c!=System.Label.ITPR_In_Process_Status && itpr1.Status__c!=System.Label.ITPR_Pending_More_Info_Needed_Status && itpr1.Status__c!=System.Label.ITPR_Pending_Project_Final_Budget_Status){
        attachment.addError('Cannot Add Attachments When Status is '+itpr1.Status__c) ;
    } 
  }
 }  
}
}
}