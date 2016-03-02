/* WebService to get All Requests*/ 
     
global class RFA_WS02_KOApprove_getAllRequests {
 
 /* @Method <This webservice method is creating the response to return fetched the attachment details based on the passed Atatchment SFDC Id. >
       @param 
       @return <rfaFinalWrapper> - Returning Data type of inner class. Method Output includes RFADetail,Approvers details and the Service Status (Suuccess or Failure) in the form of Code and Description.
       @throws exception - <Throwing Query Exception>
    */
     WebService static list<rfaFinalWrapper> getAllRFADetails()
        {
            /*~~~~Start of Variable Initialization~~~~*/ 
            List<rfaFinalWrapper> finalResult=new List<rfaFinalWrapper>(); // Final Wrapper to pass the pending request details and message
            List<rfaDataContainer> dataContainer=new List<rfaDataContainer>(); // Data container for contain all the requets
            List<rfaWrappersForAllRequests> result =new List<rfaWrappersForAllRequests>(); // RFADetails added into result Wrapper
            List<usersWrappers> resultUsers=new List<usersWrappers>(); // User Role Objects added into usersWrappers
            List<userDetailWapper> usersDetailWapper=new List<userDetailWapper>();
            Map<Id,Boolean> attachmentFlagMap=new Map<Id,Boolean>();
            statusMessageWrapper message=new statusMessageWrapper();//Message class instance
            RFA_Util_ObjectQuery qry = New RFA_Util_ObjectQuery(); // Instance of the Util class to call the Attachment query method
            List<RFA__c> rfaList=new List<RFA__c>();  
            
            /*~~~~End of Variable Initialization~~~~*/
            
            Map<RFA__c,List<RFAUserRole__c>> mapRFAUserRoleRecords=new Map<RFA__c,List<RFAUserRole__c>>();      
            try{  
                rfaList=qry.getAllRFADetailsForAwaitingApprovers(); // Query to get all the RFA details with user role records.
            }catch(System.QueryException e) 
            {
                message.code=Label.RFA_CL034; // Message Exception in Query - Error
                message.description=e.getMessage(); // Description of the Query Exception
                finalResult.add(
                    new rfaFinalWrapper(message));
                System.debug('#######Catched Exception :'+e);
                System.debug('#######Query Error Message :'+message);
                return finalResult;
            }
            /**************Adding records to all the wrapper ************/
            for(RFA__c rfaRecord:rfaList)
            {
                if(rfaRecord.RFA_User_Roles__r.size()>0) // if no approval records is pending then donot add into map. 
                {
                    mapRFAUserRoleRecords.put(rfaRecord,rfaRecord.RFA_User_Roles__r);   
                    if((rfaRecord.Attachments).size()>0)   // check the attachment exist at RFA level.
                    {
                        attachmentFlagMap.put(rfaRecord.Id,True);   
                    }
                    else
                    {
                        attachmentFlagMap.put(rfaRecord.Id,false);  
                    }
                }
            }
            /**************Adding records to all the wrapper ends here************/
            
            // check the Map Size and return the exception
            if(mapRFAUserRoleRecords.size()==0)
            {
                message.code=Label.RFA_CL034; // Message Exception in Query - Error
                message.description=Label.RFA_CL037; // No pending record in the RFA 
                finalResult.add(
                    new rfaFinalWrapper(message));
                return finalResult;
            }
            try{
                // Traverse the map of all the records and add into different wrapper.
                
                for(RFA__c rfaRecord:mapRFAUserRoleRecords.keySet())
                {
                    resultUsers=new List<usersWrappers>();
                    usersDetailWapper=new List<userDetailWapper>();
                    for(RFAUserRole__c rfaUserRoleRecord:mapRFAUserRoleRecords.get(rfaRecord)) // traverse the map values.
                    {
                        // add all the user role details into userDetailWrapper.
                        
                         usersDetailWapper.add(
                            new userDetailWapper(rfaUserRoleRecord.UserName__r.Email,String.valueof(rfaUserRoleRecord.UserName__r.FederationIdentifier)));
                        if(rfaUserRoleRecord.Agent1__c!=null)
                                usersDetailWapper.add(
                            new userDetailWapper(rfaUserRoleRecord.Agent1__r.Email,String.valueof(rfaUserRoleRecord.Agent1__r.FederationIdentifier)));
                        if(rfaUserRoleRecord.Agent2__c!=null)
                                usersDetailWapper.add(
                            new userDetailWapper(rfaUserRoleRecord.Agent2__r.Email,String.valueof(rfaUserRoleRecord.Agent2__r.FederationIdentifier)));
                        if(rfaUserRoleRecord.Agent3__c!=null)
                                usersDetailWapper.add(
                            new userDetailWapper(rfaUserRoleRecord.Agent3__r.Email,String.valueof(rfaUserRoleRecord.Agent3__r.FederationIdentifier)));        
                     }
                    // once users details are added for one rfa then add into parent usersWrapper
                    resultUsers.add(
                        new usersWrappers(usersDetailWapper)); 
                        Boolean attachmentFlag= attachmentFlagMap.get(rfaRecord.Id);    // find the attachment flag into existing attachmentMap
                   // add one complete request into rfaWrappersForAllRequests
                    result.add(
                        new rfaWrappersForAllRequests(rfaRecord.Id,rfaRecord.Level__C,rfaRecord.requestTitle__C,rfaRecord.CreatedDate,attachmentFlag,resultUsers));         
                }
                // add all complete requests into rfaDataContainer
                dataContainer.add(
                    new rfaDataContainer(result));
                    message.Code=label.RFA_CL028; //SUCCESS
                    message.Description=label.RFA_CL028; //SUCCESS
                // add data container & message details into rfaFinalWrapper.   
                finalResult.add(
                    new rfaFinalWrapper(dataContainer,message));    
                
                return finalResult;
            }catch(Exception e)
            {
                // catch the exceptions if any.
                
                message.code=Label.RFA_CL034; // Message Exception in Query - Error
                message.description=e.getMessage(); // No pending record in the RFA 
                finalResult.add(
                    new rfaFinalWrapper(message));
                return finalResult;
            
            }
        }          
        /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to display the RFA Details along with the Service StatusMessage. 
                               The wrapper class contains requests DataContainerWrappers inner class and Inner class value for status message .
        Version          : 1.0 
    */ 
    
        global class rfaFinalWrapper{
             /*~~~~Start of Variable Initialization~~~~*/     
            WebService List<rfaDataContainer> requests;  //DeclarerfaDataContainerWrapper
            WebService statusMessageWrapper message; // Message Wrapper 
            /*~~~~End of Variable Initialization~~~~*/
            
            /*~~~~Constructors~~~~*/ 
            public rfaFinalWrapper(){}
            /*~~~~Constructors with message parameter~~~~*/ 
            public rfaFinalWrapper(statusMessageWrapper message){
                this.message=message;
            }
            // Contructor Overloading to pass rfaDataContainer and Status Message
            public rfaFinalWrapper(List<rfaDataContainer> requests,statusMessageWrapper message) 
            {
                this.requests=requests;
                this.message=message;
            }
        }
     /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to add the rfaWrappersForAllRequests. 
                               
        Version          : 1.0 
    */
        global class rfaDataContainer{
             /*~~~~Start of Variable Initialization~~~~*/     
            WebService List<rfaWrappersForAllRequests> request;
            /*~~~~Constructors~~~~*/ 
            public rfaDataContainer(){}
            // Contructor Overloading to pass rfa details wrapper- rfaWrappersForAllRequests
            public rfaDataContainer(List<rfaWrappersForAllRequests> request) 
            {
                this.request=request;
            }
        }
     /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to add the rfaDetails & user details wrapper. 
                               
        Version          : 1.0 
    */
        global class rfaWrappersForAllRequests{
              /*~~~~Start of Variable Initialization~~~~*/     
            WebService String rfaId; // rfaId represents as UserId
            WebService String level; // RFA Level
            WebService String requestTitle; // RFA Request Title
            WebService DateTime submitDate;  // RFA CreatedDate
            WebService Boolean hasAttachment; // RFA Attachments exists
            WebService List<usersWrappers> users; // Users details wrapper
           /*~~~~End of Variable Initialization~~~~*/
           
           /*~~~~Constructors~~~~*/ 
            public rfaWrappersForAllRequests(){}
            // Contructor Overloading to pass rfa details- rfaId, level, requestTitle, submitDate,hasAttachment,usersWrappers
            public rfaWrappersForAllRequests(String rfaId,String level,String requestTitle,DateTime submitDate,Boolean hasAttachment,List<usersWrappers> users)
            {
                this.rfaId=rfaId;
                this.level=level;
                this.requestTitle=requestTitle;
                this.submitDate=submitDate;
                this.hasAttachment=hasAttachment;
                this.users=users;      
            
            }
            
        }
    /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to add the user details wrapper. 
                               
        Version          : 1.0 
    */
        global class usersWrappers{
             /*~~~~Start of Variable Initialization~~~~*/     
            WebService List<userDetailWapper> user;
            /*~~~~End of Variable Initialization~~~~*/
            
             // Contructor Overloading to pass USerRole details wrapper- userDetailWapper
            public usersWrappers(List<userDetailWapper> user)
            {
                this.user=user;
            }
            
        }
    /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to display the email and federationId in the Service . 
        Version          : 1.0 
    */ 
        global class userDetailWapper{
            WebService String email;
            WebService String federationId;
            /*~~~~End of Variable Initialization~~~~*/
            
            // Contructor Overloading to pass USerRole details - Email, UserName__C
            public userDetailWapper(String email,String federationId)
            {
                this.email=email;
                this.federationId=federationId;
            }
            
        } 
        
        /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to display the code and description Service StatusMessage. 
                               The wrapper class contains the 2 string values to display the code and description of the Status.
        Version          : 1.0 
    */
        global class statusMessageWrapper{
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
        
}