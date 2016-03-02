/****************************************************************************************************************************************
****************************************************************************************************************************************    
*  Trigger          : RFA_GroupApprover_trigger
*  Author           : Infosys
*  Version History  : 1.0
*  Creation         : 22/12/2015
*  Description      : Trigger to remove that processes the RFAApprover object once the user is made inactive.

****************************************************************************************************************************************
***/

trigger RFA_GroupApprover_trigger on User (after insert,after update)
{
    RFA_RemoveInactiveApprovers RFAhandler = new RFA_RemoveInactiveApprovers();
    
    if(Trigger.isInsert || Trigger.isUpdate)
    {
        RFAhandler.removeAfterUpdate(Trigger.new);        
    }
    
}