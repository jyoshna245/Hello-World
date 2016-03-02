/***********************************************************************
Trigger Name  : DealTriggerHandler
Created By   	: Kirti Agarwal
Created Date 	: 15th Nov,2013
Purpose      	: Create Deal Tracking History records
Task         	: T-212459
************************************************************************/
public class DealTriggerHandler {

 /**
 * This method will be called after update of deal record
 */
  public static void onAfterInsert(List<Sobject> newDealList, map<id,Sobject>oldMap){

  	map<string,Deal_History_Tracking_Setting__c> fieldList = Deal_History_Tracking_Setting__c.getAll();
  	List<Deal_History_Tracking__c> dealTrackingList = new List<Deal_History_Tracking__c>();

  	for(Sobject deal : newDealList){
  		object dealIdObj = deal.get('Id');
  		String dealId = String.valueOf(dealIdObj);

  		for(String fieldName : fieldList.keyset()){
  			Sobject oldDeal = oldMap.get(dealId);

  			object newDealValue = deal.get(fieldName);
   			object oldDealValue = oldDeal.get(fieldName);

   			String newVal = String.valueOf(newDealValue);
   			String oldVal = String.valueOf(oldDealValue);
   			if(newVal != oldVal){
   				Deal_History_Tracking__c dealTrack = new Deal_History_Tracking__c();
   				dealTrack.New_Value__c = newVal;
   				dealTrack.Previous_Value__c = oldVal;
   				dealTrack.Deal__c = dealId;
   				dealTrackingList.add(dealTrack);
   			}
  		}
  	}

  	if(dealTrackingList.size() > 0){
  		insert dealTrackingList;
  	}
  }

  /**
  * This method will be called After insert and update on Other_Associates__c field.
    It will share the record to the selected user in the picklist Other_Associates__c.
  **/
  public static void onAfterInsertUpdate(List<Deal__c> newDealList, map<id,Deal__c>oldMap){

  	List<User> listOfUser = new List<User>([SELECT id, FirstName, lastName
  																					FROM User
  																					WHERE Deal_Management_User__c = true
  																					AND isActive = true]);

    Schema.DescribeFieldResult fieldResult = Deal__c.Other_Associates__c.getDescribe();
	  List<Schema.PicklistEntry> pickList = fieldResult.getPicklistValues();
	  Map<String, id> mapOfUserNameandId = new Map<String, id>();

		for(Schema.PicklistEntry FieldValue : pickList) {
	      for(User usr : listOfUser){
	      	String userName = usr.FirstName + ' ' + usr.lastName;
	      	  if(userName == FieldValue.getValue()) {
	      	  	mapOfUserNameandId.put(userName, usr.id);
	      	  	break;
	      	  }
	      }
	   }

  	list<Deal__Share> listOfDealShare = new List<Deal__Share>([select id,ParentId,AccessLevel,
  	                                                                   UserOrGroupId
  																																	from Deal__Share
  																																	Where  ParentId IN: newDealList
  																																	and AccessLevel = 'Edit']);
  	map<id,Deal__Share> mapOfParentIdAndDealShare = new map<id,Deal__Share>();
    for(Deal__Share share : listOfDealShare){
    	mapOfParentIdAndDealShare.put(share.UserOrGroupId, share);
    }

  	List<Deal__Share> dealShares = new List<Deal__Share>();
    List<Deal__Share> deleteDealShares = new List<Deal__Share>();
  	for(Deal__c deal : newDealList){

  		if((oldMap == null || oldMap.get(deal.id).Other_Associates__c != deal.Other_Associates__c)
  		           &&  deal.Other_Associates__c!= null) {
         if(oldMap == null && deal.Other_Associates__c != null){
				   List<String> otherAssociateList =  deal.Other_Associates__c.split(';');
				   for(String FieldValue : otherAssociateList) {
						if(mapOfUserNameandId.containsKey(FieldValue)) {
							Deal__Share  dealShare = new Deal__Share ();
							dealShare.AccessLevel = 'Edit';
							dealShare.ParentId = deal.id;
							dealShare.UserOrGroupId  = mapOfUserNameandId.get(FieldValue);
							dealShares.add(dealShare);
						}
				   }
         }

         else if(oldMap != null){
         	if(deal.Other_Associates__c != null){
         		  List<string> addDealShare = new List<string>();
         		  List<string> deleteDealShare = new List<string>();
         		  map<String,string> commonDealShare = new map<string,string>();

         		  List<String> newOtherAssociateList =  deal.Other_Associates__c.split(';');

         		  List<String> oldOtherAssociateList = new List<String> ();
         		  if(oldMap.get(deal.id).Other_Associates__c != null){
         		     oldOtherAssociateList =  oldMap.get(deal.id).Other_Associates__c.split(';');
         		  }
         		  for(String newfield : newOtherAssociateList){
         		  	for(string oldField : oldOtherAssociateList){
	         		  	if(newfield == oldField){
	         		  		commonDealShare.put(newfield,newfield);
	         		  	}
         		  	}
         		  }
         		  for(String newfield : newOtherAssociateList){
         		  	if(!commonDealShare.containsKey(newfield)){
         		  	   addDealShare.add(newfield);
         		  	}
         		  }
         		   for(String oldField : oldOtherAssociateList){
                if(!commonDealShare.containsKey(oldField)){
                   deleteDealShare.add(oldField);
                }
              }

              for(String FieldValue : addDealShare) {
		            if(mapOfUserNameandId.containsKey(FieldValue)) {
		              Deal__Share  dealShare = new Deal__Share ();
		              dealShare.AccessLevel = 'Edit';
		              dealShare.ParentId = deal.id;
		              dealShare.UserOrGroupId  = mapOfUserNameandId.get(FieldValue);
		              dealShares.add(dealShare);
		            }
              }
              for(String FieldValue : deleteDealShare) {
                if(mapOfUserNameandId.containsKey(FieldValue)) {
                  string UserOrGroupId  = mapOfUserNameandId.get(FieldValue);

                  if(mapOfParentIdAndDealShare.containsKey(UserOrGroupId)){
                     deleteDealShares.add(mapOfParentIdAndDealShare.get(UserOrGroupId));
                  }
                }
              }


         	}
         }

  		}
  	}

  	if(dealShares.size() > 0) {
  		insert dealShares;
  	}
  	if(deleteDealShares.size() > 0) {
      delete deleteDealShares;
    }

  }

}