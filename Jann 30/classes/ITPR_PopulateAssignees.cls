/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_PopulateAssignees
 *  Author           : Infosys
 *  Version History  : 1.1
 *  Creation         : 10/02/2014
 *  Assumptions      : N/A 
 *  Description      : This class is written to Auto populate the assignees from Assignment Routing table based on Request type,
                       Category,Organization and DLA Checkbox. This class also provides the manual sharing to assignees and 
                       requestors based on the Status. And Added access level for 3 additional approver                                        
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

public class ITPR_PopulateAssignees {

    /*~~~~Start of Initialization~~~~*/
    public List<User> listUsers = [SELECT Id, ITPR_Department__c, Profile.Name FROM User WHERE Id=:userinfo.getUserId() LIMIT 1]; //new dept changes
    public String DeptName = (listUsers != null && listUsers.size() > 0 && listUsers[0].ITPR_Department__c != null)? listUsers[0].ITPR_Department__c : ''; //new dept changes
    public Id profileId=userinfo.getProfileId();
    public String profileName = (listUsers != null && listUsers.size() > 0)? listUsers[0].Profile.Name:null;
    public List<ITPR__Share> sre = new list<ITPR__Share>();
    public List<ITPR__Share> sre1 = new list<ITPR__Share>();
    public Set<String> ITPRDept = new Set<String>{'ITSES - Requestor','ITSES - Procurement','ITSES - Legal','ITSES - Finance','ITSES - Vendor Governance', 'ITSES - Approver'};
    public Map<Id,User> use = new Map<Id,User>([Select Id,Name,ITPR_Department__c from User where ITPR_Department__c IN: ITPRDept]); 
    /*~~~~End of Initialization~~~~*/
 
    /*********************This method is called in ITPR_AutoPopulateAssignee before insert Trigger.This calculates the Dynamic Logic Assignment while creation of ITPR Request***************/ 

    public void AssigneeInsert(List<ITPR__c> newitpr, Map<Id, Assignment_Routing_Rules__c> itprAssigneesIns) {
    List<ITPR__c> newitprlist= new List<ITPR__c>(newitpr);
    for(ITPR__c itpr: newitprlist)
        {
            /*************************check for with preferred categories and throw and error if they are used******************/
            if(itpr.Category__c == 'Production Support w/Preferred Supplier' || itpr.Category__c == 'Solution Delivery w/Preferred Suppliers'){
               itpr.addError(System.Label.ITPR_WithPreferredCheck);
            }  
            
            /*************Error message when Request type is RFI or RFP and approver is populated************/      
            if((itpr.Request_Type__c == System.Label.ITPR_Request_Type_RFI) || (itpr.Request_Type__c == System.Label.ITPR_Request_Type_RFP)){
                if(itpr.Wave1_Approver_1__c !=null || itpr.Wave1_Approver_2__c !=null ||itpr.Wave1_Approver_3__c !=null ||itpr.Wave1_Approver_4__c !=null ||itpr.Wave1_Approver_5__c !=null ||
                   itpr.Wave2_Approver_1__c !=null ||itpr.Wave2_Approver_2__c !=null ||itpr.Wave2_Approver_3__c !=null ||itpr.Wave2_Approver_4__c !=null ||itpr.Wave2_Approver_5__c !=null ||
                   itpr.Wave3_Approver_1__c !=null ||itpr.Wave3_Approver_2__c !=null ||itpr.Wave3_Approver_3__c !=null ||itpr.Wave3_Approver_4__c !=null ||itpr.Wave3_Approver_5__c !=null){
                    itpr.AddError(System.Label.ITPR_Approver_RFI_RFP_Error);
                }
            }    
            /*************Error message when Request type is not RFI or RFP and approver is not populated************/   
            /******** & Request type should not NDA*********/   
            else{
                if(itpr.Request_Type__c!='NDA' && itpr.Wave2_Approver_1__c == null && itpr.Wave2_Approver_2__c == null && itpr.Wave2_Approver_3__c == null && itpr.Wave2_Approver_4__c == null && itpr.Wave2_Approver_5__c == null){
                    itpr.AddError(System.Label.ITPR_Atleast_One_Approver);
                }
            }
            
            /*************Error message when Submitted on behalf is anyone other than requestor************/      
            if((itpr.Submitted_on_behalf_of__c != null) &&(use.get(itpr.Submitted_on_behalf_of__c)==null)){
                itpr.AddError(System.Label.ITPR_Error_Anyone_From_Requestors);
            }
            if(itpr.Submitted_on_behalf_of__c == null){
                if(DeptName != null && DeptName == System.Label.ITPR_Requestor_profile){
                    itpr.Submitted_on_behalf_of__c = Userinfo.getUserId();       
                }          
            }     
      /*************When there are dynamic rules matching the ITPR Request Type/Category/Organization auto populate assignees************/
           ItprCalculateRules(itpr,itprAssigneesIns);     
                 
        /*************Before inserting the Assignees check if there is any delegation of an assignee************/
            ItprRecalculatewithDelegation(itpr);
            
            //itpr.Wave1_Approver_1__c = itpr.Finance_Assignee__c;
                      
      /*************Assigning the Status to Draft while creation************/ 
      itpr.Status__c = System.Label.ITPR_Status; 
      if((itpr.Request_Type__c != System.Label.ITPR_Request_Type_RFI) && (itpr.Request_Type__c != System.Label.ITPR_Request_Type_RFP)){
      itpr.Wave1_Approver_1__c = itpr.Finance_Assignee__c;
      }                 
    } 
}
/*********************This method updates the Assignees after recalculating the Dynamic Logic Assignment while updating of ITPR Request***************/  

