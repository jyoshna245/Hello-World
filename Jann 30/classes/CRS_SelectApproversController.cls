public with sharing class CRS_SelectApproversController {
    public String fieldValue {get; set;}

    public String getUserNames() {
        return CRS_CRSEdit.getMultiItemsNames('User', fieldValue);	
    }
}