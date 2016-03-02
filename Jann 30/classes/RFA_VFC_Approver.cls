public class RFA_VFC_Approver 
{
    public RFA_GroupApprover__c GrpApprverObj {get;set;}
    public String selectedLevel{set;get;}
    public List<SelectOption> ApproverLevels{set;get;}
    
    
    public String selectedApproverRole{set;get;}
    public List<SelectOption> ApproverRole{set;get;}
    public Boolean ApproverRoles{set;get;}
    public Decimal sequence{get;set;}
     public Boolean ApproverGroups{set;get;}
    
    public String selectedGroup{set;get;}
    public List<SelectOption> ApproverGroup{set;get;}
    
    public boolean editMode{get;set;}
    public boolean viewMode{get;set;}
    String GroupDescription;
    public boolean showmessage {get;set;}
    String ProfileName;
    Id username;
    public Boolean FieldMsgs{set;get;} 
    public RFA_VFC_Approver(apexpages.StandardController appCtrl)
    {
        ApproverRoles = false;
        showmessage = false;
        FieldMsgs = false;
        //Coordinator Level security
        username = userinfo.getUserId();
        Id profileId=userinfo.getProfileId();
        ProfileName = [Select Id,Name from Profile where Id=:profileId].Name;
        if(ProfileName != null && ProfileName == 'RFA - Standard User' )
           {
              List<ProfitCenterUserRole__c> PCUobj = [select Level__c from ProfitCenterUserRole__c where UserName__c = : username and UserType__c = 'Location Coordinator' ];
               if(PCUobj != null && PCUobj.size() >0 )
               {
                 getAvailableLevels(); 
                 editmode = true;
               }
               else
               {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You Donot Have Permissions to Edit Approver'));  
                  showmessage = true ; 
                   FieldMsgs = false;
                   editmode = false;
               }    
           }
        //End here
    if(showmessage == false)
    {
        GrpApprverObj = (RFA_GroupApprover__c)appCtrl.getRecord();
        System.debug('GrpApprverObj'+GrpApprverObj);
        System.debug('GrpApprverObj.Id'+GrpApprverObj.Id);
        if(GrpApprverObj.Id!=null)
        {
            System.debug('hi iam null');
            GrpApprverObj=[select Profit_Center__c,Approver_Name__c,Approver_Group__c,Approver_Group_Description__c,Sequence__c ,Approver_Role__c,Level__c ,Key_Operation__c ,Business_Unit__c, Group__c,LastModifiedById, createdById   from RFA_GroupApprover__c  where id=:GrpApprverObj.id ];
            sequence = GrpApprverObj.Sequence__c;
            selectedLevel = GrpApprverObj.Level__c;
            selectedApproverRole = GrpApprverObj.Approver_Role__c;
            selectedGroup = GrpApprverObj.Approver_Group__c; 
        }
        
        //Populating selected Group
        ApproverGroup= new List<SelectOption>();
        if(selectedGroup!=null)
        {
            ApproverGroup.add(new SelectOption('--Select--','--Select--'));
            ApproverGroup.add(new SelectOption(selectedGroup,selectedGroup));
        }
         
        
       
        System.debug('Levels that can be accessed '+ApproverLevels);
            
        /*Schema.DescribeFieldResult ApproverLevelsResult = RFA_GroupApprover__c.Level__c.getDescribe();
         
        ApproverLevels.add(new SelectOption('--Select--','--Select--'));
        for (Schema.PicklistEntry ApproverLevelpicklist : ApproverLevelsResult.getPicklistValues())
        {
                System.debug('ApproverLevelpicklist label '+ApproverLevelpicklist.getLabel());
                ApproverLevels.add(new SelectOption(ApproverLevelpicklist.getValue(),ApproverLevelpicklist.getLabel()));
        }  
        */
        
        
        
        /*if(ApexPages.currentPage().getParameters().get('save_new') != null || (ApexPages.currentPage().getParameters().get('id') == null && ApexPages.currentPage().getParameters().get('retURL') != null))
        {
            editMode = false;
            viewMode = false;
        }
        else if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('retURL') != null)
        {
            editMode = true;
            viewMode = false;
        }
        else
        {
            editMode = false;
            viewMode = true;
        }*/
        string url = ApexPages.currentPage().getURL();
        if(ApexPages.currentPage().getParameters().get('Id')!=null&& !url.contains('retURL'))       
        {  
            System.debug('You opened in detail mode');
            EditMode=false;
           
        }
         else
        {
            System.debug('You opened in EDIT mode');
            EditMode=true;
            getAvailableLevels();
        } 
        }
    }
    /*
    Public void getApproverRoles()
    {
        ApproverRole = new List<SelectOption>();
        ApproverRoles=true;
        system.debug('Level is..'+GrpApprveRObj.Level__c);
        system.debug('selectedLevel Level is..'+selectedLevel);
         
        if(selectedLevel!=null&&selectedLevel!='')
        { 
        
        List<Approver_Group__c> GroupsList = [Select Approver_GroupName__c,Approver_Role__c from Approver_Group__c where level__C=:selectedLevel];
        System.debug('Groups are: '+GroupsList);
        ApproverRole.add(new SelectOption('--Select--','--Select--'));
        for(Approver_Group__c eachGrp: GroupsList)
        {
            ApproverRole.add(new SelectOption(eachGrp.Approver_Role__c,eachGrp.Approver_Role__c));
        }
        }
    }
    */
    
    Public void getApproverGroups()
    {
        ApproverGroups = true;
         
        List<Approver_Group__c> GroupsList = [Select Approver_GroupName__c,Approver_Group_Description__c from Approver_Group__c where Approver_GroupName__c like :selectedLevel+'%'];
        System.debug('GroupsList'+GroupsList);
        ApproverGroup = new List<SelectOption>();
        for(Approver_Group__c eachGrp : GroupsList)
        {
            ApproverGroup.add(new selectOption(eachGrp.Approver_GroupName__c,eachGrp.Approver_GroupName__c));
             
        } 
    }
    public void getAvailableLevels()
    {
        ApproverLevels = new List<SelectOption>();         
        //Populating Approver Level values
        ApproverLevels = RFA_VFC_CoordinatorLevelHelper.getAvailableLevels();
    }
    /*
    Public void getApproverGroups()
    {
        ApproverGroups = true;
        String LevelRole=selectedLevel+' '+selectedApproverRole;
        system.debug('Level Role combination '+LevelRole);
        List<Approver_Group__c> GroupsList = [Select Approver_GroupName__c,Approver_Group_Description__c from Approver_Group__c where Approver_GroupName__c=:LevelRole];
        System.debug('GroupsList'+GroupsList);
        ApproverGroup = new List<SelectOption>();
        for(Approver_Group__c eachGrp : GroupsList)
        {
            ApproverGroup.add(new selectOption(eachGrp.Approver_GroupName__c,eachGrp.Approver_GroupName__c));
            GroupDescription = eachGrp.Approver_Group_Description__c;
        } 
    }*/
    
    public PageReference saveApprover()
    {
        try{
        if(selectedGroup=='--Select--' && ApproverGroup.size()>1)
        {
            FieldMsgs = true;
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Approver Group'));
        }
        else{
            if(selectedGroup=='--Select--')
            {
                selectedGroup=null;
            }
            EditMode=false;
            System.debug('GrpApprveRObj '+GrpApprveRObj);
            System.debug('GrpApprveRObj.sequence'+sequence);
            GrpApprveRObj.sequence__c=sequence;
            GrpApprveRObj.Approver_Role__c=selectedApproverRole;
            GrpApprveRObj.Level__c = selectedLevel;
            GrpApprveRObj.Approver_Group__c=selectedGroup;
            List<Approver_Group__c> Groupdesc=[select Approver_Group_Description__c from Approver_Group__c where Approver_GroupName__c=:selectedGroup];
            System.debug('Group descripton'+Groupdesc);
            if(Groupdesc!=null)
            {
             GrpApprveRObj.Approver_Group_Description__c= Groupdesc.get(0).Approver_Group_Description__c;   
            }
            
            //GrpApprveRObj.Approver_Name__c=
            upsert GrpApprveRObj;
            }
        }
            catch(System.DmlException  e)
            {
                 EditMode=true;
                  FieldMsgs = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getDMLMessage(0)));        
            }
        
        return null;
    }
    public PageReference EditApprover()
    {
        editMode = true;
        return null;
    }
    public PageReference CancelApprover()
    {
        editMode=false;
        System.debug('hi null'+GrpApprverObj.Id);
        if(GrpApprverObj.Id==null)
        {
            System.debug('hi null');
            return new PageReference('/a1o/o');
        }
        else
        {
             System.debug('hi null');
              return null ;
        }
    }
    public PageReference DeleteApprover()
    {
        editMode=false;
        delete GrpApprveRObj;
        return new PageReference('/a1o/o');
            
    }
    
    public pagereference Bck()
    {
      pagereference pref = new pagereference('/a1o?fcf=00Bg00000016xp9');
      return pref;
    }
    
    
}