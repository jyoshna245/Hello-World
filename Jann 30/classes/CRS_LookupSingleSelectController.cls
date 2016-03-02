public class CRS_LookupSingleSelectController {
    public final static String ASCENDING_ORDER = 'ASC';
    public final static String DESCENDING_ORDER = 'DESC';
    private final static String NULLS_FIRST = 'NULLS FIRST';
    private final static String NULLS_LAST = 'NULLS LAST';
    private final static String SPACE = ' ';
    public final static Integer DEFAULT_PAGE_SIZE = 25;
    private final static String DEFAULT_QUERY_FIELDS = 'Name';
    private final static String FIELD_LABEL_PLACEHOLDER = '-';
    private final static String STRING_SEPARATOR = ',';
    
    private final static Integer MAX_NAME_LENGTH = 80;
    private final static String NEW_PRODUCT_NOTIFICATION_TEMPLATE = 'CRS_Add_New_Product_Notification';
    public final static String BUSINESS_ADMIN_EMAIL_SETTING_KEY = 'BusinessAdminEmail';
    
    public String searchString {
        get;
        set {
        	searchString = (value != null) ? value.trim() : null;
        }
    }
    
    /**
     * Search value for sorting. Has value of searchString when last search was performed.
     * Purpose: to mimic OOB SF behaviour - search value should be applyed only 
     * when User clicks "Go", not when just sorting performed.
     */
    private String searchStringForSort;
    
    public String objectType {get; set;}
    
    private Boolean needGvwFilter = false;
    private Boolean isGvw = false;
    
    public String objectLabel {get; private set;}
    
    /**
     * Comma-separated list of API fieldnames included into query,
     * eg. 'Name,MyCustomField__c'. Shouldn't include Id field 
     * - it's always included.
     */
    private String queryFields;
    
    public List<String> displayFields {get;set;}
    
    public String sortField {
      	get;
        set {
        	if (value == sortField) {
        		sortDir = (ASCENDING_ORDER == sortDir) ? DESCENDING_ORDER : ASCENDING_ORDER;
        	} else {
        		sortDir = ASCENDING_ORDER;
        	}
        	sortField = value;
        }
  	}
  	
    public String sortDir {get; private set;}
    
    private String getSortNulls() {
    	return (ASCENDING_ORDER == sortDir) ? NULLS_FIRST : NULLS_LAST;
    }
    
    private String query;
    
    private Boolean hasActiveField = false;
    
    public Map<String, String> fieldLabels {get; private set;}
    
    /**
     * Used by the VF page to send the link to the right dom element.
     */
    public String getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
 
    /**
     * Used by the VF page to send the link to the right dom element for the text box.
     */
    public String getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }

    // instantiate the StandardSetController from a query locator
    private ApexPages.StandardSetController setController {
        get {
            if (setController == null && query != null) {
                setController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                setController.setPageSize(pageSize);
            }
            return setController;
        }
        set;
    }
    
    public Boolean getHasNext() {
        return setController.getHasNext();
    }
 
    public Boolean getHasPrevious() {
        return setController.getHasPrevious();
    }
 
    /**
     * Wrapper property for ApexPages.StandardSetController.get(set)PageNumber() methods.
     * Mimic SF OOB behaviour:
     * 1) Entered page number (EPN) is a valid page number - go to this page;
     * 2) EPN is not a number - go to the 1st page;
     * 3) EPN is greater than total pages - to to the last page;
     * 4) EPN is less then 1 - go to the 1st page;
     */
    public String pageNumberTxt {
        get {
            return String.valueOf(setController.getPageNumber());
        }
        set {
            Integer intValue = 1;
            try {
               intValue = Integer.valueOf(value);
            } catch (Exception e) {
                // Do nothing, default value will be used.
            }
            if (intValue > getTotalPages()) {
                intValue = getTotalPages();
            } else if (intValue < 1) {
                intValue = 1;
            }
            
            setController.setPageNumber(intValue);
        }
    }
    
    public Integer getResultSize() {
        return setController.getResultSize();
    }
    
    public Integer pageSize {
        get;
        set {
            pageSize = value;
            setController.setPageSize(value);
        }
    }
    
    public Integer getTotalPages() {
        Integer result = 0;
        if (pageSize != 0) {
            result = Integer.valueOf(Math.ceil(1.0*getResultSize()/pageSize)); 
        }
        return result;
    }
    
    public List<SObject> getResults() {
        return setController.getRecords();
    }     
    
    public CRS_CRS_Product__c newProduct {get;set;}
    
    public String inputProductName {get; set;}
    public String inputKOProduct {get; set;}
    
    /**
     * Default constructor.
     */
    public CRS_LookupSingleSelectController() {
       	String gvwParam = System.currentPageReference().getParameters().get('gvw');
    	isGvw = gvwParam == '1';
    
        searchString = System.currentPageReference().getParameters().get('lksrch');
        objectType = System.currentPageReference().getParameters().get('objType');
        applyCustomSettings();
        sortField = DEFAULT_QUERY_FIELDS;
        sortDir = ASCENDING_ORDER;
	    search();
	    pageSize = DEFAULT_PAGE_SIZE;
	    
	    prepareProduct();
    }
    
    /** Action for VF page. Performs the keyword search.
     */
    public PageReference search() {
        runSearch(searchString);
        /* SearchString should be taken into consideration 
           only when "Go" button clicked, 
           not for sorting (as OOB SF behaviour).
        */
        searchStringForSort = searchString;
        return null;
    }
    
    
    /** Action for VF page. Peroforms only sorting.
     */
    public PageReference sort() {
        runSearch(searchStringForSort);
        return null;
    }
 
    /** 
     * Prepare the query.
     */
    private void runSearch(String searchString) {
        // Prevent query injections.
        String safeSearchString = (searchString != null) 
                ? String.escapeSingleQuotes(searchString)
                : null;
        prepareSearch(safeSearchString);
    } 
 
    /** 
     * Build the query string and discard the old ApexPages.StandardSetController reference.
     */ 
    private void prepareSearch(string searchString) {
        query = 'SELECT Id,' + queryFields + ' FROM ' + objectType;
        
        String conditionToken = '';
        
        if (hasActiveField) {
        	conditionToken = 'WHERE';
            query += SPACE + conditionToken + ' Active__c = \'Yes\'';
        }
        
        if (needGvwFilter) {
        	conditionToken = (''.equals(conditionToken)) ? 'WHERE' : 'AND';
        	query += SPACE + conditionToken + ' gvwCRS__c = ' + isGvw;
        }
          
        if(searchString != '' && searchString != null) {
            conditionToken = (''.equals(conditionToken)) ? 'WHERE' : 'AND';
            query += SPACE + conditionToken + ' Name LIKE \'%' + searchString +'%\'';
        }
        
        query += ' ORDER BY ' + sortField + SPACE + sortDir + SPACE + getSortNulls();

        query += ' LIMIT ' + Limits.getLimitQueryLocatorRows();
    
        System.debug(query);
    
        // New query - new controller.
        setController = null;
    }
 
    public void first() {
        setController.first();
    }
 
    public void last() {
        setController.last();
    }
 
    public void previous() {
        setController.previous();
    }
 
    public void next() {
        setController.next();
    }
 
    /**
     * Read setup from Custom Settings.
     * Use defaults if particular settings is not present or wrong.
     */
    private void applyCustomSettings() {
    	queryFields = DEFAULT_QUERY_FIELDS;
    	List<String> fieldCustomLabelsList = new List<String>();
    	
    	CRS_LookupSettings__c settings = CRS_LookupSettings__c.getInstance(objectType);
    	
    	if (settings != null) {
    		queryFields = settings.FieldNames__c;
    		
    		hasActiveField = settings.HasActiveField__c;
    		
    		needGvwFilter = settings.HasGvwFlag__c;
    		
    		String labels = settings.FieldLabels__c;
    		if (labels != null) {
                fieldCustomLabelsList = labels.split(STRING_SEPARATOR);
    		}
    	}
    	
    	displayFields = queryFields.split(STRING_SEPARATOR);
    	prepareLabels(fieldCustomLabelsList);
    }
    
    /**
     * 1) Fills objectLabel property;
     * 2) Prepare map of labels for fields.
     *      a) try to find label in Custom Settings;
     *      b) if a) is not successful, then try to get field label from field describe info;
     *      c) if b) is not successful, then use field name as label
     *         (Eg. such can occur if field is "UserRole.Name" for the User object, so actually field is belonging to another object).
     */
    private void prepareLabels(List<String> customLabelsList) {
        // Prepare map of field labels from Custom Settings.
        Map<String, String> fieldCustomLabels = new Map<String, String>();
        if (customLabelsList != null && customLabelsList.size() > 0) {
            for (Integer i = 0; i <customLabelsList.size(); i++) {
                String fieldName = displayFields[i];
                String customLabel = customLabelsList[i];
                if (customLabel != null && customLabel != FIELD_LABEL_PLACEHOLDER) {
                    fieldCustomLabels.put(fieldName,customLabel);
                } 
            }
        }
    	
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectType);
        
        objectLabel = targetType.getDescribe().getLabel();
        
    	Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
    	fieldLabels = new Map<String, String>();
        for (String fieldName : displayFields) {
            String fieldLabel = fieldCustomLabels.get(fieldName);
            if (fieldLabel == null) {
                Schema.SObjectField sfield = fieldMap.get(fieldName);
                fieldLabel = (sfield != null) 
                        ? sfield.getDescribe().getLabel()
                        : fieldName; 
            } 
            fieldLabels.put(fieldName, fieldLabel);
        }
    }
    
    private void prepareProduct() {
    	newProduct = new CRS_CRS_Product__c();
    	newProduct.Active__c = 'No';
    	newProduct.gvwCRS__c = isGvw;
    	
    	inputProductName = null;
        inputKOProduct = null;
    }
    
    public void submitProduct() {
    	newProduct.KO_Product__c = inputKOProduct;
    	
    	String prodName = inputProductName;
    	
        if (prodName == null  || prodName == '') {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Product Name: You must enter a value'));
        } else {
        	newProduct.Beverage_Product_Name__c = prodName;
        	
	    	if (prodName.length() > MAX_NAME_LENGTH) {
	            prodName = prodName.substring(0,MAX_NAME_LENGTH);
	    	}
	    	newProduct.Name = prodName;
	    	
	    	Boolean isSuccess; 
	    	try {
	            insert newProduct;
	            isSuccess = sendNewProductNotification(newProduct.Id);
	    	} catch (Exception e) {
	    		System.debug('~~~Add new Product from CRS page: exception: ' + e);
	            isSuccess = false;
	    	}
	    	
	        if (isSuccess) {
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.CRS_New_Product_request_successfull));
	            prepareProduct();	
	        } else {
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CRS_New_Product_request_failed));
	        }
        }
    }
    
    private Boolean sendNewProductNotification(String prodId) {
        CRS_NameValueSetup__c setup = CRS_NameValueSetup__c.getInstance(BUSINESS_ADMIN_EMAIL_SETTING_KEY);
        
        String emailAddress = null;
        if (setup != null) {
            emailAddress = setup.Value__c;	
        }
        
        /*
            When we want to use Messaging.SingleEmailMessage.setWhatId() 
            to use CRS Product as merge data, target object must be a Contact. 
        */
        Contact tempContact = new Contact();
        tempContact.Email = emailAddress;
        // Contact's required field(s);
        tempContact.LastName = 'temp';
        insert tempContact;
            
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :NEW_PRODUCT_NOTIFICATION_TEMPLATE];

        Messaging.SingleEmailMessage emailNotification = new Messaging.SingleEmailMessage();
        
        emailNotification.setTemplateId(template.id);                                           
        emailNotification.setTargetObjectId(tempContact.id);
        emailNotification.setWhatId(prodId);
        emailNotification.setBccSender(false);
        emailNotification.setSaveAsActivity(false);
        emailNotification.setUseSignature(false);
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailNotification });
        Messaging.SendEmailResult result = results[0];
            
        delete tempContact;
        return result.isSuccess(); 
    }
  
}