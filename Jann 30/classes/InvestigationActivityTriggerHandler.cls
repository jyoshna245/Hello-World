// 
// (c) 2014 Appirio, Inc.
// 
// InvestigationActivityTriggerHandler
// Handler class for InvestigationActivityTrigger
// T-301209
//
// 18 July 2014     Ashish Goyal(JDC)       Original
//
public with sharing class InvestigationActivityTriggerHandler {
	
	/*
	* Method Name: updateInvestigationActivityRecord
	* Description: Updating the Case Short Description of Investigation Activity Record
	* Passing param: List of Investigation_Activity__c
	* Return Type: void
	*/
	public static void updateInvestigationActivityRecord(List<Investigation_Activity__c> newList){
		
		Map<Id, List<Investigation_Activity__c>> caseIdInvestigationActivityListMap = new Map<Id, List<Investigation_Activity__c>>();
		for(Investigation_Activity__c investActObj : newList){
			if(investActObj.Case_Short_Description__c == null || investActObj.Case_Short_Description__c == ''){
				if(!caseIdInvestigationActivityListMap.containsKey(investActObj.Case__c)){					
					caseIdInvestigationActivityListMap.put(investActObj.Case__c, new List<Investigation_Activity__c>());
				}
				caseIdInvestigationActivityListMap.get(investActObj.Case__c).add(investActObj);
			}
		}
		
		if(caseIdInvestigationActivityListMap.size() > 0){
			for(Case caseObj : [SELECT Id, Case_Short_Description__c from Case 
									where Id IN : caseIdInvestigationActivityListMap.keySet()]){
				if(caseIdInvestigationActivityListMap.containsKey(caseObj.Id)){
					for(Investigation_Activity__c investActivityObj : caseIdInvestigationActivityListMap.get(caseObj.Id)){
						investActivityObj.Case_Short_Description__c = caseObj.Case_Short_Description__c;
					}
				}
			}
		}
	}

}