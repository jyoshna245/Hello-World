/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VCC04_CapitalExpComponentContrlSTD
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 05/14/2012
 *  Assumptions      : N/A
 *  Description      : This controller class will contain logic of matrix creation for capital expenditure which is called from RFA_C04_Capital_Expenditure.
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
 


public with sharing class RFA_VCC04_CapitalExpComponentContrlSTD {

    /*~~~~Start of Variable/Getter-Setter Initialization~~~~*/
    
    public list<Capital_Expenditure__c> capitalExpenditureList{get; set;}    // Getter-Setter for sObject existing CapitalExpenditure records
    public List<internalDataWapper> internalDataWapperList{get; set;}   //Getter-Setter for interDataWrapperList 
    public List<dataWrapper> DataWrapperList{get; set;}  //Getter-Setter for DataWrapperList 
    public List<String> allMasters{get;set;}  //Getter-Setter for allMasters- It will store all the masters picklist (AssetCategory)  
    public String selectedVal{get;set;}  //Getter-Setter for selectedVal- Whenever investmentObj will udpate from inline VF page 
    private static Map<Id, String> recordTypeIdsMap =new Map<ID, String>(); // Store recordType id and value  of RFARecordType
    public boolean editVisible{get;set;}  //Boolean variable to store visibility of the page (Edit or Non-Editable)
    public boolean recordTypeFlag{get;set;}  // it will store the recordTypeFlag for SPR & CPR
    public List<Capital_Expenditure__c> capExpUpdateList{get;set;} // Getter-Setter for sObject updated CapitalExpenditure records
    public RFA__c rfa{get; private set;} //Getter-Setter for RFA sObject
    public Id RecordRFAId; // It will store the current RFA Id which will pass from VF page standard controller 
    // Setter called for RecordRFAId and assign a value to RFA Object 
    public void setRecordRFAId (Id recordTypeIdAssign) {
    RecordRFAId= recordTypeIdAssign;
    try{  
        rfa=[Select recordTypeId, id, stage__c from rfa__c where id=:RecordRFAId];  // assigning value to RFA 
    }catch(QueryException e)
    {
        System.debug('No record Found:'+e.getMessage());
    }
  }
   
   // Getter for RecordRFAId variable 
  public String getRecordRFAId() {
    return RecordRFAId;
  } 
   /*~~~~End of Variable/Getter-Setter Initialization~~~~*/ 
     
    /*~~~~Default Constructors~~~~*/   
   public RFA_VCC04_CapitalExpComponentContrlSTD (){}
    
     /* @Method <This method is adding dataWrapper from existing all the capitalExpenditure Records >
       @param 
       @return <String> - This method has no value to return
       @throws exception - <Throwing Query Exception>
    */
     public  String getRFA_Capital_CreationMethod    () {
 
    /*~~~~Start of Variable Initialization~~~~*/
        editVisible=false;
        recordTypeIdsMap = RFA_Util_RecordTypeHelper.getRecordTypeName(Schema.sObjectType.RFA__c.getName()); 
        allMasters=new List<String>();
        Schema.DescribeFieldResult fieldResult = Capital_Expenditure__c.AssetCategory__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<SelectOption> secondHeaderOptionsOrg = new List<SelectOption>();
        internalDataWapperList=new List<internalDataWapper>();
        DataWrapperList=new List<dataWrapper>();
        capitalExpenditureList=new list<Capital_Expenditure__c>();   
        
    /*~~~~End of Variable Initialization~~~~*/
        
        /*~~~~~~~ sObjectDescribe Call starts here for AssetCategory && InvestmentObjective~~~~~~~*/
        for(Schema.PicklistEntry pe : ple)
        {
            system.debug('label :'+pe.getLabel());
             allMasters.add(pe.getLabel());   
        }
        Schema.DescribeFieldResult fieldResultInvestmentObjective = Capital_Expenditure__c.InvestmentObjectiveCategory__c.getDescribe();
        List<Schema.PicklistEntry> pleInvestmentObjective = fieldResultInvestmentObjective.getPicklistValues();
        
        for(Schema.PicklistEntry pe : pleInvestmentObjective)
        {
             system.debug('label :'+pe.getLabel());
             secondHeaderOptionsOrg.add(new SelectOption (pe.getLabel(),pe.getLabel()));   
        }
    
        /*~~~~~~~ sObjectDescribe Call ends here for AssetCategory && InvestmentObjective~~~~~~~*/
        
        String rfaRecordTypeName=recordTypeIdsMap.get(rfa.RecordTypeId);
        try{
            capitalExpenditureList=[Select Amount__c,AmountUSD__c,AssetCategory__c,InvestmentObjectiveCategory__c,RFA__c,RecordTypeId,RecordType.Name from Capital_Expenditure__c where RFA__c=:rfa.ID and RecordType.Name=:rfaRecordTypeName  order by AssetCategory__c,InvestmentObjectiveCategory__c ];
        }catch(QueryException e)
        {
            System.debug('No record found:'+e.getMessage());
        }
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Adding existing data into DataWrapper~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        for(String tempString: allMasters) 
        {  dataWrapper temp=new dataWrapper();
           internalDataWapperList=new List<internalDataWapper>();
            for(Capital_Expenditure__c capList: capitalExpenditureList)  
            {
                internalDataWapper tempWrapper;     
                
                system.debug('\n Capital Expenditure Record Type Name:--'+capList.RecordType.Name);
                if(tempString==capList.AssetCategory__c && capList.RecordType.Name=='Small Project Request')
                {
                    tempWrapper=new internalDataWapper(capList.AssetCategory__c,capList.InvestmentObjectiveCategory__c,String.valueof(capList.Amount__c),(capList.Amount__c),capList.AmountUSD__c,capList.Id);
                    internalDataWapperList.add(tempWrapper);        
                    recordTypeFlag=true;        
                }
                else if(tempString==capList.AssetCategory__c && capList.RecordType.Name!='Small Project Request')
                {
                    tempWrapper=new internalDataWapper(capList.AssetCategory__c,capList.InvestmentObjectiveCategory__c,String.valueof(capList.Amount__c),(capList.Amount__c),capList.AmountUSD__c,capList.Id,secondHeaderOptionsOrg);
                    internalDataWapperList.add(tempWrapper);
                    if(capList.InvestmentObjectiveCategory__c!=null)
                        selectedVal=capList.InvestmentObjectiveCategory__c;
                    recordTypeFlag=false;
                }
                
                
            }    
            if(internalDataWapperList.size()>0){
            temp.AssetCategory=tempString;
            temp.internalDataWapperRecords=internalDataWapperList;
           
            dataWrapperList.add(temp);
            }
            
        }
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Existing data into DataWrapper ends here~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        
        return null;
    }
    
    /*~~~~~~~~~~~~~~~~~~~~Method for Editing the table starts here~~~~~~~~~~~~~~~~~~~~~~~~~*/
    public pageReference performEdit()
    {
        editVisible=true;
        return new PageReference('/apex/RFA_VFP01_CapitalExpenditure?id='+rfa.Id+'&visible='+editVisible);
        
    }
    /*~~~~~~~~~~~~~~~~~~~~Method for Editing the table ends here~~~~~~~~~~~~~~~~~~~~~~~~~*/
    
    
    /*~~~~~~~~~~~~~~~~~~~~Method for Cancel the table starts here~~~~~~~~~~~~~~~~~~~~~~~~~*/
    public pageReference performCancel()
    {
        editVisible=false;
        return new PageReference('/apex/RFA_VFP01_CapitalExpenditure?id='+rfa.Id+'&visible='+editVisible);
        
    }
    /*~~~~~~~~~~~~~~~~~~~~Method for Editing the table ends here~~~~~~~~~~~~~~~~~~~~~~~~~*/
    
    
    /*~~~~~~~~~~~~~~~~~~~~Method for saving the matrix table into database starts here~~~~~~~~~~~~~~~~~~~~~~~~~*/
    
     public pageReference performSave()
    {
        System.savepoint sp = Database.setSavepoint();
        editVisible=false;
        System.debug('testWrapper::'+dataWrapperList );
        capExpUpdateList=new list<Capital_Expenditure__c>();
          for(dataWrapper dataContain: dataWrapperList )
          {
                for(internalDataWapper tempRecord: dataContain.internalDataWapperRecords)
                {
                        Capital_Expenditure__c capTemp=new Capital_Expenditure__c(id=tempRecord.recordId);
                        try{
                            if(tempRecord.amt!='' && tempRecord.amt!=null)
                            {    
                                /*
                                Requirement #FR1.49
                                Description #To truncate decimal values on the capital request detail page.
                                History     #Modified by ASHWANI KAUSHIK on 19-Apr-2013
                                */
                                //capTemp.Amount__c=Decimal.valueof(tempRecord.amt); - Commented by ASHWANI KAUSHIK on 19-Apr-2013 for FR1.49
                                
                                capTemp.Amount__c = Decimal.valueof(tempRecord.amt).longValue();
                            }   
                            else
                                   capTemp.Amount__c=0;
                            
                        }catch(Exception e)
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the whole number without any commas or special characters'));
                            editVisible=true;
                        }
                        if(recordTypeFlag==false)
                        {
                            capTemp.InvestmentObjectiveCategory__c=selectedVal;
                        }
                            capExpUpdateList.add(capTemp);
                         
                }
          }
        system.debug('Joban---------------------------------'+capExpUpdateList);
        if(capExpUpdateList.size()>0)
        {
        try{
        update capExpUpdateList;
        }catch(Exception ex) 
            {
                editVisible=true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You donot have Read/Write permission for editing.')); 
                Database.rollback(sp);
                
               return null;
            }
            /*Database.Saveresult [] result = RFA_Util_PerformDML.performInsOperation(capExpUpdateList);
            
            for(Database.SaveResult saveResult : result)
            {
                // To -Do : Define code logic for this block if(!result.isSuccess) throw Exception;
            }*/
        }

        return new PageReference('/apex/RFA_VFP01_CapitalExpenditure?id='+rfa.Id+'&visible='+editVisible);
       
        
    }
    /*~~~~~~~~~~~~~~~~~~~~Method for saving the matrix table into database ends here~~~~~~~~~~~~~~~~~~~~~~~~~*/
    
     /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to display the matrix Details . 
        Version          : 1.0 
    */ 
 public class dataWrapper{
        public String AssetCategory{get;set;}
        public List<internalDataWapper> internalDataWapperRecords{get;set;}
        public dataWrapper()
        {
        internalDataWapperRecords=new List<internalDataWapper>();
        }
        
    } 
    /*
        Class Type     : Inner Class
        Date Created  : 06/08/2012
        Description     : This is our wrapper/container Inner class to adding record details for the matrix Details . 
        Version          : 1.0 
    */
    public class internalDataWapper{
        public String assetCategory{get;set;} //storing assetCategory
        public String secondHeader{get;Set;}  //SecondHeader field store the investmentObjective data
        public List<SelectOption> secondHeaderOptions{get;set;} // Default investmentObjective describe values
        public String amt{get;set;} // Amount getter setter
        public Decimal amtDisplay{get;set;} // Amount getter setter
        public Decimal amtUSD{get;set;} // AmountUSD getter setter
        public Id recordId {get;set;} // RecordId getter setter
        
        public internalDataWapper(){}  // Default construtor
        
        // Parameter construtor for SPR
        public internalDataWapper(  String AssetCategory,String secondHeader,String amt,Decimal amtDisplay,Decimal amtUSD, Id recordId,List<SelectOption> secondHeaderOptions )
        {
            this.AssetCategory=AssetCategory;
            this.secondHeader=secondHeader;
            this.amt=amt;
            this.amtDisplay=amtDisplay;
            this.amtUSD=amtUSD;
            this.recordId =recordId ;
            this.secondHeaderOptions=secondHeaderOptions;
        }
        // Parameter construtor for CPR
        public internalDataWapper(  String AssetCategory,String secondHeader,String amt,Decimal amtDisplay,Decimal amtUSD, Id recordId )
        {
            this.AssetCategory=AssetCategory;
            this.secondHeader=secondHeader;
            this.amtDisplay=amtDisplay;
            this.amt=amt;
            this.amtUSD=amtUSD;
            this.recordId =recordId ;
           
        }
        
    }
    // Wrapper class ends here
      
}