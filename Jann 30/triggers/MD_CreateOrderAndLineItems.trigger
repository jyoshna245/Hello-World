trigger MD_CreateOrderAndLineItems on Quote (after update) 
{
    if(Trigger.isUpdate && Trigger.isAfter)
    {
    
    MD_CreateOrderAndLineItemsHandler.OnAfterUpdate(Trigger.new);
    
    }
}