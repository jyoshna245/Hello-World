/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VC_DeleteNotesAndAttachments
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/05/2013
 *  Assumptions      : N/A
 *  Description      : This is a controller class which provide functoinality to delete notes and attachments related to RFA.
                       You can delete multiple notes and attachments together using the visualforce page (RFA_VFP_DeleteNotesAndAttachments) where this class is tagged as controller.
                       Visualforce page (pop-up) is attached to button("Delete Notes and Attachments") on RFA page.             
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
public class RFA_VC_DeleteNotesAndAttachments {

    private integer counter = 0;  //keeps track of the offset
    private integer list_size = 5;
    public integer total_size; 
    public RFA__c rfaObj{get;set;}
    public  Set<String> attId = new Set<String>();
    public  Set<String> ntId = new Set<String>(); 
    public String defaultURL {get;set;}
    
    public List<Attachment> AttachmentsToDelete;
    public List<Note> NotesToDelete;
    
    public List<Attachment> AttachmentList=new List<Attachment>();
    List<RFAAttachments> attList;
    
    
    public RFA_VC_DeleteNotesAndAttachments(ApexPages.StandardController controller) {
    
    this.rfaObj = (RFA__c)controller.getRecord();
    defaultURL = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RFA_VFP11_RFATab?save_new=1&sfdc.override=1';
    
    
    }
    
    public class RFAAttachments {
    public Boolean selected { get; set; }
    public Attachment att { get; set; }
    public Note nt {get;set;}
    public String type {get; set;}
    public String fileURL {get; set;}

    public RFAAttachments(){
        att = new Attachment();
        nt = new Note();
        selected = false;
        type='';
    }
    
    public RFAAttachments(Attachment attParam){
        att = attParam;
        selected = false;
        type='Attachment';
        fileURL=URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att.id;
    }

    public RFAAttachments(Attachment attParam, Boolean selected){
        att = attParam;
        this.selected = selected ;
        type='Attachment';
        fileURL=URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att.id;
      }
    public RFAAttachments(Note ntParam){
        nt = ntParam;
        selected = false;
        type='Note';
    }

    public RFAAttachments(Note ntParam, Boolean selected){
        nt = ntParam;
        this.selected = selected ;
        type='Note';
    }
    

}

public List<RFAAttachments> getAttachmentList() {
    attList = new List<RFAAttachments>();
    

    //we have to catch query exceptions in case the list is greater than 2000 rows
    try {
        for ( Attachment att : [SELECT id,Name,description,createddate,lastmodifieddate,createdbyid,ownerid,contenttype from Attachment where parentid=:rfaObj.id FOR UPDATE] ) {
            if ( !attId.contains(att.Id) ) 
                attList.add(new RFAAttachments(att));
            else
                attList.add(new RFAAttachments(att,false));               
        }
        for ( Note nt : [SELECT title,body,createddate,ownerid,createdbyid,lastmodifieddate from Note where parentid=:rfaObj.id FOR UPDATE] ) {
            if ( !ntId.contains(nt.Id) ) 
                attList.add(new RFAAttachments(nt));
            else
                attList.add(new RFAAttachments(nt,false));               
        }
        
         
    } catch ( QueryException e ) {
        ApexPages.addMessages(e);                   
        return null;
    }    
    return attList;
}

public Integer getListCount()
{
Integer AttachmentSize=0;
Integer NoteSize=0;
AttachmentSize=[select count() from Attachment where parentid=:rfaObj.id] ;
NoteSize=[select count() from Note where parentid=:rfaObj.id];

return AttachmentSize+NoteSize ;
}

public void deleteAttachment()
{
AttachmentsToDelete=new List<Attachment>();
NotesToDelete=new List<Note>();
if(attList!=null)
{
for(RFAAttachments rfatt:attList)
{
if(rfatt.selected && rfatt.type=='Attachment')    AttachmentsToDelete.add(rfatt.att);
if(rfatt.selected && rfatt.type=='Note')    NotesToDelete.add(rfatt.nt);
}

if(AttachmentsToDelete.size()>0) delete AttachmentsToDelete;
if(NotesToDelete.size()>0) delete NotesToDelete;

}
}
}