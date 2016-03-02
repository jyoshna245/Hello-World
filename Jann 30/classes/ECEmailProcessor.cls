global class ECEmailProcessor implements Messaging.InboundEmailHandler {

global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

try {
String emailBody = email.HtmlBody;
system.debug('email.HtmlBody>>>'+email.HtmlBody);
if(String.isBlank(emailBody)) emailBody = email.plainTextBody;
system.debug('email.plainTextBody >>>'+email.plainTextBody );
System.debug('email.binaryAttachments>>>'+email.binaryAttachments);
RecordType logRT = [SELECT Id FROM RecordType WHERE SObjectType = 'Investigation_Activity__c' AND Name = 'Email']; 
Case c;
try {
c = [SELECT Id FROM Case WHERE CaseNumber = :email.subject.trim() LIMIT 1]; 
} catch(Exception e) {
notifySenderOfError(email.subject.trim(),email.fromName,email.fromAddress,e.getLineNumber() + ' ::: ' + e.getMessage() + ' ::: ' + e.getStackTraceString());
}

/*
CHG0107036 - Trimmed email.plaintextbody BreakFix INC2592590
*/
String shortDesc = getShortDescription(email.plainTextBody.trim());


Investigation_Activity__c log = new Investigation_Activity__c(Case__c = c.Id,RecordTypeId = logRT.Id,Activity_Date__c = Date.today(), Details__c = cycleReplaceHTMLString(emailBody),From_Address__c = email.fromAddress, From_Name__c = email.fromName, Activity_Type__c = 'Email',Short_Description__c = shortDesc);
if(email.toAddresses != null && email.toAddresses.size() > 0) log.To_Addresses__c = String.join(email.toAddresses,', ');
if(email.ccAddresses != null && email.ccAddresses.size() > 0) log.CC_Addresses__c = String.join(email.ccAddresses,', ');
Database.SaveResult logResult = Database.insert(log);
log = [SELECT Id,Details__c FROM Investigation_Activity__c WHERE Id = :logResult.getId()];
List<Attachment> attachmentsToInsert = new List<Attachment>();
for(Messaging.InboundEmail.BinaryAttachment attachment : email.binaryAttachments) {
attachmentsToInsert.add(new Attachment(Body = attachment.Body,Name = attachment.fileName,ParentId = logResult.getId()));
}
Database.SaveResult[] attachmentResults = Database.insert(attachmentsToInsert);
List<String> orderedAttachmentList = new List<String>();
for(Database.SaveResult result : attachmentResults) {
orderedAttachmentList.add('src=\"/servlet/servlet.FileDownload/?file='+result.getId()+'\"');
}
//for each image tag, replace source with id
List<String> sourceStr = new List<String>();
for(String str : orderedAttachmentList) {
sourceStr.add('src=\"\"');
}
System.debug('log details-1>>> '+log.Details__c);
log.Details__c = cycleReplace(log.Details__c,'src=\"\"',orderedAttachmentList);
log.Details__c = log.Details__c.replace('P { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px }','');
System.debug('log details-2>>> '+log.Details__c);

log.Id = logResult.getId();
update log;
}catch(Exception e) {
system.debug(e);

}
Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
return result;
}


private static String cycleReplace(String text, String searchText, String[] replacementList) {
/* PLEASE FILL THIS OUT */
Integer searchStringLen = searchText.length();
Integer index = 0;
Integer Counter = 0;
while(index != -1 && Counter < replacementList.size()) {
index = text.indexOf(searchText,index);
if(index != -1) {
text = text.replaceFirst(text.substring(index,index + searchStringLen),replacementList.get(Counter)); 
index = index + replacementList.get(Counter).length();
Counter++;
}
}
return text;
}


private static void notifySenderOfError(String subject,String name,String email,String error) {
Messaging.SingleEmailMessage errorMail = new Messaging.SingleEmailMessage();

String emailAddr = email;
String newOwnerName = name;

String[] toAddresses = new String[] {emailAddr};
errorMail.setToAddresses(toAddresses);

errorMail.setSubject('ERROR: Invalid Case Id Specified');

errorMail.setPlainTextBody(subject+' is not a valid case Id. Please update the email subject and resend the message. Error: '+error);
errorMail.setHtmlBody(subject+' is not a valid case Id.<br/>Please update the email subject and resend the message.<br/>Error: '+error);

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { errorMail });
}

/*
* Start By: @Ashish Goyal
* Task: T-296645
* Method Name: cycleReplaceHTMLString
* Description: String replacement
* Passing Parameter: String
* Return Type: String
*/
private static String cycleReplaceHTMLString(String htmlText) {
/* PLEASE FILL THIS OUT */
Integer backClrindex = 0;
Integer angulrBracIndex = 0;
Integer colonIndex = 0;
Integer index = 0;
Integer Counter = 0;
while(index != -1) {
index = htmlText.indexOf('background:',index);
if(index != -1) {
htmlText = htmlText.replace(htmlText.substring(index, index+11),'background-color:'); 
backClrindex = htmlText.indexOf('background-color:',backClrindex);
angulrBracIndex = htmlText.indexOf('>',backClrindex);
colonIndex = htmlText.indexOf(';',backClrindex);

/*
CHG0107036 - added if to catch angulrBracIndex greater than ColonIndex producing ing position out of bounds: BreakFix INC2558249
*/
if (angulrBracIndex >colonIndex ){
htmlText = htmlText.replace(htmlText.substring(colonIndex,angulrBracIndex-1),''); 
system.debug('----'+htmlText);
}
}
}
return htmlText;
}

private static String getShortDescription(String inputText) {
String shortDescription = '';
Integer minimumSentenceLength = 10;
String[] paragraphs = inputText.split('\\n');
shortDescription = paragraphs[0].trim();
return shortDescription;
}

}