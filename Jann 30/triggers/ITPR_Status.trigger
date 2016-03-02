trigger ITPR_Status on ITPR__c (before update) {

 String userDeptName = null;
 String userProfile = null;
 ID userID=null;
 //User currentUser = [Select Id, ITPR_Department__c,Profile.Name From User where Id = :UserInfo.getUserId()];
 //userID = currentUser.Id;
 //userDeptName = currentUser.ITPR_Department__c;
 //userProfile  = currentUser.Profile.Name;
 System.debug('DeptName'+userDeptName);
 System.debug('Profilee'+userProfile);
 
//Id test = [select Id from Profile where name =:'System Administrator'];
 
// if(userDeptName != 'ITSES - Vendor Governance' ){
for(ITPR__c f :Trigger.new)
{
if(Trigger.oldMap.get(f.Id).status__c == 'All Digital Initials Obtained' && f.Status__c == 'All Digital Initials Obtained')
{
if(f.Vendor_Governance__c !=UserInfo.getUserId() ) {
System.debug('in loop');
system.debug('status :'+f.Status__c);
f.addError('You cannot Edit the Request since the status is All Digital Initials Obtained');
}
}
}
}