/****************************************************************************************************************************************
****************************************************************************************************************************************    
*  Class            : RFA_VFC_AddMultipleUsersctlr
*  Author           : INFOSYS
*  Version History  : 1.1
*  Creation         : 11/14/2015
*  Assumptions      : N/A
*  Description      : Controller Class for the RFA_VFP_AddMultipleUsers visualforce page. This class will determine the Approvers Label for the Send to 
based on the RFA criteria and allows users to add multiple approvers at a time                      

* Author            : jyoshna_g@infosys.com
* Date of Change    : Dec 29, 2015
* Description       : Added boolean variables to display the warning  messages.

****************************************************************************************************************************************
****************************************************************************************************************************************/

public with sharing class RFA_VFC_AddMultipleUsersctlr 
{
    public RFA__c rfaobj ;
    public ApexPages.StandardController ctrl;
    public string rfadoacategory;
    public IntermediaterfaAutoAppvr__c InAuobj {get;set;}
    public List<IntermediaterfaAutoAppvr__c>listofusers;
    public List<IntermediaterfaAutoAppvr__c>MasterList;
    public  List<IntermediaterfaAutoAppvr__c> intermApp ;
    public  List<IntermediaterfaAutoAppvr__c> finallist{get;set;} 
    public List<id> deleteIds;
    public Map<String, Integer> LevelsMap ;
     public Map<String, String> Levels;
    public Map<String, Integer> RecordTypesmap ;   
    public boolean selectARE {get;set;}
    public boolean Criteriausr {get;set;}   
    public boolean ErrorMessage {get;set;}
    public boolean EditMessage {get;set;}
    public boolean disablebuttons {get;set;}
    public boolean delemptyrowmsg {get;set;}
    public Id tobeEdited{get; set;}   
    public id tobeDeleted{get; set;}
    public integer totalRecords=0;
    public integer Counter=0;
    Public Integer size{get;set;}
    public integer rowNum{get;set;}
    public integer editvalue {get;set;}
    public integer deletevalue {get;set;}
    public Integer savevalue{get; set;}
    public integer cancelvalue {get;set;}
    public string ProfileName ;
    public boolean noemptyrow;
    public RFA_VFC_AddMultipleUsersctlr(ApexPages.StandardController ctrl)
    {
        Criteriausr = false;
        ErrorMessage  = false; 
        disablebuttons = false;
        delemptyrowmsg = false;
        selectARE = false;
        noemptyrow = true;
        listofusers = new List<IntermediaterfaAutoAppvr__c>();
        MasterList = new List<IntermediaterfaAutoAppvr__c>();
        deleteIds = new List<Id>();
        LevelsMap = new Map<String, Integer>{ '1. Key Operations' => 1, '2. Business Unit' => 2, '3. Group' => 3 , '4. Corporate' => 4, '5. Executive' => 5,'6. Senior Executive' => 6};
        Levels= new Map<String, string>{'KEYOP' => '1. Key Operations' ,'BU' => '2. Business Unit', 'GROUP' => '3. Group' , 'CORP' => '4. Corporate' ,'EXEC' => '5. Executive','Sr. EXEC' => '6. Senior Executive'};        
        RecordTypesmap = new Map<String, Integer>{ 'Approver' => 1, 'Info Copy Only' => 2,'Co-Creator' => 3 };  
        try
            {
                Id profileId=userinfo.getProfileId();
                ProfileName=[Select Id,Name from Profile where Id=:profileId].Name;
                rfaObj = (RFA__c)ctrl.getRecord();
                rfaobj = [select AREMonth__c,Stage__c,Level__c,ProfitCenterNumber__c,ProfitCenterName__c,RequestAmountUSD__c,PrimaryDOACategorySubCategory__c from RFA__c where id=: rfaobj.Id];                                       
                rfadoacategory = rfaobj.PrimaryDOACategorySubCategory__c;                
                rfadoacategory= rfadoacategory.replaceAll('(\\s+)', '');                             
                List<RFAUserRole__c> RFAPendingApprovers = [select Id,Level__c,UserName__c,Agent1__c,Agent2__c,Agent3__c,recordTypeId,Manual_Automated__c,ApprovalComments__c,ApprovalRecommendation__c from RFAUserRole__c where RFA__c =: rfaobj.Id ];                
                // Below code gets the list of only existing pending approvers (i.e., excluding approved users) and adds to Listofusers
                if(RFAPendingApprovers.size() > 0 && RFAPendingApprovers != null)
                {
                    for(RFAUserRole__c URobj : RFAPendingApprovers)
                    {                
                        IntermediaterfaAutoAppvr__c rfagruserobj = new IntermediaterfaAutoAppvr__c(); 
                        if(URobj.ApprovalRecommendation__c == null)
                        {                            
                            rfagruserobj.Agent1__c = URobj.Agent1__c;
                            rfagruserobj.Agent2__c = URobj.Agent2__c;
                            rfagruserobj.Agent3__c = URobj.Agent3__c;
                            if(URobj.Manual_Automated__c != null)
                            {
                                rfagruserobj.Manual_Automated__c = URobj.Manual_Automated__c;
                            }
                            else
                            {
                                rfagruserobj.Manual_Automated__c = 'Manual';
                            }
                            rfagruserobj.Level__c = URobj.Level__c;
                            Map<Id,RecordTypeInfo> recrdname=Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosById();
                            rfagruserobj.RoleType__c = recrdname.get(URobj.recordTypeId).getName();
                            rfagruserobj.Approver__c = URobj.UserName__c;                   
                            rfagruserobj.ApprovalComments__c = URobj.ApprovalRecommendation__c;                    
                            rfagruserobj.RFAId__c = rfaobj.Id;
                            rfagruserobj.ExistingOne__c = URobj.Id; 
                            rfagruserobj.Usercount__c ='' ;
                            listofusers.add(rfagruserobj);
                        }
                    }            
                    MasterList.addAll(listofusers);
                } 
                //Below is the new code 
                listofusers = new List<IntermediaterfaAutoAppvr__c>();
                List<RFA_GroupApprover__c> grpusrs = new List<RFA_GroupApprover__c>();
                List<String> grpnames = new List<String>();
                 Map<string,string> grproletype = new Map<string,string>();
                 Map<string,string> grpleveltype = new Map<string,string>();
                system.debug('rfaDOA Category is:' +rfadoacategory);
                system.debug('RFA request amount is :' + rfaobj.RequestAmountUSD__c);
                List<RFA_DOA__c> DOAgrps = [select Approver_Group__c,Approver_Type__c,Approver_Level__c from RFA_DOA__c where TrimmedDOACategory__c=: rfadoacategory and Amount_Upper_limit__c >=: rfaobj.RequestAmountUSD__c and Amount_Lower_limit__c <=: rfaobj.RequestAmountUSD__c];              
                 system.debug('DOA Grps are :' + DOAgrps);
                if(DOAgrps  != null)
                {
                  for(RFA_DOA__c obj : DOAgrps  )
                  {
                   grpnames.add(obj.Approver_Group__c);
                   grproletype.put(obj.Approver_Group__c,obj.Approver_Type__c);
                   grpleveltype.put(obj.Approver_Group__c,obj.Approver_Level__c);
                  }
                }
                system.debug('grp names are:' +grpnames);
                if(grpnames != null)
                {
                 grpusrs = [select Id,Approver_Name__c,Level__c,Approver_Group__c  from RFA_GroupApprover__c where Approver_Group__c in : grpnames  and Profit_Center__c =: rfaobj.ProfitCenterNumber__c]; 
                }
                 system.debug('grp users are:' +grpusrs);
                if(grpusrs != null)
                {
                   for (RFA_GroupApprover__c RGAobj : grpusrs)
                     {
                            IntermediaterfaAutoAppvr__c rfagruserobj = new IntermediaterfaAutoAppvr__c();                                             
                             rfagruserobj.Level__c = Levels.get(RGAobj.Level__c); 
                             rfagruserobj.RoleType__c = grproletype.get(RGAobj.Approver_Group__c);
                             rfagruserobj.Approver__c = RGAobj.Approver_Name__c;
                             rfagruserobj.Manual_Automated__c = 'Auto';
                             rfagruserobj.RFAId__c = rfaobj.Id;
                             rfagruserobj.ApprovalComments__c = '';
                             rfagruserobj.Usercount__c = '' ;
                             rfagruserobj.ExistingOne__c  = RGAobj.Id;
                             listofusers.add(rfagruserobj);
                     }
                }
                else
                {
                     grpusrs = [select Id,Approver_Name__c,Level__c,Approver_Role__c,Approver_Group__c  from RFA_GroupApprover__c where Approver_Group__c in : grpnames  and Profit_Center__c =''];
                     if(grpusrs != null)
                      {
                       for (RFA_GroupApprover__c RGAobj : grpusrs)
                         {
                                IntermediaterfaAutoAppvr__c rfagruserobj = new IntermediaterfaAutoAppvr__c();                                             
                                 rfagruserobj.Level__c = RGAobj.Level__c; 
                                 rfagruserobj.RoleType__c = Levels.get(RGAobj.Level__c);
                                 rfagruserobj.Approver__c = RGAobj.Approver_Name__c;
                                 rfagruserobj.Manual_Automated__c = 'Auto';
                                 rfagruserobj.RFAId__c = rfaobj.Id;
                                 rfagruserobj.ApprovalComments__c = '';
                                 rfagruserobj.Usercount__c = '' ;
                                 rfagruserobj.ExistingOne__c  = RGAobj.Id;
                                 listofusers.add(rfagruserobj);
                         }
                     }
                }
                system.debug('finalizedgrp users are:' +listofusers);
                //Below code gets the automated approvers based on the RFA criteria and adds to Listofusers
              /*  List<ProfitCenterCOAGroupJunctionobject__c>  selectedGroupNames = [select RFA_COA_Group_Name__r.Name from ProfitCenterCOAGroupJunctionobject__c where Profit_Center_Number__r.Id =:rfaobj.ProfitCenterNumber__c and RFA_COA_Group_Name__r.Amount__c =: rfaobj.RequestAmountUSD__c and  RFA_COA_Group_Name__r.TrimmedDOACategory__c =:rfadoacategory];                               
                List<String> groupnames = new List<String>();
                if(selectedGroupNames != null)
                {
                    for (ProfitCenterCOAGroupJunctionobject__c obj : selectedGroupNames)
                    {
                        groupnames.add(obj.RFA_COA_Group_Name__r.Name);
                    }
                }
                List<RFA_Approver__c> criteriausers = new List<RFA_Approver__c>();
                criteriausers = [select Username__c,UserRole__c,Level__c,RFA_COA_Group__c,RFA_COA_Group__r.name from RFA_Approver__c where RFA_COA_Group__r.name in : groupnames ];        
                listofusers = new List<IntermediaterfaAutoAppvr__c>();
                if(criteriausers != null)
                {                                  
                   for(RFA_Approver__c grpnamobj : criteriausers )
                      {                        
                         IntermediaterfaAutoAppvr__c rfagruserobj = new IntermediaterfaAutoAppvr__c();                                             
                         rfagruserobj.Level__c = grpnamobj.Level__c; 
                         rfagruserobj.RoleType__c = grpnamobj.UserRole__c;
                         rfagruserobj.Approver__c = grpnamobj.Username__c;
                         rfagruserobj.Manual_Automated__c = 'Auto';
                         rfagruserobj.RFAId__c = rfaobj.Id;
                         rfagruserobj.ApprovalComments__c = '';
                         rfagruserobj.Usercount__c = '' ;
                         listofusers.add(rfagruserobj);
                     }
                 } */
                if(listofusers.Size()>0)
                {                     
                                    
                    MasterList.addAll(listofusers);                    
                }
                else
                {
                    Criteriausr = true;   
                }
                listofusers = new  List<IntermediaterfaAutoAppvr__c>();
                listofusers = RemoveDuplicates(MasterList);                
                //Below code gets the list of Approved users and adds to Listofusers       
                List<RFAUserRole__c> approvedusers = [select Id,Level__c,UserName__c,Agent1__c,Agent2__c,Agent3__c,recordTypeId,Manual_Automated__c,ApprovalComments__c,ApprovalRecommendation__c from RFAUserRole__c where RFA__c =: rfaobj.Id and ApprovalRecommendation__c != null ];         
                List<IntermediaterfaAutoAppvr__c> appvrduserlist = new List<IntermediaterfaAutoAppvr__c>();       
                if(approvedusers.size() > 0 && approvedusers != null)
                {
                    for(RFAUserRole__c obj : approvedusers)
                    {
                        IntermediaterfaAutoAppvr__c rfagruserobj = new IntermediaterfaAutoAppvr__c();                    
                        rfagruserobj.Agent1__c = obj.Agent1__c;
                        rfagruserobj.Agent2__c = obj.Agent2__c;
                        rfagruserobj.Agent3__c = obj.Agent3__c;
                        rfagruserobj.Level__c = obj.Level__c;
                        if(obj.Manual_Automated__c != null)
                        {
                            rfagruserobj.Manual_Automated__c = obj.Manual_Automated__c;
                        }
                        else
                        {
                            rfagruserobj.Manual_Automated__c = 'Manual';
                        }           
                        rfagruserobj.Approver__c = obj.UserName__c;
                        rfagruserobj.ApprovalComments__c = obj.ApprovalRecommendation__c;
                        rfagruserobj.RFAId__c = rfaobj.Id;
                        rfagruserobj.ExistingOne__c = obj.Id;
                        rfagruserobj.Usercount__c = '' ;
                        Map<Id,RecordTypeInfo> recrdname=Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosById();            
                        rfagruserobj.RoleType__c =  recrdname.get(obj.recordTypeId).getName();
                        appvrduserlist.add(rfagruserobj);            
                    }
                }
                listofusers.addAll(appvrduserlist); 
            }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));  
        }
    }
    
    // Below code deletes the duplicate users based on recordtype priority considering "Approver" record type and "Senior Executive" level as high priority. 
    public List<IntermediaterfaAutoAppvr__c> RemoveDuplicates(List<IntermediaterfaAutoAppvr__c> UsersList)
    {
        try
        {
            List<IntermediaterfaAutoAppvr__c> distinctuserlist = new List<IntermediaterfaAutoAppvr__c>();
            List<IntermediaterfaAutoAppvr__c> Finallist = new List<IntermediaterfaAutoAppvr__c>();
            Map<string,List<IntermediaterfaAutoAppvr__c>> mapAllUsers = new Map<string,List<IntermediaterfaAutoAppvr__c>>();
            if(UsersList != null)
            {
                for(IntermediaterfaAutoAppvr__c obj : UsersList)
                {
                    String key = obj.Approver__c;                      
                    if(mapAllUsers.containsKey(key))
                    {                
                        (mapAllUsers.get(key)).add(obj);
                    }              
                    else
                    { 
                        distinctuserlist = new List<IntermediaterfaAutoAppvr__c>();
                        distinctuserlist.add(obj); 
                        mapAllUsers.put(key,distinctuserlist);                   
                    }
                    
                }
            }
            Map<Id,RecordTypeInfo> recTypeIdMap=Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosById();
            for(string keyvar : mapAllUsers.keySet() )
            {
                distinctuserlist = new List<IntermediaterfaAutoAppvr__c>();                
                distinctuserlist =  mapAllUsers.get(keyvar);               
                IntermediaterfaAutoAppvr__c finaRec = new IntermediaterfaAutoAppvr__c();
                if(distinctuserlist.size()>1)
                {                   
                    for(integer i=0 ; i < distinctuserlist.size() ; i++)
                    {
                        if(i==0)
                        {                                 
                            finaRec= distinctuserlist[i];
                        }
                        else
                        {  
                            Integer currentroletype  =RecordTypesmap.get(distinctuserlist[i].RoleType__c);                                
                            Integer existingroletype =RecordTypesmap.get(finaRec.RoleType__c);                                
                            if(currentroletype < existingroletype)
                            {                                    
                                finaRec=distinctuserlist[i];
                            }
                            else if(currentroletype == existingroletype)
                            {
                                Integer currentleveltype  =RecordTypesmap.get(distinctuserlist[i].Level__c);                                
                                Integer existingleveltype =RecordTypesmap.get(finaRec.Level__c);
                                if(currentleveltype > existingleveltype)
                                {
                                    finaRec=distinctuserlist[i];
                                }
                            }
                            
                        }
                    }
                    Finallist.add(finaRec);
                }
                else if(distinctuserlist.size()==1)
                {
                    Finallist.add(distinctuserlist[0]);
                }               
                
            }      
            return Finallist;
        }
        catch(Exception ex)
        {
         throw ex;   
        }
    }
    //Below Method inserts the finallist(unique list) of approvers to intermediate object
    public pageReference insertInauObj()
    {        
        intermApp=[select level__C from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id];
        delete  intermApp;               
        insert listofusers;
        intermApp = new List<IntermediaterfaAutoAppvr__c>();
        intermapp=[select ExistingOne__c,Approver__r.Email,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c,Usercount__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and Approver__c != null];
        duplicatecheckusername(intermapp);
        pagination();
        validateemptyrow();
        return null;
    }
    //Below method checks the presence of same user in the list and highlights that user on VF page
    public void duplicatecheckusername(List<IntermediaterfaAutoAppvr__c> dusrnameobj)
    {
        List<String> usrnames = new List<String>();
        if(dusrnameobj != null)
        {
            for(integer i=0;i<dusrnameobj.size();i++)
            {
                for(integer j=i+1; j<dusrnameobj.size();j++)
                {
                    if(dusrnameobj.get(i).Approver__c == dusrnameobj.get(j).Approver__c)
                    {                    
                        dusrnameobj.get(j).Usercount__c = 'Available'; 
                        dusrnameobj.get(i).Usercount__c = 'Available';
                        update dusrnameobj[i];
                        update dusrnameobj[j];                  
                        
                    }
                   
                }
            }
        }   
    }    
    //Below method inserts approvers to RFAUserRole object on click of Proceed on VF page
    public pagereference InsertUsers()
    {        
        try
        {           
             if(deleteIds != null)
               {
                 List<RFAUserRole__c> delobj = [select level__c,Agent1__c from RFAUserRole__c where Id in :deleteIds and RFA__c=:rfaObj.id ] ;
                  delete delobj;
                   
               }
            List<RFAUserRole__c> RFAApproverusers = new List<RFAUserRole__c>(); 
            Map<Id,RecordTypeInfo> recrdname=Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosById();
            //List<RFAUserRole__c> existingusers = [select Agent1__c,Agent2__c,Agent3__c,Level__c,UserName__c,RecordTypeId,Manual_Automated__c from RFAUserRole__c where RFA__c=:rfaobj.id ];
            List<IntermediaterfaAutoAppvr__c> existingrfausers =[select ExistingOne__c,Approver__r.Email,Approver__c,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Level__c,Agent1__c,Agent2__c,Agent3__c,Usercount__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and ExistingOne__c !=null];            
            if(existingrfausers != null)
            {
                for(IntermediaterfaAutoAppvr__c obj : existingrfausers)
                {            
                    RFAUserRole__c RFArole=new RFAUserRole__c();
                    RFArole.Agent1__c=Obj.Agent1__c;
                    RFArole.Agent2__c=Obj.Agent2__c;
                    RFArole.Agent3__c=Obj.Agent3__c;
                    RFArole.Level__c=Obj.Level__c;                
                    RFArole.RecordTypeId = Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosByName().get(obj.RoleType__c).getRecordTypeId();                       
                    RFArole.UserName__c=obj.Approver__c; 
                    RFArole.Manual_Automated__c = obj.Manual_Automated__c;
                    RFArole.RFA__c=rfaobj.id;
                    RFArole.Id = obj.ExistingOne__c;
                    RFAApproverusers.add(RFArole);
                    
                }
                update RFAApproverusers;                
            }
            List<IntermediaterfaAutoAppvr__c> newrfausers =[select ExistingOne__c,Approver__r.Email,Approver__c,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Level__c,Agent1__c,Agent2__c,Agent3__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and ExistingOne__c =null and RoleType__c != null ];            
            if(newrfausers != null)
            {
                RFAApproverusers = new List<RFAUserRole__c>();
                for(IntermediaterfaAutoAppvr__c obj : newrfausers)
                {            
                    RFAUserRole__c RFArole=new RFAUserRole__c();
                    RFArole.Agent1__c=Obj.Agent1__c;
                    RFArole.Agent2__c=Obj.Agent2__c;
                    RFArole.Agent3__c=Obj.Agent3__c;
                    RFArole.Level__c=Obj.Level__c;                        
                    RFArole.RecordTypeId = Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosByName().get(obj.RoleType__c).getRecordTypeId();                                               
                    RFArole.UserName__c=obj.Approver__c; 
                    RFArole.Manual_Automated__c = obj.Manual_Automated__c;
                    RFArole.RFA__c=rfaobj.id;                        
                    RFAApproverusers.add(RFArole);
                    
                }
                insert RFAApproverusers;                
            }           
            
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
        return new PageReference('/'+rfaobj.id);
    }   
    //Below method allows user to edit the approvers
    public pagereference EditUsers()
    {
        try
        {
            delemptyrowmsg = false;
            Criteriausr = false;
            tobeEdited = ApexPages.currentPage().getParameters().get('EditId');        
            rowNum =Integer.valueOf(ApexPages.currentPage().getParameters().get('indexid'));        
            if(rfaobj.Stage__c =='Circulation' && ProfileName.indexOf('RFA') >= 0 && (finallist[rowNum].RoleType__c == 'Approver' || finallist[rowNum].RoleType__c == 'Info Copy Only') )
            {            
                EditMessage = true;
                disablebuttons = false;
                tobeEdited=null;
            }       
            else if(finallist[rowNum].ApprovalComments__c != null)
            {
                ErrorMessage = true;
                disablebuttons = false;
                EditMessage = false;
                tobeEdited=null;
            }
            else
            {
                EditMessage = false;
                ErrorMessage = false;
                Inauobj = [select ExistingOne__c,Approver__r.Email,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c,Usercount__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and Id=:tobeEdited ];                                 
                disablebuttons = true;
            }
            
        }
        catch(Exception ex)
        {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
        return null;
    }
    //Below method allows user to delete the approvers
    public pagereference DeleteUsers()
    {
     try
      {
        tobeDeleted = ApexPages.currentPage().getParameters().get('DeleteId');       
        rowNum =Integer.valueOf(ApexPages.currentPage().getParameters().get('indexid'));
       if(finallist[rowNum].Level__c == null && finallist[rowNum].RoleType__c == null && finallist[rowNum].Approver__c == null )
        {
            delemptyrowmsg = true;
        } 
        else if(finallist[rowNum].ApprovalComments__c != null)
        {
            ErrorMessage = true;
            delemptyrowmsg = false;
        }         
        else
        {
            delemptyrowmsg = false;
            IntermediaterfaAutoAppvr__c deleterow  =[select ExistingOne__c,Level__c,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and Id=:tobeDeleted];            
            deleteIds.add(deleterow.ExistingOne__c);
            if(deleterow!=null)
            {
            delete deleterow;
            }
            ErrorMessage = false;
            finallist=[select ExistingOne__c,Approver__r.Email,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c,Usercount__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and Approver__c != null ];
                for(integer i=0; i< finallist.size(); i++)
                    {
                        finallist[i].Usercount__c ='';
                        update finallist[i];
                    }
                
                duplicatecheckusername(finallist); 
                pagination();
                
        }
      }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
        return null;
    }
    //Below method allows user to save the approvers info
    public pagereference SaveUsers()
    {  
        try
        {
            savevalue=Integer.valueOf(ApexPages.currentPage().getParameters().get('Saverownum'));
            finallist[savevalue].Manual_Automated__c = 'Manual';        
            noemptyrow = true; 
            if(finallist[savevalue].Approver__c != null && finallist[savevalue].RoleType__c == null )
            {   
                disablebuttons =true;
                noemptyrow = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select the User Type.'));
            }
            else if(finallist[savevalue].Approver__c == null && finallist[savevalue].RoleType__c != null )
            { 
                disablebuttons =true;
                noemptyrow = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select the UserName.'));
            }
            else if(finallist[savevalue].RoleType__c == 'Approver' || finallist[savevalue].RoleType__c == 'Info Copy Only')
            {
                if(finallist[savevalue].Level__c == '--None--' || finallist[savevalue].Level__c == null )
                {  
                    disablebuttons =true;
                    noemptyrow = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select the Level.'));
                    tobeEdited = finallist[savevalue].Id;
                }  
                else
                {             
                    update finallist[savevalue];
                    tobeEdited = null;                    
                     finallist=[select ExistingOne__c,Approver__r.Email,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c,Usercount__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and Approver__c != null];
                    for(integer i=0; i< finallist.size(); i++)
                    {
                        finallist[i].Usercount__c ='';
                        update finallist[i];
                    }
                   
                    duplicatecheckusername(finallist);
                    pagination();                
                    disablebuttons =false; 
                }
            }
            else
            {            
                update finallist[savevalue];
                tobeEdited = null;
                finallist=[select ExistingOne__c,Approver__r.Email,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c,Usercount__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and Approver__c != null ];
                for(integer i=0; i< finallist.size(); i++)
                    {
                        finallist[i].Usercount__c ='';
                        update finallist[i];
                    }
                
                duplicatecheckusername(finallist);          
                pagination();
                disablebuttons =false;                     
            }
            validateemptyrow();
            
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
        return null;
    }
    //Below method validates the existance of empty row in the list
    public void validateemptyrow()
    {        
        for(integer i=0; i< finallist.size();i++)
        {          
            if(finallist[i].Approver__c == null && finallist[i].RoleType__c == null && finallist[i].Level__c == null)
            {
                noemptyrow = false;
            } 
            else
            {
                noemptyrow = true;
            }
            
        }
    }
    //Below method allows user to cancel unsaved data
    public pagereference Cancelusers()
    {       
        cancelvalue = Integer.valueOf(ApexPages.currentPage().getParameters().get('Cancelrownum'));        
        finallist[cancelvalue]=inauobj;
        tobeEdited = null;
        disablebuttons =false;
        return null;
    }
    //Below method populates the agents info on select of Usertype in VF page
    public pagereference updateagentsinfo()
    {  
        user obj =[select RFA_Agent_1__c,RFA_Agent_2__c,RFA_Agent_3__c from User where Id=:finallist[rowNum].Approver__c];
        finallist[rowNum].Agent1__c=obj.RFA_Agent_1__c;
        finallist[rowNum].Agent2__c=obj.RFA_Agent_2__c;
        finallist[rowNum].Agent3__c=obj.RFA_Agent_3__c;        
        return null;
    }
    //Below method controls the no of rows per page in VF page
    public void pagination()
    {
        try
        {
            finallist = new List<IntermediaterfaAutoAppvr__c>();            
            // Insert empty row if noemptyrow=true
            if(noemptyrow)
            {           
                IntermediaterfaAutoAppvr__c obj = new IntermediaterfaAutoAppvr__c();        
                obj.RFAId__c = rfaobj.Id;
                obj.Manual_Automated__c ='Manual';
                insert obj;
                IntermediaterfaAutoAppvr__c emptyrow =[select ExistingOne__c,Approver__r.Email,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c,Usercount__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and Approver__c = null   LIMIT 1 ];
                finallist.add(emptyrow);
            }
            intermApp= new List<IntermediaterfaAutoAppvr__c>();        
            intermApp =[select ExistingOne__c,Approver__r.Email,RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c,Usercount__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id and Approver__c != null  order by  Level__c desc,RoleType__c asc LIMIT 10 OFFSET: counter ];                 
            for(integer i=1;i<=intermApp.size();i++)
            {  
                finallist.add(intermapp[i-1]);
                
            }             
            totalRecords =[select count()  from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id AND Approver__c!=null];
        }
        catch(Exception ex)
        {
            throw ex;
        }
    }
    
    public pagereference previous ()
    {
        if(counter>=10)
        {
            counter = counter -10;
        }
        else
        {
            counter =0; 
        } 
        delemptyrowmsg = false;
        ErrorMessage = false;
        EditMessage = false;        
        pagination();
        validateemptyrow();
        return null;
    }
    
    public pagereference next ()
    {        
        counter = counter +10;
        delemptyrowmsg = false;
        ErrorMessage = false;
        EditMessage = false;        
        pagination();
        validateemptyrow();
        return null;
    }
    
    public pagereference first ()
    {
        counter = 0; 
        delemptyrowmsg = false;
        ErrorMessage = false;
        EditMessage = false;
        pagination();
        validateemptyrow();
        return null;
    }
    
    public pagereference last ()
    {
        integer reminder = math.mod(totalrecords, 10);
        counter = totalRecords - reminder; 
        delemptyrowmsg = false;
        ErrorMessage = false;
        EditMessage = false;        
        pagination();
        validateemptyrow();
        return null;
    }
    
    public boolean getprv()
    {
        if (counter == 0)
            return true;
        else
            return false;    
    }
    
    public boolean getnxt()
    {
        if ((counter + 10) >= totalRecords)
            return true;
        else
            return false;    
    }
    
    public boolean getfst()
    {
        if (counter == 0)
            return true;
        else
            return false;    
    }
    
    public boolean getlst()
    {
        
        if ((counter + 10) >= totalRecords)
            return true;
        else
            return false;    
    }
    
}