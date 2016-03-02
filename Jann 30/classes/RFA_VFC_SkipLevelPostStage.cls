public class RFA_VFC_SkipLevelPostStage {

    //31st
    public Id validationOfskipLevel()
    {    
        String skippedlevel='';         
        List<RFA__c> rfalist= [SELECT Id, level__C, stage__C, ProfitCenterNumber__c ,levelstage__C FROM RFA__c WHERE Id IN: Trigger.newMap.keySet()];
        RFA__c rfaobj=rfalist.get(0);
        Boolean hascoord= false;   
        //List to fetch the next level for current level
        Map<String, String> pcnextLevelMap = new Map<String, String>{
            '1. Key Operations'    =>  '2. Business Unit',
                '2. Business Unit'  =>  '3. Group',
                '3. Group'  =>  '4. Corporate',
                '4. Corporate'  =>  '5. Executive',
                '5. Executive'  =>  '6. Senior Executive'
                }; 
                    
        if(RFAStaticVariables.doskiplevelProcess==true)
        { 
            String nextLevel=pcnextLevelMap.get(rfaobj.level__c);
            //This loop iterates until it finds the level for which the location coordinators are defined for the RFA's related Profit center.
            Map<String,Integer> CoordinaorsList=null;
            if(nextLevel!=null)
            {
                CoordinaorsList = getCordinatordetails(rfaobj);                    
                while(hascoord==false){ 
                   
                    //If profit center users are not present for the nextLevel, then fetch the next level from pcnextLevelMap
                    if(CoordinaorsList.get(nextLevel)==null)
                    {                    
                        skippedlevel=nextLevel;                    
                        nextLevel=pcnextLevelMap.get(nextLevel); 
                        //To stop from looping after the last level
                        if(skippedlevel==RFAStaticVariables.Level6)
                        {
                            hascoord=true;   
                        }
                    }  
                    else{
                        hascoord=true;                   
                    } 
                }
            }           
            RFAStaticVariables.skiplevel=true;            
            RFAStaticVariables.doskiplevelProcess=false;
            RFAStaticVariables.level =skippedlevel;
            if(skippedlevel!='')
             {
                 rfaObj.level__c=skippedlevel;
             	 //rfaObj.stage__C=RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE;
                 system.debug('Updating second time...');
                 update rfaObj;
             }
            return rfaobj.id; 
        }
        else
        {
            return null;
        } 
    }
    
    //Below method gets the coordinators present on the Profit Ceneter linked to RFA    
    public  Map<String,Integer> getCordinatordetails(RFA__c rfaobj)
    { 
        //The list "aggres" stores all the Location coordinators for each level defined on the Profit center
        List <AggregateResult> aggres = [SELECT Level__c,count(id) PFUsersCount from ProfitCenterUserRole__c WHERE ProfitCenter__c =:rfaObj.ProfitCenterNumber__c
                                        GROUP BY Level__c];
        
        Map<String,Integer> LocationCordinatorsList= new  Map<String,Integer>();        
        for (AggregateResult res : aggres)
        {           
            String level=(String)res.get('Level__c');
            Integer userCount=(Integer)res.get('PFUsersCount');
            LocationCordinatorsList.put(level,userCount );
        }
        
        return LocationCordinatorsList;
    }    

}