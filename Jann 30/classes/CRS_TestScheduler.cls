/*
* author: Ivan_Tsitulenka
* class: CRS_NewYearEvents, CRS_EveryDayEvents
* method: *
*/
@isTest
private class CRS_TestScheduler {

    static testMethod void newYearEventTest() {
    	test.startTest();
    	CRS_NewYearEvents m = new CRS_NewYearEvents();
        String sch = '0 0 0 1 1 ?';
        String jobId = system.schedule('New Year Events', sch, m);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];
        
        test.stopTest();
        
        System.assertEquals((System.today().addYears(1).year())+'-01-01 00:00:00', 
        String.valueOf(ct.NextFireTime));
    }
    
    static testMethod void everyDayEventTest() {
    	test.startTest();
        CRS_EveryDayEvents m = new CRS_EveryDayEvents();
        String sch = '0 0 0 * * ?';
        String jobId = system.schedule('Every Day Events', sch, m);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
        	NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        test.stopTest();
        
        System.assertEquals(System.today().addDays(1)+'', 
        	String.valueOf(ct.NextFireTime));	
    }
    
    static testMethod void eventWeekdaysEvents() {
    	test.startTest();
    	CRS_WeekdaysEvents m = new CRS_WeekdaysEvents();
    	String sch = '0 0 0 * * ?';
		String jobId = system.schedule('Every Day Events', sch, m);
		
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
        	NextFireTime FROM CronTrigger WHERE id = :jobId];
		
		test.stopTest();

		System.assertEquals(System.today().addDays(1)+'', 
        	String.valueOf(ct.NextFireTime));	
    }
    
    static testMethod void eventWeekdaysEventsforDaysinProcess() {
    	test.startTest();
    	CRS_WeekdaysEventsforDaysinProcess m = new CRS_WeekdaysEventsforDaysinProcess();
    	String sch = '0 0 0 * * ?';
		String jobId = system.schedule('Every Day Events', sch, m);
		
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
        	NextFireTime FROM CronTrigger WHERE id = :jobId];
		
		test.stopTest();

		System.assertEquals(System.today().addDays(1)+'', 
        	String.valueOf(ct.NextFireTime));	
    }
}