public with sharing class CRS_CRSEdit {
    public final static String MULTISELECT_JUNCTION_COUNTRY = 'CRS_Country_to_CRS__c';
    public final static String MULTISELECT_JUNCTION_FLAVOR = 'CRS_Flavor_to_CRS__c';
    public final static String MULTISELECT_JUNCTION_CRSTYPE = 'CRS_Type_to_CRS__c';
    public final static String MULTISELECT_JUNCTION_PACKAGETYPE = 'CRS_PacType_to_CRS__c';
    public final static String MULTISELECT_JUNCTION_MEDIATYPE = 'CRS_MediaType_to_CRS__c';
    
    public final static String MULTISELECT_COUNTRY = 'CRS_Country__c';
    public final static String MULTISELECT_FLAVOR = 'CRS_Flavor__c';
    public final static String MULTISELECT_CRSTYPE = 'CRS_Type__c';
    public final static String MULTISELECT_PACKAGETYPE = 'CRS_Package_Type__c';
    public final static String MULTISELECT_MEDIATYPE = 'CRS_Media_Type__c';
    
    private static Map<String, String> lookupNameFields = new Map<String, String> {
            MULTISELECT_COUNTRY     => 'Country_Name__c',
            MULTISELECT_FLAVOR      => 'Flavor_Name__c',
            MULTISELECT_CRSTYPE     => 'CRS_Type_Name__c',
            MULTISELECT_PACKAGETYPE => 'Package_Type_Name__c',
            MULTISELECT_MEDIATYPE   => 'Media_Type_Name__c'};
    
    private static Set<String> multiKeys = new Set<String>{
            MULTISELECT_JUNCTION_COUNTRY,
            MULTISELECT_JUNCTION_FLAVOR,
            MULTISELECT_JUNCTION_CRSTYPE,
            MULTISELECT_JUNCTION_PACKAGETYPE,
            MULTISELECT_JUNCTION_MEDIATYPE};

    private static Map<String, String> relatedObjects = new Map<String, String> {
            MULTISELECT_JUNCTION_COUNTRY     => MULTISELECT_COUNTRY,
            MULTISELECT_JUNCTION_FLAVOR      => MULTISELECT_FLAVOR,
            MULTISELECT_JUNCTION_CRSTYPE     => MULTISELECT_CRSTYPE,
            MULTISELECT_JUNCTION_PACKAGETYPE => MULTISELECT_PACKAGETYPE,
            MULTISELECT_JUNCTION_MEDIATYPE   => MULTISELECT_MEDIATYPE};

    public Map<String, String> selectedMultipleIds {get; set;}
    private Map<String, List<SObject>> selectedMultipleLinks;

    public final static String BEVERAGE_PRODUCT_NAME_LIVE_POSITIVELY = 'LivePositively-Product';
    public final static String BEVERAGE_PRODUCT_NAME_GENERAL_COMMUNICATIONS = 'GeneralComm-Product';
    
    public final static String FLAVOR_NAME_LIVE_POSITIVELY = 'LivePositively-Flavor';
    public final static String FLAVOR_NAME_GENERAL_COMMUNICATIONS = 'GeneralComm-Flavor';

    public final static String BRAND_NAME_LIVE_POSITIVELY = 'LivePositively-Brand';
    public final static String BRAND_NAME_GENERAL_COMMUNICATIONS = 'GeneralComm-Brand';
    
    public final static String BEVERAGE_CATEGORY_NAME_LIVE_POSITIVELY = 'LivePositively-BeverageCategory';
    public final static String BEVERAGE_CATEGORY_NAME_GENERAL_COMMUNICATIONS = 'GeneralComm-BeverageCategory';
    
    public final static String CRS_TYPE_NAME_LIVE_POSITIVELY = 'LivePositively-CRSType';
    public final static String CRS_TYPE_NAME_GENERAL_COMMUNICATIONS = 'GeneralComm-CRSType';
    
    public final static String PACKAGE_TYPE_NAME_LIVE_POSITIVELY = 'LivePositively-PackageType';
    public final static String PACKAGE_TYPE_NAME_GENERAL_COMMUNICATIONS = 'GeneralComm-PackageType';
    
    public final static String MEDIA_TYPE_NAME_LIVE_POSITIVELY = 'LivePositively-MediaTypes';
    public final static String MEDIA_TYPE_NAME_GENERAL_COMMUNICATIONS = 'GeneralComm-MediaTypes';
    
    public final static String PROCESS_FLOW_FULL_REVIEW_NON_COKE = 'Full Review Non-Coke Branded Product';
    public final static String PROCESS_FLOW_FULL_REVIEW_COKE = 'Full Review Coke Branded Product';
    public final static String PROCESS_FLOW_GVW_FULL_REVIEW = 'Full Review (for gvwCRS Only)';
    public final static String PROCESS_FLOW_FULL_REVIEW_NOTIFICATION = 'Full Review & Notification';
    public final static String PROCESS_FLOW_NOTIFICATION = 'Notification';
    public final static String PROCESS_FLOW_FULL_REVIEW_PAC_COKE = 'Full Review Coke Branded Product & PAC';  //process flow for 5
    public final static String PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC = 'Full Review & Notification & PAC';
    public final static String PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE = 'Full Review Non-Coke Branded Product & PAC';
    
    private final static String REVIEW_TYPE_NOTIFICATION = 'Notification';
    private final static String REVIEW_TYPE_FULL_REVIEW = 'Full Review';
    private final static String REVIEW_TYPE_PAC = 'PAC'; // crs enhancement
    
    public final static String CRS_Status_InProcess = 'In Process';
    public final static String CRS_Status_Draft = 'Draft';
    public final static String CRS_Status_NewSubmission = 'New Submission';
    public final static String CRS_Status_UnderReview = 'Under Review';
    public final static String CRS_Status_Abandoned = 'Abandoned';
    public final static String CRS_Status_Disapproved = 'Disapproved';
    public final static String CRS_Status_Approved = 'Approved';
    public final static String CRS_Status_ConditionallyApproved = 'Conditionally Approved';
    
    private final static String NOT_APPLICABLE = 'N/A';
    
    public final static String CRS_Title = 'CRS Title'; //++CRS Enhancement
    public final static String CRS_Prior_Status = 'Prior Status';//++CRS Enhancement
    public final static String SYSTEM_ADMIN_SETTING_KEY = 'SystemAdminProfileApiName';
    public final static String BUSINESS_ADMIN_SETTING_KEY = 'BusinessAdminProfileApiName';

    public ApexPages.StandardController stdController;
    public String selectedUsersIds {get;set;}
    public String userNames {get;set;}
    public Boolean isCorrectUserToApprove{get;set;} //added by Ranjan to show/hide send corp pac/send fgd fields
    public Boolean isAuthorizedSRA{get;set;}
    public Boolean isAuthorizedFGD{get;set;}
    
    public Boolean isShowConditionalapprover{   //added by Ranjan 14th Oct
       get{
          CRS__c crs = (CRS__c) stdController.getRecord();
          if(crs.id!=null){ //added by Ranjan---to give edit access to PAC user to edit Send to Corp FGD field
                List<CRS__c > ApproverIds=[select CRS_Corp_SRA_Approver__c,CRS_Corp_Formula_Governance__c from CRS__c where id=:crs.id];
                String loggedInUserId=UserInfo.getUserId();
                if(ApproverIds.size()!=0 && !ApproverIds.isEmpty()){
                String ListOfSraApprover=String.valueOf(ApproverIds[0].CRS_Corp_SRA_Approver__c);
                String ListOfFgdApprover=String.valueOf(ApproverIds[0].CRS_Corp_Formula_Governance__c);
                if(ListOfSraApprover !=null && ListOfSraApprover!= ''){
                String [] splittSraApprover=ListOfSraApprover.split(';');
                for(String str:splittSraApprover){
                  if(str.contains(loggedInUserId))
                    isAuthorizedSRA=true;
                 }
                }
                if(ListOfFgdApprover !=null && ListOfFgdApprover != ''){
                String [] splittFgdApprover=ListOfFgdApprover.split(';');
                for(String str:splittFgdApprover){
                  if(str.contains(loggedInUserId))
                    isAuthorizedFGD=true;
                }
               } 
              }
            }
          return ((crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess  && crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPSRA && crs.Internal_Status2__c == 'Wait2' &&(isAuthorizedSRA || isCRSBA || isCRSSA)) 
          || (crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess && crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN && crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_COKE && (isAuthorizedFGD|| isCRSBA || isCRSSA))
          || (crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess && crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN && crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_PAC_COKE && (isAuthorizedFGD|| isCRSBA || isCRSSA)));
          }
    }
    public Boolean isGvw{get;set;}
    public Boolean isLock{get;set;}
    
    public Boolean isShowSendCorpFormGov {
        get {
            CRS__c crs = (CRS__c) stdController.getRecord();
            if(crs.id!=null){ //added by Ranjan---to give edit access to PAC user to edit Send to Corp FGD field
                List<CRS__c > ApproverIds=[select CRS_Corp_SRA_Approver__c from CRS__c where id=:crs.id];
                String loggedInUserId=UserInfo.getUserId();
                if(ApproverIds.size()!=0 && !ApproverIds.isEmpty()){
                String ListOfIds=String.valueOf(ApproverIds);
                if(ListOfIds!=null && ListOfIds!=''){
                String [] splittedIds=ListOfIds.split(';');
                for(String str:splittedIds){
                  if(str.contains(loggedInUserId))
                    isCorrectUserToApprove=true;
                }
                }
                }
            }
            return ((crs.Status__c == CRS_CRSEdit.CRS_Status_InProcess ||(crs.Status__c == CRS_CRSEdit.CRS_Status_UnderReview && isCRSBA )|| (crs.Status__c == CRS_CRSEdit.CRS_Status_UnderReview && isCRSSA))
                    && crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_FIELDSRA
                    && crs.Internal_Status2__c == 'Wait2' && (crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NON_COKE 
                    || crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NOTIFICATION )) //added process flow condition for workflow 3---by Ranjan
                    || (crs.Status__c == CRS_CRSEdit.CRS_Status_InProcess 
                    && crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPPAC 
                    && crs.Internal_Status2__c == 'Wait2' 
                    && (crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE 
                    || crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC));
                    //||(isCRSBA); //added process flow condition for workflow 4---by Ranjan
        }
    }
    
    public Boolean isShowSendCorpPAC {
        get {
            CRS__c crs = (CRS__c) stdController.getRecord();
            if(crs.id!=null){  //added by Ranjan---to give edit access to PAC user to edit Send to Corp PAC field
                List<CRS__c > ApproverIds=[select CRS_Corp_SRA_Approver__c from CRS__c where id=:crs.id];
                String loggedInUserId=UserInfo.getUserId();
                if(ApproverIds.size()!=0 && !ApproverIds.isEmpty()){
                String ListOfIds=String.valueOf(ApproverIds);
                if(ListOfIds!=null && ListOfIds!=''){
                String [] splittedIds=ListOfIds.split(';');
                for(String str:splittedIds){
                  if(str.contains(loggedInUserId))
                    isCorrectUserToApprove=true;
                }
               } 
               }
            }
            return ((crs.Status__c == CRS_CRSEdit.CRS_Status_InProcess ||(crs.Status__c == CRS_CRSEdit.CRS_Status_UnderReview && isCRSBA )|| (crs.Status__c == CRS_CRSEdit.CRS_Status_UnderReview && isCRSSA))
                    && crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_FIELDSRA
                    && crs.Internal_Status2__c == 'Wait2' && (crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NOTIFICATION
                    || crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NON_COKE 
                    || crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_COKE));
                    // || (isCRSBA);
        }
    }
    
    public Boolean isShowSendVPChief {
        get {
            CRS__c crs = (CRS__c) stdController.getRecord();
            if (crs.Status__c == CRS_CRSEdit.CRS_Status_InProcess
                    && crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPSRA
                    && crs.Internal_Status2__c == 'Wait2'){
               crs.CRS_Corporate_SRA_Approver_Message__c = '';
               return true;         
            }
            return false;
        }
    }
    
    public Boolean isShowSendVPScience {
        get {
            CRS__c crs = (CRS__c) stdController.getRecord();
            if(crs.id!=null){  //added by Ranjan---to give edit access to FGD user to edit Send to VP Science field
                List<CRS__c > ApproverIds=[select CRS_Corp_Formula_Governance__c from CRS__c where id=:crs.id];
                String loggedInUserId=UserInfo.getUserId();
                if(ApproverIds.size()!=0 && !ApproverIds.isEmpty()){
                String ListOfIds=String.valueOf(ApproverIds);
                if(ListOfIds!=null && ListOfIds!=''){
                String [] splittedIds=ListOfIds.split(';');
                for(String str:splittedIds){
                  if(str.contains(loggedInUserId))
                    isCorrectUserToApprove=true;
                }
               } 
              } 
            }
            return (crs.Status__c == CRS_CRSEdit.CRS_Status_InProcess
                    && crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN
                    && crs.Internal_Status2__c == 'Wait2' 
                    && crs.Process_Flow__c ==PROCESS_FLOW_FULL_REVIEW_COKE && (isCorrectUserToApprove || isCRSBA || isCRSSA))
                    || (crs.Status__c == CRS_CRSEdit.CRS_Status_InProcess
                    && crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN
                    && crs.Internal_Status2__c == 'Wait2' 
                    && crs.Process_Flow__c ==PROCESS_FLOW_FULL_REVIEW_PAC_COKE && (isCorrectUserToApprove || isCRSBA || isCRSSA)) ; //added for workflow 5
        }
    }
    
    Boolean isCRSBA = false;
    Boolean isCRSSA = false;

    public static String getBAProfileName(){
        if(Test.isRunningTest()){
            return 'CRS Business Admin';
        }
        CRS_NameValueSetup__c adminPrfile = CRS_NameValueSetup__c.getInstance(BUSINESS_ADMIN_SETTING_KEY);
        return adminPrfile==null ? null : adminPrfile.Value__c;
    }
    public static String getSAProfileName(){
        if(Test.isRunningTest()){
            return 'System Administrator';
        }
        CRS_NameValueSetup__c adminPrfile = CRS_NameValueSetup__c.getInstance(SYSTEM_ADMIN_SETTING_KEY);
        return adminPrfile==null ? null : adminPrfile.Value__c;
    }
    public CRS_Dossier__c objDossier {get;set;} // crs enhancement
    
    public CRS_CRSEdit(ApexPages.StandardController stdController) {
        isCorrectUserToApprove=false;
        isAuthorizedSRA =false;
        isAuthorizedFGD=false;
        this.stdController = stdController;
        CRS__c crs = (CRS__c) stdController.getRecord();
        Profile currentProfile = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()];
        List<CRS_Role__c> roles = [Select Id FROM CRS_Role__c WHERE Business_Unit__c =:crs.CRS_Business_Unit__c and User__c =:UserInfo.getUserId() and (CRS_Corporate_Level__c = 'Yes' or gvwCRS_Corporate_Level__c = 'Yes')];
        
        String BAProfileName = getBAProfileName();
        String SAProfileName = getSAProfileName();
        
        isCRSBA = (currentProfile.Name == BAProfileName);
        isCRSSA = (currentProfile.Name == SAProfileName);

        // Set Draft status if status is empty      
        if(crs.Status__c==null || crs.Status__c==''){
            crs.Status__c=CRS_Status_Draft;
        }
        
        // Set gvw Record Type if it is gvw Only user
        Id crsGvwRecordTypeId = [Select Id, Name From RecordType where sObjectType='CRS__c' and name='glaceau vitaminwater CRS'][0].Id;
        Id gvwOnlyRoleId = [select Id from UserRole where Name = 'gvwCRS Only'][0].Id;
        if(currentProfile.Name.contains('gvw only') && Userinfo.getUserRoleId() == gvwOnlyRoleId){
            crs.RecordTypeId = crsGvwRecordTypeId;
        }
        
        isGvw = (crs.RecordTypeId == crsGvwRecordTypeId);
        
        // Set owner and initiated by for new CRS
        if (crs.id == null){
            crs.Initiated_By__c = UserInfo.getUserId();
            crs.OwnerId = UserInfo.getUserId();
        }
        if(ApexPages.currentPage().getParameters().get('clone') == '1'){
            finishClone(crs);
        }
        fillMultiItemsFromLinks(crs);

        // unlock (allow edit) for system admin, business admin, (owner in draft status) and corporate users
        // the rest can't edit 
        if (crs.id == null ||
            (crs.OwnerId==UserInfo.getUserId() && crs.Status__c==CRS_Status_Draft) || 
            BAProfileName.equals(currentProfile.Name) || 
            SAProfileName.equals(currentProfile.Name) ||
                (!roles.isEmpty()
                   && (crs.Status__c==CRS_Status_Draft || crs.Status__c==CRS_Status_NewSubmission || crs.Status__c==CRS_Status_InProcess))){
            isLock = false;
        } else {
            isLock = true;  
        }
        
    }

    private void finishClone(CRS__c crs){
        crs.Name = '';
        crs.Status__c = CRS_Status_Draft;           
        crs.Initiated_By__c = UserInfo.getUserId();
        crs.Date_Initiated__c = Date.today();
        crs.Audit_Status__c = '';
        if(crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_PAC_COKE 
        || crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC 
        || crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE){
          crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BUPAC;
        }
        else{
            crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BULEGAL;
        }
        crs.Internal_Status2__c = 'NotStarted';
        crs.CRS_Review__c = null;
        crs.Date_Closed__c = null;
        crs.MTR_Day_Count__c = 0;
        crs.Total_Page_Count__c = 0;
        crs.Days_In_Process_After_BU_Approval__c = 0;//++CRS Enhancement
        crs.Additional_Submission_Required__c='';
        crs.Conditional_Approval_Required__c='';
        crs.Send_VP_Chief__c = '';
        crs.Send_VP_Science__c = '';
        crs.Send_Corp_Form_Gov__c = '';
        crs.Send_Corporate_PAC__c='';
        crs.CRS_Corporate_PAC_Approver__c='';
        crs.CRS_Corporate_SRA_Approver_Message__c = '';
        crs.OwnerId = UserInfo.getUserId();
        List<CRS_Business_Unit__c> listBu = [SELECT Id, Name, Group__c FROM CRS_Business_Unit__c WHERE Id=:crs.CRS_Business_Unit__c limit 1];
        if(!listBu.isEmpty()){
            autoPopulateApprovers(crs, listBu[0].Name);
        }
    } 
    @TestVisible 
    private Pagereference saveLogic(){
        CRS__c crs = (CRS__c) stdController.getRecord();
        System.debug('~~~saveLogic'+crs); 
        Boolean isWaitStatus = (crs.Internal_Status2__c=='Wait'|| (crs.Internal_Status2__c=='Wait2'));

        fillMultiItemsNames();

        //Here is logic for step 2.1. Go to the step 2.1 or to 2.2
       /* if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_FIELDSRA && isWaitStatus && crs.Send_Corp_Form_Gov__c=='Yes'){
            if(crs.CRS_Corp_Formula_Governance_Names__c== null || crs.CRS_Corp_Formula_Governance_Names__c== ''){
                crs.addError('Approver CRS Corporate Formula Governance is required.');
                return null;
            }
            crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN;
            crs.Internal_Status2__c='RunNext';
        } else if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_FIELDSRA && isWaitStatus && crs.Send_Corp_Form_Gov__c=='No'){
            crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPFOODLAW;
            crs.Internal_Status2__c='RunNext';
        }*/
       
       
        //Added by Ranjan 8th Oct'14 -line no 241 to 290
        
        //Approval process Step2-Corporate PAC Review&Corp Form Gov .Logic to the step 2.1
        if((crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NON_COKE) || (crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NOTIFICATION)){
            if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_FIELDSRA && isWaitStatus && crs.Send_Corp_Form_Gov__c=='Yes' && crs.Send_Corporate_PAC__c=='Yes'){
                if(crs.CRS_Corporate_PAC_Approver_Names__c== null || crs.CRS_Corporate_PAC_Approver_Names__c== ''){
                    crs.addError('Approver CRS Corporate PAC Review is required.');
                    return null;
                }
                if(crs.CRS_Corp_Formula_Governance_Names__c== null || crs.CRS_Corp_Formula_Governance_Names__c== ''){
                    crs.addError('Approver CRS Corporate Formula Governance is required.');
                    return null;
                }
                crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPPAC;
                crs.Internal_Status2__c='RunNext';
            } else if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_FIELDSRA && isWaitStatus && crs.Send_Corporate_PAC__c=='Yes' && crs.Send_Corp_Form_Gov__c=='No'){
            
                if(crs.CRS_Corporate_PAC_Approver_Names__c== null || crs.CRS_Corporate_PAC_Approver_Names__c== ''){
                    crs.addError('Approver CRS Corporate PAC Review is required.');
                    return null;
                }
                
                crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPPAC;
                crs.Internal_Status2__c='RunNext';
                
            } else if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_FIELDSRA && isWaitStatus && crs.Send_Corporate_PAC__c=='No' && crs.Send_Corp_Form_Gov__c=='Yes'){
            
                
                if(crs.CRS_Corp_Formula_Governance_Names__c== null || crs.CRS_Corp_Formula_Governance_Names__c== ''){
                    crs.addError('Approver CRS Corporate Formula Governance is required.');
                    return null;
                }
                crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN;
                crs.Internal_Status2__c='RunNext';
                    
            }else if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_FIELDSRA && isWaitStatus && crs.Send_Corp_Form_Gov__c=='No' &&crs.Send_Corporate_PAC__c=='No'){
                crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPFOODLAW;
                crs.Internal_Status2__c='RunNext';
            }
        }
        //Approval Process Worklow 3---Added by Ranjan
        if(crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_COKE){
            if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_FIELDSRA && isWaitStatus && crs.Send_Corporate_PAC__c=='Yes'){
             if(crs.CRS_Corporate_PAC_Approver_Names__c== null || crs.CRS_Corporate_PAC_Approver_Names__c== ''){
                    crs.addError('Approver CRS Corporate PAC Review is required.');
                    return null;
                }
                crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPPAC;
                crs.Internal_Status2__c='RunNext';
            }
            else if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_FIELDSRA && isWaitStatus && crs.Send_Corporate_PAC__c=='No'){
               crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPSRA;
               crs.Internal_Status2__c='RunNext';
            }
        }
        
        //Approval Process Workflow 4---Added by Ranjan 15th oct.
        if((crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE) || (crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC)){
            if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPPAC && isWaitStatus && crs.Send_Corp_Form_Gov__c=='Yes'){
             if(crs.CRS_Corp_Formula_Governance_Names__c== null || crs.CRS_Corp_Formula_Governance_Names__c== ''){
                    crs.addError('Approver CRS Corporate Formula Governance is required.');
                    return null;
                }
                crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN;
                crs.Internal_Status2__c='RunNext';
            }
            else if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPPAC && isWaitStatus && crs.Send_Corp_Form_Gov__c=='No'){
               crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_CORPFOODLAW;
               crs.Internal_Status2__c='RunNext';
            }
        }
        
        // Aproval process #1a and #1b. Here is logic for  step 3.1. Go to the step 3.1 or approve CRS
        if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPSRA && isWaitStatus && crs.Send_VP_Chief__c=='Yes'){
            if(crs.CRS_VP_Chief_Scientific_Regulatory_Names__c== null || crs.CRS_VP_Chief_Scientific_Regulatory_Names__c== ''){
                crs.addError('Approver VP-Chief Scientific & Regulatory is required.');
                return null;
            }
            String validateErrorMessage = CRS_Approval.validateFinalAttachments(crs);
            if(validateErrorMessage != null){
               crs.addError(validateErrorMessage);
               return null;
            }
            List<CRS_Message__c> crsMessages = [select Id, Notification_Comment__c from CRS_Message__c where CRS__c =:crs.Id];
            CRS_Message__c crsMessage = new CRS_Message__c();
            if(!crsMessages.isEmpty()){
                crsMessage = crsMessages[0];
            } 
            crsMessage = CRS_CRSResendController.fillMessage(crs, crsMessage);
            crsMessage.Notification_Comment__c = crs.CRS_Corporate_SRA_Approver_Message__c;
            upsert crsMessage;
            crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_VPCHIEF;
            crs.Internal_Status2__c='RunNext';
        } else if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPSRA && isWaitStatus && crs.Send_VP_Chief__c=='No'){
            String validateErrorMessage = CRS_Approval.validateFinalAttachments(crs);
            if(validateErrorMessage != null){
               crs.addError(validateErrorMessage);
               return null;
            }
            crs.Status__c='Approved';
        }

        // Aproval process #2. Here is logic for  step 3.1. Go to the step 3.1 or approve CRS
        if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN && isWaitStatus && crs.Send_VP_Science__c=='Yes'){
            if(crs.CRS_VP_Science_Division_Names__c== null || crs.CRS_VP_Science_Division_Names__c== ''){
                crs.addError('Approver VP-Science Division is required.');
                return null;
            }
            String validateErrorMessage = CRS_Approval.validateFinalAttachments(crs);
            if(validateErrorMessage != null){
               crs.addError(validateErrorMessage);
               return null;
            }
            crs.Internal_Status__c=CRS_Approval.APPROVAL_STEP_VPSCIENCEDIVISION;
            crs.Internal_Status2__c='RunNext';
        } else if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN && isWaitStatus && crs.Send_VP_Science__c=='No'){
            String validateErrorMessage = CRS_Approval.validateFinalAttachments(crs);
            if(validateErrorMessage != null){
               crs.addError(validateErrorMessage);
               return null;
            }
            if(crs.Conditional_Approval_Required__c=='YES'){   //added by Ranjan for workflow 3-14th Oct
               crs.Status__c='Conditionally Approved';
            }
            else if(crs.Conditional_Approval_Required__c=='NO'){
               crs.Status__c='Approved';
            }
        }
        //Validate Attachments before final Approval  for Workflow 2&4--by Ranjan 20th oct'14
        if(crs.Internal_Status__c==CRS_Approval.APPROVAL_STEP_CORPSRA && isWaitStatus && crs.Process_Flow__c!=PROCESS_FLOW_NOTIFICATION 
           && crs.Process_Flow__c!=PROCESS_FLOW_FULL_REVIEW_COKE && crs.Process_Flow__c!=PROCESS_FLOW_FULL_REVIEW_PAC_COKE){
           String validateErrorMessage = CRS_Approval.validateFinalAttachments(crs);
            if(validateErrorMessage != null){
               crs.addError(validateErrorMessage);
               return null;
            }
         }
        
        //++CRS enhancement
        String crsType;
         if(crs.Id != null){
            crsType = [Select CRS_Type_Names__c from CRS__c where Id =: crs.Id].CRS_Type_Names__c ; 
         }
         
        //string crsType = objCRS.
        PageReference result = stdController.save();

        if (!ApexPages.hasMessages()) {
            syncJunctionObjects(stdController.getId());
        }
        PageReference returnPage;
        boolean isCloned = false;
        if(ApexPages.currentPage().getParameters().get('clone') != null){
            if(ApexPages.currentPage().getParameters().get('clone') == '1'){
                 isCloned = true;            
            }
        }
        if(crs.Id != null && crsType != null && isCloned == false){
            if(crsType.trim() == getMultiItemsNames(MULTISELECT_CRSTYPE, selectedMultipleIds.get(MULTISELECT_JUNCTION_CRSTYPE)).trim()){
                returnPage=  result;
            }else{

                list<CRS_Dossier__c> lstDossier = [select Id, CRSDossierToCRS__c from CRS_Dossier__c where CRSDossierToCRS__c =: crs.Id limit 1];
                if(lstDossier.size() > 0){
                    objDossier = lstDossier[0];
                    objDossier.isSubmitted__c = false;
                    update objDossier;
                    returnPage = new PageReference('/apex/CRS_EditDossier?CRSId='+crs.Id+'');
                }else{
                    returnPage = result; 
                }   
            }   
        }else{
            
            returnPage=  result;
        }
        
        return returnPage;
        //--crs enhancement
        
    }

    private void syncJunctionObjects(Id crsId) {
        //CRS__c crs = (CRS__c) stdController.getRecord();
        
        // TODO: Do not delete the whole old list and then create a brand new.
        // Delete only things that need to be deleted.
        // Create only new things.
        for (String key : multiKeys) {
            List<SObject> oldList = selectedMultipleLinks.get(key);
            if (oldList != null) {
                if(ApexPages.currentPage().getParameters().get('clone') != '1'){
                    delete oldList;
                }   
            }
             
            
            String selectedIds = selectedMultipleIds.get(key);
            
            if (selectedIds != null && selectedIds != '') {
                List<String> selectedIdsList = selectedIds.split(';');
                List<SObject> linksList = new List<SObject>();
                for (String itemId : selectedIdsList) {
                    
                    SObject itemLink;
                    if (key.equals(MULTISELECT_JUNCTION_COUNTRY)) {
                        itemLink = new CRS_Country_to_CRS__c();
                    } else if (key.equals(MULTISELECT_JUNCTION_FLAVOR)) {
                        itemLink = new CRS_Flavor_to_CRS__c();
                    } else if (key.equals(MULTISELECT_JUNCTION_CRSTYPE)) {
                        itemLink = new CRS_Type_to_CRS__c();
                    } else if (key.equals(MULTISELECT_JUNCTION_PACKAGETYPE)) {
                        itemLink = new CRS_PacType_to_CRS__c();
                    } else if (key.equals(MULTISELECT_JUNCTION_MEDIATYPE)) {
                        itemLink = new CRS_MediaType_to_CRS__c();
                    }
                    
                    itemLink.put(relatedObjects.get(key), itemId);
                    itemLink.put('CRS__c', crsId);
                    linksList.add(itemLink);
                } 
                insert linksList;
            }
        }
    }
    
    /**
     * Filling fields with multiselect items names.
     * These fields will be used on view page. 
     */
    private void fillMultiItemsNames() {
        CRS__c crs = (CRS__c) stdController.getRecord();
        System.debug('~~~selectedMultipleIds2:'+selectedMultipleIds);
        crs.CRS_Country_Names__c = getMultiItemsNames(MULTISELECT_COUNTRY, selectedMultipleIds.get(MULTISELECT_JUNCTION_COUNTRY));
        crs.CRS_Flavor_Names__c = getMultiItemsNames(MULTISELECT_FLAVOR, selectedMultipleIds.get(MULTISELECT_JUNCTION_FLAVOR));
        crs.CRS_Type_Names__c = getMultiItemsNames(MULTISELECT_CRSTYPE, selectedMultipleIds.get(MULTISELECT_JUNCTION_CRSTYPE));
        crs.CRS_Package_Type_Names__c = getMultiItemsNames(MULTISELECT_PACKAGETYPE, selectedMultipleIds.get(MULTISELECT_JUNCTION_PACKAGETYPE));
        crs.CRS_Media_Type_Names__c = getMultiItemsNames(MULTISELECT_MEDIATYPE, selectedMultipleIds.get(MULTISELECT_JUNCTION_MEDIATYPE));
        
        //Fill Approvers Names
        crs.CRS_BU_Legal_Approver_Names__c = getMultiItemsNames('User', crs.CRS_BU_Legal_Approver__c);
        crs.CRS_Field_SRA_Approver_Names__c = getMultiItemsNames('User', crs.CRS_Field_SRA_Approver__c);
        crs.CRS_Corp_SRA_Approver_Names__c = (getIsApproval1a() || getIsApproval1b() || isGvw || getIsApproval2() || getIsApproval3()) 
                ? getMultiItemsNames('User', crs.CRS_Corp_SRA_Approver__c) 
                : NOT_APPLICABLE; 
        crs.CRS_Corp_Food_Law_Approver_Names__c = (getIsApproval1a() || getIsApproval1b() || getIsApproval2() || getIsApproval3() || isGvw)
                ? getMultiItemsNames('User', crs.CRS_Corp_Food_Law_Approver__c)
                : NOT_APPLICABLE;
        crs.CRS_Corp_Formula_Governance_Names__c = (getIsApproval1a() || getIsApproval2() || getIsApproval3())
                ? getMultiItemsNames('User', crs.CRS_Corp_Formula_Governance__c)
                : NOT_APPLICABLE;
        crs.CRS_VP_Chief_Scientific_Regulatory_Names__c = (getIsApproval1a() || getIsApproval1b() || isGvw) 
                ? getMultiItemsNames('User', crs.CRS_VP_Chief_Scientific_Regulatory__c)
                : NOT_APPLICABLE;
        crs.CRS_VP_Science_Division_Names__c = (getIsApproval2())
                ? getMultiItemsNames('User', crs.CRS_VP_Science_Division__c)
                : NOT_APPLICABLE;
        crs.CRS_Corporate_PAC_Approver_Names__c= (getIsApproval1a() || getIsApproval2() || getIsApproval3())  //ADDED BY RANJAN 8TH OCT'14
                ? getMultiItemsNames('User', crs.CRS_Corporate_PAC_Approver__c)
                : NOT_APPLICABLE;
        crs.CRS_BU_PAC_Approver_Names__c= (getIsApproval3()||getIsApproval2() || getIsApproval3())  //ADDED BY RANJAN 15TH OCT'14
                ? getMultiItemsNames('User', crs.CRS_BU_PAC_Approver__c)
                : NOT_APPLICABLE;
        System.debug('~~~crs2:'+crs);
    }
    
    /**
     * idsString - semicolon-separated ids.
     * objectType - API object name.
     * 
     * Method returns semicolon-separated string with object names.
     */
    public static String getMultiItemsNames(String objectType, String idsString) {
        String result = '';
        
        if (idsString != null && idsString != '') {    
            List<String> idsList = idsString.split(';');
            String ids = '';
            for (String idFromList : idsList) {
                ids += '\'' + idFromList + '\'' + ','; 
            }
            ids = ids.substring(0, ids.length()-1);        

            String nameField = lookupNameFields.get(objectType);
            if (nameField == null) {
                nameField = 'Name';
            }
            
            // Long textarea field can not be sorted in a query call, so we sort by name. 
            String query = 'SELECT Id, ' + nameField + ' FROM ' + objectType + ' WHERE Id IN (' + ids + ') ORDER BY Name';
            System.debug('~~~MultiCompQuery'+query);
                    
            List<SObject> objects = database.query(query);
            if (objects.size() > 0) {
                String names = '';
                for (SObject obj : objects) {
                    String name = (String) obj.get(nameField);
                    names += name + '; ';
                }    
                result = names;
            }
                
        }   
        return result;  
    }

    public Pagereference doSave() {
        return saveLogic();
    }
    
    public PageReference assignUsers() {
        CRS__c crs = (CRS__c) stdController.getRecord();
        String fieldName = ApexPages.currentPage().getParameters().get('fieldName');
        system.debug('~~~fieldName='+fieldName);
        //get field by name and set selected ids
        if (fieldName != null) {
            crs.put(fieldName, selectedUsersIds);   
        } else {
            system.debug('fieldName is empty!');
        }
        return null;
    }
    
    public PageReference assignMultiselect() {
        CRS__c crs = (CRS__c) stdController.getRecord();
        String fieldName = ApexPages.currentPage().getParameters().get('fieldName');
        String selectedIds = ApexPages.currentPage().getParameters().get('selectedIds');
        system.debug('~~~fieldName='+fieldName);
        system.debug('~~~selectedIds='+selectedIds);
        //get field by name and set selected ids
        if (fieldName != null) {
            selectedMultipleIds.put(fieldName,selectedIds);
            if(fieldName == MULTISELECT_JUNCTION_CRSTYPE){
                updateProcessFlow(true);    
            }
        } else {
            system.debug('fieldName is empty!');
        }
        return null;
    }

    private void autoPopulateApprovers(CRS__c crs, String buName1) {
    
        String buName = buName1;
        if(buName1.length() > 39){
            buName = buName1.substring(0,39);
        }
        // Auto-populate default BU Legal approvers
            List<User> users = isGvw?[SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE gvwCRS_BU_Legal_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')]:
                [SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE CRS_BU_Legal_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')];
            System.debug('~~~BU Legal Approvers: ' + users);
            String legalApprovers = '';
            for(User us: users){
                legalApprovers = legalApprovers + (legalApprovers.length() == 0 ? '' : ';') + us.Id;
            }
            crs.CRS_BU_Legal_Approver__c = legalApprovers;
            
            // Auto-populate default BU PAC approvers
            users = isGvw?[SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE gvwCRS_BU_PAC_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')]:
                [SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE CRS_BU_PAC_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')];
            System.debug('~~~BU PAC Approvers: ' + users);
            String BuPacApprovers = '';
            for(User us: users){
                BuPacApprovers= BuPacApprovers + (BuPacApprovers.length() == 0 ? '' : ';') + us.Id;
            }
            crs.CRS_BU_PAC_Approver__c = BuPacApprovers;
            
            // Auto-populate default Field SRA approvers
            users = isGvw?[SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE gvwCRS_Field_SRA_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')]:
                [SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE CRS_Field_SRA_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')];
            System.debug('~~~Field SRA Approvers: ' + users);
            
            String fieldSRAApprovers = '';
            for(User us: users){
                fieldSRAApprovers = fieldSRAApprovers + (fieldSRAApprovers.length() == 0 ? '' : ';') + us.Id;
            }
            crs.CRS_Field_SRA_Approver__c = fieldSRAApprovers;
            
            // Auto-populate default Corporate SRA Approvers
            users = isGvw?[SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE gvwCRS_Corporate_SRA_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')]:
                [SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE CRS_Corporate_SRA_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')];
            System.debug('~~~Field Corporate SRA Approvers: ' + users);
            String fieldCorpSRAApprovers = '';
            for(User us: users){
                fieldCorpSRAApprovers = fieldCorpSRAApprovers + (fieldCorpSRAApprovers.length() == 0 ? '' : ';') + us.Id;
            }
            crs.CRS_Corp_SRA_Approver__c = fieldCorpSRAApprovers;
            
            // Auto-populate default Corporate PAC Approvers----Added by Ranjan 10th Oct'14
            users = isGvw?[SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE gvwCRS_Corporate_PAC_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')]:
                [SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE CRS_Corporate_PAC_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')];
            System.debug('~~~Field Corporate PAC Approvers: ' + users);
            String fieldCorpPACApprovers = '';
            for(User us: users){
                fieldCorpPACApprovers = fieldCorpPACApprovers + (fieldCorpPACApprovers.length() == 0 ? '' : ';') + us.Id;
            }
            crs.CRS_Corporate_PAC_Approver__c= fieldCorpPACApprovers ;
            
            // Auto-populate default Corporate Food Law Approvers
            users = isGvw?[SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE gvwCRS_Corporate_Food_Law_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')]:
                [SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE CRS_Corporate_Food_Law_Approver__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')];
            System.debug('~~~Field Corporate Food Law Approvers: ' + users);
            String fieldCorpFoodLawApprovers = '';
            for(User us: users){
                fieldCorpFoodLawApprovers = fieldCorpFoodLawApprovers + (fieldCorpFoodLawApprovers.length() == 0 ? '' : ';') + us.Id;
            }
            crs.CRS_Corp_Food_Law_Approver__c = fieldCorpFoodLawApprovers;
            
            // Auto-populate default Corporate Formula Governance Approvers
            if (!isGvw){
                users = [SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE CRS_Corporate_Formula_Governance__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')];
                System.debug('~~~Field Corporate Formula Governance Approvers: ' + users);
                String fieldCorpFormGovernApprovers = '';
                for(User us: users){
                    fieldCorpFormGovernApprovers = fieldCorpFormGovernApprovers + (fieldCorpFormGovernApprovers.length() == 0 ? '' : ';') + us.Id;
                }
                crs.CRS_Corp_Formula_Governance__c = fieldCorpFormGovernApprovers;
            }

            // Auto-populate default VP-Chief Scientific & Regulatory Officers
            users = isGvw?[SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE gvwCRS_VP_Chief_Scientific__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')]:
                [SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE CRS_VP_Chief_Scientific_Regulatory__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')];
            System.debug('~~~VP-Chief Scientific & Regulatory Officer: ' + users);
            String fieldVPRegulatory = '';
            for(User us: users){
                fieldVPRegulatory = fieldVPRegulatory + (fieldVPRegulatory.length() == 0 ? '' : ';') + us.Id;
            }
            crs.CRS_VP_Chief_Scientific_Regulatory__c = fieldVPRegulatory;

            // Auto-populate default VP-Chief Scientific & Regulatory Officers
            if (!isGvw){
                users = [SELECT Id, Name FROM User Where Id IN (SELECT User__c FROM CRS_Role__c WHERE CRS_VP_Science_Division__c='Yes' AND Business_Unit__r.Business_Unit_External_Id__c LIKE :buName + '%')];
                System.debug('~~~VP-Chief Scientific & Regulatory Officer: ' + users);
                String fieldVPScienceDivision = '';
                for(User us: users){
                    fieldVPScienceDivision = fieldVPScienceDivision + (fieldVPScienceDivision.length() == 0 ? '' : ';') + us.Id;
                }
                crs.CRS_VP_Science_Division__c = fieldVPScienceDivision;
            }
    }

    public PageReference populateBUDependencies() {
        CRS__c crs = (CRS__c) stdController.getRecord();
        /* Get Business Unit as request param because form is not submitted when actionFunction or 
           actionSupport has "immediate" attribute set to "true".*/ 
        String buFromPage = ApexPages.currentPage().getParameters().get('bu');
        List<CRS_Business_Unit__c> listBu = [SELECT Id, Name, Group__c FROM CRS_Business_Unit__c WHERE Id=:buFromPage or Name=:buFromPage];
        System.debug('~~~crs:'+crs);
        if (!listBu.isEmpty()){
            CRS_Business_Unit__c bu = listBu[0];
            crs.CRS_Business_Unit__c = bu.Id;
            
            // Clear selected Countries
            selectedMultipleIds.put(MULTISELECT_JUNCTION_COUNTRY, '');
            // Choose only one for 'All ...' Business Unit
            if (bu.Name.contains('All')){
                List<CRS_Country__c> country = [SELECT Id From CRS_Country__c WHERE Business_Unit__c=:bu.Id];
                if (!country.isEmpty()) selectedMultipleIds.put(MULTISELECT_JUNCTION_COUNTRY, country[0].Id);
            }
            
            // Auto-populate CRS Group
            crs.CRS_Group__c = bu.Group__c;
            System.debug('~~~crs:'+crs);
            
            autoPopulateApprovers(crs, bu.Name);
        }
        return null;
    }
    
    //++ crs enahancement, method changed
    public PageReference updateProcessFlow(boolean isCRSTypeChange){
        CRS__c crs = (CRS__c) stdController.getRecord();
        List <CRS_CRS_Product__c> prods = [SELECT Id, Name, KO_Product__c FROM CRS_CRS_Product__c WHERE Id=:crs.CRS_Product_Name__c LIMIT 1];
        if(prods.isEmpty()){
            crs.Process_Flow__c = '';
            return null;
        }
        System.debug('~~~prods: '+prods);
        if(isGvw){
            //KO Product = No and Record Type = gvwCRS
            if(prods[0].KO_Product__c == 'No'){
                if(!isCRSTypeChange){
                    List<CRS_Type__c> crsType = [Select Id from CRS_Type__c where Name = 'glaceau vitaminwater communication' limit 1];
                    if(!crsType.isEmpty()){
                        selectedMultipleIds.put(MULTISELECT_JUNCTION_CRSTYPE, crsType[0].Id);
                    }
                }
                crs.Process_Flow__c = PROCESS_FLOW_GVW_FULL_REVIEW;
            }
        } else {
            if(prods[0].Name == getPDNameFor(BEVERAGE_PRODUCT_NAME_GENERAL_COMMUNICATIONS)){
                //Product Name = All Products - General Communications
                crs.Process_Flow__c = PROCESS_FLOW_FULL_REVIEW_NON_COKE;
                crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BULEGAL;  //added to resolve defect when cloning
                return null;
            } else if(prods[0].Name == getPDNameFor(BEVERAGE_PRODUCT_NAME_LIVE_POSITIVELY)){
                //Product Name = All Products - LivePositively
                crs.Process_Flow__c = PROCESS_FLOW_FULL_REVIEW_NON_COKE;
                crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BULEGAL;  //added to resolve defect when cloning
                return null;
            }
            List<CRS_Type__c> cts = [SELECT Id, Name, Review_Type__c FROM CRS_Type__c WHERE Id in :(selectedMultipleIds.get(MULTISELECT_JUNCTION_CRSTYPE).split(';'))];
            if(prods[0].KO_Product__c == 'Yes'){
                boolean isPac = false;
                for(CRS_Type__c ct: cts){
                    if(ct.Name == 'Promoting Trust/Refresh 2020 and Corporate Reputation claims'){
                        isPac = true;
                        break;
                    }
                }
                if(isPac){
                        //KO Product = Yes and Record Type = CRS and CRS Type = General Communication on nutrition health and food safety
                        //crs.Process_Flow__c = PROCESS_FLOW_FULL_REVIEW_NON_COKE; - orig code, commented out by BSA 20-Sept-2013
                        crs.Process_Flow__c =PROCESS_FLOW_FULL_REVIEW_PAC_COKE; //- to return original logic as per INC0960803 BSA 20-Sept-2013
                        crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BUPAC;  //added to resolve defect when cloning
                } else {
                    //KO Product = Yes and Record Type = CRS
                    crs.Process_Flow__c = PROCESS_FLOW_FULL_REVIEW_COKE;
                    crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BULEGAL; //added to resolve defect when cloning
                }
            } else if (prods[0].KO_Product__c == 'No') {
                if(cts.isEmpty()){
                    crs.Process_Flow__c = '';
                    return null;
                }
                boolean notification = false;
                boolean fullReview = false;
                boolean pac = false;
                for(CRS_Type__c ct: cts){
                    if(ct.Review_Type__c != null){
                        if(ct.Review_Type__c.contains(REVIEW_TYPE_NOTIFICATION)) {
                            notification = true;
                        }
                        if(ct.Review_Type__c.contains(REVIEW_TYPE_FULL_REVIEW)){
                            fullReview = true;
                        }
                        if(ct.Review_Type__c.contains(REVIEW_TYPE_PAC)){
                            pac= true;
                        }
                    } 
                }  
                if(pac){
                    if(notification){
                        if (fullReview) {
                            //KO Product = No, Record Type = CRS and Review Type = Full Review & Notification 
                            crs.Process_Flow__c = PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC;
                            crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BUPAC; //added to resolve defect when cloning
                        } else {
                            //KO Product = No, Record Type = CRS and Review Type = Notification
                            crs.Process_Flow__c = PROCESS_FLOW_NOTIFICATION;
                            crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BULEGAL; //added to resolve defect when cloning
                        }
                    } else {
                        //KO Product = No, Record Type = CRS and Review Type = Full Review
                        crs.Process_Flow__c = PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE;
                        crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BUPAC; //added to resolve defect when cloning
                    }
                }
                else 
                if(notification){
                    if (fullReview) {
                        //KO Product = No, Record Type = CRS and Review Type = Full Review & Notification 
                        crs.Process_Flow__c = PROCESS_FLOW_FULL_REVIEW_NOTIFICATION;
                        crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BULEGAL; //added to resolve defect when cloning
                    } else {
                        //KO Product = No, Record Type = CRS and Review Type = Notification
                        crs.Process_Flow__c = PROCESS_FLOW_NOTIFICATION;
                        crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BULEGAL; //added to resolve defect when cloning
                    }
                } else {
                    //KO Product = No, Record Type = CRS and Review Type = Full Review
                    crs.Process_Flow__c = PROCESS_FLOW_FULL_REVIEW_NON_COKE;
                    crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_BULEGAL; //added to resolve defect when cloning
                }
            } 
        }
        
        return null;
    }
    
    private void setCRSProductRelatedFields(String flavorName, String brandName, String beverageCategoryName,
            String crsTypeName, String packageTypeName, String mediaTypeName) {
        CRS__c crs = (CRS__c) stdController.getRecord();
 
        CRS_Flavor__c flavor = null;
        if (flavorName != null) {
            List<CRS_Flavor__c> flavors = [SELECT Id, Name FROM CRS_Flavor__c WHERE Name = :flavorName];
            if (flavors.size() != 0) {
                flavor = flavors[0];
            }
        }
        
        CRS_Brand__c brand = null;
        if (brandName != null) {
            List<CRS_Brand__c> brands = [SELECT Id, Name FROM CRS_Brand__c WHERE Name = :brandName];
            if (brands.size() != 0) {
                brand = brands[0];
            }
        }
        
        CRS_Beverage_Category__c beverageCategory = null;
        if (beverageCategoryName != null) {
            List<CRS_Beverage_Category__c> beverageCategories = [SELECT Id, Name FROM CRS_Beverage_Category__c WHERE Name = :beverageCategoryName];
            if (beverageCategories.size() != 0) {
                beverageCategory = beverageCategories[0];
            }
        }
        
        CRS_Type__c crsType = null;
        if (crsTypeName != null) {
            List<CRS_Type__c> crsTypes = [SELECT Id, Name FROM CRS_Type__c WHERE Name = :crsTypeName];
            if (crsTypes.size() != 0) {
                crsType = crsTypes[0];
            }
        }
        
        CRS_Package_Type__c packageType = null;
        if (packageTypeName != null) {
            List<CRS_Package_Type__c> packageTypes = [SELECT Id, Name FROM CRS_Package_Type__c WHERE Name = :packageTypeName];
            if (packageTypes.size() != 0) {
                packageType = packageTypes[0];
            }
        }
        
        CRS_Media_Type__c mediaType = null;
        if (mediaTypeName != null) {
            List<CRS_Media_Type__c> mediaTypes = [SELECT Id, Name FROM CRS_Media_Type__c WHERE Name = :mediaTypeName];
            if (mediaTypes.size() != 0) {
                mediaType = mediaTypes[0];
            }
        }
        
        if (flavor != null) {
            selectedMultipleIds.put(MULTISELECT_JUNCTION_FLAVOR, flavor.Id);
        } else {
            selectedMultipleIds.put(MULTISELECT_JUNCTION_FLAVOR, '');
        } 

        if (brand != null) {
            crs.CRS_Brand__c = brand.Id;
            crs.CRS_Brand__r = brand;
        } else {
            crs.CRS_Brand__c = null;
        }
            
        if (beverageCategory != null) {
            crs.CRS_Beverage_Category__c = beverageCategory.Id;
            crs.CRS_Beverage_Category__r = beverageCategory;
        } else {
            crs.CRS_Beverage_Category__c = null;
        }

        if (crsType != null) {
            selectedMultipleIds.put(MULTISELECT_JUNCTION_CRSTYPE, crsType.Id);
        } else {
            selectedMultipleIds.put(MULTISELECT_JUNCTION_CRSTYPE, '');
        }
        
        if (packageType != null) {
            selectedMultipleIds.put(MULTISELECT_JUNCTION_PACKAGETYPE, packageType.Id);
        } else {
            selectedMultipleIds.put(MULTISELECT_JUNCTION_PACKAGETYPE, '');
        }
           
        if (mediaType != null) {
            selectedMultipleIds.put(MULTISELECT_JUNCTION_MEDIATYPE, mediaType.Id);
        } else {
            selectedMultipleIds.put(MULTISELECT_JUNCTION_MEDIATYPE, '');
        }
        
        //"BBN Not Available"
        String bbnDefault = CRS__c.BBN__c.getDescribe().getDefaultValueFormula().replace('"','');
        crs.BBN__c = bbnDefault;
        
        //"Package Size Not Available"
        String packSizeDefault = CRS__c.Package_Size__c.getDescribe().getDefaultValueFormula().replace('"','');
        crs.Package_Size__c = packSizeDefault;
    }
    
    public void processBeverageProductChange() {
        CRS__c crs = (CRS__c) stdController.getRecord();
        String product = ApexPages.currentPage().getParameters().get('product');
        List<CRS_CRS_Product__c> listProd = [select Id from CRS_CRS_Product__c where Id = :product or Name = :product];
        if (!listProd.isEmpty()){
            crs.CRS_Product_Name__c = listProd[0].Id;
            if (isCRSHasProduct(getPDNameFor(BEVERAGE_PRODUCT_NAME_LIVE_POSITIVELY))) {
                setCRSProductRelatedFields(getPDNameFor(FLAVOR_NAME_LIVE_POSITIVELY),
                        getPDNameFor(BRAND_NAME_LIVE_POSITIVELY),
                        getPDNameFor(BEVERAGE_CATEGORY_NAME_LIVE_POSITIVELY),
                        getPDNameFor(CRS_TYPE_NAME_LIVE_POSITIVELY),
                        getPDNameFor(PACKAGE_TYPE_NAME_LIVE_POSITIVELY),
                        getPDNameFor(MEDIA_TYPE_NAME_LIVE_POSITIVELY));  
                        
            } else if (isCRSHasProduct(getPDNameFor(BEVERAGE_PRODUCT_NAME_GENERAL_COMMUNICATIONS))) {
                setCRSProductRelatedFields(getPDNameFor(FLAVOR_NAME_GENERAL_COMMUNICATIONS),
                        getPDNameFor(BRAND_NAME_GENERAL_COMMUNICATIONS),
                        getPDNameFor(BEVERAGE_CATEGORY_NAME_GENERAL_COMMUNICATIONS),
                        getPDNameFor(CRS_TYPE_NAME_GENERAL_COMMUNICATIONS),
                        getPDNameFor(PACKAGE_TYPE_NAME_GENERAL_COMMUNICATIONS),
                        getPDNameFor(MEDIA_TYPE_NAME_GENERAL_COMMUNICATIONS));
            }
            updateProcessFlow(false);   
        }
    }

    private Boolean isCRSHasProduct(String productName) {
        CRS__c crs = (CRS__c) stdController.getRecord();
        List<CRS_CRS_Product__c> products = [SELECT Id FROM CRS_CRS_Product__c WHERE Name = :productName];
        Boolean result = false;
        if (products.size() == 1) {
            result = crs.CRS_Product_Name__c == products[0].Id; 
        }
        return result;
    }
    
    public Boolean isGeneralCommProductSelected {
        get {
            return isCRSHasProduct(getPDNameFor(BEVERAGE_PRODUCT_NAME_GENERAL_COMMUNICATIONS));
        }
    } 
    
    public Boolean getSpecialProductSelected() {
        return isCRSHasProduct(getPDNameFor(BEVERAGE_PRODUCT_NAME_LIVE_POSITIVELY)) 
                || isCRSHasProduct(getPDNameFor(BEVERAGE_PRODUCT_NAME_GENERAL_COMMUNICATIONS));
    }
    
    /**
     * Get Name of object from Custom Settings for Product-dependent fields setup.
     */
    private String getPDNameFor(String settingName) {
        String result = null;
        CRS_ProductDependentFieldsSetup__c setting = CRS_ProductDependentFieldsSetup__c.getInstance(settingName);
        if (setting != null) {
             result = setting.Value__c;
        }
        return result;
    }

    private void fillMultiItemsFromLinks(CRS__c crs) {
        selectedMultipleIds = new Map<String, String>();
        selectedMultipleLinks = new Map<String, List<SObject>>();
        for (String objName : multiKeys) {
            String selectedIds = '';
            if (crs.Id != null) {// saved record
                String relObjName = relatedObjects.get(objName);
                
                String query = 'SELECT ' + relObjName + ' FROM ' + objName + ' WHERE CRS__c = \'' + crs.Id + '\'';
                system.debug('~~~query:'+query);
                
                List<SObject> links = Database.query(query);

                selectedMultipleLinks.put(objName, links);
                
                for (SObject link : links) {
                   selectedIds += link.get(relObjName) + ';';
                }
            }
                
            selectedMultipleIds.put(objName, selectedIds);
            system.debug('~~~key:'+objName+'~~~value:'+selectedMultipleIds.get(objName));       
        }   
    }
    
    public Boolean getIsApproval1a() {
        CRS__c crs = (CRS__c) stdController.getRecord();
        return crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_NOTIFICATION
               || crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_NON_COKE;
    }
 
    public Boolean getIsApproval1b() {
        CRS__c crs = (CRS__c) stdController.getRecord();
        return crs.Process_Flow__c == PROCESS_FLOW_GVW_FULL_REVIEW;
    }
    
    public Boolean getIsApproval2() {
        CRS__c crs = (CRS__c) stdController.getRecord();
        return crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_COKE
        || crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_PAC_COKE ;
    }
    
    public Boolean getIsApproval3() {    //Added by Ranjan for Workflow 4&5
        CRS__c crs = (CRS__c) stdController.getRecord();
        return crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC 
        || crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE
        || crs.Process_Flow__c ==PROCESS_FLOW_FULL_REVIEW_PAC_COKE;
    }

    public Boolean getIsReadOnlyBULegal(){
        return getReadOnlyApproverField(CRS_Approval.APPROVAL_STEP_BULEGAL );
    }
    
    public Boolean getIsReadOnlyBUPac(){
        return getReadOnlyApproverField(CRS_Approval.APPROVAL_STEP_BUPAC );
    }

    public Boolean getIsReadOnlyFieldSRA(){
        return getReadOnlyApproverField(CRS_Approval.APPROVAL_STEP_FIELDSRA );
    }

    public Boolean getIsReadOnlyCorpFormulaGovern(){
        return getReadOnlyApproverField(CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN );
    }
    
    public Boolean getIsReadOnlyCorpPAC(){   //added by Ranjan 10th Oct'14
        return getReadOnlyApproverField(CRS_Approval.APPROVAL_STEP_CORPPAC);
    }
    
    public Boolean getIsReadOnlyCorpFoodLaw(){
        return getReadOnlyApproverField(CRS_Approval.APPROVAL_STEP_CORPFOODLAW );
    }

    public Boolean getIsReadOnlyCorpSRA(){
        return getReadOnlyApproverField(CRS_Approval.APPROVAL_STEP_CORPSRA );
    }

    public Boolean getIsReadOnlyVPChiefScientific(){
        return getReadOnlyApproverField(CRS_Approval.APPROVAL_STEP_VPCHIEF);
    }
 
    public Boolean getIsReadOnlyVPScience(){
        return getReadOnlyApproverField(CRS_Approval.APPROVAL_STEP_VPSCIENCEDIVISION );
    }
    @TestVisible 
    private Boolean getReadOnlyApproverField(String fieldName) {
        CRS__c crs = (CRS__c) stdController.getRecord();
        if (crs.Status__c!=CRS_Status_InProcess && crs.Status__c!=CRS_Status_Draft && crs.Status__c!=CRS_Status_NewSubmission){
            return true;
        }
            
        if (isCRSSA){
            return false;
            
        }
        if (isCRSBA){
            // First step. All approvers are editable
            if((crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_BULEGAL || crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_BUPAC)  || crs.Status__c == CRS_Status_Draft){ //adding BU PAC approver-by Ranjan
                return false;
            } 
            //Step for workflow 4 & 5---by Ranjan 
            else if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_BULEGAL && crs.Internal_Status2__c =='Wait'){
            system.debug('Read only test'+crs.Internal_Status__c);
              system.debug('Read only test'+crs.Internal_Status2__c );
              system.debug('Read only test'+fieldName );
                 if (fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                        return true;
                    }
                    return false;
                }
            
            // Second step
            else if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_FIELDSRA  && crs.Internal_Status2__c != 'Wait2'){
                // First step approvers are read-only
                if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                    return true;
                }
                return false;
            }else if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_FIELDSRA && crs.Internal_Status2__c == 'Wait2'){
                if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA){
                    return true;
                }
                return false;
            }else if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_BULEGAL && crs.Internal_Status2__c=='Wait' && 
                (crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_PAC_COKE || crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC
                || crs.Process_Flow__c==PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE)){
                if (fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                    return true;
                }
                return false;
            }

            // Approval Process #1a and #1b
            if(crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_NOTIFICATION
                || crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_NON_COKE
                || crs.Process_Flow__c == PROCESS_FLOW_GVW_FULL_REVIEW){
             
                //Adding Corp PAC Approver to all conditions ---by Ranjan 10th Oct'14
                // Thrid step
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN || crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPPAC){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                        return true;
                    }
                    return false;
                }
                
                
                
                // Forth step
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFOODLAW){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                        return true;
                    }
                    return false;
                }
                // Fifth step
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPSRA && crs.Internal_Status2__c != 'Wait2'){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN || fieldName == CRS_Approval.APPROVAL_STEP_CORPFOODLAW
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                        return true;
                    }
                    return false;
                }
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPSRA && crs.Internal_Status2__c == 'Wait2'){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN || fieldName == CRS_Approval.APPROVAL_STEP_CORPFOODLAW
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPSRA || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC
                        || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                        return true;
                    }
                    return false;
                }
                //Sixth step
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_VPCHIEF){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_VPCHIEF){
                        return false;
                    }
                    return true;
                }
            }
            
            
            // Approval Process #2
            else if (crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_COKE){
                // Thrid step
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFOODLAW){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                        return true;
                    }
                    return false;
                }
                // Forth step
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN && crs.Internal_Status2__c != 'Wait2'){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPFOODLAW || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                        return true;
                    }
                    return false;
                }
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN && crs.Internal_Status2__c == 'Wait2'){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPFOODLAW || fieldName == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN
                        || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                        return true;
                    }
                    return false;
                }
                // Fifth step
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_VPSCIENCEDIVISION){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_VPSCIENCEDIVISION){
                        return false;
                    }
                    return true;
                }
            }
            else if(crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC
                || crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE 
                || crs.Process_Flow__c == PROCESS_FLOW_GVW_FULL_REVIEW){
                
                
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPPAC && crs.Internal_Status2__c =='Wait2'){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC){
                        return true;
                    }
                    return false;
                }
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN ){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC
                      || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC){
                        return true;
                    }
                    return false;
                }
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFOODLAW){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC
                      || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC || fieldName == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN ){
                        return true;
                    }
                    return false;
                }
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPSRA && crs.Internal_Status2__c =='Wait2'){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC
                      || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC || fieldName == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN || fieldName == CRS_Approval.APPROVAL_STEP_CORPFOODLAW
                      || fieldName == CRS_Approval.APPROVAL_STEP_CORPSRA){
                        return true;
                    }
                    return false;
                }
                
            }
            else if(crs.Process_Flow__c == PROCESS_FLOW_FULL_REVIEW_PAC_COKE){
               if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPPAC){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC){
                        return true;
                    }
                    return false;
                }
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPSRA){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC){
                        return true;
                    }
                    return false;
                }
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFOODLAW ){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC || fieldName == CRS_Approval.APPROVAL_STEP_CORPSRA){
                        return true;
                    }
                    return false;
                }
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN && crs.Internal_Status2__c =='Wait2'){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA || fieldName == CRS_Approval.APPROVAL_STEP_BUPAC
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPPAC || fieldName == CRS_Approval.APPROVAL_STEP_CORPSRA || fieldName == CRS_Approval.APPROVAL_STEP_CORPFOODLAW 
                        || fieldName == CRS_Approval.APPROVAL_STEP_CORPFORMULAGOVERN ){
                        return true;
                    }
                    return false;
                }
                if(crs.Internal_Status__c == CRS_Approval.APPROVAL_STEP_VPSCIENCEDIVISION){
                    if (fieldName == CRS_Approval.APPROVAL_STEP_VPSCIENCEDIVISION){
                        return false;
                    }
                    return true;
                }
            }
            return true;
        }
        if (crs.Status__c == CRS_Status_Draft && (fieldName == CRS_Approval.APPROVAL_STEP_BULEGAL || fieldName == CRS_Approval.APPROVAL_STEP_FIELDSRA)){
            return false;
        }
        return true;
    }
}