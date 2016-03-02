public with sharing class CRS_RolesViewController {

    private final User user;
    
    public final static String USER_ID_KEY = 'userId';
    public final static integer SINGLE_USER = 0;
    
    public CRS_Role__c[] roleList {get; set;} 
    public boolean isEmptyRoleList {get; set;}
    public boolean isReadonly{get; set;}
    
    public CRS_RolesViewController(ApexPages.StandardController controller) {
        this.user = (User) controller.getRecord();
        isReadonly = ([SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()
            and (Name=:CRS_CRSEdit.getBAProfileName() OR Name=:CRS_CRSEdit.getSAProfileName())]).isEmpty();
        
        roleList = [SELECT id,
                           Name,
                           Business_Unit__c,
                           Business_Unit__r.Name,
                           CRS_BU_Legal_Approver__c,
                           CRS_BU_PAC_Approver__c,
                           CRS_Corporate_Food_Law_Approver__c,
                           CRS_Corporate_Formula_Governance__c,
                           CRS_Corporate_SRA_Approver__c,
                           CRS_Corporate_Level__c,
                           CRS_Field_SRA_Approver__c,
                           CRS_Corporate_PAC_Approver__c, //added by Ranjan 10th Oct'14
                           gvwCRS_BU_Legal_Approver__c,
                           gvwCRS_BU_PAC_Approver__c,
                           gvwCRS_Corporate_Food_Law_Approver__c,
                           gvwCRS_Corporate_Level__c,
                           gvwCRS_Corporate_SRA_Approver__c,
                           gvwCRS_Field_SRA_Approver__c,
                           gvwCRS_Corporate_PAC_Approver__c,  //added by Ranjan 10th Oct'14
                           gvwCRS_VP_Chief_Scientific__c,
                           CRS_VP_Chief_Scientific_Regulatory__c,
                           CRS_VP_Science_Division__c
                    FROM CRS_Role__c
                    WHERE User__c = :user.id order by Business_Unit__r.Name];
    }
}