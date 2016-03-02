public with sharing class CRS_DaysInProcAfterBUAppr {
 //++CRS enhancement
    //count Days In Process After BU Approval
    public static void recountDaysInProcessAfterBUApproval(){
        String inProcessStatus = CRS_CRSEdit.CRS_Status_InProcess;
        List<CRS__c> lstCRS = [select Id, CreatedDate, Days_In_Process_After_BU_Approval__c , Status__c ,CRS_Prior_Status__c from CRS__c 
            where Status__c =:inProcessStatus];
            
            system.debug('1111'+lstCRS);
            for(CRS__c crs : lstCRS){
                if(!crs.CreatedDate.isSameDay(datetime.now()) && crs.CRS_Prior_Status__c != null ){
                
                if(crs.Status__c.equals('In Process') && crs.CRS_Prior_Status__c.equals('Under Review')){
                  if(crs.Days_In_Process_After_BU_Approval__c != null){
                  crs.Days_In_Process_After_BU_Approval__c++;
                  }else{
                  crs.Days_In_Process_After_BU_Approval__c =1;
                  }  
                }
              }
            }
          update lstCRS;
    }
     //++CRS enhancement
     //count Total Days Since Initiated
    public static void recountTotalDaysSinceInitiated(){
        
        List<CRS__c> lstCRSTotalDays = [select Id, CreatedDate, Total_Days_Since_Initiated__c , Status__c from CRS__c where Status__c != 'Approved' and Status__c != 'Rejected' and Status__c != 'Conditionally Approved' and Status__c != 'Abandoned' and Status__c != 'Disapproved' and Status__c != 'Approved-Obsolete'];

            for(CRS__c crs : lstCRSTotalDays){

                      if(crs.Total_Days_Since_Initiated__c!= null){
                      crs.Total_Days_Since_Initiated__c ++;
                      }else{
                      crs.Total_Days_Since_Initiated__c =1;
                      }  

              }
            
          update lstCRSTotalDays ;

    }
    
}