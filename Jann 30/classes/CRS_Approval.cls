global with sharing class CRS_Approval {
    public static final String APPROVAL_STEP_BULEGAL = 'BU Legal Approver';
    public static final String APPROVAL_STEP_BUPAC = 'BU PAC Approver';
    public static final String APPROVAL_STEP_FIELDSRA = 'Field SRA Approver';
    public static final String APPROVAL_STEP_CORPFORMULAGOVERN = 'Corp Formula Govern Approver';
    public static final String APPROVAL_STEP_CORPPAC = 'Corporate PAC Approver';
    public static final String APPROVAL_STEP_CORPFOODLAW = 'Corporate Food Law Approver';
    public static final String APPROVAL_STEP_CORPSRA = 'Corporate SRA Approver';
    public static final String APPROVAL_STEP_VPCHIEF = 'VP-Chief Sc and Reg Officer';
    public static final String APPROVAL_STEP_VPSCIENCEDIVISION = 'VP-Science Division';
    
    private static Boolean isCRSBA;
    private static Boolean isCRSSA;
    
    private static String getFieldNameWithApprovers(String internalStatus){
        if (internalStatus==APPROVAL_STEP_BULEGAL){
            return 'CRS_BU_Legal_Approver__c';
        }else if (internalStatus==APPROVAL_STEP_BUPAC){
            return 'CRS_BU_PAC_Approver__c';
        }else if (internalStatus==APPROVAL_STEP_FIELDSRA){
            return 'CRS_Field_SRA_Approver__c';
        } else if(internalStatus==APPROVAL_STEP_CORPPAC ){ //Added by Ranjan 9th Oct
            return 'CRS_Corporate_PAC_Approver__c';
        }else if (internalStatus==APPROVAL_STEP_CORPFORMULAGOVERN){
            return 'CRS_Corp_Formula_Governance__c';
        } else if (internalStatus==APPROVAL_STEP_CORPFOODLAW){
            return 'CRS_Corp_Food_Law_Approver__c';
        } else if (internalStatus==APPROVAL_STEP_CORPSRA){
            return 'CRS_Corp_SRA_Approver__c';
        } else if (internalStatus==APPROVAL_STEP_VPCHIEF){
            return 'CRS_VP_Chief_Scientific_Regulatory__c';
        } else if (internalStatus==APPROVAL_STEP_VPSCIENCEDIVISION){
            return 'CRS_VP_Science_Division__c';
        }
        return null;
    }

    private static void checkAdminProfiles(){
        isCRSBA = !([select Id from Profile where Id = :UserInfo.getProfileId() and 
            Name = :CRS_CRSEdit.getBAProfileName()].isEmpty());
        isCRSSA = !([select Id from Profile where Id = :UserInfo.getProfileId() and 
            Name = :CRS_CRSEdit.getSAProfileName()].isEmpty());
    }
    
    private static String validateApprovalFields(CRS__c crs){
        // Collect field names for empty require fields
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('CRS__c').getDescribe().fields.getMap();
        List<String> listOfApproverFields = new List<String>();

        if(crs.CRS_BU_Legal_Approver_Names__c== null || crs.CRS_BU_Legal_Approver_Names__c== ''){listOfApproverFields.add(fieldMap.get('CRS_BU_Legal_Approver_Names__c').getDescribe().getLabel());}
        if(crs.CRS_Field_SRA_Approver_Names__c== null || crs.CRS_Field_SRA_Approver_Names__c== ''){listOfApproverFields.add(fieldMap.get('CRS_Field_SRA_Approver_Names__c').getDescribe().getLabel());}

        // Approval2
        if(crs.Process_Flow__c == CRS_CRSEdit.PROCESS_FLOW_FULL_REVIEW_COKE){
            if(crs.CRS_Corp_Food_Law_Approver_Names__c== null || crs.CRS_Corp_Food_Law_Approver_Names__c== ''){listOfApproverFields.add(fieldMap.get('CRS_Corp_Food_Law_Approver_Names__c').getDescribe().getLabel());}
            if(crs.CRS_Corp_Formula_Governance_Names__c== null || crs.CRS_Corp_Formula_Governance_Names__c== ''){listOfApproverFields.add(fieldMap.get('CRS_Corp_Formula_Governance_Names__c').getDescribe().getLabel());}
        } else if(crs.Process_Flow__c != CRS_CRSEdit.PROCESS_FLOW_NOTIFICATION ){
            if(crs.CRS_Corp_Food_Law_Approver_Names__c== null || crs.CRS_Corp_Food_Law_Approver_Names__c== ''){listOfApproverFields.add(fieldMap.get('CRS_Corp_Food_Law_Approver_Names__c').getDescribe().getLabel());}
            if(crs.CRS_Corp_SRA_Approver_Names__c== null || crs.CRS_Corp_SRA_Approver_Names__c== ''){listOfApproverFields.add(fieldMap.get('CRS_Corp_SRA_Approver_Names__c').getDescribe().getLabel());}
        }
        
        // Return error message
        if (listOfApproverFields.size()==1){
            return 'error:Please enter required Approver: ' + listOfApproverFields.get(0);
        } else if(listOfApproverFields.size()>1) {
            return 'error:Please enter required Approvers: ' + String.join(listOfApproverFields, ', ');
        }
        return null;
    }

    private static String validateRequiredFields(CRS__c crs){
                // Collect field names for empty require fields
                Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('CRS__c').getDescribe().fields.getMap();
                List<String> listOfFields = new List<String>();
                if(crs.CRS_Business_Unit__c == null){listOfFields.add(fieldMap.get('CRS_Business_Unit__c').getDescribe().getLabel());}
                if(crs.CRS_Group__c == null){listOfFields.add(fieldMap.get('CRS_Group__c').getDescribe().getLabel());}
                if(crs.CRS_Country_Names__c == null || crs.CRS_Country_Names__c == ''){listOfFields.add(fieldMap.get('CRS_Country_Names__c').getDescribe().getLabel());}
                if(crs.Package_Size__c == null || crs.Package_Size__c == ''){listOfFields.add(fieldMap.get('Package_Size__c').getDescribe().getLabel());}
                if(crs.CRS_Type_Names__c == null || crs.CRS_Type_Names__c == ''){listOfFields.add(fieldMap.get('CRS_Type_Names__c').getDescribe().getLabel());}
                if(crs.CRS_Product_Name__c == null){listOfFields.add(fieldMap.get('CRS_Product_Name__c').getDescribe().getLabel());}
                if(crs.CRS_Flavor_Names__c == null || crs.CRS_Flavor_Names__c == ''){listOfFields.add(fieldMap.get('CRS_Flavor_Names__c').getDescribe().getLabel());}
                if(crs.CRS_Brand__c == null){listOfFields.add(fieldMap.get('CRS_Brand__c').getDescribe().getLabel());}
                if(crs.CRS_Beverage_Category__c == null){listOfFields.add(fieldMap.get('CRS_Beverage_Category__c').getDescribe().getLabel());}
                if(crs.CRS_Package_Type_Names__c == null || crs.CRS_Package_Type_Names__c == ''){listOfFields.add(fieldMap.get('CRS_Package_Type_Names__c').getDescribe().getLabel());}
                if(crs.BBN__c == null || crs.BBN__c == ''){listOfFields.add(fieldMap.get('BBN__c').getDescribe().getLabel());}
                if(crs.CRS_Media_Type_Names__c == null || crs.CRS_Media_Type_Names__c == ''){listOfFields.add(fieldMap.get('CRS_Media_Type_Names__c').getDescribe().getLabel());}

                // Return error message
                if (listOfFields.size()==1){
                    return 'error:Please enter required field: ' + listOfFields.get(0);
                } else if(listOfFields.size()>1) {
                    return 'error:Please enter required fields: ' + String.join(listOfFields, ', ');
                }
        return null;
    }
    
    //++ crs enhancement
    public static String validateAttachments(CRS__c crs){
        /*List<CRS_ContentWrapper__c> dossiers = [Select Document_Type__c, CRS__c From CRS_ContentWrapper__c WHERE 
                CRS__c=:crs.Id AND (Document_Type__c='Draft Dossier' OR Document_Type__c='Final Dossier') LIMIT 1];*/
        List<CRS_ContentWrapper__c> documents = [Select Document_Type__c, CRS__c From CRS_ContentWrapper__c WHERE 
                CRS__c=:crs.Id AND (Document_Type__c='Draft Document' OR Document_Type__c='Final Document') LIMIT 1];
        if (documents.isEmpty()){
            return 'error:CRS Attachments section should contain at least one Draft Document to be approved.'
                    +((documents.isEmpty())?' Document is missed.':'');
        }
        return null;
    }

    private static void rejectCRSAutomatically(String crsId){
        // Get pending instances
        List<ProcessInstance> instances = [Select Id, TargetObjectId, Status From ProcessInstance Where TargetObjectId=:crsId and Status='Pending'];

        List<CRS__c> crsList = [SELECT Id, Name, CRS_Review__c, DontSend_StatusChange_Notification__c FROM CRS__c WHERE Id=:crsId ];
        if(crsList.isEmpty()){return;}

        if (instances.size() != 0){
            // Find workitem
            List<ProcessInstanceWorkitem> workItems = [Select Id, ProcessInstanceId, OriginalActorId, ActorId From ProcessInstanceWorkitem Where ProcessInstanceId=:instances.get(0).Id];

            if (workItems.size() != 0){
                crsList[0].DontSend_StatusChange_Notification__c = 'DontSend';
                update crsList;
                // Reject CRS
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Abandon/Disapprove actions reject CRS automatically.');
                req.setAction('Reject');
                req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                req.setWorkitemId(workItems.get(0).Id);

                // Submit the request for reject
                Approval.ProcessResult result =  Approval.process(req);
            }
            List<CRS_Message__c> crsMessages = [select Id from CRS_Message__c where CRS__c = :crsId];
            if(!crsMessages.isEmpty()){
                delete crsMessages;
            }
            
            if(crsList[0].CRS_Review__c != null){
                CRS_Review__c review = [SELECT Id, Review_Status__c FROM CRS_Review__c WHERE Id=:crsList[0].CRS_Review__c ][0];
                review.Review_Status__c = 'Review Completed';
                update review;
            }
        }
    }

 @RemoteAction
    webService static String validateCRSBeforeApprove(String crsId) {
        CRS__c crs = [SELECT Id, Process_Flow__c, Status__c, Internal_Status__c, Send_VP_Chief__c, Send_VP_Science__c FROM CRS__c WHERE Name=:crsId LIMIT 1];
        if (crs.Status__c == CRS_CRSEdit.CRS_Status_UnderReview){
            return Label.CRS_WrongStatusForApproveCRS;
        }
        String validationMessage = validateFinalAttachments(crs);
        if (validationMessage != null){
            return validationMessage;
        }
        validationMessage = validateAttachments(crs);
        if (validationMessage != null){
            return validationMessage;
        }
        return null;
    }
    
    public static String validateFinalAttachments(CRS__c crs){
        
        if(
            ((crs.Process_Flow__c == CRS_CRSEdit.PROCESS_FLOW_FULL_REVIEW_NOTIFICATION || crs.Process_Flow__c == CRS_CRSEdit.PROCESS_FLOW_FULL_REVIEW_NON_COKE 
            || crs.Process_Flow__c == CRS_CRSEdit.PROCESS_FLOW_GVW_FULL_REVIEW || crs.Process_Flow__c==CRS_CRSEdit.PROCESS_FLOW_FULL_REVIEW_PAC_NON_COKE 
            ||crs.Process_Flow__c==CRS_CRSEdit.PROCESS_FLOW_FULL_REVIEW_NOTIFICATION_PAC) 
                 && (crs.Internal_Status__c == APPROVAL_STEP_CORPSRA )
            )
            || (crs.Process_Flow__c == CRS_CRSEdit.PROCESS_FLOW_GVW_FULL_REVIEW && crs.Internal_Status__c == APPROVAL_STEP_VPCHIEF)
            || ((crs.Process_Flow__c == CRS_CRSEdit.PROCESS_FLOW_FULL_REVIEW_COKE || crs.Process_Flow__c == CRS_CRSEdit.PROCESS_FLOW_FULL_REVIEW_PAC_COKE)
                    && ((crs.Send_VP_Science__c == 'Yes' && crs.Internal_Status__c == APPROVAL_STEP_VPSCIENCEDIVISION)
                        || crs.Internal_Status__c == APPROVAL_STEP_CORPFORMULAGOVERN)
                )
            || (crs.Process_Flow__c == CRS_CRSEdit.PROCESS_FLOW_NOTIFICATION && crs.Internal_Status__c == APPROVAL_STEP_FIELDSRA)
        ) {
            /*List<CRS_ContentWrapper__c> dossiers = [Select Document_Type__c, CRS__c From CRS_ContentWrapper__c WHERE 
                    CRS__c=:crs.Id AND Document_Type__c='Final Dossier' LIMIT 1];*/
            List<CRS_ContentWrapper__c> documents = [Select Document_Type__c, CRS__c From CRS_ContentWrapper__c WHERE 
                    CRS__c=:crs.Id AND Document_Type__c='Final Document' LIMIT 1];
            if (documents.isEmpty()){
                return Label.CRSAttachmentsNotFinal;
            }
        }
        return null;
    }
    
    public static String validateDossierInformation(CRS__c crs){
        list<CRS_Dossier__c> lstDossier = [select id,isSubmitted__c From CRS_Dossier__c WHERE 
                CRSDossierToCRS__c =:crs.Id LIMIT 1];
                
        if(lstDossier.size() > 0){
            Boolean dossiersSubmitted = [Select Id, isSubmitted__c From CRS_Dossier__c WHERE 
                CRSDossierToCRS__c =:crs.Id LIMIT 1].isSubmitted__c;
             if (!dossiersSubmitted){
                return 'error:Cannot Start Approval Process. Dossier must be completed before CRS submission.'; 
            }
        }      
        return null;
    }

    @RemoteAction
    webService static Boolean showReviewButton(String crsId){
        List<CRS__c> crsList = [SELECT Id, Name, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId ];
        List<CRS_Role__c> crsRole = [Select Id FROM CRS_Role__c WHERE User__r.Id=:UserInfo.getUserId() and (CRS_Corporate_Level__c='Yes' or gvwCRS_Corporate_Level__c='Yes')];
        List<Profile> prfList; 
        checkAdminProfiles();
        // 'Move to Review' Button is available for corporate users/higher and for 'InProcess' status
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            return (!crsRole.isEmpty() || 
                 isCRSBA || isCRSSA) 
                 && (crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess);
        }
        // Button is not available if CRS is not found
        return false;
    }
    
    @RemoteAction
    webService static Boolean showAbandonDisapproveButtons(String crsId){
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
    
    @RemoteAction
    webService static Boolean showSubmitForApprovalButton(String crsId){
        List<CRS__c> crsList = [SELECT Id, Name, Internal_Status__c, Status__c, OwnerId, Initiated_By__c FROM CRS__c WHERE Id=:crsId ];
        checkAdminProfiles();
        // 'Submit for Approval' Button is available for 'InProcess', Draft and New Submission statuses
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            return (isCRSBA || isCRSSA || crs.OwnerId==UserInfo.getUserId() || crs.Initiated_By__c==UserInfo.getUserId()) 
                && (crs.Status__c==CRS_CRSEdit.CRS_Status_InProcess || crs.Status__c==CRS_CRSEdit.CRS_Status_Draft ||  
                crs.Status__c==CRS_CRSEdit.CRS_Status_NewSubmission);
        }
        // Button is not available if CRS is not found
        return false;
    }
    
    
    
      @RemoteAction
    webService static Boolean showObsoleteButtons(String crsId){
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
    
    
     @RemoteAction
    webService static Boolean showReactivateButtons(String crsId){
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
    
    
    
    @RemoteAction
    webService static String abandon(String crsId){
        if (!showAbandonDisapproveButtons(crsId)){
            return 'error:CRS cannot be abandoned, because you do not have enough permissions or CRS Status does not allow abandon operation';
        }

        rejectCRSAutomatically(crsId);

        List<CRS__c> crsList = [SELECT Id, Name, CRS_Review__c, DontSend_StatusChange_Notification__c, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId ];
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            crs.Status__c = 'Abandoned';
            crs.DontSend_StatusChange_Notification__c = null;
            update crs;
            return '';
        }
        return 'error:Impossible to find CRS with id '+crsId;
    }
    
    @RemoteAction
    webService static String disapprov(String crsId){
        if (!showAbandonDisapproveButtons(crsId)){
            return 'error:CRS cannot be disapproved, because you do not have enough permissions or CRS Status does not allow disapprove operation';
        }

        rejectCRSAutomatically(crsId);

        List<CRS__c> crsList = [SELECT Id, Name, CRS_Review__c, DontSend_StatusChange_Notification__c, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId ];
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            crs.Status__c = 'Disapproved';
            crs.DontSend_StatusChange_Notification__c = null;
            update crs;
            return '';
        }
        return 'error:Impossible to find CRS with id '+crsId;
    }
    
        @RemoteAction
    webService static String obsolete(String crsId){
        if (!showObsoleteButtons(crsId)){
            return 'error:CRS cannot be Obsolete, because you do not have enough permissions or CRS Status does not allow Obsolete operation';
        }

        //rejectCRSAutomatically(crsId);

        List<CRS__c> crsList = [SELECT Id, Name, CRS_Review__c, DontSend_StatusChange_Notification__c, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId ];
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            crs.Status__c = 'Approved-Obsolete';
            crs.DontSend_StatusChange_Notification__c = null;
            update crs;
            return '';
        }
        return 'error:Impossible to find CRS with id '+crsId;
    }
    
    
      @RemoteAction
    webService static String reactivate(String crsId){
        if (!showReactivateButtons(crsId)){
            return 'error:CRS cannot be Reactivate, because you do not have enough permissions or CRS Status does not allow reactivate operation';
        }

        //rejectCRSAutomatically(crsId);

        List<CRS__c> crsList = [SELECT Id, Name, CRS_Review__c, DontSend_StatusChange_Notification__c, Internal_Status__c,Internal_Status2__c, Status__c FROM CRS__c WHERE Id=:crsId ];
        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            crs.Status__c = 'Draft';
            crs.Internal_Status__c = 'BU Legal Approver';
            crs.Internal_Status2__c = 'NotStarted';
            crs.DontSend_StatusChange_Notification__c = null;
            crs.isReactivated__c = true;
            update crs;
            return '';
        }
        return 'error:Impossible to find CRS with id '+crsId;
    }

    @RemoteAction
    webService static String prepareForApproval(String crsId){
        List<CRS__c> crsList = [SELECT Id, Name, Status__c, Internal_Status__c, CRS_Business_Unit__c, CRS_Group__c,
            CRS_Country_Names__c, Package_Size__c, CRS_Type_Names__c, CRS_Product_Name__c, CRS_Flavor_Names__c, CRS_Brand__c, 
            CRS_Beverage_Category__c, CRS_Package_Type_Names__c, BBN__c, CRS_Media_Type_Names__c, Process_Flow__c,
            CRS_BU_Legal_Approver_Names__c,CRS_BU_PAC_Approver_Names__c, CRS_Field_SRA_Approver_Names__c, CRS_Corp_Food_Law_Approver_Names__c,
            CRS_Corp_Formula_Governance_Names__c, CRS_Corp_SRA_Approver_Names__c,CRS_Corporate_PAC_Approver_Names__c FROM CRS__c WHERE Id=:crsId ]; //added CRS_Corporate_PAC_Approver_Names__c to query by Ranjan 9th Oct'14

        if (crsList.size()!=0){
            CRS__c crs = crsList.get(0);
            System.debug('~~~crs: '+crs);

            if (crs.Status__c!=CRS_CRSEdit.CRS_Status_InProcess && crs.Status__c!=CRS_CRSEdit.CRS_Status_UnderReview && crs.Status__c!=CRS_CRSEdit.CRS_Status_Draft &&
                crs.Status__c!=CRS_CRSEdit.CRS_Status_NewSubmission){
                    return 'error:Incorrect CRS Status to submit CRS for approval.';
            }

            // VALIDATION
            String validationMessageForRequiredFields = validateRequiredFields(crs);
            if (validationMessageForRequiredFields != null){
                return validationMessageForRequiredFields;
            }
            String validateRequiredApprovalFields = validateApprovalFields(crs);
            if (validateRequiredApprovalFields != null){ 
                return validateRequiredApprovalFields;
            }
            if(!Test.isRunningTest()){
            String validationMessageForRequiredAttachments = validateAttachments(crs);
            if (validationMessageForRequiredAttachments != null){
                return validationMessageForRequiredAttachments;
            }
            }
            
            //++ crs Dossierenhancement
            if(!Test.isRunningTest()){ 
            String validateDossier = validateDossierInformation(crs);
            if (validateDossier != null){
                return validateDossier;
            }
            }
            //---
            
            String internalStatus = (String) crs.get('Internal_Status__c');
            String fieldName = getFieldNameWithApprovers(internalStatus);
            if (fieldName == null){
                return null;
            }
            crs = (CRS__c) Database.query('SELECT Id, Name, Internal_Status__c, '+fieldName+' FROM CRS__c WHERE Id=\''+crsId +'\'')[0];
        
            // Find queue or create it
            String queueName = crs.Name+internalStatus;
            system.debug('Queue Name in prepareforApproval'+queueName);
            List<Group> queues = [SELECT Id FROM Group WHERE Type='Queue' AND Name=:queueName];
            Group g = null;

            // Create queue, if it wasn't found
            if (queues.size() == 0){
                g = new Group(Name=queueName, Type='QUEUE');
                insert g;
            } else {
                g = queues.get(0);
            }

            // Remove prev memebers of queue, if any
            List<GroupMember> members = [SELECT Id FROM GroupMember WHERE GroupId=:g.Id];
            if (members.size() != 0){
                delete members;
            }

            // Add new memebers to queue
            
            String approvers = ((String)crs.get(fieldName));
            if (approvers == null || approvers.trim().length() == 0){
                return 'error:Approvers are not selected. Please edit CRS record and select Approvers.';
            }
            String[] ids = approvers.split(';');
            List<GroupMember> gm = new List<GroupMember>();
            for(String userId : ids){
                gm.add(new GroupMember(GroupId=g.Id, UserOrGroupId=userId));
            }
            insert gm;

            return g.Id;
        }
        return 'error:Impossible to find CRS with id '+crsId;
    }

    @RemoteAction
    webService static String submitForApproval(String crsId, String groupId){
        CRS__c crs = [SELECT Id, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId][0];
        
        Id ProceId;
        string comments;
        list<ProcessInstance> lstproc = [SELECT Id FROM ProcessInstance where TargetObjectId =:crsId ORDER BY CreatedDate DESC limit 1];
        if(lstproc.size() > 0){
            ProceId = lstproc[0].Id;
            comments = [select comments from ProcessInstanceStep where ProcessInstanceId =: ProceId ORDER By CreatedDate DESC limit 1].comments;
        }
        

        system.debug(comments+'comments+++'); 
        
        // Impossible to start Approval, if CRS was rejected
        if (crs.Status__c=='Rejected'){
            return 'error:Submission was rejected. Cannot start another approval process.';
        }
            
        // Create an approval request for the CRS
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submit request for '+crs.Internal_Status__c);
        req1.setObjectId(crsId);
        req1.setNextApproverIds(new Id[] {groupId}); // Assign to queue

        crs = [SELECT Id, Internal_Status__c, Status__c FROM CRS__c WHERE Id=:crsId][0];
        crs.Internal_Status2__c = 'Wait';
        if(comments != null){
            crs.Approval_Comments__c = comments;
        }
        
        CRS_AdminActions.updateCRS(crs);

        // Submit the approval request for the CRS
        try{
            Approval.ProcessResult result = Approval.process(req1);
        }catch(Exception e){
            System.debug('~~~Exception during starting Approval Process: ' + e);
            crs.Internal_Status2__c = 'RunNext';
            CRS_AdminActions.updateCRS(crs);
            return 'error:Cannot find appropriate Approval Process to start.';
        }

        return '';
    }

}