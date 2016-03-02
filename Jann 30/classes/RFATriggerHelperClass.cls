/* Author,email :     Mads Pascua , mpascua@coca-cola.com
*  Date Create  :     Nov 8, 2013
*  Description  :     The Apex Class that contains methods used by the main trigger for RFA_RFATrigger
*                    
****** REVISION HISTORY*****
*  Author,email : 
*  Date Revised : 
*  Description  : 
*
*
*/

public class RFATriggerHelperClass{

/**
*  @ Description : This method contains logic to notify local ccordinator when the RFA Stage is set to
*                  "Return To Sender" or "Pre-Circulation"                    
*  @ param : Set<String>, Map<String, RFA__c>
*  @ return : void
*/
public  static void notifyLocalCoordinator2(Map<Id, String> levelMap,  Map<String, String> rfaMap){
        System.debug('\n level map :'+levelMap);
        System.debug('\n rfa map :'+rfaMap);
          
        Map<String, Map<String, RecordType>> RECORDTYPESMAP = RFAGlobalConstants.RECORDTYPESMAP;
        Map<String, RecordType> rfaRecordTypeMap = RECORDTYPESMAP.get(Schema.sObjectType.RFA__c.getName());
    
        Set<String> profitCenterNumbers = new Set<String>();
        Set<String> uniqueLevels = new Set<String>();
         
        RFA__c currRFA=[SELECT Id,Name,FunctionalCurrencyNameFC__c, RecordTypeId,Functional_Currency__c,RequestAmountFunctionalCurrency__c,RequestAmountUSD__c,ExecutiveSummary__c, POC_Name__c,CO_CREATOR_Name__c,LOC_Name__c, Stage__c,RequestTitle__c,ReturnReason__c, CreatedById, LevelStage__c,ControlNumber__c,Policy_Category__c,Request_Summary__c, ProfitCenterNumberName__c from RFA__c WHERE Id=:rfaMap.keyset() LIMIT 1];
        System.debug('\n RSAS currRFA ID:'+currRFA.Id);
        System.debug('\n RSAS currRFA LevelStage:'+currRFA.LevelStage__c);   
                                  
        profitCenterNumbers.addAll(rfaMap.values());
        uniqueLevels.addAll(levelMap.values());
        
        System.debug('\n rowcause for the share :'+levelMap);
        System.debug('\n Rfa map :'+rfaMap);
        System.debug('\n Profit center set :'+profitCenterNumbers);
                                             
        ProfitCenterUserRole__c[] profitCenterUserRoles = [Select Id, UserName__c, UserType__c, ProfitCenter__c, Level__c FROM ProfitCenterUserRole__c WHERE Level__c IN: uniqueLevels AND ProfitCenter__c IN: profitCenterNumbers AND UserType__c = 'Location Coordinator'];                                
        String breakString = '<BR/>';
        Set<Id> lcSetId = new Set<Id>();
        for(ProfitCenterUserRole__c profitCenter : profitCenterUserRoles)
        {
             lcSetId.add(profitCenter.UserName__c);
        }  
        lcSetId.add(currRFA.CreatedById);

        List<User> lcUsers = [SELECT Id, Email, Name FROM User WHERE ID IN: lcSetId LIMIT 1000];
        List<String> addresses = new List<String>();
        Map<Id, User> userMap = new Map<Id, User>();

        for (User u : lcUsers){
             addresses.add(u.Email);
             if(!userMap.containsKey(u.Id)){ 
                 userMap.put(u.Id,u);
             }
        }
    
       
        System.debug(' Debug RFA ID: ' + currRFA.Id);
        System.debug('\n RSAS value of levelMap.get(rfaId): ' +levelMap.get(currRFA.Id) ) ;           
        System.debug('\n RSAS value of currRFA Stage:'+currRFA.Stage__c); 
        System.debug('\n RSAS value of currRFA LevelStage__c:'+currRFA.LevelStage__c); 

        if(currRFA.LevelStage__c == RFAGlobalConstants.RETURN_TO_SENDER)
        {   
             //Apexpages.StandardController sc = new Apexpages.StandardController(currRFA);
             //PageReference pr = Page.RFAReturnToSenderEmailContent;
             //pr.getParameters().put('id', String.valueOf(currRFA.Id));
             String htmlBodyEmail = '';
             String ccAddress = '';
             //Added by Mads 4-29-2014;
             Pattern dollarPattern = Pattern.compile('[$]');
             String strReason = currRFA.returnReason__c;
             String strControlNumber = currRFA.ControlNumber__c;
             String strProfitCenter = currRFA.ProfitCenterNumberName__c; // added by RLC for Profit Center May 2, 2014
             String strRequestTitle = currRFA.RequestTitle__c;

             strReason = dollarPattern.matcher(strReason).replaceAll('xxRSASxx');
             strControlNumber = dollarPattern.matcher(strControlNumber).replaceAll('xxRSASxx');
             strRequestTitle = dollarPattern.matcher(strRequestTitle).replaceAll('xxRSASxx');  

             if(currRFA.POC_Name__c != null){ccAddress = currRFA.POC_Name__c;}   
             if(currRFA.CO_CREATOR_Name__c != null){ccAddress += ', '+currRFA.CO_CREATOR_Name__c;}   
             if(currRFA.LOC_Name__c != null){ccAddress += ', '+currRFA.LOC_Name__c;}
             String strSubject = 'Action Required: ' + currRFA.ControlNumber__c+' Returned to Sender';
             if(currRFA.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id){
                String strRequestSummary = currRFA.Request_Summary__c;
                String strPolicyCategory = currRFA.Policy_Category__c;
                strRequestSummary = dollarPattern.matcher(strRequestSummary).replaceAll('xxRSASxx');
                strPolicyCategory = dollarPattern.matcher(strPolicyCategory).replaceAll('xxRSASxx');


                 htmlBodyEmail  = Label.RFA_CL_PE_ReturnToSender;
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%REASON%' , strReason);
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%CONTROL_NUM%' , strControlNumber);
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%REQUEST_TITLE%' , strRequestTitle);  
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%REQUEST_TYPE%' , RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST);  
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%REQUEST_SUMMARY%' , strRequestSummary);    
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%POLICY_CATEGORY%' , strPolicyCategory);      
      
             }else{    
                 htmlBodyEmail  = Label.RFA_CL_NonPE_ReturnToSender;
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%REQUEST_TITLE%' , strRequestTitle);  
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%REASON%' , strReason);
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%CONTROL_NUM%' , strControlNumber);
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%PROFIT_CENTER%' , strProfitCenter); //Added by RLC for Profit Center may 2, 2014


                 String strFC = currRFA.FunctionalCurrencyNameFC__c;
                 String strRequestAmountUSD = String.valueOf(currRFA.RequestAmountUSD__c);  
                 String strRequestAmountFC = String.valueOf(currRFA.RequestAmountFunctionalCurrency__c); 
                 String strExecSummary = currRFA.ExecutiveSummary__c; 
  
                 strFC = dollarPattern.matcher(strFC).replaceAll('xxRSASxx');
                 strRequestAmountUSD = dollarPattern.matcher(strRequestAmountUSD).replaceAll('xxRSASxx');  
                 strRequestAmountFC = dollarPattern.matcher(strRequestAmountFC).replaceAll('xxRSASxx');
                 strExecSummary = dollarPattern.matcher(strExecSummary).replaceAll('xxRSASxx');
    
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%REQ_AMT_USD%' , strRequestAmountUSD);
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%FC%' , strFC);    
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%REQ_AMT_FC%' ,  strRequestAmountFC);     
                 htmlBodyEmail  = htmlBodyEmail.replaceAll('%EXEC_SUMMARY%' , strExecSummary);      
             }   
  
             htmlBodyEmail  = htmlBodyEmail.replaceAll('%TO_ADDRESS%' , userMap.get(currRFA.CreatedById).Name);
             htmlBodyEmail  = htmlBodyEmail.replaceAll('%CC_ADDRESS%' , ccAddress);
             htmlBodyEmail  = htmlBodyEmail.replaceAll('%URL1%' , Label.RFA_CL026+'/'+currRFA.Id);
             htmlBodyEmail  = htmlBodyEmail.replaceAll('%URL2%' , currRFA.Name);
             htmlBodyEmail  = htmlBodyEmail.replaceAll('%EMAIL1%' , 'mailto:'+userMap.get(currRFA.CreatedById).Email+'?subject=RE : '+strSubject );    
             htmlBodyEmail  = htmlBodyEmail.replaceAll('%EMAIL2%' , userMap.get(currRFA.CreatedById).Name);  
             System.debug('ROYCASTILLO inside RETURN_TO_SENDER');
             Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
             mail.setToAddresses(addresses);
             mail.setSubject(strSubject);
             mail.setSaveAsActivity(false);
             mail.orgWideEmailAddressId=Label.RFA_CL131; //-added by RSAS 11-Oct-2012 for INC0075225
             htmlBodyEmail  = htmlBodyEmail.replaceAll('xxRSASxx','\\$');//Added mpascua@coca-cola.com April 29, 2014
             mail.setHtmlBody(htmlBodyEmail);
             System.debug('ROYCASTILLO sending email');
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }                       
                               
    }
   
    
}