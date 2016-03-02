/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VC_CloseDraftRFA
 *  Author           : mpascua@coca-cola.com
 *  Version History  : 1.0
 *  Creation         : 08/19/2013
 *  Assumptions      : N/A
 *  Description      : This is a controller class which provide functoinality to close Draft RFAs.
                       Users can add comments when closing draft RFAs in the visualforce page (RFA_VFP_CloseDraftRFA) where this class is used.
                       Visualforce page (pop-up) is attached to button("Close RFA") on RFA page.             
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
 public class RFA_VC_CloseDraftRFA{

    public RFA__c rfaObj {get;set;}
    public List<RFA__c> rfaList {get;set;}
    public String defaultURL {get;set;}
    public String userComment {get;set;}
    public Set<Id> rfaIdSet {get;set;}   
    public boolean hasError{get; private set;}
    
    public RFA_VC_CloseDraftRFA(ApexPages.StandardController controller) {
        
        this.hasError = false;
        this.rfaObj = (RFA__c)controller.getRecord();
        this.userComment = '';
        rfaIdSet = new Set<Id>();
        rfaIdSet.add(this.rfaObj.Id);
        
        this.rfaList = [SELECT Level__c, Name, Stage__c, Id FROM RFA__c WHERE Id IN:rfaIdSet LIMIT 1 ];

        //ApexPages.addMessage(﻿ new ApexPages.Message(ApexPages.Severity.FATAL, 'my error msg')﻿);

        defaultURL = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RFA_VFP11_RFATab?save_new=1&sfdc.override=1';
    
    }
    
    public void closeDraftRFA(){
        /*  
        this.hasError = true;
        String errString = 'Test';
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errString)); 
        */
        
        try{
            this.hasError = false;
            
            if(rfaList.size() > 0){
                //rfaList[0].Level__c = '';
                rfaList[0].Stage__c = 'Draft Closed';
                rfaList[0].LevelStage__c = 'Draft Closed';
                if(userComment!= null && userComment != ''){
                    rfaList[0].Comments__c = '[Draft Close] '+ userComment;
                }
                //rfaList[0].Level__c = 'Draft Closed';
                update rfaList;
          }
            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            this.hasError = true;
        }
    }
    
    public void reopenCloseDraftRFA(){
        /*  
        this.hasError = true;
        String errString = 'Test';
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errString)); 
        */
        
        try{
            this.hasError = false;
            
            if(rfaList.size() > 0){
                //rfaList[0].Level__c = '';
                rfaList[0].Stage__c = 'Draft';
                //rfaList[0].LevelStage__c = 'Draft Closed';
                //rfaList[0].Level__c = 'Draft Closed';
                update rfaList;
            }
            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            this.hasError = true;
        }
    }

    
 }