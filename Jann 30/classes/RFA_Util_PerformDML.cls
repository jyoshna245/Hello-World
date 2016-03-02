/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_Util_PerformDML
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 05/14/2012
 *  Assumptions      : N/A
 *  Description      : This utility class will contain generic DML methods which can be called from other class.
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
 
 
public class RFA_Util_PerformDML
{
    
    public static List<ProfitCenterUserRole__c> profitCenterAssociatedRoles = new List<ProfitCenterUserRole__c>();
      
      /**
        *  @ Description : Method to handle the insert operation of List of generic SObject
        *  @ param : list<SObject>
        *  @ return : List<Database.Saveresult>
        */
      public static List<Database.Saveresult> performInsOperation(List<SObject> objectsInsList)
      {
        Database.Saveresult[] result = Database.insert(objectsInsList, false);
        return result;
      }      
 
      
      /**
        *  @ Description : Method to handle the update operation of List of generic SObject
        *  @ param : list<SObject>
        *  @ return : List<Database.Saveresult>
        */
      public static List<Database.Saveresult> performUpdOperation(List<SObject> objectsForUpdlist)
      {
        Database.Saveresult[] result = Database.update(objectsForUpdlist, false);
        return result;
      }
      
  
      /**
        *  @ Description : Method to handle the upsert operation of List of generic SObject
        *  @ param : list<SObject>
        *  @ return : List<Database.UpsertResult>
        */
      public static List<Database.UpsertResult> performUpsOperation(List<SObject> objectsForUpsList)
      {
        Database.UpsertResult[] result = Database.upsert(objectsForUpsList, false);
        return result;
      }   
     
      
      /**
        *  @ Description : Method to handle the delete operation of List of generic SObject
        *  @ param : list<SObject>
        *  @ return : List<Database.DeleteResult>
        */
      public static List<Database.DeleteResult> performDelOperation(List<SObject> objectsForDelList)
      {
        Database.DeleteResult[] result = Database.delete(objectsForDelList, false);
        return result;
      }     
      
      
      public List<ProfitCenterUserRole__c> getLoggedInUserRoleDetails(String loggedInUser, String profitCenter)
      {
            if(profitCenterAssociatedRoles.isEmpty())
            {
                for(ProfitCenterUserRole__c userRole : [Select Id, Level__c, ProfitCenter__c, UserName__c, UserType__c 
                                                        FROM ProfitCenterUserRole__c 
                                                        WHERE ProfitCenter__c =: profitCenter 
                                                        AND UserName__c = : loggedInUser])
                {
                     profitCenterAssociatedRoles.add(userRole); 
                }                                        
            }
            return profitCenterAssociatedRoles;
                
      }
     
}