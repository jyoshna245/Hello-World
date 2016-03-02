/**
* Class Name: RFA_AP02_Shareutil 
* Author: Accenture
* Date: 02-06-2012
* Project Name: Coke-RFA
 * Requirement Description: This is the Utility Class to Give access to the users to teh RFA share based on various conditions.
 **/

public  class RFA_AP02_Shareutil {
       
    // for RFA create
    public List<RFA__Share> rfaShareListInsert=new List<RFA__Share>();
    public List<RFA__Share> rfaShareList;
    
    public List<RFA__Share> rfaShareListDelete=new List<RFA__Share>();
    public Static Map<String, String> rfaSharingReason=new Map<String, String>();
    public Map<String,String> rfaSharingReasonStaticList=rfaSharingReasonUtil.listAllRFASharingReason();
    
    public static Map<String, RecordType> approverRecordTypeMap = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
    
    /* RFA Create Methods******************************/
    public void rfaCreate(Map<Id, Id> UseridsMap) // Id for RFAIds, Id for UserId
    
    {
        rfaShareListInsert=new List<RFA__Share>();
        for(Id rfaId: UseridsMap.keySet())
        {
                RFA__Share rfaShare=new RFA__Share();
                rfaShare.AccessLevel='Edit';
                rfaShare.parentid=rfaId;
                rfaShare.RowCause=Schema.RFA__Share.RowCause.KORequestor__c;
                rfaShare.UserOrGroupId=UseridsMap.get(rfaId);
                rfaShareListInsert.add(rfaShare);
        
        }
        system.debug('\n for KO requestor'+rfaShareListInsert);
        if(rfaShareListInsert.size()>0)
        {
            insert rfaShareListInsert;
        }
        
        
    }
    /************************Provide ReadOnly Access to Location Coordinators if RFA is completed************/
    //Added by Ashwani for FR1.70
    public void ModifyLocationCoordinatorAccess(Set<ID> rfaMapforCompletedRFAs)
    {
        RFAShareList=new List<RFA__Share>();
  
     for(RFA__Share rfs:[select id,accesslevel from RFA__Share where parentid in :rfaMapforCompletedRFAs and rowcause='PCLocationCoordinator__c' and accessLevel='Edit'])
     {
                
         rfs.accessLevel='Read';
         RFAShareList.add(rfs);
            
     }
     
     if(RFAShareList.size()>0) update RFAShareList;
    }
    /************************Profit center permission at rfa creation****************************************/
    //Added by Ashwani for FR1.86 - rfaList in the parameter below
    public void profitCenterAtRfaCreateShare(Map<Id, Map<Id,String> > UseridsMap) // Id RFA Ids, Id for ProfitCenterID, String for LevelofRFA
    {
        //system.debug(UseridsMap+'%%%%%%%%%%%%%%%%%%%%%%%%%');
        rfaShareListInsert=new List<RFA__Share>();
        Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap=new Map<Id, List<ProfitCenterUserRole__c>>();
        Map<Id,String> rfaRecordTypeMap=new Map<Id,String>(); // rfa Id, RecordTypeName
        Set<id> ProfitCenterids=new Set<Id>();
        Map<Id,RFA__c> rfaMap=new Map<Id,RFA__c>(); //Added by Ashwani for FR1.86
        
      
        for(Id rfaId: UseridsMap.keySet() )
        {
            for(Id profitCenterId: UseridsMap.get(rfaId).keySet())
            {
                ProfitCenterids.add(profitCenterId);
            }
        }
        for(RFA__C rfaRec:[Select RecordType.Name, id,PrimaryDOACategorySubCategory__c,SecondDOACategorySubCategory__c,ThirdDOACategorySubCategory__c from rfa__c where Id IN: UserIdsMap.keyset()])
        {
            rfaRecordTypeMap.put(rfaRec.Id,rfaRec.RecordType.Name);
                rfaMap.put(rfaRec.Id,rfaRec);
        
        }
        for(ProfitCenter__c profitCenter: [Select Id, (Select id,UserName__c,Level__c,Usertype__c from Profit_Center_Associated_Users__r where UserName__r.IsActive=true order by level__c),name from ProfitCenter__c where Id IN:ProfitCenterids LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows()) ])
        {
            if (!profitCenter.Profit_Center_Associated_Users__r.IsEmpty())
                profitCenterMap.put(profitCenter.Id, profitCenter.Profit_Center_Associated_Users__r);
        }
        
