public with sharing class CreateReportRequestExtension {

    
    public Report_Request__c reportRequest{get;set;}
    public Report_Type__c reportType{get;set;}
    private Map<Id,Report_Type__c> reportTypeMap{get;set;}
    public List<Case> hierarchyCaseFilters{get;set;}
    public List<SelectOption> reportTypes{get;set;}
    public String selectedReportTypeId{
        get;
        set {
            this.reportType = reportTypeMap.get(value);
            this.selectedReportTypeId = value;    
        }
    }
    

    

    public CreateReportRequestExtension(ApexPages.StandardController stdController) {
        this.reportRequest = (Report_Request__c)stdController.getRecord();
        initialize();
    }
    
    private void initialize() {
        this.reportTypes = new List<SelectOption>();
        this.reportTypeMap = new Map<Id,Report_Type__c>([SELECT Id,Name,Template_Id__c,Supports_Multi_Period__c,Subtitle__c,Filename__c,(SELECT Id,Query_Id__c,Query_Alias__c,Query_Filter__c,Report_Type__c FROM Report_Type_Queries__r) FROM Report_Type__c WHERE Active__c = TRUE]);
        for(Report_Type__c reportType : reportTypeMap.values()) {
           this.reportTypes.add(new SelectOption(reportType.Id,reportType.Name));
           if(String.isBlank(this.selectedReportTypeId)) selectedReportTypeId = this.reportTypes[0].getValue();
        }
        
        this.hierarchyCaseFilters = new List<Case>();
        addHierarchyFilter();
        
    }
    
    
    public void addHierarchyFilter() {
        this.hierarchyCaseFilters.add(new Case());
    }
    
    public void clearHierarchyFilters() {
        this.hierarchyCaseFilters = new List<Case>();
        addHierarchyFilter();
    }
    
    public void deleteHierarchyFilter() {
        if(this.currentFilterIndex >= 0) this.hierarchyCaseFilters.remove(this.currentFilterIndex);
    }
    
    public Integer currentFilterIndex{get;set;}
    
    private String generateHierarchyFilterString() {
        String hierarchyFilterString = '';
		hierarchyFilterString += ' (';
        for(Case c : this.hierarchyCaseFilters) {
        	String filter = '(';    
            if(!String.isBlank(c.Business_Unit_Bottling_Company__c)) {
    
                filter += ' Business_Unit_Bottling_Company__c = \'';
                filter += c.Business_Unit_Bottling_Company__c;
                filter += '\' ';
            }
            if(!String.isBlank(c.Group__c)) {
                if(filter != '(') filter += ' AND ';
                filter += ' Group__c = \'';
                filter += c.Group__c;
                filter += '\' ';
            }    
            if(!String.isBlank(c.SBU__c)) {
                if(filter != '(') filter += ' AND ';
                filter += ' SBU__c = \'';
                filter += c.SBU__c;
                filter += '\' ';
            }   
            if(!String.isBlank(c.Location_Function__c)) {
                if(filter != '(') filter += ' AND ';
                filter += ' Location_Function__c = \'';
                filter += c.Location_Function__c;
                filter += '\' ';
            }            
			filter += ')';
			if(hierarchyFilterString != ' (') hierarchyFilterString += ' OR ';
            hierarchyFilterString += filter;
            
        }
		hierarchyFilterString += ')';

        
        return (!String.isBlank(hierarchyFilterString.replace('(','').replace(')','').trim()) ? hierarchyFilterString : null);
    }
    
    public PageReference save() {
    
        reportRequest.Report_Header__c = reportType.Name;
        
        reportRequest.Report_Subtitle__c = mergeFields(reportType.Subtitle__c);
        reportRequest.OFN__c = mergeFields(reportType.Filename__c);
        reportRequest.Conga_URL_String__c = generateCongaQueryString(reportType);

        Database.SaveResult result = Database.insert(reportRequest);
        return new PageReference('/'+result.getId());
    }
    
    private String generateCongaQueryString(Report_Type__c reportType) {
        String congaQueryString = '';
        congaQueryString += '&TemplateId=' + reportType.Template_Id__c;
        congaQueryString += '&QueryId=';
        boolean addComma = false;
        for(Report_Type_Query__c query : this.reportTypeMap.get(reportType.Id).Report_Type_Queries__r) {
            if(addComma) congaQueryString += ',';
            congaQueryString += '[' + query.Query_Alias__c + ']' + query.Query_Id__c; 
            congaQueryString += '?pv0=' + generateCombinedFilters(query);   
            addComma = true;
        }
        return congaQueryString;
    }
    
    
    
    private Map<String,String> mergeMap{get;set;}
    private void initializeMergeMap() {
        this.mergeMap = new Map<String,String>();

        //PERIOD_START
        String periodStart = DateTime.newInstance(reportRequest.Reporting_Period_Start__c.year(), reportRequest.Reporting_Period_Start__c.month(), reportRequest.Reporting_Period_Start__c.day()).format('yyyy-MM-dd');
        this.mergeMap.put('{PERIOD_START}',periodStart);
        
        //PERIOD_END
        String periodEnd = DateTime.newInstance(reportRequest.Reporting_Period_End__c.year(), reportRequest.Reporting_Period_End__c.month(), reportRequest.Reporting_Period_End__c.day()).format('yyyy-MM-dd');
        this.mergeMap.put('{PERIOD_END}',periodEnd);

        //PERIOD_START_HEADING
        String periodStartHeading = DateTime.newInstance(reportRequest.Reporting_Period_Start__c.year(), reportRequest.Reporting_Period_Start__c.month(), reportRequest.Reporting_Period_Start__c.day()).format('MM/dd/yyyy');
        this.mergeMap.put('{PERIOD_START_HEADING}',periodStartHeading);
        
        //PERIOD_END_HEADING
        String periodEndHeading = DateTime.newInstance(reportRequest.Reporting_Period_End__c.year(), reportRequest.Reporting_Period_End__c.month(), reportRequest.Reporting_Period_End__c.day()).format('MM/dd/yyyy');
        this.mergeMap.put('{PERIOD_END_HEADING}',periodEndHeading);
        

        if(reportRequest.Reporting_Period_2_Start__c != NULL) {
            //PERIOD2_START
            String period2Start = DateTime.newInstance(reportRequest.Reporting_Period_2_Start__c.year(), reportRequest.Reporting_Period_2_Start__c.month(), reportRequest.Reporting_Period_2_Start__c.day()).format('yyyy-MM-dd');
            this.mergeMap.put('{PERIOD2_START}',period2Start);

            //PERIOD2_START_HEADING
            String period2StartHeading = DateTime.newInstance(reportRequest.Reporting_Period_2_Start__c.year(), reportRequest.Reporting_Period_2_Start__c.month(), reportRequest.Reporting_Period_2_Start__c.day()).format('MM/dd/yyyy');
            this.mergeMap.put('{PERIOD2_START_HEADING}',period2StartHeading);

        }

        if(reportRequest.Reporting_Period_2_End__c != NULL) {
            //PERIOD2_END
            String period2End = DateTime.newInstance(reportRequest.Reporting_Period_2_End__c.year(), reportRequest.Reporting_Period_2_End__c.month(), reportRequest.Reporting_Period_2_End__c.day()).format('yyyy-MM-dd');
            this.mergeMap.put('{PERIOD2_END}',period2End);
                   

            
            
            //PERIOD2_END_HEADING
            String period2EndHeading = DateTime.newInstance(reportRequest.Reporting_Period_2_End__c.year(), reportRequest.Reporting_Period_2_End__c.month(), reportRequest.Reporting_Period_2_End__c.day()).format('MM/dd/yyyy');
            this.mergeMap.put('{PERIOD2_END_HEADING}',period2EndHeading);
        }
    }
    
    private String mergeFields(String text) {
        try {
            if(this.mergeMap == null) initializeMergeMap();        
            String mergedText = text;
            for(String mergeField : this.mergeMap.keySet()) {
                mergedText = mergedText.replace(mergeField,this.mergeMap.get(mergeField));
            }
            return mergedText;      
        }catch(Exception e) {
            return text;
        } 

    }
    
    private String generateCombinedFilters(Report_Type_Query__c query) {
        String hierarchyFilter = generateHierarchyFilterString();
        System.debug(hierarchyFilter);
        //String queryFilter = '(';
        String queryFilter = '';    
        queryFilter += (!String.isBlank(hierarchyFilter) ? hierarchyFilter : '');
        System.debug(queryFilter);
        boolean needsEndParens = false;
        if(queryFilter != '') {
                queryFilter += ' AND (';
                needsEndParens = true;
        }
        queryFilter += mergeFields(query.Query_Filter__c);
        if(needsEndParens) queryFilter += ') ';
        queryFilter = EncodingUtil.urlEncode(queryFilter, 'UTF-8').replace('++','+').replace('+','%20');
        return queryFilter;
    }
}