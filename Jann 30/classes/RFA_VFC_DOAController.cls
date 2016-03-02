public  with sharing class RFA_VFC_DOAController {
    Public RFA_DOA__c DOAObj{set;get;}
    Public List<selectOption> DOACategory{set;get;}
    Public String selectedDOACategory{set;get;}   
    Public List<selectOption> DOAControlLevel{set;get;}
    Public String selectedDOAControlLevel{set;get;} 
    Public Decimal  AmountUpperLimit{set;get;}
    Public Decimal  AmountLowerLimit{set;get;}
    Public String Comments{set;get;}
    Public List<selectOption> ControlLevel{set;get;}
    Public String selectedControlLevel{set;get;}
    
    Public List<selectOption> ApproverLevel{set;get;}
    Public String selectedApproverLevel{set;get;}
    Public List<selectOption> Approvergroup{set;get;}
    Public String selectedApprovergroup{set;get;}
    Public List<selectOption>approverType{set;get;}
    Public String selectedapproverType{set;get;}
    Public Boolean IsEditMode{set;get;}
    
    Public Boolean Grpapprover{set;get;}
    Public Boolean AppLevel{set;get;}
    Public RFA_VFC_DOAController(ApexPages.StandardController DOActrl)
    {
        Grpapprover=false;
        AppLevel = false;
        System.debug('Hello World');
        System.debug('Param value is::'+ApexPages.currentPage().getParameters().get('Id'));
        string url = ApexPages.currentPage().getURL();
        if(ApexPages.currentPage().getParameters().get('Id')!=null&& !url.contains('retURL'))       
        {  
            System.debug('You opened in detail mode');
            IsEditMode=false;
           
        }
        else
        {
            System.debug('You opened in EDIT mode');
            IsEditMode=true;
        } 
         Id DOARec = ApexPages.currentPage().getParameters().get('Id');
        if(DOARec!=null)
        {
            
        DOAObj = (RFA_DOA__c)DOActrl.getRecord();  
        DOAObj = [Select Primary_DOA_Category__c ,DOA_Control_Level__c,Approver_Level__c,Amount_Upper_limit__c,Amount_Lower_limit__c,Comments__c,Approver_Group__c,Approver_Type__c,CreatedById,CreatedDate,LastModifiedById,LastModifiedDate from RFA_DOA__c  where id=:DOARec];
            
            selectedDOACategory = DOAObj.Primary_DOA_Category__c;            
            selectedDOAControlLevel = DOAObj.DOA_Control_Level__c;
            AmountUpperLimit = DOAObj.Amount_Upper_limit__c;
                AmountLowerLimit = DOAObj.Amount_Lower_limit__c;
                Comments = DOAObj.Comments__c;
                selectedApproverLevel = DOAObj.Approver_Level__c;
                selectedApprovergroup = DOAObj.Approver_Group__c;
                selectedapproverType = DOAObj.Approver_Type__c;
        }      
        //Populating DOA Category values
        Schema.DescribeFieldResult DOACategories = RFA_DOA__c.Primary_DOA_Category__c.getDescribe();
        DOACategory = new list<SelectOption>();
        DOACategory.add(new SelectOption('--Select--','--Select--'));
        for (Schema.PicklistEntry picklistEntry : DOACategories.getPicklistValues())
        {
                DOACategory.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        } 
         
        //Populating DOA_Control_Level__c values
        /*Schema.DescribeFieldResult DOAControlLevels = RFA_DOA__c.DOA_Control_Level__c.getDescribe();
        DOAControlLevel = new list<SelectOption>();
        DOAControlLevel.add(new SelectOption('--Select--','--Select--'));
        for (Schema.PicklistEntry DOAControlLevelpicklist : DOAControlLevels.getPicklistValues())
        {
                DOAControlLevel.add(new SelectOption(DOAControlLevelpicklist.getValue(),DOAControlLevelpicklist.getLabel()));
        } */
        DOAControlLevel = RFA_VFC_CoordinatorLevelHelper.getAvailableControlLevels();
        System.debug('Levels that can be accessed '+DOAControlLevel);
         
        //Populating Approver Level values
         ApproverLevel= new List<SelectOption>();
        if(selectedApproverLevel!=null)
        {
         	ApproverLevel.add(new SelectOption('--Select--','--Select--'));
         	ApproverLevel.add(new SelectOption(selectedApproverLevel,selectedApproverLevel));
        }
         
         //Populating Approver Group values
         Approvergroup= new List<SelectOption>();
        if(selectedApprovergroup!=null)
        {
            Approvergroup.add(new SelectOption('--Select--','--Select--'));
         	Approvergroup.add(new SelectOption(selectedApprovergroup,selectedApprovergroup));
        }
         
            
        //Populating Approver Type values
        Schema.DescribeFieldResult ApproverTypes = RFA_DOA__c.Approver_Type__c.getDescribe();
        approverType = new list<SelectOption>();
        approverType.add(new SelectOption('--Select--','--Select--'));
        for (Schema.PicklistEntry ApproverTypepicklist : ApproverTypes.getPicklistValues())
        {
                approverType.add(new SelectOption(ApproverTypepicklist.getValue(),ApproverTypepicklist.getLabel()));
        }  
    } 
    // This poupulates the Approver levels based on the selected control level
    public void getApproverLevels()
    {
        AppLevel= true;
        Map<String,List<String>> availableLevels = new Map<String,List<String>>();
        availableLevels.put('KEYOP', new  List <String> {'KEYOP'});
        availableLevels.put('BU', new  List <String> {'KEYOP','BU'});
        availableLevels.put('GROUP', new  List <String> {'KEYOP','BU','GROUP'});
        availableLevels.put('CORP', new  List <String> {'KEYOP','BU','GROUP','CORP','EXEC','Sr. EXEC'}); 
        System.debug('Map is: '+availableLevels);
        System.debug('selectedDOAControlLevel is'+selectedDOAControlLevel);
        System.debug('Levels set'+availableLevels.get(selectedDOAControlLevel));
        List<String> levels=availableLevels.get(selectedDOAControlLevel);
        ApproverLevel = new List<SelectOption>();
        ApproverLevel.add(new SelectOption('--Select--','--Select--'));
        for(String eachLevel: levels )
        {
            ApproverLevel.add(new SelectOption(eachLevel,eachLevel));
        }
    }
    //This fetches the Approver groups based on the selected "Level"
    public Void getApprovergroup()
    {
        System.debug('Hello..1');
        Grpapprover=true;
            
        Approvergroup =  new list<SelectOption>();
        List<Approver_Group__c> Groups=[select id,Approver_GroupName__c from Approver_Group__c where Level__c='Group'];
        for(Approver_Group__c eachGrp:Groups)
        {
            Approvergroup.add(new SelectOption(eachGrp.Approver_GroupName__c,eachGrp.Approver_GroupName__c));
        } 
        System.debug('Value of Approvergroup'+Approvergroup);
      //  return Approvergroup;
    }
    Public PageReference EditDOA()
    {
        System.debug('You clicked EDIT');
        IsEditMode=true;
        return null;
    }
    Public PageReference DeleteDOA()
    {
        IsEditMode=false;
        delete DOAObj;
        return new PageReference('/a1n/o');
    }
    
    Public PageReference SaveDOA()
    {
        try{
        if(selectedApprovergroup=='--Select--' && Approvergroup.size()>1)
        {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Approver Group'));
        }  
        else
        {
        DOAObj.Primary_DOA_Category__c=selectedDOACategory;
        DOAObj.DOA_Control_Level__c=selectedDOAControlLevel;
        DOAObj.Amount_Upper_limit__c=AmountUpperLimit;
        DOAObj.Amount_Lower_limit__c=AmountLowerLimit;
        DOAObj.Comments__c=Comments;
        DOAObj.Approver_Level__c=selectedApproverLevel;
        if(selectedApprovergroup=='--Select--')
        {
            selectedApprovergroup=null;
        }         
       DOAObj.Approver_Group__c=selectedApprovergroup;
        DOAObj.Approver_Type__c=selectedapproverType;
        System.debug('Primary_DOA_Category__c'+selectedDOACategory);
        system.debug('DOA_Control_Level__c'+selectedDOAControlLevel);
        system.debug('AmountUpperLimit'+AmountUpperLimit);
        system.debug('AmountLowerLimit'+AmountLowerLimit);
        system.debug('Comments'+Comments);
        system.debug('selectedApproverLevel'+selectedApproverLevel);
        system.debug('selectedApprovergroup'+selectedApprovergroup);
        system.debug('selectedapproverType'+selectedapproverType);
        
        upsert DOAObj;
        DOAObj  = [select CreatedById,CreatedDate,LastModifiedById,LastModifiedDate from RFA_DOA__c where id=:DOAObj.id];
        IsEditMode=false;
    	}
        }
        catch(System.DmlException  e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getDMLMessage(0)));        
        }
        return null;
    }
    Public PageReference CancelDOA()
    {
        IsEditMode=false;
        
        return null;
    }
    
    Public void getApproverGroups()
    {
        System.debug('Hello Value --->');
        Grpapprover=true;
       Approvergroup =  new list<SelectOption>();
        List<Approver_Group__c> Groups=[select id,Approver_GroupName__c from Approver_Group__c where Level__c=:selectedApproverLevel];
        System.debug('selectedApproverLevel is '+selectedApproverLevel);
        System.debug('Groups'+Groups);
        Approvergroup.add(new SelectOption('--Select--','--Select--'));
        for(Approver_Group__c eachGrp:Groups)
        {
            Approvergroup.add(new SelectOption(eachGrp.Approver_GroupName__c,eachGrp.Approver_GroupName__c));
        }
        System.debug('Value of Approvergroup'+Approvergroup); 
    }
    
    
}