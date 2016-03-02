/******************************************************************************************************************
*Class            : ITPR_DepartmentalSuperUsers_share
*Author           : Capgemini
*Version History  : 1.0
*Creation         : 15/12/2014
*Assumptions      : N/A
*Description      : This class is used to share the IT-SES record of user in Requestor field with users selected in viewer fields.
******************************************************************************************************************/

public class ITPR_DepartmentalSuperUsers_share1{
   
   public List<Database.SaveResult>  DSU_ITPR_Share(List<DepartmentalSuperUser__c> allDepartmentSU)
   {
      //List to add new ITPR__Share objects
        List<Id> ownerIds = new List<Id>();      
        List<ITPR__Share> lstITPRShare = new List<ITPR__Share>();
        List<ITPR__c> lstITPR = new List<ITPR__c>();
        Map<Id, ITPR__Share> maptemp = new Map<Id, ITPR__Share>();
        ITPR__Share ITPRshare1;
        ITPR__Share ITPRshare2;
        ITPR__Share ITPRshare3;
        ITPR__Share ITPRshare4;
        ITPR__Share ITPRshare5;
    /********* End of Initialisation of variables ******/
      for(DepartmentalSuperUser__c d : allDepartmentSU){
          ownerIds.add(d.ownerId);
      }   
      
       lstITPR = [SELECT Id,CreatedById, status__c,Vendor_Governance__c,Procurement_Assignee__c,Legal_Assignee__c,Finance_Assignee__c FROM ITPR__c where CreatedById IN :ownerIds OR
                     Procurement_Assignee__c IN :ownerIds OR Legal_Assignee__c IN :ownerIds 
                     OR Finance_Assignee__c IN :ownerIds  OR Vendor_Governance__c IN :ownerIds];
      
      for(DepartmentalSuperUser__c DSU: allDepartmentSU){
          
          for(ITPR__c ITPR : lstITPR){
              
              if( (ITPR.CreatedById == DSU.ownerId) || (ITPR.Procurement_Assignee__c == DSU.ownerId) || (ITPR.Legal_Assignee__c == DSU.ownerId) || (ITPR.Finance_Assignee__c == DSU.ownerId) || (ITPR.Vendor_Governance__c == DSU.ownerId) ){
               
               {
                System.debug('Inside DSU_ITPR_Share....');
                if(DSU.Viewer1__c != null)
                 {
        
                ITPRshare1 = new ITPR__Share();                    
                
                ITPRshare1.ParentId = ITPR.Id;
                ITPRshare1.UserOrGroupId = DSU.Viewer1__c;
                ITPRshare1.AccessLevel = 'Read';
                // If Type of Access Defined as Read/Edit then check
                system.debug('xxxx'+DSU.Type_of_Access_1__c +'zzzz'+DSU.Viewer1__c + 'yyy'+DSU.Additional_Access_1_Department__c);
                If(DSU.Type_of_Access_1__c == 'Read/Edit')
                {
                  If(ITPR.Status__c == 'Draft')   
                { 
                  if (DSU.Additional_Access_1_Department__c == 'ITSES - Requestor'){
                       ITPRshare1.AccessLevel = 'Edit';
                       
                 }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Procurement')
                  {
                      ITPRshare1.AccessLevel = 'Read';
                       
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare1.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }
               } else if(ITPR.Status__c == 'Submitted' || ITPR.Status__c == 'Assigned')
                  {
                   if (DSU.Additional_Access_1_Department__c == 'ITSES - Requestor'){
                      ITPRshare1.AccessLevel = 'Read';
                       
                } else if(DSU.Additional_Access_1_Department__c == 'ITSES - Finance')
                  {
                      ITPRshare1.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare1.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare1.AccessLevel = 'Edit';
                      
                  } else if(DSU.Additional_Access_1_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare1.AccessLevel = 'Edit';
                      
                  }
               }else if(ITPR.Status__c == 'In Process' ){
                   if (DSU.Additional_Access_1_Department__c == 'ITSES - Requestor'){
                     ITPRshare1.AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Finance')
                  {
                    ITPRshare1.AccessLevel = 'Edit';
                     
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare1.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare1.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare1.AccessLevel = 'Edit';
                      
                  }
               }else if((ITPR.Status__c == 'Pending Project Final Budget') || (ITPR.Status__c == 'Pending More Info Needed' )){
                   if (DSU.Additional_Access_1_Department__c == 'ITSES - Requestor'){
                  ITPRshare1.AccessLevel = 'Edit';
                   
                 }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }
               }                
                  
                  else if(ITPR.Status__c == 'In Approvals' ){
                  system.debug('InApprovals');
                  if (DSU.Additional_Access_1_Department__c == 'ITSES - Requestor'){
                      
                      ITPRshare1.AccessLevel = 'Read';
                       
                 }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Finance')
                  {  
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Legal')
                  {  
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Vendor Governance')
                  {  
                      
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }
               }  else if(ITPR.Status__c == 'All Digital Initials Obtained' ){
                   if(DSU.Additional_Access_1_Department__c =='ITSES - Requestor'){
                     ITPRshare1.AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Finance')
                  {
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare1.AccessLevel = 'Edit';
                      
                  }
               }  else if((ITPR.Status__c == 'Cancelled') || (ITPR.Status__c == 'On Hold') || (ITPR.Status__c == 'Complete') || (ITPR.Status__c == 'Executed and Filed') || (ITPR.Status__c == 'Not Executed and Closed')){
                   if (DSU.Additional_Access_1_Department__c == 'ITSES - Requestor'){
                       ITPRshare1.AccessLevel = 'Read';
                        
                 }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Finance')
                  {    
                     ITPRshare1.AccessLevel = 'Read';
                      
                  } else if(DSU.Additional_Access_1_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_1_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare1.AccessLevel = 'Read';
                      
                  }
              }                       
            }
                
                ITPRshare1.RowCause = Schema.ITPR__Share.RowCause.Departmental_User_Sharing__c;
                //lstITPRShare.add(ITPRshare1);
                maptemp.put(ITPRshare1.UserOrGroupId,ITPRshare1);
            }
                
            if(DSU.Viewer2__c != null)
            {
                ITPRshare2 = new ITPR__Share();
                
                ITPRshare2.ParentId = ITPR.Id;
                ITPRshare2.UserOrGroupId = DSU.Viewer2__c;
                ITPRshare2.AccessLevel = 'Read';
           // If Type of Access Defined as Read/Edit then check     
                If(DSU.Type_of_Access_2__c == 'Read/Edit')
                {
                  If(ITPR.Status__c == 'Draft')   
                { 
                  if (DSU.Additional_Access_2_Department__c == 'ITSES - Requestor'){
                       ITPRshare2.AccessLevel = 'Edit';
                       
                 }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Procurement')
                  {
                      ITPRshare2.AccessLevel = 'Read';
                       
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare2.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }
               } else if(ITPR.Status__c == 'Submitted' || ITPR.Status__c == 'Assigned')
                  {
                   if (DSU.Additional_Access_2_Department__c == 'ITSES - Requestor'){
                      ITPRshare2.AccessLevel = 'Read';
                       
                } else if(DSU.Additional_Access_2_Department__c == 'ITSES - Finance')
                  {
                      ITPRshare2.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare2.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare2.AccessLevel = 'Edit';
                      
                  } else if(DSU.Additional_Access_2_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare2.AccessLevel = 'Edit';
                      
                  }
               }else if(ITPR.Status__c == 'In Process' ){
                   if (DSU.Additional_Access_2_Department__c == 'ITSES - Requestor'){
                     ITPRshare2.AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Finance')
                  {
                    ITPRshare2.AccessLevel = 'Edit';
                     
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare2.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare2.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare2.AccessLevel = 'Edit';
                      
                  }
               }else if((ITPR.Status__c == 'Pending Project Final Budget') || (ITPR.Status__c == 'Pending More Info Needed' )){
                   if (DSU.Additional_Access_2_Department__c == 'ITSES - Requestor'){
                  ITPRshare2.AccessLevel = 'Edit';
                   
                 }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }
               }  else if(ITPR.Status__c == 'In Approvals' ){
                  if (DSU.Additional_Access_2_Department__c == 'ITSES - Requestor'){
                      ITPRshare2.AccessLevel = 'Read';
                       
                 }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Finance')
                  {
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }
               }  else if(ITPR.Status__c == 'All Digital Initials Obtained' ){
                   if (DSU.Additional_Access_2_Department__c =='ITSES - Requestor'){
                     ITPRshare2.AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Finance')
                  {
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare2.AccessLevel = 'Edit';
                      
                  }
               }  else if((ITPR.Status__c == 'Cancelled') || (ITPR.Status__c == 'On Hold') || (ITPR.Status__c == 'Complete') || (ITPR.Status__c == 'Executed and Filed') || (ITPR.Status__c == 'Not Executed and Closed')){
                   if (DSU.Additional_Access_2_Department__c == 'ITSES - Requestor'){
                       ITPRshare2.AccessLevel = 'Read';
                        
                 }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Finance')
                  {    
                     ITPRshare2.AccessLevel = 'Read';
                      
                  } else if(DSU.Additional_Access_2_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_2_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare2.AccessLevel = 'Read';
                      
                  }
              }                       
            }                  
                ITPRshare2.RowCause = Schema.ITPR__Share.RowCause.Departmental_User_Sharing__c;
                //lstITPRShare.add(ITPRshare2);
                maptemp.put(ITPRshare2.UserOrGroupId,ITPRshare2);
            }
            
            if(DSU.Viewer3__c != null)
            {
                ITPRshare3 = new ITPR__Share();
                
                ITPRshare3.ParentId = ITPR.Id;
                ITPRshare3.UserOrGroupId = DSU.Viewer3__c;
                ITPRshare3.AccessLevel = 'Read';
                // If Type of Access Defined as Read/Edit then check
                If(DSU.Type_of_Access_3__c == 'Read/Edit')
                 {
                  If(ITPR.Status__c == 'Draft')   //If(DSU.Type_of_Access_4__c == 'Read/Edit')
                { 
                  if (DSU.Additional_Access_3_Department__c == 'ITSES - Requestor'){
                       ITPRshare3.AccessLevel = 'Edit';
                       
                 }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Procurement')
                  {
                      ITPRshare3.AccessLevel = 'Read';
                       
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare3.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }
               } else if(ITPR.Status__c == 'Submitted' || ITPR.Status__c == 'Assigned')
                  {
                   if (DSU.Additional_Access_3_Department__c == 'ITSES - Requestor'){
                      ITPRshare3.AccessLevel = 'Read';
                       
                } else if(DSU.Additional_Access_3_Department__c == 'ITSES - Finance')
                  {
                      ITPRshare3.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare3.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare3.AccessLevel = 'Edit';
                      
                  } else if(DSU.Additional_Access_3_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare3.AccessLevel = 'Edit';
                      
                  }
               }else if(ITPR.Status__c == 'In Process' ){
                   if (DSU.Additional_Access_3_Department__c == 'ITSES - Requestor'){
                     ITPRshare3.AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Finance')
                  {
                    ITPRshare3.AccessLevel = 'Edit';
                     
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare3.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare3.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare3.AccessLevel = 'Edit';
                      
                  }
               }else if((ITPR.Status__c == 'Pending Project Final Budget') || (ITPR.Status__c == 'Pending More Info Needed' )){
                   if (DSU.Additional_Access_3_Department__c == 'ITSES - Requestor'){
                  ITPRshare3.AccessLevel = 'Edit';
                   
                 }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }
               }  else if(ITPR.Status__c == 'In Approvals' ){
                  if (DSU.Additional_Access_3_Department__c == 'ITSES - Requestor'){
                      ITPRshare3.AccessLevel = 'Read';
                       
                 }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Finance')
                  {
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }
               }  else if(ITPR.Status__c == 'All Digital Initials Obtained' ){
                   if (DSU.Additional_Access_3_Department__c =='ITSES - Requestor'){
                     ITPRshare3.AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Finance')
                  {
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare3.AccessLevel = 'Edit';
                      
                  }
               }  else if((ITPR.Status__c == 'Cancelled') || (ITPR.Status__c == 'On Hold') || (ITPR.Status__c == 'Complete') || (ITPR.Status__c == 'Executed and Filed') || (ITPR.Status__c == 'Not Executed and Closed')){
                   if (DSU.Additional_Access_3_Department__c == 'ITSES - Requestor'){
                       ITPRshare3.AccessLevel = 'Read';
                        
                 }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Finance')
                  {    
                     ITPRshare3.AccessLevel = 'Read';
                      
                  } else if(DSU.Additional_Access_3_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_3_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare3.AccessLevel = 'Read';
                      
                  }
              }                       
            }
               ITPRshare3.RowCause = Schema.ITPR__Share.RowCause.Departmental_User_Sharing__c;
                //lstITPRShare.add(ITPRshare3);
                maptemp.put(ITPRshare3.UserOrGroupId,ITPRshare3);
            }
            
            if(DSU.Viewer4__c != null)
            {
                ITPRshare4 = new ITPR__Share();
                
                ITPRshare4.ParentId = ITPR.Id;
                ITPRshare4.UserOrGroupId = DSU.Viewer4__c;                                       
                ITPRshare4.AccessLevel = 'Read';
                // If Type of Access Defined as Read/Edit then check
                If(DSU.Type_of_Access_4__c == 'Read/Edit')
                {
                  If(ITPR.Status__c == 'Draft')  
                { 
                  if (DSU.Additional_Access_4_Department__c == 'ITSES - Requestor'){
                       ITPRshare4.AccessLevel = 'Edit';
                       
                 }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Procurement')
                  {
                      ITPRshare4.AccessLevel = 'Read';
                       
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare4.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }
               } else if(ITPR.Status__c == 'Submitted' || ITPR.Status__c == 'Assigned')
                  {
                   if (DSU.Additional_Access_4_Department__c == 'ITSES - Requestor'){
                      ITPRshare4.AccessLevel = 'Read';
                       
                } else if(DSU.Additional_Access_4_Department__c == 'ITSES - Finance')
                  {
                      ITPRshare4.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare4.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare4.AccessLevel = 'Edit';
                      
                  } else if(DSU.Additional_Access_4_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare4.AccessLevel = 'Edit';
                      
                  }
               }else if(ITPR.Status__c == 'In Process' ){
                   if (DSU.Additional_Access_4_Department__c == 'ITSES - Requestor'){
                     ITPRshare4.AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Finance')
                  {
                    ITPRshare4.AccessLevel = 'Edit';
                     
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare4.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare4.AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare4.AccessLevel = 'Edit';
                      
                  }
               }else if((ITPR.Status__c == 'Pending Project Final Budget') || (ITPR.Status__c == 'Pending More Info Needed' )){
                   if (DSU.Additional_Access_4_Department__c == 'ITSES - Requestor'){
                  ITPRshare4.AccessLevel = 'Edit';
                   
                 }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }
               }  else if(ITPR.Status__c == 'In Approvals' ){
                  if (DSU.Additional_Access_4_Department__c == 'ITSES - Requestor'){
                      ITPRshare4.AccessLevel = 'Read';
                       
                 }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Finance')
                  {
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }
               }  else if(ITPR.Status__c == 'All Digital Initials Obtained' ){
                   if (DSU.Additional_Access_4_Department__c =='ITSES - Requestor'){
                     ITPRshare4.AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Finance')
                  {
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare4.AccessLevel = 'Edit';
                      
                  }
               }  else if((ITPR.Status__c == 'Cancelled') || (ITPR.Status__c == 'On Hold') || (ITPR.Status__c == 'Complete') || (ITPR.Status__c == 'Executed and Filed') || (ITPR.Status__c == 'Not Executed and Closed')){
                   if (DSU.Additional_Access_4_Department__c == 'ITSES - Requestor'){
                       ITPRshare4.AccessLevel = 'Read';
                        
                 }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Finance')
                  {    
                     ITPRshare4.AccessLevel = 'Read';
                      
                  } else if(DSU.Additional_Access_4_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_4_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare4.AccessLevel = 'Read';
                      
                  }
              }                       
            }
                ITPRshare4.RowCause = Schema.ITPR__Share.RowCause.Departmental_User_Sharing__c;
                //lstITPRShare.add(ITPRshare4);
                maptemp.put(ITPRshare4.UserOrGroupId,ITPRshare4);
           } 
            
            if(DSU.Viewer5__c != null)
            {
                ITPRshare5 = new ITPR__Share();
                
                ITPRshare5.ParentId = ITPR.Id;
                ITPRshare5.UserOrGroupId = DSU.Viewer5__c;
                ITPRshare5.AccessLevel = 'Read';
                // If Type of Access Defined as Read/Edit then check
                If(DSU.Type_of_Access_5__c == 'Read/Edit')
                {
                  If(ITPR.Status__c == 'Draft')   
                { 
                  if (DSU.Additional_Access_5_Department__c == 'ITSES - Requestor'){
                       ITPRshare5 .AccessLevel = 'Edit';
                       
                 }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Procurement')
                  {
                      ITPRshare5 .AccessLevel = 'Read';
                       
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare5 .AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }
               } else if(ITPR.Status__c == 'Submitted' || ITPR.Status__c == 'Assigned')
                  {
                   if (DSU.Additional_Access_5_Department__c == 'ITSES - Requestor'){
                      ITPRshare5 .AccessLevel = 'Read';
                       
                } else if(DSU.Additional_Access_5_Department__c == 'ITSES - Finance')
                  {
                      ITPRshare5 .AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare5 .AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare5 .AccessLevel = 'Edit';
                      
                  } else if(DSU.Additional_Access_5_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare5 .AccessLevel = 'Edit';
                      
                  }
               }else if(ITPR.Status__c == 'In Process' ){
                   if (DSU.Additional_Access_5_Department__c == 'ITSES - Requestor'){
                     ITPRshare5 .AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Finance')
                  {
                    ITPRshare5 .AccessLevel = 'Edit';
                     
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare5 .AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare5 .AccessLevel = 'Edit';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare5 .AccessLevel = 'Edit';
                      
                  }
               }else if((ITPR.Status__c == 'Pending Project Final Budget') || (ITPR.Status__c == 'Pending More Info Needed' )){
                   if (DSU.Additional_Access_5_Department__c == 'ITSES - Requestor'){
                  ITPRshare5 .AccessLevel = 'Edit';
                   
                 }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Finance')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }
               }  else if(ITPR.Status__c == 'In Approvals' ){
                  if (DSU.Additional_Access_5_Department__c == 'ITSES - Requestor'){
                      ITPRshare5 .AccessLevel = 'Read';
                       
                 }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Finance')
                  {
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }
               }  else if(ITPR.Status__c == 'All Digital Initials Obtained' ){
                   if (DSU.Additional_Access_5_Department__c =='ITSES - Requestor'){
                     ITPRshare5 .AccessLevel = 'Read';
                      
                 }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Finance')
                  {
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare5 .AccessLevel = 'Edit';
                      
                  }
               }  else if((ITPR.Status__c == 'Cancelled') || (ITPR.Status__c == 'On Hold') || (ITPR.Status__c == 'Complete') || (ITPR.Status__c == 'Executed and Filed') || (ITPR.Status__c == 'Not Executed and Closed')){
                   System.debug('test..ITPR status'+ITPR.Status__c);
                   if (DSU.Additional_Access_5_Department__c == 'ITSES - Requestor'){
                       ITPRshare5 .AccessLevel = 'Read';
                        
                 }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Finance')
                  {    
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  } else if(DSU.Additional_Access_5_Department__c == 'ITSES - Procurement')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Legal')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }else if(DSU.Additional_Access_5_Department__c == 'ITSES - Vendor Governance')
                  { 
                     ITPRshare5 .AccessLevel = 'Read';
                      
                  }
              }                       
            }                 
                ITPRshare5.RowCause = Schema.ITPR__Share.RowCause.Departmental_User_Sharing__c;
                //lstITPRShare.add(ITPRshare5);
                maptemp.put(ITPRshare5.UserOrGroupId,ITPRshare5);
            }
            
            
            } //Copied code is over
         } //Comparing ownerId with the various profile in If Loop
       }//ITPR For Loop
    }   //DSU For Loop
      
      for(Id key : maptemp.keyset())
           {
               lstITPRShare.add(maptemp.get(key));
           }
           
           insert lstITPRShare;
           
         If(lstITPR.size() > 0)
       {
            List<ITPR__Share> sharesToDelete = [SELECT Id FROM ITPR__Share WHERE ParentId IN :lstITPR AND RowCause = :Schema.ITPR__Share.RowCause.Departmental_User_Sharing__c];
            
             /**********************Flushing the Departmental User Sharing *********/                                                                               
             if(!sharesToDelete.isEmpty())
             {
                  Database.Delete(sharesToDelete, false);    
             }
        system.debug('sharesToDelete' +sharesToDelete); 
        }  
             
      return null; 
   }
}