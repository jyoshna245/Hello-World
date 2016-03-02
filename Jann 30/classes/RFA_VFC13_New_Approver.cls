/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC13_New_Approver
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 28/5/2013 
 *  Assumptions      : N/A
 *  Description      : Class to implement the logic on the New Approver Page. 
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
public with sharing class  RFA_VFC13_New_Approver {
    
    public RFAUserRole__c rfaUserObj { get; set; }
    //jyoshna code start
     public RFA__c rfaObj { get; set; }
    //end
    private String oldUsername;
    
    // instantiate new rfa_AP02_ShareUtil
    private RFA_AP02_Shareutil shareUtil=new RFA_AP02_Shareutil();
    
    // Get RecordTypes associated to RFAUser Role
    public static Map<String, RecordType> approverRecordTypeMap = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());

    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP = RFAGlobalConstants.RECORDTYPESMAP;
    public static Map<String, RecordType> rfaRecordTypeMap = RECORDTYPESMAP.get(Schema.sObjectType.RFA__c.getName());
    
   //-- added by mpsacua@coca-cola.com Aug 28,2013 for FR1.33 Level should be taken from Profit Center
    public Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap {get;set;}
    public boolean isPolicy{get;set;}//Added mpascua@coca-cola.com for FR1.5 and FR1.6
    public String strLevel{get;set;}//Added mpascua@coca-cola.com for FR1.5 and FR1.6
    public List<RFA__c> rfaList{get;set;}
    public Id profitCenterId{get;set;}

    public List<SelectOption> getLevel()
    {
        List<SelectOption> options = new List<SelectOption>();
        Set<String> uniqueLevel = new Set<String>();
       
        for(ProfitCenterUserRole__c tempMap: this.profitCenterMap.get(rfaList[0].profitCenterNumber__c) )
        {
            if(!(uniqueLevel.contains(tempMap.Level__c))){
                options.add(new SelectOption(tempMap.Level__c, tempMap.Level__c));
                uniqueLevel.add(tempMap.Level__c);
            }    
        }
        
        options.add(new SelectOption('', '--None--'));
        options.sort();        
        return options; 
    }
  //-----------------
  
  public RFA_VFC13_New_Approver(ApexPages.StandardController controller) {

          //Query the record values in case Edit page is opened
          this.strLevel = '';
          
          ID  id = ApexPages.currentPage().getParameters().get('id');
          if(ID<>NULL)
              rfaUserObj = [Select UserName__c,RecordTypeId,Level__c,RFA__c,DoNotSendEmail__c,Notifyuserfirsttime__c,NotifyUsers__c,ApprovalRecommendation__c,ApprovalComments__c,Agent1__c,Agent2__c,Agent3__c,Name from RFAUserRole__c where Id =:id] ;
          
          else         
          {                           
              rfaUserObj = (RFAUserRole__c)controller.getRecord();
          }
              
          
          oldUsername = rfaUserObj.Username__c;      
               
          //Added by MadsPascua for FR1.5 and FR1.6
          if(rfaUserObj.Level__c != null && rfaUserObj.Level__c != ''){
                strLevel = rfaUserObj.Level__c;
          }
  
          rfaList = [SELECT RecordTypeId,ProfitCenterNumber__c from RFA__c WHERE Id =: rfaUserObj.RFA__c LIMIT 1];

          this.profitCenterMap = new Map<Id, List<ProfitCenterUserRole__c>>();

          this.profitCenterId = rfaList[0].ProfitCenterNumber__c;  
                            
            for(ProfitCenter__c profitCenter: [Select Id, (Select id,UserName__c,Level__c,Usertype__c from Profit_Center_Associated_Users__r where UserType__c='Location Coordinator'),name from ProfitCenter__c where Id =: this.profitCenterId ])
            {
               this.profitCenterMap.put(profitCenter.Id, profitCenter.Profit_Center_Associated_Users__r);        
            }
           //-----------

          /*
          if(rfaList[0].RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST).Id){
              //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'rfa policy : '+rfaUserObj.RFA__c+', record type id : '+rfaList[0].RecordTypeId);
              //ApexPages.addMessage(myMsg);
              isPolicy = true;
          }else{
              //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'rfa : '+rfaUserObj.RFA__c+', record type id : '+rfaList[0].RecordTypeId);              ApexPages.addMessage(myMsg);
              isPolicy = false;
          }*/

          //--------------
          
          
          /* GA 5/20/13 : 2013 Q1 Enhancement FR 1.22
           * The following is logic to handle changing RFA Approver/User object record type but this is now commented out.
           * The reason this code is commented out is because Record Type updating should not be supported per object validation rule RUR_VR09_Lock_RecordType.
           
          String pageRecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
          String rfaUserRecordTypeId = rfaUserObj.RecordTypeId;
          
          if (!rfaUserRecordTypeId.contains(pageRecordTypeId))
          {
                system.debug('enter update record type');
                rfaUserObj.RecordTypeId = (Id)pageRecordTypeId;
          }
           
          system.debug('Page Record Type Id: ' + pageRecordTypeId);
          system.debug('rfaUserRecordTypeId:' + rfaUserRecordTypeId);
          
          */
          
          system.debug('constructor: ' + rfaUserObj);
    }
    
    public PageReference dosave()
    {   //Added mpascua@coca-cola.com Sept 3, 2013 
        if (strLevel == null) {  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Level: You must enter a value'));  
            return null; 
        }//------- 
        
        try
        {
            // to handle if the return (Enter) key is pressed or save is clicked before queryAction can be invoked
            if (oldUsername != rfaUserObj.Username__c)
            {
                queryAgents();
            }
                
            rfaUserObj.Level__c = strLevel;
            upsert rfaUserObj ;
        }
        catch(exception e)
        {
           ApexPages.addMessages(e);
           return null;
        }  

        return new Pagereference('/' + rfaUserObj.get('Id'));
    }
    
    public PageReference doSaveAndNew()
    {
  
       //Added mpascua@coca-cola.com Sept 3, 2013 
        if (strLevel == null) {  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Level: You must enter a value'));  
            return null; 
        }//------- 
    
    
        try{
            if (oldUsername != rfaUserObj.Username__c)
            {
                queryAgents();
            }
            rfaUserObj.Level__c = strLevel;            
            upsert rfaUserObj;
        }
        catch(exception e)
        {
           ApexPages.addMessages(e);
           return null;
        }  

        // string s = '/' + ('' + rfaUserObj.get('Id')).subString(0, 3) + '/e';
        string s = '/setup/ui/recordtypeselect.jsp?ent='+System.Label.RFA_CL145+'&retURL=%2F'+rfaUserObj.id+'&save_new_url=%2Fa0E%2Fe%3FCF'+System.Label.RFA_CL144+'%3DRFA%2523-0007566%26CF'+System.Label.RFA_CL144+'_lkid%3D'+rfaUserObj.rfa__c+'%26scontrolCaching%3D1%26retURL%3D%252F'+rfaUserObj.rfa__c;
        return new Pagereference(s);
    }
    
    public PageReference queryAgents()
    {
        try
        {
            oldUsername = rfaUserObj.Username__c;
            system.debug('QueryAgent() rfaUserObj.Username__c: ' + rfaUserObj.Username__c);
            User usr = [Select RFA_Agent_1__r.Name, RFA_Agent_2__r.Name , RFA_Agent_3__r.Name From User where Id = :rfaUserObj.Username__c];
            rfaUserObj.Agent1__c = usr.RFA_Agent_1__c;
            rfaUserObj.Agent2__c = usr.RFA_Agent_2__c;
            rfaUserObj.Agent3__c = usr.RFA_Agent_3__c;
            system.debug('User Agents 1  ' +usr.RFA_Agent_1__c);
            system.debug('User Agents 2  ' +usr.RFA_Agent_2__c);
            system.debug('User Agents 3  ' +usr.RFA_Agent_3__c);
        }
        catch(exception e)
        {
           ApexPages.addMessages(e);
        }  

        return null;
    }
    
 
    
}