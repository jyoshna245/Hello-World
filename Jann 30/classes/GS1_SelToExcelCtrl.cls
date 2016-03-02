/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept October 30, 2013
* Description  :     A controller class for exporting selected request ids to Excel file.
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
public without sharing class GS1_SelToExcelCtrl {
    //public List<String> idList {get;set;}
    public List<GS1_Request__c> selectedRequests {get;set;}    
    public String filename {get; private set;}
    public string html {get; private set;}
    
    public GS1_SelToExcelCtrl () {
        String so = ApexPages.currentPage().getParameters().get('so');
        String sf = ApexPages.currentPage().getParameters().get('sf');
        String sortOption = '';
        if (!String.isBlank(sf)) sortOption = 'ORDER BY ' + sf;        
        if (!String.isBlank(so)) sortOption += so.toLowerCase()=='descending' ? ' DESC' : '';
        List<String> idList = ApexPages.CurrentPage().getParameters().get('ids').split(',');
        
        html = '';
        
        String objectName = '';
        String fieldName = '';
        String config = Label.GS1_ExportToExcelColumns;
        List<String> fields = new List<String>();
        List<String> columns = config.split(',');
        Map<String,String> colMapping = new Map<String,String>();
        for (String c : columns) {
            if (c.trim().length()>0) {
                String[] colLabel = c.split('\\|');
                fields.add(colLabel[0].trim());
                if (colLabel.size()>1) {
                    colMapping.put(colLabel[0].trim(),colLabel[1].trim());
                } else {
                    colMapping.put(colLabel[0].trim(),colLabel[0].trim());
                }               
            }
        }   
        
        
        String query = 'SELECT ';
        query+= String.join(fields,',');
        query+= ' FROM GS1_Request__c WHERE Id IN:this.idList ' + sortOption + ' LIMIT 1000' ;
                       
        try {
            system.debug( 'query ??? ' + query ) ; // added by jeevan D 
            this.selectedRequests = database.query(query);
        }        
        catch (Exception ex) {
            html = 'Error fetching data. Please contact your System Administrator.';
            return;
        }
        
        if ( this.selectedRequests.size()>0) {
            
            html += '<table><tr>';
            for (String c : fields) {
                html+='<td><b>' + colMapping.get(c) + '</b></td>';
            } 
            html += '</tr>';
            
            for (GS1_Request__c req : this.selectedRequests) {
                html += '<tr>';
                for (String c : fields) {
                    String data = '';
                    if (c.contains('.')) {
                        List<string> foPair = c.split('\\.');
                        if (foPair.size()>0) {
                            objectName = foPair[0].toupperCase().trim();
                            fieldName = foPair[1].trim();
                            if (!String.isBlank(objectName) && !String.isBlank(fieldName)) {
                                if (objectName=='APPROVED_BY__R' && req.APPROVED_BY__R!=null) {data=resolveData(req.APPROVED_BY__R.get(fieldName));}
                                else if (objectName=='AUTHOR_PROFILE__R' && req.AUTHOR_PROFILE__R!=null) {data=resolveData(req.AUTHOR_PROFILE__R.get(fieldName));}
                                else if (objectName=='BBN__R' && req.BBN__R!=null) {data=resolveData(req.BBN__R.get(fieldName));}
                                else if (objectName=='CAPACITY__R' && req.CAPACITY__R!=null) {data=resolveData(req.CAPACITY__R.get(fieldName));}
                                else if (objectName=='COUNTRY__R' && req.COUNTRY__R!=null) {data=resolveData(req.COUNTRY__R.get(fieldName));}
                                else if (objectName=='CREATEDBY' && req.CREATEDBY!=null) {data=resolveData(req.CREATEDBY.get(fieldName));}
                                else if (objectName=='DESIGN__R' && req.DESIGN__R!=null) {data=resolveData(req.DESIGN__R.get(fieldName));}
                                else if (objectName=='EAN_CODE__R' && req.EAN_CODE__R!=null) {data=resolveData(req.EAN_CODE__R.get(fieldName));}
                                else if (objectName=='FLAVOUR__R' && req.FLAVOUR__R!=null) {data=resolveData(req.FLAVOUR__R.get(fieldName));}
                                else if (objectName=='LASTMODIFIEDBY' && req.LASTMODIFIEDBY!=null) {data=resolveData(req.LASTMODIFIEDBY.get(fieldName));}
                                else if (objectName=='MATERIAL__R' && req.MATERIAL__R!=null) {data=resolveData(req.MATERIAL__R.get(fieldName));}
                                else if (objectName=='MULTIPACK__R' && req.MULTIPACK__R!=null) {data=resolveData(req.MULTIPACK__R.get(fieldName));}
                                else if (objectName=='OWNER' && req.OWNER!=null) {data=resolveData(req.OWNER.get(fieldName));}
                                else if (objectName=='PALLET_DESIGN__R' && req.PALLET_DESIGN__R!=null) {data=resolveData(req.PALLET_DESIGN__R.get(fieldName));}
                                else if (objectName=='PALLET_MATERIAL__R' && req.PALLET_MATERIAL__R!=null) {data=resolveData(req.PALLET_MATERIAL__R.get(fieldName));}
                                else if (objectName=='PROMO_CURRENCY__R' && req.PROMO_CURRENCY__R!=null) {data=resolveData(req.PROMO_CURRENCY__R.get(fieldName));}
                                else if (objectName=='PROMO_OTHER__R' && req.PROMO_OTHER__R!=null) {data=resolveData(req.PROMO_OTHER__R.get(fieldName));}
                                else if (objectName=='PROMO_QUANTITY__R' && req.PROMO_QUANTITY__R!=null) {data=resolveData(req.PROMO_QUANTITY__R.get(fieldName));}
                                else if (objectName=='RECORDTYPE' && req.RECORDTYPE!=null) {data=resolveData(req.RECORDTYPE.get(fieldName));}
                                else if (objectName=='REJECTED_BY__R' && req.REJECTED_BY__R!=null) {data=resolveData(req.REJECTED_BY__R.get(fieldName));}
                                else if (objectName=='REQUESTEDBYUSERID__R' && req.REQUESTEDBYUSERID__R!=null) {data=resolveData(req.REQUESTEDBYUSERID__R.get(fieldName));}
                                else if (objectName=='TRADEMARK__R' && req.TRADEMARK__R!=null) {data=resolveData(req.TRADEMARK__R.get(fieldName));}
                                else if (objectName=='UNIT__R' && req.UNIT__R!=null) {data=resolveData(req.UNIT__R.get(fieldName));}
                                else if (objectName=='UNITS_PACK__R' && req.UNITS_PACK__R!=null) {data=resolveData(req.UNITS_PACK__R.get(fieldName));}
                                else if (objectName=='WITHDRAWN_BY__R' && req.WITHDRAWN_BY__R!=null) {data=resolveData(req.WITHDRAWN_BY__R.get(fieldName));}
                            }                       
                        }                        
                        html+='<td>&nbsp;' + data + '</td>';                        
                    } else {
                        html+='<td>&nbsp;' + resolveData(req.get(c)) + '</td>';
                    }
                }
                html += '</tr>';
            }
            
            html += '</table>';
        }
        this.filename = 'export' + string.valueOf(System.currentTimeMillis()) + '.xls';        
    }
    
    private string resolveData(Object d) {
        String ret = '';
        if ( d != null) {
            ret = String.valueOf(d);
        }
        return ret;
    }
}