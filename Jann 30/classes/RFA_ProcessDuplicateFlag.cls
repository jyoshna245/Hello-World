/**
* Class Name: RFA_ProcessDuplicateFlag
* Author: Accenture
* Date: 05-30-2013
* Project Name: Coke-RFA
* Requirement Description: Class to tick or untick duplicate flag on RFAUser/Approver records 
**/

public with sharing class RFA_ProcessDuplicateFlag {

Set<Id> rfaIdsSet=new Set<Id>();
Set<String> EmailIds=new Set<String>();
Set<Id> NottoCheck=new Set<Id>();

List<RFAUserrole__c> UserRoleRecordsToUpdate=new List<RFAUserrole__c>();

Map<Id,Set<String>> UserRoleList=new Map<Id,Set<String>>();
Map<Id,List<Rfauserrole__c>> rfaUserMap=new  Map<Id,List<Rfauserrole__c>>();
Map<Id,Map<String,List<RFAUserRole__c>>> newMap=new Map<Id,Map<String,List<RFAUserRole__c>>>();
Map<String,List<RFAUserRole__c>> secondMap=new Map<String,List<RFAUserRole__c>>();

// Get RecordTypes associated to RFAUser Role
public static Map<String, RecordType> approverRecordTypeMap = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());

public void ProcessDuplicateFlagAfterUpdate(List<RFAUserRole__c> userList,Map<Id,RFAUserRole__c> OldMap)
{
     for(RFAUserRole__c rfausr:userList)
                    {
                          rfaIdsSet.add(rfausr.RFA__c);
                          Nottocheck.add(rfausr.id);
                    }  
                    
         for(RFA__c rfa:[Select id,(Select id,RecordTypeId,username__r.email,RFA__c,DuplicateRecord__c,NotifyUsers__c from RFA_User_Roles__r where id not in :Nottocheck AND (RecordTypeId=:approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id OR RecordTypeId=:approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)) from RFA__c where id in :rfaIdsSet])
              {
                 if(rfa!=null && rfa.RFA_User_Roles__r!=null)
                       {
                            rfaUserMap.put(rfa.id,rfa.RFA_User_Roles__r);
                       }
              }
            
         for(ID KeyID:rfaUserMap.KeySet())
         {
            for(RFAUserRole__c rf:rfaUserMap.get(KeyID))
            {
            List<RFAUserRole__c> listRecords=new List<RFAUserRole__c>();
            listRecords.add(rf);
            if(secondMap.containsKey(rf.username__r.email))
            {
                secondMap.get(rf.username__r.email).addAll(listRecords);
            }
            else
                secondMap.put(rf.username__r.email,listRecords);
            }
            newMap.put(KeyId,secondMap);
            system.debug('Ashwani newMap After Update'+newMap);
         }
         
           for(RFAUserRole__c rfausr:userList)
                    {
                          if(newMap!=null && newMap.containsKey(rfausr.RFA__c))
                                if(newMap.get(rfausr.RFA__c).ContainsKey(OldMap.get(rfausr.id).email__c))
                                     for(RFAUserRole__c rfau : newMap.get(rfausr.RFA__c).get(OldMap.get(rfausr.id).email__c))
                                     {
                                      if(rfau.DuplicateRecord__c==true) 
                                      {
                                        rfau.DuplicateRecord__c=false;
                                        rfau.NotifyUsers__c=false;
                                        UserRoleRecordsToUpdate.add(rfau);
                                      }
                                     }
                    }
                    if(UserRoleRecordsToUpdate.size()>0) update UserRoleRecordsToUpdate;
                
}
     
