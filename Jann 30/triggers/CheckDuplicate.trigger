trigger CheckDuplicate on DepartmentalSuperUser__c (before insert, before update) {

    for(DepartmentalSuperUser__c DSU : trigger.new)
    {
        integer intCount = 0;
        
        If(DSU.From_User__c == null)
        {
            DSU.From_User__c = DSU.OwnerId;
        }
        
        DSU.OwnerId = DSU.From_User__c;
        
        If(trigger.IsInsert)
            intCount = [SELECT count() FROM DepartmentalSuperUser__c where OwnerId = :DSU.OwnerId];
        
        If(intCount > 0)
        {
            DSU.addError('Please return to the previous departmental super user screen and edit the additional viewer access settings you have already created.');
        }
    }

}