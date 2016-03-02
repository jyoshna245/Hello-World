/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     A class to access approval process of an object via APEX
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*
*/

public with sharing virtual class GS1_ApprovalProcess {
    private sObject p_object;
    private String lastError = '';
    
    public String getLastErrorMessage() {
        return this.lastError;
    }
    
    public GS1_ApprovalProcess(SObject obj){
        String query = 'SELECT Id, (SELECT processinstanceid, actorid FROM processSteps WHERE stepstatus = \'Pending\' AND isDeleted = false) FROM ' + obj.getSObjectType().getDescribe().getName() + ' where id = \'' + obj.id +'\'';
        SObject o = Database.query(query);
        this.p_object = o;
    } 
    
    public SObject relatedObject {
        get {return this.p_object; }
    }
    
    public Id getCurrentWorkItemId() {
        Id ret;
        ProcessInstanceHistory[] detail = this.relatedObject.getSObjects('ProcessSteps');
        if (detail != null) {
            ProcessInstanceWorkitem[] piw = [SELECT id From ProcessInstanceWorkitem WHERE processinstanceid =: detail[0].processinstanceid];
            if (piw != null) {
                if (piw.size()>0) ret = piw[0].id;
            }
        }
        return ret;
    }
    
    public boolean decide(String decision, String comment) {
        if (this.getCurrentWorkItemId()==null) {
            this.lastError = 'Item has not been submitted for approval';
            return false;
        }
        Approval.Processworkitemrequest req = new Approval.Processworkitemrequest();
        req.setAction(decision);
        req.setComments(comment);
        req.setNextApproverIds(null);
        req.setWorkitemId(this.getCurrentWorkItemId());
        Approval.ProcessResult result = Approval.process(req);
        
        this.lastError = '';
        
        if (result.getErrors()!=null) {
            if (result.getErrors().size()>0) {
                Database.Error err = result.getErrors()[0];
                this.lastError = err.getMessage();
            }
        }
        return result.isSuccess();
    }
    
    public boolean submit(String comment) {
        boolean ret = false;
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments(comment);
        req.setObjectId(relatedObject.id);
        try {
            Approval.ProcessResult result = Approval.process(req);
            ret = result.isSuccess();
        } catch (System.DmlException e) {
            if (e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                this.lastError = e.getDmlMessage(0);
            } else {
                System.debug(GS1_Constants.GS1_DEBUG_SIG + e.getMessage());
                this.lastError = 'Error occured while submitting the request for approval. It may have been already submitted.';
            }           
        } 
        return ret;
    } 
}