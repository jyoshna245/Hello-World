public class CRS_RolesEditController {

    public final static String USER_ID_KEY = 'userId';
    public final static integer SINGLE_USER = 0;
    public final static String SAVE_ERROR_MASSAGE = 'The changes have not been saved';
    
    public User user {get; set;}
    
    public List<CRS_Role__c> roleList {get; set;}
    public CRS_Business_Unit__c[] businessUnitList {get; set;}
    public Map<String, boolean> activeRolesMap {get; set;}
    public CRS_Role__C currentRole {get; set;}
    public String currentRoleId {get; set;}

    private PageReference redirectToUserView;
    private List<SelectOption> options;
    

    public CRS_RolesEditController () {
    
        String userId = ApexPages.currentPage().getParameters().get(USER_ID_KEY);

        redirectToUserView = new PageReference('/' + userId ); 
        redirectToUserView.getParameters().put('noredirect', '1');
        redirectToUserView.setRedirect(true);
                          
        user = ([SELECT id,
                       Name 
                FROM User
                WHERE id = :userId]).get(SINGLE_USER); 
        activeRolesMap = new Map<String, boolean>();
        businessUnitList = [SELECT id, Name, Active__c FROM CRS_Business_Unit__c order by Name]; //Added Active__c on the query MLdC 22-July-2013 for INC0789775
        roleList = getRoleList(userId);
       
        for (CRS_Business_Unit__c bu: businessUnitList ) {
            activeRolesMap.put(bu.id, false);
            for (CRS_Role__c role: roleList) {
                if (bu.id == role.Business_Unit__c) {
                    activeRolesMap.put(bu.id, true);
                }
            }     
        }
        
        CRS_Role__c tmpRole;
        
        for (CRS_Business_Unit__c bu: businessUnitList) {
            if (!activeRolesMap.get(bu.id)) {
                tmpRole = new CRS_Role__c ();
                tmpRole.Business_Unit__c = bu.id;
                tmpRole.Business_Unit__r = bu;
                tmpRole.User__c = user.id;
                tmpRole.User__r = user;
                roleList.add(tmpRole);
            }     
        }
            
        if (!roleList.isEmpty()) {
            currentRole = roleList[0];
        }
    }

    private static List<CRS_Role__c> getRoleList(String userId) {
        return [SELECT id,
                       Name,
                       Business_Unit__c,
                       Business_Unit__r.id,
                       Business_Unit__r.Name,
                       Business_Unit__r.Active__c, //Added Active__c on the query MLdC 22-July-2013 for INC0789775
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
                       gvwCRS_Corporate_PAC_Approver__c, //added by Ranjan 10th Oct'14
                       gvwCRS_VP_Chief_Scientific__c,
                       CRS_VP_Chief_Scientific_Regulatory__c,
                       CRS_VP_Science_Division__c
                FROM CRS_Role__c
                WHERE User__c = :userId order by Business_Unit__r.Name];
    }

    @future
    public static void updateGroupMembersAsync(String userId) {
        
        Map<String, Id> groupsIdMapping = new Map<String, Id>();
        Map<String, CRS_PublicGroupMapping__c> groupMapping;

        groupMapping = CRS_PublicGroupMapping__c.getAll();

        for(Group item: [Select Id,DeveloperName from Group where DeveloperName like 'CAR_%' or DeveloperName like 'CRS_%' or DeveloperName like 'gvwCRS_%']){
            groupsIdMapping.put(item.DeveloperName, item.Id);   
        }
        
        List<GroupMember> memberToAdd = new List<GroupMember>();
        List<GroupMember> memberToDelete = new List<GroupMember>();
        List<CRS_Role__c> roleList = getRoleList(userId);          
        List<GroupMember> currentGroupMembers = [SELECT id,
                                                        GroupId
                                                 FROM GroupMember  
                                                 WHERE UserOrGroupId = :userId];

        map<Id, GroupMember> currentGroupMembersIdMap = new map<id,GroupMember>();

        for (GroupMember groupMember: currentGroupMembers) {
            currentGroupMembersIdMap.put(groupMember.GroupId, groupMember);
        }

        boolean isUpsert;
        GroupMember member;
        Id groupsId;

        for(String field: groupMapping.keySet()){
            isUpsert = false;
            for (CRS_Role__c role: roleList) {
                system.debug(role.get(field)+'roleslist');
                if(role.get(field) == 'Yes'){
                    isUpsert = true;
                }
            }
            groupsId = groupsIdMapping.get(groupMapping.get(field).Groups_Name__c);
            member = currentGroupMembersIdMap.get(groupsId);
            if (member == null){
                if (isUpsert) {
                    member = new GroupMember();
                    member.GroupId = groupsId;
                    member.UserOrGroupId = userId;
                    memberToAdd.add(member);
                }
            } else if (!isUpsert) {
                memberToDelete.add(member);
            }
        }
        if(!memberToAdd.isEmpty()){
            upsert memberToAdd;
        }
        if(!memberToDelete.isEmpty()){
            delete memberToDelete;
        }
    }

    public void doChange() {

        for (CRS_Role__c role: roleList) {
            if(role.Business_Unit__r.id == currentRoleId) {
                currentRole = role;
                return;
            }
        } 
    }

    public List<SelectOption> getItems() {
    
        options = new List<SelectOption>();
        
        for (CRS_Role__c role: roleList) {
            if (role.Business_Unit__r.Active__c=='Yes'){ //Added if condition to check if BU is Active on the query MLdC 22-July-2013 for INC0789775
            options.add(new SelectOption(role.Business_Unit__r.id, role.Business_Unit__r.Name));
            }
        }
        return options;
    }

    public PageReference doCancel() {
        return redirectToUserView;
    }

    public PageReference doSave() {

        List<CRS_Role__c> delList = new List<CRS_Role__c>();
        List<CRS_Role__c> upsetList = new List<CRS_Role__c>();

        try {

            for(CRS_Role__c role: roleList) {
                if (activeRolesMap.get(role.Business_Unit__r.id)) {
                    upsetList.add(role);
                } else {
                    if (role.id != null) {
                        delList.add(role); 
                    } 
                }
            }

            upsert upsetList;
            delete delList;
            updateGroupMembersAsync(User.id);

            return redirectToUserView;

        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, SAVE_ERROR_MASSAGE ));
            System.debug(e);
        }
        
        return null;
    }
}