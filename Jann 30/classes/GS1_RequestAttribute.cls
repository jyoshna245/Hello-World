/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 22, 2013
* Description  :     A class containing that attibutes to determine current web user's access to the request
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*
*/
public class GS1_RequestAttribute {
    GS1_Request__c req = null;
    public GS1_RequestAttribute (GS1_Request__c r) {
        this.req = r;
    }
    
    public boolean userCanSubmit {
        get {
            if (req == null) return false;
            if (!userCanEdit) return false;
            return req.status__c == GS1_Constants.REQUEST_STATUS_NEW || req.status__c ==  GS1_Constants.REQUEST_STATUS_REJECTED;                
        }
    }
    
    public boolean userCanAllocateEAN {
        get {
            if (req == null) return false;
            if (!userCanEdit) return false;        
            if (req.status__c != GS1_Constants.REQUEST_STATUS_APPROVED && 
                req.status__c != GS1_Constants.REQUEST_STATUS_REQUESTED) return false;
            if (!String.isBlank(req.EAN_Code__c)) return false;
            
            //determine if current user is GS1 Admin        
            if (!(GS1_CommonFunctions.isGS1Admin(System.Userinfo.getUserId())) && (!GS1_CommonFunctions.isSystemAdministrator())) return false;
            return true;                    
        }
    }
    
    public boolean userCanWithdraw {
        get {
            if (req == null) return false;        
            if (!userCanEdit) return false;
            if (req.status__c != GS1_Constants.REQUEST_STATUS_ALLOCATED) return false;
            if (String.isBlank(req.EAN_Code__c)) return false;
            
            //determine if current user is GS1 Admin        
            if (!(GS1_CommonFunctions.isGS1Admin(System.Userinfo.getUserId())) && (!GS1_CommonFunctions.isSystemAdministrator())) return false;
            return true;                
        }
    }
    
    public boolean userCanReactivate {
        get {
            if (req == null) return false;
            if (!userCanEdit) return false;
            if (req.status__c != GS1_Constants.REQUEST_STATUS_WITHDRAWN) return false;
            if (String.isBlank(req.EAN_Code__c)) return false;
            
            //determine if current user is GS1 Admin      
            if (!(GS1_CommonFunctions.isGS1Admin(System.Userinfo.getUserId())) && (!GS1_CommonFunctions.isSystemAdministrator())) return false;  
            return true;                
        }
    }
    
    public boolean userCanCreateCopy {
        get {
            if (req == null) return false;        
            if (req.status__c != GS1_Constants.REQUEST_STATUS_NEW) return false;
            if (!String.isBlank(req.EAN_Code__c)) return false;
            
            return true;                
        }
    }
    
    public boolean userCanEdit {
        get {
            boolean ret = false;
            Id userId = System.Userinfo.getUserId();
            Id recId = req.id;
            List<UserRecordAccess> acc = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId=:userId AND RecordId=:recId limit 1];
            if (acc.size()>0) {
                UserRecordAccess recAcc = acc[0];
                if ( recAcc.hasEditAccess ) {
                    ret = true;
                }
            }           
            
            return ret; 
        }
    }
    
    public boolean userCanCancelDuplicate {
        get {
            return userCanAllocateEAN;
        }
    }
    
    public boolean userCanAllocateShortLong {
        get {
            if ( req.Product_Type__c == 'Pallet') return false;
            return userCanAllocateEAN;
        }
    }                        
    
    public boolean userCanCancel {
        get {
            if (req == null) return false;
            if (!userCanEdit) return false;
            return req.status__c == GS1_Constants.REQUEST_STATUS_NEW;// || req.status__c ==  GS1_Constants.REQUEST_STATUS_REJECTED;                
        }
    }
}