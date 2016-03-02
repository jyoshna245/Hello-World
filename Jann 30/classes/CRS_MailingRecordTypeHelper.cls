public with sharing class CRS_MailingRecordTypeHelper {
	// Specify the value 012000000000000AAA for the master recordTypeId regardless of the object. 
	// This value is returned in the recordTypeInfos for the master record type in the DescribeSObjectResult per SF docs.
	// See http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_describelayout.htm#i1425561 - "Arguments" section.
	public static final String MASTER_REC_TYPE_ID = '012000000000000AAA';
	
	public static final Map<String,String> RECORD_TYPES;

	static {
    	List<RecordType> recordTypes = [select Name from RecordType];
    	RECORD_TYPES = new Map<String,String>{};
    	for(RecordType rt: recordTypes) {	
    		RECORD_TYPES.put(rt.Id, rt.Name);
    	}
	}
	public static String getRecTypeNameById(String id) {
		return RECORD_TYPES.get(id);
  	}
}