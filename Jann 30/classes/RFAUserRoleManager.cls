/**
* Author,email :     Mads Pascua , mpascua@coca-cola.com
* Date Create  :     Nov 5, 2013
* Description  :     The Apex Class that contains methods used by the main trigger for RFAUserRole__c.
*                    
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
**/

public class RFAUserRoleManager {

    public class RFAUserRoleException extends Exception {}
    // Get RecordTypes associated to RFAUser Role    
    public static Map<String, RecordType> approverRecordTypeMap = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
  
    public static void preventPointOfContactDeletionWhenNotInDraft(List<RFAUserRole__c> oldRFAUserRole) { 
        Map<Id, RFA__c> rfaMap = new Map<Id, RFA__c>();
        Set<Id> idSet = new Set<Id>();
        for(RFAUserRole__c rfaur : oldRFAUserRole){
           idSet.add(rfaur.RFA__c);
        }
        List<RFA__c> rfaList = [SELECT Id, Level__c, POC_Total__c from RFA__c WHERE Id IN: idSet LIMIT 1000];
        for(RFA__c rfa: rfaList){
            rfaMap.put(rfa.Id, rfa);
        }
  
        for(RFAUserRole__c rfaur : oldRFAUserRole){

               if(rfaur.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id && !rfaur.RFA_Level__c.equalsIgnoreCase(RFAGlobalConstants.RFA_STAGE_DRAFT)){
                   //rfaur.addError('Cannot delete Primary Point Of Contact. RFA no longer in Draft.');
                   Integer counterPOC = Integer.valueOf(rfaMap.get(rfaur.RFA__c).POC_Total__c);
                   if(counterPOC < 2){
                       rfaur.addError('Cannot delete Primary Point Of Contact. At least 1 Primary Point of Contact is needed when as RFA is no longer in Draft.');
                   }    
               }                
          
        }   
           
    }   
}