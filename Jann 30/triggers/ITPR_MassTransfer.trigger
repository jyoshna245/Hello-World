trigger ITPR_MassTransfer on ITPR_Mass_Transfer__c (before insert) {


public String userProfileName {
        get {
            return [
                    select Name
                    from RecordType
                    where Name = 'In Process'
                    ].Name;
        }
    }
    
    system.debug('%%%%%%%%%%%%%%' + userProfileName );
for(ITPR_Mass_Transfer__c mtransfer : Trigger.new)

{




}

}