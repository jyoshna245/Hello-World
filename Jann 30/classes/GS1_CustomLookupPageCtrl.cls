/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     A (controller) class used to provide custom/enhanced lookup functionality for GS1 objects
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*/

public with sharing class GS1_CustomLookupPageCtrl {
    private final integer  MAX_RECORDS = 100;
    private GS1_LookupDefinition def;  
    private String objectName = '';
    
    private String luSourceObjectPrefix = '';
    private String luCurrentFldVal = '';
    private String luFilterValues = '';
    private String luTargetField = '';
    private String luReturnFieldName = '';
    private String luCurrentObjectId = '';
    private Boolean isQueryByLetter = false;    
    
    private void setParameters() {
        String value = '';
        Map<String,String> params = ApexPages.currentPage().getParameters();
        this.luSourceObjectPrefix = params.get('ObjectPrefix');
        this.luCurrentFldVal = params.get('CurrentValue');
        this.luFilterValues = params.get('FilterValues');
        this.luTargetField = params.get('CurrentField');
        this.luCurrentObjectId = params.get('CurrentObjectId');
        value = params.get('CountPerFetch');
        
        if (!String.isBlank(value)) {
            try {
                this.countPerFetch = integer.valueOf(value);
            } catch (Exception e) {                 
            }
        }
        
        value = params.get('dlgHeight');
        if (!String.isBlank(value)) {
            try {
                this.dialogHeight = integer.valueOf(value);
            } catch (Exception e) {                 
            }
        }
        
        value = params.get('dlgWidth');
        if (!String.isBlank(value)) {
            try {
                this.dialogWidth = integer.valueOf(value);
            } catch (Exception e) {                 
            }
        }                                      
    }
    
    private List<String> getFilterValues() {        
        List<String> filterValues = (List<String>)JSON.deserialize(this.luFilterValues, List<String>.class);
        List<String> ret = new List<String>();
        
        if (filterValues !=null) {
            integer size = filterValues.size();
            if (size>0) {
                for (integer i=1; i<size; i++) {
                    ret.add(filterValues[i]);
                }
            }    
        }
        
        return ret;
    }
        
    public GS1_CustomLookupPageCtrl() {
        
        this.countPerFetch = MAX_RECORDS;
        this.dialogHeight = 500;
        this.dialogWidth = 700;
                               
        setParameters();
        
        this.searchKey = luCurrentFldVal;
        
        String currentObjectName = GS1_CommonFunctions.getObjectNameByPrefix(luCurrentObjectId);        
        
        if (currentObjectName != null) {
            if (currentObjectName.trim() != '') {
                currentObjectName += '-';
            }
        } else {
            currentObjectName = '';
        }
        
        if (luSourceObjectPrefix == 'StandardUserLookup') {
            objectName = 'User';
        } else {
            objectName = GS1_CommonFunctions.getObjectNameByPrefix(luSourceObjectPrefix);
        }                
        
        Map<String, GS1_LookupDefinitions__c> lookupMapSettings = GS1_LookupDefinitions__c.getAll();
        GS1_LookupDefinitions__c luDef = lookupMapSettings.get(currentObjectName + this.objectName);
        if (luDef == null) {
            luDef = lookupMapSettings.get(this.objectName);
            
            if (luDef != null) {
                if (!luDef.Active__c) {
                    luDef = null;
                }
            }
                                    
        } else {
            if (!luDef.Active__c) {
                luDef = null;
            }           
        }
        
        if (luDef != null) {
            String value;
            this.def = new GS1_LookupDefinition(this.objectName, luDef.Display_Fields__c);
            
            value = luDef.Fixed_Filter_Expression__c;
            if ( value != null) {
                if (value.trim() != '') {
                    def.setFixedFilterExpression(value);
                }
            }
            
            value = luDef.Variable_Filter_Expression__c;
            if ( value == null) { value = ''; }
                
            if (currentObjectName != '' && value.trim()!='') {
                List<String> filterValues = getFilterValues();
                if (filterValues.size()>0) {
                    def.setVarFilter(value, filterValues);
                }
            }            
        } else {
            this.def = new GS1_LookupDefinition(this.objectName, 'Name');
            if (def.hasField('IsDeleted')) {
                def.setFixedFilterExpression('IsDeleted=false');
            } else if (def.hasField('IsActive')) {
                def.setFixedFilterExpression('IsActive=true');  
            }
        }   
        
        //default filter field               
        this.filterField = 'Name';
        this.recordCount = 0; 
        this.setRecordCount();       
        this.lastOffset = 0;              
    }     
    
    public String searchKey {get;set;}
    public String selectedLetter{get;set;}
    public String filterField {get;set;}    
    
    public boolean disablePrevButton {get;private set;}
    public boolean disableNextButton {get;private set;}
    public String debugString{get ; set;}      
    public integer recordCount {get;private set;}  
    public integer lastOffset {get; private set;}
    public integer countPerFetch {get; private set;}
    public integer lastFetchCount {get; private set;}
    public integer dialogWidth {get; private set;}
    public integer dialogHeight {get; private set;}
    
    private boolean getShowPreviousPage() {
        return this.lastOffset > 0;
    }
    
    private boolean getShowNextPage() {
        
        return (this.lastOffset + this.countPerFetch) < this.recordCount;       
        
    }
    
    public List<selectOption> getFieldOptions() {
        List<selectOption> options = new List<selectOption>();
        String label;
        if (def != null) {
            List<String> fieldNames = def.getListFields().split(',');
            for (String f : fieldNames) {
                label = def.getFieldLabel(f);
                if (label == null) label = f;
                options.add(new selectOption(f,label));
            }
        }
        return options;
    }
    
    public Apexpages.Pagereference nextPage() {
        if (this.lastOffset<2000) {
            this.lastOffset += this.countPerFetch;
            if (this.lastOffset > 2000) this.lastOffset = 2000;
        }        
        return null;
    }
    
    public Apexpages.Pagereference previousPage() {
        this.lastOffset -= this.countPerFetch;
        return null;
    }
    
    public Apexpages.Pagereference refresh() {
        return null;
    }    
    
    public Apexpages.Pagereference queryByLetter() {
        this.isQueryByLetter = true;     
        this.searchKey = '';
        this.lastOffset = 0;
        
        this.setRecordCount();      
            
        return null;
    }    
    
    public Apexpages.Pagereference queryBySearchKey() {
        this.isQueryByLetter = false;
        this.selectedLetter = '';        
        this.lastOffset = 0;
        
        this.setRecordCount();  
                        
        return null;
    }    
    
    public Apexpages.Pagereference resetSearch() {
        this.isQueryByLetter = false;        
        this.filterField = 'Name';
        this.searchKey = '';
        this.selectedLetter = '';
        this.lastOffset = 0;    
        this.setRecordCount();
        return null;
    }       
    
    private void setRecordCount() {
        String query = this.buildQuery(true);
                
        this.recordCount = database.countQuery(query);
        this.debugString = query;       
    }
    
    private string buildQuery(boolean isCount) {
        String filter = '';         
        String filter2 = this.def.getFilterExpression();
        String query = isCount ? 'SELECT count() FROM ' + def.getObjectName(): this.def.getSelectExpression();        

        if ( this.def.getFieldType(this.filterField)=='TEXT') {
            if (this.isQueryByLetter) filter = this.selectedLetter==null || this.selectedLetter=='' ? '' : '(' + this.filterField + ' LIKE \'' + String.escapeSingleQuotes(this.selectedLetter) + '%\')';
            if (!this.isQueryByLetter) filter = this.searchKey==null || this.searchKey==''  ? '' : '(' + this.filterField + ' LIKE \'' + String.escapeSingleQuotes(this.searchKey).replace('*','%').replace('?','_') + '%\')';          
        } else if ( this.def.getFieldType(this.filterField)=='NUMBER') {
            if (this.isQueryByLetter) filter = this.selectedLetter==null || this.selectedLetter=='' ? '' : '(' + this.filterField + ' = ' + String.escapeSingleQuotes(this.selectedLetter) + ')';
            if (!this.isQueryByLetter) {
            	this.searchKey = this.searchKey.replaceAll('[^0-9]','');
            	
            	if (this.searchKey==null || this.searchKey=='') {
            		filter = '';            	
            	} else {
            		filter = '(' + this.filterField + ' = ' + String.escapeSingleQuotes(this.searchKey) + ')';
            	}
            }              
        } else if ( this.def.getFieldType(this.filterField)=='ID') {
        	if (!String.isBlank(this.searchKey)) {
        		if (this.searchKey.length()==15||this.searchKey.length()==18) filter = '(' + this.filterField + ' = \'' + String.escapeSingleQuotes(this.searchKey) + '\')';
        		else filter = '(' + this.filterField + ' = \'000000000000000\')'; 
        	}
        }
                        
        if (filter.trim() != '' && filter2.trim() != '') {
            filter = '(' + filter + ' AND ' + filter2 + ')';            
        } else {
            if (filter.trim() == '') filter = filter2; 
        }       
        
        if (filter.trim() != '') query += ' WHERE (' + filter + ')';
                
        query += isCount ? ' LIMIT 10000' : ' ORDER BY ' + this.filterField;
        
        return query;        
                    
    } 
    
    
    public string getLetterButtonsHTML() {
        String[] letters = 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z'.split(' ');
        String[] numbers = '1 2 3 4 5 6 7 8 9 0'.split(' ');
        String html = '';        

		if (this.def.getFieldType(this.filterField)=='TEXT') {        
	        for (String l : letters) {
	            if (this.selectedLetter == l) {
	            	html+= '<input class="btn letterButtonSelected" type="button" value="'+ l + '" onclick="queryByLetter(this);"/>';          	                
	            } else {
	            	html+= '<input class="btn letterButton" type="button" value="'+ l + '" onclick="queryByLetter(this);"/>';                
	            }
	        }
		} else {
			html+= '<input class="btn letterButton" style="visibility:hidden;" type="button" value="X"';
			html+= '<span style="color:#515151;">Selected filter field is not text and cannot be filtered by letters</span>';
		}
        return html;
    }
    
    public string getHTML() {    
        Integer count = this.lastOffset;    
        String html = '';
        String content = '';
        String link = '';
        Boolean hasResult = false;
        String query = '';
        if (def == null) return '';
        
        String limitString = 'LIMIT ' + string.valueOf(this.countPerFetch);
        String offsetString = this.lastOffset > 0 ? 'OFFSET ' + string.valueOf(this.lastOffset) : '';
        
        query = this.buildQuery(false);
        
        if (query.trim() == '') {
            return '';
        }
                
        if (limitString.trim() != '') query+= ' ' + limitString;        
        
        if (offsetString.trim() != '') query+= ' ' + offsetString;        
        
        List<String> fieldNames = def.getListFields().split(',');                
                       
        //sObject[] items = database.query( query );                     

        for (sObject o : database.query( query )) {
            String onClick = 'onclick="pick(';
                onClick +=  '\'' + luTargetField + '\','; 
                onClick +=  '\'' + o.get('id') + '\',';
                onClick +=  '\'' + String.valueOf(o.get('name')).replace('\'','\\\'').replace('"','&quot;') + '\'';
                onClick += ');"';
                content+= '<tr class="dataRow" ' + onClick + '>';
            for (String f : fieldNames) {
                content+='<td class="dataCell">' + (o.get(f)==null ? '' : o.get(f)) + '</td>';
            }
            content+= '</tr>';
            
            hasResult = true;
            count++;
        }
        
        if (hasResult) {
                        
            html = '<table class="list">';
            html+= '<thead>';
            html+= '<tr class="headerRow">';
            for (String f : fieldNames) {
                if (f=='') continue;
                String label = def.getFieldLabel(f);
                if (label !=null) {
                    html+='<th class="zen-deemphasize">' + label + '</th>';
                } else {
                    html+='<th class="zen-deemphasize">' + f + '</th>';
                }           
            }
            html+= '</tr></thead>';
            
            html+= '<tbody>' + content + '</tbody></table>';    
        }  else {
            html = '<div class="noresult">Search yielded no result!</div>';
        }
                
        
        this.disableNextButton = !this.getShowNextPage();
        this.disablePrevButton = !this.getShowPreviousPage();
        this.lastFetchCount = count;
        
        return html;
        
    }
}