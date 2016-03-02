public with sharing class RFA_VFC_AutoApprover {

 public RFA_GroupApprover__c appvrgrpobj ;
 public boolean viewmode {get;set;}
 public boolean editmode {get;set;}
 public RFA_VFC_AutoApprover (ApexPages.StandardController ctrl)
    {
      system.debug('Id is : '+ApexPages.currentPage().getParameters().get('Id'));
      system.debug('retURL is : '+ApexPages.currentPage().getParameters().get('retURL'));
      system.debug('save new is : '+ApexPages.currentPage().getParameters().get('save_new'));
       if(ApexPages.currentPage().getParameters().get('save_new') != null || (ApexPages.currentPage().getParameters().get('id') == null && ApexPages.currentPage().getParameters().get('retURL') != null))
       {
          viewmode  = false;
          editmode = false;
       }      
      else if( ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('retURL') != null)
       {
         viewmode  = false;
         editmode = true;
         
       }
       else
       {
         editmode = false;
         viewmode  = true;
       }
      
        system.debug('edit mode value is:' +editmode);
     
    }
}