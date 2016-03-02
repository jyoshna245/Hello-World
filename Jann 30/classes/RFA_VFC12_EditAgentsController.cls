public class RFA_VFC12_EditAgentsController {

    /*~~~~Start of Variable Initialization~~~~*/

        public User userObj {get;set;}

    // identifier variable for transaction failure
    public boolean hasError{get;private set;}

    public RFA_VFC12_EditAgentsController(ApexPages.StandardController stdController) {
        ID  id = ApexPages.currentPage().getParameters().get('id');
        userObj = [Select Name, Email, RFA_Agent_1__c, RFA_Agent_2__c, RFA_Agent_3__c from User where Id =:id] ;
    }
    
    
    
    public pageReference updateUserAgents()
    {
        try
        {
            hasError = false;
            
            // if logged in user is not an RFA Admin not a Location Coordinator, do not allow update to agent fields
            if (!RFA_WS07_CheckRFAUser.isRFAAdmin() && !RFA_WS07_CheckRFAUser.isLocationCoordinator())
            {
                throw new UserEditException('You do not have authorization to perform this action.');
            }
            // if any of the three agent fields match the selected user id
            else if (userObj.id == userObj.RFA_Agent_1__c || userObj.id == userObj.RFA_Agent_2__c || userObj.id == userObj.RFA_Agent_3__c)
            {
                throw new UserEditException('Agents selected cannot be the same as user.');
            }
           else // allow save
                update userObj;
        }
        catch(UserEditException userEx)
        {            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, userEx.getMessage())); 
            hasError = true;
            return null;
        }
        catch(Exception ex)
        {
            ApexPages.addMessages(ex); 
            hasError = true;
            return null;
        }
        
        return null;
    }

      // Custom Exception class extending Exception.
      public class UserEditException extends Exception{}

}