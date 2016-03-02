/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_WS07_CheckRFAAdmin
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 04/26/2013
 *  Assumptions      : N/A
 *  Description      : Class for checking RFA user type for logged in user. This class is used in custom button at Reporting Unit level.
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
global class RFA_WS07_CheckRFAUser{

	public static boolean isAdmin; // flag to identify if user is a RFA admin
	
	public static List<ProfitCenterUserRole__c> pcAssociatedUsers; // Profit Center Location Coordinators records for logged in user

    /**
     *  isRFAAdmin() method
     *  Checks if logged in user is an RFA Admin type
     *  WebService method
     *  @return boolean(true, false)   
     */
    WebService static boolean isRFAAdmin()
    {
    	if (isAdmin != null)
    		return isAdmin;
    		
        User usr=[Select Profile.Name, id from User where id=:UserInfo.getUserId() Limit 1]; // User query to fetch profile Name for logged In user to bypass the custom validation
        
        String UserNameProfile=usr.Profile.Name; //storing the profile name
        
        if(UserNameProfile==Label.RFA_CL053 || // System Administrator
            UserNameProfile==Label.RFA_CL052 || // RFA - System Administrator
            UserNameProfile==Label.RFA_CL054 || // RFA - Capital Management Admin
            UserNameProfile==Label.RFA_CL055) // RFA - Capital Management Team Member
        { 
        	isAdmin = true; // user is a RFA system admin   
        }
        
        else isAdmin = false; // user is not a RFA system admin
        
        return isAdmin;
    }

    /**
     *  isLocationCoordinator() method
     *  Checks if logged in user is a Location Coordinator under any profit center
     *  @return boolean(true, false)   
     */
    global static Boolean isLocationCoordinator()
    {
        // pull back list of Location Coordinator records associated to profit centers for logged in user
        if (pcAssociatedUsers == null)
			pcAssociatedUsers =  [Select id from ProfitCenterUserRole__c where UserType__c =:RFAGlobalConstants.PC_USERTYPE_LC and UserName__c =:UserInfo.getUserId()];
        
        // if logged in user is a location for at least one Profit Center, return true
        if (pcAssociatedUsers.size() > 0)
            return true;

        // else, return false. Logged in user is not a Location Coordinator under any profit centers
        return false;
    }
    
    /**
     *  isNotRequestorWithEditOnRFA(Set<Id> RFA) method
     *  Checks if logged in user is a user with edit access to an RFA ignoring Requestor type
     *  @return Map<Id, Boolean> RFA id, Boolean true = is user with write access and not requestor. else, false
     */
    global static Map<Id, Boolean> ignoreRequestorWithEditOnRFA(Set<Id> rfaIds)
    {
		Set<Id> rfaIsLC = new Set<Id>(); // used to store unique RFA Ids which logged in user has edit access to and is not a requestor.
		Map<Id, Boolean> toReturn = new Map<Id, Boolean>(); // will be the Map which is returned at the end of this method
		String requestorRowCause = Label.RFA_CL076 + '__c'; // KORequestor__c

    	for (RFA__Share rfaLCUser: [Select id, ParentId from RFA__Share where RowCause != :requestorRowCause AND UserOrGroupId =:UserInfo.getUserId() AND ParentId IN :rfaIds AND AccessLevel = 'Edit'])
    	{
    		rfaIsLC.add(rfaLCUser.ParentId);
    	}
    	
    	// build Map<Id, Boolean> toReturn
    	for (Id rfaId: rfaIds)
		{
			if (rfaIsLC.contains(rfaId))
				toReturn.put(rfaId, true);
			
			else
				toReturn.put(rfaId, false);
		}
        
        return toReturn;
    }
}