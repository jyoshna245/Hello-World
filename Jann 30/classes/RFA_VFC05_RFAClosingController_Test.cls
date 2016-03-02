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
@isTest(SeeAllData=true)
private class RFA_VFC05_RFAClosingController_Test
{
  static testmethod void RFA_VFC05_RFATest()
  {
  		RFATestData testData = new RFATestData();
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);    		
    	}
    	
    	System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
		{
			Map<String, String> urlParams = new Map<String, String>
			{
				'Id' => testRFA.Id
			};
			Test.setCurrentPage(getPageReference('RFA_VFP06_RFAClosing', urlParams));
			ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFA);
			RFA_VFC05_RFAClosingController controller1 = new RFA_VFC05_RFAClosingController(stdController1);
			//controller1.selectedStage = 'Approved';
			controller1.updateRFA();
			controller1.selectedStage = 'Approved';
			controller1.updateRFA();
		}
  
  }
  
   static PageReference getPageReference(String page, Map<String, String> params) {
        String url = '/apex/'+page+'?';
        for (String param : params.keySet()) {
            url += param + '=' + params.get(param) + '&';
        }
        PageReference p = new PageReference(url);
        return p;
    }


}