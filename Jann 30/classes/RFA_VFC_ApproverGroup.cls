public class RFA_VFC_ApproverGroup 
{
 public Approver_Group__c appvrgrpobj ;
 public boolean viewmode {get;set;}
 public boolean editmode {get;set;} 
 public boolean showmessage {get;set;}
 public Map<String, Integer> LevelsMap ;
 public List<SelectOption> levels{set;get;}
 public String selectedLevel{set;get;}
    public String selectedRole{set;get;}
    public String selectedDescrip{set;get;}
 Integer currentlevel=null;
 public Map<String, Integer>  PCLevelsMap ;
 public  Boolean FieldMsgs{set;get;}
 String recordlevel=null;
    Id username = null;
     Id apprvrgrprecordId =null;
    String ProfileName=null;
 public RFA_VFC_ApproverGroup (ApexPages.StandardController ctrl)
    {
        FieldMsgs= false;
       showmessage = false; 
        username = userinfo.getUserId();
       Id profileId=userinfo.getProfileId();
       ProfileName=[Select Id,Name from Profile where Id=:profileId].Name;
      appvrgrpobj=(Approver_Group__c)ctrl.getRecord();
      LevelsMap = new Map<String, Integer>{ 'KEYOP' => 1, 'BU' => 2, 'GROUP' => 3 , 'CORP' => 4, 'EXEC' => 5,'Sr. EXEC' => 6};
       PCLevelsMap = new Map<String, Integer>{ '1. Key Operations' => 1, '2. Business Unit' => 2, '3. Group' => 3 , '4. Corporate' => 4, '5. Executive' => 5,'6. Senior Executive' => 6};  
      system.debug('User id is : '+username );
      system.debug('Profile id is : '+profileId);
      system.debug('Profile Name is : '+ProfileName);
      system.debug('Id is : '+ApexPages.currentPage().getParameters().get('Id'));
      system.debug('retURL is : '+ApexPages.currentPage().getParameters().get('retURL'));
      system.debug('save new is : '+ApexPages.currentPage().getParameters().get('save_new'));
       apprvrgrprecordId = ApexPages.currentPage().getParameters().get('id');
       //Below is new mode
     if(ApexPages.currentPage().getParameters().get('save_new') != null || (ApexPages.currentPage().getParameters().get('id') == null && ApexPages.currentPage().getParameters().get('retURL') != null))
     //if(ApexPages.currentPage().getParameters().get('retURL') != null)
       {
           System.debug('new clicked');
           if(ProfileName != null && ProfileName == 'RFA - Standard User' )
           {
              List<ProfitCenterUserRole__c> PCUobj = [select Level__c from ProfitCenterUserRole__c where UserName__c = : username and UserType__c = 'Location Coordinator' ];
               if(PCUobj != null && PCUobj.size() >0 )
               {
                 getAvailableLevels();
                 viewmode  = false;
                 editmode = false;
               }
               else
               {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'As you are not identified as Location Co-ordinator on any of the Profit Centers you are not authorized to create any Approver Group..'));  
                  showmessage = true ; 
               }    
           }
           else if(ProfileName  == 'System Administrator' || ProfileName  =='RFA - System Administrator')
           {
               getAvailableLevels();
               viewmode  = false;
               editmode = false;
           }
           else
           {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not authorized to create any Approver Group.'));  
             showmessage = true ;
           }     
            
       } 
       //Below is Edit Mode     
      else if( ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('retURL') != null)
       {            
            system.debug('Entered Edit mode');
           //Below code restricts the logged user to edit the records greater than their level            
            system.debug('Edited record id:' +apprvrgrprecordId);
             recordlevel = [select Level__c from Approver_Group__c where Id=: apprvrgrprecordId].Level__c ;
            selectedLevel = recordlevel;
          appvrgrpobj = [select Approver_Role__c,level__c,Approver_Group_Description__c  from Approver_Group__c where Id=: apprvrgrprecordId limit 1] ;
           selectedRole = appvrgrpobj.Approver_Role__c;
           selectedDescrip = appvrgrpobj.Approver_Group_Description__c ;
            system.debug('Edited record level is:' +recordlevel);
             currentlevel = LevelsMap.get(recordlevel );
            system.debug('Maped record level is:' +currentlevel);
            //&& ProfileName == 'RFA - Standard User
           if(ProfileName != null && ProfileName == 'RFA - Standard User' )
           {
             system.debug('User is a rfa std user');
              List<ProfitCenterUserRole__c> PCUobj = [select Level__c from ProfitCenterUserRole__c where UserName__c = : username and UserType__c = 'Location Coordinator' ];
              system.debug('User presentin PC;'+PCUobj.size());
              if(PCUobj  != null && PCUobj.size() > 0)
                 {
                    for(ProfitCenterUserRole__c obj : PCUobj)
                    {
                      Integer PCUserLevel = PCLevelsMap.get(obj.Level__c);
                      system.debug('ProfitCenter User level is:' +PCUserLevel );
                        if(currentlevel > PCUserLevel)
                        {
                          //show pop up message
                           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You donot have permissions to Edit this record...'));  
                           showmessage = true ; 
                        }
                        else
                        {
                         viewmode  = false;
                         editmode = true;
                            
                         }
                     }
                  }
               else
               {                  
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You donot have permissions to Edit this record...'));  
                   showmessage = true ; 
               }
           }
           else if(ProfileName  == 'System Administrator' || ProfileName  =='RFA - System Administrator')
           {                      
             viewmode  = false;
             editmode = true;
             getAvailableLevels();
           }
           else
           {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You donot have permissions to Edit this record...'));  
             showmessage = true ;            
           }
       }
       //Below is View Mode
       else if( ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('retURL') == null)
       {  
        System.debug('Entered View mode');                            
           editmode = false;
           viewmode  = true;
           if(apprvrgrprecordId!=null)
           {
               selectedLevel   = [select Level__c from Approver_Group__c where Id=: apprvrgrprecordId].Level__c ;
               selectedRole   = [select Approver_Role__c from Approver_Group__c where Id=: apprvrgrprecordId].Approver_Role__c;
           }
           system.debug('hello im here');
       }
       //Below is Delete Mode
       else
       {
          system.debug('Entered Delete mode');
           //Below code restricts the logged user to delete the records greater than their level            
            system.debug('deleted record id:' +apprvrgrprecordId);
             recordlevel = [select Level__c from Approver_Group__c where Id=: apprvrgrprecordId].Level__c ;            
            system.debug('Deleted record level is:' +recordlevel);
             currentlevel = LevelsMap.get(recordlevel );
            system.debug('Maped record level is:' +currentlevel);           
           if(ProfileName != null && ProfileName == 'RFA - Standard User' )
           {
             system.debug('User is a rfa std user');
              List<ProfitCenterUserRole__c> PCUobj = [select Level__c from ProfitCenterUserRole__c where UserName__c = : username and UserType__c = 'Location Coordinator' ];
              system.debug('User presentin PC;'+PCUobj.size());
              if(PCUobj  != null && PCUobj.size() > 0)
                 {
                    for(ProfitCenterUserRole__c obj : PCUobj)
                    {
                      Integer PCUserLevel = PCLevelsMap.get(obj.Level__c);
                      system.debug('ProfitCenter User level is:' +PCUserLevel );
                        if(currentlevel > PCUserLevel)
                        {
                          //show pop up message
                           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You donot have permissions to Delete this record...'));  
                           showmessage = true ; 
                        }
                        else
                        {
                          deletegroup();
                            
                        }
                     }
                  }
               else
               {                  
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'As you are not identified as Location Co-ordinator on any of the Profit Centers you are not authorized to Delete any Approver Group....'));  
                   showmessage = true ; 
               }
           }
           else if(ProfileName  == 'System Administrator' || ProfileName  =='RFA - System Administrator')
           {
               deletegroup();
           }
           else
           {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not authorized to Delete any Approver Group.'));  
             showmessage = true ;
           }    
               
         
       }
       
         
    }
   
    public void getAvailableLevels()
    {
        /*
        Map<String,List<String>> availableLevels = new Map<String,List<String>>();                
        availableLevels.put('1. Key Operations', new  List <String> {'KEYOP'});
        availableLevels.put('2. Business Unit', new  List <String> {'KEYOP','BU'});
        availableLevels.put('3. Group', new  List <String> {'KEYOP','BU','GROUP'});
        availableLevels.put('4. Corporate', new  List <String> {'KEYOP','BU','GROUP','CORP'}); 
        availableLevels.put('5. Executive', new  List <String> {'KEYOP','BU','GROUP','CORP','EXEC'});
        availableLevels.put('6. Senior Executive', new  List <String> {'KEYOP','BU','GROUP','CORP','EXEC','Sr. EXEC'});
        
        List<ProfitCenterUserRole__c> PCUobj = [select Level__c from ProfitCenterUserRole__c where UserName__c = : username and UserType__c = 'Location Coordinator'  order by  Level__c desc];             
        System.debug('hii'+PCUobj);
        levels = new List<SelectOption>(); 
        levels.add(new SelectOption('--Select--','--Select--'));
        List<String> levelsList=null;
        System.debug('hii profile'+ProfileName);
        if(ProfileName=='System Administrator')
        {
             levelsList=availableLevels.get('6. Senior Executive');
             for(String eachLevel:levelsList)
             {
                 Levels.add(new SelectOption(eachLevel,eachLevel));
             }
        }
        else if(PCUobj!=null )
        {
                String UserLevel = PCUobj.get(0).Level__c;
                System.debug('Users Highest level is..'+UserLevel); 
                levelsList = availableLevels.get(UserLevel);
                
                System.debug('levelsList for '+'current level'+UserLevel+' is '+levelsList);
               
                for(String eachLevel:levelsList)
                {
                    Levels.add(new SelectOption(eachLevel,eachLevel));
                }
        }  
        
        System.debug('hello im at end');*/
        Levels = RFA_VFC_CoordinatorLevelHelper.getAvailableLevels();
        System.debug('Levels that can be accessed '+Levels);
    }
    public pagereference deletegroup()
    {
      List<Approver_Group__c > delobj =[select Approver_Role__c,level__c,Approver_Group_Description__c  from Approver_Group__c where Id=: apprvrgrprecordId ] ;
      delete delobj;
      pagereference pref = new pagereference('/a1k?fcf=00Bg00000016xof');
      return pref;
    } 
    public pagereference Bck()
    {
      pagereference pref = new pagereference('/a1k?fcf=00Bg00000016xof');
      return pref;
    }
    Public PageReference SaveGroup()
    {
        try{
            Boolean flag=false;
            System.debug('View mode when clicked Edit'+viewMode);
            System.debug('Edit mode when clicked Edit'+EditMode);
        if(selectedLevel=='--Select--')
        {
            FieldMsgs = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Level'));
        }
       else{
               // appvrgrpobj.Level__c = selectedLevel;
               //appvrgrpobj.Approver_Role__c = selectedRole;
                String checkGroup= selectedLevel+' '+ selectedRole;
                List<Approver_Group__c> availableGroups=null;
                if(viewMode==false&&EditMode==false)
                {
                    System.debug('checkGroup'+checkGroup);
                     availableGroups=[Select Approver_GroupName__c,Approver_Group_Description__c from Approver_Group__c where Approver_GroupName__c=:checkGroup];
                    System.debug('Available groups in insert'+availableGroups);
                    if(availableGroups.size()>0)
                    {
                        showmessage = false;
                        viewMode = false;
                        FieldMsgs= true;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The intended Approver group is already present in the system')); 
                    }
                    else{
                         appvrgrpobj.Level__c = selectedLevel;
                           appvrgrpobj.Approver_Role__c = selectedRole;
                        insert appvrgrpobj;
                        showmessage = false;
                        FieldMsgs= true;
                        viewMode = false;
                        flag = true;
                    }
                    
                }
                else if(viewMode==false&&EditMode==true)
                {
                    System.debug(appvrgrpobj.Level__c);
                    System.debug(selectedLevel );                    
                    System.debug(appvrgrpobj.Approver_Role__c );
                    System.debug(selectedRole);
                    
                    
                    if(appvrgrpobj.Level__c != selectedLevel || appvrgrpobj.Approver_Role__c != selectedRole)
                    {
                    availableGroups=[Select Approver_GroupName__c,Approver_Group_Description__c from Approver_Group__c where Approver_GroupName__c=:checkGroup];
                    System.debug('Available groups in update'+availableGroups);
                    System.debug('checkGroup'+checkGroup);
                        if(availableGroups.size()>=1)
                        {
                            System.debug('duplicate Groups are present');
                            showmessage = false;
                            FieldMsgs= true;
                            viewMode = false;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The intended Approver group is already present in the system')); 
                        }
                        else
                        {
                            appvrgrpobj.Level__c = selectedLevel;
                           appvrgrpobj.Approver_Role__c = selectedRole;
                           appvrgrpobj.Approver_Group_Description__c = selectedDescrip ;
                           system.debug('update 1'+appvrgrpobj);
                            update appvrgrpobj;
                             flag = true;    
                        }
                    }
                    else{
                     appvrgrpobj.Level__c = selectedLevel;
                       appvrgrpobj.Approver_Role__c = selectedRole;
                       appvrgrpobj.Approver_Group_Description__c = selectedDescrip ;
                       system.debug('update 2'+appvrgrpobj);
                        update appvrgrpobj;
                        flag = true;    
                    }
                    
                }
            if(flag == true)
            {
                
                appvrgrpobj= [select Level__c,Approver_GroupName__c from Approver_Group__c where Id=: appvrgrpobj.id];
            
                PageReference pageRef = new PageReference('/' +appvrgrpobj.Id);
                appvrgrpobj=[select Level__c,Approver_Role__c,Approver_GroupName__c,Approver_Group_Description__c from Approver_Group__c where Id=: appvrgrpobj.id];
                return pageRef;  
            }
        }
        }
        catch(Exception e)
        {
            FieldMsgs = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));    
        }
        system.debug('view mode at end'+viewMode);
        return null;
      
    } 
    
    
}