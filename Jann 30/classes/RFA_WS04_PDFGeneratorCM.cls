/**
 * Class Name: RFA_WS04_PDFGeneratorCM
 * Author: Accenture
 * Date: 18-12-2012
 * Project Name: RFA - Coke 
 * Requirement Description: This apex class is used for calling the PDF Generator REST based class.
 */
 
public class RFA_WS04_PDFGeneratorCM
{
    @Future( callout=true)
    public static void PDFGenerator(Id rfaId, String SessionId)
    {
        rfaEndpoint_RESTWebServiceCM__c EndPointRetrive=rfaEndpoint_RESTWebServiceCM__c.getInstance();
        String EndPoint=EndPointRetrive.EndPoint__c;

        //String EndPoint='https://fina--sbdev4.cs9.my.salesforce.com/services/apexrest/pdfGeneratorCM/RFA_AP04_UTIL_PdfCompletionMemo/savePDF';
        
        /********************* Creating Http Request for pdf Generator REST based WS******/

        HttpRequest req = new HttpRequest(); 
        
        req.setEndpoint(EndPoint+'/services/apexrest/pdfGeneratorCM/RFA_AP04_UTIL_PdfCompletionMemo/savePDF');
        req.setMethod('POST');
        // adding content type as JSON format for the request
        req.setHeader('Content-Type', 'application/json');
        //Passing RFA ID as parentId for attaching the attachment.
        req.setbody('{"parentId":"'+rfaId +'"}');
        //Adding SOAP Action
        req.setHeader('SOAPAction', '""');
        //Set the header with OAuth and session Id
        req.setHeader('Authorization','OAuth '+SessionId);
        try{
            Http http = new Http();  
            system.debug('--End Point--'+req.getEndPoint());    
            HTTPResponse res = http.send(req);  
        }Catch(Exception e)
        {
            system.debug(e.getMessage());
        }
    }
}