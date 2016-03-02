/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_AP12_ReminderEmailUtil
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/05/2012
 *  Assumptions      : N/A
 *  Description      : To - Do
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

public class RFA_AP12_ReminderEmailUtil {
    
    //public final String EMAIL_SUBJECT_AP10 = 'Summary of Pending RFAs for Approval';
    
    public final String EMAIL_SUBJECT_AP10 = System.Label.RFA_CL123;
    
    //public final String EMAIL_BODY1_AP10 = 'The following RFA(s) are pending your review and approval :' + '<BR/><BR/>';
    
    public final String EMAIL_BODY1_AP10 =  System.Label.RFA_CL124;
    
    //public final String EMAIL_BODY2 = '<p><div style="font-weight:bold">Click each link to open the RFA Request Document.</div></p>';
    
    public final String EMAIL_BODY2 = System.Label.RFA_CL125;
    
    //public final String EMAIL_BODY3 = '<div><span style="color:red;">NOTE: THIS IS A SYSTEM GENERATED MESSAGE.</span> Please <span style="color:red">DO NOT RESPOND</span> to this email.</div>';
    
    public final String EMAIL_BODY3 = System.Label.RFA_CL126;
    
    //public final String EMAIL_SUBJECT_AP15 = 'Summary of Draft RFAs Requiring your Attention';
    
    public final String EMAIL_SUBJECT_AP15 = System.Label.RFA_CL127;
    
    //public final String EMAIL_BODY1_AP15 = 'The following list of Request for Authorization documents in the RFA Application Database are still in DRAFT stage and requires your attention.';
    
    public final String EMAIL_BODY1_AP15 = System.Label.RFA_CL128;
    
    
    /**
     *  prepareEmailBody
     *  @param <List<String>, Map<Id, RFA__c>, String>
     *  @return <String> 
     */
    public String prepareEmailBody(List<String> associatedRfas, Map<Id, RFA__c> rfaIdDetailMap, String htmlBody)
    {
        htmlBody = '<font style="font-size:10.5pt;">'+  EMAIL_BODY1_AP10  +'</font>';
        htmlBody = htmlBody + '<BR/>'; 
        Integer rowCount = 1;
        for(String rfa : associatedRfas)
        {
            htmlBody = htmlBody + '<font style="font-size:10.5pt;">'+ rowCount + '-' + ' ' + + '<a href="'+ RFAGlobalConstants.CURRENT_DOMAIN_NAME + '/' + rfaIdDetailMap.get(rfa).Id + '">' + rfaIdDetailMap.get(rfa).ControlNumber__c + '</a> '+ rfaIdDetailMap.get(rfa).RequestTitle__c + '</font> <BR/>';
            rowCount = rowCount + 1;
        }
        htmlBody = htmlBody + '<BR/>';
        //htmlBody = htmlBody + '</BR>'; 
        htmlBody = htmlBody + '<font style="font-size:10.5pt;">'+ EMAIL_BODY2 + '<BR/>';
        htmlBody = htmlBody + '<font style="font-size:10.5pt;">' +EMAIL_BODY3;
        return htmlBody;           
    }
    
    
    /**
     *  prepareEmailBody
     *  @param <Map<String, List<RFA__c>, String>
     *  @return <String> 
     */
    public String prepareEmailBody(Map<Id, List<RFA__c>> creatorRFAs, String htmlBody, String creator)
    {
        htmlBody = '<font style="font-size:10.5pt;">' + EMAIL_BODY1_AP15 + '</font>';
        htmlBody = htmlBody + '<BR/>'; 

        Integer rowCount = 1;
        
        for(RFA__c rfa : creatorRFAs.get(creator)) 
        {
            htmlBody = htmlBody + '<font style="font-size:10.5pt;">'+ rowCount + '-' + ' ' + + '<a href="'+ RFAGlobalConstants.CURRENT_DOMAIN_NAME + '/' + rfa.Id + '">' + rfa.ControlNumber__c + '</a> ' + rfa.RequestTitle__c + '</font> <BR/>';      
            rowCount = rowCount + 1;
        }
        
        htmlBody = htmlBody + '<BR/>';
        //htmlBody = htmlBody + '</BR>'; 
        htmlBody = htmlBody + '<font style="font-size:10.5pt;">'+ EMAIL_BODY2 + '</font> <BR/>';
        htmlBody = htmlBody + '<font style="font-size:10.5pt;">'+ EMAIL_BODY3 +'</font>';
        return htmlBody;
        return null;
    }

}