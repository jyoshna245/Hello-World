public with sharing class CRS_HistoryComponentController {
	// External variables
	//The object for which history need to be displayed
	public SObject myObject {get; set;}
	//Record Limit of History Records to be shown on page
	public Integer intRecordLimit {get; set;}
	//SFDC Object Label 
	public static String strObjectLabel {get;}
	//Object Id passed from Component corresponding to which SOQL will be fired and the history records will be retrieved 
	public static String strObjectId {get;set;}
	//Object Map to get the associated fields
	public static final Map<String, Schema.SObjectType> mySObjectTypeMap = Schema.getGlobalDescribe();
	//Associated Fields' map
	public static Map<String, Schema.SObjectField> mapMyObjectField;
	//List for storing the associated picklist values 
	public static List<Schema.PicklistEntry> lstHistoryFieldPicklist;

	//Method to get the History Data related to record/object passed from Component
	public List<ObjectHistoryLine> getObjectHistory(){
		//Id myObjectId = String.valueOf(myObject.get('Id'));
		//Id myObjectId = String.valueOf(strObjectId);
		list<ObjectHistoryLine> objectHistory = new list<ObjectHistoryLine>();
		if(strObjectId == null)
			return objectHistory;
		Schema.DescribeSObjectResult objectDescription = myObject.getSObjectType().getDescribe(); 
		mapMyObjectField = objectDescription.fields.getMap();
		
		strObjectLabel = String.valueOf(objectDescription.getLabel());
		
		//Get the name of thew history table
		String objectHistoryTableName = objectDescription.getName();

		//if we have a custom object we need to drop the 'c' off the end before adding 'History' to get the history tables name
		if (objectDescription.isCustom()){
			objectHistoryTableName = objectHistoryTableName.substring(0, objectHistoryTableName.length()-1);
		}
		objectHistoryTableName = objectHistoryTableName + 'History';
		Schema.DescribeFieldResult objectHistoryFieldField = mySObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get('Field').getDescribe();
		lstHistoryFieldPicklist = objectHistoryFieldField.getPickListValues();
		String strPrevDate = '';
		if (intRecordLimit== null){
			intRecordLimit = 100;
		}
		//list<sObject> historyList = Database.query( 'SELECT CreatedDate,'+ 'CreatedById,'+'Field,'+ 'NewValue,'+'OldValue ' +  'FROM ' + objectHistoryTableName + ' ' + 'WHERE ParentId =\'' + myObjectId + '\' ' +'ORDER BY CreatedDate DESC '+ 'LIMIT ' + String.valueOf(recordLimit));  
		list<sObject> historyList = Database.query(
			'SELECT CreatedDate,CreatedById,Field,NewValue,OldValue ' 
			+  'FROM ' + objectHistoryTableName + ' WHERE ParentId =\'' 
			+ strObjectId + '\' ORDER BY CreatedDate DESC LIMIT ' 
			+ String.valueOf(intRecordLimit));
		
		for(Integer i = 0; i < historyList.size(); i++){
			sObject historyLine = historyList.get(i);
			if((historyLine.get('newValue') == null && historyLine.get('oldValue') == null)|| 
					(historyLine.get('newValue') != null && !(string.valueOf(historyLine.get('newValue')).startsWith('005') 
							|| string.valueOf(historyLine.get('newValue')).startsWith('00G')))
							|| (historyLine.get('oldValue') != null && !(string.valueOf(historyLine.get('oldValue')).startsWith('005') 
									|| string.valueOf(historyLine.get('oldValue')).startsWith('00G')))){
				ObjectHistoryLine tempHistory = new ObjectHistoryLine();
				// Set the Date and strCreatedBy performed the strAction
				if(String.valueOf(historyLine.get('CreatedDate')) != strPrevDate){
					try{
					  DateTime dt = (DateTime) historyLine.get('CreatedDate');
					  tempHistory.strCreationDate = dt.format('yyyy-MM-dd HH:mm:ss');
					}catch(Exception e){}
					tempHistory.idUser = String.valueOf(historyLine.get('CreatedById'));
					tempHistory.strCreatedBy = String.valueOf(historyLine.get('CreatedById'));
				}else{
					tempHistory.strCreationDate = '';
					tempHistory.strCreatedBy = '';
					tempHistory.idUser = String.valueOf(historyLine.get('CreatedById'));
				}
				strPrevDate = String.valueOf(historyLine.get('CreatedDate'));
				// Get the field label
				String strFieldLabel = CRS_HistoryComponentController.returnFieldLabel(
																			String.valueOf(historyLine.get('Field')));
				// Set the Action value
				if(String.valueOf(historyLine.get('Field')) == 'created'){
					// on Creation
					tempHistory.strAction = 'Created.';            
				}else if(historyLine.get('oldValue') != null && historyLine.get('newValue') == null){
					// when deleting a value from a field
					// Format the Date and if there's an error, catch it and re
					try{
						tempHistory.strAction = 'Deleted ' + Date.valueOf(historyLine.get('oldValue')).format() + ' in <b>' + strFieldLabel + '</b>.';
					}catch (Exception e){
						tempHistory.strAction = 'Deleted ' + String.valueOf(historyLine.get('oldValue')) + ' in <b>' + strFieldLabel + '</b>.';
					}
				}else{// all other scenarios
					String strFromText = '';
					if(historyLine.get('oldValue') != null){
						try{
							strFromText = ' from ' + Date.valueOf(historyLine.get('oldValue')).format();
						}catch (Exception e){
							strFromText = ' from ' + String.valueOf(historyLine.get('oldValue'));
						}
					}
					String strToText = '';
					if(historyLine.get('oldValue') != null){
						try{
							strToText = Date.valueOf(historyLine.get('newValue')).format();
						}catch (Exception e){
							strToText = String.valueOf(historyLine.get('newValue'));
						}
					}
					if(strToText != ''){
						tempHistory.strAction = 'Changed <b>' + strFieldLabel + '</b>' + strFromText + ' to <b>' + strToText + '</b>.';
					}else{
						if(historyLine.get('oldValue') == null && historyLine.get('newValue') != null){
							try{
							strToText = Date.valueOf(historyLine.get('newValue')).format();
							}catch (Exception e){
								strToText = String.valueOf(historyLine.get('newValue'));
							}
							tempHistory.strAction = 'Changed <b>' + strFieldLabel + ' to <b>' + strToText + '</b>.';
						}
						else{
							tempHistory.strAction = 'Changed <b>' + strFieldLabel;
						}
					}
				}
				// Add to the list
				objectHistory.add(tempHistory);
			}
		}
		List<Id> lstUserIds = new List<Id>();
		for(ObjectHistoryLine myHistory : objectHistory){
			lstUserIds.add(myHistory.idUser);
		}
		Map<Id, User> mapUserIds = new Map<ID, User>([SELECT Name FROM User WHERE Id IN : lstUserIds]);
		for (ObjectHistoryLine myHistory : objectHistory){
			if(mapUserIds.containsKey(myHistory.idUser) & (myHistory.strCreatedBy != '') ){
				myHistory.strCreatedBy = mapUserIds.get(myHistory.strCreatedBy).Name;
			}
		}
		return objectHistory;
	}           
	
	// Function to return Field Label of a object field given a Field API name
	public Static String returnFieldLabel(String strFieldName){
		if (CRS_HistoryComponentController.mapMyObjectField.containsKey(strFieldName)){
			return CRS_HistoryComponentController.mapMyObjectField.get(strFieldName).getDescribe().getLabel();
		}else{
			for(Schema.PicklistEntry pickList : lstHistoryFieldPicklist){
				if(pickList.getValue() == strFieldName){
					if(pickList.getLabel() != null){
						return pickList.getLabel();
					}else{
						return pickList.getValue();
					}
				}
			}
	  }
		return '';
	}
	// Inner Class to store the detail of the object history lines       
	public class ObjectHistoryLine{
		public String strCreationDate {get; set;}
		public String strCreatedBy {get; set;}
		public Id idUser {get; set;}
		public String strAction {get; set;}
	}
}