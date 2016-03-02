trigger ITPR_DuplicateDelegationValidation on ITPRDelegation__c (before insert,before update) {

public set<Id> st = new Set<Id>();
public string x = UserInfo.GetUserId();



if(trigger.isInsert)
{
for(ITPRDelegation__c it:Trigger.new)
{
st.add(x);
if(it.Start_Date__c <=Date.Today() || it.End_Date__c <= Date.Today())
{
it.addError('The Start date and End Date should be Greater than today');
}

}

Map<Id,ITPRDelegation__c> mp = new Map<Id,ITPRDelegation__c>([Select CreatedById,Start_Date__c,End_Date__c,Reset__c 
from ITPRDelegation__c where End_Date__c >= Today and Reset__c != True and CreatedById =: UserInfo.getUserId()]);

for(ITPRDelegation__c itp:Trigger.new)
{
if(mp.size() >0)
{
itp.addError('There is already an Active rule in the future. Please select different date or deactivate the future Rule');
}
}

List<ITPRDelegation__c> mp1 = new List<ITPRDelegation__c>([Select CreatedById,Start_Date__c,End_Date__c,Reset__c 
from ITPRDelegation__c where End_Date__c >= Today and Reset__c != True ]);

for(ITPRDelegation__c itp:Trigger.new)
{
for(ITPRDelegation__c itp1:mp1)
{
if(itp.delegate_to__c == itp1.CreatedById)
{
if(((itp.Start_date__c >= itp1.Start_date__c)&&(itp.Start_date__c <= itp1.End_date__c))||((itp.End_date__c >= itp1.Start_date__c)&&(itp.End_date__c <= itp1.End_date__c)) || ((itp.Start_Date__c <= itp1.Start_Date__c) && (itp.End_Date__c >= itp1.End_Date__c)))
{
itp.addError('The Delegated person is on Leave in the timeperiod you selected. Please select a different User');
}
}

}
}
    //validation for circular delegation
   /* Map<Id,ITPRDelegation__c> mapDelegates = new Map<Id,ITPRDelegation__c>([Select CreatedById,Start_Date__c,End_Date__c,Reset__c 
                                                                  from ITPRDelegation__c where End_Date__c >= Today and 
                                                                  Reset__c != True]);
     Boolean displayOverlapError = false; 
     Boolean displayEndDateOutOfRangeError = false;
     Boolean displayStartDateOutOFRangeError = false;                                                          
    for(ITPRDelegation__c itp:Trigger.new)
    {
        if(mapDelegates != null && mapDelegates.size() > 0){
            for(ITPRDelegation__c delegationObject : mapDelegates.values())
            {
                 //9 to 11
                // 11 to 12
                /*if(itp.Delegate_To__c == delegationObject.CreatedById){
                    if(itp.Start_Date__c >= delegationObject.Start_Date__c && itp.End_Date__c <= delegationObject.End_Date__c){
                        displayOverlapError = true;
                    }else if(itp.Start_Date__c <= delegationObject.Start_Date__c && itp.End_Date__c <= delegationObject.End_Date__c && itp.End_Date__c >= delegationObject.Start_Date__c){
                        displayOverlapError = true;
                    }else if(itp.Start_Date__c <= delegationObject.End_Date__c && itp.Start_Date__c >= delegationObject.Start_Date__c && itp.End_Date__c >= delegationObject.End_Date__c){
                        displayOverlapError = true;
                    }else if(itp.Start_Date__c <= delegationObject.Start_Date__c && itp.End_Date__c >= delegationObject.End_Date__c){
                        displayOverlapError = true;
                    }
                }
                if(itp.Start_date__c >= delegationObject.Start_date__c && itp.Start_date__c <= delegationObject.End_date__c){
                //displayOverlapError = true;
                itp.addError('The Delegated person is on leave in the time period you selected. Please select a different user');
                }else if(itp.End_date__c >= delegationObject.Start_date__c && itp.End_date__c <= delegationObject.End_date__c){
                 displayOverlapError = true;
                }else if(itp.Start_Date__c <= delegationObject.Start_Date__c && itp.End_Date__c >= delegationObject.End_Date__c){
                        displayOverlapError = true;
                    }
                    else
                    {
                    displayOverlapError = false;
                    }
                
                
            }
            
            
        }
        if(displayOverlapError == true){
        itp.addError('The Delegated person is on leave in the time period you selected. Please select a different user');
    }
    }*/
}
}