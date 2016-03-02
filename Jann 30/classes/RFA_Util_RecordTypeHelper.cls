public class RFA_Util_RecordTypeHelper {

    public static Map<String, Map<String, RecordType>> createRecordTypesMap(String[] sObjTypes,
        String[] recordTypeNames) {

        Map<String, Map<String, RecordType>> sObjTypesMap =
            new Map<String, Map<String, RecordType>>();

        if (
            (sObjTypes == null) ||
            (sObjTypes.isEmpty()) ||
            (recordTypeNames == null) ||
            (recordTypeNames.isEmpty())
            ) {
            return sObjTypesMap;
        }

        for (RecordType[] recTypes :
            [select
                 Name,
                 sObjectType
             from
                 RecordType
             where
                 sObjectType in :sObjTypes
             and
                 Name in :recordTypeNames
            ]
            ) {
            for (RecordType recType : recTypes) {
                Map<String, RecordType> tmp = sObjTypesMap.get(recType.sObjectType);
                if (tmp == null) {
                    tmp = new Map<String, RecordType>();
                    sObjTypesMap.put(recType.sObjectType, tmp);
                }
                tmp.put(recType.Name, recType);
            }
        }
        return sObjTypesMap;
    }
    
    public static Map<Id, String> getRecordTypeName(String objectType){
         Map<Id, String> recordTypeNameMap = new map<Id, String>();
         for(RecordType recordTypeIds:[select Id,name, DeveloperName from RecordType where SobjectType = : objectType and IsActive=true])
            {
                  recordTypeNameMap.put(recordTypeIds.Id, recordTypeIds.name); 
                  
                  
            }
            return recordTypeNameMap;
    }
    
    

    public RFA_Util_RecordTypeHelper() {
    }

}