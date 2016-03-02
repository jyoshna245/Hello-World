public class sample
{
/*
    public String selectedRec{get;set;}
    public String selectedCategory{get;set;}
    public String selectedUnit{get;set;}
    public String selectedPC{get;set;}    
    public List<String> pcStringList{get;set;}
    public List<RFA_Approver__c> RFAApprovers{get;set;}
    public List<RFA_COA_Group__c> coaGroups{get;set;}
    public List<SelectOption> BusRecordTypes{get;set;}
    public String[] BusRecTypes{set;get;}
    
    public List<SelectOption> selectedBusRecordTypes{get;set;}
    public sample()
    {
        List<RecordType> results = [Select Id ,DeveloperName  From RecordType  Where SobjectType = 'RFA_Business_Unit__c'];
        
        BusRecordTypes=new List<SelectOption>();
       
        BusRecordTypes.add(new SelectOption('--Select--','--Select--'));
        for(RecordType rt: results)
        {            
            BusRecordTypes.add(new SelectOption(rt.DeveloperName,rt.DeveloperName));            
             
        }
        
        system.debug('selectedRec in const'+selectedRec);
    }
    
    public List<SelectOption> getBusinessUnits()
    {
        system.debug('selectedRec'+selectedRec);
        List<selectoption> BusinessUnits=null;
        //not
        if(selectedRec!=null)
        {
            BusinessUnits= new List<SelectOption>();
            //BusRecTypes[0] = selectedRec;
             //where RecordType.name=:selectedRec
             //system.debug('In if');
            List<RFA_Business_Unit__c> listunits=[select id,name from RFA_Business_Unit__c  where RecordType.name = :selectedRec];
            BusinessUnits.add(new SelectOption('--Select--','--Select--'));
            for(RFA_Business_Unit__c cat: listunits)
            {
                
                BusinessUnits.add(new SelectOption(cat.name,cat.name));
            }
            system.debug('BusinessUnits size'+BusinessUnits.size());
            system.debug('Business unit'+BusinessUnits);
           //  
        }
        
        return BusinessUnits;
    }   
    public list<selectoption> getCategories()
    {
        system.debug('selectedUnit'+selectedUnit);
        List<SelectOption> Categorieslist=null;
        List<RFA_Category__c> categories;
        if(!(selectedRec==null))
        {
            
            Categorieslist = new List<SelectOption>();
            Categorieslist.add(new SelectOption('--Select--','--Select--'));
            categories=[select id,Category__c,RFA_Business_Unit__r.Name,name from RFA_Category__c where RFA_Business_Unit__r.Name=:selectedUnit];
            for(RFA_Category__c cat:categories)
            {                
                Categorieslist.add(new SelectOption(cat.name,cat.name));
            }
        }
        return Categorieslist;
    }    
    public list<selectoption> getProfitcenters()
    {
        system.debug('selectedpc'+selectedPC);
        List<SelectOption>  pclist=null;
        List<ProfitCenter__c> profitcenters;
        if(!(selectedCategory==null))
        {            
            Pclist = new List<SelectOption>();
            pcStringList = new List<String>();
            system.debug('selectedCategory'+selectedCategory);
            Pclist.add(new SelectOption('--Select--','--Select--'));
            profitcenters=[select id,name from ProfitCenter__c where Category__r.name=:selectedCategory];
            for(ProfitCenter__c pc:profitcenters)
            {                
                Pclist.add(new SelectOption(pc.name,pc.name));
                pcStringList.add(pc.name);
            }
        }
        return Pclist;
    } 
    
    public RFA_Approver__c  getApprovers()
    {
        RFA_Approver__c obj=[select id,UserName__c from RFA_Approver__c limit 1];  
        List<ProfitCenterCOAGroupJunctionobject__c> PfCOA= [select id,RFA_COA_Group_Name__r.name,RFA_COA_Group_Name__c,Profit_Center_Number__c,name from ProfitCenterCOAGroupJunctionobject__c where Profit_Center_Number__r.name in :pcStringList];
        system.debug('PfCOA..'+PfCOA);       
        coaGroups=new List<RFA_COA_Group__c>();
        for(ProfitCenterCOAGroupJunctionobject__c pfCOAObj: PfCOA)
        {
            coaGroups.add(pfCOAObj.RFA_COA_Group_Name__r);
        }
        List<RFA_Approver__c> applist=[select id,UserName__c from RFA_Approver__c where RFA_COA_Group__c in :coaGroups];
        obj=applist.get(0);
        return obj;
    }
    
    public PageReference viewApprovers()
    {
        
        List<ProfitCenterCOAGroupJunctionobject__c> PfCOA= [select id,RFA_COA_Group_Name__r.name,RFA_COA_Group_Name__c,Profit_Center_Number__c,name from ProfitCenterCOAGroupJunctionobject__c where Profit_Center_Number__r.name in :pcStringList];
        system.debug('PfCOA..'+PfCOA);       
        coaGroups=new List<RFA_COA_Group__c>();
        for(ProfitCenterCOAGroupJunctionobject__c pfCOAObj: PfCOA)
        {
            coaGroups.add(pfCOAObj.RFA_COA_Group_Name__r);
        }
        List<AggregateResult> ListGroupbyamount =[select count(id),amount__C from RFA_COA_Group__c where id in :coaGroups group by amount__c ];
        for(AggregateResult ar: ListGroupbyamount )
        {
            //String ar=ar.get('');
            system.debug('agregated result: '+ar);
            
        }
        
        
        
        //List<RFA_Approver__c> approversList=[select id from RFA_Approver__c where RFA_COA_Group__r in:coaGroups ];
        
        return null;
    }
  */  
    
}