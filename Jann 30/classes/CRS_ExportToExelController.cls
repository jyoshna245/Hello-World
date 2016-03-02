public with sharing class CRS_ExportToExelController {

	private String baseLink;
	
	/*
		StandardSetController shows 20 records per page by default.
	 */
    public CRS_ExportToExelController(ApexPages.StandardSetController controller) {
    	if(controller.getResultSize() > 2000){
            controller.setPageSize(2000);
        } else {
            controller.setPageSize(controller.getResultSize());
        }
    }

    public String getBaseLink() {
    	return (new PageReference('/').getUrl());
    }
}