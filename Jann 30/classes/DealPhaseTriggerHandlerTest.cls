/***********************************************************************
Trigger Name  : DealPhaseTriggerHandlerTest
Created By   	: Kirti Agarwal
Created Date 	: 27th Nov,2013
Purpose      	: Test class for DealPhaseTriggerHandler
Task         	: T-215444
************************************************************************/
@isTest
private class DealPhaseTriggerHandlerTest {

    static testMethod void DealPhaseTriggerHandlerTest() {
       
       Deal_Phases__c rec = new Deal_Phases__c();
    	 rec.Attachment__c = 'Target Strategic Analysis';
    	 rec.Name = 'Target Strategic Analysis';
    	 rec.Deal_Field__c = 'Target_Strategic_Analysis__c';
    	 rec.Is_Need_To_Set_Deal_Field__c = true;
    	 insert rec;
    	 
    	 Deal__c deal = new Deal__c();
	     deal.Current_Status__c = 'test 1';
	     deal.Target__c = 'test';
	     deal.Close_Date__c = date.today().addDays(2);
	     deal.Current_Status_Date__c = date.today().addDays(1);
    	 insert deal;
    	 
    	 Deal_Phase__c dealPhase = new Deal_Phase__c();
    	 dealPhase.Deal__c = deal.id;
    	 dealPhase.Required_Attachments__c = 'Target Strategic Analysis';
    	 insert dealPhase;
    	 
    	 Deal__c dealRec = [SELECT id,Target_Strategic_Analysis__c 
    	 										FROM Deal__c 
    	 										WHERE id =: deal.id];
    											
    	 system.assertEquals(dealRec.Target_Strategic_Analysis__c, true);
    	 
    	 dealPhase.Required_Attachments__c = null;
    	 update dealPhase;
    	 
    	 dealRec = [SELECT id,Target_Strategic_Analysis__c 
 										FROM Deal__c 
 										WHERE id =: deal.id];
    											
    	 system.assertEquals(dealRec.Target_Strategic_Analysis__c, false);
    	 
    	  rec.Is_Need_To_Set_Deal_Field__c = false;
    	  update rec;
    	  
    	  dealPhase.Required_Attachments__c = 'Target Strategic Analysis';
    	  update dealPhase;
    	  system.assertEquals(dealRec.Target_Strategic_Analysis__c, false);
    }
    
   
}