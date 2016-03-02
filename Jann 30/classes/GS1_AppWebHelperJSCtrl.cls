/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     A classcontaining methods used in web/javascript manipulation/operation
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
* NOTE: all methods in class are not meant for bulkified operation and should not be used in such condition
*       This is abosolutely for web consumption only
*
*/

global class GS1_AppWebHelperJSCtrl {
    public without sharing class FinderClass
    {
        //no longer used since criteria for finding duplicate is now based on how duplicate is searched when allocating barcode
        /*public GS1_Request__c getDuplicateRequest(GS1_Request__c req) {         
            GS1_Request__c req2 = null;
            
            String query = 'select id, EAN_Code__c, EAN_Code__r.Name from GS1_Request__c where EAN_Code__c != null AND Country__c = \'' + req.Country__c+ '\' AND Trademark__c = \'' + req.Trademark__c+ '\' AND Flavour__c = \'' + req.Flavour__c+ '\' AND Unit__c = \'' + req.Unit__c+ '\' AND Material__c = \'' + req.Material__c+ '\' AND Design__c = \'' + req.Design__c+ '\' AND Multipack__c = \'' + req.Multipack__c+ '\' AND Units_Pack__c = \'' + req.Units_Pack__c+ '\' AND Id != \'' + String.valueOf(req.Id) + '\'';     
            if (req.Product_Type__c != 'Pallet') {
                query += ' AND BBN__c = \'' + (String.isBlank(req.BBN__c) ? '' : req.BBN__c) + '\'';
            }
            System.debug(GS1_Constants.GS1_DEBUG_SIG + query);
            
            List<GS1_Request__c> dupReq = Database.query(query);    
            
            if (dupReq.size()>0) {
                req2 = dupReq[0];
            }
                        
            return req2;
        }        */
        
        public GS1_Request__c getDuplicateRequest2( GS1_Request__c req ) {
            GS1_Request__c[] dups;    
            String query = 'select id, Description__c, Description_Computed__c, Status__c, EAN_Code__c, Country__c, Country__r.Name, EAN_Code__r.name from GS1_Request__c where ';
            query += 'EAN_Code__c != null AND id !=\'' + req.id + '\''; 
            query += ' AND Trademark__c=\'' + req.Trademark__c + '\'';
            query += ' AND Country__c=\'' + req.Country__c + '\'';
            query += ' AND Flavour__c=\'' + req.Flavour__c + '\'';
            query += ' AND Unit__c=\'' + req.Unit__c + '\'';
            query += ' AND Capacity__c=\'' + req.Capacity__c + '\'';
            query += ' AND Material__c=\'' + req.Material__c + '\'';
            query += ' AND Design__c=\'' + req.Design__c + '\'';
            query += ' AND Multipack__c=\'' + req.Multipack__c + '\'';
            query += req.Multipack_Type__c.startsWith('D') ? ' AND Packs_Case__c=' + String.valueOf(req.Packs_Case__c) : '';
            query += ' AND Units_Pack__c=\'' + req.Units_Pack__c + '\'';
            query += String.isBlank(req.BBN__c)==false ? ' AND BBN__r.code__c=\'' + req.BBN__r.code__c + '\'' : '';
            query += ' AND Product_Type__c=\'' + req.Product_Type__c + '\'';
            query += ' AND Request_Type__c=\'' + req.Request_Type__c + '\'';            
            
            if (req.Request_Type__c == 'Promotion') {
                if(req.Promotion_type__c == 'Quantity') {
                    query += ' AND Promo_Quantity__c=\'' + req.Promo_Quantity__c + '\'';
                } else if (req.Promotion_type__c == 'Amount') {
                    query += ' AND Promo_Currency__c=\'' + req.Promo_Currency__c + '\'';
                    query += ' AND Promo_Amount__c=' + String.valueOf(req.Promo_Amount__c);
                } else if (req.Promotion_type__c == 'Other') {
                    query += ' AND Promo_Other__c=\'' + req.Promo_Other__c + '\'';
                }
            }
            
            if (req.Product_Type__c=='Pallet') {
                query += ' AND Pallet_Material__c=\'' + req.Pallet_Material__c + '\'';
                query += ' AND Pallet_Design__c=\'' + req.Pallet_Design__c + '\'';
                query += ' AND Number_of_Layers__c=' + String.valueOf(req.Number_of_Layers__c);
                query += ' AND Count_per_Pallet__c=' + String.valueOf(req.Count_per_Pallet__c);
            }        
            
            query += ' LIMIT 1';
            
            System.debug(GS1_Constants.GS1_DEBUG_SIG + query);
                    
            dups = database.query(query);
            if (dups.size()>0) {
                return dups[0];
            } else {
                return null;
            }        
        }        
    }

    public class CallStatus {
        public string status = 'ok';
        public string message = '';
        public object data = '';
        public String eanCode = '';
        public string eanId = '';
        public boolean eanFree = false;
        
        public void setErrorMessage(String msg) {
            this.status = 'error';
            this.message = msg;
        }
    }
    
    public string getBBNObjectPrefix() {
        return GS1_CommonFunctions.getObjectPrefix('GS1_BBN__c');
    }    
    
    public string getRequestObjectPrefix() {
        return GS1_CommonFunctions.getObjectPrefix('GS1_Request__c');
    }
    
    public boolean getIsGS1Admin() {
        return (GS1_CommonFunctions.isGS1Admin( system.Userinfo.getUserId()) || GS1_CommonFunctions.isSystemAdministrator());
    }
    
    public static String getGS1ObjectIds() {
        String ret = '';
        String oName;
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        
        for(String sObj : gd.keySet()){
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            oName = r.getName();           
            if (oName.toUpperCase().startsWith('GS1_')) {
            if (!oName.endsWith('__Share') && !oName.endsWith('__History')) {
                if (ret=='') {
                        ret = r.getKeyPrefix();
                   } else {
                        ret += '|' + r.getKeyPrefix();
                   }
                }
            }
        }
        return ret;     
    }
    
    public static GS1_Request__c[] findSameRequests( GS1_Request__c req ) {
        
        GS1_Request__c[] dups;
        String query = 'select id, Description__c, Description_Computed__c, Status__c, EAN_Code__c, Country__c, Country__r.Name, EAN_Code__r.name from GS1_Request__c where ';
        query += 'EAN_Code__c != null AND id !=\'' + req.id + '\''; 
        query += ' AND Trademark__c=\'' + req.Trademark__c + '\'';
        query += ' AND Flavour__c=\'' + req.Flavour__c + '\'';
        query += ' AND Unit__c=\'' + req.Unit__c + '\'';
        query += ' AND Capacity__c=\'' + req.Capacity__c + '\'';
        query += ' AND Material__c=\'' + req.Material__c + '\'';
        query += ' AND Design__c=\'' + req.Design__c + '\'';
        query += ' AND Multipack__c=\'' + req.Multipack__c + '\'';
        query += req.Multipack_Type__c.startsWith('D') ? ' AND Packs_Case__c=' + String.valueOf(req.Packs_Case__c) : '';
        query += ' AND Units_Pack__c=\'' + req.Units_Pack__c + '\'';
        query += String.isBlank(req.BBN__c)==false ? ' AND BBN__r.code__c=\'' + req.BBN__r.code__c + '\'' : '';
        query += ' AND Product_Type__c=\'' + req.Product_Type__c + '\'';
        query += ' AND Request_Type__c=\'' + req.Request_Type__c + '\'';
        
        if (req.Request_Type__c == 'Promotion') {
            if(req.Promotion_type__c == 'Quantity') {
                query += ' AND Promo_Quantity__c=\'' + req.Promo_Quantity__c + '\'';
            } else if (req.Promotion_type__c == 'Amount') {
                query += ' AND Promo_Currency__c=\'' + req.Promo_Currency__c + '\'';
                query += ' AND Promo_Amount__c=' + String.valueOf(req.Promo_Amount__c);
            } else if (req.Promotion_type__c == 'Other') {
                query += ' AND Promo_Other__c=\'' + req.Promo_Other__c + '\'';
            }
        }
        
        if (req.Product_Type__c=='Pallet') {
            query += ' AND Pallet_Material__c=\'' + req.Pallet_Material__c + '\'';
            query += ' AND Pallet_Design__c=\'' + req.Pallet_Design__c + '\'';
            query += ' AND Number_of_Layers__c=' + String.valueOf(req.Number_of_Layers__c);
            query += ' AND Count_per_Pallet__c=' + String.valueOf(req.Count_per_Pallet__c);
        }          
        
        System.debug(GS1_Constants.GS1_DEBUG_SIG + query);
        
        dups = database.query(query);
        return dups;
    }
    
    private static GS1_EAN__c getFreeBarcode(GS1_Request__c req, String shorOrLong) {
        String requestType = req.Request_Type__c=='Promotion' ? 'Promo':'Normal';
        String prodType = req.Product_Type__c;
        String freeStat = GS1_Constants.BARCODE_STAT_FREE;
        
        if (String.isBlank(shorOrLong)) {
            shorOrLong = req.Long_Short__c;
        }
                
        GS1_EAN__c[] eans = [select id, name from GS1_EAN__c where Property_2__c=:prodType AND Property_3__c=:requestType AND Property_1__c=:shorOrLong AND status__c=:freeStat order by name limit 1];
        if (eans.size()>0) {        
            return eans[0];
        } else {
            return null;
        }
    }    
    
    private static boolean sendDuplicateRequestEmail(GS1_Request__c req) {
        boolean ret = false;
        /*FinderClass finder = new FinderClass();
        GS1_Request__c dup = finder.getDuplicateRequest2(req);
        if (dup != null) {
            req.Duplicate_Request__c = dup.id;
        }
        update req;*/
        //send notification to requestor
        String rcpt = req.RequestedByUserId__c;
        if (String.isBlank(rcpt)) rcpt = req.OwnerId;
        if (String.isBlank(rcpt)) rcpt = req.CreatedById;
        if (!String.isBlank(rcpt)) {
            Messaging.Singleemailmessage email = GS1_CommonFunctions.composeEmailFromTemplate(label.GS1_Cancel_Email_Template_Id, req.id);
            email.setTargetObjectId(rcpt);
            LIST<Messaging.Email> emails = new LIST<Messaging.Email>();
            emails.add(email);
            Messaging.sendEmailResult[] res = Messaging.sendEmail(emails, false);
            if (res[0].isSuccess()) {
                ret = true;
            } else {
                System.debug(GS1_Constants.GS1_DEBUG_SIG + res[0].getErrors()[0].getMessage());
            }
        }    
        
        return ret;   
    }    
    
    //JAVASCRIPT CALLABLE/EXECUTABLES
    
    //given an object name (custom or built-in), it returns the 3-letter code associated to it.
    //the code can be used to reference to some URLs        
    webservice static String getObjectPrefix(String objectName) {
        return GS1_CommonFunctions.getObjectPrefix(objectName);
    }

    webservice static String withdrawRequest(String requestId) {
        CallStatus stat = new CallStatus();
        List<GS1_Request__c> reqs = [select id, EAN_Code__c, status__c from GS1_Request__c where id=:requestId limit 1];
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        } 
        GS1_Request__c req = reqs[0];
        GS1_RequestAttribute att = new GS1_RequestAttribute (req);
        if ( att.userCanWithdraw ) {
            req.Status__c = GS1_Constants.REQUEST_STATUS_WITHDRAWN;
            update req;
        } else {
            stat.setErrorMessage(GS1_Constants.ERRMSG_ACTION_RESTRICTED);  
        }
        return JSON.serialize(stat);
    }
    
    webservice static String reactivateRequest(String requestId) {
        CallStatus stat = new CallStatus();
        List<GS1_Request__c> reqs = [select id, EAN_Code__c, status__c from GS1_Request__c where id=:requestId limit 1];
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        } 
        GS1_Request__c req = reqs[0];
        GS1_RequestAttribute att = new GS1_RequestAttribute (req);
        if ( att.userCanReactivate ) {
            req.Status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
            update req;
        } else {
            stat.setErrorMessage(GS1_Constants.ERRMSG_ACTION_RESTRICTED);  
        }
        
        return JSON.serialize(stat);
    }    
    
    webservice static string allocateEAN(String requestId, String eanId, boolean isFree) {        
        CallStatus stat = new CallStatus();
        Boolean approved = false;
        
        List<GS1_Request__c> reqs = [select id, EAN_Code__c, Status__c, BBN__c, Product_Type__c, BBN_Formula__c from GS1_Request__c where id=:requestId limit 1];       
        
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        }
        
        if (isFree) {
            List<GS1_EAN__c> eanList = [select id,status__c from GS1_EAN__c where id =:eanId AND status__c=:GS1_Constants.BARCODE_STAT_FREE];
            if (eanList.size()<=0) {
                stat.setErrorMessage(GS1_Constants.ERRMSG_EAN_NOTFOUND );
                return JSON.serialize(stat);        
            }
        }
        
        GS1_Request__c req = reqs[0];
        GS1_RequestAttribute att = new GS1_RequestAttribute (req);
        
        if ( att.userCanAllocateEAN ) {
            
            GS1_BBN__c[] bbn;
            
            if (req.Product_Type__c!='Pallet') {
                bbn = [select id, code__c, name from GS1_BBN__c where name like :req.BBN_Formula__c];
                
                if (bbn.size()==0) {
                    stat.setErrorMessage( 'No matching BBN found. Please create a new one, or selected an existing one.');
                    return JSON.serialize(stat);                
                }
            }
                        
            if (req.Status__c == GS1_Constants.REQUEST_STATUS_REQUESTED) {
                GS1_ApprovalProcess apr = new GS1_ApprovalProcess(req);
                if (!apr.decide('Approve', GS1_Constants.APPROVAL_COMMENT_APPROVE)) {
                    System.debug(GS1_Constants.GS1_DEBUG_SIG + apr.getLastErrorMessage());
                    stat.setErrorMessage('An error occurred while trying to approve this request');
                } else {
                    approved = true;
                }                           
            } else {
                approved = true;
            }
            
            if (approved) {
                if (req.Product_Type__c!='Pallet') {
                    req.bbn__c = bbn[0].id;
                    req.bbn_short__c = bbn[0].Code__c;
                }
                req.EAN_Code__c = eanId;
                req.Status__c = GS1_Constants.REQUEST_STATUS_ALLOCATED;
                update req;                 
            }
            
        } else {
            stat.setErrorMessage(GS1_Constants.ERRMSG_ACTION_RESTRICTED);          
        }                
        return JSON.serialize(stat);
    }
    
    webservice static string findAllowableEAN(String requestId) {
        CallStatus stat = new CallStatus();
        List<GS1_Request__c> reqs = [select id, Country__c, Flavour__c, Long_Short__c, Request_type__c, Design__c, Promotion_type__c, Promo_Quantity__c, Product_Type__c, Promo_Amount__c, Promo_Other__c, Promo_Currency__c, EAN_Code__c, BBN__c, BBN__r.code__c, Status__c, Packs_Case__c, Material__c, Capacity__c, Units_Pack__c, Unit__c, Trademark__c, Multipack__c, Multipack_Type__c,Pallet_Material__c, Pallet_Design__c, Number_of_Layers__c, Count_per_Pallet__c from GS1_Request__c where id =:requestId limit 1];
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        } 
        
        GS1_Request__c req = reqs[0];        
        GS1_Request__c[] dups = findSameRequests(req);        

        if (dups.size() > 0) {
            for (GS1_Request__c dupReq : dups) {
                stat.eanCode = dupReq.EAN_Code__r.name;
                stat.eanId = (String)dupReq.ean_code__c;
                stat.data += dupReq.country__r.name + '@' + dupReq.EAN_Code__r.name + '@' + dupReq.status__c + '|';
                if (dupReq.Country__c == req.Country__c ) {
                    stat.status = 'duplicate';
                }
            }
        } else {
            GS1_EAN__c ean = getFreeBarcode(req, req.Long_Short__c);
            if (ean != null) {
                stat.eanCode = ean.name;
                stat.eanId = (String)ean.id;                
                stat.eanFree = true;
            } else {
                stat.setErrorMessage(GS1_Constants.ERRMSG_EAN_NOTMATCHED);
            }
        }
                       
        return JSON.serialize(stat);
    }
    
    webservice static string findAllowableEANSpecial(String requestId, String longOrShort) {
        CallStatus stat = new CallStatus();
        List<GS1_Request__c> reqs = [select id, Country__c, Flavour__c, Long_Short__c, Request_type__c, Design__c, Promotion_type__c, Promo_Quantity__c, Product_Type__c, Promo_Amount__c, Promo_Other__c, Promo_Currency__c, EAN_Code__c, BBN__c, BBN__r.code__c, Status__c, Packs_Case__c, Material__c, Capacity__c, Units_Pack__c, Unit__c, Trademark__c, Multipack__c, Multipack_Type__c,Pallet_Material__c, Pallet_Design__c, Number_of_Layers__c, Count_per_Pallet__c from GS1_Request__c where id =:requestId limit 1];        
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        } 
        
        GS1_Request__c req = reqs[0];
        GS1_Request__c[] dups = findSameRequests(req);        

        if (dups.size() > 0) {
                stat.eanCode = dups[0].EAN_Code__r.name;
                stat.eanId = (String)dups[0].ean_code__c;
                stat.status = 'duplicate';
                stat.message = GS1_Constants.ERRMSG_EAN_IDENTICAL;
        } else {
            GS1_EAN__c ean = getFreeBarcode(req, longOrShort);
            if (ean != null) {
                stat.eanCode = ean.name;
                stat.eanId = (String)ean.id;    
                stat.eanFree = true;            
            } else {
                stat.setErrorMessage(GS1_Constants.ERRMSG_EAN_NOTMATCHED);
            }
        }
                       
        return JSON.serialize(stat);
    }    
    
    webservice static string findDuplicateRequest(String requestId) {
        CallStatus stat = new CallStatus();
        List<GS1_Request__c> reqs = [select id, OwnerId, CreatedById, RequestedByUserId__c, Duplicate_Request__c, Country__c, Flavour__c, Long_Short__c, Request_type__c, Design__c, Promotion_type__c, Promo_Quantity__c, Product_Type__c, Promo_Amount__c, Promo_Other__c, Promo_Currency__c, EAN_Code__c, BBN__c, BBN__r.Code__c, Status__c, Packs_Case__c, Material__c, Capacity__c, Units_Pack__c, Unit__c, Trademark__c, Multipack__c, Multipack_Type__c,Pallet_Material__c, Pallet_Design__c, Number_of_Layers__c, Count_per_Pallet__c from GS1_Request__c where id=:requestId limit 1];        
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        } 
        
        GS1_Request__c req = reqs[0];        
        
        if (String.isBlank(req.Country__c)) {
            stat.status = 'error';
            stat.message = GS1_Constants.ERRMSG_COUNTRY_EMPTY;
            return JSON.serialize(stat);
        }
                
        FinderClass finder = new FinderClass();
        
        //modification for not to allow submission of duplicate request - 9/21/2013
        //GS1_Request__c dup = finder.getDuplicateRequest2(req);
        //if (dup!=null) stat.data = dup;
        //return JSON.serialize(stat);
        
        GS1_Request__c dup = finder.getDuplicateRequest2(req);
        if (dup!=null) {
            stat.status = 'error';
            stat.message = 'The same request information exists under <b>' + dup.EAN_Code__r.Name + '</b> (barcode) for ' + dup.Country__r.name;
            if (dup.Status__c == GS1_Constants.REQUEST_STATUS_WITHDRAWN) {
                stat.message += ' but is currently <b>' + GS1_Constants.REQUEST_STATUS_WITHDRAWN + '</b>.';
                stat.message += '\n\nPlease contact GS1 administrator if you want to reactivate that request.';
            }
        }
        
        return JSON.serialize(stat);
    }
    
    webservice static string submitRequest(String requestId, String duplicateId) {
        CallStatus stat = new CallStatus();

        List<GS1_Request__c> reqs = [select id, EAN_Code__c, Status__c, Duplicate_Request__c, Country__c, Trademark__c, Flavour__c, Unit__c, Material__c, Design__c, Multipack__c, Units_Pack__c, BBN__c from GS1_Request__c where id=:requestId limit 1];        
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        } 
        
        GS1_Request__c req = reqs[0];                            
        GS1_RequestAttribute att = new GS1_RequestAttribute (req);
        if (att.userCanSubmit) {
            GS1_ApprovalProcess apr = new GS1_ApprovalProcess(req);
            if ( !apr.submit( GS1_Constants.APPROVAL_COMMENT_SUBMIT )) {
                stat.setErrorMessage(apr.getLastErrorMessage());//'Error occured while submitting the request for approval. It may have been already submitted.');
                System.debug(GS1_Constants.GS1_DEBUG_SIG + apr.getLastErrorMessage());                
            } else {
                if (!String.isBlank(duplicateId)) {
                    req.Duplicate_Request__c = duplicateId;
                } else {
                    req.Duplicate_Request__c = null;
                }
                req.status__c = GS1_Constants.REQUEST_STATUS_REQUESTED;
                update req;
            }
        } else {
            stat.setErrorMessage(GS1_Constants.ERRMSG_ACTION_RESTRICTED);          
        }
        
        return JSON.serialize(stat);
    }
    
    webservice static string cancelDuplicateRequest(String requestId) {
        Boolean canCancel = false;
        CallStatus stat = new CallStatus();                                            
        List<GS1_Request__c> reqs = [select id, OwnerId, CreatedById, RequestedByUserId__c, Duplicate_Request__c, Country__c, Flavour__c, Long_Short__c, Request_type__c, Design__c, Promotion_type__c, Promo_Quantity__c, Product_Type__c, Promo_Amount__c, Promo_Other__c, Promo_Currency__c, EAN_Code__c, BBN__c, BBN__r.code__c, Status__c, Packs_Case__c, Material__c, Capacity__c, Units_Pack__c, Unit__c, Trademark__c, Multipack__c, Multipack_Type__c,Pallet_Material__c, Pallet_Design__c, Number_of_Layers__c, Count_per_Pallet__c from GS1_Request__c where id=:requestId limit 1];//[select id, OwnerId, CreatedById, Cancelled__c, Multipack_Type__c, Capacity__c, RequestedByUserId__c, EAN_Code__c, Status__c, Duplicate_Request__c, Country__c, Trademark__c, Flavour__c, Unit__c, Material__c, Design__c, Multipack__c, Units_Pack__c, BBN__c from GS1_Request__c where id=:requestId limit 1];
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        } 
        
        GS1_Request__c req = reqs[0];          
        GS1_RequestAttribute att = new GS1_RequestAttribute (req);
        
        if (att.userCanCancelDuplicate) {
        
            GS1_ApprovalProcess apr = new GS1_ApprovalProcess(req);
            
            if (req.Status__c == GS1_Constants.REQUEST_STATUS_REQUESTED) {
                SavePoint sp = Database.setSavePoint();
                FinderClass finder = new FinderClass();            
                GS1_Request__c dup = finder.getDuplicateRequest2(req);
                if (dup != null) {
                    req.Duplicate_Request__c = dup.id;
                }
                req.Cancelled__c = true;
                update req;                
                if (!apr.decide('Reject', GS1_Constants.APPROVAL_COMMENT_REJECT)) {
                    stat.setErrorMessage('Error occured while rejecting the request.');
                    System.debug(GS1_Constants.GS1_DEBUG_SIG + apr.getLastErrorMessage());               
                    Database.rollback(sp);
                }                       
            } else {
                req.Cancelled__c = true;
                req.Status__c = GS1_Constants.REQUEST_STATUS_REJECTED;
                update req;                                
                if (!sendDuplicateRequestEmail(req)) {
                    //stat.setErrorMessage(GS1_Constants.ERRMSG_SENDMAIL_FAILED );
                }
            }
        } else {
            stat.setErrorMessage(GS1_Constants.ERRMSG_ACTION_RESTRICTED);
        }
        
        return JSON.serialize(stat);
    }
    
    webservice static string sendDuplicateRequestEmail(String requestId) {
        CallStatus stat = new CallStatus();    
        List<GS1_Request__c> reqs = [select id, OwnerId, CreatedById, RequestedByUserId__c, Duplicate_Request__c, Country__c, Flavour__c, Long_Short__c, Request_type__c, Design__c, Promotion_type__c, Promo_Quantity__c, Product_Type__c, Promo_Amount__c, Promo_Other__c, Promo_Currency__c, EAN_Code__c, BBN__c, BBN__r.code__c, Status__c, Packs_Case__c, Material__c, Capacity__c, Units_Pack__c, Unit__c, Trademark__c, Multipack__c, Multipack_Type__c,Pallet_Material__c, Pallet_Design__c, Number_of_Layers__c, Count_per_Pallet__c from GS1_Request__c where id=:requestId limit 1];        
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        } 
        
        GS1_Request__c req = reqs[0];  
        List<GS1_Request__c> dups = findSameRequests(req);
        if (dups.size()>0) {
            req.Duplicate_Request__c = dups[0].id;
            update req;
            if (!sendDuplicateRequestEmail(req)) {
                stat.setErrorMessage(GS1_Constants.ERRMSG_SENDMAIL_FAILED );
            }
        } else {
            stat.setErrorMessage('Same requests not found!');
        }
        return JSON.serialize(stat);      
    }
    
    //this function is called to cancel a request. cancelled requests go to recycle bin
    webservice static string cancelRequest(String requestId) {
        CallStatus stat = new CallStatus();
        
        List<GS1_Request__c> reqs = [select id, EAN_Code__c, Status__c from GS1_Request__c where id=:requestId limit 1]; 
        if (reqs.size()<=0) {
            stat.setErrorMessage(GS1_Constants.ERRMSG_REQUEST_NOTFOUND);
            return JSON.serialize(stat);
        }    
        GS1_Request__c req = reqs[0];     
        GS1_RequestAttribute att = new GS1_RequestAttribute (req);
        
        if (att.userCanCancel) {
            req.Status__c = GS1_Constants.REQUEST_STATUS_CANCELLED;
            //update req;
            delete req;
        } else {
            stat.status = 'error';
            stat.message = GS1_Constants.ERRMSG_ACTION_RESTRICTED;
        }
        return JSON.serialize(stat);
    }
      
    webservice static string freeBarcode(Id barcodeId) {        
        CallStatus stat = new CallStatus();
        Map<id, String> status = null;
        GS1_EANFreeProcessor proc = new GS1_EANFreeProcessor();
        List<GS1_EAN__c> eanList = [select id, status__c from GS1_EAN__c where id=:barcodeId limit 1];
        
        if (eanList.size()>0) {
            if (eanList[0].status__c != GS1_Constants.BARCODE_STAT_NOTFREE ) {
                stat.setErrorMessage( 'Selected barcode is not in \'' + GS1_Constants.BARCODE_STAT_NOTFREE + '\' status.' );
            }  else {
                status = proc.processRecords(eanList, true, true);
                if (status.size()>0) {
                    if (status.containsKey(barcodeId)) {
                        String msg = status.get(barcodeId);
                        if (msg != '') {
                            stat.setErrorMessage(msg);
                        }
                    }
                }
            }
        } else {
            stat.setErrorMessage(GS1_Constants.ERRMSG_EAN_NOTFOUND);
        }
        
        return JSON.serialize(stat);
    }
    
    webservice static string deallocateRequests(List<Id> reqIds) {
        CallStatus stat = new CallStatus();
        
        if (reqIds == null || reqIds.size()==0) {
            return JSON.serialize(stat);
        }
        String status = GS1_Constants.REQUEST_STATUS_ALLOCATED;
        GS1_Request__c[] reqs = [select id, EAN_Code__r.id, EAN_Code__r.status__c, status__c from GS1_Request__c where id IN :reqIds AND status__c=:status AND EAN_Code__c!=null];
        List<GS1_EAN__c> eans = new List<GS1_EAN__c>();
        
        if (reqs !=null && reqs.size()>0) {
            for (GS1_Request__c req : reqs) {
                eans.add(req.EAN_Code__r);
                req.status__c = GS1_CONSTANTS.REQUEST_STATUS_APPROVED;
                req.ean_code__c = null;
            }
            
            update reqs;
            
            if (eans.size()>0) {
                GS1_EANFreeProcessor proc = new GS1_EANFreeProcessor();
                proc.processRecords(eans , true, false);
            }            
            
        }
        
        return JSON.serialize(stat);
    }    
}