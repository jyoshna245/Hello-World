/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 11, 2013
* Description  :     A class containing all GS1 objects related triggers
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

public without sharing class GS1_ObjectsTriggerProcessor
{
    public static Map<Id,Boolean> trapDuplicate(List<SObject> triggerNew, Map<Id,SObject> triggerOldMap, String fieldName, boolean isInsert, String message) {
        String sObjectName = triggerNew[0].getSObjectType().getDescribe().getName();
        String val = '';
        Map<Id,Boolean> resultById = new Map<Id,Boolean>();
        Map<String, SObject> objMap = new Map<String, SObject>();
        for (SObject o : triggerNew) {
            val = ((String)o.get(fieldName)).toupperCase();      
            if (( val != null) && (isInsert || (val != triggerOldMap.get((Id)o.get('Id')).get(fieldName)))) {  
                if (objMap.containsKey(val)) {
                    resultById.put((Id)o.get('Id'),true);
                    o.addError(message);
                } else {                    
                    objMap.put(val, o);
                }
           }
        }
        
        
        Set<String> keys = objMap.KeySet();
        
        String query = 'SELECT id,' + fieldName + ' FROM ' + sObjectName + ' WHERE ' + fieldName + ' IN :keys';
        for (SObject o : database.query(query)) {
            val = ((String)o.get(fieldName)).toupperCase();
            sObject newO = objMap.get(val);
            newO.addError(message);
            resultById.put((Id)newO.get('Id'),true);
        }       
        
        return resultById;
    }   
    
    public static Map<Id,Boolean> trapDuplicateCS(List<SObject> triggerNew, Map<Id,SObject> triggerOldMap, String fieldName, boolean isInsert, String message) {
        String sObjectName = triggerNew[0].getSObjectType().getDescribe().getName();
        String val = '';
        Map<Id,Boolean> resultById = new Map<Id,Boolean>();
        Map<String, SObject> objMap = new Map<String, SObject>();
        for (SObject o : triggerNew) {            
            val = ((String)o.get(fieldName));      
            if (( val != null) && (isInsert || (val != triggerOldMap.get((Id)o.get('Id')).get(fieldName)))) {  
                if (objMap.containsKey(val)) {
                    resultById.put((Id)o.get('Id'),true);
                    o.addError(message);
                } else {
                    objMap.put(val, o);
                }
           }
        }
        
        
        Set<String> keys = objMap.KeySet();
        
        String query = 'SELECT id,' + fieldName + ' FROM ' + sObjectName + ' WHERE ' + fieldName + ' IN :keys';
        for (SObject o : database.query(query)) {
            val = ((String)o.get(fieldName));
            sObject newO = objMap.get(val);
            newO.addError(message);
            resultById.put((Id)newO.get('Id'),true);
        }       
        
        return resultById;
    }       
        
    public static Map<Id,Boolean> trapChangeValueIfUsedInRequest(List<SObject> triggerNew, Map<Id,SObject> triggerOldMap, String fieldName, String fieldInRequest, String message) {
        SObject old;
        Map<Id,Boolean> resultById = new Map<Id,Boolean>();
        Map<Id,SObject> toCheckMap = new Map<Id,SObject>();
        for (SObject value : triggerNew) {
            old = triggerOldMap.get(value.id);
            if (old.get(fieldName) != value.get(fieldName)) {
                toCheckMap.put(value.id, value);
            }
            resultById.put(value.id, false);            
        }
                
        Map<Id,SObject> errorList = new Map<Id,SObject>();
        List<Id> keys = new List<Id>();
        keys.addAll(toCheckMap.keySet());
        String query = 'select ' + fieldInRequest + ' from GS1_Request__c where ' + fieldInRequest + ' IN :keys';
        System.debug(GS1_Constants.GS1_DEBUG_SIG + query);
        for (GS1_Request__c prod : Database.query(query)) {
            Id pid = (id)prod.get(fieldInRequest);
            errorList.put(pid, toCheckMap.get(pid));
        }
        
        for (String key : errorList.keySet()) {
            SObject v = errorList.get(key);
            resultById.put(Id.valueOf(key), false);     
            v.addError( message );
        }       
        
        return resultById;
    }
    
    public static void setOwnerToAdmin(sObject[] records) {
        for (sObject s : records) {
            s.put('OwnerId', Label.GS1_AdminQueueId);
        }
    }
    
    //trigger related manipulation for GS1_Country__c object must be handled here!!!
    public class CountryTriggerProcessor 
    {   
        public void beforeInsert(sObject[] records) {   
            GS1_ObjectsTriggerProcessor.trapDuplicate(records, null, 'Name', true, GS1_Constants.ERRMSG_COUNTRY_NODUP);
            GS1_ObjectsTriggerProcessor.setOwnerToAdmin(records);
            
            GS1_SharingProcessor.createUpdateGroupsForCountry(records);
        }
        
        public void afterInsert(GS1_Country__c[] records) {        
            Set<Id> cIds = new Set<Id>();
            for (GS1_Country__c c : records) {
                cIds.add(c.id);
            }
            
            GS1_SharingProcessor.updateAuthorAccess(cids);
            GS1_SharingProcessor.updateCountrySharing(records);
            GS1_SharingProcessor.updateRequestSharingByCountry(records);
        }
        
        public void beforeUpdate(GS1_Country__c[] records, Map<Id, sObject>oldMap) {
            GS1_ObjectsTriggerProcessor.trapDuplicate(records, OldMap, 'Name', false, GS1_Constants.ERRMSG_COUNTRY_NODUP);
            GS1_ObjectsTriggerProcessor.setOwnerToAdmin(records);
            
            GS1_SharingProcessor.createUpdateGroupsForCountry(records);
        }
        
        public void afterUpdate(GS1_Country__c[] records, Map<Id, sObject>oldMap) {    
            Set<Id> cIds = new Set<Id>();
            for (GS1_Country__c c : records) {
                cIds.add(c.id);
            }
                        
            GS1_SharingProcessor.updateAuthorAccess(cids);
            GS1_SharingProcessor.updateCountrySharing(records);
            GS1_SharingProcessor.updateRequestSharingByCountry(records);            
        }   
        
        public void beforeDelete(sObject[] records) { //pass the old list    
            //not handled; not needed    
        }
        
        public void afterDelete(GS1_Country__c[] records) { //pass the old list    
            Set<Id> groupIds = new Set<id>();
            for (GS1_Country__c ctry : records) {
                if (!String.isBlank(ctry.Country_Requests_Editor__c)) {
                    groupIds.add(ctry.Country_Requests_Editor__c);
                }
                
                if (!String.isBlank(ctry.Country_Requests_Reader__c)) {
                    groupIds.add(ctry.Country_Requests_Reader__c);
                }               
            }
            
            if (groupIds.size()>0) {
                GS1_SharingProcessor.removeGroups(groupIds);
            }
            
        }               
    }
    
    //trigger related manipulation for GS1_Request__c object must be handled here!!!
    public class RequestTriggerProcessor
    {
        public void beforeInsert(GS1_Request__c[] records) {
            Map<Id,GS1_AuthorProfile__c> authors = new Map<Id,GS1_AuthorProfile__c>();
            List<Id> creatorIds = new List<Id>();  
            GS1_AuthorProfile__c author;
            Set<String> bbnFormula = new Set<String>();                    
             
            for (GS1_Request__c rec : records) {
                if (rec.RequestedByUserId__c == null) {
                    rec.RequestedByUserId__c = System.UserInfo.getUserId();
                }
                rec.OwnerId = Label.GS1_AdminQueueId;
                creatorIds.add( rec.RequestedByUserId__c);          
                if (rec.status__c==GS1_Constants.REQUEST_STATUS_NEW) {
                    rec.Requested_By__c = System.UserInfo.getName();
                }
                
                if (!String.isEmpty(rec.bbn_formula__c)) {
                    bbnFormula.add(rec.bbn_formula__c);
                }                
            }
            
            for (GS1_AuthorProfile__c au : [select id, User__c from GS1_AuthorProfile__c where (User__c IN :creatorIds) AND Active__c=true]) {
                authors.put( au.User__c, au);           
            }
            
            Map<String, GS1_BBN__c> bbnMap = new Map<String, GS1_BBN__c>();            
            Map<String, List<String>> bbnShortList = new Map<String, List<String>>();
            
            if (bbnFormula.size()>0) {
                GS1_BBN__c[] bbns = [select id, name, code__c from GS1_BBN__c where name IN :bbnFormula];                
                
                for (GS1_BBN__c bbn : bbns) {
                    String key = bbn.name.toLowerCase();                    
                    bbnMap.put(key, bbn);
                    if (!bbnShortList .containsKey(key)) {
                        bbnShortList.put(key, new List<String>());
                    } 
                    bbnShortList.get(key).add(bbn.Code__c);
                }
            }            
            
            for (GS1_Request__c rec : records) {
                author = authors.get(rec.RequestedByUserId__c);
                if (author != null) {
                    rec.author_profile__c = author.Id;                
                } else {
                    rec.addError( GS1_Constants.ERRMSG_AUTHOR_NOTFOUND );
                }
                
                if (!String.isEmpty(rec.bbn_formula__c)) {
                    String key = rec.bbn_formula__c.toLowerCase();
                    
                    if (bbnMap.containsKey(key)) {
                        rec.BBN_Short__c = bbnMap.get(key).Code__c;
                        rec.BBN__c = bbnMap.get(key).id;
                        rec.BBN_Formula__c = bbnMap.get(key).name;
                    }                
                    
                    if (bbnShortList.containsKey(key)) {
                        if (bbnShortList.get(key).size()>0) {
                            rec.BBN_Short__c = String.join(bbnShortList.get(key),'; ');
                        }                    
                    }
                }
            }                           
        }
        
        public void afterInsert(GS1_Request__c[] records) {
            GS1_SharingProcessor.updateRequestSharing(records);
        }
        
        public void beforeUpdate(GS1_Request__c[] records, Map<Id, GS1_Request__c>oldMap) {
            Map<Id,GS1_AuthorProfile__c> authors = new Map<Id,GS1_AuthorProfile__c>();
            List<Id> creatorIds = new List<Id>();  
            GS1_AuthorProfile__c author;
            Set<String> bbnFormula = new Set<String>();         
                        
            GS1_Request__c oldRec = null;
            List<GS1_Request__c> reqsToSubmit = new List<GS1_Request__c>();
                    
            for (GS1_Request__c rec : records) {
                
                rec.OwnerId = Label.GS1_AdminQueueId;
                oldRec = oldMap.get( rec.id );                                 
                
                if (oldRec.bbn_formula__c != rec.bbn_formula__c) {
                    if (!String.isEmpty(rec.bbn_formula__c)) {
                        bbnFormula.add(rec.bbn_formula__c);
                        rec.BBN_Short__c = null;
                        rec.BBN__c = null;
                    }
                }                              
                
                if (oldRec.Status__c == GS1_Constants.REQUEST_STATUS_REQUESTED) {
                    
                    if ( rec.Status__c == GS1_Constants.REQUEST_STATUS_APPROVED) {                      
                        rec.Approved_By__c = system.Userinfo.getUserId();
                        rec.Approval_Date__c = system.now();
                    }
                    
                    if ( rec.Status__c == GS1_Constants.REQUEST_STATUS_ALLOCATED) {
                        rec.Approved_By__c = system.Userinfo.getUserId();
                        rec.Approval_Date__c = system.now();
                    }               
                    
                    if ( rec.Status__c == GS1_Constants.REQUEST_STATUS_REJECTED) {
                        rec.Rejected_By__c = system.Userinfo.getUserId();
                        rec.Reject_Date__c = system.now();
                    }                                               
                }
                
                if (oldRec.Status__c == GS1_Constants.REQUEST_STATUS_ALLOCATED) {
                    if ( rec.Status__c == GS1_Constants.REQUEST_STATUS_WITHDRAWN) {
                        rec.Withdrawn_By__c = system.Userinfo.getUserId();
                        rec.Withdraw_Date__c = system.now();
                    }               
                }
                
                if (oldRec.status__c == GS1_Constants.REQUEST_STATUS_NEW || oldRec.status__c == GS1_Constants.REQUEST_STATUS_REJECTED) {
                    if (rec.status__c == GS1_Constants.REQUEST_STATUS_REQUESTED) {
                        //just submitted
                        //reset fields
                        rec.Approved_By__c = null;
                        rec.Approval_Date__c = null;     
                        rec.Withdrawn_By__c = null;
                        rec.Withdraw_Date__c = null;
                        rec.Rejected_By__c = null;
                        rec.Reject_Date__c = null;
                        rec.Requested_Date__c = system.now();                                                               
                        //rec.RequestedById__c = System.UserInfo.getUserId();
                        rec.RequestedByUserId__c = System.UserInfo.getUserId();
                        rec.Requested_By__c = System.UserInfo.getName();
                        rec.Cancelled__c = false;     
                        
                        reqsToSubmit.add(rec);                                                 
                    }
                }           
            }
            
            Map<String, GS1_BBN__c> bbnMap = new Map<String, GS1_BBN__c>(); 
            Map<String, List<String>> bbnShortList = new Map<String, List<String>>();          
            
            if (bbnFormula.size()>0) {
                GS1_BBN__c[] bbns = [select id, name, code__c from GS1_BBN__c where name IN :bbnFormula];                
                
                for (GS1_BBN__c bbn : bbns) {
                    String key = bbn.name.toLowerCase();                    
                    bbnMap.put(key, bbn);
                    if (!bbnShortList .containsKey(key)) {
                        bbnShortList.put(key, new List<String>());
                    } 
                    bbnShortList.get(key).add(bbn.Code__c);
                }
            }
            
            for (GS1_Request__c rec : records) {
                if (oldRec.bbn_formula__c != rec.bbn_formula__c) {
                
                    if (!String.isEmpty(rec.bbn_formula__c)) {
                        String key = rec.bbn_formula__c.toLowerCase();
                        
                        if (bbnMap.containsKey(key)) {
                            rec.BBN_Short__c = bbnMap.get(key).Code__c;
                            rec.BBN__c = bbnMap.get(key).id;
                            rec.BBN_Formula__c = bbnMap.get(key).name;
                        }                
                        
                        if (bbnShortList.containsKey(key)) {
                            if (bbnShortList.get(key).size()>0) {
                                rec.BBN_Short__c = String.join(bbnShortList.get(key),'; ');
                            }                    
                        }                    
                    }
                }
            }                
            
            if (reqsToSubmit.size()>0) { 
                creatorIds.add( System.UserInfo.getUserId() );
                for (GS1_Request__c rec : reqsToSubmit) {
                    creatorIds.add( rec.RequestedByUserId__c);
                }            
                
                for (GS1_AuthorProfile__c au : [select id, User__c from GS1_AuthorProfile__c where (User__c IN :creatorIds) AND Active__c=true]) {
                    authors.put( au.User__c, au);           
                }       
                
                for (GS1_Request__c rec : reqsToSubmit) {
                    author = authors.get(System.UserInfo.getUserId());
                    if (author != null) {
                        author = authors.get(rec.RequestedByUserId__c);
                        if (author != null) {
                            rec.author_profile__c = author.Id;                
                        } else {
                            rec.addError( GS1_Constants.ERRMSG_AUTHOR_NOTFOUND );
                        }
                    }
                    else {
                        rec.addError( GS1_Constants.ERRMSG_AUTHOR_NOTFOUND );
                    }
                }                       
            }
            
            setLongShort(records, oldMap);
            tagAllocatedBarcodes(records, oldMap);
        }
        
        public void afterUpdate(GS1_Request__c[] records, Map<Id, GS1_Request__c>oldMap) {
            final string INACTIVE_VALUE_MESSAGE = 'Value is not active';
            GS1_Request__c[] modifiedRequests = new List<GS1_Request__c>();
            Set<id> errorSet = new Set<Id>();
            Map<Id,GS1_Request__c> recMap = new Map<Id,GS1_Request__c>(records);
            
            GS1_Request__c[] reqs = [SELECT Id, Country__r.active__c,Promo_Quantity__r.active__c, BBN__r.active__c, Capacity__r.active__c, Design__r.active__c, Flavour__r.active__c, Material__r.active__c, Multipack__r.active__c, Promo_Other__r.active__c, Pallet_Design__r.active__c, Pallet_Material__r.active__c, Promo_Currency__r.active__c, Trademark__r.active__c, Units_Pack__r.active__c from GS1_Request__c where Id IN :recMap.keySet()];
            for (GS1_Request__c req : reqs ) {
                GS1_Request__c treq = recMap.get(req.id);
                if (treq.Status__c != GS1_Constants.REQUEST_STATUS_ALLOCATED) {
                    if ((treq.country__c != null) && (req.country__r.active__c==false)) {
                        treq.country__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }
                    if ((treq.Promo_Quantity__c !=null) && (req.Promo_Quantity__r.active__c==false)) {
                        treq.Promo_Quantity__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }         
                    if ((treq.bbn__c != null) && (req.BBN__r.active__c==false)) {       
                        treq.bbn__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }                
                    if ((treq.Capacity__c != null) && (req.Capacity__r.active__c==false)) {       
                        treq.Capacity__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }  
                    if ((treq.Design__c != null) && (req.Design__r.active__c==false)) {       
                        treq.Design__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }      
                    if ((treq.Flavour__r != null) && (req.Flavour__r.active__c==false)) {       
                        treq.Flavour__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }  
                    if ((treq.Material__c != null) && (req.Material__r.active__c==false)) {       
                        treq.Material__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }  
                    if ((treq.Multipack__c != null) && (req.Multipack__r.active__c==false)) {       
                        treq.Multipack__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }  
                    if ((treq.Promo_Other__r != null) && (req.Promo_Other__r.active__c==false)) {       
                        treq.Promo_Other__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }  
                    if ((treq.Pallet_Design__c != null) && (req.Pallet_Design__r.active__c==false)) {       
                        treq.Pallet_Design__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }
                    if ((treq.Promo_Currency__c != null) && (req.Promo_Currency__r.active__c==false)) {       
                        treq.Promo_Currency__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }
                    if ((treq.Trademark__c != null) && (req.Trademark__r.active__c==false)) {       
                        treq.Trademark__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    } 
                    if ((treq.Units_Pack__c != null) && (req.Units_Pack__r.active__c==false)) {       
                        treq.Units_Pack__c.addError(INACTIVE_VALUE_MESSAGE);
                        errorSet.add(treq.id);
                    }                   
                }                            
            }            
            
            for (GS1_Request__c req : records) {
                if (req.country__c !=oldMap.get(req.id).country__c || (req.status__c == GS1_Constants.REQUEST_STATUS_ALLOCATED && oldMap.get(req.id).status__c != GS1_Constants.REQUEST_STATUS_ALLOCATED) || (req.status__c != GS1_Constants.REQUEST_STATUS_ALLOCATED && oldMap.get(req.id).status__c == GS1_Constants.REQUEST_STATUS_ALLOCATED)) {
                    if (!errorSet.contains(req.id)) {
                        modifiedRequests.add(req);
                    }
                }
            }            
            
            if (modifiedRequests.size()>0) GS1_SharingProcessor.updateRequestSharing(modifiedRequests);
        }           
        
        public void beforeDelete(sObject[] records) { //pass the old list    
            //not handled; not needed    
        }
        
        public void afterDelete(sObject[] records) { //pass the old list    
            //not handled; not needed    
        }
        
        private void tagAllocatedBarcodes(GS1_Request__c[] records, Map<Id, GS1_Request__c>oldMap) {
            List<String> barcodeIDs = new List<String>();
            GS1_EAN__c[] barcodes = new List<GS1_EAN__c>();
            GS1_Request__c oldReq;
            
            for (GS1_Request__c req : records) {
                oldReq = oldMap.get(req.id);
                if (String.isBlank(oldReq.EAN_Code__c)) {
                    if (!String.isBlank(req.EAN_Code__c)) {
                        barcodeIDs.add(req.EAN_Code__c);
                    }
                }
            }
            
            if (barcodeIDs.size()>0) {
                for (GS1_EAN__c ean : [select id, status__c from GS1_EAN__c where id IN :barcodeIDs]) {                    
                    ean.Status__c = GS1_Constants.BARCODE_STAT_NOTFREE;
                    barcodes.add(ean);
                }                
                update barcodes;
            }
        }        
        
        private void setLongShort(GS1_Request__c[] records, Map<Id, GS1_Request__c>oldMap) {
            GS1_Material__c material;
            GS1_Multipack_Value__c unitsPerPack;
            GS1_Unit_Capacity__c capacity;
            GS1_Unit__c unit;
            GS1_Trademark__c trademark;
            
            Set<Id> matIds = new Set<id>();
            Set<Id> uppIds = new Set<id>();
            Set<Id> capIds = new Set<id>();
            Set<Id> tmkIds = new Set<id>();
            Set<Id> untIds = new Set<id>();
                        
            Map<id, GS1_Request__c> newMap = new Map<id, GS1_Request__c>();
            GS1_Request__c oldRec;
            
            for (GS1_Request__c rec : records) {
                oldRec = oldMap.get(rec.id);                
                if (rec.Material__c != oldRec.Material__c ||
                    rec.Capacity__c != oldRec.Capacity__c ||
                    rec.Units_Pack__c != oldRec.Units_Pack__c || 
                    rec.Unit__c != oldRec.Unit__c || 
                    rec.Trademark__c != oldRec.Trademark__c || 
                    rec.Product_Type__c != oldRec.Product_Type__c ||
                    String.isBlank(rec.Long_Short__c)) {
                        //reqIds.add( rec.id);
                        newMap.put(rec.id, rec);
                        matIds.add(rec.Material__c);
                        uppIds.add(rec.Units_Pack__c );
                        capIds.add(rec.Capacity__c);
                        untIds.add(rec.Unit__c);
                        tmkIds.add(rec.Trademark__c);
                    }
                
            }
            
            Map<Id,GS1_Material__c> matsMap = new Map<Id,GS1_Material__c>([select id, code__c from GS1_Material__c where id IN :matIds]);
            Map<Id,GS1_Multipack_Value__c> pacsMap = new Map<Id,GS1_Multipack_Value__c>([select id, name from GS1_Multipack_Value__c where id IN :uppIds]);
            Map<Id,GS1_Unit_Capacity__c> capsMap = new Map<Id,GS1_Unit_Capacity__c>([select id, name from GS1_Unit_Capacity__c where id IN :capIds]);
            Map<Id,GS1_Trademark__c> tmksMap = new Map<Id, GS1_Trademark__c>([select id, code__c from GS1_Trademark__c where id IN :tmkIds]);
            Map<Id,GS1_Unit__c> untsMap = new Map<Id, GS1_Unit__c>([select id, code__c from GS1_Unit__c where id IN :untIds]);
            
            for (String key : newMap.keySet()) {
                GS1_Request__c rec = newMap.get(key);
                String value = '';
                capacity = null;
                material = null;
                unitsPerPack = null;
                unit = null;
                trademark = null;
                
                if (!String.isBlank(rec.Material__c)) {
                    if (matsMap.containsKey(rec.Material__c)) {
                        material = matsMap.get(rec.Material__c);
                    }
                }
                
                if (!String.isBlank(rec.Units_Pack__c)) {
                    if (pacsMap.containsKey(rec.Units_Pack__c)) {
                        unitsPerPack = pacsMap.get(rec.Units_Pack__c);
                    }
                }

                if (!String.isBlank(rec.Capacity__c)) {
                    if (capsMap.containsKey(rec.Capacity__c)) {
                        capacity = capsMap.get(rec.Capacity__c);
                    }
                }
                
                if (!String.isBlank(rec.Unit__c)) {
                    if (untsMap.containsKey(rec.Unit__c)) {
                        unit = untsMap.get(rec.Unit__c);
                    }
                }   
                
                if (!String.isBlank(rec.Trademark__c)) {
                    if (tmksMap.containsKey(rec.Trademark__c)) {
                        trademark = tmksMap.get(rec.Trademark__c);
                    }
                }                                                   
                
                //integer cp = 0;//integer.valueOf(rec.capacity__r.name);   
                //integer mc = 0;//integer.valueOf(rec.material__r.Code__c);
                //integer up = 0;//integer.valueOf(rec.Units_Pack__r.Name);
                
                decimal cp = (capacity != null && capacity.name.isnumeric()) ? decimal.valueOf(capacity.name) : 0;   
                decimal mc = (material != null && material.code__c.isnumeric()) ? decimal.valueOf(material.Code__c) : 0;
                decimal up = (unitsPerPack != null && unitsPerPack.name.isnumeric()) ? decimal.valueOf(unitsPerPack.Name) : 0;
                
                if (rec.Product_Type__c == 'Pallet') {
                    value = 'Long';
                } else if (unit != null && unit.Code__c == '2') {                    
                    value = 'Long';
                } else if (trademark != null && trademark.Code__c == '90') {
                    value = 'Long';
                } else if (mc < 3 && cp < 500 && up==1) {
                    value = 'Short';
                } else if (mc == 3 && cp <= 150 && up==1) {
                    value = 'Short';
                } else if (mc == 4 && cp < 500 && up==1) {
                    value = 'Short';
                }
                
                if (value == '') {
                    value = 'Long';
                }
                
                rec.Long_Short__c = value;
                    
            }
        }                       
    }
    
    //trigger related manipulation for GS1_EAN__c object must be handled here!!!
    public class EANTriggerProcessor
    {
        public void beforeInsert(GS1_EAN__c[] records) {   
            Map<Id,Boolean> withErrorMap = GS1_ObjectsTriggerProcessor.trapDuplicate(records, null, 'Name', true, GS1_Constants.ERRMSG_EAN_NODUP);
            for (GS1_EAN__c ean : records) {
                if (!withErrorMap.containsKey(ean.id)) {
                    if (String.valueOf(ean.name).length()!=13 && String.valueOf(ean.name).length()!=8) {
                        ean.addError('Barcode should be either 8 or 13 characters.');
                    }
                }   
            }
            
        }
        
        public void afterInsert(sObject[] records) {        
            //not handled; not needed
        }
        
        public void beforeUpdate(GS1_EAN__c[] records, Map<Id, GS1_EAN__c>oldMap) {
            Map<Id,Boolean> withErrorMap = GS1_ObjectsTriggerProcessor.trapDuplicate(records, oldMap, 'Name', false, GS1_Constants.ERRMSG_EAN_NODUP);
            for (GS1_EAN__c ean : records) {
                if (!withErrorMap.containsKey(ean.id)) {
                    if (String.valueOf(ean.name).length()!=13 && String.valueOf(ean.name).length()!=8) {
                        ean.addError('Barcode should be either 8 or 13 characters.');
                    } else {
                        if (ean.status__c != oldMap.get(ean.id).status__c) {
                            if (ean.status__c == GS1_Constants.BARCODE_STAT_FREE) {
                                ean.Freed__c = true;
                            }
                        }                    
                    }
                }   
            }
                        
        }
        
        public void afterUpdate(sObject[] records, Map<Id, sObject>oldMap) {    
            //not handled; not needed    
        }   
        
        public void beforeDelete(sObject[] records) { //pass the old list    
            //not handled; not needed    
        }
        
        public void afterDelete(sObject[] records) { //pass the old list    
            //not handled; not needed    
        }               
    }
    
    //trigger related manipulation for GS1_CountryAuthor__c object must be handled here!!!
    public class CountryAuthorProcessor
    {
        public void beforeInsert(sObject[] records) {   
            GS1_ObjectsTriggerProcessor.trapDuplicate(records, null, 'UniqueKey__c', true, GS1_Constants.ERRMSG_COUNTRY_EXISTS_IN_AUTHOR);
        }
        
        public void afterInsert(sObject[] records) {        
            processCountryAuthorUpdate(records);
        }
        
        public void beforeUpdate(sObject[] records, Map<Id, sObject>oldMap) {
            GS1_ObjectsTriggerProcessor.trapDuplicate(records, OldMap, 'UniqueKey__c', false, GS1_Constants.ERRMSG_COUNTRY_EXISTS_IN_AUTHOR);
        }
        
        public void afterUpdate(sObject[] records, Map<Id, sObject>oldMap) {    
            processCountryAuthorUpdate(records);
        }   
        
        public void beforeDelete(sObject[] records) { //pass the old list    
            //not handled; not needed    
        }
        
        public void afterDelete(sObject[] records) { //pass the old list    
            processCountryAuthorUpdate(records);
            
            Database.emptyRecycleBin(records);    
        }      
        
        private void processCountryAuthorUpdate(GS1_CountryAuthor__c[] records) {
            Set<Id> cIds = new Set<Id>();           
            for (GS1_CountryAuthor__c author : records) {
                cIds.add(author.country__c);
            }
            
            invokeCountryTriggers(cIds);                
        }               
    }
    
    public class AuthorProfileProcessor
    {
        public void beforeInsert(sObject[] records) {
            GS1_ObjectsTriggerProcessor.trapDuplicateCS(records, null, 'User__c', true, GS1_Constants.ERRMSG_AUTHOR_NODUP);
        }
        
        public void afterInsert(GS1_AuthorProfile__c[] records) {        
            Map<Id, GS1_AuthorProfile__c> profiles = new Map<Id, GS1_AuthorProfile__c>(records);
            //processProfileUserData(profiles.keySet(),true);    
            processProfileUserData( JSON.serialize(new GS1_SharingProcessor.JSONSObjectList(((List<SOBject>)records))),true,false);
        }
        
        public void beforeUpdate(GS1_AuthorProfile__c[] records, Map<Id, GS1_AuthorProfile__c>oldMap) {
            GS1_ObjectsTriggerProcessor.trapDuplicateCS(records, oldMap, 'User__c', false, GS1_Constants.ERRMSG_AUTHOR_NODUP);
            GS1_ObjectsTriggerProcessor.trapChangeValueIfUsedInRequest(records, oldMap, 'User__c', 'Author_Profile__c', GS1_Constants.ERRMSG_CANNOT_CHANGE_PROFILEUSER);
            for (GS1_AuthorProfile__c ap : records) {
                if (ap.user__c != oldMap.get(ap.Id).user__c) {
                    ap.addError( GS1_Constants.ERRMSG_AUTHOR_RELATEDUSERCHANGE );
                } else {
                    if (ap.user__c == UserInfo.getUserId()) {
                        if ( Userinfo.getProfileId() != Id.valueOf(Label.GS1_SystemAdministratorId) ) {
                            if (ap.Active__c != oldMap.get(ap.Id).active__c) {
                                ap.addError( GS1_Constants.ERRMSG_AUTHOR_OWNLEVELCHANGE );
                            } else if (ap.GS1_Administrator__c != oldMap.get(ap.id).GS1_Administrator__c) {
                                ap.addError( GS1_Constants.ERRMSG_AUTHOR_OWNLEVELCHANGE );
                            }
                        }
                    }
                }
            }
        }
        
        
        public void afterUpdate(GS1_AuthorProfile__c[] records, Map<Id, GS1_AuthorProfile__c>oldMap) {
            List<Id> profileIds = new List<Id>();
            Map<id,GS1_AuthorProfile__c> profiles = new Map<Id,GS1_AuthorProfile__c>();
            Boolean updateGS1Admin = true;        
            
            for (GS1_AuthorProfile__c prof : records) {
                if (prof.active__c != oldMap.get(prof.id).active__c || prof.GS1_Administrator__c != oldMap.get(prof.id).GS1_Administrator__c) {
                    //profileIds.add(prof.id);
                    profiles.put(prof.id, prof);
                }
            }
                
                
            //if (profileIds.size()>0) {
            if (profiles.values().size()>0) {    
                Set<Id> cIds = new Set<Id>(); 
                //for (AggregateResult ag : [SELECT Country__c from GS1_CountryAuthor__c where AuthorProfile__c IN :profileIds GROUP BY Country__c]) {
                for (AggregateResult ag : [SELECT Country__c from GS1_CountryAuthor__c where AuthorProfile__c IN :profiles.keySet() GROUP BY Country__c]) {                 
                    cIds.add( (Id)ag.get('Country__c'));
                    updateGS1Admin = false;
                }       
                
                invokeCountryTriggers(cIds);                
            }
            
            //processProfileUserData(profiles.keySet(),updateGS1Admin);
            processProfileUserData( JSON.serialize(new GS1_SharingProcessor.JSONSObjectList((List<SOBject>)profiles.values())),updateGS1Admin,false);
        }   
        
        public void beforeDelete(sObject[] records) { //pass the old list    
            //not handled; not needed    
        }
        
        public void afterDelete(GS1_AuthorProfile__c[] records) { //pass the old list           
            List<Id> profileIds = new List<Id>();
            Boolean updateGS1Admin = true;   
            
            for (GS1_AuthorProfile__c prof : records) {
                profileIds.add(prof.id);
            }
                
                
            if (profileIds.size()>0) {    
                Set<Id> cIds = new Set<Id>(); 
                for (AggregateResult ag : [SELECT Country__c from GS1_CountryAuthor__c where AuthorProfile__c IN :profileIds GROUP BY Country__c ALL ROWS]) {
                    cIds.add( (Id)ag.get('Country__c'));
                    updateGS1Admin = false;
                }       
                
                invokeCountryTriggers(cIds);
            }
            
            Map<Id, GS1_AuthorProfile__c> profiles = new Map<Id, GS1_AuthorProfile__c>(records);
            //processProfileUserData(profiles.keySet(),updateGS1Admin);
            processProfileUserData( JSON.serialize(new GS1_SharingProcessor.JSONSObjectList((List<SOBject>)records)),updateGS1Admin,true);
                                                
            Database.emptyRecycleBin(records);
        }      
    }    
    
    public static void invokeCountryTriggers(Set<Id >cIds) {
        if (cIds.size()>0) {
            GS1_Country__c[] countries = [select id from GS1_Country__c where id IN :cIds];
            update countries;           
        }
    }
    
    @future(callout=false)
    //public static void processProfileUserData( Set<Id> recordIds, boolean updateIsGS1Admin ) {
    public static void processProfileUserData( String data, boolean updateIsGS1Admin, boolean isDeleteMode ) {
        List<Id> userIds = new List<Id>();
        List<User> usersForUpdate = new List<User>();
        List<GroupMember> grpMembersToAdd = new List<GroupMember>();
        List<PermissionSetAssignment> psAssignmentToAdd = new List<PermissionSetAssignment>();
        
        GS1_SharingProcessor.JSONSObjectList jlist = (GS1_SharingProcessor.JSONSObjectList)JSON.deserialize(data, GS1_SharingProcessor.JSONSObjectList.class);      
        //List<GS1_AuthorProfile__c> records = [select isDeleted, id, Active__c, GS1_Administrator__c, user__c from GS1_AuthorProfile__c where id IN :recordIds ALL ROWS];      
        List<GS1_AuthorProfile__c> records = (List<GS1_AuthorProfile__c>) jlist.ObjectList;   
        List<Id> psIds = new List<Id>();
        
        psIds.add(id.valueOf(Label.GS1_Author_SFAdmin_PermissionSetID));            
        psIds.add(id.valueOf(Label.GS1_Author_SPAdmin_PermissionSetID));
        psIds.add(id.valueOf(Label.GS1_Author_SFUser_PermissionSetID));            
        psIds.add(id.valueOf(Label.GS1_Author_SPUser_PermissionSetID));     

        for (GS1_AuthorProfile__c profile : records) {
            userIds.add( profile.User__c );
        }
                     
        Map<Id, User> userMap = new Map<Id, User>([select Id, profileid, profile.name, profile.userlicense.name from user where id IN :userIds]);           
        
        for (GS1_AuthorProfile__c profile : records) {
            User u = userMap.get(profile.user__c);

            if (isDeleteMode) {
                profile.active__c = false;
            }           
            
            if ( profile.active__c ) {
                String permissionId = '';
                String profileId = '';                  
                if (profile.GS1_Administrator__c) {
                    if (updateIsGS1Admin) {
                        //add to GS1 Admin (public group)
                        GroupMember gm = new GroupMember();
                        gm.GroupId = Label.GS1_AdminGroupID;
                        gm.UserOrGroupId = u.id;                
                        grpMembersToAdd.add(gm);      
                    }       
                                                                    
                    if (u.profile.userlicense.name == 'Salesforce') {
                        if (u.profile.name=='Standard User' || u.profileid == id.valueOf(Label.GS1_Author_SFAdmin_ProfileID) || u.profileid == id.valueOf(Label.GS1_Author_SFUser_ProfileID)) {
                            profileId = Label.GS1_Author_SFAdmin_ProfileID;
                        } else {
                            permissionId = Label.GS1_Author_SFAdmin_PermissionSetID;
                        }
                    } else if (u.profile.userlicense.name == 'Salesforce Platform') {
                        if (u.profile.name=='Standard Platform User' || u.profileid == id.valueOf(Label.GS1_Author_SPAdmin_ProfileID) || u.profileid == id.valueOf(Label.GS1_Author_SPUser_ProfileID)) {
                            profileId = Label.GS1_Author_SPAdmin_ProfileID;
                        } else {
                            permissionId = Label.GS1_Author_SPAdmin_PermissionSetID;
                        }                           
                    }
                } else {
                    if (u.profile.userlicense.name == 'Salesforce') {
                        if (u.profile.name=='Standard User' || u.profileid == id.valueOf(Label.GS1_Author_SFAdmin_ProfileID) || u.profileid == id.valueOf(Label.GS1_Author_SFUser_ProfileID)) {
                            profileId = Label.GS1_Author_SFUser_ProfileID;
                        } else {
                            permissionId = Label.GS1_Author_SFUser_PermissionSetID;
                        }
                    } else if (u.profile.userlicense.name == 'Salesforce Platform') {
                        if (u.profile.name=='Standard Platform User' || u.profileid == id.valueOf(Label.GS1_Author_SPAdmin_ProfileID) || u.profileid == id.valueOf(Label.GS1_Author_SPUser_ProfileID)) {
                            profileId = Label.GS1_Author_SPUser_ProfileID;
                        } else {
                            permissionId = Label.GS1_Author_SPUser_PermissionSetID;
                        }                           
                    }                       
                }
                
                if (profileId != '') {
                    u.profileid = profileId;
                    usersForUpdate.add(u);                      
                } else if (permissionId != '') {
                    PermissionSetAssignment ps = new PermissionSetAssignment();
                    ps.AssigneeId = u.id;
                    ps.PermissionSetId =  permissionId;             
                    psAssignmentToAdd.add(ps);                      
                }
            } else {
                if (u.profileid == id.valueOf(Label.GS1_Author_SFUser_ProfileID)) {
                    u.profileid = Label.GS1_Author_SFStandardProfileID;
                    usersForUpdate.add(u);
                } else if (u.profileid == id.valueOf(Label.GS1_Author_SPUser_ProfileID)) {
                    u.profileid = Label.GS1_Author_SPStandardProfileID;
                    usersForUpdate.add(u); 
                } else if (u.profileid == id.valueOf(Label.GS1_Author_SFAdmin_ProfileID)) {
                    u.profileid = Label.GS1_Author_SPStandardProfileID;
                    usersForUpdate.add(u); 
                } else if (u.profileid == id.valueOf(Label.GS1_Author_SPAdmin_ProfileID)) {
                    u.profileid = Label.GS1_Author_SPStandardProfileID;
                    usersForUpdate.add(u); 
                }
            }
        } 
        
        //delete existing permission sets and/or group enrollments
        if (userIds.size()>0) {
            
            if (updateIsGS1Admin) {
                List<GroupMember> grpMembersToDelete = [select id from GroupMember where GroupId=:Label.GS1_AdminGroupID AND (UserOrGroupId IN :userIds)];
                if (grpMembersToDelete.size()>0) {
                    delete grpMembersToDelete;
                }               
            }                   
            List<PermissionSetAssignment> psAssignmentToDelete = [select id from PermissionSetAssignment WHERE (AssigneeId IN :userIds) AND (PermissionSetId IN :psIds)];           
            
            if (psAssignmentToDelete.size()>0) {
                delete psAssignmentToDelete;
            }                               
        }       

        if (updateIsGS1Admin) {
            //add to admin group when applicable
            if (grpMembersToAdd.size()>0){
                insert grpMembersToAdd;
            }
        }       
        
        //add permission sets when applicable
        if (psAssignmentToAdd.size()>0){
            insert psAssignmentToAdd;
        }           
        
        //update as needed
        if (usersForUpdate.size()>0) {
            update usersForUpdate;
        }
    }        
}