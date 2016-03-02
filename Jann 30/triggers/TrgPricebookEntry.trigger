trigger TrgPricebookEntry on Product2 (after insert,before insert) 

{

 if(Trigger.isInsert && (Trigger.isAfter || Trigger.isBefore))
 
 {
 
 TrgPricebookEntryHandler.OnInsert(Trigger.new);
 
 }

}