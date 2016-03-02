/***********************************************************************
Class Name      : DealDatabaseMonthlyReport
Created By      : Kirti Agarwal
Created Date    : 6th Jan, 2014
Purpose         : Controller for DealDatabaseMonthlyReport page
************************************************************************/
public class DealDatabaseMonthlyReport {

  public list<string> listOfGroup {get;set;}
  public map<string, list<string>> mapOfGroupAndType {get;set;}
  public map<string, List<Deal__c>> mapOfDeal {get;set;}
  public list<Deal__c> listOfClosedProject {get;set;}
  public list<Document> listOfImage {get;set;}
  public date currentDate{get;set;}
  public string currentUrl {get;set;}
  private id recordTypeId {get;set;}

    public DealDatabaseMonthlyReport(){
        currentUrl = '';
        currentDate = Date.Today();
        mapOfDeal =  new map<string, List<Deal__c>>();
        mapOfGroupAndType = new map<string, list<string>>();
    listOfGroup = new list<string>();
    recordTypeId = getRecordTypeId('Transactions', 'Deal__c');
    getListOfOpenDeal();
    getListOfClosedDeal();
    getlistOfImage();
    }

    public void getListOfOpenDeal(){
        List<Deal__c> listOfDeal = [SELECT id, Name,
                                       Type_of_Deal__c,
                                       Estimated_USD__c,
                                       Deal_Description_Objectives__c,
                                       Project_Manager__c,
                                       Deal_Status__c,
                                       Close_Date__c,
                                       Group__c,
                                       Open_Date__c,
                                       Current_Status__c
                                FROM Deal__c
                                WHERE Group__c != null
                                AND  Type_of_Deal__c != null
                                AND RecordTypeId =: recordTypeId
                                AND Deal_Status__c = 'Active' Order by Name];
        if(listOfDeal.size() > 0){
      set<string> setOfGroup = new set<string>();
      for(Deal__c deal : listOfDeal) {
        string key = deal.Group__c + deal.Type_of_Deal__c;
        if(!mapOfDeal.containsKey(key)){
          mapOfDeal.put(key, new List<Deal__c>{deal});
        }
        else{
          list<Deal__c> listOfRecords = mapOfDeal.get(key);
          listOfRecords.add(deal);
        }

        if(!setOfGroup.contains(deal.Group__c)) {
          listOfGroup.add(deal.Group__c);
          setOfGroup.add(deal.Group__c);
        }

        if(mapOfGroupAndType.containsKey(deal.Group__c)){
          list<string> listOfType = mapOfGroupAndType.get(deal.Group__c);
          set<string> setOfDeal = new set<string>();
          setOfDeal.addAll(listOfType);
          if(!setOfDeal.contains(deal.Type_of_Deal__c)){
            setOfDeal.add(deal.Type_of_Deal__c);
            listOfType.add(deal.Type_of_Deal__c);
            listOfType.sort();
          }
        }else{
          mapOfGroupAndType.put(deal.Group__c,new list<string>{deal.Type_of_Deal__c});
        }
      }
    }
    listOfGroup.sort();
    }

    public void getListOfClosedDeal(){
            listOfClosedProject = [SELECT id, Name,
                                       Type_of_Deal__c,
                                       Estimated_USD__c,
                                       Deal_Description_Objectives__c,
                                       Project_Manager__c,
                                       Deal_Status__c,
                                       Close_Date__c,
                                       Group__c,
                                       Current_Status__c
                                FROM Deal__c
                                WHERE Close_Date__c = THIS_YEAR
                                AND Deal_Status__c = 'Closed'
                                AND RecordTypeId =: recordTypeId
                                Order by Name];
    }

    public void getlistOfImage() {
     listOfImage = [SELECT id
                 FROM Document
                 WHERE DeveloperName = 'Monthly_Report_Table'
                 OR  DeveloperName = 'Monthly_Report_Header'
                 order BY DeveloperName];
   currentURL = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
    }

      /**
    * This method is used to create the recordtype id
    */
    public static Id getRecordTypeId(String recordType, String objectType) {
        Map<String,Schema.RecordTypeInfo> rtMapByName = null;
        if(rtMapByName == null) {
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
      Schema.SObjectType ctype = gd.get(objectType);
        Schema.DescribeSObjectResult d1 = ctype.getDescribe();
        rtMapByName = d1.getRecordTypeInfosByName();
      }
      Schema.RecordTypeInfo recordTypeDetail = rtMapByName.get(recordType);
      if(recordTypeDetail != null) {
        return recordTypeDetail.getRecordTypeId();
      } else {
        return null;
      }
    }

}