        if(!profitCenterMap.IsEmpty())
        {
            for(Id rfaId: UseridsMap.keySet())
            {
                for(Id profitCenterId : UseridsMap.get(rfaId).keySet())
                {
                    String rfaLevel='';
                    try{
                        rfaLevel=UseridsMap.get(rfaId).get(profitCenterId);
                    }catch(Exception e)
                    {
                        rfaLevel='';
                    }
                    System.debug(rfaLevel+'@@@@'+profitCenterId+'#############'+rfaId);
                    if(profitCenterMap.get(profitCenterId)<>null)
                    {
                        for(ProfitCenterUserRole__c profitCenterUserRole: profitCenterMap.get(profitCenterId) )
                        {
                                    system.debug('rfaLevel'+rfaLevel);
                                    RFA__Share rfaShare=new RFA__Share();
                                    rfaShare.parentid=rfaId;
                                    rfaShare.RowCause=Schema.RFA__Share.RowCause.PCLocationCoordinator__c;
                                    if(profitCenterUserRole.UserType__c==RFAGlobalConstants.PC_USERTYPE_LC && (rfaLevel.contains(System.Label.RFA_CL001) && (profitCenterUserRole.Level__c.contains(System.Label.RFA_CL001) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL002) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL003) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL004) || (profitCenterUserRole.Level__c.contains(System.Label.RFA_CL005) && !profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006)) ||  profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006) )))
                                    {
                                        
                                        rfaShare.AccessLevel='Edit';
                                    }
                                    else if(profitCenterUserRole.UserType__c==RFAGlobalConstants.PC_USERTYPE_LC && rfaLevel.contains(System.Label.RFA_CL002) )
                                    {
                                        if(profitCenterUserRole.Level__c.contains(System.Label.RFA_CL002) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL003) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL004) || (profitCenterUserRole.Level__c.contains(System.Label.RFA_CL005) && !profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006)) ||  profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006) )
                                        {
                                            
                                            rfaShare.AccessLevel='Edit';
                                        }
                                        else if(profitCenterUserRole.Level__c.contains(System.Label.RFA_CL001) )
                                        {
                                            rfaShare.AccessLevel='Read';
                                        }   
                                    }
                                    else if(profitCenterUserRole.UserType__c==RFAGlobalConstants.PC_USERTYPE_LC && rfaLevel.contains(System.Label.RFA_CL003) )
                                    {
                                        if( profitCenterUserRole.Level__c.contains(System.Label.RFA_CL003) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL004) || (profitCenterUserRole.Level__c.contains(System.Label.RFA_CL005) && !profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006)) ||  profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006) )
                                        {
                                            rfaShare.AccessLevel='Edit';
                                        }
                                        else if(profitCenterUserRole.Level__c.contains(System.Label.RFA_CL002) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL001) )
                                        {
                                            rfaShare.AccessLevel='Read';
                                        }
                                    
                                    }
                                    else if(profitCenterUserRole.UserType__c==RFAGlobalConstants.PC_USERTYPE_LC && rfaLevel.contains(System.Label.RFA_CL004) )
                                    {
                                        if(  profitCenterUserRole.Level__c.contains(System.Label.RFA_CL004) || (profitCenterUserRole.Level__c.contains(System.Label.RFA_CL005) && !profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006)) ||  profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006) )
                                        {
                                            rfaShare.AccessLevel='Edit';
                                        }
                                        else if(profitCenterUserRole.Level__c.contains(System.Label.RFA_CL003) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL002) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL001) )
                                        {
                                            rfaShare.AccessLevel='Read';
                                        }
                                    
                                    }
                                    else if(profitCenterUserRole.UserType__c==RFAGlobalConstants.PC_USERTYPE_LC && rfaLevel.contains(System.Label.RFA_CL005) && !rfaLevel.contains(System.Label.RFA_CL006)  )
                                    {
                                        if(   (profitCenterUserRole.Level__c.contains(System.Label.RFA_CL005) && !profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006)) ||  profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006) )
                                        {
                                            rfaShare.AccessLevel='Edit';
                                        }
                                        else if(profitCenterUserRole.Level__c.contains(System.Label.RFA_CL004) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL003) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL002) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL001) )
                                        {
                                            rfaShare.AccessLevel='Read';
                                        }
                                    
                                    }
                                    else if(profitCenterUserRole.UserType__c==RFAGlobalConstants.PC_USERTYPE_LC && rfaLevel.contains(System.Label.RFA_CL006) )
                                    {
                                        if(  profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006) )
                                        {
                                            rfaShare.AccessLevel='Edit';
                                        }
                                        else if((profitCenterUserRole.Level__c.contains(System.Label.RFA_CL005) && !profitCenterUserRole.Level__c.contains(System.Label.RFA_CL006)) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL004) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL003) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL002) || profitCenterUserRole.Level__c.contains(System.Label.RFA_CL001) )
                                        {
                                            rfaShare.AccessLevel='Read';
                                        }
                                    
                                    }
                                    else if(profitCenterUserRole.UserType__c==RFAGlobalConstants.PC_USERTYPE_Viewer)
                                    {
                                        rfaShare.RowCause=Schema.RFA__Share.RowCause.PCReviewer__c;
                                        rfaShare.AccessLevel='Read';
                                    }
                                    else if(profitCenterUserRole.UserType__c==RFAGlobalConstants.PC_USERTYPE_RFCViewer)
                                    {
                                        If(rfaRecordTypeMap.get(rfaId)!=label.RFA_CL122)
                                        {
                                            rfaShare.RowCause=Schema.RFA__Share.RowCause.PCReviewer__c;
                                            rfaShare.AccessLevel='Read';
                                            rfaShare.UserOrGroupId=profitCenterUserRole.UserName__c;
                                            rfaShareListInsert.add(rfaShare);
                                        }
                                        //added by Ashwani for FR1.86
                                        else if(rfaRecordTypeMap.get(rfaId)==label.RFA_CL122)
                                        {
                                           if((rfaMap.get(rfaId).PrimaryDOACategorySubCategory__c!=null && rfaMap.get(rfaId).PrimaryDOACategorySubCategory__c.contains(label.RFA_FR1_86)) || (rfaMap.get(rfaId).SecondDOACategorySubCategory__c!=null && rfaMap.get(rfaId).SecondDOACategorySubCategory__c.contains(label.RFA_FR1_86)) || (rfaMap.get(rfaId).ThirdDOACategorySubCategory__c!=null && rfaMap.get(rfaId).ThirdDOACategorySubCategory__c.contains(label.RFA_FR1_86)))
                                            {
                                            rfaShare.RowCause=Schema.RFA__Share.RowCause.PCReviewer__c;
                                            rfaShare.AccessLevel='Read';
                                            rfaShare.UserOrGroupId=profitCenterUserRole.UserName__c;
                                            rfaShareListInsert.add(rfaShare);
                                            }
                                        }
                                    
                                    }
                                    if(profitCenterUserRole.UserType__c!=RFAGlobalConstants.PC_USERTYPE_RFCViewer)
                                    {
                                        rfaShare.UserOrGroupId=profitCenterUserRole.UserName__c;
                                        rfaShareListInsert.add(rfaShare);
                                    }
                        }
                    }
                }
            
            }
        }
        if(!rfaShareListInsert.IsEmpty())
        {
            system.debug('\n Custom Apex Sharing:--'+ rfaShareListInsert);
            insert rfaShareListInsert;
        }
    } 
    
    /**********************Reporting Unit users access at RFA creation***************************/
    public void reportingUnitCreteShare(Map<Id, Set<Id>> UseridsMap) // Id RFA Ids, Set<Id> for ReportingUnitIds
    {
        rfaShareListInsert=new List<RFA__Share>();  
        Set<id> reportingUnitIds=new Set<Id>();
        for(Id rfaId : UserIdsMap.keySet())
        {
            for(Id reportingUnitID:UserIdsMap.get(rfaId))
            {
                reportingUnitIds.add(reportingUnitID);
            }
        
        }
        Map<Id, List<ReportingUnitUserRole__c>> ReportingUnitMap=new Map<Id, List<ReportingUnitUserRole__c>>(); 
        for(ReportingUnit__c reportingUnit: [Select id, Reporting_Unit_Name__c, (Select id,User__c from ReportingUnitUserRoles__r where User__r.IsActive=true) from ReportingUnit__c where Id IN:reportingUnitIds LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())])
        {
            if(!reportingUnit.ReportingUnitUserRoles__r.IsEmpty())
                ReportingUnitMap.put(reportingUnit.Id, reportingUnit.ReportingUnitUserRoles__r);
        }
        if(!ReportingUnitMap.IsEmpty())
        {    for(Id rfaId: UseridsMap.keySet())
            {
                for(Id reportingUnitId:UserIdsMap.get(rfaId)) 
                {
                    if(ReportingUnitMap.get(reportingUnitId)!=null)
                    {
                    for(ReportingUnitUserRole__c tempUserRole: ReportingUnitMap.get(reportingUnitId) )
                        {
                            RFA__Share rfaShare=new RFA__Share();
                            rfaShare.AccessLevel='Read';
                            rfaShare.parentid=rfaId;
                            rfaShare.RowCause=Schema.RFA__Share.RowCause.ReportingUnitUsers__c;
                            rfaShare.UserOrGroupId=tempUserRole.User__c;
                            rfaShareListInsert.add(rfaShare);
                        }
                     }
            
                }
            }
         }
         if(!rfaShareListInsert.IsEmpty())
        {
            system.debug('\n Custom Apex Sharing:--'+ rfaShareListInsert);
            insert rfaShareListInsert;
        }
    }
    
    /**********************This method is not yet final. Will use in batch process****/
    public void profitCenteruserRoleInsert(Map<Id, Map<Id, String>> userRoleIds)   // profitId, UserId, UserTypeRole
    {
        rfaShareListInsert=new List<RFA__Share>();
        Map<Id, List<Rfa__c>> profitCenterRFAMap=new Map<Id, List<Rfa__c>>();
        for(ProfitCenter__C profitCenter: [Select Id, Name,(Select id,ProfitCenterNumber__c from RFA__r) from ProfitCenter__c where Id IN :userRoleIds.keyset() LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows()) ])
        {
            profitCenterRFAMap.put(profitCenter.Id, profitCenter.RFA__r );
        }
        for(Id profitCenterId: userRoleIds.keyset())
        {
            for(Id userId: (userRoleIds.get(profitCenterId)).keySet())
            {
                for(Rfa__c rfa: profitCenterRFAMap.get(profitCenterId))
                {
                        RFA__Share rfaShare=new RFA__Share();
                        rfaShare.parentid=rfa.Id;
                        if((userRoleIds.get(profitCenterId)).get(userId)==RFAGlobalConstants.PC_USERTYPE_LC)
                        {
                            rfaShare.RowCause='Location Coordinator Access';
                            rfaShare.AccessLevel='Edit';
                        }
                        else if((userRoleIds.get(profitCenterId)).get(userId)=='Viewer')
                        {
                            rfaShare.RowCause='Profit Center Reviewer Access';
                            rfaShare.AccessLevel='Read';
                        }
                        rfaShare.UserOrGroupId=userId;
                        rfaShareListInsert.add(rfaShare);
                }
            
            }
        
        }
        if(!rfaShareListInsert.IsEmpty())
        {
            system.debug('\n Custom Apex Sharing:--'+ rfaShareListInsert);
            insert rfaShareListInsert;
        }
    
    }
    
    /**********************This method is not yet final. Will use in batch process Ends here****/
    
    
    public void rfaApproversShareInsert(Map<String, Map<Id,String>> UseridsMap) // rfaId,UserId,Role--InfoUser,Approvers
    {
        System.debug('\n User Id Map :'+UseridsMap);
        rfaShareListInsert=new List<RFA__Share>();
        for(String rfa: UserIdsMap.KeySet())
        {           
            for(Id rfaUserRole:UseridsMap.get(rfa).KeySet())
            {
                RFA__Share rfaShare=new RFA__Share();               
                rfaShare.parentid=rfa;
                if(UseridsMap.get(rfa).get(rfaUserRole)== Schema.RFA__Share.RowCause.Approver__c)
                {
                    rfaShare.AccessLevel='Read';
                    rfaShare.RowCause=Schema.RFA__Share.RowCause.Approver__c;
                }               
                else if(UseridsMap.get(rfa).get(rfaUserRole)==Schema.RFA__Share.RowCause.Authors__c)
                {
                    rfaShare.AccessLevel='Read';
                    rfaShare.RowCause=Schema.RFA__Share.RowCause.Authors__c;
                }
                else if(UseridsMap.get(rfa).get(rfaUserRole)==Schema.RFA__Share.RowCause.KORequestor__c)
                {
                    rfaShare.AccessLevel='Edit';
                    rfaShare.RowCause=Schema.RFA__Share.RowCause.KORequestor__c;
                }else if(UseridsMap.get(rfa).get(rfaUserRole)==Schema.RFA__Share.RowCause.Reviewer__c)
                {
                    rfaShare.AccessLevel='Read';
                    rfaShare.RowCause=Schema.RFA__Share.RowCause.Reviewer__c;
                }
                
                
                rfaShare.UserOrGroupId=rfaUserRole;
                rfaShareListInsert.add(rfaShare);           
                
            }
        }
        if(!rfaShareListInsert.IsEmpty())
        {
            system.debug('\n Custom Apex Sharing:--'+ rfaShareListInsert);
            insert rfaShareListInsert;
        }
    
    }
    
    
    public void processAfterDeleteUserRole(List<RFAUserRole__c> userRoles)
    {
        
        for(RFAUserRole__c deletedUserRole : userRoles)
        {
            
        }
    }
    
    // Need to correct the logic
    // usersForDeletion<RFA ID, <User Id of deleted RFA_User_Role, Share Row Cause Value>>
    // changedUserRoles: set of deleted RFA_User_Role IDs
    public void rfaShareDeletion(Map<String, Map<Id, String>> usersForDeletion, Set<String> changedUserRoles)
    {
        // Retreive List of RFA records with list of child RFA_User_Roles__r                               
        RFA__c[] rfaRecords = [Select Id,
                            (Select UserName__c, Agent1__c, Agent2__c, Agent3__c, RecordTypeId, RecordType.Name FROM RFA_User_Roles__r where Id NOT IN: changedUserRoles)
                             FROM RFA__c Where Id IN: usersForDeletion.keySet() LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())];                              
        
        // Iterate through each RFA record retreived
        for(RFA__c rfa : rfaRecords)
        {
            Map<Id, String> userRoleMap = usersForDeletion.get(rfa.Id); // store map of User Ids which were deleted, Row Cause value per RFA Id
            Map<Id, String> associatedUsers = new Map<Id, String>(); // container for all current RFA associated users
            List<RFAUserRole__c> associatedUserRoles = rfa.RFA_User_Roles__r; // list of RFA child RFA_User_Roles__r records
            
            // logic to filter the delete list if another RFA_User_Roles record exists with the user as the same type.
            for(RFAUserRole__c userRole : associatedUserRoles)
            {
                if(userRole.UserName__c <> null && userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id)
                {
                    associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Approver__c);   
                }else if(userRole.UserName__c <> null && 
                        (userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id || 
                         userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id))
                {
                    associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.KORequestor__c);
                }else if(userRole.UserName__c <> null && userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id)
                {
                    associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);   
                }       
                if(userRole.Agent1__c <> null)
                {
                    if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id)
                        associatedUsers.put(userRole.Agent1__c,Schema.RFA__Share.RowCause.Approver__c); 
                        
                    else if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id)
                        associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);
                }
                if(userRole.Agent2__c <> null)
                {
                    if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id)
                        associatedUsers.put(userRole.Agent2__c,Schema.RFA__Share.RowCause.Approver__c); 
                        
                    else if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id)
                        associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);
                }
                if(userRole.Agent3__c <> null)
                {
                    if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id)
                        associatedUsers.put(userRole.Agent3__c,Schema.RFA__Share.RowCause.Approver__c); 
                        
                    else if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id)
                        associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);
                }
                    
            }
            
            // validate that the user to be delete from RFA__Share is not mapped to the same role in an existing RFA_User_Roles record and should have access removed
            // if the user is mapped to the same role on an existing RFA_User_Roles record, exclude the user from being deleted on the RFA__Share table.
            for(String userId : userRoleMap.keySet())
            {
                if(associatedUsers.containsKey(userId))
                {
                    if(userRoleMap.get(userId) == associatedUsers.get(userId))
                        userRoleMap.remove(userId); 
                }
            }
            usersForDeletion.put(rfa.Id, userRoleMap);
        }
        
        System.debug('\n *********************Map value for user for deletion after iteration'+usersForDeletion);
        
        deleteRFAShare(usersForDeletion);                               
    }
    
    
    
    /* @Method <This method validates other existing userroles before deleting and finally deletes the sharing record once the validation is passed.>
       @param <Map<Id, Map<Id, String>>> 
       @return <None>
    */ 
    public void deleteRFAShare(Map<String, Map<Id, String>> usersForDeletion)
    {
        List<RFA__Share> shareForDelete = new List<RFA__Share>();
        RFA__Share[] shareRecords = [Select UserOrGroupId, AccessLevel, RowCause, ParentId FROM RFA__Share where parentId IN : usersForDeletion.keySet() LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())];
        
        for(String rfa : usersForDeletion.keySet())
        {
            for(String user : usersForDeletion.get(rfa).keySet())
            {
                for(RFA__Share shareRec : shareRecords)
                {
                    if(shareRec.Parentid == rfa && shareRec.UserOrGroupId == user && shareRec.RowCause == usersForDeletion.get(rfa).get(user))
                    {
                        shareForDelete.add(shareRec);
                    }
                }   
            }
        }
        
        if(!shareForDelete.isEmpty()) delete shareForDelete;
    }
