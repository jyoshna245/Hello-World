/*
*
* Author,email :     Mads Pascua , mpascua@coca-cola.com
* Date Create  :     Sept 12, 2013
* Description  :     Custom Controller for the send back functionality of GS1 Requests.
*
* REVISION HISTORY
*
* Author,email : Aldrin Rasdas, arasdas@coca-cola.com
* Date Revised : Sept 19, 2013
* Description  : added (HTML) body content; parameterized viewid, and dynamic object id acuisition
*
*
*
*/

public class GS1_SendBackCtrl{ 
    public List<String> idList {get;set;}
    public List<GS1_Request__c> gs1RequestList {get;set;}
    public Map<Id,List<GS1_Request__c>> userGS1RequestMap{get;set;}
    public List<User> uList{get;set;}
  
    public GS1_SendBackCtrl() {              
        this.idList = ApexPages.CurrentPage().getParameters().get('ids').split(',');      
        //this.gs1RequestList = [SELECT Id, Name, EAN_code__r.name, Sent_Back__c, RequestedById__c, country__r.name, Description__c FROM GS1_Request__c WHERE Id IN:this.idList LIMIT 1000 ];
        String okStatus = GS1_Constants.REQUEST_STATUS_ALLOCATED;
        this.gs1RequestList = [SELECT Id, Name, EAN_code__r.name, Sent_Back__c, RequestedByUserId__c, country__r.name, Description__c FROM GS1_Request__c WHERE Sent_Back__c=false AND Status__c=:okStatus AND Id IN:this.idList LIMIT 1000 ];
        this.userGS1RequestMap = new Map<Id,List<GS1_Request__c>>();  
  
      for(GS1_Request__c gs1 : this.gs1RequestList){    
           Id tempId = Id.valueOf(gs1.RequestedByUserId__c);
           if(userGS1RequestMap.containsKey(tempId )){
              userGS1RequestMap.get(tempId).add(gs1);      
           }else{
               List<GS1_Request__c> gList = new List<GS1_Request__c>();
               gList.add(gs1);
               userGS1RequestMap.put(tempId,gList);
           }
       }    
       
       this.uList = [SELECT Id,Email,Name FROM User WHERE Id IN:userGS1RequestMap.keySet() LIMIT 1000];
    }
     
   
    public PageReference sendBackGS1Requests(){

       for(GS1_Request__c gs1 : this.gs1RequestList){    
           gs1.Sent_Back__c = true;    
       }    
       update this.gs1RequestList;
       sendSingleMail(this.uList);

       //Pagereference pageRef = new Pagereference('/a12?fcf='+Label.GS1_List_View_Id);
       String viewId = ApexPages.CurrentPage().getParameters().get('srcview');
       Pagereference pageRef = new Pagereference('/' + GS1_CommonFunctions.getObjectPrefix('GS1_Request__c')+'?fcf='+viewId); 
       pageRef.setRedirect(true);                
       return pageRef;         
     
    }

    public void sendSingleMail(List<User> userList){  
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm(); //FIXME!
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>(); 
        GS1_Request__c[] reqs;
        for(User u : userList){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  
            //String[] toAddresses = new String[] {u.Email}; 
            String strHtmlBody = '<style type="text/css"> td{font-family:Calibri,Arial;} span{font-family:Calibri,Arial;}table, td, th { border:1px solid #c0c0c0; border-collapse:collapse;} .tdh{background-color:#c0c0c0;font-weight:bold;}</style>';
            strHtmlBody+= '<table border="0" cellspacing="0" cellpadding="3" width="100%">';
            strHtmlBody+= '<tr><td class="tdh">Country</td><td align="center" class="tdh">Description</td><td class="tdh">Barcode</td></tr>';
            
            reqs = this.userGS1RequestMap.get(u.id);
            
            for (GS1_Request__c req : reqs) {
                strHtmlBody+= '<tr><td>' + req.country__r.name + '</td>';
                strHtmlBody+= '<td><a href="' + baseURL + '/' + req.id + '">' + req.Description__c + '</a></td>';
                strHtmlBody+= '<td>' + req.EAN_code__r.name + '</td>';
                strHtmlBody+= '</tr>';                
            }
            
            strHtmlBody+='</table>';
  
            //mail.setToAddresses(toAddresses);
            //mail.setCcAddresses(ccAddresses);
            mail.setTargetObjectId(u.id);
            mail.setReplyTo(Label.GS1_ReplyTo);
            mail.setSenderDisplayName(Label.GS1_SendBack_Email_Sender_Display_Name);
            mail.setSubject(Label.GS1_SendBack_Email_Subject);
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            //mail.setPlainTextBody('Test');
            mail.setCharset('UTF8');
            mail.setHtmlBody(strHtmlBody );
                
            mailList.add(mail);
                
       }
 
       Messaging.sendEmail(mailList);         
   }
}