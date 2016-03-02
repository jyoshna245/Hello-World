/**
 */
@isTest
private class CRS_TestApproval {
    static testMethod void showReviewButton() {
        CRS__c crs = CRS_TestHelper.prepareDraftCRS();
        System.assert(CRS_Approval.showReviewButton(crs.Id)==false);
    }
    static testMethod void showSubmitForApprovalButton() {
        CRS__c crs = CRS_TestHelper.prepareDraftCRS();
        System.assert(CRS_Approval.showSubmitForApprovalButton(crs.Id)==true);
    }
    
    static testMethod void testAbandon() {
        CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
        CRS_Approval.abandon(crs.Id);
        crs = [SELECT Id, Status__c FROM CRS__c LIMIT 1];
        System.assert(crs.Status__c==CRS_CRSEdit.CRS_Status_Abandoned);
        System.debug('~~~crsAbandoned: '+crs);
    }
    
    static testMethod void testDisapproved() {
        CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
        CRS_Approval.disapprov(crs.Id);
        crs = [SELECT Id, Status__c FROM CRS__c LIMIT 1];
        System.assert(crs.Status__c==CRS_CRSEdit.CRS_Status_Disapproved);
        System.debug('~~~crsDisapproved: '+crs);
    }
    
    static testMethod void testObsolete() {
        CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
        crs.Status__c = CRS_CRSEdit.CRS_Status_Approved;
        update crs;
        CRS_Approval.obsolete(crs.Id);
        crs = [SELECT Id, Status__c FROM CRS__c LIMIT 1];
        System.assert(crs.Status__c=='Approved-Obsolete');
        System.debug('~~~crsObsolute: '+crs);
    }
    
    static testMethod void testReavtivate() {
        CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
        crs.Status__c = CRS_CRSEdit.CRS_Status_Abandoned;
        update crs;
        CRS_Approval.reactivate(crs.Id);
        crs = [SELECT Id, Status__c FROM CRS__c LIMIT 1];
        System.assert(crs.Status__c=='Draft');
        System.debug('~~~crsReactivate: '+crs);
    }

    static testMethod void validateAttachments() {
        CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
        String st = CRS_Approval.validateAttachments(crs);
        System.assert(st.indexOf('error')!=-1);
    }
	
    static testMethod void runApproval() {
        String st = null;
        CRS__c crs = null;
        User u = CRS_TestHelper.createSysAdmin();
        CRS_Role__c r = [Select crs_bu_legal_approver__c From CRS_Role__c where User__c = :u.Id and Business_Unit__r.Name = 'sysAdminTestBU' limit 1];
        System.assert(r != null);
        System.assert(r.crs_bu_legal_approver__c=='Yes');

        System.runAs(u) {
            CRS_CRSEdit editExtController = CRS_TestHelper.prepareCRSEdit();
            crs = (CRS__c) editExtController.stdController.getRecord();
            System.debug('~~~crs11: '+crs);

            st = CRS_Approval.prepareForApproval(crs.Id);
            System.assert(st!='error:Incorect CRS Status to submit CRS for approval.');
            System.assert(!st.contains('error:Please enter required field'));
            System.assert(!st.contains('error:Please enter required Approver'));
            System.assert(!st.contains('error:CRS Attachments section'));
            System.assert(!st.contains('error:Approvers are not selected.'));
            System.assert(!st.contains('error:Impossible to find CRS'));
            //System.assert(!st.contains('error:')); 
        }
        
            String st2 = CRS_Approval.submitForApproval(crs.Id, st);
            System.debug('~~~st2: '+st2);
            if (!'error:Cannot find appropriate Approval Process to start.'.equals(st2)){
                crs = [SELECT Id, Status__c FROM CRS__c LIMIT 1];
                System.assert(crs.Status__c==CRS_CRSEdit.CRS_Status_NewSubmission);
            }
            
            CRS_Approval.disapprov(crs.Id);
    }
    
    static testMethod void textValidateCRSBeforeApprove() {

    	 CRS__c crs = CRS_TestHelper.prepareDraftCRS();
    	 crs.Name = 'testName';
    	 update crs;
    	 CRS_TestHelper.prepareContentWrapper('Final Dossier', crs.Id);
    	 CRS_TestHelper.prepareContentWrapper('Final Document', crs.Id);

    	 String st = CRS_Approval.validateCRSBeforeApprove(crs.Name);
    	 System.assert(st == null, st);
    }
    
    static testMethod void testValidateFinalAttachments() {

    	 CRS__c crs = CRS_TestHelper.prepareDraftCRS();
    	 crs.Process_Flow__c = CRS_CRSEdit.PROCESS_FLOW_NOTIFICATION;
    	 crs.Internal_Status__c = CRS_Approval.APPROVAL_STEP_FIELDSRA;
 
    	 update crs;
    	 CRS_TestHelper.prepareContentWrapper('Final Dossier', crs.Id);
    	 CRS_TestHelper.prepareContentWrapper('Final Document', crs.Id);
    	 
    	 String st = CRS_Approval.validateFinalAttachments(crs);
    	 System.assert(st == null, st);
    }
    
    static testMethod void validateDossierinfosrmation() {
        CRS__c crs = CRS_TestHelper.prepareUnderReviewCRS();
        String st = CRS_Approval.validateDossierInformation(crs);
        System.assert(st.indexOf('error')!=-1);
    }
    

}