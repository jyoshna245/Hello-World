//ASynchronous class to reset a value

Public class RFA_VFC_AsyncronusclasstoReset{
    public static boolean asyn = true;
@future
    public static void resetRFALevelStageCopyfield(List<id> rfaids){
        system.debug('---Asyncronusclass--->');
        list<RFA__c> rfas= new list<RFA__c>();
        rfas=[select id,levelStageCopy__c from RFA__C where id in: rfaids];
        
        for(RFA__C rfaObj:rfas){
            rfaObj.levelStageCopy__c=null; 
        }
        if(asyn == true){
            asyn = false;
            update rfas;
        } 
    } 
}