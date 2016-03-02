public class RFA_VFC_NewAutoApproverController 
{
    public RFA__c rfaobj ;
    public String searchstring {get;set;} 
    Public Integer size{get;set;}
    //public Id UserId {get;set;}   
    public List<RFA_Approver__c> criteriausers;
    public List<IntermediaterfaAutoAppvr__c> listofusers;
    public List<IntermediaterfaAutoAppvr__c> MasterList;
     public Map<string,List<IntermediaterfaAutoAppvr__c>> mapAllUsers;
    public List<ProfitCenterCOAGroupJunctionobject__c>  GroupNames;  
    //public IntermediaterfaAutoAppvr__c usrroleobj {get;set;}    
    public List<IntermediaterfaAutoAppvr__c> intermApp{get;set;}
    public id tobeDeleted{get; set;}
    public List<RFAUserRole__c> approvedusers {get;set;}
    public Map<String, Integer> LevelsMap ;
    public Map<String, Integer> RecordTypesmap ;
    public List<user> rfausers {get;set;}   
    public  List<RFAUserRole__c> RFAPendingApprovers; 
    public List<Userwrapper> UsersList =  new List<Userwrapper>();
    public List<User> selectedUsers = new List<User>();
    public boolean tablerendered {get;set;} 
    public boolean ErrorMessage {get;set;}
    public boolean Criteriausr {get;set;}
   
    public RFA_VFC_NewAutoApproverController(ApexPages.StandardController ctrl)
    {         
        tablerendered=false;
        ErrorMessage = false;
        Criteriausr= false;
        rfaobj = new RFA__c(); 
        //Set<String> Levels= null;
        GroupNames = new List<ProfitCenterCOAGroupJunctionobject__c>();
        MasterList = new  List<IntermediaterfaAutoAppvr__c>();        
        criteriausers= new List<RFA_Approver__c>();
        listofusers = new List<IntermediaterfaAutoAppvr__c>();
        mapAllUsers = new Map<string,List<IntermediaterfaAutoAppvr__c>>();       
       // lstusrrole = new List<IntermediaterfaAutoAppvr__c>();         
        intermapp =new  List<IntermediaterfaAutoAppvr__c>();
        //LevelsMap = new Map<String, Integer>{ '1. Key Operations' => 1, '2. Business Unit' => 2, '3. Group' => 3 , '4. Corporate' => 4, '5. Executive' => 5,'6. Senior Executive' => 6};      
        RecordTypesmap = new Map<String, Integer>{ 'Approver' => 1, 'Co-Creator' => 2, 'Info Copy Only' => 3 };          
        //setgroupusers = new Set<RFAApproverGroupUser__c>();
        RFAPendingApprovers = new List<RFAUserRole__c>();
        rfausers = new List<user>();               
        rfaObj = (RFA__c)ctrl.getRecord();  
        system.debug('RFA id is :' +rfaObj.ID);        
        rfaobj = [select Level__c,ProfitCenterNumber__c,ProfitCenterName__c,RequestAmountUSD__c,PrimaryDOACategorySubCategory__c from RFA__c where id=: rfaobj.Id];        
        system.debug('RFA result is :' +rfaObj);
        RFAPendingApprovers = [select Id,Level__c,UserName__c,Agent1__c,Agent2__c,Agent3__c,recordTypeId,Manual_Automated__c,ApprovalRecommendation__c from RFAUserRole__c where RFA__c =: rfaobj.Id ];        
        system.debug('RFAPending Approvers are :' +RFAPendingApprovers);
        if(RFAPendingApprovers.size() > 0)
        {
            for(RFAUserRole__c URobj : RFAPendingApprovers)
            {                
                IntermediaterfaAutoAppvr__c rfagruserobj = new IntermediaterfaAutoAppvr__c(); 
                // Getting list of only existing pending approvers (i.e., excluding approved users)
                if(URobj.ApprovalRecommendation__c == null)
                {
                    system.debug('Hello');
                    rfagruserobj.Agent1__c = URobj.Agent1__c;
                    rfagruserobj.Agent2__c = URobj.Agent2__c;
                    rfagruserobj.Agent3__c = URobj.Agent3__c;
                    rfagruserobj.Manual_Automated__c = 'Manual';
                    rfagruserobj.Level__c = URobj.Level__c;                    
                   // string recrdname= [select Name from recordType where  SobjectType='RFAUserRole__c' and Id=:URobj.recordTypeId].Name;                     
                    //rfagruserobj.recordTypeId= [select Id from recordType where  SobjectType='IntermediaterfaAutoAppvr__c' and Name=:recrdname].Id;                    
                    Map<Id,RecordTypeInfo> recrdname=Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosById();
                    rfagruserobj.RoleType__c = recrdname.get(URobj.recordTypeId).getName();
                    rfagruserobj.Approver__c = URobj.UserName__c;                   
                    rfagruserobj.ApprovalComments__c = URobj.ApprovalRecommendation__c;                    
                    rfagruserobj.RFAId__c = rfaobj.Id;                    
                    listofusers.add(rfagruserobj);
                }
            }            
            MasterList.addAll(listofusers);
        }
        system.debug('Master List is:' +MasterList);       
        List<ProfitCenterCOAGroupJunctionobject__c>  selectedGroupNames = [select RFA_COA_Group_Name__r.Name from ProfitCenterCOAGroupJunctionobject__c where Profit_Center_Number__r.Id =:rfaobj.ProfitCenterNumber__c and RFA_COA_Group_Name__r.Amount__c =: rfaobj.RequestAmountUSD__c ];
        system.debug('Selected Groupnames are:' +selectedGroupNames);        
        List<RFA_Approver__c> criteriausers = new List<RFA_Approver__c>();
        criteriausers = [select Username__c,UserRole__c,Level__c,RFA_COA_Group__c,RFA_COA_Group__r.name from RFA_Approver__c ];
        system.debug('All Groupnames are:' +criteriausers); 
        listofusers = new List<IntermediaterfaAutoAppvr__c>();
        for(ProfitCenterCOAGroupJunctionobject__c junobj : selectedGroupNames )
          {              
           for(RFA_Approver__c grpnamobj : criteriausers )
              {  
                if(junobj.RFA_COA_Group_Name__c == grpnamobj.RFA_COA_Group__c)
                {                      
                       system.debug('Criteria users are Present');                    
                        IntermediaterfaAutoAppvr__c rfagruserobj = new IntermediaterfaAutoAppvr__c();                         
                        rfagruserobj.Level__c = grpnamobj.Level__c;                         
                        //rfagruserobj.RecordTypeId =  [select Id from recordType where  SobjectType='IntermediaterfaAutoAppvr__c' and Name =: grpnamobj.UserRole__c].Id;                                           
                        rfagruserobj.RoleType__c = grpnamobj.UserRole__c;
                        rfagruserobj.Approver__c = grpnamobj.Username__c;
                        rfagruserobj.Manual_Automated__c = 'Auto';
                        rfagruserobj.RFAId__c = rfaobj.Id;
                        rfagruserobj.ApprovalComments__c = '';
                        listofusers.add(rfagruserobj);
                        system.debug('List is:'+listofusers);
                        
                        
                    }
                }
          }
        if(listofusers.Size()>0)
        {
          MasterList.addAll(listofusers);
        }
        else
        {
         Criteriausr = true;   
        }
       
       system.debug('Final List of users are :' +MasterList);        
       listofusers = new  List<IntermediaterfaAutoAppvr__c>();      
       listofusers = RemoveDuplicates(MasterList); 
        system.debug('Final Prioritized List of users are :' +listofusers);
        //Below code adds the list of Approved users to Listofusers
         approvedusers = new  List<RFAUserRole__c>();
        approvedusers = [select Id,Level__c,UserName__c,Agent1__c,Agent2__c,Agent3__c,recordTypeId,Manual_Automated__c,ApprovalRecommendation__c from RFAUserRole__c where RFA__c =: rfaobj.Id and ApprovalRecommendation__c != null ];
        system.debug('Approved List of users are :' +approvedusers); 
        List<IntermediaterfaAutoAppvr__c> appvrduserlist = new List<IntermediaterfaAutoAppvr__c>();
        for(RFAUserRole__c obj : approvedusers)
        {
            IntermediaterfaAutoAppvr__c rfagruserobj = new IntermediaterfaAutoAppvr__c();            
            rfagruserobj.Agent1__c = obj.Agent1__c;
            rfagruserobj.Agent2__c = obj.Agent2__c;
            rfagruserobj.Agent3__c = obj.Agent3__c;
            rfagruserobj.Level__c = obj.Level__c;
            rfagruserobj.Manual_Automated__c = 'Manual';
            rfagruserobj.Approver__c = obj.UserName__c;
            rfagruserobj.ApprovalComments__c = obj.ApprovalRecommendation__c;
            rfagruserobj.RFAId__c = rfaobj.Id;
            Map<Id,RecordTypeInfo> recrdname=Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosById();
           // string recrdname= [select Id,Name from recordType where  SobjectType='RFAUserRole__c' and Id=:obj.recordTypeId].Name;
            rfagruserobj.RoleType__c =  recrdname.get(obj.recordTypeId).getName();
            appvrduserlist.add(rfagruserobj);            
        }
        listofusers.addAll(appvrduserlist);          
   }  
    // Below code deletes the duplicate users based on recordtype priority
    public List<IntermediaterfaAutoAppvr__c> RemoveDuplicates(List<IntermediaterfaAutoAppvr__c> UsersList)
    {
        List<IntermediaterfaAutoAppvr__c> distinctuserlist = new List<IntermediaterfaAutoAppvr__c>();
         List<IntermediaterfaAutoAppvr__c> Finallist = new List<IntermediaterfaAutoAppvr__c>();
        for(IntermediaterfaAutoAppvr__c obj : UsersList)
         {
              String key = obj.Approver__c;
              system.debug('Combined key is :' +key);          
              if(mapAllUsers.containsKey(key))
              {
                  //distinctuserlist.add(obj); 
                  (mapAllUsers.get(key)).add(obj);
              }              
              else
              { 
                  distinctuserlist = new List<IntermediaterfaAutoAppvr__c>();
                  distinctuserlist.add(obj); 
                  mapAllUsers.put(key,distinctuserlist);                   
              }
            
         }
         system.debug('Mapallusers are:' +mapAllUsers);
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
                                //String curntrectypeName=recTypeIdMap.get(distinctuserlist[i].RecordTypeId).getName(); 
                                String curntrectypeName=distinctuserlist[i].RoleType__c; 
                                String finalrecName=finaRec.RoleType__c;                               
                                Integer current  =RecordTypesmap.get(curntrectypeName);                                
                                Integer existing =RecordTypesmap.get(finalrecName);
                                if(current < existing)
                                {                                    
                                    finaRec=distinctuserlist[i];
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
        system.debug('FinalList Is:' +Finallist);
        return Finallist;
    }
    public ApexPages.StandardSetController setCon 
    {
        get{
            List<Profile> rfaprofsuser = [Select Id,Name from Profile where Name like '%RFA - Standard User%'];
             if(tablerendered)
                { 
                    system.debug('when string is searched clicked1:' +searchstring);
                    if(!String.isEmpty(searchstring))
                    {
                    system.debug('when string is searched clicked:' +searchstring);                    
                    string searchquery='select Id,Name,FirstName,LastName,Email from user where  profileId in : rfaprofsuser and (name like \'%'+searchstring+'%\' OR Email like \'%'+searchstring+'%\')  order by Name asc';  
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator(searchquery));
                    setCon.setPageSize(size);
                    }
                    else
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide FirstName or LastName to search users.'));
                    }
                }
            else
            {
                if(setCon == null)
                {
                system.debug('When cancel is clicked');
                size = 10;
                string queryString = 'select Id, Name, FirstName,LastName,Email from User where profileId in : rfaprofsuser order by Name asc';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                 }
            }
            return setCon;
        }set;
    }
     public List<Userwrapper> getusers()
    {
         UsersList = new List<Userwrapper>();
        if( setCon.getResultSize() > 0)
        {
             for(User Userobj : (List<User>)setCon.getRecords())
             {
                 System.debug('get users called when clicked on searcj & Cancel');
               UsersList.add(new Userwrapper(Userobj));
             }
        }
        else
        {
           
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No User is available with the search string'));
        }
        return UsersList;
    }
    
     public pageReference insertInauObj()
    {        
        intermApp=[select level__C from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id];
        delete  intermApp;        
        insert listofusers;
        intermApp =[select RoleType__c,ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id order by Level__c asc];       
        return null;
    } 
    public pagereference searchUsers()
    { 
        tablerendered=true;
        system.debug('When search string is clicked');
       // getusers();                                
        return null;
    }
    public pagereference ClearUsers()
    {
        searchstring='';        
        tablerendered=false;
        system.debug('When cancel is clicked calling getusers method');        
        return null;
    }
    
    public pagereference Addtotable()
    {         
        List<User> selectedUsers = new List<User>();
        for(Userwrapper uObj:UsersList) 
        {            
            if(uObj.selected == true) 
            {  
                Criteriausr = false;
                selectedUsers.add(uObj.userObj);
                IntermediaterfaAutoAppvr__c userselected= new IntermediaterfaAutoAppvr__c();                
                userselected.Approver__c =uObj.userObj.Id;              
                userselected.RFAId__c = rfaobj.Id;
                userselected.Manual_Automated__c = 'Manual' ;
                userselected.RoleType__c = 'Approver' ;
                intermApp.add(userselected);
                uObj.selected =false;
                
            }
        }
        system.debug('inserting....');
        upsert intermApp;
        return null;
    }  
   
    public pagereference DeleteRFAUserrole()
    {
        system.debug('Delete action called');
        tobeDeleted = ApexPages.currentPage().getParameters().get('DeleteId');
        system.debug('Deleted Id is:' +tobeDeleted);
        IntermediaterfaAutoAppvr__c obj =[select Id,ApprovalComments__c from IntermediaterfaAutoAppvr__c where Id=: tobeDeleted];
        system.debug('Selected row Approvers comments is:' +obj.ApprovalComments__c);
        if(obj.ApprovalComments__c != null)
        {
           ErrorMessage = true;
          //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot delete an approved user'));  
        }
        else
        {
            intermApp=[select level__C from IntermediaterfaAutoAppvr__c where Id=: tobeDeleted];
            delete  intermApp;            
        } 
        
        intermApp = [select ApprovalComments__c,RFAId__c,Manual_Automated__c,Approver__c,Level__c,Agent1__c,Agent2__c,Agent3__c from IntermediaterfaAutoAppvr__c where RFAId__c=:rfaObj.id order by Level__c asc];
        return null;
    }
    
    public PageReference InsertApprovers()
    {
        //Id Primartpointofcontact =[select Id from recordType where SobjectType='RFAUserrole__c' and Name='Primary Point of Contact'].Id;
        List<RFAUserrole__c> existingroles = [select UserName__c,Level__c,RecordTypeId from RFAUserrole__c where RFA__c=:rfaobj.id ];                
        if(intermapp!=null)       
        {            
            for(IntermediaterfaAutoAppvr__c Obj  : intermapp)
            {
               /* for(RFAUserrole__c RFAURobj : existingroles )
                {
                    if(RFAURobj.UserName__c == Obj.Approver__c && RFAURobj.Level__c == obj.Level__c && RFAURobj.RecordTypeId == Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosByName().get(obj.RoleType__c).getRecordTypeId() )
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
                        //RFArole.Id=RFAURobj.Id;
                        RFAPendingApprovers.add(RFArole);
                    }
                    else
                    {*/
                        RFAUserRole__c RFArole=new RFAUserRole__c();
                        RFArole.Agent1__c=Obj.Agent1__c;
                        RFArole.Agent2__c=Obj.Agent2__c;
                        RFArole.Agent3__c=Obj.Agent3__c;
                        RFArole.Level__c=Obj.Level__c;                
                        RFArole.RecordTypeId = Schema.sObjectType.RFAUserRole__c.getRecordTypeInfosByName().get(obj.RoleType__c).getRecordTypeId();
                       /* if(obj.recordTypeId != null)
                        {
                        string recrdname= [select Name from recordType where  SobjectType='IntermediaterfaAutoAppvr__c' and Id=:obj.recordTypeId].Name;                     
                        RFArole.RecordTypeId= [select Id from recordType where  SobjectType='RFAUserRole__c' and Name=:recrdname].Id;          
                        }
                        RFArole.RecordTypeId=[Select Id from recordType where SobjectType='RFAUserRole__c' and ].Id;*/
                        RFArole.UserName__c=obj.Approver__c; 
                        RFArole.Manual_Automated__c = obj.Manual_Automated__c;
                        RFArole.RFA__c=rfaobj.id;
                        RFAPendingApprovers.add(RFArole);
                    //}
                }
            }            
            Upsert RFAPendingApprovers;
         return new PageReference('/'+rfaobj.id);
        }
       
    
     public PageReference getSelected()
    {
        selectedUsers.clear();
        for(Userwrapper usrwrapper : UsersList)
        if(usrwrapper.selected == true)
        selectedUsers.add(usrwrapper.userobj);
        return null;
    }
     public List<User> GetselectedUsers()
    {
        if(selectedUsers.size()>0)
        return selectedUsers;
        else
        return null;
    }    
    
    public class Userwrapper
    {
        public User userobj{get; set;}
        public Boolean selected {get; set;}
        public Userwrapper(User u)
        {
            userobj = u;
            selected = false;
        }
    }
     public Boolean hasNext {
        get {
            system.debug('Has Next is:' +setCon.getHasNext());
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
             system.debug('Has Previous is:' +setCon.getHasPrevious());
            return setCon.getHasPrevious();
        }
        set;
    }
    
    public void first() {
        setCon.first();
        
    }
  
    public void last() {
        setCon.last();
       
    }
  
    public void previous() {
        setCon.previous();
       
    }
  
    public void next() {
        setCon.next();
        
    }
    
}