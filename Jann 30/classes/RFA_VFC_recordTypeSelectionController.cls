public class RFA_VFC_recordTypeSelectionController 
{     
    
    public string selectedrecrdtype {get;set;}
    private RFA__c rfaobj;
    public boolean section {get;set;}
    
    Public RFA_VFC_recordTypeSelectionController(ApexPages.StandardController ctrl)
    {
        section = false;
        //this.rfaobj = (RFA__C)ctrl.getRecord();
        
    }
public list<SelectOption> getRecordTypes()
{
    list<SelectOption> options = new list<SelectOption>();

    for(RecordType sRecordType : [SELECT Id, Name FROM RecordType WHERE sObjectType = 'RFA__c'])
    {
        // Select options are added with key,value pairing
        options.add(new SelectOption(sRecordType.Name, sRecordType.Name));
    }
    return options;
}
    
    public pagereference OpenRFAVFP()
    {
        if(selectedrecrdtype=='General Request')
        {
           section = true; 
        }
        else
        {
            section = false; 
        }
        system.debug('RecordType is:' +selectedrecrdtype);
        system.debug('Section is:' +section);
        Pagereference pr = new Pagereference('/apex/CustomizingFieldsetsVFPage');        
        return pr;
    }

}