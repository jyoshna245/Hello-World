/**************************************************************************************************************************************** 
****************************************************************************************************************************************     
*  Class            : ITSES_ViewAttachments
*  Author           : Capgemini 
*  Version History  : 1.0 
*  Creation         : 12/17/2014 
*  Assumptions      : N/A  
*  Description      : This class is the controller for the inline visualforce page which was emebedded on an ITPR object
                       This returns the list of additional attachments.                                    
**************************************************************************************************************************************** 
****************************************************************************************************************************************/

public class ITSES_ViewAttachments
{
    //Variables Initiialisation
    private ITPR__c objITPR {get; set;}
    public ITSES_Additional_Attachment__c objAA; 
        
    //Pagination
    public Integer pageSize = 5;
    Integer counter;
    
    public Id AttachId {get; set;}
    
    public boolean DisplayViewAttachments {get; set;}
    public boolean DisplayAddAttachments {get; set;}
    
    public Id ITPRid
    {
      get
      {
          If(ITPRid == null)
          {
              ITPRid = ApexPages.currentPage().getParameters().get('id');
              
              If(ITPRid == null)
              {
                  ITPRid = ApexPages.CurrentPage().getParameters().get('id1');
              }
          }
          return ITPRid;
      }
      set;
    }
    
    public User LoggedInUser
    {
      get
      {
          If(LoggedInUser == null)
          {
              LoggedInUser = [select Profile.Name,ITPR_Department__c from User where Id = :Userinfo.getUserId() limit 1];
          }
          return LoggedInUser;
      }
      set;
    }  
    
    public ITPR__c Check
    {
      get
      {
          If(objITPR == null)
          {
              objITPR = [select Id,Status__c,transfered_requestor__c,RecordTypeId,Request_Type__c,Manager__c,Wave1_Approver_1__c,Wave3_Approver_1__c,
                          Primary_Assignee__c,Vendor_Governance__c,Finance_Assignee__c, Legal_Assignee__c, Procurement_Assignee__c, 
                          Submitted_By__c,Delegated_Requestor__c,Submitted_On_Behalf_Of__c from ITPR__c where Id =:ITPRid];
          }
          return objITPR;
      }
      set;
    }
    
    public boolean IsUploadAllowed
    {
      get
      {
          If(Userinfo.getUserId() == Check.Delegated_Requestor__c || Userinfo.getUserId() == Check.Vendor_Governance__c || 
              Userinfo.getUserId() == Check.Finance_Assignee__c || Userinfo.getUserId() == Check.Legal_Assignee__c ||
              Userinfo.getUserId() == Check.Manager__c || Userinfo.getUserId() == Check.Procurement_Assignee__c ||
              (LoggedInUser.Profile.Name.Contains('ITSES') &&  LoggedInUser.Profile.Name.Contains('Business Administrator')) ||
              LoggedInUser.Profile.Name == System.Label.ITPR_System_Admin || LoggedInUser.Profile.Name == System.Label.ITPR_Requestor_profile)
          {
              return true;
          }
          else
          {
              return false;
          }
      }
    }
    
    public boolean IsDeleteAllowed
    {
      get
      {
          If(Userinfo.getUserId() == Check.Delegated_Requestor__c || Userinfo.getUserId() == Check.Vendor_Governance__c || 
              Userinfo.getUserId() == Check.Finance_Assignee__c || Userinfo.getUserId() == Check.Legal_Assignee__c ||
              Userinfo.getUserId() == Check.Manager__c || Userinfo.getUserId() == Check.Procurement_Assignee__c ||
              (LoggedInUser.Profile.Name.Contains('ITSES') &&  LoggedInUser.Profile.Name.Contains('Business Administrator')) ||
              LoggedInUser.Profile.Name == System.Label.ITPR_System_Admin || LoggedInUser.Profile.Name == System.Label.ITPR_Requestor_profile)
          {
              return true;
          }
          else
          {
              return false;
          }
      }
    }
    
    
    
    
    
    private List<Attachment> lstAttach;
    public list<Attachment> AttachmentsToDisplay{get; set;}    
        
    public List<Attachment> getAttachments()
    {
        return AttachmentsToDisplay;
    }
    
    public Boolean hasNextFind
    {
        get
        {
            if(counter >= lstAttach.size() || lstAttach.size() <= 0)
                return false;
            else
                return true;
        }
        set;
    }
    
    public Boolean hasPreviousFind
    {
        get
        {
            if((counter <= lstAttach.size()) && !(counter <= pageSize))
                return true;
            else
                return false;
        }
        set;
    }
    
    public List<Attachment> nextRequest()
    {
        system.debug('##############this.pageSize############'+this.pageSize);
        system.debug('##############this.counter############'+this.counter);
        List<Attachment> AttachmentsToDisplay_temp = new List<Attachment>();
        Integer startNumber;
        Integer size = lstAttach.size();
        if(hasNextFind )
        {
            if(size <= (this.counter + this.pageSize))
            {
                startNumber = this.counter; this.counter = size;
            }
            else
            {
                this.counter = (this.counter + this.pageSize); startNumber = (this.counter - this.pageSize);
            }
            
            for(Integer start = startnumber; start < this.counter; start++)
            {
                AttachmentsToDisplay_temp.add(lstAttach[start]);
            }
        }
        return AttachmentsToDisplay_temp;
    }
    
