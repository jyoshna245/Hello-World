/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC_EditPopupforApprvrsControler
 *  Author           : infosys
 *  Version History  : 1.0
 *  Creation         : 11/18/2015
 *  Assumptions      : N/A
 *  Description      : Controller Class for restricts the RFA users to edit the approvers when RFA is in Circulation Stage
                       
 * Change History    : --NA--
 
 * Author            : jyoshna_g@infosys.com
 * Date of Change    : Nov 18, 2015
                                             
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

public with sharing class RFA_VFC_EditPopupforApprvrsControler 
{
    public RFAUserrole__c rfauseroleobj{get;set;} 
    public RFAUserrole__c rfaobj {get;set;}
    public RFA__c stage {get;set;}
    public string usertype {get;set;}
    public string ProfileName {get;set;}
    public boolean userexistinPC {get;set;}
    //Controller gets the RFA current stage and user profile information
    public RFA_VFC_EditPopupforApprvrsControler(ApexPages.StandardController ctlr)
    {
       userexistinPC  = false;
        try
        {
            Id userId = userinfo.getUserId();
            Id profileId=userinfo.getProfileId();
            ProfileName=[Select Id,Name from Profile where Id=:profileId].Name;        
            rfaobj = new RFAUserrole__c();
            rfauseroleobj= (RFAUserrole__c)ctlr.getRecord();              
            rfaobj = [select RFA__c,RecordtypeId from RFAUserRole__c where id=: rfauseroleobj.Id];        
            usertype = [select Name from Recordtype where SobjectType='RFAUserRole__c' and ID =: rfaobj.RecordtypeId].Name;        
            stage = [select stage__c from RFA__c where ID =: rfaobj.RFA__c ];
            ID profitcenter =[select ProfitCenterNumber__c from RFA__c where ID =: rfaobj.RFA__c].ProfitCenterNumber__c ;
            List<ProfitCenterUserRole__c> pcusrobj = [select UserName__c from ProfitCenterUserRole__c where UserName__c =:userId and ProfitCenter__c =:profitcenter]; 
            if(pcusrobj !=null)
            {
              //userexistinPC  = true;
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
             
        
    }
}