/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 10, 2013
* Description  :     A class used to handle access to requests based on country/author profile
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
public without sharing class  GS1_SharingProcessor {
	
	public class JSONSObjectList {
		public JSONSObjectList(){}
		public JSONSObjectList(List<SOBject> data){this.ObjectList = data;}
		public List<SOBject> ObjectList;
	}

    public class DeleteInsertGroupMemberValues {
        public List<GroupMember> deleteList;
        public List<GroupMember> insertList;
    }
    
    public static void DeleteAndInsertGroupMembers(String data) {
        if (System.isBatch()||System.isFuture() || Test.isRunningTest()) {
            updateGroupMemberships(data);
        } else {
            updateGroupMembershipsAsync(data);
        }
    }
    
    @future(callout=false)
    public static void updateGroupMembershipsAsync(String data) {
        updateGroupMemberships(data);
    }
  
    
    public static void updateGroupMemberships(String data){
        DeleteInsertGroupMemberValues digmv = (DeleteInsertGroupMemberValues) JSON.deserialize(data, DeleteInsertGroupMemberValues.class);
        
        if (digMv.deleteList != null && digMv.deleteList.size()>0) delete digmv.deleteList;
        if (digMv.insertList != null && digMv.insertList.size()>0) insert  digmv.insertList;        
    }
    
    public static List<GroupMember> getNewAdminMembersList() {
    	List<GroupMember> newSet = new List<GroupMember> ();
    	for (GS1_AuthorProfile__c author : [ select User__c from GS1_AuthorProfile__c where GS1_Administrator__c=true AND Active__c=true]) {
            GroupMember gm = new GroupMember();
            gm.UserOrGroupId = author.User__c;
            gm.GroupId = Label.GS1_AdminGroupID;               
            newSet.add(gm);      		
    	}
    	return newSet;
    }
    
    public static void updateAuthorAccess(Set<Id> countryIds) {
        List<GroupMember> deleteList = new List<GroupMember>();
        List<GroupMember> insertList = new List<GroupMember>();
        Map<Id,Set<Id>> existingGroupMembers = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> newGroupMembers = new Map<Id,Set<Id>>();
        Set<Id> groupIds = new Set<Id>();
        Set<id> remainingCids =  new Set<Id>();
        remainingCids.addAll(countryIds);
        //for (GS1_CountryAuthor__c author : [select country__c, Country_Reader__c, Country__r.Country_Requests_Editor__c, Country__r.Country_Requests_Reader__c, AuthorProfile__r.User_name__c, AuthorProfile__r.Active__c, AuthorProfile__r.User__c, AuthorProfile__r.gs1_administrator__c, isDeleted from GS1_CountryAuthor__c where (country__c IN :countryIds) ORDER BY country__c ALL ROWS]) {
        for (GS1_CountryAuthor__c author : [select country__c, Country_Reader__c, Country__r.Country_Requests_Editor__c, Country__r.Country_Requests_Reader__c, AuthorProfile__r.User_name__c, AuthorProfile__r.Active__c, AuthorProfile__r.User__c, AuthorProfile__r.gs1_administrator__c from GS1_CountryAuthor__c where (country__c IN :countryIds) AND AuthorProfile__r.active__c=true ORDER BY country__c]) {
            if (!String.isblank(author.country__r.Country_Requests_Editor__c)) {
                groupIds.add(author.country__r.Country_Requests_Editor__c);
            }           
            
            if (!String.isblank(author.country__r.Country_Requests_Reader__c)) {
                groupIds.add(author.country__r.Country_Requests_Reader__c);
            }
                        
            
            if (author.Country_Reader__c) {
                if (!String.isblank(author.country__r.Country_Requests_Reader__c)) {
                    if (!newGroupMembers.containsKey(author.country__r.Country_Requests_Reader__c)) {
                        newGroupMembers.put(author.country__r.Country_Requests_Reader__c, new Set<Id>());
                    }
                    
                    newGroupMembers.get(author.country__r.Country_Requests_Reader__c).add(author.AuthorProfile__r.User__c);                 
                }
                
            } else {
                if (!String.isblank(author.country__r.Country_Requests_Editor__c)) {
                    if (!newGroupMembers.containsKey(author.country__r.Country_Requests_Editor__c)) {
                        newGroupMembers.put(author.country__r.Country_Requests_Editor__c, new Set<Id>());
                    }
                    
                    newGroupMembers.get(author.country__r.Country_Requests_Editor__c).add(author.AuthorProfile__r.User__c);                 
                }
            }           
            
            remainingCids.remove(author.country__c);            
            
        }
        
        if (remainingCids.size()>0) {
            for (GS1_Country__c ctry : [select Country_Requests_Reader__c, Country_Requests_Editor__c from GS1_Country__c where ID IN: remainingCids]) {
                if (!String.isBlank(ctry.Country_Requests_Editor__c)) {
                    groupIds.add(ctry.Country_Requests_Editor__c);
                }
                
                if (!String.isBlank(ctry.Country_Requests_Reader__c)) {
                    groupIds.add(ctry.Country_Requests_Reader__c);
                }               
            }
        }
        

        Map<Id,List<GroupMember>> delGrpMembers = new Map<Id, List<GroupMember>> ();
        for (GroupMember g : [select id, UserOrGroupId, GroupId from GroupMember where GroupId IN :groupIds]) {
            if (!existingGroupMembers.containsKey(g.GroupId)) {
                existingGroupMembers.put(g.groupId, new Set<Id>());             
            }
            
            existingGroupMembers.get(g.groupId).add(g.UserOrGroupId);
            
            if (!delGrpMembers.containsKey(g.GroupId)) {
                delGrpMembers.put(g.groupId, new List<GroupMember>());              
            }           
            
            delGrpMembers.get(g.groupId).add(g);
        }
                
        for (Id key : newGroupMembers.keySet()) {
            Boolean equal = true;           
            List<Id> newIds = new List<Id>();
            List<Id> oldIds = new List<Id>();
            
            if (newGroupMembers.containsKey(key)) newIds.addAll(newGroupMembers.get(key));
            if (existingGroupMembers.containsKey(key))  oldIds.addAll(existingGroupMembers.get(key));               
            
            if (newIds.size() != oldIds.size()) {
                equal = false;          
            } else {
                newIds.sort();
                oldIds.sort();
                
                if (String.join(newIds,'') != String.join(oldIds,'')) {
                    equal = false;                      
                }
            }
            
            if (!equal) {                
                for (Id memberId : newIds) {
                    GroupMember gm = new GroupMember();
                    gm.UserOrGroupId = memberId;
                    gm.GroupId = key;               
                    insertList.add(gm);                 
                }               
            } else {
                if (delGrpMembers.containsKey(key)) {
                    delGrpMembers.remove(key);
                }               
            }
            
        }
        
        for (Id key : delGrpMembers.keySet()){
            deleteList.addAll(delGrpMembers.get(key));
        }
                
    	GroupMember[] adminMembers = [select  id, UserOrGroupId, GroupId from GroupMember where GroupId=:Label.GS1_AdminGroupID];    
    	if (adminMembers!=null && adminMembers.size()>0) deleteList.addall(adminMembers);                
        
        insertList.addAll(getNewAdminMembersList());
        
        if (deleteList.size()>0 || insertList.size()>0) {           
            DeleteInsertGroupMemberValues digmv = new DeleteInsertGroupMemberValues();
            digmv.deleteList = deleteList;
            digmv.insertList = insertList;
            DeleteAndInsertGroupMembers(JSON.serialize(digmv));
        }
        
    }   
    
    public static void createUpdateGroupsForCountry( GS1_Country__c[] countries) {
        final integer max_country_name = 25;
        Map<Id,Id> editMap = new Map<Id,Id>();
        Map<Id,Id> readMap = new Map<Id,Id>();
        List<Group> grps = new List<Group>();        
        Set<Id> groupIds = new Set<Id>();
        Map<Id, GS1_Country__c> cMap = new Map<Id, GS1_Country__c>();
        Set<GS1_Country__c> noReaderSet = new Set<GS1_Country__c>(); 
        Set<GS1_Country__c> noEditorSet = new Set<GS1_Country__c>();
        Map<Id, Group> groupEditMap = new Map<Id,Group>();
        Map<Id, Group> groupReadMap = new Map<Id,Group>();
        
       for (GS1_Country__c ctry : countries) {
            if (!String.isBlank(ctry.Country_Requests_Editor__c)) {             
                editMap.put(Id.valueOf(ctry.Country_Requests_Editor__c ), ctry.id);
            } else {
                noEditorSet.add(ctry);
            }
            
            if (!String.isBlank(ctry.Country_Requests_Reader__c)) {             
                readMap.put(Id.valueOf(ctry.Country_Requests_Reader__c ), ctry.id);
            }  else {
                noReaderSet.add(ctry);
            }           
            
            cmap.put(ctry.id, ctry);
        }        
        
        groupIds.addAll(editMap.keySet());
        groupIds.addAll(readMap.keySet());
        
        Map<id,Group> currentGrpMap = new Map<id,Group>([select id from group where id IN :groupIds]);
        
        for (Id grpId : editMap.keySet()) {
            if (!currentGrpMap.containsKey(grpId)) {
                if (cMap.containsKey(editMap.get(grpid))) {
                    noEditorSet.add(cMap.get(editMap.get(grpid)));
                }
            }
        }
        
        for (Id grpId : readMap.keySet()) {
            if (!currentGrpMap.containsKey(grpId)) {
                if (cMap.containsKey(readMap.get(grpid))) {
                    noReaderSet.add(cMap.get(readMap.get(grpid)));                  
                }
            }
        }
        

        String name = null;
        for (GS1_Country__c ctry : noReaderSet) {
        
            name = ctry.Name;
            if (name.length()>max_country_name) {
                name = ctry.Name.substring(1,max_country_name);
                name = name.trim();
            }
        
            Group g = new Group();
            g.DeveloperName = 'GS1_' + getDeveloperName(ctry.Name) + '_Read';
            g.Name = 'GS1 ' + name + ' Read Group';
            g.Type = 'Regular';
            groupReadMap.put(ctry.id, g);
        }

        for (GS1_Country__c ctry : noEditorSet) {

            name = ctry.Name;
            if (name.length()>max_country_name) {
                name = ctry.Name.substring(1,max_country_name);
                name = name.trim();
            }        
        
            Group g = new Group();
            g.DeveloperName = 'GS1_' + getDeveloperName(ctry.Name) + '_Edit';
            g.Name = 'GS1 ' + name + ' Edit Group';
            g.Type = 'Regular';
            groupEditMap.put(ctry.id, g);
        }
        
        grps.addAll(groupReadMap.values());
        grps.addAll(groupEditMap.values());        
        
        if (grps.size()>0) {
            insert grps;
            
            for (GS1_Country__c ctry : noReaderSet) {
                if (groupReadMap.containsKey(ctry.id)) {
                    ctry.Country_Requests_Reader__c = groupReadMap.get(ctry.Id).id;
                } 
            }
            
            for (GS1_Country__c ctry : noEditorSet) {
                if (groupEditMap.containsKey(ctry.id)) {
                    ctry.Country_Requests_Editor__c = groupEditMap.get(ctry.Id).id;
                } 
            }
        }
    }
    
    public static void removeGroups(Set<Id> groupIds) {
        if (System.isBatch() || System.isFuture()) {
            permanentlyDeleteGroups(groupIds);
        } else {
            permanentlyDeleteGroupsAsync(groupIds);
        }
    }
    
    public static void permanentlyDeleteGroups(Set<Id> groupIds) {
        Group[] grps = [select id from Group where id IN :groupIds];
        if (grps.size()>0) {
            delete grps;
        }       
    }
    
    @future(callout=false)
    public static void permanentlyDeleteGroupsAsync(Set<Id> groupIds) {
        permanentlyDeleteGroups(groupIds);
    }    
    
    public static void updateCountrySharing(GS1_Country__c[] countries) {
    	
    	if (countries==null || countries.size()==0) return;
    	
        Map<Id, GS1_Country__c> countryMap = new Map<Id, GS1_Country__c>(countries);
        GS1_Country__Share[] addShares = new List<GS1_Country__Share>();
        for (GS1_Country__c ctry : [select id, Country_Requests_Editor__c from GS1_Country__c where id IN :countryMap.keySet()]) {
            GS1_Country__Share share = new GS1_Country__Share();
            share.ParentId = ctry.Id;
            share.UserOrGroupId = ctry.Country_Requests_Editor__c;
            share.RowCause = Schema.GS1_Country__Share.RowCause.CountryAuthor__c;
            share.AccessLevel = 'Read';                
            addShares.add(share);                   
        }               
        
        GS1_Country__Share[] delShares = [select id from GS1_Country__Share where parentId IN :countryMap.keySet() AND RowCause != 'Owner'];
        
        if (delShares.size()>0) {
            delete delShares;
        }
        
        if (addShares.size()>0) {
            insert addShares;
        }       
    }    
    
    @future(callout=false)
    private static void updateRequestSharingAsync(String data) {
    	JSONSObjectList jList = (JSONSObjectList)JSON.deserialize(data, JSONSObjectList.class);
    	GS1_Request__c[] reqs = (List<GS1_Request__c>)jList.ObjectList;
    	if (reqs!=null && reqs.size()>0) {
    		updateRequestSharing(reqs);
    	}
    }    
    
    public static void updateRequestSharing(List<GS1_Request__c> reqs) {
    	
    	if (reqs==null||reqs.size()==0) return;
    	
        Map<id,GS1_Request__c> reqMap = new Map<id,GS1_Request__c>(reqs);
        List<GS1_Request__Share> addShares = new List<GS1_Request__Share>();
        List<GS1_Request__Share> delShares = new List<GS1_Request__Share>();
        Set<id> countryIds = new Set<Id>();
        
        for (GS1_Request__c req : reqs) {
            if (!String.isBlank(req.Country__c)) {
           		countryIds.add(req.Country__c);
            }
        }
        
        Map<Id,GS1_Country__c> countries = new Map<Id,GS1_Country__c>([select id, name, Country_Requests_Editor__c, Country_Requests_Reader__c from GS1_Country__c where Id IN :countryIds]);
        Map<Id,GS1_Request__Share[]> readList = new Map<Id, GS1_Request__Share[]>();
        Map<Id,GS1_Request__Share[]> editList = new Map<Id, GS1_Request__Share[]>();
        Map<Id,List<GS1_Request__c>> countryReqMap = new Map<Id,List<GS1_Request__c>>();
        List<GS1_Request__Share> allShares = [select id, AccessLevel, ParentId, UserOrGroupId from GS1_Request__Share where ParentId IN :reqMap.keySet() AND rowCause != 'Owner'];
        
        
        for (GS1_Request__c req : reqs) {
        	if (!countryReqMap.containsKey(req.Country__c)) {
        		countryReqMap.put(req.country__c, new List<GS1_Request__c>());	
        	}
        	
        	countryReqMap.get(req.country__c).add(req);
        }
        
        for (GS1_Request__Share rs : allShares) {
        	if (rs.AccessLevel == 'Read') {
        		if (!readList.containsKey(rs.parentId)) {
        			readList.put(rs.parentId, new List<GS1_Request__Share>());        			
        		}        		
        		
        		readList.get(rs.parentId).add(rs);
        	} else {
        		if (!editList.containsKey(rs.parentId)) {
        			editList.put(rs.parentId, new List<GS1_Request__Share>());        			
        		}        		
        		
        		editList.get(rs.parentId).add(rs);
        	}
        }

		for (GS1_Request__c req : reqs) {
	    	Boolean addEditShare = false;
	    	Boolean addReadShare = false;
			if (countries.containsKey(req.country__c)) {
				GS1_Country__c country = countries.get(req.country__c);
				if (editList.containsKey(req.id)) {
					List<GS1_Request__Share> reqshares = editList.get(req.id);
					Set<GS1_Request__Share> reqshares2 = new Set<GS1_Request__Share>(reqshares);
					for (integer i=0; i<reqshares.size(); i++) {
						GS1_Request__Share rs = reqshares.get(i);
						if (rs.UserOrGroupId != country.Country_Requests_Editor__c) {
							delShares.add(rs);
							reqshares2.remove(reqshares.get(i));							
						} else if (req.status__c == GS1_Constants.REQUEST_STATUS_ALLOCATED) {
							delShares.add(rs);
							reqshares2.remove(reqshares.get(i));
						}						
					}
					
					if (reqshares2.size()==0) {
						addEditShare = true;
					}
					
				} else {
					addEditShare = true;
				}
				
				if (addEditShare) {
					if (!String.isBlank(country.Country_Requests_Editor__c)) {
						GS1_Request__Share share = new GS1_Request__Share();
			            share = new GS1_Request__Share();
			            share.ParentId = req.id;
			            share.UserOrGroupId = country.Country_Requests_Editor__c;
			            share.RowCause = Schema.GS1_Request__Share.RowCause.CountryUser__c;
			            if (req.Status__c == GS1_Constants.REQUEST_STATUS_ALLOCATED ) {
			            	share.AccessLevel = 'Read';
			            } else {
			            	share.AccessLevel = 'Edit';
			            }
			            addShares.add(share);  	
					}				
				}
				
				if (readList.containsKey(req.id)) {
					List<GS1_Request__Share> reqshares = readList.get(req.id);
					Set<GS1_Request__Share> reqshares2 = new Set<GS1_Request__Share>(reqshares);
					//reqshares2.addAll(reqshares);
					for (integer i=0; i<reqshares.size(); i++) {
						GS1_Request__Share rs = reqshares.get(i);
						if (rs.UserOrGroupId != country.Country_Requests_Reader__c) {
							delShares.add(rs);
							reqshares2.remove(reqshares.get(i));
						}						
						
					}
					
					if (reqshares2.size()==0) {
						addReadShare = true;
					}					

				} else {
					addReadShare = true;
				}				
				
				if (addReadShare) {
					if (!String.isBlank(country.Country_Requests_Reader__c)) {
						GS1_Request__Share share = new GS1_Request__Share();
			            share = new GS1_Request__Share();
			            share.ParentId = req.id;
			            share.UserOrGroupId = country.Country_Requests_Reader__c;
			            share.RowCause = Schema.GS1_Request__Share.RowCause.CountryUser__c;
			            share.AccessLevel = 'Read';
			            addShares.add(share);  	
					}					
				}
			} else {
				if (readList.containskey(req.id)) delShares.addall( readList.get(req.id) );
				if (editList.containskey(req.id)) delShares.addall( editList.get(req.id) );
			}
		}
		    
        
        if (delShares.size()>0) {
        	System.debug( GS1_Constants.GS1_DEBUG_SIG + ' shares to delete:' + String.valueOf(delShares.size()));
            delete delShares;
        }
        
        if (addShares.size()>0) {
        	System.debug(GS1_Constants.GS1_DEBUG_SIG + ' shares to add:' + String.valueOf(addShares.size()));
        	Database.insert(addShares, false);
        }
        
    }
    
    public static void updateRequestSharingByCountry(List<GS1_Country__c> countries) {
    	final integer MAX_REQUEST = 2500; //the maximum number requests
    	final integer INVOKE_FUTURE_COUNT = 1000;
    	Map<Id, GS1_Country__c> cMap = new Map<Id, GS1_Country__c>(countries);
    	
    	Boolean runAsBatch = false;
    	boolean runAsFuture = false;
    	
    	GS1_Request__c[] reqs = [select id, Country__c, status__c from GS1_Request__c where Country__c IN :cMap.keySet() limit :MAX_REQUEST];
    	if (reqs !=null & reqs.size()<MAX_REQUEST) {	
    		if (reqs.size()>=INVOKE_FUTURE_COUNT) {
    			if ((Limits.getLimitFutureCalls()-Limits.getFutureCalls())>0) {
    				runAsFuture = true;
    			} else { // we can't do future call... so we do batch
    				runAsBatch = true;
    			}
    		} else {
    			Integer availableDmlRows = Limits.getLimitDmlRows() - Limits.getDmlRows();
    			if ((reqs.size()*4) > availableDmlRows) { // # of requests * 4 (reader to add, reader to delete, editor to add, editor to delete)
    				runAsFuture = true;
    			}
    		}
    	} else {
    		runAsBatch = true;
    	}
    	
    	if (runAsBatch) {
    		GS1_BatchUpdateRequestSharing burs = new GS1_BatchUpdateRequestSharing(cMap.keySet());
    		Database.executeBatch(burs);    		
    	} else if (runAsFuture) {
			JSONSObjectList obj = new JSONSObjectList();
			obj.ObjectList = reqs;
			updateRequestSharingAsync(JSON.serialize(obj));    		
    	} else {
    		updateRequestSharing(reqs);
    	}    	
    }
    
    public static void DestroyAndRebuildAccess(boolean rebuild) {
    	GS1_Country__c[] countries = [select id, name, Country_Requests_Editor__c, Country_Requests_Reader__c from GS1_Country__c];
    	Set<Id> groupIds = new Set<Id>();
    	if (countries!=null && countries.size()>0) {
    		for (GS1_Country__c c : countries) {
    			if (!String.isBlank( c.Country_Requests_Editor__c)) groupIds.add(c.Country_Requests_Editor__c);
    			if (!String.isBlank( c.Country_Requests_Reader__c)) groupIds.add(c.Country_Requests_Reader__c);
    			c.Country_Requests_Reader__c = null;
    			c.Country_Requests_Editor__c = null;
    		}
    		
	    	if (groupIds.size()>0) {
	    		delete [select id from GS1_Country__Share where rowCause != 'Owner'];
	    		delete [select id from GS1_Country__Share where rowCause != 'Owner' AND UserOrGroupId IN :groupIds];
	    		delete [select id from group where id IN :groupIds];   		
	    	}
	    	
	    	if (rebuild) update countries;    		
    	}
    }
    
    public static string getDeveloperName(String v) {   
		String ret = (v.replaceAll('[^A-Z^a-z^0-9]','')).left(40) + '_' + String.valueOf( System.currentTimeMillis()) ;
		return ret;
    }    
}