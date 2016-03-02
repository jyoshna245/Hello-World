global with sharing class CRS_CRSReview {
    public final static String CRS_REVIEW_RT_CRS_REVIEW = 'CRS_Review';
    public final static String CRS_REVIEW_RT_GVWCRS_REVIEW = 'gvwCRS_Review';
    
    public final static String CRS_RT_CRS = 'CRS_submission';
    
    public final static String PROCESS_FLOW_FULL_REVIEW_NON_COKE = 'Full Review Non-Coke Branded Product'; //workflow 2
    public final static String PROCESS_FLOW_FULL_REVIEW_COKE = 'Full Review Coke Branded Product';  // work flow 3
    public final static String PROCESS_FLOW_GVW_FULL_REVIEW = 'Full Review (for gvwCRS Only)';  // workflwo 2 & 4
    public final static String PROCESS_FLOW_FULL_REVIEW_NOTIFICATION = 'Full Review & Notification';  // workflow 2
    public final static String PROCESS_FLOW_NOTIFICATION = 'Notification';   // workflow flow 1 
    public final static String PROCESS_FLOW_FULL_REVIEW_PAC_COKE = 'Full Review Coke Branded Product & PAC';  // work flow 5
    public final static String PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC = 'Full Review & Notification & PAC'; // work flow 4
    public final static String PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE = 'Full Review Non-Coke Branded Product & PAC'; // work flow 4
    
    @RemoteAction
    webService static String moveToReview(String crsId){
        if (!CRS_Approval.showReviewButton(crsId)){
            return 'error:CRS cannot be moved to review, because you do not have enough permissions or CRS Status does not allow this operation';
        }
        //++ frr 12, crs enhancement
        List<CRS__c> crsList = [SELECT Id, Active__c, Name, CRS_Review__c, CRS_Business_Unit__c, CRS_Group__c,
            CRS_Country_Names__c, Package_Size__c, CRS_Type_Names__c, CRS_Product_Name__c, CRS_Flavor_Names__c, CRS_Brand__c, 
            CRS_Beverage_Category__c, CRS_Package_Type_Names__c, BBN__c, CRS_Media_Type_Names__c, Total_CRS__c,
            Total_Page_Count__c, Audit_Status__c, CRS_Document_Title__c, Process_Flow__c, Current_Reviewer_s__c FROM CRS__c WHERE Id=:crsId ];

        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            if (crs.Active__c=='No'){
                return 'error:Cannot move to review inactive CRS';
            }
            CRS_Review__c crsReview = null;
            // Create a new one or get existing CRS Review 
            if(crs.CRS_Review__c == null){
                 crsReview = new CRS_Review__c(CRS_Tracking__c=crsId);
                 crsReview.Name=crs.Name + 'rvw';
                 RecordType crsReviewRT;
                 if([select Id, RecordTypeId from CRS__c where Id = :crs.Id].RecordTypeId == [Select Id From RecordType WHERE SobjectType='CRS__c' and DeveloperName = :CRS_RT_CRS][0].Id){
                    crsReviewRT = [Select Id From RecordType r WHERE SobjectType='CRS_Review__c' and DeveloperName = :CRS_REVIEW_RT_CRS_REVIEW];
                 } else {
                    crsReviewRT = [Select Id From RecordType r WHERE SobjectType='CRS_Review__c' and DeveloperName = :CRS_REVIEW_RT_GVWCRS_REVIEW];
                 }
                 if(crsReviewRT != null){
                    crsReview.RecordTypeId = crsReviewRT.Id;
                 }
            } else {
                List<CRS_Review__c> crsReviewList = [SELECT Id from CRS_Review__c WHERE Id=:crs.CRS_Review__c limit 1];
                if(!crsReviewList.isEmpty()){
                    crsReview = crsReviewList[0];
                }
            }
            crsReview.Active__c=crs.Active__c;
            crsReview.Beverage_Category__c=crs.CRS_Beverage_Category__c;
            crsReview.CRS_Brand__c=crs.CRS_Brand__c;
            crsReview.CRS_Business_Unit__c=crs.CRS_Business_Unit__c;
            crsReview.CRS_Country_Names__c=crs.CRS_Country_Names__c;
            crsReview.CRS_Type_Names__c=crs.CRS_Type_Names__c;
            crsReview.CRS_Flavor_Names__c=crs.CRS_Flavor_Names__c;
            crsReview.CRS_Group__c=crs.CRS_Group__c;
            crsReview.Initiated_By__c=Userinfo.getUserId();
            crsReview.CRS_Media_Type_Names__c=crs.CRS_Media_Type_Names__c;
            crsReview.CRS_Package_Type_Names__c=crs.CRS_Package_Type_Names__c;
            crsReview.CRS_Product_Name__c=crs.CRS_Product_Name__c;
            crsReview.Review_Status__c=CRS_CRSEdit.CRS_Status_UnderReview;
            
            //++ crs enahancement, frr12
            if(crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_NON_COKE || crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_NOTIFICATION){
                crsReview.Current_reviewer_FL__c = true;
                crsReview.Current_reviewer_SRA__c = true;
                crsReview.Current_reviewer_FGD__c =  false;
                crsReview.Current_reviewer_PAC__c =  false;
                crs.Current_Reviewer_s__c = 'FL,SRA';
            }
            
            // for work flow 3
            if(crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_COKE){
                crsReview.Current_reviewer_FL__c = true;
                crsReview.Current_reviewer_SRA__c = true;
                crsReview.Current_reviewer_FGD__c =  true;
                crsReview.Current_reviewer_PAC__c =  false;
                crs.Current_Reviewer_s__c = 'FL,SRA,FGD';
            }
            
            // for work flow 4 
            if(crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC || crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE){
                crsReview.Current_reviewer_FL__c = true;
                crsReview.Current_reviewer_SRA__c = true;
                crsReview.Current_reviewer_PAC__c =  true;
                crsReview.Current_reviewer_FGD__c =  false;
                crs.Current_Reviewer_s__c = 'FL,SRA,PAC';
            }
            
            // work flow 5
            if(crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_PAC_COKE){
                crsReview.Current_reviewer_FL__c = true;
                crsReview.Current_reviewer_SRA__c = true;
                crsReview.Current_reviewer_FGD__c =  true;
                crsReview.Current_reviewer_PAC__c =  true;
                crs.Current_Reviewer_s__c = 'FL,SRA,FGD,PAC';
            }
            
            // for gvw workflow
            if(crs.Process_Flow__c == PROCESS_FLOW_GVW_FULL_REVIEW){
                crsReview.Current_reviewer_FL__c = true;
                crsReview.Current_reviewer_SRA__c = true;
                crsReview.Current_reviewer_FGD__c =  false;
                crsReview.Current_reviewer_PAC__c =  false;
                crs.Current_Reviewer_s__c = 'FL,SRA';
            }
            
            //--
            
            
            crsReview = CRS_AdminActions.updateCRSReview(crsReview);
            // for workflow 2
            
            
            
            string CRSReviewers;
            
            crs.CRS_Review__c = crsReview.Id;
            crs.Status__c = CRS_CRSEdit.CRS_Status_UnderReview;
            crs.UnderReviewApprovalValidationCheck__c = false;
            CRS_AdminActions.updateCRS(crs);
            return crsReview.Id;
        }
        return '';
    }

    @RemoteAction
    webService static String reviewComplete(String crsReviewId){
        List<CRS_Review__c> reviewList =[SELECT Id, CRS_Tracking__c, Review_Status__c from CRS_Review__c WHERE Id=:crsReviewId];
        System.debug('~~~reviewList: '+reviewList);
        if (reviewList.size()!=0){
            CRS_Review__c review = reviewList.get(0);
            if (review.Review_Status__c=='Review Completed'){
                return 'error:Review was already completed.';
            }
            review.Review_Status__c = 'Review Completed';
            review = CRS_AdminActions.updateCRSReview(review);

            if (review.CRS_Tracking__c != null){
                CRS__c crs = [SELECT Id, Status__c FROM CRS__c WHERE Id=:review.CRS_Tracking__c];
                crs.Status__c=CRS_CRSEdit.CRS_Status_InProcess;
                CRS_AdminActions.updateCRS(crs);
                
                return review.CRS_Tracking__c;
            } else {
                return 'reload:';
            }           
        }
        return 'error:';
    }
}