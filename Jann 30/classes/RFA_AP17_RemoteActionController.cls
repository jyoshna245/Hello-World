/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_AP17_RemoteActionController 
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/18/2012
 *  Assumptions      : N/A
 *  Description      : This class containes a webservice method to process RFA updates from javascript.
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
global class RFA_AP17_RemoteActionController {
    
    
    // Inner class. 
    global class ErrorDisplay
    {
        public String errorDetail;
        
        public String componentLabel;
        
        public String summary;
        
        public ErrorDisplay(String errorDetail, String componentLabel, String summary)
        {
            this.errorDetail = errorDetail;
            
            this.componentLabel = componentLabel;
            
            this.summary = summary; 
        }   
    }

    

     /**
      *  @ Description : Webservice method to process RFA updates.
      *  @ param : String, String
      *  @ return : String
      */ 
    webService  static String performAction(String rfaId, String labelClicked)
    {
        
        System.debug('\n label clicked by the user:::::'+labelClicked+'!@@@@@@@RFAID@@@'+rfaId);
        
        //String errMsg = null;
        
        pageReference pref = null;
        
        List<ErrorDisplay> errorList = new List<ErrorDisplay>();
        
        boolean hasPageMessage = false;
        
        String serializedErrorMsg;
        
        //Savepoint sp = Database.setSavepoint
        
        try{
        	RFA__c rfaObjTemp = new RFA__c(Id = rfaId);           
        if(labelClicked ==RFAGlobalConstants.SEND_TO_PRE_CIRCULATION)
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            //update rfaObjTemp;
            
        }
        else if(labelClicked ==RFAGlobalConstants.RETURN_TO_SENDER)
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RETURN_TO_SENDER;
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL001+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '1. '+System.Label.RFA_CL001;
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL002+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '2. '+System.Label.RFA_CL002;
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL003+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '3. '+System.Label.RFA_CL003;
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL004+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '4. '+System.Label.RFA_CL004;
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL005+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '5. '+System.Label.RFA_CL005;
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL006+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '6. '+System.Label.RFA_CL006;
            //update rfaObjTemp;
        }
        
        Database.update(rfaObjTemp);
        		
        }catch(DMLException dme)
        {
        	
        	serializedErrorMsg = dme.getDMlMessage(0);	
        	
        	return serializedErrorMsg;		
        } 
        
        return serializedErrorMsg;  
    }
    
}