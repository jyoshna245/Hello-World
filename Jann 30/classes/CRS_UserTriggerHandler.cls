public with sharing class CRS_UserTriggerHandler {
    private Map<String, Id> groupsIdMapping;
    private Map<String, CRS_PublicGroupMapping__c> groupMapping;
    	
	public CRS_UserTriggerHandler(){
		groupMapping = CRS_PublicGroupMapping__c.getAll();
		initGroupsMap();
	}
    
    private void initGroupsMap(){
    	groupsIdMapping = new Map<String, Id>();
    	for(Group item: [Select Id,DeveloperName from Group where DeveloperName like 'CAR_%' or DeveloperName like 'CRS_%' or DeveloperName like 'gvwCRS_%']){
    		groupsIdMapping.put(item.DeveloperName, item.Id);	
    		System.debug('---+++'+item.DeveloperName + ' || ' + item.id);
    	}
    }
    
    private Map<String, GroupMember> initCurrentGroup(List<Id> users){
    	Map<String, GroupMember> currentGroupMap = new Map<String, GroupMember>();
    	for(GroupMember member : [select Id, GroupId, UserOrGroupId from GroupMember where UserOrGroupId in :users]){
    		currentGroupMap.put('' + member.UserOrGroupId + member.GroupId, member);
    	}
    	return currentGroupMap;
    }
    
    private GroupMember createGroupMember(Id userId, String fieldName){
        GroupMember member = new GroupMember();
        System.debug('~~~' + groupMapping.get(fieldName).Groups_Name__c + ' ~|~ ' + groupsIdMapping.get(groupMapping.get(fieldName).Groups_Name__c) + ' ~|~ ' + fieldName);
        member.GroupId = groupsIdMapping.get(groupMapping.get(fieldName).Groups_Name__c);
        member.UserOrGroupId = userId;
        return member;
    }
    
    public void onAfterInsert(User []newUser){
        SObject obj;
        List<GroupMember> memberToAdd = new List<GroupMember>();
        for(User user:newUser){
            obj = user;
            for(String field: groupMapping.keySet()){
                if(obj.get(field) == 'Yes'){
                    memberToAdd.add(createGroupMember(user.Id,field));
                }
            }
        }
        if(!memberToAdd.isEmpty()){
        	insert memberToAdd;
        }
    }

    public void onAfterUpdate(User[] oldUser, User[] newUser){
        /*
        List<GroupMember> memberToAdd = new List<GroupMember>();
        List<GroupMember> memberToDelete = new List<GroupMember>();
        List<Id> temp = new List<Id>();
		for(User user: oldUser){
			temp.add(user.Id);
		}
		Map<String, GroupMember> currentGroupMap = initCurrentGroup(temp);
		GroupMember currentMember;
        for(User user:newUser){
            for(String field: groupMapping.keySet()){
            	currentMember = currentGroupMap.get(''+user.Id+groupsIdMapping.get(groupMapping.get(field).Groups_Name__c));
        		if(user.get(field) == 'Yes' && currentMember == null){
        			memberToAdd.add(createGroupMember(user.Id,field));	
        		} else if(user.get(field) == 'No' && currentMember != null){
                	memberToDelete.add(currentMember);
                }
            }
        }
        if(!memberToDelete.isEmpty()){
        	delete memberToDelete;
        }
        if(!memberToAdd.isEmpty()){
        	insert memberToAdd;
        }*/
    }
}