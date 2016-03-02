global class ITSES_FlagAllDigitalInitialsObtained implements Schedulable, Database.Batchable<sObject> {   
	String query='SELECT Name, Status__c, Flag_as_All_Digital_Initials_Obtained__c from ITPR__c where Flag_as_All_Digital_Initials_Obtained__c=FALSE AND Status__c =\''+System.Label.ITPR_All_Digital_Initials_Obtained_Status+'\'';
	global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('RSAS value of query ' + query);
        return Database.getQueryLocator(this.query);
    } 
	
	global void execute(Database.BatchableContext BC,  List<ITPR__c> ITSESlist) {
        this.FlagAllDigitalInitialsObtained(ITSESlist);
    }
	
	 global void FlagAllDigitalInitialsObtained(List<ITPR__c> itseslst) {
        
        system.debug('RSAS went to the FlagAllDigitalInitialsObtained part');
        
        List<ITPR__c> ITSESListToUpdate = new List<ITPR__c>();
        
        
        for(ITPR__c eachITSES: itseslst) {
            if(eachITSES.Status__c== System.Label.ITPR_All_Digital_Initials_Obtained_Status && eachITSES.Flag_as_All_Digital_Initials_Obtained__c==False)
            {
            eachITSES.Flag_as_All_Digital_Initials_Obtained__c=True;
            ITSESListToUpdate.add(eachITSES);
            }          
        }

        if(ITSESListToUpdate.size() > 0) {
            system.debug('RSAS went to the Update part' + ITSESListToUpdate.size());
           try {
                update ITSESListToUpdate;
                 system.debug('RSAS ITSESListToUpdate Updated Successfully');
                } catch (Exception e) {
                System.debug('Update exception: ' + e.getMessage());
            }

        } 
         
    }
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this); 
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }    



}