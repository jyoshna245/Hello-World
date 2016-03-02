public class CRS_LookupMultiSelectController {
	// Param passed through from popup caller to handler.
	public String inputFieldNameParam {get; set;}
	
	//pre-selected and all selected ids on all pages
	public String selectedIds {get; set;}
	
	private Set<String> selectedIdsSet = new Set<String>();
	
    private final static String NULLS_FIRST = 'NULLS FIRST';
    private final static String NULLS_LAST = 'NULLS LAST';
    private final static String SPACE = ' ';
    private final static String DEFAULT_QUERY_FIELDS = 'Name';
    private final static String FIELD_LABEL_PLACEHOLDER = '-';
    private final static String STRING_SEPARATOR = ',';

    private final static Integer MAX_NAME_LENGTH = 80;
    private final static String NEW_FLAVOR_NOTIFICATION_TEMPLATE = 'CRS_Add_New_Flavor_Notification';
    
    public final static String APPROVERS_TOP_ROLE_SETTING_KEY = 'ApproversTopRoleApiName';
    
    private String userProfileIdsFilter;
    private String userRoleIdsFilter;
    
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
    
    public Boolean isApprovers {get; private set;}
    
    public String objectType {get; set;}
    
    public String businessUnit {get; set;}
    
    private String filterField;
    private String filterValue;
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
        		sortDir = (CRS_LookupSingleSelectController.ASCENDING_ORDER == sortDir)
        		      ? CRS_LookupSingleSelectController.DESCENDING_ORDER
        		      : CRS_LookupSingleSelectController.ASCENDING_ORDER;
        	} else {
        		sortDir = CRS_LookupSingleSelectController.ASCENDING_ORDER;
        	}
        	sortField = value;
        }
  	}
  	
    public String sortDir {get; private set;}
    
    private String getSortNulls() {
    	return (CRS_LookupSingleSelectController.ASCENDING_ORDER == sortDir) ? NULLS_FIRST : NULLS_LAST;
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
    
    public void goToPage() {
    	storeSelection();
        prepareResults();
    }
    
    public void changePageSize() {
        storeSelection();
        prepareResults();
    }
    
    
    public Integer getResultSize() {
        return setController.getResultSize();
    }
    
    public Integer pageSize {
        get {
        	if (pageSize == null) {
        		pageSize = CRS_LookupSingleSelectController.DEFAULT_PAGE_SIZE;
        	}
        	return pageSize;
        }
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
    
    public List<SelectableSObject> results {
    	get {
            if (results == null) {
            	results = new List<SelectableSObject>();
            }
            return results;
    	} 
    	private set;
    }
    
    public Boolean readyForProcess {get; private set;}

    public CRS_Flavor__c newFlavor {get;set;}
    
    public String inputFlavorName {get; set;}
    
    /**
     * Default constructor.
     */
    public CRS_LookupMultiSelectController() {
    	String approversParam = System.currentPageReference().getParameters().get('approvers');
    	isApprovers = approversParam == '1';
    	
    	String gvwParam = System.currentPageReference().getParameters().get('gvw');
    	isGvw = gvwParam == '1';
    	
    	businessUnit = System.currentPageReference().getParameters().get('businessUnit');
    	
    	inputFieldNameParam = System.currentPageReference().getParameters().get('fieldName');
    	selectedIds = System.currentPageReference().getParameters().get('fieldValue');
    	selectedIdsSet = new Set<String>();
    	if (selectedIds != null && selectedIds.length() > 0) {
            selectedIdsSet.addAll(selectedIds.split(';'));
    	}
    	system.debug('~~~preselectedids:'+selectedIds+'~~~');
    	system.debug('~~~preselectedids size:'+selectedIdsSet.size());
    	readyForProcess = false;
    	
        searchString = System.currentPageReference().getParameters().get('lksrch');
        objectType = System.currentPageReference().getParameters().get('objType');
        
        filterField = System.currentPageReference().getParameters().get('filterField');
        filterValue = System.currentPageReference().getParameters().get('filterValue');
        
        if (objectType == 'User') {
       		userRoleIdsFilter = getSuitableRoles();
            userProfileIdsFilter = getSuitableProfiles();
        }
        
        applyCustomSettings();
        sortField = DEFAULT_QUERY_FIELDS;
        sortDir = CRS_LookupSingleSelectController.ASCENDING_ORDER;
	    search();
	    
	    prepareFlavor();
	    
	    
	    //CRS Enhancement - FR 8
	    system.debug(selectedIds+'results++++');
	    if(objectType == 'CRS_Type__c' && selectedIds.length() > 0){
	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, '<span style="color:red;font-weight:bold;">Updating CRS Type will require Dossier modification and will redirect to Dossier page up on saving the record.</span>'));
	    }
	    //
    }
    
    /** Action for VF page. Performs the keyword search.
     */
    public PageReference search() {
    	storeSelection();
        runSearch(searchString);
        prepareResults();
        
        /*"Search" should reset selected items.
        selectedIdsSet = new Set<String>();*/
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
    	storeSelection();
        runSearch(searchStringForSort);
        prepareResults();
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
        if (objectType == 'User' && (userRoleIdsFilter == null || userProfileIdsFilter == null)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CRS_Approvers_filtering_by_Role_and_Profile_failed));        	
        }
        
    } 
 
    /** 
     * Method checks whether the user is Admin.
     */
    private boolean isAdminProfile(boolean sysAdminOnly) {
		boolean isCRSBA = !([select Id from Profile where Id = :UserInfo.getProfileId() and Name = :CRS_CRSEdit.getBAProfileName()].isEmpty());
		boolean isCRSSA = !([select Id from Profile where Id = :UserInfo.getProfileId() and Name = :CRS_CRSEdit.getSAProfileName()].isEmpty());
		if(sysAdminOnly){
		  return isCRSSA;
		} else {
		  return (isCRSSA || isCRSBA);
		}
	}
        
    /** 
     * Method returns business unit name.
     */
    public String getCRSBusinessUnitName() {
        LIST<CRS_Business_Unit__c> CRSBusinessUnitNames = [select Name from CRS_Business_Unit__c where Id=:businessUnit limit 1];
        if(!CRSBusinessUnitNames.isEmpty()){
            return CRSBusinessUnitNames[0].Name;
        } else {
        	return null;
        }
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
        
        // Filter param
        // e.g. Business_Unit__c = CRS__c.Business_Unit__c
        if (filterField != null && filterValue != null & filterValue != '') {
        	conditionToken = (''.equals(conditionToken)) ? 'WHERE' : 'AND';
        	query += SPACE + conditionToken + SPACE + filterField + ' = \'' + String.escapeSingleQuotes(filterValue) + '\'';
        }
        
        // Filtering for Approvers. Multiselect popup with User type is for approvers fields only.
        // Select Users with specific roles or profiles.
        if (objectType == 'User' && userRoleIdsFilter != null && userProfileIdsFilter != null) {
        	conditionToken = (''.equals(conditionToken)) ? 'WHERE' : 'AND';
            if (isAdminProfile(true) || (isAdminProfile(false) && businessUnit == '')) {            
        	query += SPACE + conditionToken + SPACE + '(UserRoleId IN (' + userRoleIdsFilter + ')'
                    + ' OR ProfileId IN (' + userProfileIdsFilter + '))';
            } else {
                 query += SPACE + conditionToken + SPACE + (isGvw ? 'Id IN (SELECT User__c FROM CRS_Role__c WHERE gvw' : 'Id IN (SELECT User__c FROM CRS_Role__c WHERE ') + inputFieldNameParam + '= \'Yes\'';
                 String buName = getCRSBusinessUnitName();
                 conditionToken = (''.equals(conditionToken)) ? 'WHERE' : 'AND';
                 query += SPACE + conditionToken + SPACE + 'Business_Unit__r.Business_Unit_External_Id__c LIKE \'' + buName + '\')';
            }
        }
        
        query += ' ORDER BY ' + sortField + SPACE + sortDir + SPACE + getSortNulls();
        
        query += ' LIMIT ' + Limits.getLimitQueryLocatorRows();
    
        System.debug(query);
    
        // New query - new controller.
        setController = null;
    }

    /**
     * Returns comma-separated list of UserRole ids surrounded with single quotes
     * E.g. "'xxx','yyy','zzz'".
     * Returns null if CustomSettings or top Role cannot be found.
     */
    private static String getSuitableRoles() {
        CRS_NameValueSetup__c roleSetup = CRS_NameValueSetup__c.getInstance(APPROVERS_TOP_ROLE_SETTING_KEY);
        String result = null;

        if (roleSetup != null) {
	        String topRoleName = roleSetup.Value__c;
	        
	        List<UserRole> rolesList = [SELECT Id FROM UserRole WHERE DeveloperName = :topRoleName];
	        if (rolesList.size() == 1) {
                ID topRoleId = rolesList[0].Id;
                
                Set<ID> roleIds = new Set<ID> {topRoleId};
                roleIds.addAll(getAllSubRoleIds(roleIds));
            
                result = '';
                for (ID roleId : roleIds) {
                    result += '\'' + roleId + '\',';
                }
            
                // Remove last comma
                if (result.length() > 0) {
                    result = result.substring(0,result.length()-1);
                }
	        }
        } 

    	return result;
    }
    
    /**
     * Returns ids of all Roles below given roles in hierarchy.
     */
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        Set<ID> currentRoleIds = new Set<ID>();
        for(UserRole userRole :[SELECT Id FROM UserRole WHERE ParentRoleId IN :roleIds AND ParentRoleID != null]) {
            currentRoleIds.add(userRole.Id);
        }
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
    }
    
    /**
     * Returns comma-separated list of Profile ids surrounded with single quotes
     * E.g. "'xxx','yyy','zzz'".
     * Returns null if CustomSettings or Profiles cannot be found.
     */
    private static String getSuitableProfiles() {
        String systemAdminName = CRS_CRSEdit.getSAProfileName();
        String businessAdminName = CRS_CRSEdit.getBAProfileName();
    	
    	String result = null;
    	
    	if (systemAdminName != null && businessAdminName != null) {
	    	List<String> profileNames = new String[]{systemAdminName, businessAdminName};
	    	
	    	List<Profile> profiles = [SELECT Id FROM Profile WHERE Name IN :profileNames];
	    	if (profiles.size() == 2) {
    	    	result = '';
                for (Profile p : profiles) {
                    result += '\'' + p.Id + '\',';
                }
	    	
                // Remove last comma
	           	if (result.length() > 0) {
    	    		result = result.substring(0,result.length()-1);
                }
	    	}
    	}
    	
        return result;
    }
 
    public void first() {
    	storeSelection();
        setController.first();
        prepareResults();
    }
 
    public void last() {
    	storeSelection();
        setController.last();
        prepareResults();
    }
 
    public void previous() {
    	storeSelection();
        setController.previous();
        prepareResults();
    }
 
    public void next() {
        storeSelection();
        setController.next();
        prepareResults();
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
    
    /**
     * Wrapper object with selection status.
     */
    public class SelectableSObject {
    	public Boolean selected {get; set;}
    	public SObject obj {get; set;}
    }
    
    /**
     * Store selection made on last visited page.
     */
    private void storeSelection() {
        List<SelectableSObject> pageResult = results;
        
        for (SelectableSObject item : pageResult) {
            String itemId = (String) item.obj.get('Id');
            if (selectedIdsSet.contains(itemId)) {
                if (!item.selected) {
                    selectedIdsSet.remove(itemId);
                }
            } else {
                if (item.selected) {
                    selectedIdsSet.add(itemId);
                }
            }
        }    	
    }
    
    /**
     * Prepare wrappers for results.
     */
    private void prepareResults() {
        List<SObject> rawResults = setController.getRecords();
        List<SelectableSObject> wrappers = new List<SelectableSObject>();
        for (SObject obj : rawResults) {
            SelectableSObject wrapper = new SelectableSObject();
            wrapper.obj = obj;
            wrapper.selected = selectedIdsSet.contains(obj.Id);
            wrappers.add(wrapper);
        }
        
        results = wrappers;
    }
    
    public void clearSelected() {
    	selectedIdsSet = new Set<String>();
    }
    
    public void applySelection() {
    	storeSelection();
    	selectedIds = '';
    	for (String selectedId : selectedIdsSet) {
    		selectedIds += selectedId + ';';
    	}
    	readyForProcess = true;
    }

    private void prepareFlavor() {
        newFlavor = new CRS_Flavor__c();
        newFlavor.Active__c = 'No';
        newFlavor.gvwCRS__c = isGvw;
        
        inputFlavorName = null;
    }
    
    public void submitFlavor() {
        String flavorName = inputFlavorName;
        
        if (flavorName == null || flavorName == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Flavor Name: You must enter a value'));
        } else {
        	newFlavor.Flavor_Name__c = flavorName;
        	
	        if (flavorName.length() > MAX_NAME_LENGTH) {
	            flavorName = flavorName.substring(0,MAX_NAME_LENGTH);
	        }
	        newFlavor.Name = flavorName;
	        
	        Boolean isSuccess;
	        try {
		        insert newFlavor;
		        isSuccess = sendNewFlavorNotification(newFlavor.Id);
		    } catch (Exception e) {
	    		System.debug('~~~Add new Flavor from CRS page: exception: ' + e);
	            isSuccess = false;
	    	}
	        
	        if (isSuccess) {
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.CRS_New_Flavor_request_successfull));
	            prepareFlavor();	
	        } else {
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CRS_New_Flavor_request_failed));
	        }
        }
    }
    
    private Boolean sendNewFlavorNotification(String flavorId) {
        CRS_NameValueSetup__c setup = CRS_NameValueSetup__c.getInstance(CRS_LookupSingleSelectController.BUSINESS_ADMIN_EMAIL_SETTING_KEY);

        String emailAddress = null;
        if (setup != null) {
            emailAddress = setup.Value__c;	
        }
        
        /*
            When we want to use Messaging.SingleEmailMessage.setWhatId() 
            to use CRS Flavor as merge data, target object must be a Contact. 
        */
        Contact tempContact = new Contact();
        tempContact.Email = emailAddress;
        // Contact's required field(s);
        tempContact.LastName = 'temp';
        insert tempContact;
            
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :NEW_FLAVOR_NOTIFICATION_TEMPLATE];

        Messaging.SingleEmailMessage emailNotification = new Messaging.SingleEmailMessage();
        
        emailNotification.setTemplateId(template.id);                                           
        emailNotification.setTargetObjectId(tempContact.id);
        emailNotification.setWhatId(flavorId);
        emailNotification.setBccSender(false);
        emailNotification.setSaveAsActivity(false);
        emailNotification.setUseSignature(false);
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailNotification });
        Messaging.SendEmailResult result = results[0];
            
        delete tempContact;
        return result.isSuccess(); 
    }

}