  public void AssigneeUpdate(List<ITPR__c> newitpr, Map<Id, Assignment_Routing_Rules__c> itprAssigneesUpd,Map<Id, ITPR__c> oldMapITPR) 
  { 
    List<ITPR__c> newitprlist = new List<ITPR__c>(newitpr);
    for(ITPR__c itpr: newitprlist)
    {
       /*********************Assigning the Delegation checkboxes to False***************/  
        /*itpr.Delegated_Procurement_Assignee__c = false;
        itpr.Delegated_Legal_Assignee__c = false;
        itpr.Delegated_Finance_Assignee__c = false;
        itpr.Delegated_Vendor_Governance_User__c = false;*/
        
        /*********************Validation RFI and RFP should not have a single Approver***************/   
        if((itpr.Request_Type__c == System.Label.ITPR_Request_Type_RFI) || (itpr.Request_Type__c == System.Label.ITPR_Request_Type_RFP)){
            if(itpr.Wave1_Approver_1__c !=null || itpr.Wave1_Approver_2__c !=null ||itpr.Wave1_Approver_3__c !=null ||itpr.Wave1_Approver_4__c !=null ||itpr.Wave1_Approver_5__c !=null ||
               itpr.Wave2_Approver_1__c !=null ||itpr.Wave2_Approver_2__c !=null ||itpr.Wave2_Approver_3__c !=null ||itpr.Wave2_Approver_4__c !=null ||itpr.Wave2_Approver_5__c !=null ||
               itpr.Wave3_Approver_1__c !=null ||itpr.Wave3_Approver_2__c !=null ||itpr.Wave3_Approver_3__c !=null ||itpr.Wave3_Approver_4__c !=null ||itpr.Wave3_Approver_5__c !=null){
                itpr.AddError(System.Label.ITPR_Error_Approver_for_RFI_RFP);
            }
        }
        /*********************Validation RFI and RFP should not have a single Approver***************/  
       /************** && Validation for Request Type Not equal to NDA ***************/
        if((userinfo.getUserId() == itpr.Submitted_on_behalf_of__c) || (userinfo.getName() == itpr.Submitted_by__c) || (ProfileName == System.Label.ITPR_System_Admin)||(userinfo.getUserId() == itpr.Manager__c)|| (userinfo.getUserId() == itpr.Delegated_Requestor__c)|| (userinfo.getUserId() == itpr.Transfered_Requestor__c)){
            if((itpr.Status__c == System.Label.ITPR_Submitted_Status)|| (itpr.Status__c == System.Label.ITPR_Status)){
                if(itpr.Wave2_Approver_1__c == null && itpr.Wave2_Approver_2__c == null && itpr.Wave2_Approver_3__c == null && itpr.Wave2_Approver_4__c == null && itpr.Wave2_Approver_5__c == null && itpr.Request_type__c !='RFI' && itpr.Request_type__c !='RFP' && itpr.Request_type__c !='NDA' ){
                    itpr.AddError(System.Label.ITPR_Atleast_One_Approver);
                }
            }    
        }
        /*********************Population of Submitted on behalf of***************/ 
        if(itpr.Submitted_on_behalf_of__c != null){
            if(use.get(itpr.Submitted_on_behalf_of__c)==null){
                itpr.AddError(System.Label.ITPR_Error_Anyone_From_Requestors);
            }
        }
        else if(itpr.Submitted_on_behalf_of__c == null){
            if(DeptName != null && DeptName  == System.Label.ITPR_Requestor_profile){
                itpr.Submitted_on_behalf_of__c = itpr.CreatedById;
            }
        } 
        
       /*********************Fetching the last values of ITPR record***************/ 
        ITPR__c ls = oldMapITPR.get(itpr.Id);
        
        itpr.Primary_Assignee_Prior_Value__c = ls.Primary_Assignee__c;

        /*********************Validation - Requestor should not change the Approver once it comes back to Pending More Info***************/  

        if((userinfo.getUserId() == itpr.Submitted_on_behalf_of__c) || (userinfo.getName() == itpr.Submitted_by__c) ||(userinfo.getUserId() == itpr.Manager__c)|| (userinfo.getUserId() == itpr.Delegated_Requestor__c) || (userinfo.getUserId() == itpr.Transfered_Requestor__c)){
            if(((itpr.Status__c == System.Label.ITPR_Pending_More_Info_Needed_Status) ||(itpr.Status__c == System.Label.ITPR_Pending_Project_Final_Budget_Status)) && ((itpr.Wave2_approver_1__c!=ls.wave2_approver_1__c)||(itpr.Wave2_approver_2__c!=ls.wave2_approver_2__c)||(itpr.Wave2_approver_3__c!=ls.wave2_approver_3__c)||(itpr.Wave2_approver_4__c!=ls.wave2_approver_4__c)||(itpr.Wave2_approver_5__c!=ls.wave2_approver_5__c))){
                itpr.AddError(System.Label.ITPR_Error_Modify_Approver);
            }
        }

        /*********************Recalculating the Dynamic rules based on change in the Request Parameters***************/ 
        
        if((userinfo.getName() == itpr.Primary_Assignee__c) || (userinfo.getUserId() == itpr.Submitted_on_behalf_of__c) || (userinfo.getName() == itpr.Submitted_by__c) || (ProfileName == System.Label.ITPR_System_Admin)|| (ProfileName == System.Label.ITPR_Finance_Admin)|| (ProfileName == System.Label.ITSES_Procurement_Business_Administrator)|| (ProfileName == System.Label.ITSES_Legal_Business_Administrator)|| (ProfileName == System.Label.ITSES_VendorGovernance_Business_Administrator)||(userinfo.getUserId() == itpr.Manager__c)|| (userinfo.getUserId() == itpr.Delegated_Requestor__c)|| (userinfo.getUserId() == itpr.Transfered_Requestor__c)){                                         
            if((((itpr.Request_Type__c != ls.Request_Type__c) || (itpr.Category__c != ls.Category__c) || (itpr.Organization__c != ls.Organization__c)) && (itpr.Do_Not_Auto_Assign__c != True)) || ((itpr.Do_Not_Auto_Assign__c != ls.Do_Not_Auto_Assign__c) &&(itpr.Do_Not_Auto_Assign__c != True))){                                                     
                if(itpr.Status__c != System.Label.ITPR_Pending_Project_Final_Budget_Status) {
                ItprCalculateRules(itpr,itprAssigneesUpd);
                }
                else{
                    itpr.AddError(System.Label.ITPR_Error_Change_Request_Parameters); 
                }                         
             }
             else{  
                if((itpr.Procurement_Assignee__c == null) && (itpr.Legal_Assignee__c == null)){                            
                    itpr.AddError(System.Label.ITPR_Error_Removing_Assignee);                            
                }
                else{
                    if(itpr.Procurement_Assignee__c != null){
                         if((itpr.Procurement_Assignee__c !=ls.Procurement_Assignee__c) &&((itpr.Status__c == System.Label.ITPR_Submitted_Status) || (itpr.Status__c == System.Label.ITPR_Assigned_Status))){
                              itpr.Primary_Assignee__c = use.get(itpr.Procurement_Assignee__c).Name ;
                              itpr.Status__c = System.Label.ITPR_Assigned_Status;
                         }
                         else{
                              try{
                              itpr.Primary_Assignee__c = use.get(itpr.Procurement_Assignee__c).Name ;
                              }
                              catch(Exception e){
                              itpr.Primary_Assignee__c = '';
                              }
                         }
                     }                       
                     else{
                         if((itpr.Legal_Assignee__c !=ls.Legal_Assignee__c) &&((itpr.Status__c == System.Label.ITPR_Submitted_Status) || (itpr.Status__c == System.Label.ITPR_Assigned_Status))){
                              itpr.Primary_Assignee__c = use.get(itpr.Legal_Assignee__c).Name ;
                              itpr.Status__c = System.Label.ITPR_Assigned_Status;
                         }
                         else{
                              try{
                                  itpr.Primary_Assignee__c = use.get(itpr.Legal_Assignee__c).Name ;
                              }
                              catch(Exception e){
                                  itpr.Primary_Assignee__c = '';
                              }
                         }
                           
                     }
                  }
              }                                                
       }  
       /*********************Error message when Anyone other than Primary Assignee is changing the request parameters and saving the request***************/                   
       else {      
           if((itpr.Request_Type__c != ls.Request_Type__c) || (itpr.Category__c != ls.Category__c) || (itpr.Organization__c != ls.Organization__c)){
               itpr.AddError(System.Label.ITPR_Request_Type_Error_Message);
           }
           /*********************Check if Donot Auto assign checkbox is changed by non primary assignee. If changed show error Donot Auto assign***************/                   
           if(itpr.Do_Not_Auto_Assign__c != ls.Do_Not_Auto_Assign__c){
               itpr.AddError(System.Label.ITPR_Error_Donot_Auto_Assign);
           }
           else{           
               if(itpr.Procurement_Assignee__c != null){
                   itpr.Primary_Assignee__c = use.get(itpr.Procurement_Assignee__c).Name ;
               }
               else{
                   try{
                       itpr.Primary_Assignee__c = use.get(itpr.Legal_Assignee__c).Name ;
                   }
                   catch(Exception e){
                       itpr.Primary_Assignee__c = '';
                   }
               } 
           }
       }
       /*************calling method to check if delegations are existing************/
        ItprRecalculatewithDelegation(itpr);                                   
  }
 }
    /*************Populate Assignee fields based on Request Parameters and Assignment Rules************/
    
    public void ItprCalculateRules(ITPR__c itpr,Map<Id, Assignment_Routing_Rules__c> owners)
    {
    
    /*************If there are Assignment rules corresponding to the selected Request parameters************/ 
    
    if(!owners.isEmpty()){
            for (Id id : owners.keySet()) {
                itpr.Procurement_Assignee__c = owners.get(id).Procurement_Assignee__c;                
                itpr.Legal_Assignee__c = owners.get(id).Legal_Assignee__c;               
                itpr.Vendor_Governance__c = owners.get(id).Vendor_Governance_User__c;               
                if(itpr.Procurement_Assignee__c != null){
                    itpr.Primary_Assignee__c = owners.get(id).Procurement_Assignee__r.Name;
                }
                else{
                    try{
                       itpr.Primary_Assignee__c = use.get(itpr.Legal_Assignee__c).Name ;
                    }
                    catch(Exception e){
                       itpr.Primary_Assignee__c = '';
                    }
                }                
            }
       } 
       
       /*************If there are no Assignment rules corresponding to the selected Request parameters, Populate default assignees************/ 
      
       else{
            if((itpr.Request_Type__c == System.Label.ITPR_Request_Type_RFI) || (itpr.Request_Type__c == System.Label.ITPR_Request_Type_RFP )||(itpr.Request_Type__c == System.Label.ITPR_Request_Type_Other_Procurement)){
                itpr.Procurement_Assignee__c = ITPRDefaultProcurementAssignee__c.getInstance().ITPRSetting__c;
                itpr.Legal_Assignee__c = null; 
                itpr.Vendor_Governance__c =  ITPRDefaultVendorGovernance__c.getInstance().ITPR_Default_Vendor_Governance__c;
                try{
                      itpr.Primary_Assignee__c = use.get(itpr.Procurement_Assignee__c).Name ; 
                    }
                    catch(Exception e){
                       itpr.Primary_Assignee__c = '';
                    }
              
            }
            else if((itpr.Request_Type__c == System.Label.ITPR_Request_Type_NDA) || (itpr.Request_Type__c ==System.Label.ITPR_Request_Type_Other_Legal)||(itpr.Request_Type__c == System.Label.ITPR_Request_Type_Eval_Agreement)||(itpr.Request_Type__c == System.Label.ITPR_Request_Type_Letter_Of_Termination)){
                itpr.Procurement_Assignee__c = null;
                itpr.Legal_Assignee__c = ITPRDefaultLegalAssignee__c.getInstance().ITPR_Default_Legal__c;
                itpr.Vendor_Governance__c =ITPRDefaultVendorGovernance__c.getInstance().ITPR_Default_Vendor_Governance__c;
                 try{
                      itpr.Primary_Assignee__c = use.get(itpr.Legal_Assignee__c).Name ;
                    }
                    catch(Exception e){
                       itpr.Primary_Assignee__c = '';
                    }               
            }
            else{
                itpr.Procurement_Assignee__c = ITPRDefaultProcurementAssignee__c.getInstance().ITPRSetting__c;
                itpr.Legal_Assignee__c = ITPRDefaultLegalAssignee__c.getInstance().ITPR_Default_Legal__c; 
                itpr.Vendor_Governance__c =ITPRDefaultVendorGovernance__c.getInstance().ITPR_Default_Vendor_Governance__c;
                try{
                    // if(use != null && use.size() > 0 && itpr != null && use.containsKey(itpr.Procurement_Assignee__c)){
                     itpr.Primary_Assignee__c = use.get(itpr.Procurement_Assignee__c).Name ;
                    // }
                    }
                    catch(Exception e){
                       itpr.Primary_Assignee__c = '';
                    }              
            }
       }
  }
  
   /*************Check if there are delegations for the Assignees in the Delegation object and override the Actual Assignees with Delegated Assignees************/ 
   
