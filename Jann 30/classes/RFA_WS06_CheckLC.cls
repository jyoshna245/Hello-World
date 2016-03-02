/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_AP14CheckLC
 *  Author           : Accenture
 *  Version History  : 3.0
 *  Creation         : 07/10/2012
 *  Assumptions      : N/A
 *  Description      : Class for checking the location coordinator for logged in user. This class is used in custom button at profit center level.
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
global class RFA_WS06_CheckLC{

    /**
     *  WebService method
     *  @param profitCenterId
     *  @return boolean(true, false)   
     */
    WebService static Boolean isLocationCoorinator(Id pfId)
    {
        
        User usr=[Select Profile.Name, id from User where id=:UserInfo.getUserId() Limit 1]; // User query to fetch profile Name for logged In user to bypass the custom validation
        String UserNameProfile=usr.Profile.Name; //storing the profile name
        Boolean flag=false;    
        if(UserNameProfile!=Label.RFA_CL053 &&  UserNameProfile!=Label.RFA_CL052 && UserNameProfile!=Label.RFA_CL054 && UserNameProfile!=Label.RFA_CL055)  // Bypass for System Admin profile
        { 
            // Query to get the profit center & associated users role into profit center
            for(ProfitCenter__C profitCenter : [Select id,(Select id from Profit_Center_Associated_Users__r where UserType__c =:RFAGlobalConstants.PC_USERTYPE_LC and UserName__c =:UserInfo.getUserId()  ) from ProfitCenter__c where Id=:pfId])
            {    
                system.debug(profitCenter);
                if(!profitCenter.Profit_Center_Associated_Users__r.IsEmpty())
                    flag=true;        
            }
        }
        else
        {
            flag=true;
        }
        return flag;
    }

}