public void ProcessDuplicateFlagBeforeUpdateInsert(List<RFAUserRole__c> userList)   
{
     for(RFAUserRole__c rfausr:userList)
                    {
                          rfaIdsSet.add(rfausr.RFA__c);
                          Nottocheck.add(rfausr.id);
                    }  
                    
         for(RFA__c rfa:[Select id,(Select id,RecordTypeId,username__r.email,RFA__c from RFA_User_Roles__r where id not in :Nottocheck AND (RecordTypeId=:approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id OR RecordTypeId=:approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)) from RFA__c where id in :rfaIdsSet])
              {
                 if(rfa!=null && rfa.RFA_User_Roles__r!=null)
                       {
                            rfaUserMap.put(rfa.id,rfa.RFA_User_Roles__r);
                       }
              }
         for(ID KeyID:rfaUserMap.KeySet())
         {
         	EmailIds = new Set<String>();
            for(RFAUserRole__c rf:rfaUserMap.get(KeyID))
            {
            EmailIds.add(rf.username__r.email);
            List<RFAUserRole__c> listRecords=new List<RFAUserRole__c>();
            listRecords.add(rf);
            if(secondMap.containsKey(rf.username__r.email))
            {
                secondMap.get(rf.username__r.email).addAll(listRecords);
            }
            else
                secondMap.put(rf.username__r.email,listRecords);
            }
            newMap.put(KeyId,secondMap);
            UserRoleList.put(KeyID,EmailIds);
            system.debug('Ashwani newMap Before Update'+newMap);
         }
         
           for(RFAUserRole__c rfausr:userList)
                    {
                          if(newMap!=null && newMap.containsKey(rfausr.RFA__c))
                                if(newMap.get(rfausr.RFA__c).ContainsKey(rfausr.email__c))
                                     for(RFAUserRole__c rfau : newMap.get(rfausr.RFA__c).get(rfausr.email__c))
                                     {
                                        if(rfau.recordTypeID==rfausr.recordTypeID)
                                        {
                                            rfausr.UserName__c.addError('Same User Already Exists');
                                        }
                                        else if(rfau.UserName__r.email==rfausr.Email__c )
                                        {
                                            rfausr.DuplicateRecord__c=true;
                                        }
                                        }
                                        else if (UserRoleList!=null && !(UserRoleList.get(rfausr.RFA__c).contains(rfausr.email__c)))  
                                        {
                                        	rfausr.DuplicateRecord__c=false;
                                        	rfausr.NotifyUsers__c=false;
                                        }
                                        
                                        
                                        
                          
                    }   
    
}




public void ProcessDuplicateFlagAfterDelete(List<RFAUserRole__c> userList )
{
    for(RFAUserRole__c rfausr:userList)
                    {
                          rfaIdsSet.add(rfausr.RFA__c);
                    }  
                    
         for(RFA__c rfa:[Select id,(Select username__r.email,RFA__c,DuplicateRecord__c,NotifyUsers__c from RFA_User_Roles__r where RecordTypeId=:approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id OR RecordTypeId=:approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id) from RFA__c where id in :rfaIdsSet])
              {
                 if(rfa!=null && rfa.RFA_User_Roles__r!=null)
                       {
                            rfaUserMap.put(rfa.id,rfa.RFA_User_Roles__r);
                       }
              }
           
             
         for(ID KeyID:rfaUserMap.KeySet())
         {
            for(RFAUserRole__c rf:rfaUserMap.get(KeyID))
            {
            List<RFAUserRole__c> listRecords=new List<RFAUserRole__c>();
            listRecords.add(rf);
            if(secondMap.containsKey(rf.username__r.email))
            {
                secondMap.get(rf.username__r.email).addAll(listRecords);
            }
            else
                secondMap.put(rf.username__r.email,listRecords);
            }
            newMap.put(KeyId,secondMap);
            system.debug('Ashwani newMap'+newMap);
         }
          for(RFAUserRole__c rfausr:userList) 
                    {
                          if(newMap!=null && newMap.containsKey(rfausr.RFA__c))
                          {
                            if(newMap.get(rfausr.RFA__c).containsKey(rfausr.email__c))
                            for(RFAUserRole__c rfau : newMap.get(rfausr.RFA__c).get(rfausr.email__c))
                                     {
                                      if(rfau.DuplicateRecord__c==true) 
                                        
                                        {
                                        rfau.duplicateRecord__c=false;
                                        rfau.NotifyUsers__c=false;
                                        UserRoleRecordsToUpdate.add(rfau);
                                        }
                                     }
                          }
                    }
                    if(UserRoleRecordsToUpdate.size()>0) update UserRoleRecordsToUpdate;
                          
                          
                    } 
                    
               
}