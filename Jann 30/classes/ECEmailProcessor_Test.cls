// 
// (c) 2014 Appirio, Inc.
//
// Test Class Name: ECEmailProcessor_Test
// Tested Class: ECEmailProcessor
//
// 25th July 2014     Hemendra Singh Bhati      Original
//
@isTest(seeAllData=false)
private class ECEmailProcessor_Test
{
  private static testMethod void myUnitTest()
  {
    User testUser = TestUtilityHelper.createUser('testUser',UserInfo.getProfileId(),'tU','testUser@appirio.com');
    insert testUser;
    TestUtilityHelper.createNAAccount();
    Case testCase = TestUtilityHelper.createCase(testUser.Id);
    insert testCase;

    // Creating New Email And Envelope Object.
    Messaging.InboundEmail email = new Messaging.InboundEmail();
    Messaging.InboundEnvelope emailEnvelope = new Messaging.InboundEnvelope();

    // Setting Up Data For The Email.
    email.subject = [SELECT CaseNumber FROM Case].CaseNumber; // Test Case 1.
    email.toAddresses = new List<String>{ 'test1@abc.com', 'test2@abc.com', 'test3@abc.com' };
    email.ccAddresses = new List<String>{ 'test4@abc.com', 'test5@abc.com', 'test6@abc.com' };
    email.fromAddress = 'testing@domain.com';
    email.plainTextBody = 'Inbound Email Sample Plain Text Body.';
    email.HtmlBody = '<p style="background: #00ff00 url(\'smiley.gif\') no-repeat fixed center;">Inbound Email Sample HTML Body.<img src=\"\"/></p>';

    // Adding Binary Attachment To Email.
    Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
    attachment.body = blob.valueOf('My Attachment Text.');
    attachment.fileName = 'fileToBeAttachment1.txt';
    attachment.mimeTypeSubType = 'text/plain';
    email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };

    // Adding Text Attachment To Email.
    Messaging.InboundEmail.TextAttachment attachmentText = new Messaging.InboundEmail.TextAttachment();
    attachmentText.body = 'My Attachment Text';
    attachmentText.fileName = 'fileToBeAttachment2.txt';
    attachmentText.mimeTypeSubType = 'texttwo/plain';
    email.textAttachments = new Messaging.inboundEmail.TextAttachment[] { attachmentText };

    // Calling The InBound Email Service Class.
    ECEmailProcessor testInBoundEmail = new ECEmailProcessor();
    testInBoundEmail.handleInboundEmail(email,emailEnvelope);

    // Test Case 2.
    email.subject = 'Test Email Subject';
    testInBoundEmail.handleInboundEmail(email,emailEnvelope);

    // Functionality Validation Asserts.
    system.assert([SELECT Id FROM Investigation_Activity__c].size() > 0,'ECEmailProcessor class failed to create a new record of type Investigation_Activity__c.');
  }
}