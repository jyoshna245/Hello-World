global class CRS_CRSCustomButtons {
public Crs__c crs{get;set;}
 public ID crsId{get;set;}
 public String reviewId{get;set;}
  private static Boolean isCRSBA{get;set;}
  private static Boolean isCRSSA {get;set;}
 public CRS_CRSCustomButtons (ApexPages.StandardController controller) {
     crsId=controller.getRecord().Id;
     Crs__c crs1=[select CRS_Review__c from Crs__c where Id=:crsId];
     if(crs1.CRS_Review__c !=null){
     CRS_Review__c crsReview=[select Id,Name from CRS_Review__c where CRS_Tracking__c=:crsId limit 1];
     if(crsReview!=null){
       reviewId=(crsReview.Id);
     }
    }
}
 
  

 webservice static Boolean Abandon(String crs){
  CRS__c crs1=[select id from Crs__c where id=:crs limit 1];
  String result=CRS_Approval.abandon(crs);
  system.debug('******'+result);
  if(result.indexOf('error') != -1){
    String errMsg = result.substring(6); 
    crs1.adderror('Error: Cannot Abandon CRS.'+ errMsg );
     return false;
  }
  else{
      return true;
  }
   
 }
 
 webservice static Boolean Disapprove(String crs){
 CRS__c crs1=[select id from Crs__c where id=:crs limit 1];
  String result=CRS_Approval.disapprov(crs);
  system.debug('******'+result);
  if(result.indexOf('error') != -1){
    String errMsg = result.substring(6); 
    crs1.adderror('Error: Cannot Disapprove CRS.'+ errMsg );
    return false;
  }
  else{
       return true;
  }
  
 }
 
 webservice static Boolean MoveToReview(String crs){
  CRS__c crs1=[select id from Crs__c where id=:crs limit 1];
  String result=CRS_CRSReview.moveToReview(crs);
  system.debug('******'+result);
  if(result.indexOf('error') != -1){
    String errMsg = result.substring(6); 
    crs1.adderror('Error:'+ errMsg );
    return false;
  }
  else if(result!=''){
    return true;
  }
  else{
       
    crs1.adderror('Internal Server Error');
     return false;  
  }
 }
  
 @RemoteAction
 webservice static Boolean Reactivate(String crs ){
  CRS__c crs1=[select id,CRS_Review__c from Crs__c where id=:crs limit 1];
  if(crs1.CRS_Review__c!=null){
      CRS_Review__c crsReview=[select Id,Name from CRS_Review__c where CRS_Tracking__c=:crs1.Id limit 1];
      if(crsReview!=null){
        delete crsReview;
      }
  }
  String result=CRS_Approval.reactivate(crs);
  system.debug('******'+result);
  if(result.indexOf('error') != -1){
    String errMsg = result.substring(6); 
    crs1.adderror('Error: Cannot Reactivate CRS.'+ errMsg );
    return false;
  }
  else{
    
       return true;
  }
    
 }
 
 webservice static Boolean Obsolete(String crs){
  CRS__c crs1=[select id from Crs__c where id=:crs limit 1];
  String result=CRS_Approval.obsolete(crs);
  system.debug('******'+result);
  if(result.indexOf('error') != -1){
    String errMsg = result.substring(6); 
    crs1.adderror('Error: Cannot Obsolete CRS.'+ errMsg );
    return false;
  }
  else{
    
       return true;
  }
 }
 
 
  @TestVisible 
 private static void checkAdminProfiles(){
        isCRSBA = !([select Id from Profile where Id = :UserInfo.getProfileId() and 
            Name = :CRS_CRSEdit.getBAProfileName()].isEmpty());
        isCRSSA = !([select Id from Profile where Id = :UserInfo.getProfileId() and 
            Name = :CRS_CRSEdit.getSAProfileName()].isEmpty());
    }
 
 public boolean getshowSubmitForApprovalButton()
    {  
       List<Crs__c> crsList=[SELECT Id,Name,Internal_Status2__c, Status__c,OwnerId,Initiated_By__c  from CRS__c WHERE Id =:crsId];
        checkAdminProfiles();
        if(crsList.size()>0 && !crsList.isEmpty()){
           CRS__c crs = crsList.get(0);
            return (isCRSBA || isCRSSA || crs.OwnerId==UserInfo.getUserId() || crs.Initiated_By__c==UserInfo.getUserId()) 
                && crs.Internal_Status2__c=='NotStarted' &&(crs.Status__c==CRS_CRSEdit.CRS_Status_Draft ||crs.Status__c==CRS_CRSEdit.CRS_Status_NewSubmission || crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess);
           
        }
        
        return false;
    }
 public boolean getshowReviewButton()
    {
        
        List<CRS__c> crsList = [SELECT Id, Name, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId ];
        List<CRS_Role__c> crsRole = [Select Id FROM CRS_Role__c WHERE User__r.Id=:UserInfo.getUserId() and (CRS_Corporate_Level__c='Yes' or gvwCRS_Corporate_Level__c='Yes')];
        
        checkAdminProfiles();
        // 'Move to Review' Button is available for corporate users/higher and for 'InProcess' status
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            return (!crsRole.isEmpty() || 
                 isCRSBA || isCRSSA) 
                 && (crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess && crs.Internal_Status__c!=CRS_Approval.APPROVAL_STEP_FIELDSRA );
        }
        // Button is not available if CRS is not found
        return false;
    }
 public boolean getshowAbandonDisapproveButtons()
    {
        List<CRS__c> crsList = [SELECT Id, Name, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId ];
        checkAdminProfiles();
        // 'Abandon' and 'Disapprove' Buttons is available for business/system admins and for 'NewSubmission', 'InProcess' and 'UnderReview' statuses
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            return (isCRSBA || isCRSSA) && 
                (crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess || crs.Status__c==CRS_CRSEdit.CRS_Status_NewSubmission || 
                crs.Status__c==CRS_CRSEdit.CRS_Status_UnderReview);
        }
        // Button is not available if CRS is not found 
        return false;
    }
 public boolean getshowReactivateButtons()  
    {
        List<CRS__c> crsList = [SELECT Id, Name, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId ];
        checkAdminProfiles();
        // 'Reactivate' Buttons is available for business/system admins and for 'Abandoned' status
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            return (isCRSBA || isCRSSA) &&
                (crs.Status__c==CRS_CRSEdit.CRS_Status_Abandoned);
        }
        // Button is not available if CRS is not found   
        return false;
    }
   public boolean getshowObsoleteButtons()  
    {
        List<CRS__c> crsList = [SELECT Id, Name, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId ];
        checkAdminProfiles();
        // 'Obsolete' Buttons is available for business/system admins and for 'Approved'/ conditionallly approved status
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            return (isCRSBA || isCRSSA) &&
                (crs.Status__c==CRS_CRSEdit.CRS_Status_Approved || crs.Status__c == CRS_CRSEdit.CRS_Status_ConditionallyApproved);
        }
        // Button is not available if CRS is not found   
        return false;
    }
}