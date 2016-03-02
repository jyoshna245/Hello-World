/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 11, 2013
* Description  :     A schedulable/batchable class used to generate and send CSV report to specified email addresses
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
public without sharing class GS1_RequestCSVReport
    implements Database.Batchable<sObject>,  Schedulable, Database.stateful {

    String csv = 'EAN,GENCOD CODE,GENCOD KEY,GENCOD DESCRIPTION,MAJOR BRAND,MINOR BRAND,STARTING DATE,PROMOTIONAL FLAG GENCOD,TECHNICAL FEATURE,CLASSIFICATION,COUNTRY,CAPACITY,CAPACITY UNIT,MATERIAL,DESIGN,MULTIPACK,PACK UNIT';
	boolean hasData = false;
    
    List<String> recipients = new List<String>();
    List<String> countries = Label.GS1_CSV_Report_Countries.split(';');

    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);

        //List<GS1_Request__c> requests = database.query(this.query);
        //this.processRecords(requests);
        //this.finish(null);        
    }   
    
    public Database.QueryLocator start(Database.BatchableContext BC) {      
        String rcpts = label.GS1_CSV_Report_Recipients;
        List<String> filteredCountries = new List<String>();
        
        if (!String.isblank(rcpts)) {
            List<String> partialRcpts = rcpts.split(';');
            for (String pr : partialRcpts) {
                if (this.isValidEmail(pr.trim())) {
                    this.recipients.add(pr.trim());
                } else {
                    System.debug(GS1_Constants.GS1_DEBUG_SIG + 'Invalid email address: ' + pr);
                }
            }
        }
        
        if (this.recipients.size()>0) {        
            for (String c : this.countries) {
                String country = c.trim();
                if (country != '') {
                    filteredCountries.add(country);
                }                            
            }
            
            
            if (filteredCountries.size()>0) {                
				return Database.getQueryLocator([SELECT Description_Computed__c, EAN_Code__r.Name, Trademark__r.name, Flavour__r.name, Country__r.name, Capacity__r.name, Unit__r.name, Material__r.name, Design__r.name, Multipack__r.Name, Units_Pack__r.name, Date_On_Market__c from GS1_Request__c WHERE EAN_Code__c != null AND Country__r.name IN :filteredCountries ]);
            } else {
                return Database.getQueryLocator([SELECT Description_Computed__c, EAN_Code__r.Name, Trademark__r.name, Flavour__r.name, Country__r.name, Capacity__r.name, Unit__r.name, Material__r.name, Design__r.name, Multipack__r.Name, Units_Pack__r.name, Date_On_Market__c from GS1_Request__c WHERE EAN_Code__c != null]);
            }
        } else {
            return null;
        }
                
    }
    
    private boolean isValidEmail(String emailAddress) {
        Boolean ret = false;
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);
        
        Matcher MyMatcher = MyPattern.matcher(emailAddress);
        
        if (!String.isblank(emailAddress)) {
            if (MyMatcher.matches()) {
                ret = true;
            }           
        }
        
        return ret;
    }

    public void execute(Database.BatchableContext BC,  List<GS1_Request__c> requests) {
        this.processRecords(requests);
    }
    
    private void processRecords(List<GS1_Request__c> requests) {
        String csvLine = '';
        String EANCode = '';
        for(GS1_Request__c req : requests) {
            
            EANCode = req.EAN_Code__r.Name;
            if (String.isBlank(EANCode)) EANCode = '';
            
            csvLine = (String.isBlank(EANCode) ? '' : toCSV( EANcode )); //EAN
            csvLine += ',' + (String.isBlank(EANCode) ? '' : toCSV( EANCode.substring(0, EANCode.length()-1) )); //GENCOD CODE
            csvLine += ',' + (String.isBlank(EANCode) ? '' : toCSV( EANCode.substring(EANCode.length()-1) )); //GENCOD KEY
            csvLine += ',' + (String.isBlank(req.Description_Computed__c) ? '' : toCSV( req.Description_Computed__c )); //GENCOD DESCRIPTION
            csvLine += ',' + (String.isBlank(req.Trademark__r.Name) ? '' : toCSV( req.Trademark__r.Name )); //MAJOR BRAND
            csvLine += ',' + (String.isBlank(req.Flavour__r.Name) ? '' : toCSV( req.Flavour__r.Name )); //MINOR BRAND
            csvLine += ',' + (String.isBlank(String.valueOf(req.Date_On_Market__c)) ? '' : toCSV( String.valueOf(req.Date_On_Market__c) )); //STARTING DATE
            csvLine += ',' + toCSV( '' ); //PROMOTIONAL FLAG GENCOD
            csvLine += ',' + toCSV( '' ); //TECHNICAL FEATURE
            csvLine += ',' + toCSV( '' ); //CLASSIFICATION
            csvLine += ',' + (String.isBlank(req.Country__r.Name) ? '' : toCSV( req.Country__r.Name )); //COUNTRY
            csvLine += ',' + (String.isBlank(req.Capacity__r.Name) ? '' : toCSV( req.Capacity__r.Name )); //CAPACITY
            csvLine += ',' + (String.isBlank(req.Unit__r.Name) ? '' : toCSV( req.Unit__r.Name )); //CAPACITY UNIT
            csvLine += ',' + (String.isBlank(req.Material__r.Name) ? '' : toCSV( req.Material__r.Name )); //MATERIAL
            csvLine += ',' + (String.isBlank(req.Design__r.Name) ? '' : toCSV( req.Design__r.Name )); //DESIGN
            csvLine += ',' + (String.isBlank(req.Multipack__r.Name) ? '' : toCSV( req.Multipack__r.Name )); //MULTIPACK
            csvLine += ',' + (String.isBlank(req.Units_Pack__r.Name) ? '' : toCSV( req.Units_Pack__r.Name )); //PACK UNIT
            
            this.csv += '\r\n' + csvLine;
            this.hasData = true;
        }       
    }
  
    public void finish(Database.BatchableContext BC) {   
        if (this.hasdata) {
            Messaging.EmailFileAttachment csvFile = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(this.csv);
            csvFile.setFileName('GS1_CSV_Export_' + String.valueOf(System.today()).replace('/', '-') + '.csv');        
            csvFile.setBody(csvBlob);        
            Messaging.SingleEmailMessage eml = new Messaging.SingleEmailMessage();
            eml.setSubject('GS1 Auchan Export as of ' + String.valueOf( System.today() ) );
            eml.setToAddresses( this.recipients );
            eml.setPlainTextBody(label.GS1_CSV_Report_Email_Content);
            eml.setFileAttachments(new Messaging.EmailFileAttachment[]{csvFile});
            if (this.reserveEmailCapacity( this.recipients.size())) {
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {eml});
            } else {
                System.debug(GS1_Constants.GS1_DEBUG_SIG + 'No email was sent, as it would reach the current allowable limit.');
            }
        }
    }
    
    private string toCSV(String s) {
        if (String.isEmpty(s)) {
            return '';
        } else {
            return s.escapeCSV();
        }
        
    }
    
    private boolean reserveEmailCapacity(Integer count) {
        boolean ret = false;
        try {
            Messaging.reserveSingleEmailCapacity(count);
            ret = true;
        } catch (Exception ex) {
            System.debug(GS1_Constants.GS1_DEBUG_SIG + ex.getMessage());
        }
        
        return ret;     
    }
}