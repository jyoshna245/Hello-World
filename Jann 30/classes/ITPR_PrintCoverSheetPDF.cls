/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_PrintCoverSheetPDF
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 26/03/2014
 *  Assumptions      : N/A 
 *  Description      : This class is written to print the cover sheet details for a corresponding ITPR request.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
public with sharing class ITPR_PrintCoverSheetPDF {
    
    /*variable declaration and initialization*/
    public ITPR__c objITPR {get; set;}
    //public List<Budget_Detail__c> lstBudgetDetails {get; set;}
    public List<ApprovalDetail> lstApprovalDetails {get; set;}
    
    /*end of variable declaration and initialization*/
        
    public ITPR_PrintCoverSheetPDF(ApexPages.StandardController controller) {
        //query the fields of the ITPR object to display on the cover sheet
        // added Currency_Type__c on query 5-5-2015
        objITPR = [Select Id, Name, Request_Type__c, Supplier_Name__r.Name, Submitted_By__c, Opportunity_Statement__c, Manager__r.Name,
                        Category__c, Business_Area__c, Portfolio_Department__c,Currency_Type__c, CAPEX1__c,CAPEX2__c,CAPEX3__c,OPEX1__c,OPEX2__c,OPEX3__c,
                        Project_Cost_Center1__c,Project_Cost_Center2__c,Project_Cost_Center3__c,
                        Project_Cost_Center4__c,Project_Cost_Center5__c,Project_Cost_Center6__c,
                        Long_Term_Commitments_Obligations__c, Guarantees__c, SFAS_133_Embedded_Derivatives__c, New_Supplier_Financial_Analysis_Done__c,
                        If_No_Explain1__c, Year_1__c, Year_2__c, Year_3__c, Year_4__c, Year_5__c, Thereafter__c,
                        Any_Noteworthy_Exceptional_Risk__c, Will_Supplier_Retain_Rights_To_New_IP__c, Are_There_Fees_For_Early_Termination__c,
                        If_Yes_Explain1__c, If_Yes_Explain2__c, If_Yes_Explain3__c, Cost_Avoidance__c, Savings__c,
                        Is_System_Participation_Allowed__c, If_Required_Has_IT_Security_Approved__c, If_Rqd_Has_Hosting_Cert_Team_Approved__c
                        From ITPR__c where Id = :controller.getId()];
        System.Debug('~~~~objITPR'+objITPR);
                        
        //query the approval fields
        List<ProcessInstance> lstApprovedSteps = [SELECT Id, (SELECT ActorId, OriginalActorId, stepStatus, Comments, CreatedDate FROM StepsAndWorkitems where stepStatus in ('Reassigned', 'Approved') order by OriginalActorId, CreatedDate)
                                                    FROM ProcessInstance where TargetObjectId = :controller.getId()];
            
       /*          List<ProcessInstance> lstApprovedSteps = [SELECT Id, (SELECT OriginalActorId, stepStatus, Comments, CreatedDate FROM StepsAndWorkitems where stepStatus = 'Approved')
                                                   FROM ProcessInstance where TargetObjectId = :controller.getId()];
        */
         System.debug('~~~lstApprovedSteps' +lstApprovedSteps);       
        lstApprovalDetails = new List<ApprovalDetail>();
         
        for(ProcessInstance pi : lstApprovedSteps){
        
            Map<Id, ProcessInstanceHistory> MapPIH = new Map<Id, ProcessInstanceHistory>();
            
            for(ProcessInstanceHistory wi : pi.StepsAndWorkitems){ If(wi.stepStatus == 'Reassigned') { MapPIH.put(wi.OriginalActorId, wi); }
                else { User Appr = GetApproverDetails(wi.ActorId); string Comments = wi.Comments; string Name = Appr.Name; string Department = Appr.ITPR_Department__c;
                     If(wi.ActorId != wi.OriginalActorId)  { ProcessInstanceHistory wi_temp; User OrgAppr = GetApproverDetails(wi.OriginalActorId);
                            
                            If(MapPIH.size() > 0) {  wi_temp = MapPIH.get(wi.OriginalActorId);   }
                        
                                If(wi_temp != null)   {  Comments = 'Reassigned from ' + OrgAppr.Name + ' : ' + Comments; }
                                else { Name = OrgAppr.Name; Department = OrgAppr.ITPR_Department__c;
                                       Comments = 'Approved by Business Admin (' + Appr.Name + ') on behalf of ' + OrgAppr.Name + ' : ' + Comments;
                                     }
                                                            }     
                    ApprovalDetail detail = new ApprovalDetail(Department, Name, wi.CreatedDate, Comments); lstApprovalDetails.add(detail);
                }
            }
        }        
    }
    
    public User GetApproverDetails(string UserId)
    {
        User usr; List<User> lstUser = [Select Name, ITPR_Department__c from User where Id = :UserId];
        
        If(lstUser.size() > 0) { usr = lstUser[0]; }
        return usr;
    }
    
    //wrapper class to capture approver details
    class ApprovalDetail{
        public String deptName {get; set;}
        public String approverName {get; set;}
        public DateTime dateApproved {get; set;}
        public String comments {get; set;}
        ApprovalDetail(String deptName, String approverName, DateTime dateApproved, String comments)
        { this.deptName = deptName; this.approverName = approverName; this.dateApproved = dateApproved; this.comments = comments; }
    }
}
/*********************************************END*****************************************************************************************************************/