// 
// (c) 2014 Appirio, Inc.
// 
// CaseTrigger
// Trigger to update the E&C Manager and Lead Investigator of Case before Insert/Update
//
// 11 July 2014     Erik Golden       Original
// 18 July 2014     Ashish goyal      Updated
//
trigger CaseTrigger on Case (Before Insert,Before Update, After Update,After Insert) {
    
    String userName = UserInfo.getName();
    String orgName = UserInfo.getOrganizationName();
    CaseTriggerHnadler handler = new CaseTriggerHnadler();

    // Redirect controller to Trigger Handler class
    if(Trigger.isBefore && Trigger.isInsert){
        System.debug('Before Insert');
        handler.beforeInsert(Trigger.New);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate ){
        System.debug('Before Update');
        if(!userName.equalsIgnoreCase('connection user')) handler.beforeUpdate(Trigger.New,Trigger.oldMap);
        handler.beforeUpdate2(Trigger.New,Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        System.debug('After Insert');
        handler.afterInsert(Trigger.New);
    }
    
    // Start @Ashish Goyal
    // T-301209
    if(Trigger.isAfter && Trigger.isUpdate){
        System.debug('After Update');
        handler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
    // End
}