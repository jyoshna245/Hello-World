global class PermissionSetQuery implements Schedulable, Database.Batchable<sObject>, Database.Stateful{
    
    public String query = 'SELECT SystemModstamp, Assignee.Name, Assignee.Profile.Name, PermissionSet.Label FROM PermissionSetAssignment WHERE PermissionSet.IsOwnedByProfile = false AND PermissionSet.Label = \'' + 'RFA Auditor Add On' + '\' AND SystemModstamp = YESTERDAY';
    public String emailBodyHtml;    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<PermissionSetAssignment> psaList){
        
        //Let's have a few CSS
        String html = '<style>';
        html+='table {border-collapse: collapse;}';
        html+='table, th, td {border: 1px solid black;font-family: Calibri;font-size:11pt;}';
        html+='td {min-width: 150px;}';
        html+='</style>';
        
        html+= '<table cellpadding="4" cellspacing="0" border="1">'; //html table start
        //Table column headers - start
        html+='<tr>';
        html+='<td><b>Time Stamp</b></td>'; //SystemModstamp col hdr
        html+='<td><b>Name</b></td>'; //Assignee.Name col hdr
        html+='<td><b>Profile</b></td>'; //Assignee.Profile.Name col hdr
        html+='<td><b>Permission Set</b></td></tr>'; //permissionset.label col hdr
        html+='</tr>';
        //Table column headers - end
            
        for (PermissionSetAssignment psa : psaList) {
            html+='<tr>'; //table row start
            
            html+='<td>' + psa.SystemModstamp.format() + '</td>';
            html+='<td>' + psa.Assignee.Name + '</td>';
            html+='<td>' + psa.Assignee.Profile.Name + '</td>';
            html+='<td>' + psa.permissionset.label + '</td>';
            
            html+='</tr>'; //table row end
        }
        
        html+='</table>'; //html table end
        
        emailBodyHtml = html;
        
    }
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(this);
    }
    
    global void finish(Database.BatchableContext BC){
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<String> mailList = new List<String>();
        List<String> mailAddresses = new List<String>(); 
        
        //Check Group Member 
        Group g = [SELECT (SELECT userOrGroupId FROM groupMembers) FROM GROUP WHERE Id = :Label.PermissionSetGroup];
        for (GroupMember gm : g.groupMembers) {
            mailList.add(gm.userOrGroupId);
        }
        
        //Get Members Email Address
        User[] usr = [SELECT Email FROM User WHERE Id IN :mailList];
        for(User u : usr){
            mailAddresses.add(u.email);
        } 
        
        System.debug('*** EMAIL ADDRESSES ' + mailAddresses);
        
        //Set Email Body with or without result
        if(emailBodyHtml == null || emailBodyHtml.length() <= 0){
            email.setHTMLBody('<h4>No Permission Set Assignment</h4>'); //set email content
        }else{
            email.setHTMLBody(emailBodyHtml);
        }
        
        //Set Org-Wide Email as Sender
        OrgWideEmailAddress owe = [SELECT ID, IsAllowAllProfiles, DisplayName, Address FROM OrgWideEmailAddress WHERE DisplayName = 'RFA System' LIMIT 1];

        email.setOrgWideEmailAddressId(owe.Id);
        email.setToAddresses(mailAddresses);
        email.setSaveAsActivity(false);
        email.setSubject('Permission Set Assignment');
        mails.add(email);
        
        try{
            if(mails.size() > 0){
                Messaging.sendEmail(mails);
            }
        }catch (Exception e){
            System.debug('*** ERROR ' + e.getMessage());
        }
        
    }
    
}