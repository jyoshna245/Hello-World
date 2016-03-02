public with sharing class CRS_CRSReviewTriggerHandler {

    private Integer getNumberFromName(List<CRS_Review__c> crsRvw){
        Integer idNum = 0;
        if(!crsRvw.isEmpty()){
            Pattern p = Pattern.compile('(\\d{6})');
            Matcher m = p.matcher(crsRvw[0].Name);
            if(m.find()){
                idNum = Integer.valueOf(m.group(1)) + 1;
                System.debug('~~~:' + m.group(1)); 
            }
        }
        if(idNum < 1001){
            idNum = 1001;
        }
        return idNum;
    }
    
    public void BeforeInsert(CRS_Review__c[] newCrsReview){
        Integer lastCrsRvwId = getNumberFromName(CRS_AdminActions.getIrwCRSReview());
        for(CRS_Review__c crsRvw : newCrsReview){
            if(crsRvw.Name == null || !crsRvw.Name.contains('ATL')){
                crsRvw.Name = 'Irvw' + '0'.repeat(6 - String.valueOf(lastCrsRvwId).length()) + lastCrsRvwId++;
                if(crsRvw.Initiated_By__c == null){
                    crsRvw.Initiated_By__c = Userinfo.getUserId();
                }
            }
            crsRvw.Date_Initiated__c = System.today();
        }
    }
    
    public void AfterInsert(CRS_Review__c[] newCrsReview){
        set<Id> CRSId = new set<ID>();
        for(CRS_Review__c crsRvw : newCrsReview){
            CRSId.add(crsRvw.CRS_Tracking__c);
        }
        
        list<CRS__c> lstCRStoUpdate = new list<CRS__c>();
        CRS__c objCRS = [select Id,CRS_Review__c from CRS__c where Id in :CRSId limit 1];
        for(CRS_Review__c crsRvw : newCrsReview){
            objCRS.CRS_Review__c = crsRvw.Id;
            objCRS.Current_Reviewer_s__c = crsRvw.Current_Reviewers__c;
            objCRS.UnderReviewApprovalValidationCheck__c = false;
            lstCRStoUpdate.add(objCRS);
        }
        
        upsert lstCRStoUpdate;
    }
    public void AfterUpdate(CRS_Review__c[] newCrsReview){
        set<Id> CRSId = new set<ID>();
        for(CRS_Review__c crsRvw : newCrsReview){
            CRSId.add(crsRvw.CRS_Tracking__c);
        }
        CRS__c objCRS = [select Id,CRS_Review__c,Current_Reviewer_s__c from CRS__c where Id in :CRSId limit 1];
        
        string CurrentReviewers = '';
        for(CRS_Review__c crsRvw : newCrsReview){
            if(crsRvw.Current_reviewer_FL__c){
                CurrentReviewers += 'FL,';
            }
            if(crsRvw.Current_reviewer_SRA__c){
                CurrentReviewers += 'SRA,';
            }
            if(crsRvw.Current_reviewer_FGD__c){
                CurrentReviewers += 'FGD,';
            }
            if(crsRvw.Current_reviewer_PAC__c){
                CurrentReviewers += 'PAC';
            }
        }
        
        objCRS.Current_Reviewer_s__c = CurrentReviewers;
        CRS_AdminActions.updateCRS(objCRS);
    
    }
}