   Public Void ItprRecalculatewithDelegation(ITPR__c itpr){
   
   List<ITPRDelegation__c> lstDelegation = [Select Id, CreatedById, Delegate_To__c From ITPRDelegation__c where reset__c != True and Start_Date__c <=Today and End_Date__c >=Today ];
            if(lstDelegation.size()>0){
            Map<Id, Id> mapInitial = new Map<Id, Id>();
            for(ITPRDelegation__c itprDel : lstDelegation){
                mapInitial.put(itprDel.CreatedById, itprDel.Delegate_To__c);
            }
            Map<Id, Id> mapFinal = new Map<Id, Id>();
            for(ITPRDelegation__c itprDel : lstDelegation){
                mapFinal.put(itprDel.CreatedById, itprDel.Delegate_To__c);
  
                Id delId = mapInitial.get(itprDel.Delegate_To__c);
                if(delId != null){
                    id delId2 = delId;
                    //Keep checking the map again and again until the new Delegated Id is not found to be set as Created By Id
                    while(delId2 != null){
                        delId2 = mapInitial.get(delId2);
                        if(delId2 != null){
                            delId = delId2;
        
                            if(delId2 == itprDel.CreatedById){
                                delId2 = null;
                            }
                        }
                    }
               mapFinal.put(itprDel.CreatedById, delId);
               }
            }
            /*************Populating Assignees from ITPR Delegation Object ************/
            for(Id id1: mapFinal.keySet()){
                if(itpr.Procurement_Assignee__c == id1 && itpr.Procurement_Assignee__c!=null){
                    itpr.Procurement_Assignee__c = mapFinal.get(id1);
                    //itpr.Primary_Assignee__c = use.get(itpr.Procurement_Assignee__c).Name;
                     try{
                     itpr.Primary_Assignee__c = use.get(itpr.Procurement_Assignee__c).Name ;
                    }
                    catch(Exception e){
                       itpr.Primary_Assignee__c = '';
                    }
                    itpr.Delegated_Procurement_Assignee__c = True;
                }
                if(itpr.Legal_Assignee__c == id1 && itpr.Legal_Assignee__c!=null){
                    itpr.Legal_Assignee__c = mapFinal.get(id1);
                    itpr.Delegated_Legal_Assignee__c = True;
                    if(itpr.Procurement_Assignee__c == null){
                      try{
                      itpr.Primary_Assignee__c = use.get(itpr.Legal_Assignee__c).Name ;
                    }
                    catch(Exception e){
                       itpr.Primary_Assignee__c = '';
                    }
                        //itpr.Primary_Assignee__c=use.get(itpr.Legal_Assignee__c).Name;
                    }
                }
                if(itpr.Vendor_Governance__c == id1 && itpr.Vendor_Governance__c!=null){
                    itpr.Vendor_Governance__c = mapFinal.get(id1);
                    itpr.Delegated_Vendor_Governance_User__c = True;
                }
                if(itpr.Finance_Assignee__c == id1  && itpr.Finance_Assignee__c !=null){
                    itpr.Finance_Assignee__c = mapFinal.get(id1);
                    itpr.Delegated_Finance_Assignee__c = True;
                }
            }  
        }   
   
   }

/*************Manual Sharing for Requestors,Assignees and Approvers at every stage************/



public void ITPR_Share(List<ITPR__c> NewOpps2) 
{
  system.debug('enter method----');
  List<ITPR__c> NewOpps = new List<ITPR__c>(NewOpps2);  
  for(ITPR__c acc: NewOpps){
        /*************Sharing when IT SES Draft************/
        system.debug('enter loop----');
        if(acc.status__c == 'Draft'){ 
                ITPR__Share share3 = new ITPR__Share();
                share3.ParentId = acc.Id; 
                share3.UserOrGroupId=acc.CreatedById;
                share3.AccessLevel='Edit'; 
                share3.RowCause = 'Manual';
                sre.add(share3);
            if(acc.Finance_Assignee__c !=null){
                ITPR__Share share4 = new ITPR__Share();
                share4.ParentId = acc.Id; 
                share4.UserOrGroupId=acc.Finance_Assignee__c;
                share4.AccessLevel='Edit'; 
                share4.RowCause = 'Manual';
                sre.add(share4);
            }
            if(acc.submitted_on_behalf_of__c !=null){
                ITPR__Share share52 = new ITPR__Share();
                share52.ParentId = acc.Id; 
                share52.UserOrGroupId=acc.submitted_on_behalf_of__c;
                share52.AccessLevel='Edit'; 
                share52.RowCause = 'Manual';
                sre.add(share52);
            }
            if(acc.Manager__c !=null){
                ITPR__Share share61 = new ITPR__Share();
                share61.ParentId = acc.Id; 
                share61.UserOrGroupId=acc.Manager__c;
                share61.AccessLevel='Edit'; 
                share61.RowCause = 'Manual';
                sre.add(share61);
            }
            if(acc.Delegated_Requestor__c !=null){
                ITPR__Share share60 = new ITPR__Share();
                share60.ParentId = acc.Id; 
                share60.UserOrGroupId=acc.Delegated_Requestor__c;
                share60.AccessLevel='Edit'; 
                share60.RowCause = 'Manual';
                sre.add(share60);
            }
              if(acc.transfered_Requestor__c !=null){
                ITPR__Share share70 = new ITPR__Share();
                share70.ParentId = acc.Id; 
                share70.UserOrGroupId=acc.transfered_Requestor__c;
                share70.AccessLevel='Edit'; 
                share70.RowCause = 'Manual';
                sre.add(share70);
            }
        }
        /*************Sharing when IT SES Submitted,Assigned and In Process************/
        if((acc.status__c == 'Submitted') || (acc.status__c == 'Assigned') ){ 
            
            if(acc.CreatedById !=null){
                ITPR__Share share2 = new ITPR__Share();
                share2.ParentId = acc.Id; 
                share2.UserOrGroupId=acc.CreatedById;
                share2.AccessLevel='Read';   
                share2.RowCause = 'Manual'; 
                sre.add(share2);
            }
            if(acc.Delegated_Requestor__c !=null){
                ITPR__Share share61 = new ITPR__Share();
                share61.ParentId = acc.Id; 
                share61.UserOrGroupId=acc.Delegated_Requestor__c;
                share61.AccessLevel='Read';   
                share61.RowCause = 'Manual'; 
                sre.add(share61);
            }
            if(acc.transfered_Requestor__c !=null){
                ITPR__Share share71 = new ITPR__Share();
                share71.ParentId = acc.Id; 
                share71.UserOrGroupId=acc.transfered_Requestor__c;
                share71.AccessLevel='Read';   
                share71.RowCause = 'Manual'; 
                sre.add(share71);
            }
             if(acc.Manager__c !=null){
                ITPR__Share share62 = new ITPR__Share();
                share62.ParentId = acc.Id; 
                share62.UserOrGroupId=acc.Manager__c;
                share62.AccessLevel='Read'; 
                share62.RowCause = 'Manual';
                sre.add(share62);
            }
            if(acc.submitted_on_behalf_of__c !=null){
                ITPR__Share share53 = new ITPR__Share();
                share53.ParentId = acc.Id; 
                share53.UserOrGroupId=acc.submitted_on_behalf_of__c;
                share53.AccessLevel='Read'; 
                share53.RowCause = 'Manual';
                sre.add(share53);
            }
            if(acc.Finance_Assignee__c !=null){
                ITPR__Share share5 = new ITPR__Share();
                share5.ParentId = acc.Id; 
                share5.UserOrGroupId=acc.Finance_Assignee__c;
                share5.AccessLevel='Edit'; 
                share5.RowCause = 'Manual';
                sre.add(share5);
            }
            if(acc.Vendor_Governance__c !=null){
                ITPR__Share share6 = new ITPR__Share();
                share6.ParentId = acc.Id; 
                share6.UserOrGroupId = acc.Vendor_Governance__c;
                share6.AccessLevel='Edit'; 
                share6.RowCause = 'Manual';
                sre.add(share6);
            }
            if(acc.Procurement_Assignee__c !=null){
                ITPR__Share share = new ITPR__Share();
                share.ParentId = acc.Id; 
                share.UserOrGroupId=acc.Procurement_Assignee__c;
                share.AccessLevel='Edit'; 
                share.RowCause = 'Manual';
                sre.add(share);
            }
            if(acc.Legal_Assignee__c !=null){
                ITPR__Share share1 = new ITPR__Share();
                share1.ParentId = acc.Id; 
                share1.UserOrGroupId=acc.Legal_Assignee__c;
                share1.AccessLevel='Edit';   
                share1.RowCause = 'Manual'; 
                sre.add(share1);}
             /*if(acc.wave1_Approver_1__c!=null){
                ITPR__Share share69= new ITPR__Share();
                share69.ParentId = acc.Id; 
                share69.UserOrGroupId = acc.wave1_Approver_1__c;
                share69.AccessLevel='Edit'; 
                share69.RowCause = 'Manual';
                sre.add(share69);
            }
             if(acc.wave3_Approver_1__c!=null){
                ITPR__Share share70 = new ITPR__Share();
                share70.ParentId = acc.Id; 
                share70.UserOrGroupId = acc.wave3_Approver_1__c;
                share70.AccessLevel='Edit'; 
                share70.RowCause = 'Manual';
                sre.add(share70);
            }*/

        }
        /**********start validations for approvers in in process stage after rejection***********/
      if(acc.status__c == 'In Process') {
             
            if(acc.Wave1_Rejected__c==true){
                if(acc.Wave1_Approver_1__c !=null ){
                    ITPR__Share share71 = new ITPR__Share();
                    share71.ParentId = acc.Id; 
                    share71.UserOrGroupId=acc.Wave1_Approver_1__c;
                    share71.AccessLevel='Read'; 
                    share71.RowCause = 'Manual';
                    sre.add(share71);
                }
                if(acc.Wave1_Approver_2__c !=null){
                    ITPR__Share share72 = new ITPR__Share();
                    share72.ParentId = acc.Id; 
                    share72.UserOrGroupId=acc.Wave1_Approver_2__c;
                    share72.AccessLevel='Read'; 
                    share72.RowCause = 'Manual';
                    sre.add(share72);
                }
                if(acc.Wave1_Approver_3__c !=null){
                    ITPR__Share share73 = new ITPR__Share();
                    share73.ParentId = acc.Id; 
                    share73.UserOrGroupId=acc.Wave1_Approver_3__c;
                    share73.AccessLevel='Read'; 
                    share73.RowCause = 'Manual';
                    sre.add(share73);
                }
                if(acc.Wave1_Approver_4__c !=null){
                    ITPR__Share share74 = new ITPR__Share();
                    share74.ParentId = acc.Id; 
                    share74.UserOrGroupId=acc.Wave1_Approver_4__c;
                    share74.AccessLevel='Read'; 
                    share74.RowCause = 'Manual';
                    sre.add(share74);
                }
                if(acc.Wave1_Approver_5__c !=null){
                    ITPR__Share share75 = new ITPR__Share();
                    share75.ParentId = acc.Id; 
                    share75.UserOrGroupId=acc.Wave1_Approver_5__c;
                    share75.AccessLevel='Read'; 
                    share75.RowCause = 'Manual';
                    sre.add(share75);
                }
            }
            if(acc.Wave2_Rejected__c==true){
                if(acc.Wave2_Approver_1__c !=null){
                    ITPR__Share share76 = new ITPR__Share();
                    share76.ParentId = acc.Id; 
                    share76.UserOrGroupId=acc.Wave2_Approver_1__c;
                    share76.AccessLevel='Read'; 
                    share76.RowCause = 'Manual';
                    sre.add(share76);
                }
                if(acc.Wave2_Approver_2__c !=null ){
                    ITPR__Share share77 = new ITPR__Share();
                    share77.ParentId = acc.Id; 
                    share77.UserOrGroupId=acc.Wave2_Approver_2__c;
                    share77.AccessLevel='Read'; 
                    share77.RowCause = 'Manual';
                    sre.add(share77);
                }
                if(acc.Wave2_Approver_3__c !=null){
                    ITPR__Share share78 = new ITPR__Share();
                    share78.ParentId = acc.Id; 
                    share78.UserOrGroupId=acc.Wave2_Approver_3__c;
                    share78.AccessLevel='Read'; 
                    share78.RowCause = 'Manual';
                    sre.add(share78);
                }
                if(acc.Wave2_Approver_4__c !=null){
                    ITPR__Share share79 = new ITPR__Share();
                    share79.ParentId = acc.Id; 
                    share79.UserOrGroupId=acc.Wave2_Approver_4__c;
                    share79.AccessLevel='Read'; 
                    share79.RowCause = 'Manual';
                    sre.add(share79);
                }
                if(acc.Wave2_Approver_5__c !=null){
                    ITPR__Share share80 = new ITPR__Share();
                    share80.ParentId = acc.Id; 
                    share80.UserOrGroupId=acc.Wave2_Approver_5__c;
                    share80.AccessLevel='Read'; 
                    share80.RowCause = 'Manual';
                    sre.add(share80);
                }
            }
            if(acc.Wave3_Rejected__c==true){
                if(acc.Wave3_Approver_4__c !=null){
                    ITPR__Share share81 = new ITPR__Share();
                    share81.ParentId = acc.Id; 
                    share81.UserOrGroupId=acc.Wave3_Approver_4__c;
                    share81.AccessLevel='Read'; 
                    share81.RowCause = 'Manual';
                    sre.add(share81);
                }
                if(acc.Wave3_Approver_5__c !=null){
                    ITPR__Share share82 = new ITPR__Share();
                    share82.ParentId = acc.Id; 
                    share82.UserOrGroupId=acc.Wave3_Approver_5__c;
                    share82.AccessLevel='Read'; 
                    share82.RowCause = 'Manual';
                    sre.add(share82);
                }
                if(acc.Wave3_Approver_1__c !=null){
                    ITPR__Share share83 = new ITPR__Share();
                    share83.ParentId = acc.Id; 
                    share83.UserOrGroupId=acc.Wave3_Approver_1__c;
                    share83.AccessLevel='Read'; 
                    share83.RowCause = 'Manual';
                    sre.add(share83);
                }
                if(acc.Wave3_Approver_2__c !=null ){
                    ITPR__Share share84 = new ITPR__Share();
                    share84.ParentId = acc.Id; 
                    share84.UserOrGroupId=acc.Wave3_Approver_2__c;
                    share84.AccessLevel='Read'; 
                    share84.RowCause = 'Manual';
                    sre.add(share84);
                }
                if(acc.Wave3_Approver_3__c !=null){
                    ITPR__Share share85 = new ITPR__Share();
                    share85.ParentId = acc.Id; 
                    share85.UserOrGroupId=acc.Wave3_Approver_3__c;
                    share85.AccessLevel='Read'; 
                    share85.RowCause = 'Manual';
                    sre.add(share85);
                }
            }
            
            
            if(acc.CreatedById !=null){
                ITPR__Share share2 = new ITPR__Share();
                share2.ParentId = acc.Id; 
                share2.UserOrGroupId=acc.CreatedById;
                share2.AccessLevel='Read';   
                share2.RowCause = 'Manual'; 
                sre.add(share2);
            }
            if(acc.Delegated_Requestor__c !=null){
                ITPR__Share share61 = new ITPR__Share();
                share61.ParentId = acc.Id; 
                share61.UserOrGroupId=acc.Delegated_Requestor__c;
                share61.AccessLevel='Read';   
                share61.RowCause = 'Manual'; 
                sre.add(share61);
            }
            if(acc.transfered_Requestor__c !=null){
                ITPR__Share share71 = new ITPR__Share();
                share71.ParentId = acc.Id; 
                share71.UserOrGroupId=acc.transfered_Requestor__c;
                share71.AccessLevel='Read';   
                share71.RowCause = 'Manual'; 
                sre.add(share71);
            }
             if(acc.Manager__c !=null){
                ITPR__Share share62 = new ITPR__Share();
                share62.ParentId = acc.Id; 
                share62.UserOrGroupId=acc.Manager__c;
                share62.AccessLevel='Read'; 
                share62.RowCause = 'Manual';
                sre.add(share62);
            }
            if(acc.submitted_on_behalf_of__c !=null){
                ITPR__Share share53 = new ITPR__Share();
                share53.ParentId = acc.Id; 
                share53.UserOrGroupId=acc.submitted_on_behalf_of__c;
                share53.AccessLevel='Read'; 
                share53.RowCause = 'Manual';
                sre.add(share53);
            }
            if(acc.Procurement_Assignee__c !=null){
                ITPR__Share share = new ITPR__Share();
                share.ParentId = acc.Id; 
                share.UserOrGroupId=acc.Procurement_Assignee__c;
                share.AccessLevel='Edit'; 
                share.RowCause = 'Manual';
                sre.add(share);
            }
            if(acc.Legal_Assignee__c !=null){
                ITPR__Share share1 = new ITPR__Share();
                share1.ParentId = acc.Id; 
                share1.UserOrGroupId=acc.Legal_Assignee__c;
                share1.AccessLevel='Edit';   
                share1.RowCause = 'Manual'; 
                sre.add(share1);}
            if(acc.Finance_Assignee__c !=null){
                ITPR__Share share5 = new ITPR__Share();
                share5.ParentId = acc.Id; 
                share5.UserOrGroupId=acc.Finance_Assignee__c;
                share5.AccessLevel='Edit'; 
                share5.RowCause = 'Manual';
                sre.add(share5);
            }
            if(acc.Vendor_Governance__c !=null){
                ITPR__Share share6 = new ITPR__Share();
                share6.ParentId = acc.Id; 
                share6.UserOrGroupId = acc.Vendor_Governance__c;
                share6.AccessLevel='Edit'; 
                share6.RowCause = 'Manual';
                sre.add(share6);
            }
            /****Capgemini :Added Code for 3 Additional Approver read access****/
	if(acc.Additional_Approver_1__c !=null){
            ITPR__Share share101 = new ITPR__Share();
            share101.ParentId = acc.Id; 
            share101.UserOrGroupId=acc.Additional_Approver_1__c;
            share101.AccessLevel='Read'; 
            share101.RowCause = 'Manual';
            sre.add(share101);
        }
	
	if(acc.Additional_Approver_2__c !=null){
            ITPR__Share share102 = new ITPR__Share();
            share102.ParentId = acc.Id; 
            share102.UserOrGroupId=acc.Additional_Approver_2__c;
            share102.AccessLevel='Read'; 
            share102.RowCause = 'Manual';
            sre.add(share102);
        }

	if(acc.Additional_Approver_3__c !=null){
            ITPR__Share share103 = new ITPR__Share();
            share103.ParentId = acc.Id; 
            share103.UserOrGroupId=acc.Additional_Approver_3__c;
            share103.AccessLevel='Read'; 
            share103.RowCause = 'Manual';
            sre.add(share103);
        }
   }
   
 
        /************end validations for approve read access after reject*********/
        /*************Sharing when IT SES Cancelled,Complete,Executed and Filed and Not executed and closed************/

        if((acc.status__c == 'Cancelled') || (acc.status__c == 'On Hold') || (acc.status__c == 'Complete') || (acc.status__c == 'Executed and Filed') || (acc.status__c == 'Not Executed and Closed') ){ 
            if(acc.Procurement_Assignee__c !=null){
                ITPR__Share share7 = new ITPR__Share();
                share7.ParentId = acc.Id;                 
                share7.UserOrGroupId=acc.Procurement_Assignee__c;
                share7.AccessLevel='Read'; 
                share7.RowCause = 'Manual';
                sre.add(share7);
            }
            if(acc.Legal_Assignee__c !=null){
                ITPR__Share share8 = new ITPR__Share();
                share8.ParentId = acc.Id; 
                share8.UserOrGroupId=acc.Legal_Assignee__c;
                share8.AccessLevel='Read';   
                share8.RowCause = 'Manual'; 
                sre.add(share8);
            }
            if(acc.CreatedById !=null){
                ITPR__Share share9 = new ITPR__Share();
                share9.ParentId = acc.Id; 
                share9.UserOrGroupId=acc.CreatedById;
                share9.AccessLevel='Read';   
                share9.RowCause = 'Manual'; 
                sre.add(share9);
            }
             if(acc.Manager__c !=null){
                ITPR__Share share63 = new ITPR__Share();
                share63.ParentId = acc.Id; 
                share63.UserOrGroupId=acc.Manager__c;
                share63.AccessLevel='Read'; 
                share63.RowCause = 'Manual';
                sre.add(share63);
            }
            if(acc.Delegated_Requestor__c !=null){
                ITPR__Share share62 = new ITPR__Share();
                share62.ParentId = acc.Id; 
                share62.UserOrGroupId=acc.Delegated_Requestor__c;
                share62.AccessLevel='Read';   
                share62.RowCause = 'Manual'; 
                sre.add(share62);
            }
            if(acc.transfered_Requestor__c !=null){
                ITPR__Share share72 = new ITPR__Share();
                share72.ParentId = acc.Id; 
                share72.UserOrGroupId=acc.transfered_Requestor__c;
                share72.AccessLevel='Read';   
                share72.RowCause = 'Manual'; 
                sre.add(share72);
            }
            if(acc.submitted_on_behalf_of__c !=null){
                ITPR__Share share54 = new ITPR__Share();
                share54.ParentId = acc.Id; 
                share54.UserOrGroupId=acc.submitted_on_behalf_of__c;
                share54.AccessLevel='Read'; 
                share54.RowCause = 'Manual';
                sre.add(share54);
            }
            if(acc.Finance_Assignee__c !=null){
                ITPR__Share share10 = new ITPR__Share();
                share10.ParentId = acc.Id; 
                share10.UserOrGroupId=acc.Finance_Assignee__c;
                share10.AccessLevel='Read'; 
                share10.RowCause = 'Manual';
                sre.add(share10);
            }
            if(acc.Vendor_Governance__c !=null){
                ITPR__Share share11 = new ITPR__Share();
                share11.ParentId = acc.Id; 
                share11.UserOrGroupId = acc.Vendor_Governance__c;
                share11.AccessLevel='Read'; 
                share11.RowCause = 'Manual';
                sre.add(share11);
            }
            if(acc.Wave1_Approver_1__c !=null){
                ITPR__Share share37 = new ITPR__Share();
                share37.ParentId = acc.Id; 
                share37.UserOrGroupId=acc.Wave1_Approver_1__c;
                share37.AccessLevel='Read'; 
                share37.RowCause = 'Manual';
                sre.add(share37);
            }
            if(acc.Wave1_Approver_2__c !=null){
                ITPR__Share share38 = new ITPR__Share();
                share38.ParentId = acc.Id; 
                share38.UserOrGroupId=acc.Wave1_Approver_2__c;
                share38.AccessLevel='Read'; 
                share38.RowCause = 'Manual';
                sre.add(share38);
            }
            if(acc.Wave1_Approver_3__c !=null){
                ITPR__Share share39 = new ITPR__Share();
                share39.ParentId = acc.Id; 
                share39.UserOrGroupId=acc.Wave1_Approver_3__c;
                share39.AccessLevel='Read'; 
                share39.RowCause = 'Manual';
                sre.add(share39);
            }
            if(acc.Wave1_Approver_4__c !=null){
                ITPR__Share share40 = new ITPR__Share();
                share40.ParentId = acc.Id; 
                share40.UserOrGroupId=acc.Wave1_Approver_4__c;
                share40.AccessLevel='Read'; 
                share40.RowCause = 'Manual';
                sre.add(share40);
            }
            if(acc.Wave1_Approver_5__c !=null){
                ITPR__Share share41 = new ITPR__Share();
                share41.ParentId = acc.Id; 
                share41.UserOrGroupId=acc.Wave1_Approver_5__c;
                share41.AccessLevel='Read'; 
                share41.RowCause = 'Manual';
                sre.add(share41);
            }
            if(acc.Wave2_Approver_1__c !=null){
                ITPR__Share share42 = new ITPR__Share();
                share42.ParentId = acc.Id; 
                share42.UserOrGroupId=acc.Wave2_Approver_1__c;
                share42.AccessLevel='Read'; 
                share42.RowCause = 'Manual';
                sre.add(share42);
            }
            if(acc.Wave2_Approver_2__c !=null){
                ITPR__Share share43 = new ITPR__Share();
                share43.ParentId = acc.Id; 
                share43.UserOrGroupId=acc.Wave2_Approver_2__c;
                share43.AccessLevel='Read'; 
                share43.RowCause = 'Manual';
                sre.add(share43);
            }
            if(acc.Wave2_Approver_3__c !=null){
                ITPR__Share share44 = new ITPR__Share();
                share44.ParentId = acc.Id; 
                share44.UserOrGroupId=acc.Wave2_Approver_3__c;
                share44.AccessLevel='Read'; 
                share44.RowCause = 'Manual';
                sre.add(share44);
            }
            if(acc.Wave2_Approver_4__c !=null){
                ITPR__Share share45 = new ITPR__Share();
                share45.ParentId = acc.Id; 
                share45.UserOrGroupId=acc.Wave2_Approver_4__c;
                share45.AccessLevel='Read'; 
                share45.RowCause = 'Manual';
                sre.add(share45);
            }
            if(acc.Wave2_Approver_5__c !=null){
                ITPR__Share share46 = new ITPR__Share();
                share46.ParentId = acc.Id; 
                share46.UserOrGroupId=acc.Wave2_Approver_5__c;
                share46.AccessLevel='Read'; 
                share46.RowCause = 'Manual';
                sre.add(share46);
            }
            if(acc.Wave3_Approver_4__c !=null){
                ITPR__Share share47 = new ITPR__Share();
                share47.ParentId = acc.Id; 
                share47.UserOrGroupId=acc.Wave3_Approver_4__c;
                share47.AccessLevel='Read'; 
                share47.RowCause = 'Manual';
                sre.add(share47);
            }
            if(acc.Wave3_Approver_5__c !=null){
                ITPR__Share share48 = new ITPR__Share();
                share48.ParentId = acc.Id; 
                share48.UserOrGroupId=acc.Wave3_Approver_5__c;
                share48.AccessLevel='Read'; 
                share48.RowCause = 'Manual';
                sre.add(share48);
            }
            if(acc.Wave3_Approver_1__c !=null){
                ITPR__Share share49 = new ITPR__Share();
                share49.ParentId = acc.Id; 
                share49.UserOrGroupId=acc.Wave3_Approver_1__c;
                share49.AccessLevel='Read'; 
                share49.RowCause = 'Manual';
                sre.add(share49);
            }
            if(acc.Wave3_Approver_2__c !=null){
                ITPR__Share share50 = new ITPR__Share();
                share50.ParentId = acc.Id; 
                share50.UserOrGroupId=acc.Wave3_Approver_2__c;
                share50.AccessLevel='Read'; 
                share50.RowCause = 'Manual';
                sre.add(share50);
            }
            if(acc.Wave3_Approver_3__c !=null){
                ITPR__Share share51 = new ITPR__Share();
                share51.ParentId = acc.Id; 
                share51.UserOrGroupId=acc.Wave3_Approver_3__c;
                share51.AccessLevel='Read'; 
                share51.RowCause = 'Manual';
                sre.add(share51);
            }
            
                  /****Capgemini :Added Code for 3 Additional Approver read access****/
	if(acc.Additional_Approver_1__c !=null){
            ITPR__Share share104 = new ITPR__Share();
            share104.ParentId = acc.Id; 
            share104.UserOrGroupId=acc.Additional_Approver_1__c;
            share104.AccessLevel='Read'; 
            share104.RowCause = 'Manual';
            sre.add(share104);
        }
	
	if(acc.Additional_Approver_2__c !=null){
            ITPR__Share share105 = new ITPR__Share();
            share105.ParentId = acc.Id; 
            share105.UserOrGroupId=acc.Additional_Approver_2__c;
            share105.AccessLevel='Read'; 
            share105.RowCause = 'Manual';
            sre.add(share105);
        }

	if(acc.Additional_Approver_3__c !=null){
            ITPR__Share share106 = new ITPR__Share();
            share106.ParentId = acc.Id; 
            share106.UserOrGroupId=acc.Additional_Approver_3__c;
            share106.AccessLevel='Read'; 
            share106.RowCause = 'Manual';
            sre.add(share106);
        }
      }
        /*************Sharing when IT SES All digital initials obtained************/
        system.debug(acc.status__c+'statussss------');
        if(acc.status__c == 'All Digital Initials Obtained')
        {
            system.debug('enter final-----');
            if(acc.Procurement_Assignee__c !=null){
                ITPR__Share share7 = new ITPR__Share();
                share7.ParentId = acc.Id; 
                share7.UserOrGroupId=acc.Procurement_Assignee__c;
                share7.AccessLevel='Read'; 
                share7.RowCause = 'Manual';
                sre.add(share7);
            }
            if(acc.Legal_Assignee__c !=null){
                ITPR__Share share8 = new ITPR__Share();
                share8.ParentId = acc.Id; 
                share8.UserOrGroupId=acc.Legal_Assignee__c;
                share8.AccessLevel='Read';   
                share8.RowCause = 'Manual'; 
                sre.add(share8);
            }
            if(acc.CreatedById !=null){
                ITPR__Share share9 = new ITPR__Share();
                share9.ParentId = acc.Id; 
                share9.UserOrGroupId=acc.CreatedById;
                share9.AccessLevel='Read';   
                share9.RowCause = 'Manual'; 
                sre.add(share9);
            }
            if(acc.Delegated_Requestor__c !=null){
                ITPR__Share share63 = new ITPR__Share();
                share63.ParentId = acc.Id; 
                share63.UserOrGroupId=acc.Delegated_Requestor__c;
                share63.AccessLevel='Read';   
                share63.RowCause = 'Manual'; 
                sre.add(share63);
            }
            if(acc.transfered_Requestor__c !=null){
                ITPR__Share share73 = new ITPR__Share();
                share73.ParentId = acc.Id; 
                share73.UserOrGroupId=acc.transfered_Requestor__c;
                share73.AccessLevel='Read';   
                share73.RowCause = 'Manual'; 
                sre.add(share73);
            }
             if(acc.Manager__c !=null){
                ITPR__Share share64 = new ITPR__Share();
                share64.ParentId = acc.Id; 
                share64.UserOrGroupId=acc.Manager__c;
                share64.AccessLevel='Read'; 
                share64.RowCause = 'Manual';
                sre.add(share64);
            }
            if(acc.submitted_on_behalf_of__c !=null){
                ITPR__Share share55 = new ITPR__Share();
                share55.ParentId = acc.Id; 
                share55.UserOrGroupId=acc.submitted_on_behalf_of__c;
                share55.AccessLevel='Read'; 
                share55.RowCause = 'Manual';
                sre.add(share55);
            }
            if(acc.Finance_Assignee__c !=null){
            system.debug('finance enter----');
                ITPR__Share share10 = new ITPR__Share();
                share10.ParentId = acc.Id; 
                share10.UserOrGroupId=acc.Finance_Assignee__c;
                share10.AccessLevel='Read'; 
                share10.RowCause = 'Manual';
                sre.add(share10);
            }         
            if(acc.Wave1_Approver_1__c !=null){
                ITPR__Share share37 = new ITPR__Share();
                share37.ParentId = acc.Id; 
                share37.UserOrGroupId=acc.Wave1_Approver_1__c;
                share37.AccessLevel='Read'; 
                share37.RowCause = 'Manual';
                sre.add(share37);
            }
            if(acc.Wave1_Approver_2__c !=null){
                ITPR__Share share38 = new ITPR__Share();
                share38.ParentId = acc.Id; 
                share38.UserOrGroupId=acc.Wave1_Approver_2__c;
                share38.AccessLevel='Read'; 
                share38.RowCause = 'Manual';
                sre.add(share38);
            }
            if(acc.Wave1_Approver_3__c !=null){
                ITPR__Share share39 = new ITPR__Share();
                share39.ParentId = acc.Id; 
                share39.UserOrGroupId=acc.Wave1_Approver_3__c;
                share39.AccessLevel='Read'; 
                share39.RowCause = 'Manual';
                sre.add(share39);
            }
            if(acc.Wave1_Approver_4__c !=null){
                ITPR__Share share40 = new ITPR__Share();
                share40.ParentId = acc.Id; 
                share40.UserOrGroupId=acc.Wave1_Approver_4__c;
                share40.AccessLevel='Read'; 
                share40.RowCause = 'Manual';
                sre.add(share40);
            }
            if(acc.Wave1_Approver_5__c !=null){
                ITPR__Share share41 = new ITPR__Share();
                share41.ParentId = acc.Id; 
                share41.UserOrGroupId=acc.Wave1_Approver_5__c;
                share41.AccessLevel='Read'; 
                share41.RowCause = 'Manual';
                sre.add(share41);
            }
            if(acc.Wave2_Approver_1__c !=null){
                ITPR__Share share42 = new ITPR__Share();
                share42.ParentId = acc.Id; 
                share42.UserOrGroupId=acc.Wave2_Approver_1__c;
                share42.AccessLevel='Read'; 
                share42.RowCause = 'Manual';
                sre.add(share42);
            }
            if(acc.Wave2_Approver_2__c !=null){
                ITPR__Share share43 = new ITPR__Share();
                share43.ParentId = acc.Id; 
                share43.UserOrGroupId=acc.Wave2_Approver_2__c;
                share43.AccessLevel='Read'; 
                share43.RowCause = 'Manual';
                sre.add(share43);
            }
            if(acc.Wave2_Approver_3__c !=null){
                ITPR__Share share44 = new ITPR__Share();
                share44.ParentId = acc.Id; 
                share44.UserOrGroupId=acc.Wave2_Approver_3__c;
                share44.AccessLevel='Read'; 
                share44.RowCause = 'Manual';
                sre.add(share44);
            }
            if(acc.Wave2_Approver_4__c !=null){
                ITPR__Share share45 = new ITPR__Share();
                share45.ParentId = acc.Id; 
                share45.UserOrGroupId=acc.Wave2_Approver_4__c;
                share45.AccessLevel='Read'; 
                share45.RowCause = 'Manual';
                sre.add(share45);
            }
            if(acc.Wave2_Approver_5__c !=null){
                ITPR__Share share46 = new ITPR__Share();
                share46.ParentId = acc.Id; 
                share46.UserOrGroupId=acc.Wave2_Approver_5__c;
                share46.AccessLevel='Read'; 
                share46.RowCause = 'Manual';
                sre.add(share46);
            }
            if(acc.Wave3_Approver_5__c !=null){
                ITPR__Share share47 = new ITPR__Share();
                share47.ParentId = acc.Id; 
                share47.UserOrGroupId=acc.Wave3_Approver_5__c;
                share47.AccessLevel='Read'; 
                share47.RowCause = 'Manual';
                sre.add(share47);
            }
            if(acc.Wave3_Approver_4__c !=null){
                ITPR__Share share48 = new ITPR__Share();
                share48.ParentId = acc.Id; 
                share48.UserOrGroupId=acc.Wave3_Approver_4__c;
                share48.AccessLevel='Read'; 
                share48.RowCause = 'Manual';
                sre.add(share48);
            }
            if(acc.Wave3_Approver_1__c !=null){
                ITPR__Share share49 = new ITPR__Share();
                share49.ParentId = acc.Id; 
                share49.UserOrGroupId=acc.Wave3_Approver_1__c;
                share49.AccessLevel='Read'; 
                share49.RowCause = 'Manual';
                sre.add(share49);
            }
            if(acc.Wave3_Approver_2__c !=null){
                ITPR__Share share50 = new ITPR__Share();
                share50.ParentId = acc.Id; 
                share50.UserOrGroupId=acc.Wave3_Approver_2__c;
                share50.AccessLevel='Read'; 
                share50.RowCause = 'Manual';
                sre.add(share50);
            }
            if(acc.Wave3_Approver_3__c !=null){
                ITPR__Share share51 = new ITPR__Share();
                share51.ParentId = acc.Id; 
                share51.UserOrGroupId=acc.Wave3_Approver_3__c;
                share51.AccessLevel='Read'; 
                share51.RowCause = 'Manual';
                sre.add(share51);
            }
              if(acc.Vendor_Governance__c !=null){
                ITPR__Share share11 = new ITPR__Share();
                share11.ParentId = acc.Id; 
                share11.UserOrGroupId = acc.Vendor_Governance__c;
                share11.AccessLevel='Edit'; 
                share11.RowCause = 'Manual';
                sre.add(share11);
            }
            
                /****Capgemini :Added Code for 3 Additional Approver read access****/
	if(acc.Additional_Approver_1__c !=null){
            ITPR__Share share107 = new ITPR__Share();
            share107.ParentId = acc.Id; 
            share107.UserOrGroupId=acc.Additional_Approver_1__c;
            share107.AccessLevel='Read'; 
            share107.RowCause = 'Manual';
            sre.add(share107);
        }
	
	if(acc.Additional_Approver_2__c !=null){
            ITPR__Share share108 = new ITPR__Share();
            share108.ParentId = acc.Id; 
            share108.UserOrGroupId=acc.Additional_Approver_2__c;
            share108.AccessLevel='Read'; 
            share108.RowCause = 'Manual';
            sre.add(share108);
        }

	if(acc.Additional_Approver_3__c !=null){
            ITPR__Share share109 = new ITPR__Share();
            share109.ParentId = acc.Id; 
            share109.UserOrGroupId=acc.Additional_Approver_3__c;
            share109.AccessLevel='Read'; 
            share109.RowCause = 'Manual';
            sre.add(share109);
        }
    }
    /*************Sharing when IT SES Pending Project Budget and More Info needed************/

    if((acc.status__c == 'Pending Project Final Budget')||(acc.status__c == 'Pending More Info Needed'))
    { 
        system.debug('if 2 contions------');
        if(acc.Procurement_Assignee__c !=null){
            ITPR__Share share12 = new ITPR__Share();
            share12.ParentId = acc.Id; 
            share12.UserOrGroupId=acc.Procurement_Assignee__c;
            share12.AccessLevel='Read'; 
            share12.RowCause = 'Manual';
            sre.add(share12);
        }
        if(acc.Legal_Assignee__c !=null){
        system.debug('test entry------');
            ITPR__Share share13 = new ITPR__Share();
            share13.ParentId = acc.Id; 
            share13.UserOrGroupId=acc.Legal_Assignee__c;
            share13.AccessLevel='Read';   
            share13.RowCause = 'Manual'; 
            sre.add(share13);
        }
          if(acc.Finance_Assignee__c !=null){
            ITPR__Share share15 = new ITPR__Share();
            share15.ParentId = acc.Id; 
            share15.UserOrGroupId=acc.Finance_Assignee__c;
            share15.AccessLevel='Read'; 
            share15.RowCause = 'Manual';
            sre.add(share15);
        }
        if(acc.Vendor_Governance__c !=null){
            ITPR__Share share16 = new ITPR__Share();
            share16.ParentId = acc.Id; 
            share16.UserOrGroupId = acc.Vendor_Governance__c;
            share16.AccessLevel='Read'; 
            share16.RowCause = 'Manual';
            sre.add(share16);
        }
        if(acc.CreatedById !=null){
            ITPR__Share share14 = new ITPR__Share();
            share14.ParentId = acc.Id; 
            share14.UserOrGroupId=acc.CreatedById;
            share14.AccessLevel='Edit';   
            share14.RowCause = 'Manual'; 
            sre.add(share14);
        }
        if(acc.Manager__c!=null){
            ITPR__Share share65 = new ITPR__Share();
            share65.ParentId = acc.Id; 
            share65.UserOrGroupId=acc.Manager__c;
            share65.AccessLevel='Edit';   
            share65.RowCause = 'Manual'; 
            sre.add(share65);
        }
        if(acc.Delegated_Requestor__c!=null){
            ITPR__Share share65 = new ITPR__Share();
            share65.ParentId = acc.Id; 
            share65.UserOrGroupId=acc.Delegated_Requestor__c;
            share65.AccessLevel='Edit';   
            share65.RowCause = 'Manual'; 
            sre.add(share65);
        }
        if(acc.transfered_Requestor__c!=null){
            ITPR__Share share75 = new ITPR__Share();
            share75.ParentId = acc.Id; 
            share75.UserOrGroupId=acc.transfered_Requestor__c;
            share75.AccessLevel='Edit';   
            share75.RowCause = 'Manual'; 
            sre.add(share75);
        }
        if(acc.submitted_on_behalf_of__c !=null){
            ITPR__Share share56 = new ITPR__Share();
            share56.ParentId = acc.Id; 
            share56.UserOrGroupId=acc.submitted_on_behalf_of__c;
            share56.AccessLevel='Edit'; 
            share56.RowCause = 'Manual';
            sre.add(share56);
        }
      

    }
    /*************Sharing when IT SES In Approvals************/

    if(acc.Status__c == 'In approvals')
    {
        if(acc.Procurement_Assignee__c !=null){
            ITPR__Share share17 = new ITPR__Share();
            share17.ParentId = acc.Id; 
            share17.UserOrGroupId=acc.Procurement_Assignee__c;
            share17.AccessLevel='Read'; 
            share17.RowCause = 'Manual';
            sre.add(share17);
        }
        if(acc.Legal_Assignee__c !=null){
            ITPR__Share share18 = new ITPR__Share();
            share18.ParentId = acc.Id; 
            share18.UserOrGroupId=acc.Legal_Assignee__c;
            share18.AccessLevel='Read';   
            share18.RowCause = 'Manual'; 
            sre.add(share18);
        }
        if(acc.CreatedById !=null){
            ITPR__Share share19 = new ITPR__Share();
            share19.ParentId = acc.Id; 
            share19.UserOrGroupId=acc.CreatedById;
            share19.AccessLevel='Read';   
            share19.RowCause = 'Manual'; 
            sre.add(share19);
        }
        if(acc.Manager__c!=null){
            ITPR__Share share66 = new ITPR__Share();
            share66.ParentId = acc.Id; 
            share66.UserOrGroupId=acc.Manager__c;
            share66.AccessLevel='Read';   
            share66.RowCause = 'Manual'; 
            sre.add(share66);
        }
        if(acc.Delegated_Requestor__c !=null){
            ITPR__Share share66 = new ITPR__Share();
            share66.ParentId = acc.Id; 
            share66.UserOrGroupId=acc.Delegated_Requestor__c;
            share66.AccessLevel='Read';   
            share66.RowCause = 'Manual'; 
            sre.add(share66);
        }
          if(acc.transfered_Requestor__c !=null){
            ITPR__Share share76 = new ITPR__Share();
            share76.ParentId = acc.Id; 
            share76.UserOrGroupId=acc.transfered_Requestor__c;
            share76.AccessLevel='Read';   
            share76.RowCause = 'Manual'; 
            sre.add(share76);
        }
        if(acc.submitted_on_behalf_of__c !=null){
            ITPR__Share share57 = new ITPR__Share();
            share57.ParentId = acc.Id; 
            share57.UserOrGroupId=acc.submitted_on_behalf_of__c;
            share57.AccessLevel='Read'; 
            share57.RowCause = 'Manual';
            sre.add(share57);
        }
        if(acc.Finance_Assignee__c !=null){
            ITPR__Share share20 = new ITPR__Share();
            share20.ParentId = acc.Id; 
            share20.UserOrGroupId=acc.Finance_Assignee__c;
            share20.AccessLevel='Read'; 
            share20.RowCause = 'Manual';
            sre.add(share20);
        }
        if(acc.Vendor_Governance__c !=null){
            ITPR__Share share21 = new ITPR__Share();
            share21.ParentId = acc.Id; 
            share21.UserOrGroupId = acc.Vendor_Governance__c;
            share21.AccessLevel='Read'; 
            share21.RowCause = 'Manual';
            sre.add(share21);
        }
        if(acc.Wave1_Approver_1__c !=null){
            ITPR__Share share22 = new ITPR__Share();
            share22.ParentId = acc.Id; 
            share22.UserOrGroupId=acc.Wave1_Approver_1__c;
            share22.AccessLevel='Edit'; 
            share22.RowCause = 'Manual';
            sre.add(share22);
        }
        if(acc.Wave1_Approver_2__c !=null){
            ITPR__Share share23 = new ITPR__Share();
            share23.ParentId = acc.Id; 
            share23.UserOrGroupId=acc.Wave1_Approver_2__c;
            share23.AccessLevel='Edit'; 
            share23.RowCause = 'Manual';
            sre.add(share23);
        }
        if(acc.Wave1_Approver_3__c !=null){
            ITPR__Share share24 = new ITPR__Share();
            share24.ParentId = acc.Id; 
            share24.UserOrGroupId=acc.Wave1_Approver_3__c;
            share24.AccessLevel='Edit'; 
            share24.RowCause = 'Manual';
            sre.add(share24);
        }
        if(acc.Wave1_Approver_4__c !=null){
            ITPR__Share share25 = new ITPR__Share();
            share25.ParentId = acc.Id; 
            share25.UserOrGroupId=acc.Wave1_Approver_4__c;
            share25.AccessLevel='Edit'; 
            share25.RowCause = 'Manual';
            sre.add(share25);
        }
        if(acc.Wave1_Approver_5__c !=null){
            ITPR__Share share26 = new ITPR__Share();
            share26.ParentId = acc.Id; 
            share26.UserOrGroupId=acc.Wave1_Approver_5__c;
            share26.AccessLevel='Edit'; 
            share26.RowCause = 'Manual';
            sre.add(share26);
        }
        if(acc.Wave2_Approver_1__c !=null){
            ITPR__Share share27 = new ITPR__Share();
            share27.ParentId = acc.Id; 
            share27.UserOrGroupId=acc.Wave2_Approver_1__c;
            share27.AccessLevel='Edit'; 
            share27.RowCause = 'Manual';
            sre.add(share27);
        }
        if(acc.Wave2_Approver_2__c !=null){
            ITPR__Share share28 = new ITPR__Share();
            share28.ParentId = acc.Id; 
            share28.UserOrGroupId=acc.Wave2_Approver_2__c;
            share28.AccessLevel='Edit'; 
            share28.RowCause = 'Manual';
            sre.add(share28);
        }
        if(acc.Wave2_Approver_3__c !=null){
            ITPR__Share share29 = new ITPR__Share();
            share29.ParentId = acc.Id; 
            share29.UserOrGroupId=acc.Wave2_Approver_3__c;
            share29.AccessLevel='Edit'; 
            share29.RowCause = 'Manual';
            sre.add(share29);
        }
        if(acc.Wave2_Approver_4__c !=null){
            ITPR__Share share30 = new ITPR__Share();
            share30.ParentId = acc.Id; 
            share30.UserOrGroupId=acc.Wave2_Approver_4__c;
            share30.AccessLevel='Edit'; 
            share30.RowCause = 'Manual';
            sre.add(share30);
        }
        if(acc.Wave2_Approver_5__c !=null){
            ITPR__Share share31 = new ITPR__Share();
            share31.ParentId = acc.Id; 
            share31.UserOrGroupId=acc.Wave2_Approver_5__c;
            share31.AccessLevel='Edit'; 
            share31.RowCause = 'Manual';
            sre.add(share31);
        }
        if(acc.Wave3_Approver_4__c !=null){
            ITPR__Share share32 = new ITPR__Share();
            share32.ParentId = acc.Id; 
            share32.UserOrGroupId=acc.Wave3_Approver_4__c;
            share32.AccessLevel='Edit'; 
            share32.RowCause = 'Manual';
            sre.add(share32);
        }
        if(acc.Wave3_Approver_5__c !=null){
            ITPR__Share share33 = new ITPR__Share();
            share33.ParentId = acc.Id; 
            share33.UserOrGroupId=acc.Wave3_Approver_5__c;
            share33.AccessLevel='Edit'; 
            share33.RowCause = 'Manual';
            sre.add(share33);
        }
        if(acc.Wave3_Approver_1__c !=null){
            ITPR__Share share34 = new ITPR__Share();
            share34.ParentId = acc.Id; 
            share34.UserOrGroupId=acc.Wave3_Approver_1__c;
            share34.AccessLevel='Edit'; 
            share34.RowCause = 'Manual';
            sre.add(share34);
        }
        if(acc.Wave3_Approver_2__c !=null){
            ITPR__Share share35 = new ITPR__Share();
            share35.ParentId = acc.Id; 
            share35.UserOrGroupId=acc.Wave3_Approver_2__c;
            share35.AccessLevel='Edit'; 
            share35.RowCause = 'Manual';
            sre.add(share35);
        }
        if(acc.Wave3_Approver_3__c !=null){
            ITPR__Share share36 = new ITPR__Share();
            share36.ParentId = acc.Id; 
            share36.UserOrGroupId=acc.Wave3_Approver_3__c;
            share36.AccessLevel='Edit'; 
            share36.RowCause = 'Manual';
            sre.add(share36);
        }
        
              /****Capgemini :Added Code for 3 Additional Approver read access****/
	if(acc.Additional_Approver_1__c !=null){
            ITPR__Share share110 = new ITPR__Share();
            share110.ParentId = acc.Id; 
            share110.UserOrGroupId=acc.Additional_Approver_1__c;
            share110.AccessLevel='Edit'; 
            share110.RowCause = 'Manual';
            sre.add(share110);
        }
	
	if(acc.Additional_Approver_2__c !=null){
            ITPR__Share share111 = new ITPR__Share();
            share111.ParentId = acc.Id; 
            share111.UserOrGroupId=acc.Additional_Approver_2__c;
            share111.AccessLevel='Edit'; 
            share111.RowCause = 'Manual';
            sre.add(share111);
        }

	if(acc.Additional_Approver_3__c !=null){
            ITPR__Share share112 = new ITPR__Share();
            share112.ParentId = acc.Id; 
            share112.UserOrGroupId=acc.Additional_Approver_3__c;
            share112.AccessLevel='Edit'; 
            share112.RowCause = 'Manual';
            sre.add(share112);
        }
      }
      
      /************* Sharing with users selected in the Viewer users Section of ITSES*/
      if(acc.user1__c !=null){
            ITPR__Share share_user1 = new ITPR__Share();
            share_user1.ParentId = acc.Id; 
            share_user1.UserOrGroupId=acc.user1__c;
            share_user1.AccessLevel='Read'; 
            share_user1.RowCause = 'Manual';
            sre.add(share_user1);
        }

      if(acc.user2__c !=null){
            ITPR__Share share_user2 = new ITPR__Share();
            share_user2.ParentId = acc.Id; 
            share_user2.UserOrGroupId=acc.user2__c;
            share_user2.AccessLevel='Read'; 
            share_user2.RowCause = 'Manual';
            sre.add(share_user2);
        }

      if(acc.user3__c !=null){
            ITPR__Share share_user3 = new ITPR__Share();
            share_user3.ParentId = acc.Id; 
            share_user3.UserOrGroupId=acc.user3__c;
            share_user3.AccessLevel='Read'; 
            share_user3.RowCause = 'Manual';
            sre.add(share_user3);
        }

      if(acc.user4__c !=null){
            ITPR__Share share_user4 = new ITPR__Share();
            share_user4.ParentId = acc.Id; 
            share_user4.UserOrGroupId=acc.user4__c;
            share_user4.AccessLevel='Read'; 
            share_user4.RowCause = 'Manual';
            sre.add(share_user4);
        }

      if(acc.user5__c !=null){
            ITPR__Share share_user5 = new ITPR__Share();
            share_user5.ParentId = acc.Id; 
            share_user5.UserOrGroupId=acc.user5__c;
            share_user5.AccessLevel='Read'; 
            share_user5.RowCause = 'Manual';
            sre.add(share_user5);
        }      
/*      
//Reinsert Departmental Super User Sharing      
          List<DepartmentalSuperUser__c> lstDSU = [Select Id, Viewer1__c, Viewer2__c, Viewer3__c, Viewer4__c, Viewer5__c,Additional_Access_1_Department__c , Additional_Access_2_Department__c, Additional_Access_3_Department__c,Additional_Access_4_Department__c,Additional_Access_5_Department__c,
                                                   Type_of_Access_1__c, Type_of_Access_2__c,Type_of_Access_3__c,Type_of_Access_4__c,Type_of_Access_5__c
                                                   from DepartmentalSuperUser__c where (OwnerId = :acc.CreatedBy.Id OR
                                                   OwnerId = :acc.Procurement_Assignee__c OR OwnerId = :acc.Legal_Assignee__c
                                                   OR OwnerId = :acc.Finance_Assignee__c  OR OwnerId = :acc.Vendor_Governance__c) ];
          
           ITPR_DepartmentalSuperUsers_share objDSU_ITPR_Share = new ITPR_DepartmentalSuperUsers_share();
           
           If(lstDSU.size() > 0)
           {
               for(DepartmentalSuperUser__c DSU : lstDSU)
               {
                   List<ITPR__Share> lstITPRShare_TEMP = objDSU_ITPR_Share.DSU_ITPR_Share(acc, DSU);
                    
                   if(lstITPRShare_TEMP.size() > 0)
                   {
                       for(ITPR__Share ITPR_temp : lstITPRShare_TEMP)
                       {
                            sre.add(ITPR_temp);
                       }
                   }
               }
           }*/
    }

    
   /*************Inserting the ITSES Share************/
   if(!sre.isEmpty())
   {
        Database.insert(sre,false);
   }
  }
  
