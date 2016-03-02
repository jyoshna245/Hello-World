/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     A class that updates request sharing in batch (when needed)
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*
*/
public without sharing class GS1_BatchUpdateRequestSharing
	implements Database.Batchable<sObject>,  Schedulable {
    
    private Set<Id> countryIds;
    public GS1_BatchUpdateRequestSharing() {}
    public GS1_BatchUpdateRequestSharing(Set<Id> cids) {
    	this.countryIds = cids;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }       
     public Database.QueryLocator start(Database.BatchableContext BC) {  
     	if (this.countryIds==null) {
     		return database.getQueryLocator([select id, status__c, country__c from GS1_Request__c]);
     	} else {
     		if (this.countryIds.size()>0) {
     			return database.getQueryLocator([select id, status__c, country__c from GS1_Request__c where Country__c IN :this.countryIds order by Country__c]);
     		} else {
     			//we would't not expect anything to be return here... and that's our intention
     			List<Id> rIds = new List<Id>();
     			return Database.getQueryLocator([select id from GS1_Request__c where Id IN :rIds]);
     		}
     	}
        
     }
     
    public void execute(Database.BatchableContext BC,  List<GS1_Request__c> records) {
   		GS1_SharingProcessor.updateRequestSharing(records);
    }   
    
    public void finish(Database.BatchableContext BC) {
    }
}