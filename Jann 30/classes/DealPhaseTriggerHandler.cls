/***********************************************************************
Trigger Name  : DealPhaseTriggerHandler
Created By   	: Kirti Agarwal
Created Date 	: 27th Nov,2013
Purpose      	: Update Deal record based on Deal Phase record
Task         	: T-215444
************************************************************************/
public class DealPhaseTriggerHandler {

/**
 * This method will be called after update or insert of deal phase record
 */
  public static void onAfterInsertUpdate(List<Deal_Phase__c> newDealPhaseList, map<id,Deal_Phase__c>oldMap) {
  		set<String> setOfDealId = new set<String>();
  		
  		for(Deal_Phase__c dealPhase : newDealPhaseList) {
  			if(dealPhase.Deal__c != null) {
  				setOfDealId.add(dealPhase.Deal__c);
  			}
  		}
  		
  		List<Deal_Phases__c> DealPhasesSetting = Deal_Phases__c.getall().values();
  		
  		map<id,Sobject> mapOfDeal = new map<id,Sobject>([SELECT id FROM Deal__c WHERE id IN: setOfDealId ]);
  		set<Sobject> setOfDeal = new set<Sobject>();
  		
  		for(Deal_Phase__c dealPhase : newDealPhaseList) {
  			if(oldMap == null || (dealPhase.Required_Attachments__c != oldMap.get(dealPhase.id).Required_Attachments__c)) {
	  			String AttachemntValue = dealPhase.Required_Attachments__c ;
	  			Sobject Deal = mapOfDeal.get(dealPhase.Deal__c);
	  			
	  			for(Deal_Phases__c setting : DealPhasesSetting) {  	
	  				Boolean isChecked;			 
	  				 if(AttachemntValue != null && AttachemntValue.contains(setting.Attachment__c)) {
	  				 	 if(setting.Is_Need_To_Set_Deal_Field__c) {
	  				 	 	 isChecked = true;
	  				 		 Deal.put(setting.Deal_Field__c, isChecked);
	  				 	
	  				 	 }else{
	  				 	 	 isChecked = false;
	  				 	 	 Deal.put(setting.Deal_Field__c, isChecked);
	  				 	 }
	  				 }
	  				 else{
	  				 	  isChecked = false; 
	  				 	 	Deal.put(setting.Deal_Field__c, isChecked);
	  				 }
	  			}
	  			setOfDeal.add(Deal);
  			}
  		}
  		
  		if(setOfDeal.size() > 0) {
  			List<Sobject> dealList = new List<Sobject>();
  			dealList.addAll(setOfDeal);
  			update dealList;
  		}	 		
  }
}