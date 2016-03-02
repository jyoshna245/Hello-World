/*
    Author           : Accenture
    Date Created  : 05/15/2012
    Description     : This class determines the logged in user's access level on the RFA.
                           This class is extended by the Other classes to inherit the security of the logged in user to perform actions.
    Version History: 1.0
*/
public virtual class RFA_Util_SecurityMatrix
{
    public String level;
    
    public RFA__c rfaObj;
    
    public UserAccess userAcc{get; private set;}
    
    public List<RFAUserRole__c> pendingWorkItems = new List<RFAUserRole__c>();
    
    

    
    // constructor for the class.   
    public RFA_Util_SecurityMatrix(ApexPages.StandardController controller)
    {
        // Initialize Local Variables.
        rfaObj = (RFA__c)controller.getRecord();
        this.level = rfaObj.Level__c;
        boolean isAdmin = evaluateIfAdmin();
        //End of Variable Initialization
        System.debug('\n ******************* Is System Admin or Capital Management User : '+isAdmin );
        
        if(isAdmin)
        {
            userAcc = new UserAccess(true, true, false, false, true, level);
            evaluateIfCurrentApprover(userAcc, level, UserInfo.getUserId());
        } 
        else
        {
            System.debug('\n in else part of security matrix');
            evaluateUserAccess(UserInfo.getUserId(), level);
        }
            
            
            
    }
    //End Of Constructor 
        
    
    /* @Method <This method sets the access level of an Logged in user>
        @param <None>
        @return Boolean - Return whether Logged in User should have admin access on RFA based on Logged in User's profile
    */
    public boolean evaluateIfAdmin()
    {
         boolean check = false;
         for(Profile profile : [Select Id From Profile Where Name = 'RFA - System Administrator' OR Name = 'RFA - Capital Management Admin' OR Name = 'System Administrator' OR Name = 'RFA - Capital Management Team Member'])
         {
             if(UserInfo.getProfileId() == profile.Id)
                check = true;
         }
         return check;
    }
    /*~~~~End of Admin and Capital MAnager evaluation Method~~~~*/
    
    
    public void evaluateUserAccess(Id userId, String level)
    {
        boolean hasNoAccess = true;
       
        Map<String, RFA__Share> rfaUserRoleAccess = getRFAUserAccess(userId);       
        
        
        System.debug('\n in else part of evaluateUserAccess');
    // Check for location coordinator permission
        userAcc = new UserAccess();
        /**
        for(RFA__Share share : rfaUserRoleAccess.values())
        {
            if(share.RowCause == rowCauseLC && share.UserOrGroupId == userId)
            {
                userAcc.isLocalCoordinator = true;
                hasNoAccess = false;    
            }
          
            
            if(share.RowCause == ROWCAUSE_REQUESTER && share.UserOrGroupId == userId)
            {
                userAcc.isRequester = true;
                hasNoAccess = false;
            }
            
            
            
        }*/
        for(RFA__Share share : rfaUserRoleAccess.values())
        {
            if(share.AccessLevel == 'Edit' && share.UserOrGroupId == userId && share.RowCause.contains(RFAGlobalConstants.ROWCAUSE_LABEL_LC))
            {
                userAcc.isLocalCoordinator = true;
                hasNoAccess = false;          
                evaluateIfCurrentApprover(userAcc, level, userId);  
            }
            
            if(share.UserOrGroupId == userId && share.RowCause.contains(RFAGlobalConstants.ROWCAUSE_REQUESTER))
            {
                    
                userAcc.isRequester = true;
                hasNoAccess = false;
                evaluateIfCurrentApprover(userAcc, level, userId);
            }
            
            if(hasNoAccess)
            {
                hasNoAccess = evaluateIfCurrentApprover(userAcc, level, userId);    
            }
            
        }          
        
        //hasNoAccess = evaluateIfCurrentApprover(userAcc, level, userId);
        if (hasNoAccess) userAcc = new UserAccess(false, false, false, false, false, level);
    }
    
    public boolean evaluateIfCurrentApprover(UserAccess userAcc, String level, String userId)
    {
         boolean hasNoAccess = true;    
                                   
            RFAUserRole__c[] approvers = RFA_AP03_ApprovalProcessHelper.getApproversForProcess(userId, rfaObj);                       

            if(!approvers.isEmpty())
            {
                  for(RFAUserRole__c approver : approvers)
                  {
                    if(approver.UserName__c <> null && approver.UserName__c == userId)
                    {
                        userAcc.isApprover = true;
                        hasNoAccess = false;
                    }
                    
                    if(approver.Agent1__c <> null && approver.Agent1__c == userId)
                    {
                        userAcc.isAgent = true;
                        hasNoAccess = false;
                    }else if(approver.Agent2__c <> null && approver.Agent2__c == userId)
                    {
                        userAcc.isAgent = true;
                        hasNoAccess = false;
                    }else if(approver.Agent3__c <> null && approver.Agent3__c == userId)
                    {
                        userAcc.isAgent = true;
                        hasNoAccess = false;
                    }
                  }
                  
                  
            }  
            return hasNoAccess;                         
    }
    
    public UserAccess getRFAUserAccess()
    {
        if(userAcc <> null)
        {
            return userAcc;
        }
        return null;
    }
    
    public Map<String, RFA__Share> getRFAUserAccess(String userId)
    {
        Map<String, RFA__Share> rfaRowCauseUserMap = new Map<String, RFA__Share>();
        for(RFA__Share share : [Select Id, Accesslevel, RowCause, UserOrGroupId FROM RFA__Share WHERE UserOrGroupId =: userId AND ParentId =: rfaObj.Id])
        {
            rfaRowCauseUserMap.put(share.RowCause, share);
        }
         return rfaRowCauseUserMap;
    }
    
    
    
    public class UserAccess
    {
        public boolean isLocalCoordinator;
        public boolean isAdmin;
        public boolean isApprover;
        public boolean isAgent;
        public boolean isRequester;
        public String level;
        
        // constructor for the class
        
        public UserAccess()
        {
            this.isLocalCoordinator = false;
            this.isAdmin = false;
            this.isApprover = false;
            this.isAgent = false;
            this.isRequester = false;
               
        }
        
        public UserAccess(boolean isLocalCoordinator, boolean isAdmin,
                          boolean isApprover, boolean isAgent, boolean isRequester, String level)
        {
            this.isLocalCoordinator = isLocalCoordinator;
            this.isAdmin = isAdmin;
            this.isApprover = isApprover;
            this.isAgent = isAgent;
            this.isRequester = isRequester;
            this.level = level;
        }
        
        public boolean isLocalCoordinator()
        {
            return isLocalCoordinator;
        }
        
        public boolean isAdmin()
        {
            return isAdmin;
        }
        
        public boolean isApprover()
        {
            return isApprover;
        }
        
        public boolean isAgent()
        {
            return isAgent;
        }
        
        public boolean isRequester()
        {
            return isRequester;
        }
        
        public String getLevel()
        {
            return level;
        }
                    
    }
    
    public class RFASecurityMatrixException extends Exception{}
}