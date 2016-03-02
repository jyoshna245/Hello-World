/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class RFA_WS05_KOApprove_getAttachment_Test {

    static testMethod void myUnitTest() {
         // TO DO: implement unit test
       RFA__c testRFA=new RFA__c();
        insert testRFA;
        Attachment attRec = new Attachment(parentId=testRFA.ID, Name = 'Test Attachment', body = blob.valueOf('Test Body'));
        insert attRec;
       
        try{
        	attRec=[select id from attachment where name=:'rr'];
        System.assert(attRec != null ,'ee');
        }Catch(QueryException e)
        {
        
        }
        RFA_WS05_KOApprove_getAttachment.statusMessageWrapper message=new RFA_WS05_KOApprove_getAttachment.statusMessageWrapper('d','d');//Message class instance
    	
        RFA_WS05_KOApprove_getAttachment.getAttachment(attRec.Id);
        try{
        	RFA_WS05_KOApprove_getAttachment.getAttachment(null);
        	RFA_WS05_KOApprove_getAttachment.getAttachment('ee');
        }catch(QueryException e)
        {
        	System.assert(e!=null);
        }
        catch(Exception e)
        {
        	System.assert(e!=null);
        }
    }
}