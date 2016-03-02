trigger PUR_ProfitCenterUserRoleTrigger on ProfitCenterUserRole__c (After insert, after update, before insert, before update,before delete,after delete) {

   /*~~~~Start of Initialization~~~~*/
   RFA_AP01_ProfitCenterUserRole pcUsrRole = new RFA_AP01_ProfitCenterUserRole ();
   User usr=[Select Profile.Name, id from User where id=:UserInfo.getUserId() Limit 1]; // User query to fetch profile Name for logged In user to bypass the custom validation
   String UserNameProfile=usr.Profile.Name;
   

   /*~~~~End of Initialization~~~~*/
   
   /****************************Trigger Before action block starts here**********************************************/
   if(Trigger.IsBefore)
    {
        
        /****************************Trigger before insert or update block starts here***********************************/      
        //Start - added by Ashwani on 19 Apr 2013 for FR1.51
        if(Trigger.IsInsert || Trigger.Isupdate)
        { 
        for(ProfitCenterUserRole__c pcur:Trigger.new)
        
            {
                    if(pcur.UserType__c==Label.RFA_Cl066) pcur.level__c=Label.RFA_FR1_51_01; 
                    else if(pcur.UserType__c==Label.RFA_Cl067) pcur.level__c=Label.RFA_FR1_51_02;   
            }
        }
        //End        
        /**********************************Trigger before insert block starts here***************************/
        if(Trigger.IsInsert)
        {
            if(UserNameProfile!=Label.RFA_CL053 &&  UserNameProfile!=Label.RFA_CL052 && UserNameProfile!=Label.RFA_CL054 && UserNameProfile!=Label.RFA_CL055) // Bypass for System Admin profile
                pcUsrRole.processRecords(Trigger.New,'Trigger.New');               // calling the custom validation for permission access to udpate the records 
            
        
        }
        /**********************************Trigger before insert block Ends here***************************/
        
        /**********************************Trigger before update block starts here***************************/
        if(Trigger.isUpdate)
        {
            
            if(UserNameProfile!=Label.RFA_CL053 &&  UserNameProfile!=Label.RFA_CL052 && UserNameProfile!=Label.RFA_CL054 && UserNameProfile!=Label.RFA_CL055) // Bypass for System Admin profile
            {
                pcUsrRole.processRecords(Trigger.Old,'Trigger.Update'); // calling the custom validation for permission access to udpate the records
                pcUsrRole.processRecords(Trigger.New,'Trigger.New'); // calling the custom validation for permission access to udpate the records
                
            
            }
        }
        /**********************************Trigger before update block ends here***************************/
        
        /**********************************Trigger before delete block starts here***************************/
        
        if(Trigger.IsDelete)
        {
            if(UserNameProfile!=Label.RFA_CL053 &&  UserNameProfile!=Label.RFA_CL052 && UserNameProfile!=Label.RFA_CL054 && UserNameProfile!=Label.RFA_CL055)  // Bypass for System Admin profile
                pcUsrRole.processRecords(Trigger.Old,'Trigger.Old'); // calling the custom validation for permission access to udpate the records
                          
        }
        /**********************************Trigger before delete block ends here***************************/
    }
    
    /****************************Trigger Before action block ends here**********************************************/
    
    /****************************Trigger After action block starts here**********************************************/
    if(Trigger.IsAfter)
    {
        /**********************************Trigger after insert block starts here***************************/
        if(Trigger.IsInsert)
        {
           pcUsrRole.updateProfitCenterForMinLevelRecords(Trigger.New); 
                    
        }
    /**********************************Trigger after insert block ends here***************************/
        
        /**********************************Trigger after update block starts here***************************/
        
        if(Trigger.IsUpdate)
        {
           pcUsrRole.updateProfitCenterForMinLevelRecords(Trigger.new);
           
        }
                /**********************************Trigger after update block ends here***************************/
        if(Trigger.IsDelete)
        {
            pcUsrRole.updateProfitCenterForMinLevelRecords(Trigger.old);
        }       
    
    }
        /****************************Trigger After action block ends here**********************************************/
   

}