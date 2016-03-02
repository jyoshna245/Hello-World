/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_RemoveInactiveApprovers
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 22/12/2015
 *  Description      : Class to remove the user from RFA Approver object when the user gets inactivated.
                                    
 ****************************************************************************************************************************************/
Public class RFA_RemoveInactiveApprovers
{
    Public void removeAfterUpdate(List<User> usersList)
    {
        List<Id> userId = new List<Id> ();
        for(User userObj : usersList)
        {
            system.debug('userObj.IsActive'+userObj.IsActive);
                
            if(userObj.IsActive == false)
            {
                userId.add(userObj.Id);
            }
        }
        if(userId!=null&&userId.size()>0)
        {
            futureRemoveApprovers(userId);
        }
        
    }
    @future
    public static void futureRemoveApprovers(List<ID> userIDs)
    {
        try{
        //Fetch all the RFA approvers 
        List<RFA_Approver__c> rfaApproversToBeDeleted = [select id,UserName__c from RFA_Approver__c where UserName__c in : userIDs];
        System.debug('RFA Approver List to be deleted : ' + rfaApproversToBeDeleted);        
        //Deleting the inactivated users from the RFA COA Group object
        if (rfaApproversToBeDeleted != null)
        {
                        Delete rfaApproversToBeDeleted;
        }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));       
        }
    }
}