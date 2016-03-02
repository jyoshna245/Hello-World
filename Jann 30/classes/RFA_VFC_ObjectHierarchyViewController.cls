/****************************************************************************************************************************************
****************************************************************************************************************************************    
*  Class            : RFA_VFC_ObjectHierarchyViewController
*  Author           : Infosys
*  Version History  : 1.0
*  Creation         : 22/12/2015
*  Description      : This class is to display all the RFA approvers related to the RFA COA group  based on the criteria selected by user. 
****************************************************************************************************************************************
****************************************************************************************************************************************/


public with sharing class RFA_VFC_ObjectHierarchyViewController {
    public String selectedRec{get;set;}
    public String selectedCategory{get;set;}
    public String selectedUnit{get;set;}
    public String selectedPC{get;set;}
    public String selectedDOA{get;set;}
    public String selectedAmount{get;set;}
    public String selectedGroupNames{get;set;}    
    public boolean showuserssection{get;set;}
    public boolean ShowMessage {get;set;}
    public boolean ShowMessageBottom {get;set;}
    public boolean showtable {get;set;}
    public IntermediaterfaAutoAppvr__c IntermObj {get;set;}
    public List<RFA_Approver__c> RFAApprovers{get;set;}
    
    List<String>  pcnames=null;
    public List<SelectOption> BusRecordTypes{get;set;}   
    public List<SelectOption> GroupNames{get;set;}
    
    public Id tobeEdited{get; set;}   
    public Id tobeDeleted{get; set;}
    public Id tobecancelled{get; set;}
    public Integer rowNum{get;set;}
    public integer editvalue {get;set;}
    public integer deletevalue {get;set;}
    public Integer savevalue{get; set;}
    public integer cancelvalue {get;set;}
    public boolean disablebuttons {get;set;}
    List<Id> tobedeletedApproversList;
    
    public List<IntermediaterfaAutoAppvr__c> intermediateObj {get;set;}
    
    private integer counter = 0;
    public integer totalRecords = 0;
    
    
    public RFA_VFC_ObjectHierarchyViewController()
    { 
        showuserssection=false;
        ShowMessage = false;
        showtable=false;  
        disablebuttons = false;
        ShowMessageBottom = false;
        intermediateObj = new List<IntermediaterfaAutoAppvr__c>();
        List<RecordType> results = [Select Id ,DeveloperName  From RecordType  Where SobjectType = 'RFA_Business_Unit__c'];
        
        BusRecordTypes=new List<SelectOption>();
        BusRecordTypes.add(new SelectOption('--Select--','--Select--'));
        if(results != null)
        {
            for(RecordType rt: results)
            {            
                BusRecordTypes.add(new SelectOption(rt.DeveloperName,rt.DeveloperName));            
            }
        }
        
    }
    //This fetches the Business units based on the selected Recordtype "selectedRec"
    public List<SelectOption> getBusinessUnits()
    {
        
        List<selectoption> BusinessUnits=null;
        
        if(selectedRec!=null)
        {
            BusinessUnits= new List<SelectOption>();            
            List<RFA_Business_Unit__c> listunits=[select id,name from RFA_Business_Unit__c  where RecordType.name=:selectedRec];
            BusinessUnits.add(new SelectOption('--Select--','--Select--'));
            if(listunits != null)
            {
                for(RFA_Business_Unit__c cat: listunits)
                {
                    
                    BusinessUnits.add(new SelectOption(cat.name,cat.name));
                }
            }
            
        }
        
        return BusinessUnits;
    }   
    
    //This fetches the ProfitCenters based on the selected Business unit
    public list<selectoption> getProfitcenters()
    {
        
        List<SelectOption>  pclist=null;
        List<ProfitCenter__c> profitcenters;
        if(!(selectedUnit==null))
        {            
            Pclist = new List<SelectOption>();
            pcnames = new List<String>();            
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
    //This fetches the DOA categories from RFACOAGroup object based on the selected Profit center "selectedPc"
    public list<selectoption> getDOACategories()
    {
        
        List<SelectOption> DOAlist = null;
        Set<string> setofDOAcatgs = new Set<string>();
        if(!(selectedPc==null))
        {   
            List<ProfitCenterCOAGroupJunctionobject__c> Pcjuncobj =[select RFA_COA_Group_Name__c,RFA_COA_Group_Name__r.Name  from ProfitCenterCOAGroupJunctionobject__c where Profit_Center_Number__r.name =:selectedPc];
            
            DOAlist= new List<SelectOption>();                         
            DOAlist.add(new SelectOption('--Select--','--Select--'));
            List<RFA_COA_Group__c> DOAfinalCategories=[select Id,DOA_Category__c from RFA_COA_Group__c  ];
            
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
        
        return DOAlist;
    }
    
    //This fetches the Amounts list from RFACOAGroup object based on the selected DOA category "selectedDOA"
    public list<selectoption> getGroupAmounts()
    {
        
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
    //This fetches the list of Approvers from RFA Approver object for appropriate selection
    public PageReference viewApprovers()
    {
        try{
            intermediateObj = new List<IntermediaterfaAutoAppvr__c>();
            //Clears Intermediate Object values with group id "selectedGroupNames"
            List<IntermediaterfaAutoAppvr__c> clearintermObj=[select level__C from IntermediaterfaAutoAppvr__c where GroupId__c=:selectedGroupNames];
            if(clearintermObj!=null&&clearintermObj.size()>0)
                delete  clearintermObj;
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));       
        }
        tobedeletedApproversList=new List<Id>();
        ShowMessageBottom = false;
        
        disablebuttons=false;
        if(selectedRec == '--Select--')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Organization'));            
            showuserssection = false;
            
        }
        else if(selectedUnit == '--Select--' )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Business Unit'));
            counter=0;            
            showuserssection = false;
            
        }
        
        else if(selectedPc == '--Select--' )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Profit Center'));
            counter=0;
            showuserssection = false;
            
        }
        else if(selectedDOA == '--Select--' )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select DOA Category'));
            counter=0;
            showuserssection = false;
            
        } 
        else if(selectedAmount == '--Select--' )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Amount'));
            counter=0;
            showuserssection = false;
            
        } 
        else
        {   
            try{
                List<RFA_COA_Group__c> groupnumbers=[select Id,Name from RFA_COA_Group__c where DOA_Category__c =: selectedDOA and  Amount__c =:Decimal.valueOf(selectedAmount)];
                if(groupnumbers.size() > 0)
                {
                    showuserssection = true;
                    GroupNames = new List<SelectOption>();          
                    selectedGroupNames = groupnumbers[0].Id;
                    List<ID> GroupIds=new List<ID>();
                    for(RFA_COA_Group__c RFACOAgrpobj: groupnumbers)
                    {                        
                        GroupNames.add(new Selectoption(RFACOAgrpobj.Id,RFACOAgrpobj.Name));                
                        GroupIds.add(RFACOAgrpobj.Id);
                    }                     
                    List<RFA_Approver__c> RFAApproversSize = new  List<RFA_Approver__c>();
                    
                    RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Group__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c in :GroupIds order by Level__c desc,UserRole__c ];
                    
                    List<IntermediaterfaAutoAppvr__c> delObj=[select level__C from IntermediaterfaAutoAppvr__c where GroupId__c in :GroupIds];
                    if(delObj!=null){
                        delete  delObj; 
                    }
                    //storing all the approvers in IntermediaterfaAutoAppvr__c object "intermediateObj"
                    if(RFAApprovers!=null)
                    {
                        for(RFA_Approver__c eachUser :RFAApprovers)
                        {
                            IntermediaterfaAutoAppvr__c IntGroupUser = new IntermediaterfaAutoAppvr__c();  
                            IntGroupUser.Approver__c = eachUser.UserName__c; 
                            IntGroupUser.Level__c = eachUser.Level__c;                        
                            IntGroupUser.RoleType__c = eachUser.UserRole__c;                        
                            IntGroupUser.GroupId__c = eachUser.RFA_COA_Group__c;
                            IntGroupUser.Group_Name__c = eachUser.RFA_COA_Group__r.name;
                            IntGroupUser.ExistingOne__c=eachUser.id;
                            IntGroupUser.Group_Number__c=eachUser.RFA_COA_Group__r.Group__c;
                            intermediateObj.add(IntGroupUser);
                        }
                    }
                    if(intermediateObj!=null&&intermediateObj.size()>0)
                    {
                        insert intermediateObj;
                    }
                    
                    intermediateObj= [select RoleType__c,GroupId__c,Group_Name__c, Group_Number__c,Approver__c,Level__c  from IntermediaterfaAutoAppvr__c where GroupId__c=:selectedGroupNames order by Level__c desc,RoleType__c asc limit 5];         	
                    system.debug('In view Approvers totalRecords: ' +totalRecords);
                    totalRecords =[select count()  from IntermediaterfaAutoAppvr__c where GroupId__c=:selectedGroupNames]; 
                    if(intermediateObj.size() ==0)
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
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            } 
        }
        counter =0;
        return null;
    }    
    
    public Pagereference SelectedgroupUsers()
    {       
        Id grpId=Id.valueOf(selectedGroupNames); 
        List<IntermediaterfaAutoAppvr__c> hasApprovers=new List<IntermediaterfaAutoAppvr__c>();
        //intermediateObj = new List<IntermediaterfaAutoAppvr__c>();
        counter =0;
        intermediateObj = [select RoleType__c,GroupId__c,Group_Name__c,Group_Number__c, Approver__c,Level__c  from IntermediaterfaAutoAppvr__c where GroupId__c=:grpId limit 5 offset:counter ];         
         totalRecords =[select count()  from IntermediaterfaAutoAppvr__c where GroupId__c=:selectedGroupNames]; 	
        system.debug('In SelectedgroupUsers totalRecords: ' +totalRecords);
        if(intermediateObj.size() ==0)
        {
            ShowMessage = true;
        }
        else
        {
            ShowMessage = false;
            showtable=true;
            intermediateObj = new List<IntermediaterfaAutoAppvr__c>();
            getPage();
        }
        return null;
    }
    //This is to add a new User when user clicks on Add user button 
    public pagereference AddUsers()
    {  
        try{
            RFA_COA_Group__c groupName=null;
             if(selectedGroupNames!=null)
            {
                groupName= [select Id,Name,Group__c from RFA_COA_Group__c where id=:selectedGroupNames limit 1];
            } 
            IntermediaterfaAutoAppvr__c newRec = new IntermediaterfaAutoAppvr__c();             
            Id grpid = Id.valueOf(selectedGroupNames);
            newRec.GroupId__c =groupName.id;
            newRec.Group_Name__c=groupName.Name ;   
            newRec.Group_Number__c=groupName.Group__c ;         
            insert newRec;            
            totalRecords+=1;            
            IntermediaterfaAutoAppvr__c newRow=[select id,RoleType__c,GroupId__c,Group_Name__c,Group_Number__c, Approver__c,Level__c from IntermediaterfaAutoAppvr__c where id=:newRec.id limit 1];            
            intermediateObj.add(newRow);            
            tobeEdited=newRec.Id;
            disablebuttons=true;
            showtable=true;
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));           
            
        }
        return null;
    }
    
    
    public pagereference EditUsers()
    {
        tobeEdited = ApexPages.currentPage().getParameters().get('EditId');
        if(tobeEdited!=null)
        {
            IntermObj = [select RoleType__c,GroupId__c,Group_Name__c,Group_Number__c, Approver__c,Level__c  from IntermediaterfaAutoAppvr__c where  Id=:tobeEdited ];         
        } 
        disablebuttons = true;
        
        return null;
    }
    
    public pagereference DeleteUsers()
    {
        if(ApexPages.currentPage().getParameters().get('DeleteId')!=null){
            tobeDeleted = ApexPages.currentPage().getParameters().get('DeleteId');
        }
        if(ApexPages.currentPage().getParameters().get('indexid')!=null){
            rowNum =Integer.valueOf(ApexPages.currentPage().getParameters().get('indexid'));
        }
        if(tobeDeleted!=null)
        {
            IntermediaterfaAutoAppvr__c deleterow  = [select Level__c,RoleType__c,Group_Number__c,ApprovalComments__c,RFAId__c,Approver__c,ExistingOne__c from IntermediaterfaAutoAppvr__c where  Id=:tobeDeleted limit 1];                        
            if(deleterow!=null&&deleterow.id!=null)
            {
                tobedeletedApproversList.add(deleterow.ExistingOne__c);                
                delete deleterow;
                intermediateObj.remove(rowNum);                
                totalRecords= totalRecords-1;
                tobeEdited = null;
            }
        }
        disablebuttons=false;
        return null;
    }
    public pagereference SaveUsers()
    {    
        try{
            savevalue=Integer.valueOf(ApexPages.currentPage().getParameters().get('Saverownum'));  
            
            if(intermediateObj[savevalue].Approver__c == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select the UserName.'));
                ShowMessageBottom = true;
            }
            else if( intermediateObj[savevalue].RoleType__c == null )
            { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select the User Type.'));
                ShowMessageBottom = true;
            }
            
            else if(intermediateObj[savevalue].RoleType__c == 'Approver' || intermediateObj[savevalue].RoleType__c == 'Info Copy Only')
            {
                if(intermediateObj[savevalue].Level__c == '--None--' || intermediateObj[savevalue].Level__c == null )
                {
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select the Level.'));
                    tobeEdited = intermediateObj[savevalue].Id;
                    ShowMessageBottom = true;
                }  
                else
                {             
                    update intermediateObj[savevalue];                
                    tobeEdited = null;                
                    getPage();
                    disablebuttons =false; 
                }
            }
            else if(intermediateObj[savevalue].RoleType__c == 'Primary Point of Contact' && intermediateObj[savevalue].Level__c !=null)
            {
                ShowMessageBottom = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Do not Select the Level for Primary Point Of Contact.'));
                tobeEdited = intermediateObj[savevalue].Id;
            }
            else if(intermediateObj[savevalue].RoleType__c == 'Co-Creator' && intermediateObj[savevalue].Level__c !=null)
            {
                ShowMessageBottom = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Do not Select the Level for Co-Creator.'));
                tobeEdited = intermediateObj[savevalue].Id;
            }
            else
            {
                disablebuttons=false;
                update intermediateObj[savevalue];
                getPage();
                tobeEdited = null;  
            } 
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));       
        }
        return null;
    }
    public pagereference Cancelusers()
    {
        cancelvalue = Integer.valueOf(ApexPages.currentPage().getParameters().get('Cancelrownum'));
        IntermObj = [select RoleType__c,GroupId__c,Group_Name__c,Group_Number__c, Approver__c,Level__c  from IntermediaterfaAutoAppvr__c where  Id=:tobeEdited ];         
        intermediateObj[cancelvalue]=IntermObj;        
        
        if(ApexPages.currentPage().getParameters().get('CancelId')!=null){
            tobecancelled = ApexPages.currentPage().getParameters().get('CancelId');
        }
        if(ApexPages.currentPage().getParameters().get('indexid')!=null){
            rowNum =Integer.valueOf(ApexPages.currentPage().getParameters().get('indexid'));
        }
        if(tobecancelled!=null)
        {
            IntermediaterfaAutoAppvr__c deleterow  = [select Level__c,RoleType__c,Group_Number__c,ApprovalComments__c,RFAId__c,Approver__c,ExistingOne__c from IntermediaterfaAutoAppvr__c where  Id=:tobecancelled limit 1];                        
            if(deleterow!=null&&deleterow.id!=null&&deleterow.Approver__c==null)
            {               
                delete deleterow; 
                intermediateObj.remove(rowNum);                
                totalRecords= totalRecords-1; 
            }        
            tobeEdited = null;        
            disablebuttons=false;   
        }
        return null;
    }    
     
    
    public pagereference updateApprovers()
    { 
        List<IntermediaterfaAutoAppvr__c> newApprovers=null;         
        RFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where RFA_COA_Group__c =: selectedGroupNames ]; 
        List<RFA_Approver__c> RFAGroupApprovers=new List<RFA_Approver__c>();
        newApprovers = [select Level__c,Approver__c,RoleType__c,Group_Number__c,GroupId__c,ExistingOne__c  from IntermediaterfaAutoAppvr__c where GroupId__c=:selectedGroupNames and ExistingOne__c = null ];                
        system.debug('New approvers are '+newApprovers);
        List<IntermediaterfaAutoAppvr__c> ExistingApprovers = [select Level__c,Approver__c,RoleType__c,Group_Number__c,GroupId__c,ExistingOne__c from IntermediaterfaAutoAppvr__c where GroupId__c=:selectedGroupNames and ExistingOne__c != null];        
        system.debug('Existing approvers are '+ExistingApprovers);
        
        // If the approvers are added newly by clicking on Add User button 
        try{
            if(newApprovers!=null)       
            {            
                for(IntermediaterfaAutoAppvr__c Obj  : newApprovers)
                {
                    RFA_Approver__c RFAapprvr=new RFA_Approver__c();
                    RFAapprvr.Level__c=Obj.Level__c;                     
                    RFAapprvr.UserRole__c=obj.RoleType__c;
                    RFAapprvr.UserName__c=obj.Approver__c;
                    RFAapprvr.RFA_COA_Group__c= obj.GroupId__c;                
                    //To prevent Blank rows from inserting
                    if(RFAapprvr.UserName__c!=null)                   
                        RFAGroupApprovers.add(RFAapprvr);                 
                }
                if(RFAGroupApprovers!=null&&RFAGroupApprovers.size()>0)
                {
                    insert RFAGroupApprovers;
                }
            }  
            //delete newApprovers;
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        RFAGroupApprovers = new List<RFA_Approver__c>();
        List<Id> Idlist=new List<ID>();
        Map<Id,IntermediaterfaAutoAppvr__c> existingUsersMap= new Map<Id,IntermediaterfaAutoAppvr__c>();
        try{
            // If the approvers are modified  by clicking on Edit button are updated
            if(ExistingApprovers!=null)       
            {  
                for(IntermediaterfaAutoAppvr__c Obj  : ExistingApprovers)
                {
                    Id objId= Id.valueOf(obj.ExistingOne__c);
                    Idlist.add(objId);
                    existingUsersMap.put(objId,obj);
                }
            }
            List<RFA_Approver__c> existingRFAApprovers = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where id in : Idlist ]; 
            IntermediaterfaAutoAppvr__c tobeUpdated=null;
            for(RFA_Approver__c obj : existingRFAApprovers)        
            {
                if(existingUsersMap.containsKey(obj.id))
                {
                    tobeUpdated =existingUsersMap.get(obj.id);
                }
                obj.UserName__c = tobeUpdated.Approver__c;
                obj.Level__c = tobeUpdated.Level__c;      
                obj.UserRole__c = tobeUpdated.RoleType__c;             
            }
            update existingRFAApprovers;
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        try{
            if(tobedeletedApproversList!=null&&tobedeletedApproversList.size()>0)
            {
                List<RFA_Approver__c> existingRFAApproverstobeDeleted = [select UserName__c,UserName__r.Name,Level__c,UserRole__c,RFA_COA_Group__r.Name from RFA_Approver__c where id in : tobedeletedApproversList ]; 
                system.debug('To be deleted Users'+existingRFAApproverstobeDeleted);
                delete existingRFAApproverstobeDeleted;  
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));       
        }
        showtable=true;
        counter=0;
        getPage();
        return null;
    }
    
    public void getPage()
    {
        if(selectedGroupNames!=null)            
            intermediateObj = [select RoleType__c,GroupId__c,Group_Name__c, Group_Number__c,Approver__c,Level__c  from IntermediaterfaAutoAppvr__c where GroupId__c=:selectedGroupNames  order by Level__c desc,RoleType__c asc limit 5 offset:counter ];         
        
    }
    public pagereference previous ()
    { 
        if(counter>=5)
        {
            counter = counter -5;
        }
        else
        {
            counter =0; 
        }
        getPage();
        return null;
    }
    
    public pagereference next ()
    {
        counter = counter +5; 
        getPage(); 
        return null;
    }
    
    public pagereference first ()
    {
        counter = 0;
        getPage();
        return null;
    }
    
    public pagereference last ()
    { 
        Integer reminder = math.mod(totalrecords, 5);
        system.debug('hi reminder'+reminder);
        system.debug('hi totalRecords'+totalRecords);        
        counter = totalRecords - reminder;
        if(reminder==0){
            counter=totalRecords - 5;
            system.debug('hi counter in 594'+counter);
        }
        system.debug('hi counter in 595'+counter);
        getPage();
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
        system.debug('Counter in nxt'+counter);
        system.debug('totalRecords in nxt'+totalRecords);
        if ((counter + 5) >=totalRecords)
        { 
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