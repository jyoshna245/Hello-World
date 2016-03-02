trigger ITSES_SharingITSESRequests on DepartmentalSuperUser__c (after insert, after update) {

    ITPR_DepartmentalSuperUsers_share1 usersShare = new ITPR_DepartmentalSuperUsers_share1();
    usersShare.DSU_ITPR_Share(Trigger.new);
    
}