  public void DSU_ITPR_Share(List<ITPR__c> lstITPR)
  {
      for(ITPR__c ITPR: lstITPR)
            { 
            
           ITPR_DepartmentalSuperUsers_share objDSU_ITPR_Share = new ITPR_DepartmentalSuperUsers_share();
           
           List<ITPR__Share> lstITPRShare_TEMP = objDSU_ITPR_Share.DSU_ITPR_Share(ITPR);
                    
                   if(lstITPRShare_TEMP.size() > 0)
                   {
                       for(ITPR__Share ITPR_temp : lstITPRShare_TEMP)
                       {
                            sre1.add(ITPR_temp);
                       }
                   }
               
            }
         
        /*  Map<Id, ITPR__Share> maptemp = new Map<Id, ITPR__Share>();
          
          List<DepartmentalSuperUser__c> lstDSU = [Select Id, Viewer1__c, Viewer2__c, Viewer3__c, Viewer4__c, Viewer5__c,Additional_Access_1_Department__c , Additional_Access_2_Department__c, Additional_Access_3_Department__c,Additional_Access_4_Department__c,Additional_Access_5_Department__c,
                                                   Type_of_Access_1__c, Type_of_Access_2__c,Type_of_Access_3__c,Type_of_Access_4__c,Type_of_Access_5__c
                                                   from DepartmentalSuperUser__c where (OwnerId = :ITPR.CreatedBy.Id OR
                                                   OwnerId = :ITPR.Procurement_Assignee__c OR OwnerId = :ITPR.Legal_Assignee__c
                                                   OR OwnerId = :ITPR.Finance_Assignee__c  OR OwnerId = :ITPR.Vendor_Governance__c) ];
          
          
           ITPR_DepartmentalSuperUsers_share objDSU_ITPR_Share = new ITPR_DepartmentalSuperUsers_share();
           
           If(lstDSU.size() > 0)
           {
               for(DepartmentalSuperUser__c DSU : lstDSU)
               {
                   List<ITPR__Share> lstITPRShare_TEMP = objDSU_ITPR_Share.DSU_ITPR_Share(ITPR, DSU);
                    
                   if(lstITPRShare_TEMP.size() > 0)
                   {
                       for(ITPR__Share ITPR_temp : lstITPRShare_TEMP)
                       {
                            //sre1.add(ITPR_temp);
                            maptemp.put(ITPR_temp.UserOrGroupId, ITPR_temp);
                       }
                   }
               }
           }
           
           for(Id key : maptemp.keyset())
           {
               sre1.add(maptemp.get(key));
           }*/
           
      /*************Inserting the ITSES Share************/
       if(!sre1.isEmpty())
       {
           Database.insert(sre1,false);
       }
  }
   
}