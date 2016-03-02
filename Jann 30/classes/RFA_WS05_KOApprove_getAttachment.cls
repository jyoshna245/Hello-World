/*
    Author           : Accenture
    Date Created  : 05/22/2012
    Description     : This Webservice class will be called by the KOApprove server to retrieve the details of an individual attachment.
    Version          : 1.0 
*/ 
global class RFA_WS05_KOApprove_getAttachment{
    
    /* @Method <This webservice method is creating the response to return fetched the attachment details based on the passed Atatchment SFDC Id. >
       @param <Id> - SFDC Id
       @return <attachmentWrapper> - Returning Data type of inner class. Method Output includes attach,ment details and the Service Status (Suuccess or Failure) in the form of Code and Description.
       @throws exception - <Throwing Query Exception>
    */
    WebService static AttachmentWrapper getAttachment(Id docId)
    {       
        system.debug('####Start of Attachment Webservice Response creation####');
        /*~~~~Start of Variable Initialization~~~~*/ 
        AttachmentWrapper result=new AttachmentWrapper(); // Attachment Wrapper to pass the Attachment details and message
        statusMessageWrapper message=new statusMessageWrapper(); //Message Wrapper to pass the the service result
        Attachment doc = New Attachment ( ); // Atatchment sObject
        RFA_Util_ObjectQuery qry = New RFA_Util_ObjectQuery(); // Instance of the Util class to call the Attachment query method
        /*~~~~End of Variable Initialization~~~~*/
        
        if(docId == NULL)
        {
            message.code=label.RFA_CL034; // Message Attachment ID mandatory in Request - Error
            message.description=label.RFA_CL013; // Description of Error Type
            result.message=message;
            System.debug('#######Missing Id Message :'+message);
        }
        else
        {
            try
            {
                doc = qry.getAttachment(docId); // Query in attachment sObject
                if(doc.Id <> NULL || doc.Id <> '')
                {
                    message.code=label.RFA_CL028; // Message Success
                    message.description=label.RFA_CL028; // Description - Success
                    result=new AttachmentWrapper(doc.Id, doc.Name, doc.BodyLength, doc.Body, message);
                }
            }
            catch(System.QueryException e) 
            {
                message.code=Label.RFA_CL034; // Message Exception in Query - Error
                message.description=label.RFA_CL015; // Description of the Query Exception
                result.message=message;
                System.debug('#######Catched Exception :'+e);
                System.debug('#######Query Error Message :'+message);
            }
            catch(Exception e)
            {
                message.code=Label.RFA_CL034; // Message Other Exceptions - Error
                message.description=e.getMessage(); // Description of the Query Exception
                result.message=message;
                System.debug('#######Catched Exception :'+e);
                System.debug('#######Other Error Message :'+message);
            }
        }    
        return result; // Return the Service Result - Attachment Details and Success Message in case of Success; 
                            // In case of failure Attachment details field will be empty and Error Message code along with appropriate mesage
    }
    
    
    /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to display the Atatchment Details along with the Service StatusMessage. 
                               The wrapper class contains specific attachment field values in primitive data type and Inner class value for status message .
        Version          : 1.0 
    */ 
    global class AttachmentWrapper
    {
        /*~~~~Start of Variable Initialization~~~~*/        
        WebService Id id; // Salesforce Attachment Id
        WebService String name; // Name of the File (along with the extension)
        WebService Integer bodyLength; // Length/ Size of the attachment body
        WebService Blob body;  // Attachment Body
        WebService statusMessageWrapper message; // Message Wrapper to pass the the service result
        /*~~~~End of Variable Initialization~~~~*/
        
        /*~~~~Constructors~~~~*/   
        public AttachmentWrapper() {} // Constructor

        // Contructor Overloading to pass Atatchment Id, Name, Size, Details and Status Message
        public AttachmentWrapper(Id id,String name, Integer bodyLength, Blob body, statusMessageWrapper message )
        {
            this.id=id;
            this.name=name;
            this.bodyLength=bodyLength;
            this.body=body;
            this.message=message;
        }
    }
    /*~~~~END of Attachment Wrapper (Inner) Class~~~~*/
    
    /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to display the code and description Service StatusMessage. 
                               The wrapper class contains the 2 string values to display the code and description of the Status.
        Version          : 1.0 
    */
    global class statusMessageWrapper
    {        
        /*~~~~Start of Variable Initialization~~~~*/
        WebService String description; // Status Description 
        WebService String code; // Status Code
        /*~~~~End of Variable Initialization~~~~*/
        
        /*~~~~Constructors~~~~*/ 
        public statusMessageWrapper(){} // Default Constructor
        
        // Constructor Overloading to pass the Status Code and Description
        public statusMessageWrapper(String code, String description)
        {
            this.code=code;
            this.description=description;
        }
    }
    /*~~~~END of Status Message Wrapper (Inner) Class~~~~*/   

}