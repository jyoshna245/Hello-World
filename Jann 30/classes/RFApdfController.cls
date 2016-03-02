//For REQ 23.2

/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFApdfController
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Created Date     : 22/12/2015 
 *  Description      : This generates the RFA Details as a PDF with the file name as "RFA control # <ControlNumber>"
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/

public with sharing class RFApdfController{

    public RFApdfController(ApexPages.StandardController controller) {

       RFA__c rfaObj=(RFA__c)controller.getRecord();
       String RFAPdfName = 'RFA # ';
       List<RFA__C> rfa= null;
        try{
       rfa=[select  ControlNumber__c from RFA__c where id=:rfaObj.id];
       //The file name is appended with the RFA's control number
       if(rfa!=null)
       {
           rfaObj=rfa.get(0);
           if(rfaObj.ControlNumber__c!=null)
           {
               RFAPdfName =RFAPdfName +rfaObj.ControlNumber__c ;
           }
        }
        RFAPdfName +='.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + RFAPdfName );
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));       
        }
    }

}