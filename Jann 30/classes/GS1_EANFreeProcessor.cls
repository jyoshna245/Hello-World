/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 16, 2013
* Description  :     A schedulable/batchable class used to free barcodes where related requests are withdrawn past the allowable timeframe
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

public class GS1_EANFreeProcessor
    implements Database.Batchable<sObject>,  Schedulable{
    
    String query = 'SELECT id from GS1_EAN__c where status__c=\'Allocated\'';        
    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);        
    }   
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext BC,  List<GS1_EAN__c> requests) {
        System.debug(GS1_Constants.GS1_DEBUG_SIG + 'GS1_EANFreeProcessor.execute STARTED');        
        System.debug(GS1_Constants.GS1_DEBUG_SIG + 'Batch size:' + String.valueOf(requests.size()));
        this.processRecords(requests, false, true);
        System.debug(GS1_Constants.GS1_DEBUG_SIG + 'GS1_EANFreeProcessor.execute ENDED');
    }
    
    public Map<id,String> processRecords(List<GS1_EAN__c> eanList, boolean ignoreThreshold, boolean deleteRequests) {
        System.debug(GS1_Constants.GS1_DEBUG_SIG + 'GS1_EANFreeProcessor.processRecords STARTED');
        Map<id,String> ret = new Map<id,String>();
        List<id> eanIds = new List<id>();       
        List<GS1_Request__c> reqs = null;
        Boolean addToFree = false;
        
        List<GS1_Request__c> reqsToDelete = new List<GS1_Request__c>();
        List<GS1_EAN__c> eansToFree = new List<GS1_EAN__c>();       
        
        Map<id, List<GS1_Request__c>> reqMap = new Map<id, List<GS1_Request__c>>();  
        Integer threshold = 26280;
        
        if (!ignoreThreshold) {
            if (Label.GS1_Free_Barcode_Threshold.isNumeric()) {
                threshold = Integer.valueOf(Label.GS1_Free_Barcode_Threshold);
            }
        }
        
        for (GS1_EAN__c ean: eanList) {
            eanIds.add(ean.id);     
        }
        
        for (GS1_Request__c req : [Select id, name, status__c, withdraw_date__c, EAN_Code__c from GS1_Request__c where EAN_Code__c IN :eanIds]) {
            reqs = reqMap.get(req.EAN_Code__c);
            if (reqs == null) {
                reqs = new List<GS1_Request__c>();              
            }           
            
            reqs.add(req);
            reqMap.put(req.EAN_Code__c, reqs);
        }
        
        for (GS1_EAN__c ean : eanList) {
            reqs = reqMap.get(ean.id);
            addToFree = true;
            if (reqs != null) {
                for (GS1_Request__c req : reqs) {
                    if (req.Status__c != GS1_Constants.REQUEST_STATUS_WITHDRAWN ) {
                        ret.put(ean.id , GS1_Constants.ERRMSG_BCF_REQ_UNWITHDRAWN);
                        System.debug(GS1_Constants.GS1_DEBUG_SIG + req.name + '/' + req.id + ': ' + GS1_Constants.ERRMSG_BCF_REQ_UNWITHDRAWN);
                        addToFree = false;
                        //break;
                    } else {
                        if (!ignoreThreshold) {
                            DateTime dt = DateTime.valueOf(req.Withdraw_Date__c);
                            dt = dt.addHours(threshold);            
                            System.debug(GS1_Constants.GS1_DEBUG_SIG + 'Computed date: ' + String.valueOf(dt));            
                            System.debug(GS1_Constants.GS1_DEBUG_SIG + 'System date: ' + String.valueOf(System.now()));
                            if (System.now() < dt ) {
                                ret.put(ean.id , GS1_Constants.ERRMSG_BCF_REQ_THRESHOLD);
                                System.debug(GS1_Constants.GS1_DEBUG_SIG + req.name + '/' + req.id + ': ' + GS1_Constants.ERRMSG_BCF_REQ_THRESHOLD);
                                addToFree = false;
                                //break;                            
                            }
                        }
                    }
                    
                    //addToFree = true;                
                    if (!addToFree) {
                        break;
                    }
                }
            }
            
            if (addToFree) {
                ean.Status__c = GS1_Constants.BARCODE_STAT_FREE;
                System.debug(GS1_Constants.GS1_DEBUG_SIG + ean.name + '/' + ean.id + ': will be freed');
                if (reqs != null) reqsToDelete.addall(reqs);
                eansToFree.add(ean);
            }           
        }
        
        if (eansToFree.size()>0) {
            System.debug(GS1_Constants.GS1_DEBUG_SIG + 'There are barcodes to free. Updating...');
            SavePoint sp = Database.setSavepoint();
            
            try {
                if (deleteRequests) {
                    for (GS1_Request__c req : reqsToDelete) {
                        req.Status__c = GS1_Constants.REQUEST_STATUS_INACTIVE;
                        req.EAN_Code__c = null;
                    }
                    update reqsToDelete;
                    delete reqsToDelete;
                }
                update eansToFree;
            } catch (Exception ex) {
                Database.rollback(sp);
                System.debug(GS1_Constants.GS1_DEBUG_SIG + 'Error occured: ' + ex.getMessage());
            }
        }
        
        System.debug(GS1_Constants.GS1_DEBUG_SIG + 'GS1_EANFreeProcessor.processRecords ENDED');
        return ret;
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }       
}