/**
 * Class Name: RFA_WS01_PDFGenerator
 * Author: Accenture
 * Date: 21-5-2012
 * Project Name: RFA - Coke 
 * Requirement Description: This apex class is used for calling the PDF Generator REST based class.
 */
 
public class RFA_WS01_PDFGenerator
{
    @Future( callout=true)
    public static void PDFGenerator(Id rfaId, String SessionId)
    {
        //Custom Setting--Fetching the Endpoint
         
        rfaEndpoint_RESTWebService__c EndPointRetrive=rfaEndpoint_RESTWebService__c.getInstance();
        String EndPoint=EndPointRetrive.EndPoint__c;
        
        /********************* Creating Http Request for pdf Generator REST based WS******/

        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(EndPoint);
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
            HTTPResponse res = http.send(req);  
        }Catch(Exception e)
        {
            system.debug(e.getMessage());
        }
    }


}