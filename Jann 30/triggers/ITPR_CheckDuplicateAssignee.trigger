trigger ITPR_CheckDuplicateAssignee on Assignment_Routing_Rules__c (before insert,after update) {

set<string> cat = new set<string>();
set<string> org = new set<string>();
set<string> req = new set<string>();

for(Assignment_Routing_Rules__c a: Trigger.new)

{
cat.clear();
org.clear();
req.clear();
cat.add(a.category__c);
org.add(a.Organization__c);
req.add(a.Request_Type__c);

}

Map<Id,Assignment_Routing_Rules__c> mp = new Map<Id,Assignment_Routing_Rules__c>([select Category__c,Request_Type__c ,Organization__c from 
                                         Assignment_Routing_Rules__c where Category__c in:cat and Organization__c in:org and Request_Type__c in:req ]);

if(Trigger.Isinsert)
{
for(Assignment_Routing_Rules__c a: Trigger.new)

{
if(mp.size() > 0)

{
a.addError('There is already an Assignment Rule for your selection');
}
}
}
if(Trigger.IsUpdate)
{
for(Assignment_Routing_Rules__c a: Trigger.new)
{
for(Id ed: mp.KeySet())
{
if(((a.Category__c == mp.get(ed).Category__c) || (a.Request_Type__c == mp.get(ed).Request_Type__c) || 
(a.Organization__c == mp.get(ed).Organization__c)) && mp.size()>1)
{
a.addError('There is already an Assignment Rule for your selection');
}}
}
}
}