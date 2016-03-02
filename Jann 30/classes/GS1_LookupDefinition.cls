/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     A class used to define lookup parameters, used in custom lookup
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*
*/

public with sharing class GS1_LookupDefinition {
    private String pFields = '';
    //private String pFilterFields = '';
    private String pObjectName;
    private Map<String, Schema.SObjectField> objectFields;
    private String fixedFilterExpression = '';
    private String varFilterExpression = '';      
    
    public string getFieldType(String f) {
    	String ret = '';
    	Schema.SObjectField fld = objectFields.get(f);
		if (fld != null) {
            Schema.Describefieldresult fldDesc  = fld.getDescribe();
            if (fldDesc.getType() == Schema.Displaytype.String || 
            fldDesc.getType() == Schema.Displaytype.TextArea ||
            fldDesc.getType() == Schema.Displaytype.Combobox ||
            fldDesc.getType() == Schema.Displaytype.Email || 
            fldDesc.getType() == Schema.Displaytype.MultiPicklist || 
            fldDesc.getType() == Schema.Displaytype.Picklist || 
            fldDesc.getType() == Schema.Displaytype.URL)  {
            	ret = 'TEXT';
			} else if (fldDesc.getType() == Schema.Displaytype.Id) {
				ret = 'ID';
			} else if (fldDesc.getType() == Schema.Displaytype.Integer || 
			fldDesc.getType() == Schema.Displaytype.Currency ||
			fldDesc.getType() == Schema.Displaytype.Double ||
			fldDesc.getType() == Schema.Displaytype.Percent) {
				ret = 'NUMBER';
			}
		}    	
		
		return ret;
    }
    
    public String getFieldLabel(String f) {
        String ret = '';
        Schema.SObjectField fld = objectFields.get(f);
        if (fld != null) {
            Schema.Describefieldresult fldDesc  = fld.getDescribe();
            if (fldDesc != null) {
                ret = fldDesc.getLabel();
            }
        }
        
        return ret;
    }
    
    public GS1_LookupDefinition(String objectName, String fieldNames) {
        if (objectName == null) return;
        if (objectName.trim()=='') return;
        this.pObjectName = objectName;        
        
        getObjectFields();
        pFields = refineFields(fieldNames);        
    }    
    
    public void setFixedFilterExpression(String fixedFilterExp) {
         this.fixedFilterExpression = fixedFilterExp;
    }
    
    public void setVarFilter(String expression, List<String> values) {      
        Integer MAX_FILTER = 50;
        Integer i=1;
        
        String exp = expression.replace('"','\'');
        
        if (values==null) return;
        if (values.size() == 0) return;
        
        for (String v : values) {
            exp = exp.replace('{!param' + string.valueOf(i) + '}', v);
            i++;
        }
        
        this.varFilterExpression = exp;
    }
    
    public String getObjectName() {
        return this.pObjectName;
    }
    
    public boolean hasField(String f) {
        Schema.SObjectField fld = objectFields.get(f);
        if (fld != null) { 
            return true;
        } else {
            return false;
        }
    }
    
    boolean getObjectFields() {
        Schema.SObjectType obj = Schema.getGlobalDescribe().get(this.pObjectName);
        Map<String, Schema.SObjectField> fields = null;
        if (obj == null) return false;
        fields = obj.getDescribe().fields.getMap();
        this.objectFields = fields;
        return true;
    }
    
    public string getListFields() {
        return this.pFields;
    }
    
    String refineFields(String fields) {
        if (fields == null) return '';
        if (fields == '') return '';
        List<String> fs = fields.split(',');
        Schema.SObjectField field;
        String trueFields = '';
        for (String f : fs) {
            f = f.trim();
            if (f.indexOf('.')<1) {
                field = objectFields.get(f);
                if (objectFields!=null) {
                    if (trueFields=='') {
                        trueFields = f;
                    } else {
                        trueFields+=',' + f;
                    }
                }
            } else {
                if (trueFields=='') {
                    //trueFields = f;
                } else {
                    //trueFields+=',' + f;
                }                
            }
        }
        
        return trueFields;
    }
    
    public string getSelectExpression() {
        String ret = '';
        if (pFields == '') return ret;
        ret =  'SELECT ' + pFields + ' FROM ' + pObjectName;
        return ret;
    }
    
    public string getFilterExpression() {
        String ret = '';
        if (this.fixedFilterExpression != null) {
            if (this.fixedFilterExpression.trim() != '') {
                ret = '(' + this.fixedFilterExpression + ')';
            }
        }
        
        if (this.varFilterExpression != null) {
            if (this.varFilterExpression.trim() != '') {
                if (ret != '') {
                    ret += ' AND (' + this.varFilterExpression + ')';                   
                }  else {
                    ret = '(' + this.varFilterExpression + ')';
                }
            }
        } 
        
        if (ret != '') ret = '(' + ret + ')';
        return ret;     
    }
}