/* RFA Create Methods End here******************************/

/* RFA Update Methods******************************/
    
    // If RFA Profit Center Changes
    public void rfaProfitCenterUpdateDeleteOldProfitCenter(Map<Id, Id> UseridsMap) // Id RFA Ids, Id for ProfitCenterID   
    {
        rfaShareListInsert=new List<RFA__Share>();
        rfaShareListDelete=new List<RFA__Share>();
        Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap=new Map<Id, List<ProfitCenterUserRole__c>>();
        Set<id> ProfitCenterids=new Set<Id>();
        Map<Id, List<RFA__Share>> rfaShareOldMap=new map<Id, List<RFA__Share>>();
        
        List<String> rowCauseList =new List<String>();
        rowCauseList.add('PCReviewer__c');
        rowCauseList.add('PCLocationCoordinator__c');
        for(RFA__c rfa: [Select id, name,ProfitCenterNumber__c, (Select id,parentId,AccessLevel from Shares where rowcause IN : rowCauseList) from RFA__c where Id IN : UseridsMap.keySet() LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())])
        {
            rfaShareOldMap.put(rfa.Id, rfa.Shares);
        }
        
        for(Id rfaId: UseridsMap.keySet())
        {
            
        
            for(RFA__Share rfaShareRecord : rfaShareOldMap.get(rfaId))
            {
                RFA__Share rfaShareOldRecord=new Rfa__Share(id=rfaShareRecord.id);
                rfaShareListDelete.add(rfaShareOldRecord);
                
            }
        }
        if(rfaShareListDelete.size()>0)
        {
            delete rfaShareListDelete;
        }
    }
    
    // Deletes all RFA Reporting Unit sharing users from the RFA__Share object. Parameter passed will be used to identify which RFA__Share records to delete
    public void rfaReportingUnitChangeDelete(Map<Id,Set<Id>> UserIdsMap)
    {
        rfaShareListDelete=new List<RFA__Share>();  
        List<String> rowCauseList = new List<String>();
        rowCauseList.add('ReportingUnitUsers__c');
        for(RFA__c rfa: [Select id, name, (Select id,parentId,AccessLevel from Shares where rowcause IN : rowCauseList) from RFA__c where Id IN : UseridsMap.keySet() LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())])
        {
            if(!rfa.Shares.IsEmpty())
            {
                for(RFA__Share rfaShareRecord : rfa.Shares)
                {
                    RFA__Share rfaShareOldRecord=new Rfa__Share(id=rfaShareRecord.id);
                    rfaShareListDelete.add(rfaShareOldRecord);
                }
            }
                
        }

        if(rfaShareListDelete.size()>0)
        {
            delete rfaShareListDelete;
        }    
    }   

