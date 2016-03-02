public class RFA_Auto_Approver_Details_controller
{
    public String selectedRec{get;set;}
    public String selectedCategory{get;set;}
    public String selectedUnit{get;set;}
    public String selectedPC{get;set;}
    public String selectedDOA{get;set;}
    public String selectedAmount{get;set;}
    public String selectedGroupNames{get;set;}
    //public integer selectedGroupNum {get;set;}
    public boolean showuserssection{get;set;}
    public boolean ShowMessage {get;set;}
    public boolean showtable {get;set;}
   // public String tobeDeleted {get;set;}
   // public List<String> pcStringList{get;set;}   
    public List<RFA_Approver__c> RFAApprovers{get;set;}
   // public List<RFA_COA_Group__c> coaGroups{get;set;}
     List<String>  pcnames=null;
    public List<SelectOption> BusRecordTypes{get;set;}   
    public List<SelectOption> GroupNames{get;set;}
	//Map<Id,Integer> RFAApproversMap=null;
    public Integer rowNum{get;set;}
    
    private integer counter = 0;
	public integer totalRecords = 0;

    
    public RFA_Auto_Approver_Details_controller()
    { 
        showuserssection=false;
        ShowMessage = false;
        showtable=false;        
        List<RecordType> results = [Select Id ,DeveloperName  From RecordType  Where SobjectType = 'RFA_Business_Unit__c'];
        
        BusRecordTypes=new List<SelectOption>();
        BusRecordTypes.add(new SelectOption('--Select--','--Select--'));
        for(RecordType rt: results)
        {            
            BusRecordTypes.add(new SelectOption(rt.DeveloperName,rt.DeveloperName));            
        }
        system.debug('selectedRec in const'+selectedRec);
        system.debug('RFAApprovers after adding row'+RFAApprovers);
    }
    
    public List<SelectOption> getBusinessUnits()
    {
        system.debug('selectedRec'+selectedRec);
        List<selectoption> BusinessUnits=null;
        //not
        if(selectedRec!=null)
        {
            BusinessUnits= new List<SelectOption>();
             //where RecordType.name=:selectedRec
             //system.debug('In if');
            List<RFA_Business_Unit__c> listunits=[select id,name from RFA_Business_Unit__c  where RecordType.name=:selectedRec];
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
   /* public list<selectoption> getCategories()
    {
        system.debug('selectedUnit'+selectedUnit);
        List<SelectOption> Categorieslist=null;
        List<RFA_Category__c> categories;
        if(selectedUnit!=null)
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
    }    */
    public list<selectoption> getProfitcenters()
    {
        system.debug('selectedBunit'+selectedUnit);
        List<SelectOption>  pclist=null;
        List<ProfitCenter__c> profitcenters;
        if(!(selectedUnit==null))
        {            
             Pclist = new List<SelectOption>();
             pcnames = new List<String>();
            system.debug('selectedCategory'+selectedCategory);
            Pclist.add(new SelectOption('--Select--','--Select--'));
            profitcenters=[select id,name from ProfitCenter__c where RFA_Business_Units__r.name=:selectedUnit];
            if(profitcenters.size() >0)
            {
                for(ProfitCenter__c pc:profitcenters)
                {                
                    Pclist.add(new SelectOption(pc.name,pc.name));
                    pcnames.add(pc.name);
                }
            }
            
        }
        return Pclist;
    }
       
public list<selectoption> getDOACategories()
    {
        system.debug('selected Pc is'+selectedPc); 
        List<SelectOption> DOAlist = null;
        Set<string> setofDOAcatgs = new Set<string>();
        if(!(selectedPc==null))
        {   
            List<ProfitCenterCOAGroupJunctionobject__c> Pcjuncobj =[select RFA_COA_Group_Name__c,RFA_COA_Group_Name__r.Name  from ProfitCenterCOAGroupJunctionobject__c where Profit_Center_Number__r.name =:selectedPc];
            system.debug('PC'+selectedpc);
            system.debug('Junction obj'+Pcjuncobj);
            DOAlist= new List<SelectOption>();                         
            DOAlist.add(new SelectOption('--Select--','--Select--'));
            List<RFA_COA_Group__c> DOAfinalCategories=[select Id,DOA_Category__c from RFA_COA_Group__c  ];
            system.debug('DOAfinalCategories'+DOAfinalCategories);
            
            if(DOAfinalCategories.size() > 0 &&  Pcjuncobj.size() > 0)
            {
                for(ProfitCenterCOAGroupJunctionobject__c PCOAobj:Pcjuncobj)
                {
                    for(RFA_COA_Group__c RCGobj: DOAfinalCategories)
                    {
                        if(PCOAobj.RFA_COA_Group_Name__c == RCGobj.Id )
                        {                        
                            if(RCGobj.DOA_Category__c !=null && !setofDOAcatgs.contains(RCGobj.DOA_Category__c) )
                            {
                              DOAlist.add(new SelectOption(RCGobj.DOA_Category__c,RCGobj.DOA_Category__c));
                              setofDOAcatgs.add(RCGobj.DOA_Category__c); 
                            }
                        }
                    }
                }
            }
            
        }
        system.debug('DOA List is'+DOAlist); 
        return DOAlist;
    }
    public list<selectoption> getGroupAmounts()
    {
        system.debug('selected DOA  is'+selectedDOA);
        List<SelectOption>  Amountlist=null;        
        Set<decimal> setofamnts = new Set<decimal>();
        if(!(selectedDOA==null))
        {  
            Amountlist = new List<SelectOption>();                         
            Amountlist.add(new SelectOption('--Select--','--Select--'));
            List<RFA_COA_Group__c> Amounts=[select Id,Amount__c from RFA_COA_Group__c where DOA_Category__c =: selectedDOA ];
            if(Amounts.size() > 0 )
            {                
                    for(RFA_COA_Group__c RCGobj: Amounts)
                    {                                                
                            if(RCGobj.Amount__c !=null && !setofamnts.contains(RCGobj.Amount__c) )
                            {
                              Amountlist.add(new SelectOption(String.valueOf(RCGobj.Amount__c),String.valueOf(RCGobj.Amount__c)));
                              setofamnts.add(RCGobj.Amount__c); 
                            }
                      }
                    
                }
            }            
        
        return Amountlist;
    }     
 
    public PageReference viewApprovers()
    {
        system.debug('org value is:' +selectedRec);
        if(selectedRec == '--Select--')
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Organization'));
        }
        else if(selectedUnit == '--Select--' )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Business Unit'));
        }
       /* else if(selectedCategory == '--Select--' )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Category'));
        } */

        else if(selectedPc == '--Select--' )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select profit Center'));
        }
         else if(selectedDOA == '--Select--' )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select DOA Category'));
        } 
        else if(selectedAmount == '--Select--' )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Amount'));
        } 
        else
        {        
           
           system.debug('Selected DOA is...'+selectedDOA);            
           List<RFA_COA_Group__c> groupnumbers=[select Id,Name from RFA_COA_Group__c where DOA_Category__c =: selectedDOA and  Amount__c =:Decimal.valueOf(selectedAmount)];
            if(groupnumbers.size() > 0)
            {
                 showuserssection = true;
               // List<ProfitCenterCOAGroupJunctionobject__c> PfCOA = [select id,RFA_COA_Group_Name__c,RFA_COA_Group_Name__r.Name,Profit_Center_Number__c,name  from ProfitCenterCOAGroupJunctionobject__c where Profit_Center_Number__r.name =:selectedPc and RFA_COA_Group_Name__c =: groupnumbers ];           
                GroupNames = new List<SelectOption>();          
                selectedGroupNames = groupnumbers[0].Id;
                //for(ProfitCenterCOAGroupJunctionobject__c pfCOAObj: PfCOA)
                for(RFA_COA_Group__c RFACOAgrpobj: groupnumbers)
                {
                    
                    GroupNames.add(new Selectoption(RFACOAgrpobj.Id,RFACOAgrpobj.Name));                
                    
                }
                List<RFA_Approver__c> RFAApproversSize = new  List<RFA_Approver__c>();
                RFAApproversSize=   [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames order by Level__c desc,UserRole__c];
                if(RFAApproversSize!=null&&RFAApproversSize.size()!=0)
                	totalRecords = RFAApproversSize.size();
                
                RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames order by Level__c desc,UserRole__c limit 5 offset :counter];
                
                system.debug('RFA Approvers Size is :' +RFAApprovers.size());
                 
                 system.debug('Total records:'+totalRecords);   
                if(RFAApprovers.size() ==0)
                {
                    ShowMessage = true;
                }
                else
                {
                   ShowMessage = false;
                   showtable=true;
                }
                        
            }
            else
            {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Group is available for the selected criteria')); 
            }
           
          }
         return null;
    }    
   
    public Pagereference SelectedgroupUsers()
    {       
        system.debug('when action function called selected value is :' +selectedGroupNames);
       RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames];
       
        
        system.debug('RFA Approvers Size is :' +RFAApprovers.size());
        if(RFAApprovers.size() ==0)
        {
            ShowMessage = true;
        }
        else
        {
           ShowMessage = false;
           showtable=true;
        }
        return null;
    }
    public pagereference AddUsers()
    {  
        system.debug('selected group name is:'+selectedGroupNames);
        RFA_Approver__c obj = new RFA_Approver__c();
        obj.Level__c='';
        //obj.RFA_COA_Group__c= RFAApprovers.get(0).RFA_COA_Group__r.Name;
        RFA_COA_Group__c groupName=null;
        if(selectedGroupNames!=null)
        {
            groupName= [select Id,Name from RFA_COA_Group__c where id=:selectedGroupNames limit 1];
        }   
        obj.RFA_COA_Group__c=selectedGroupNames;	
        obj.RFA_COA_Group__r=groupName ;        
        RFAApprovers.add(obj); 	 
        system.debug('obj.RFA_COA_Group__r'+obj.RFA_COA_Group__r);
       
        showtable=true;
        system.debug('RFAApprovers list'+RFAApprovers);
        return null;
    }
    public pagereference Deleterecord()
    {   
        if(apexpages.currentpage().getparameters().get('index')!=null)
       		 rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        System.debug('RFAPprovers list before removing with'+' Row num'+rowNum+' '+RFAApprovers);
         
        RFA_Approver__c deleteRow= RFAApprovers.get(rowNum);
        System.debug('RFAPprovers list after removing'+RFAApprovers);
        if(deleteRow.id!=null)
       		 delete deleteRow;
        
        RFAApprovers.remove(rowNum); 
        
         
       //  RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames order by Level__c desc,UserRole__c limit 5 offset :counter];
      
        
         showtable=true; 
        return null;
    }
	 
    public pagereference updateApprovers()
    {
        system.debug('Update is called:' +RFAApprovers);
        //RFAApprovers.remove();
        upsert RFAApprovers;
        RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames order by Level__c desc,UserRole__c limit 5 offset :counter];
    
        showtable=true;
        counter=0;
        return null;
    }
   
    
    
    public pagereference previous ()
    {
        system.debug('counter in prev'+counter);
    	  if(counter>=5)
        {
          counter = counter -5;
        }
        else
        {
           counter =0; 
        }
         
    	RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames order by Level__c desc,UserRole__c limit 5 offset :counter];
    	return null;
    }
    
    public pagereference next ()
    {
    counter = counter +5;
        system.debug('In next action');
    RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames order by Level__c desc,UserRole__c limit 5 offset :counter];
    system.debug('next approver list'+RFAApprovers);
    
    return null;
    }
    
    public pagereference first ()
    {
    counter = 0;
    RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames order by Level__c desc,UserRole__c limit 5 offset :counter];
    return null;
    }
    
    public pagereference last ()
    {
        system.debug('counter in last is'+counter);
         
        Integer reminder = math.mod(totalrecords, 5);
        counter = totalRecords - reminder;
    //counter = totalRecords - 5;
 	 
    RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames order by Level__c desc,UserRole__c limit 5 offset :counter]; 
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
        system.debug('counter value in nxt'+counter);
        system.debug('Total records value in nxt'+totalRecords);
        
        
        if ((counter + 5) >=totalRecords)
        {
            system.debug('in true');
            return true;
        }
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
    if ((counter + 5) >= totalRecords)
        return true;
    else
        return false;    
    }
 
    
}