    public list<Attachment> previousRequest()
    {      
        List<Attachment> AttachmentsToDisplay_temp = new list<Attachment>(); 
        Integer size = lstAttach.size(); 
       system.debug('##############this.pageSize############'+this.pageSize);
        system.debug('##############this.counter############'+this.counter);
        if(this.counter == size)
        {
           if(math.mod(size, this.pageSize) >= 0)
          
           {    
               size = math.mod(size, this.pageSize);
           }
           else
           {
               this.counter = (size - this.pageSize);
           }    
            
        }
        else
        {
            this.counter = (this.counter - this.pageSize);
        }
        
        If(size > 0)
        {
            //for(Integer start = (counter - this.pageSize); start < this.counter; ++start)
            for(Integer start = 0; start < this.counter; ++start)
            {
                AttachmentsToDisplay_temp.add(lstAttach[start]);
            } 
        }
        return AttachmentsToDisplay_temp;
    }
    
    public void BindAttachments()
    {
        List<ITSES_Additional_Attachment__c> lstAA = [Select Id from ITSES_Additional_Attachment__c 
                    where IT_SES_Request__c = :ITPRid and Attachment_Type__c = 'Normal Attachment'];
        
         If(LstAA.size() > 0)    
         {        
             for(ITSES_Additional_Attachment__c AA : LstAA)
             {
                 lstAttach = [SELECT Description,Id,Name,ParentId, CreatedById, CreatedDate FROM Attachment where ParentId = :AA.Id order by CreatedDate desc];    
             }
             
             list<Attachment> AttachmentsToDisplay_temp = new list<Attachment>();
             If(counter == 0 || counter == null)
             {
                 Integer startNumber = 0;
                 If(pageSize > lstAttach.size())
                     counter = lstAttach.size();
                 else
                     counter = this.pageSize;
                 
                for(Integer start = startnumber; start < this.counter; start++)
                {
                    AttachmentsToDisplay_temp.add(lstAttach[start]);
                }
                
                AttachmentsToDisplay = AttachmentsToDisplay_temp;
             }
         }
         else
         {
             lstAttach = new List<Attachment>();
             AttachmentsToDisplay = lstAttach;
         }
    }
    
    //Controller
    public ITSES_ViewAttachments(ApexPages.StandardController controller)
    {
        DisplayViewAttachments = true;
        DisplayAddAttachments = false;
        BindAttachments();
                
    }
        
    //Actions
    public PageReference PreviousPage()
    {
        try
        {
            AttachmentsToDisplay = previousRequest();
        }
        catch (DMLException e) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error fetching records.')); return null;
        }
        
        return null;
    }
    
    public PageReference NextPage()
    {
        try
        {
            AttachmentsToDisplay = nextRequest();
        }
        catch (DMLException e) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error fetching records.')); return null;
        }
        
        return null;
    }
    
    public PageReference NewPage()
    {
        try 
        {
            //PageReference newocp = new PageReference('/apex/ITSES_Attachment?id1=' + ITPRid);
            //newocp.setRedirect(true);
            counter = 0;
            BindAttachments();
            DisplayViewAttachments = false;
            DisplayAddAttachments = true;
            return null;
        } 
        catch (DMLException e) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error redirecting to Attachments List.')); return null;
        }
        
        return null;
    }
    
    public PageReference DeleteAttachment()
    {
        try
        {
            List<Attachment> Lst_DelAttach = [SELECT Id FROM Attachment where Id = :AttachId];
            
            If(Lst_DelAttach.size() > 0)
            {
                for(Attachment att : Lst_DelAttach)
                {
                    delete att;
                }
            }
            
            //PageReference newocp = new PageReference('/apex/ITPR_Addl_Attachment_New_Page?id1=' + ITPRid);
            //newocp.setRedirect(true);
            
            counter = 0;
            BindAttachments();
            DisplayViewAttachments = true;
            DisplayAddAttachments = false;
            return null;
        }
        catch (DMLException e) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error deleting Attachment.')); return null;
        }
        
        return null;

    }
    
    
    // Code to upload the attachments
      public Attachment attachment {
       get {
          if (attachment == null)
            attachment = new Attachment();
          return attachment;
        }
          set;
      }
      
      //Actions
  public PageReference upload() {
  
    List<ITSES_Additional_Attachment__c> LstAA = [Select Id from ITSES_Additional_Attachment__c where IT_SES_Request__c = :ITPRid and Attachment_Type__c = 'Normal Attachment'];
    
    If(LstAA.size() > 0)
    {
        objAA = LstAA[0];
    }
    else
    {
        objAA = new ITSES_Additional_Attachment__c();
        objAA.IT_SES_Request__c = ITPRid;
        objAA.Attachment_Type__c = 'Normal Attachment';
        insert objAA;
    }
    
    attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = objAA.Id; // the record the file is attached to
    attachment.IsPrivate = false;

    try 
    {
        insert attachment;
        //PageReference newocp = new PageReference('/apex/ITPR_Addl_Attachment_New_Page?id1=' + ITPRid);
        //newocp.setRedirect(true);
        counter = 0;
        BindAttachments();
        DisplayViewAttachments = true;
        DisplayAddAttachments = false;
        return null;
    } 
    catch (DMLException e) 
    {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment')); return null;
    } 
    finally 
    {
      attachment = new Attachment(); 
    }
  }
  
  public PageReference cancel() 
  {   
        //PageReference newocp = new PageReference('/apex/ITPR_Addl_Attachment_New_Page?id1=' + ITPRid);
        //newocp.setRedirect(true);
        DisplayViewAttachments = true;
        DisplayAddAttachments = false;
        return null;
  }
}