/*****************************RFA Sharing for Pending Board Review**************************************************/   
    public void rfaSharePendingBoardeview(Set<Id> rfaIds) // Rfaids for given permission for all location coordinator.
    {
        rfaShareListInsert=new List<RFA__Share>();
        Map<Id, List<RFA__Share>> rfaShareOldMap=new map<Id, List<RFA__Share>>();
        List<String> rowCauseList =new List<String>();
        rowCauseList.add('PCLocationCoordinator__c');
        for(RFA__c rfa:[Select id, name, (Select id,parentId,AccessLevel from Shares where rowcause IN : rowCauseList) from RFA__c where Id IN : rfaIds LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())])
        {
            if(!rfa.Shares.IsEmpty())
                rfaShareOldMap.put(rfa.Id, rfa.Shares);
        }
        if(!rfaShareOldMap.IsEmpty())
        {
            for(Id rfaId:rfaIds)
            {
                for(RFA__Share rfaShareRecord : rfaShareOldMap.get(rfaId))
                {
                    RFA__Share rfaShareOldRecord=new Rfa__Share(id=rfaShareRecord.id);
                    rfaShareOldRecord.AccessLevel='Read';
                    rfaShareListInsert.add(rfaShareOldRecord);
                    
                }
            
            }
        }
        if(!rfaShareListInsert.IsEmpty())
            update rfaShareListInsert;
        
    }

    public Integer compareRFALevel(String levelToCompare1, String levelToCompare2)
    {
        if ((levelToCompare1.contains(System.Label.RFA_CL001) && levelToCompare2.contains(System.Label.RFA_CL001)) ||
            (levelToCompare1.contains(System.Label.RFA_CL002) && levelToCompare2.contains(System.Label.RFA_CL002)) ||
            (levelToCompare1.contains(System.Label.RFA_CL003) && levelToCompare2.contains(System.Label.RFA_CL003)) ||
            (levelToCompare1.contains(System.Label.RFA_CL004) && levelToCompare2.contains(System.Label.RFA_CL004)) ||
            (levelToCompare1=='5. Executive' && levelToCompare2=='5. Executive') || //fix for INC1082997 BSA 5-Nov-2013
            (levelToCompare1.contains(System.Label.RFA_CL006) && levelToCompare2.contains(System.Label.RFA_CL006)) )
            {
                system.debug('RSAS - it went to  0');
                // levelToCompare1 == levelToCompare2, return 0
                return 0;
            }
        
        else if ( (levelToCompare1.contains(System.Label.RFA_CL001) && 
                    (levelToCompare2.contains(System.Label.RFA_CL002) ||
                     levelToCompare2.contains(System.Label.RFA_CL003) ||
                     levelToCompare2.contains(System.Label.RFA_CL004) ||
                     levelToCompare2.contains(System.Label.RFA_CL005) ||
                     levelToCompare2.contains(System.Label.RFA_CL006) )
                  ) || 
                  (levelToCompare1.contains(System.Label.RFA_CL002) &&
                    (levelToCompare2.contains(System.Label.RFA_CL003) ||
                     levelToCompare2.contains(System.Label.RFA_CL004) ||
                     levelToCompare2.contains(System.Label.RFA_CL005) ||
                     levelToCompare2.contains(System.Label.RFA_CL006) )
                  ) || 
                  (levelToCompare1.contains(System.Label.RFA_CL003) &&
                    (levelToCompare2.contains(System.Label.RFA_CL004) ||
                     levelToCompare2.contains(System.Label.RFA_CL005) ||
                     levelToCompare2.contains(System.Label.RFA_CL006) )
                  ) || 
                  (levelToCompare1.contains(System.Label.RFA_CL004) &&
                    (levelToCompare2.contains(System.Label.RFA_CL005) ||
                     levelToCompare2.contains(System.Label.RFA_CL006) )
                  ) || 
                  (levelToCompare1.contains(System.Label.RFA_CL005) &&
                    levelToCompare2.contains(System.Label.RFA_CL006)) )
        {
            // levelToCompare1 < levelToCompare2, return -1
            system.debug('RSAS - it went to negative 1');
            return -1;
        }
        
        else // levelToCompare1 > levelToCompare2, return 1
            system.debug('RSAS - it went to  1');
            return 1;
    }


}