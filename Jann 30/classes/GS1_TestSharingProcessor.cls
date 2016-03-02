/**
* Author,email :     Madel Pascua , mpascua@coca-cola.com
* Date Create  :     September 26, 2013
* Description  :     Test method for GS1_SharingProcessor 
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

@isTest //(SeeAllData=true)
private class GS1_TestSharingProcessor { 
    static testMethod void testSharing1(){
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){
            List<GS1_Request__c>  gs1ListTest = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU);
            gs1ListTest.addAll(GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU));
            //gs1ListTest.addAll(GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU));
            User u = GS1_TestHelper.createTestUser();//[select id from User where profile.userlicense.name='Salesforce' AND profile.name != 'System Administrator' AND isActive=true limit 1];
            GS1_AuthorProfile__c testAuthor = GS1_TestHelper.createAuthor(u.id);
            GS1_CountryAuthor__c[] cauthors = new List<GS1_CountryAuthor__c>();
            
            for (GS1_Request__c req : gs1ListTest) {
                GS1_CountryAuthor__c cau = new GS1_CountryAuthor__c();
                cau.AuthorProfile__c = testAuthor.id;
                cau.Country__c = req.Country__c;
                cauthors.add(cau);
            }
            
            insert cauthors; 
            
            Test.startTest();
            delete cauthors;
            Test.stopTest();
        }    
    }     
    
    static testMethod void testSharing2(){
        Test.startTest();  
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){        
            List<GS1_Request__c>  gs1ListTest = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU);
            gs1ListTest.addAll(GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU));
            //gs1ListTest.addAll(GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU));
            User u = GS1_TestHelper.createTestUser();//[select id from User where profile.userlicense.name='Salesforce' AND profile.name != 'System Administrator' AND isActive=true limit 1];
            GS1_AuthorProfile__c testAuthor = GS1_TestHelper.createAuthor(u.id);
            GS1_CountryAuthor__c[] cauthors = new List<GS1_CountryAuthor__c>();
            
            cauthors = new List<GS1_CountryAuthor__c>();
            for (GS1_Request__c req : gs1ListTest) {
                GS1_CountryAuthor__c cau = new GS1_CountryAuthor__c();
                cau.AuthorProfile__c = testAuthor.id;
                cau.Country__c = req.Country__c;
                cau.Country_Reader__c = false;
                cauthors.add(cau);
            }                   
            insert cauthors;
                
            for (GS1_CountryAuthor__c ca: cauthors) {
                ca.Country_Reader__c = true;
            }
            update cauthors;        
    
            for (GS1_CountryAuthor__c ca: cauthors) {
                ca.Country_Reader__c = false;
            }
            update cauthors;        
          
        }
        Test.stopTest();    
    }         
    
     static testMethod void testSharing3(){
        Test.startTest();  
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){           
            List<GS1_Request__c>  gs1ListTest = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU);
            gs1ListTest.addAll(GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU));
            //gs1ListTest.addAll(GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU));
            User u = GS1_TestHelper.createTestUser();//[select id from User where profile.userlicense.name='Salesforce' AND profile.name != 'System Administrator' AND isActive=true limit 1];
            GS1_AuthorProfile__c testAuthor = GS1_TestHelper.createAuthor(u.id);
            GS1_CountryAuthor__c[] cauthors = new List<GS1_CountryAuthor__c>();
            
            cauthors = new List<GS1_CountryAuthor__c>();
            for (GS1_Request__c req : gs1ListTest) {
                GS1_CountryAuthor__c cau = new GS1_CountryAuthor__c();
                cau.AuthorProfile__c = testAuthor.id;
                cau.Country__c = req.Country__c;
                cau.Country_Reader__c = false;
                cauthors.add(cau);
            }                   
            insert cauthors;
                
            testAuthor.Active__c = false;
            update testAuthor;                  
            testAuthor.Active__c = true;
            update testAuthor;              
  
        }
        Test.stopTest();    
    }         
    
    static testMethod void testSharing4(){
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){
            List<GS1_Request__c>  gs1ListTest = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU);
            gs1ListTest.addAll(GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU));
			User u = GS1_TestHelper.createTestUser();//[select id from User where profile.userlicense.name='Salesforce' AND profile.name != 'System Administrator' AND isActive=true limit 1];
            GS1_AuthorProfile__c testAuthor = GS1_TestHelper.createAuthor(u.id);
            GS1_CountryAuthor__c[] cauthors = new List<GS1_CountryAuthor__c>();
            
            for (GS1_Request__c req : gs1ListTest) {
                GS1_CountryAuthor__c cau = new GS1_CountryAuthor__c();
                cau.AuthorProfile__c = testAuthor.id;
                cau.Country__c = req.Country__c;
                cauthors.add(cau);
            }
            
            testAuthor.GS1_Administrator__c = true;
            update testAuthor;
            
            insert cauthors; 
            
            GS1_country__c country = new GS1_Country__c(name='THIS IS A LONG COUNTRY NAME THAT NEVER ENDS UNTIL IT ENDS' + String.valueOf( System.currentTimeMillis() ) ,Code__c=String.valueOf( System.currentTimeMillis() ));
            insert country;
            
            gs1ListTest[0].country__c = country.id;
            update gs1ListTest;
            
            Test.startTest();
            delete gs1ListTest;
            delete country;
			delete cauthors;
            delete testAuthor;
            Test.stopTest();
        }    
    }
    
    static testMethod void testSharing5(){
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){
            List<GS1_Request__c>  gs1ListTest = GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU);
            gs1ListTest.addAll(GS1_TestHelper.createRequest(1, GS1_TestHelper.REQUEST_CUDU));
			User u = GS1_TestHelper.createTestUser();//[select id from User where profile.userlicense.name='Salesforce' AND profile.name != 'System Administrator' AND isActive=true limit 1];
            GS1_AuthorProfile__c testAuthor = GS1_TestHelper.createAuthor(u.id);
            GS1_CountryAuthor__c[] cauthors = new List<GS1_CountryAuthor__c>();
            
            for (GS1_Request__c req : gs1ListTest) {
                GS1_CountryAuthor__c cau = new GS1_CountryAuthor__c();
                cau.AuthorProfile__c = testAuthor.id;
                cau.Country__c = req.Country__c;
                cauthors.add(cau);
            }
            
            testAuthor.GS1_Administrator__c = true;
            update testAuthor;
            testAuthor.GS1_Administrator__c = false;
            update testAuthor;            
            
            insert cauthors; 
            
 	        GS1_SharingProcessor.DestroyAndRebuildAccess(true);
            
            Test.startTest();
            delete gs1ListTest;
			delete cauthors;
            delete testAuthor;
            Test.stopTest();
        }                    
    }         
    static testMethod void testBatch1() {
        User me = [select id from User where Id=:System.userInfo.getUserId()];
        System.runAs(me){
        	Test.startTest();
 	        GS1_BatchUpdateRequestSharing burs = new GS1_BatchUpdateRequestSharing();
	        Database.executeBatch(burs); 
	        burs.execute(null);       
	        Test.stopTest(); 	
        }    		
    }   

    static testMethod void testBatch2() {

        User me = [select id from User where Id=:System.userInfo.getUserId()];

        System.runAs(me){
        	Test.startTest();
 	        GS1_BatchUpdateRequestSharing burs = new GS1_BatchUpdateRequestSharing(null);
        	burs.execute(null);
			burs.execute(null,null);        		
        	Test.stopTest(); 
        }    

    }            

    

    static testMethod void testBatch3() {

        User me = [select id from User where Id=:System.userInfo.getUserId()];

        System.runAs(me){
	        Test.startTest();
	        Set<id> cids = new Set<id>();
	        GS1_BatchUpdateRequestSharing burs = new GS1_BatchUpdateRequestSharing(cids);
        	burs.execute(null);
			burs.execute(null,null);        		
        	Test.stopTest(); 

        }    

    } 

    

    static testMethod void testBatch4() {

        User me = [select id from User where Id=:System.userInfo.getUserId()];

        System.runAs(me){
	        Test.startTest();
	        Set<id> cids = new Set<id>();
	        GS1_country__c country = new GS1_Country__c(name='THIS IS A LONG COUNTRY NAME THAT NEVER ENDS UNTIL IT ENDS' + String.valueOf( System.currentTimeMillis() ) ,Code__c=String.valueOf( System.currentTimeMillis() ));
	        insert country; 
	        cids.add(country.id);
	        GS1_BatchUpdateRequestSharing burs = new GS1_BatchUpdateRequestSharing(cids);
        	burs.execute(null);
			burs.execute(null,null);        		
        	Test.stopTest(); 

        }    

    }                            
}