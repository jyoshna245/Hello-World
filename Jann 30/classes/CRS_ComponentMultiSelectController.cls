public with sharing class CRS_ComponentMultiSelectController {
    public String objectType {get; set;}
    public String fieldValue {get; set;}
    
    public String getNames() {
    	return CRS_CRSEdit.getMultiItemsNames(objectType, fieldValue);
    }
}