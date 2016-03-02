public with sharing class getValuesFieldset {
        public RFA__C rfaObj{get;set;}
    public getValuesFieldset(ApexPages.StandardController controller) {
            rfaObj=(RFA__C)controller.getRecord();
            Map<String, Schema.SObjectField> allFiields = Schema.SObjectType.RFA__c.fields.getMap();
            List<String> allFieldNames = new List<String>();
            allFieldNames.addAll(allFiields.keyset());
            System.debug(allFieldNames);
            
            SObject obj = Database.query('SELECT ' + String.join(allFieldNames,',') + ' FROM RFA__C where id='+rfaObj);
            
            for(String fieldName : allFieldNames){
                System.debug('Account.' + fieldName + ' = ' + obj.get(fieldName));
            }
            
    }

}