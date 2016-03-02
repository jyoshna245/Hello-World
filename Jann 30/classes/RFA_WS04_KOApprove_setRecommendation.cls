/*
    Author           : Accenture
    Date Created  : 05/22/2012
    Description     : This Webservice class will be called by the KOApprove server to set the Recommendation.
    Version          : 1.0 
*/ 
global class RFA_WS04_KOApprove_setRecommendation{

    

     /* @Method <This webservice method is updating the workItem into SFDC. >
       @param <String>-recommendation, <String>-Comments, <String>-federationId, <Id>-SFDC Id for UserRoleRecord to Submit Recommendation
       @return <messageWrapper> - Returning the Service Status (Suuccess or Failure) in the form of Code and Description.
       @throws exception - <Throwing Query Exception>
    */
    WebService static response setRecommendation(String recommendation, String comments,String federationId,Id workItemId)
    {
        /*~~~~Start of Variable Initialization~~~~*/ 
        response result = New response(); //Response Wrapper class instance to pass the Status Message
        statusMessageWrapper message=new statusMessageWrapper();//Message Wrapper class instance to pass the Code and Description
        RFA_Util_ObjectQuery qry = New RFA_Util_ObjectQuery(); // Instance of the Util class to call the RFAUserRole__c query method
        RFAUserRole__c userRoleRecord;
        Id UserId;     
        /*~~~~End of Variable Initialization~~~~*/      
        
        
        //Check whether all the mandatory input parameters are there before start processing
        if(recommendation.trim()=='' || recommendation==null || federationId==NULL || federationId.trim()=='' || workItemId==NULL)
        {
            message.Code=Label.RFA_Cl034; //ERROR
            message.Description=label.RFA_CL033;//Recommendation, federation Id and workItem Id cannot be null 
            result.message=message; 
        }
        else
        {
            try
            {
                userRoleRecord=qry.getUserRole(workItemId); // Query the record in RFAUserRole__c for whcih recommendation need to be recorded
            }
            catch(QueryException e)
            {
                message.Code=Label.RFA_CL034;  //Error
                message.Description=label.RFA_CL015;  //Id Specified in the Request NOT Found in Salesforce
                result.message=message;
                return result;
            }
            
            if(userRoleRecord.RFA__r.Stage__c != System.Label.RFA_CL041 || userRoleRecord.RFA__r.Level__c == System.Label.RFA_CL007 || userRoleRecord.RFA__r.Level__c == System.Label.RFA_CL008 || userRoleRecord.ApprovalRecommendation__c != 'Awaiting Approval' )
            {
                message.Code=label.RFA_CL031; //ERROR
                message.Description=label.RFA_CL036; //RFA Level/Stage is Overridden    
                result.message=message;
            }
            else
            {
                try
                {
                    User user=qry.getUserDetails(federationId); //Query in User Object
                    userId=user.id; 
                }
                catch(Exception e)
                {
                    message.Code=Label.RFA_CL034;//Error
                    message.Description=label.RFA_CL035; //Federated Id not valid   
                    result.message=message;
                    return result;
                }
                
                userRoleRecord.ApprovalRecommendation__c=recommendation; // Set recommendation to userRoleSObject
                userRoleRecord.ApprovalComments__c=comments;  // Set Comments to userRoleSObject
                userRoleRecord.approvedBY__c=userId; // Set ApprovedBy to userRoleSObject
                userRoleRecord.ApprovalRecievedDateTime__c=system.today();// Set ApprovalRecievedDateTime to userRoleSObject
                    
                Database.SaveResult[] recIns = RFA_Util_PerformDML.performUpdOperation(new List<RFAUserRole__c>{userRoleRecord});
                for(Database.SaveResult sr : recIns)
                {
                    if(!sr.isSuccess())
                    {
                        System.Debug('########'+sr.getErrors()[0].getStatusCode()+' '+sr.getErrors()[0].getMessage());
                        message.Code=label.RFA_CL034;  //ERROR
                        message.Description=sr.getErrors()[0].getMessage(); //@throws exeption
                        result.message=message;             
                    }
                    else
                    {
                        message.Code=label.RFA_CL028;  //SUCCESS
                        message.Description=label.RFA_CL028; //SUCCESS
                        result.message=message; 
                    }
                }
            }
        }
            
        return result; //return result 
    } 

    /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to display the Service StatusMessage. 
                          The wrapper class contains Inner class value for status message .
        Version          : 1.0 
    */ 
   
    global class response
    {
        WebService statusMessageWrapper message; // Message Wrapper
        
        public  response(){}
        public response(statusMessageWrapper message)
        {
            this.message=message;
        }
        
    }
    /*~~~~END of response Wrapper (Inner) Class~~~~*/
    
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