/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 17, 2013
* Description  :     A (controller) class used to provide custom search functionality for GS1 Request object
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
public with sharing class GS1_CustomSearchCtrl {
    private final integer SF_MAX_RESULT = 1000;
    private final integer DEFAULT_MAX_RESULT = 500;
    private integer MAX_RESULT = DEFAULT_MAX_RESULT;
    GS1_Request__c req = null;
    List<GS1_Request__c> result = null;
    public GS1_CustomSearchCtrl (ApexPages.StandardController controller) {
        String maxResultLabel = Label.GS1_Max_Search_Result;
        if (maxResultLabel.isNumeric()) {
            this.MAX_RESULT = Integer.valueOf(maxResultLabel);
            if (this.MAX_RESULT<=0) {
                MAX_RESULT = DEFAULT_MAX_RESULT;
            } else if (this.MAX_RESULT> SF_MAX_RESULT) {
                MAX_RESULT = DEFAULT_MAX_RESULT;                
            }
        }
        req = (GS1_Request__c) controller.getRecord();
        this.unitsPerCase = null;        
        this.sortField = 'Country__r.Name';
        this.sortOrder = 'Ascending';
        this.status = new List<String>();   
        
        this.isAdminUser = (GS1_CommonFunctions.isGS1Admin(Userinfo.getUserId()) || (Id.ValueOf(userInfo.getProfileId())==Id.ValueOf(Label.GS1_SystemAdministratorId)));     
        
        String srcView = ApexPages.CurrentPage().getParameters().get('v');
                
        if (!String.isBlank(srcView)) {
            if (srcView.indexOf('For Barcode Allocation')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_REQUESTED);
                this.status.add(GS1_Constants.REQUEST_STATUS_APPROVED);                            
            }
            else if (srcView.indexOf('To Send Back')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_ALLOCATED);
            }
            
            else if (srcView.indexOf('By Approval Date')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_ALLOCATED);
            }        
            else if (srcView.indexOf('CU/DU Normal')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_ALLOCATED);
            }
            else if (srcView.indexOf('CU/DU Promotion')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_ALLOCATED);
            }
            else if (srcView.indexOf('Pallet Normal')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_ALLOCATED);
            }
            else if (srcView.indexOf('Pallet Promotion')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_ALLOCATED);
            }                     
            else if (srcView.indexOf('Drafts')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_NEW);            
            }                             
            else if (srcView.indexOf('Waiting Approval')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_REQUESTED);            
            }    
            else if (srcView.indexOf('Rejected')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_REJECTED);            
            }                                           
            else if (srcView.indexOf('Withdrawn')>=0) {
                this.status.add(GS1_Constants.REQUEST_STATUS_WITHDRAWN);            
            }                  
        }

    }
    
    public String unitsPerCase {get;set;}
    public String sortField  {get; set;}
    public String sortOrder {get;set;}
    public List<String>status {get; set;}
    public String resultIds {get; private set;}
    public boolean isAdminUser {get; set;}
    public String  Product {get; set;}
    
    public apexpages.Pagereference startOver() {
        ApexPages.Pagereference pg = new Apexpages.Pagereference(ApexPages.currentPage().getUrl());
        pg.setRedirect(true);
        return pg;
    }
    
    public apexpages.Pagereference execSearch() {
    
       
        if (!String.isBlank(unitsPerCase)) {
            if (!unitsPerCase.isNumeric()) {
                ApexPages.AddMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'Units/Case: Invalid number'));
                return null;
            }            
        }
        
        List<String>stats = this.status;
		//12-Dec/Aldrin: added Request_Type__c in select fields        
        String selectString = 'SELECT description__c, status__c, Country__r.Name, Unit__r.Name, Trademark__r.name, Flavour__r.name, Material__r.name, Design__r.name, Multipack__r.name, Units_Pack__r.Name, Packs_Case__c, Units_Case__c, EAN_Code__r.Name , Capacity__r.Name , BBN__r.Name ,BBN_Short__c, Product_Type__c, Request_Type__c FROM GS1_Request__c';
        String filter = '';
        filter += String.isBlank( req.Country__c ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Country__c=\'' + req.Country__c + '\''; //1
        filter += String.isBlank( req.Trademark__c ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Trademark__c=\'' + req.Trademark__c + '\''; //2
        filter += String.isBlank( req.Flavour__c ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Flavour__c=\'' + req.Flavour__c + '\''; //3
        filter += String.isBlank( req.Unit__c ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Unit__c=\'' + req.Unit__c + '\''; //4
        filter += String.isBlank( req.Material__c ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Material__c=\'' + req.Material__c + '\''; //5
        filter += String.isBlank( req.Design__c ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Design__c=\'' + req.Design__c + '\''; //6
        filter += String.isBlank( req.Multipack__c ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Multipack__c=\'' + req.Multipack__c + '\''; //7
        filter += String.isBlank( req.Units_Pack__c ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Units_Pack__c=\'' + req.Units_Pack__c + '\''; //8
        filter += String.isBlank( String.ValueOf(req.Packs_Case__c)) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Packs_Case__c=' + String.ValueOf(req.Packs_Case__c); //9
        filter += String.isBlank( this.unitsPerCase) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Units_Case__c=' + String.valueOf(this.unitsPerCase); //10
        filter += String.isBlank( req.EAN_Code__c ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'EAN_Code__c=\'' + req.EAN_Code__c + '\''; //11
        
        // added by Jeevan d 12 , 13 , 14 , 15
        filter += String.isBlank( req.Capacity__c) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Capacity__c=\'' + req.Capacity__c+ '\'' ;// 12 
        filter += String.isBlank( req.BBN__c) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'BBN__c=\'' + req.BBN__c+ '\'';// 13 
        filter += String.isBlank( req.BBN_Short__c) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'BBN_Short__c = \'' + req.BBN_Short__c+ '\'';// 14 
        filter += String.isBlank( this.product ) ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Product_Type__c=\'' + this.product+ '\'';// 15 
        
        filter += stats.size()==0 ? '' : (String.isBlank(filter) ? '' : ' AND ') + 'Status__c IN:this.stats '; //16
        
        if (String.isBlank(filter)) {
            ApexPages.AddMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'Provide at least one filter value'));        
            return null;
        }  else {
            if (!String.isblank(this.sortField)) {
                filter += ' ORDER BY ' + this.sortField;                
                if (!String.isblank(this.sortOrder)) {
                    if (this.sortOrder == 'Descending') {
                        filter += ' DESC';
                    }               
                }                
            }
            
            filter += ' limit ' + string.valueOf(MAX_RESULT);
        }
                
        this.result = database.query(selectString + ' WHERE ' + filter);
        Map<Id,GS1_Request__c> reqMap = new Map<Id,GS1_Request__c>(this.result);
        List<Id> ids = new List<Id>(reqMap.keySet());        
        this.resultIds = String.join(ids,',');
        
        FullAccessContext fac = new FullAccessContext();
        this.result = fac.searchRequest(selectString + ' WHERE Id IN (\'' + String.join(ids,'\',\'') + '\')');
        
        if (this.getResultCount()>=MAX_RESULT) {
            ApexPages.AddMessage(new ApexPages.Message( ApexPages.Severity.INFO, 'Maximum result limit reached. You may refine your search for a more streamlined result.'));
        }
        
        if (this.getResultCount() <= 0) {
            ApexPages.AddMessage(new ApexPages.Message( ApexPages.Severity.INFO, 'Did not find a request that match the provided criteria.'));
        }
        
        return null;
    }
    
    public List<GS1_Request__c> getSearchResult() {
        if (this.result!=null) {
            if (this.result.size()==0) {
                this.result = null;                
            }
        }
        return this.result;
    }
    
    public Integer getResultCount() {
        if (this.result != null) {
            return this.result.size();
        } else {
            return 0;
        }
    }
    
    // added method getProductList() - Jeevan 11-24-2014
    
    public List<SelectOption> getProductList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Any--'));
        options.add(new SelectOption('CU/DU','CU/DU'));
        options.add(new SelectOption('Pallet','Pallet')); 
        return options ; 
    }
    
    public List<SelectOption> getStatusList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(GS1_Constants.REQUEST_STATUS_NEW,GS1_Constants.REQUEST_STATUS_NEW));
        options.add(new SelectOption(GS1_Constants.REQUEST_STATUS_REQUESTED,GS1_Constants.REQUEST_STATUS_REQUESTED));
        options.add(new SelectOption(GS1_Constants.REQUEST_STATUS_APPROVED,GS1_Constants.REQUEST_STATUS_APPROVED));
        options.add(new SelectOption(GS1_Constants.REQUEST_STATUS_ALLOCATED,GS1_Constants.REQUEST_STATUS_ALLOCATED));
        options.add(new SelectOption(GS1_Constants.REQUEST_STATUS_WITHDRAWN,GS1_Constants.REQUEST_STATUS_WITHDRAWN));
        options.add(new SelectOption(GS1_Constants.REQUEST_STATUS_REJECTED,GS1_Constants.REQUEST_STATUS_REJECTED));      
        //options.add(new SelectOption(GS1_Constants.REQUEST_STATUS_CANCELLED,GS1_Constants.REQUEST_STATUS_CANCELLED));      
        return options;
    }
    
    public List<SelectOption> getAvailableCountryList() {
        FullAccessContext fac = new FullAccessContext();
        return fac.getCountries( this.isAdminUser );
    }
        
    public List<SelectOption> getSortFieldsList() {

        List<SelectOption> options = new List<SelectOption>();
        Map<String,String> sortFields = new Map<String,String>();
        
        sortFields.put('description__c','Request Description');
        sortFields.put('status__c','Status');        
        sortFields.put('Country__r.Name','Country'); //1
        sortFields.put('Unit__r.name','Unit'); //2
        sortFields.put('Trademark__r.name','Trademark'); //3
        sortFields.put('Flavour__r.name','Flavour'); //4
        sortFields.put('Material__r.name','Material'); //5
        sortFields.put('Design__r.name','Design'); //6
        sortFields.put('Multipack__r.name','Multipack'); //7
        sortFields.put('Units_Pack__r.name','Units/Pack'); //8
        sortFields.put('Packs_Case__c','Packs/Case'); //9
        sortFields.put('Units_Case__c','Units/Case'); //10
        sortFields.put('EAN_Code__r.Name','EAN Code'); //11
        

        for (String key : sortFields.keySet()) {

            options.add(new SelectOption(key, sortFields.get(key)));

        }

        return options;

    }      
    
    public without sharing class FullAccessContext {
        List<GS1_Request__c> searchRequest(String query) {
            return database.query(query);
        }
        
        List<SelectOption> getCountries(boolean isAdmin) {          
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','-- select country --'));
            if (isAdmin) {
                GS1_Country__c[] countries = [select id, name from GS1_Country__c order by name];
                if (countries!=null && countries.size()>0) {
                    for (GS1_Country__c c : countries) {
                        options.add(new SelectOption(String.valueOf(c.id),c.name));
                    }
                }               
            } else {
                GS1_CountryAuthor__c[] authors = [select country__c, country__r.name from GS1_CountryAuthor__c where AuthorProfile__r.User__c=:UserInfo.getUserId() order by country__r.name];
                if (authors!=null && authors.size()>0) {
                    for (GS1_CountryAuthor__c ca : authors) {
                        options.add(new SelectOption(String.valueOf(ca.country__c),ca.country__r.name));
                    }
                }
            }
      
            return options;         
        }        
    }
}