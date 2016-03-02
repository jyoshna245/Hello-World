/******************************************************************************************************************
*Class            : ITPR_DepartmentalSuperUsers_Share
*Author           : Capgemini
*Version History  : 1.0
*Creation         : 15/12/2014
*Assumptions      : N/A
*Description      : This class is used to share the IT-SES record of user in Requestor field with users selected in viewer fields.
******************************************************************************************************************/

public class ITPR_DepartmentalSuperUsers_share
{
    /********* Initialisation of variables *************/
    //List to add new ITPR__Share objects
    List<ITPR__Share> lstITPRShare = new List<ITPR__Share>();
    Map<Id, ITPR__Share> maptemp = new Map<Id, ITPR__Share>();
    ITPR__Share ITPRshare1;
    ITPR__Share ITPRshare2;
    ITPR__Share ITPRshare3;
    ITPR__Share ITPRshare4;
    ITPR__Share ITPRshare5;
    /********* End of Initialisation of variables ******/
    
    public List<ITPR__Share> DSU_ITPR_Share(ITPR__c ITPR)
    {
        
        if(ITPR != null)
        {
            System.debug('In DSU_ITPR_Share...');
            list<id>assigneeuserslist=new list<id>();
            if(ITPR.CreatedById !=null)     
            assigneeuserslist.add(ITPR.CreatedById);
            system.debug('Createdby'+ITPR.CreatedById);  
            if(ITPR.Procurement_Assignee__c !=null)
            assigneeuserslist.add(ITPR.Procurement_Assignee__c);
            system.debug('Procurment Assignee'+ ITPR.Procurement_Assignee__c);
            if(ITPR.Legal_Assignee__c !=null)       
            assigneeuserslist.add(ITPR.Legal_Assignee__c);
            system.debug('Legal Assignee'+ ITPR.Legal_Assignee__c);
            if(ITPR.Finance_Assignee__c !=null)     
            assigneeuserslist.add(ITPR.Finance_Assignee__c);
            system.debug('Finance Assignee'+ ITPR.Finance_Assignee__c);
            if(ITPR.Vendor_Governance__c!=null)     
            assigneeuserslist.add(ITPR.Vendor_Governance__c);
            system.debug('VG Assignee'+ ITPR.Vendor_Governance__c);
            system.debug('assigneeuserslist'+assigneeuserslist);
            //Query All related Departmental Super user records
            list<DepartmentalSuperUser__c>dsulist=[select id,Viewer1__c,Viewer2__c,Viewer3__c,Viewer4__c,Viewer5__c,Type_of_Access_1__c,Type_of_Access_2__c,Type_of_Access_3__c,Type_of_Access_4__c,Type_of_Access_5__c,Additional_Access_1_Department__c,Additional_Access_2_Department__c,Additional_Access_3_Department__c,Additional_Access_4_Department__c,Additional_Access_5_Department__c from DepartmentalSuperUser__c where OwnerId in:assigneeuserslist];
            system.debug('dsulist...'+dsulist.isEmpty());
            for (DepartmentalSuperUser__c DSU :dsulist)
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
            
            
            }
       }

        for(Id key : maptemp.keyset())
           {
               lstITPRShare.add(maptemp.get(key));
           }
        system.debug('lstITPRShare'+lstITPRShare);
        return lstITPRShare;
    }
}