/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 23, 2013
* Description  :     A class used as controller for GS1 approval comment component
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

public class GS1_ApprCommentCtrl {

    public String getComments() {
        String ret = '';
        if (!String.isBlank(this.objectId )) {
            GS1_Request__c[] reqs = [SELECT Id, (SELECT comments FROM processSteps WHERE isDeleted = false ORDER BY SystemModStamp DESC limit 1) FROM GS1_Request__c where id=:objectId];
            if (reqs.size()>0) {
                GS1_Request__c res = reqs[0];
                if (res.processSteps.size()>0) {
                    ret = res.processSteps [0].comments;
                }
            } else {
                //mmm
            }
        }
        
        return ret;
    }

    public Id objectId {
        get;
        set;
    }
}