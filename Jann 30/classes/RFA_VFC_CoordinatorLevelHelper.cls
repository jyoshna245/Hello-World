public  class RFA_VFC_CoordinatorLevelHelper {
    static Id username;
    static String ProfileName;
    static Id profileId;
    static Map<String,List<String>> availableLevels;
    static Map<String,List<String>> availableControlLevels = new Map<String,List<String>>{'1. Key Operations'=> new  List <String> {'KEYOP'}};
    public static List<SelectOption> getAvailableLevels()
    {
        username = userinfo.getUserId();
        ProfileName=null;
        profileId=userinfo.getProfileId();              
        availableLevels = new Map<String,List<String>>();        
        ProfileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        availableLevels.put('1. Key Operations', new  List <String> {'KEYOP'});
        availableLevels.put('2. Business Unit', new  List <String> {'KEYOP','BU'});
        availableLevels.put('3. Group', new  List <String> {'KEYOP','BU','GROUP'});
        availableLevels.put('4. Corporate', new  List <String> {'KEYOP','BU','GROUP','CORP'}); 
        availableLevels.put('5. Executive', new  List <String> {'KEYOP','BU','GROUP','CORP','EXEC'});
        availableLevels.put('6. Senior Executive', new  List <String> {'KEYOP','BU','GROUP','CORP','EXEC','Sr. EXEC'});
        List<selectOption> returnLevel = LevelsAccessed(availableLevels);
        
        return returnLevel;
      
    } 
    public Static List<SelectOption> getAvailableControlLevels()
    {
        username = userinfo.getUserId();
        ProfileName=null;
        profileId=userinfo.getProfileId();              
        availableControlLevels = new Map<String,List<String>>();        
        ProfileName=[Select Id,Name from Profile where Id=:profileId].Name;
         
        availableControlLevels.put('1. Key Operations', new  List <String> {'KEYOP'});
        availableControlLevels.put('2. Business Unit', new  List <String> {'KEYOP','BU'});
        availableControlLevels.put('3. Group', new  List <String> {'KEYOP','BU','GROUP'});
        availableControlLevels.put('4. Corporate', new  List <String> {'KEYOP','BU','GROUP','CORP'}); 
        availableControlLevels.put('5. Executive', new  List <String> {'KEYOP','BU','GROUP','CORP'});
        availableControlLevels.put('6. Senior Executive', new  List <String> {'KEYOP','BU','GROUP','CORP'});
		List<selectOption> returnLevel = LevelsAccessed(availableControlLevels);
        
        return returnLevel;
    }
	
    public static List<selectOption> LevelsAccessed(Map<String,List<String>> maplevel)
    {
         
        List<ProfitCenterUserRole__c> PCUobj = [select Level__c from ProfitCenterUserRole__c where UserName__c = : username and UserType__c = 'Location Coordinator'  order by  Level__c desc];             
        System.debug('hii'+PCUobj);
        List<SelectOption> levels = new List<SelectOption>(); 
        levels.add(new SelectOption('--Select--','--Select--'));
        List<String> levelsList=null;
        System.debug('hii profile'+ProfileName);
        if(ProfileName=='System Administrator')
        {
             levelsList=maplevel.get('6. Senior Executive');
             for(String eachLevel:levelsList)
             {
                 Levels.add(new SelectOption(eachLevel,eachLevel));
             }
        }
        else if(PCUobj!=null )
        {
                String UserLevel = PCUobj.get(0).Level__c;
                System.debug('Users Highest level is..'+UserLevel); 
                levelsList = maplevel.get(UserLevel);
                
                System.debug('levelsList for '+'current level'+UserLevel+' is '+levelsList);
               
                for(String eachLevel:levelsList)
                {
                    Levels.add(new SelectOption(eachLevel,eachLevel));
                }
        }  
        System.debug('hello im at end');
        return Levels;
    }
}