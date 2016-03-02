global class DealRecordTypeUpdateInBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{

	global Database.QueryLocator start(Database.BatchableContext BC){
		 String query = 'select id,FirstName,LastName from User where Deal_Management_User__c = true and isActive = true';
      return Database.getQueryLocator(query);
   }

  /**
  * In this method we are doing login and get the current session id and updating the record type
  */
   global void execute(Database.BatchableContext BC,
                       List<User> scope){
    	 	List<Deal_UN_PW_Setting__c> listOfRecordSetting = Deal_UN_PW_Setting__c.getAll().values();

        UsernamePasswordFlow upf = new UsernamePasswordFlow(
																			   listOfRecordSetting[0].UserName__c,
																			    listOfRecordSetting[0].Password__c,
																			    listOfRecordSetting[0].Consumer_Key__c,
																			    listOfRecordSetting[0].Secret_Key__c,
																			    listOfRecordSetting[0].Token_End_Point__c
																			     );
     		String sessionIdVal = upf.requestAccessToken();
       	set<String> OtherAssociateField = new set<String>();
       	for(User usr : scope){
       		OtherAssociateField.add(usr.FirstName+ ' ' + usr.LastName);
       	}

  		 UpdateRecordtype(OtherAssociateField,sessionIdVal);
   }

   global void finish(Database.BatchableContext BC){

   }
    /**
      This method is used to update the Deal record type's Other Associates picklist value
    */
     public static void UpdateRecordtype(set<String> OtherAssociateField,String SessionId) {

       MetadataService.MetadataPort service = createService(SessionId);
        List<MetadataService.updateMetadata> metadataList = new List<MetadataService.updateMetadata>();
        List<Deal_Record_Type_Setting__c> recordSetting = Deal_Record_Type_Setting__c.getall().values();
				for(Deal_Record_Type_Setting__c recordType : recordSetting){
        	   MetadataService.RecordType recordType1 = new MetadataService.RecordType();
       			 recordType1.active = true;
       			 recordType1.label = recordType.Label__c;
       			 recordType1.fullName =  recordType.Full_Name__c;
       			 MetadataService.RecordTypePicklistValue rtPlV = new MetadataService.RecordTypePicklistValue();
       			 rtPlV.picklist = 'Other_Associates__c';
       			 recordType1.picklistValues = new List<MetadataService.RecordTypePicklistValue>();
       			 recordType1.picklistValues.add(rtPlV);
       			 rtPlV.values = new List<MetadataService.PicklistValue>();
		         for(String value : OtherAssociateField) {
		            MetadataService.PicklistValue plValue = new MetadataService.PicklistValue();
		            plValue.fullName = value;
				        plValue.default_x = false ;
				        rtPlV.values.add(plValue);

		        }
		          MetadataService.UpdateMetadata ut1 = new MetadataService.UpdateMetadata();
			        ut1.currentName = 'Deal__c.'+ recordType.Full_Name__c;
			        ut1.metadata= recordType1;
			        metadataList.add(ut1);
        }
        if(!Test.isRunningTest()){
            MetadataService.AsyncResult[] results = service.updateMetadata(metadataList);
        }
    }

public static MetadataService.MetadataPort createService(String SessionId)
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = SessionId;
        return service;
    }
}