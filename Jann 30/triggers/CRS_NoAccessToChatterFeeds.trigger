trigger CRS_NoAccessToChatterFeeds on FeedItem (Before Delete) {
    //++CRS Enhancement
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    system.debug('ProfileName'+profileName);
    set<Id> crsId = new set<Id> ();
    for(FeedItem fi : trigger.old){
       crsId.add(fi.ParentId);          
    }
    CRS__c objcrs = new CRS__c();
    list<crs__c> lstCRS = [select id,isReactivated__c,Status__c from crs__c where id in : crsId];
    if(lstCRS.size () > 0){
        objcrs = lstCRS[0];
    }
    if(Trigger.isDelete){
        if(profileName <> 'System Administrator' && profileName <> 'CRS Business Admin'){
            for(FeedItem fi : trigger.old){
                if(objcrs != null){
                    if(objcrs.isReactivated__c && objcrs.Status__c == 'Draft'){
                         fi.addError('You are not allowed to delete the Feed of a reactivated record');
                    }
                }
                }
            }
         }    
}