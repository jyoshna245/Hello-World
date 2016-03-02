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
public class RFATestData {
    
    
    public static User requester = new User();
    public static ARE_RFA__c testARE = new ARE_RFA__c();
    public static ProfitCenter__c testProfitCenter = new ProfitCenter__c();
    public static Map<String, User> levelLCUserMap = new Map<String, User>();
    public static ReportingUnit__c testReportingUnit = new ReportingUnit__c();
    public static ReportingUnit__c testReportingUnitSubstitute = new ReportingUnit__c();
    private static Integer ctr = 0; // used to generate random unique strings for creating user records
    
    public static String rfaStandardUserProfile;
    
    
    static{
        rfaStandardUserProfile = RFATestData.getRFAStandardUserProfile();
    }
        //Test Data for RFA_VFC_SkipLevelController
     public void buildProfitCenterSkiplevel()
    {
        testProfitCenter.Business_Unit_Name__c = 'Coca-Cola USA Industries';
        testProfitCenter.GroupName__c = 'Bottling Investments';
        testProfitCenter.KeyOperationName__c = 'Coca Cola NA';
        testProfitCenter.ProfitCenterName__c = 'Test Coke PC';
        testProfitCenter.ActiveInactive__c = 'Active';
        insert testProfitCenter;
        buildProfitCenterUserRoleSkiplevel(testProfitCenter.Id);     
        testProfitCenter = [Select Id, MinLevel__c, KeyOperationName__c, ActiveInactive__c, GroupName__c FROM ProfitCenter__c where Id = : testProfitCenter.Id];
        buildARE();
        buildReportingUnit();
    }
    
    public void buildProfitCenterUserRoleSkiplevel(String pcId)
    {
        List<ProfitCenterUserRole__c> pcUserRoleForInsert = new List<ProfitCenterUserRole__c>();
        //this.rfaStandardUserProfile = getRFAStandardUserProfile();
        
        // create ko lc profit center user role
        User koUser = new User();
        koUser = createUser(rfaStandardUserProfile, 'koUsert', 'kolastt', koUser);      
        
        ProfitCenterUserRole__c koUserRole = new ProfitCenterUserRole__c();
        koUserRole.Level__c = '1. Key Operations';
        koUserRole.ProfitCenter__c = pcId;
        koUserRole.UserName__c = koUser.Id;
        koUserRole.UserType__c = 'Location Coordinator';
        pcUserRoleForInsert.add(koUserRole);
        levelLCUserMap.put('1. Key Operations', koUser);
        
        
        
        // create BU lc profit center user role
        
        User GrpUser = new User();
        
        GrpUser = createUser(rfaStandardUserProfile,'GrpUsert', 'bulastt', GrpUser);      
        
        ProfitCenterUserRole__c GrpUserRole = new ProfitCenterUserRole__c();
        GrpUserRole .Level__c = '3. Group';
        GrpUserRole .ProfitCenter__c = pcId;
        GrpUserRole .UserName__c = GrpUser.Id;
        GrpUserRole .UserType__c = 'Location Coordinator';
        pcUserRoleForInsert.add(GrpUserRole );
        levelLCUserMap.put('3. Group', GrpUser );
        
        
        
        
        insert pcUserRoleForInsert;
    }
    
     public static RFA__c buildTestRFASkipLevel(RFA__c testRFA, String rt)
    {
        testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =  rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        testRFA.RequestAmountFunctionalCurrency__c = 1200;      
        testRFA.Functional_Currency__c = RFATestData.testARE.Id;
        testRFA.Stage__c = 'Pre-Circulation';
        testRFA.Level__c = '1. Key Operations';
        testRFA.DataClassification__c = 'Internal Use';
        testRFA.AREMonth__c = 'February';
        testRFA.InitialBudgetYear__c = '2013';
        testRFA.BudgetType__c = 'Formal';
        testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
        testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
        testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
        insert testRFA;
        RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
        
        if (rt == RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id ||
            rt == RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id)
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
        //system.debug('test RFA USDAmount is:' +testRFA.RequestAmountUSD__c);
        return testRFA;
    }
    
    
    //Test Data for RFA_VFC_SkipLevelController
    
    
    public void buildProfitCenter()
    {
        testProfitCenter.Business_Unit_Name__c = 'Coca-Cola USA Industries';
        testProfitCenter.GroupName__c = 'Bottling Investments';
        testProfitCenter.KeyOperationName__c = 'Coca Cola NA';
        testProfitCenter.ProfitCenterName__c = 'Test Coke PC';
        testProfitCenter.ActiveInactive__c = 'Active';        
        insert testProfitCenter;
        buildProfitCenterUserRole(testProfitCenter.Id);     
        testProfitCenter = [Select Id, MinLevel__c, KeyOperationName__c, ActiveInactive__c, GroupName__c FROM ProfitCenter__c where Id = : testProfitCenter.Id];
        buildARE();
        buildReportingUnit();
    }
    
    public void buildProfitCenterUserRole(String pcId)
    {
        List<ProfitCenterUserRole__c> pcUserRoleForInsert = new List<ProfitCenterUserRole__c>();
        //this.rfaStandardUserProfile = getRFAStandardUserProfile();
        
        // create ko lc profit center user role
        User koUser = new User();
        koUser = createUser(rfaStandardUserProfile, 'koUsert', 'kolastt', koUser);      
        
        ProfitCenterUserRole__c koUserRole = new ProfitCenterUserRole__c();
        koUserRole.Level__c = '1. Key Operations';
        koUserRole.ProfitCenter__c = pcId;
        koUserRole.UserName__c = koUser.Id;
        koUserRole.UserType__c = 'Location Coordinator';
        pcUserRoleForInsert.add(koUserRole);
        levelLCUserMap.put('1. Key Operations', koUser);
        
        
        // create BU lc profit center user role
        
        User buUser = new User();
        buUser = createUser(rfaStandardUserProfile, 'buUsert', 'bulastt', buUser);      
        
        ProfitCenterUserRole__c buUserRole = new ProfitCenterUserRole__c();
        buUserRole.Level__c = '2. Business Unit';
        buUserRole.ProfitCenter__c = pcId;
        buUserRole.UserName__c = buUser.Id;
        buUserRole.UserType__c = 'Location Coordinator';
        pcUserRoleForInsert.add(buUserRole);
        levelLCUserMap.put('2. Business Unit', buUser);
        
        // create GR lc profit center user role
        
        User grUser = new User();
        grUser = createUser(rfaStandardUserProfile, 'grUsert', 'grlastt', grUser);      
        
        ProfitCenterUserRole__c grUserRole = new ProfitCenterUserRole__c();
        grUserRole.Level__c = '3. Group';
        grUserRole.ProfitCenter__c = pcId;
        grUserRole.UserName__c = grUser.Id;
        grUserRole.UserType__c = 'Location Coordinator';
        pcUserRoleForInsert.add(grUserRole);
        levelLCUserMap.put('3. Group', grUser);
        
        // create corp lc profit center user role
        
        User corpUser = new User();
        corpUser = createUser(rfaStandardUserProfile, 'coUsert', 'corlstt', corpUser);      
        
        ProfitCenterUserRole__c corpUserRole = new ProfitCenterUserRole__c();
        corpUserRole.Level__c = '4. Corporate';
        corpUserRole.ProfitCenter__c = pcId;
        corpUserRole.UserName__c = corpUser.Id;
        corpUserRole.UserType__c = 'Location Coordinator';
        pcUserRoleForInsert.add(corpUserRole);
        levelLCUserMap.put('4. Corporate', corpUser);
        
        insert pcUserRoleForInsert;
    }
    
    public ProfitCenter__c buildProfitCenterWithMinLevel(String ProfitCenterName, String MinLevel)
    {
        ProfitCenter__c newProfitCenter = new ProfitCenter__c();
        
        newProfitCenter.Business_Unit_Name__c = 'Coca-Cola USA Industries';
        newProfitCenter.GroupName__c = 'Bottling Investments';
        newProfitCenter.KeyOperationName__c = 'Coca Cola NA';
        newProfitCenter.ProfitCenterName__c = ProfitCenterName;
        newProfitCenter.ActiveInactive__c = 'Active';
        insert newProfitCenter;
        buildProfitCenterUserRoleWithMinLevel(newProfitCenter.Id, MinLevel);        
        
        return [Select Id, MinLevel__c, KeyOperationName__c, ActiveInactive__c, GroupName__c, 
        (Select Id, Level__c, UserName__c, UserType__c From Profit_Center_Associated_Users__r)
         FROM ProfitCenter__c where Id = :newProfitCenter.id];
    }
    
    public void buildProfitCenterUserRoleWithMinLevel(String pcId, String MinLevel)
    {
        List<ProfitCenterUserRole__c> pcUserRoleForInsert = new List<ProfitCenterUserRole__c>();
        //this.rfaStandardUserProfile = getRFAStandardUserProfile();
        
        // Unique String for creating unique Users 
        String uniqueString = String.valueOf(ctr++);
        
        if ( MinLevel.contains(Label.RFA_CL001) )
        {
            // create ko lc profit center user role
            User koUser = new User();
            koUser = createUser(rfaStandardUserProfile, 'koUsr' + uniqueString, 'kolastt' + uniqueString, koUser);      
            
            ProfitCenterUserRole__c koUserRole = new ProfitCenterUserRole__c();
            koUserRole.Level__c = '1. Key Operations';
            koUserRole.ProfitCenter__c = pcId;
            koUserRole.UserName__c = koUser.Id;
            koUserRole.UserType__c = 'Location Coordinator';
            pcUserRoleForInsert.add(koUserRole);
        }
        
        // create BU lc profit center user role
        if ( MinLevel.contains(Label.RFA_CL001) || MinLevel.contains(Label.RFA_CL002))
        {
            User buUser = new User();
            buUser = createUser(rfaStandardUserProfile, 'buUsr' + uniqueString, 'bulastt' + uniqueString, buUser);      
            
            ProfitCenterUserRole__c buUserRole = new ProfitCenterUserRole__c();
            buUserRole.Level__c = '2. Business Unit';
            buUserRole.ProfitCenter__c = pcId;
            buUserRole.UserName__c = buUser.Id;
            buUserRole.UserType__c = 'Location Coordinator';
            pcUserRoleForInsert.add(buUserRole);
        }
        
        // create GR lc profit center user role
        if ( MinLevel.contains(Label.RFA_CL001) || MinLevel.contains(Label.RFA_CL002)
            || MinLevel.contains(Label.RFA_CL003))
        {
            User grUser = new User();
            grUser = createUser(rfaStandardUserProfile, 'grUsr' + uniqueString, 'grlastt' + uniqueString, grUser);      
            
            ProfitCenterUserRole__c grUserRole = new ProfitCenterUserRole__c();
            grUserRole.Level__c = '3. Group';
            grUserRole.ProfitCenter__c = pcId;
            grUserRole.UserName__c = grUser.Id;
            grUserRole.UserType__c = 'Location Coordinator';
            pcUserRoleForInsert.add(grUserRole);
        }
        
        // create corp lc profit center user role
        if ( MinLevel.contains(Label.RFA_CL001) || MinLevel.contains(Label.RFA_CL002)
            || MinLevel.contains(Label.RFA_CL003) || MinLevel.contains(Label.RFA_CL004))
        {
            User corpUser = new User();
            corpUser = createUser(rfaStandardUserProfile, 'coUsr' + uniqueString, 'corlstt' + uniqueString, corpUser);      
            
            ProfitCenterUserRole__c corpUserRole = new ProfitCenterUserRole__c();
            corpUserRole.Level__c = '4. Corporate';
            corpUserRole.ProfitCenter__c = pcId;
            corpUserRole.UserName__c = corpUser.Id;
            corpUserRole.UserType__c = 'Location Coordinator';
            pcUserRoleForInsert.add(corpUserRole);
        }
        
        // create exec lc profit center user role
        if ( MinLevel.contains(Label.RFA_CL001) || MinLevel.contains(Label.RFA_CL002)
            || MinLevel.contains(Label.RFA_CL003) || MinLevel.contains(Label.RFA_CL004)
            || MinLevel.contains(Label.RFA_CL005))
        {
            User ExecUser = new User();
            ExecUser = createUser(rfaStandardUserProfile, 'exUsr' + uniqueString, 'exrlstt' + uniqueString, ExecUser);      
            
            ProfitCenterUserRole__c ExecUserRole = new ProfitCenterUserRole__c();
            ExecUserRole.Level__c = '5. Executive';
            ExecUserRole.ProfitCenter__c = pcId;
            ExecUserRole.UserName__c = ExecUser.Id;
            ExecUserRole.UserType__c = 'Location Coordinator';
            pcUserRoleForInsert.add(ExecUserRole);
        }
        
        // create sr. exec lc profit center user role
        if ( MinLevel.contains(Label.RFA_CL001) || MinLevel.contains(Label.RFA_CL002)
            || MinLevel.contains(Label.RFA_CL003) || MinLevel.contains(Label.RFA_CL004)
            || MinLevel.contains(Label.RFA_CL005) || MinLevel.contains(Label.RFA_CL006))
        {
            User SrExecUser = new User();
            SrExecUser = createUser(rfaStandardUserProfile, 'seUsr' + uniqueString, 'serlstt' + uniqueString, SrExecUser);      
            
            ProfitCenterUserRole__c SrExecUserRole = new ProfitCenterUserRole__c();
            SrExecUserRole.Level__c = '6. Senior Executive';
            SrExecUserRole.ProfitCenter__c = pcId;
            SrExecUserRole.UserName__c = SrExecUser.Id;
            SrExecUserRole.UserType__c = 'Location Coordinator';
            pcUserRoleForInsert.add(SrExecUserRole);
        }
        
        insert pcUserRoleForInsert;
            
    }
    
    public void buildReportingUnit()
    {       
        testReportingUnit.ActiveInactive__c = 'Active';
        testReportingUnit.Name = 'USA Reporting Unit NA';
        testReportingUnit.Reporting_Unit_Name__c = 'Atlanta Bottling Company, Limited';
        insert testReportingUnit;
        User reportingUnitUser = new User();
        reportingUnitUser = createUser(rfaStandardUserProfile, 'reUsert', 'rlastt', reportingUnitUser);     
        
        ReportingUnitUserRole__c userRole = new ReportingUnitUserRole__c();
        userRole.ReportingUnit__c = testReportingUnit.Id;
        userRole.User__c = reportingUnitUser.Id;
        insert userRole;  
        
        testReportingUnitSubstitute.ActiveInactive__c = 'Active';
        testReportingUnitSubstitute.Name = 'USA Reporting Unit NA';
        testReportingUnitSubstitute.Reporting_Unit_Name__c = 'Atlanta Bottling Company, Limited';
        insert testReportingUnitSubstitute;
        User reportingUnitUser2 = new User();
        reportingUnitUser2 = createUser(rfaStandardUserProfile, 'reUsertt', 'rlast', reportingUnitUser);    
        
        ReportingUnitUserRole__c userRole2 = new ReportingUnitUserRole__c();
        userRole2.ReportingUnit__c = testReportingUnit.Id;
        userRole2.User__c = reportingUnitUser.Id;
        insert userRole2;
    }
    
    public void buildARE()
    {
        testARE.Country__c = 'United States';
        testARE.Name = 'USD';
        testARE.JanuaryRate__c = 2;
        testARE.February_Rate__c = 2;
        testARE.March_Rate__c = 2;
        testARE.April_Rate__c = 2;
        testARE.May_Rate__c = 2;
        testARE.June_Rate__c = 2;
        testARE.July_Rate__c = 2;
        testARE.August_Rate__c = 2;
        testARE.September_Rate__c = 2;
        testARE.October_Rate__c = 2;
        testARE.November_Rate__c = 2;
        testARE.December_Rate__c = 2;
        insert testARE;
    }
    
    
    /*
     * This method creates a user record
     * @Paran : String profileId, String alias, String lastName
     * @return: User__c
     * @return void
     */
    public User createUser(String profileId, String alias, String lastName, User testUser)
    {
        testUser = new User();
        testUser.alias = alias;
        testUser.email = 'cokeuserfortest@cocacola.com' + ctr++;
        testUser.emailencodingkey='UTF-8';
        testUser.lastName = lastName;
        testUser.languagelocalekey='en_US';
        testUser.localesidkey='en_US';
        testUser.ProfileId = profileId;
        testUser.timezonesidkey='Europe/London';
        testUser.UserName = alias+'@rfa.cocacola.com';
        insert testUser;
        return testUser;
    }
    
    
     /*
     * This method creates a Agent user record
     * @Paran : String profileId, String alias, String lastName
     * @return: User__c
     * @return void
     */
    public User createUserasAgent(String profileId, String alias, User testUser)
    {
        testUser = new User();
        testUser.alias = alias;
        testUser.email = 'cokeuserfortestAgent@cocacola.com' + ctr++;
        testUser.emailencodingkey='UTF-8';
        testUser.lastName = 'Agent1';
        testUser.languagelocalekey='en_US';
        testUser.localesidkey='en_US';
        testUser.ProfileId = profileId;
        testUser.timezonesidkey='Europe/London';
        testUser.UserName = alias+'@rfa.cocacola.com';
        insert testUser;
        return testUser;
    }
    
    
          
    public static RFA__c createTestRFA(String stage) {
        RFA__c rfaTest = new RFA__c();
        rfaTest.Stage__c = stage;
        rfaTest.ControlNumber__c = 'Sehwag - 219';
        rfaTest.LocalReferenceNumber__c = 'L23345';
        rfaTest.RequestTitle__c = 'Test Data Created in test class';
        rfaTest.LCOACategorySubCategory__c = 'Testing 3 years Cash Spent';
        //rfaTest.RequestedAmount__c = 4567;
        //rfaTest.InitialBudgetYear
        return null;
    }
    
    public static RFA__c buildTestRFA(RFA__c testRFA, String rt)
    {
        testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =  rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        testRFA.RequestAmountFunctionalCurrency__c = 1200;      
        testRFA.Functional_Currency__c = RFATestData.testARE.Id;
        testRFA.Stage__c = 'Pre-Circulation';
        testRFA.Level__c = '1. Key Operations';
        testRFA.DataClassification__c = 'Internal Use';
        testRFA.AREMonth__c = 'February';
        testRFA.InitialBudgetYear__c = '2013';
        testRFA.BudgetType__c = 'Formal';
        testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
        testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
        testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
        insert testRFA;        
        RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200); 
        if (rt == RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id ||
            rt == RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id)
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
        
        return testRFA;
    }
    
    public static String getRFAStandardUserProfile()
    {
        return [Select Id, Name FROM Profile where Name = 'RFA - Standard User' LIMIT 1].Id;
    }
    
    public void createRequester()
    {
        //String rfaStandardUserProfile = getRFAStandardUserProfile();
        requester = createUser(rfaStandardUserProfile, 'rUsert', 'reqlastt', requester);    
    }
    
    public static String getRecordType(String pName, String sObjectType)
    {
        return [Select Id, Name FROM RecordType Where SObjectType =: sObjectType AND Name =: pName].Id;
    }
    
    
    public static void updateThreeYearCashSpentForRFA(RFA__c rfaObj, Double amount)
    {
        ThreeYearCashSpend__c[] cashSpents = [Select ARERate__c, Name FROM ThreeYearCashSpend__c where RFA__c =: rfaObj.Id];
        cashSpents[0].X3YearCashSpendFunc__c = amount;
        update cashSpents[0];
    }
    
    public static void updateCapitalExpenditure(RFA__c rfaObj, Double amount)
    {
        Capital_Expenditure__c[] expenditureArray = [Select Amount__c From Capital_Expenditure__c where RFA__c =: rfaObj.Id];
         expenditureArray[0].Amount__c = amount;
        update expenditureArray[0];
    }
    
    public static RFAUserRole__c buildApprover(String rfaId, User approver, String level)
    {
            
        RFAUserRole__c approver1 = new RFAUserRole__c();
        approver1.RFA__c = rfaId;
        approver1.UserName__c = approver.Id;
        approver1.Level__c = level;
        approver1.RecordTypeId = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id;
        return approver1;
    }
    
    public static RFAUserRole__c buildApprover(String rfaId, String level)
    {
            
        RFAUserRole__c approver1 = new RFAUserRole__c();
        approver1.RFA__c = rfaId;
        //approver1.UserName__c = approver.Id;
        approver1.Level__c = level;
        approver1.RecordTypeId = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id;
        return approver1;
    }
    
    public static RFAUserRole__c buildCoCreator(String rfaId, User cocreatorUser)
    {
        RFAUserRole__c cocreator = new RFAUserRole__c();
        cocreator.RFA__c = rfaId;
        cocreator.UserName__c = cocreatorUser.Id;
        cocreator.RecordTypeId = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id;
        return cocreator;   
    }
    
    public static RFAUserRole__c buildPPOC(String rfaId, User cocreatorUser)
    {
        RFAUserRole__c cocreator = new RFAUserRole__c();
        cocreator.RFA__c = rfaId;
        cocreator.UserName__c = cocreatorUser.Id;
        cocreator.RecordTypeId = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.RECORDTYPE_PRIMARY_POC).Id;
        return cocreator;   
    }
    
    public static RFAUserRole__c buildInfoOnlyUsers(String rfaId, User infoUsers)
    {
        RFAUserRole__c reviewer = new RFAUserRole__c();
        reviewer.RFA__c = rfaId;
        reviewer.UserName__c = infoUsers.Id;
        reviewer.RecordTypeId = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id;
        return reviewer;
    }
    
    public static RFAUserRole__c buildInfoOnlyUsers(String rfaId, User infoUsers, String level)
    {
        RFAUserRole__c reviewer = new RFAUserRole__c();
        reviewer.RFA__c = rfaId;
        reviewer.UserName__c = infoUsers.Id;
        reviewer.Level__c = level;
        reviewer.RecordTypeId = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.RECORDTYPE_INFOONLY).Id;
        return reviewer;
    }
    
    public static RFA_Business_Unit__c buildRFAHierarchyBusinessUnit()
    {
        RFA_Business_Unit__c rfaBU= new RFA_Business_Unit__c();
        
        rfaBu.name='Test BU';
        rfaBu.Business_Unit_Description__c='Test BU desc';
        return rfaBU;          
    }
    public ProfitCenter__c buildRFAHierarchyProfitCenter(Id BUid)
    {
        testProfitCenter.Business_Unit_Name__c = 'Coca-Cola USA Industries';
        testProfitCenter.GroupName__c = 'Bottling Investments';
        testProfitCenter.KeyOperationName__c = 'Coca Cola NA';
        testProfitCenter.ProfitCenterName__c = 'Test Coke PC';
        testProfitCenter.ActiveInactive__c = 'Active';
        testProfitCenter.RFA_Business_Units__c = BUid;        
        insert testProfitCenter;
 
        buildProfitCenterUserRole(testProfitCenter.id);     
        testProfitCenter = [Select Id, MinLevel__c, Name, KeyOperationName__c, ActiveInactive__c, GroupName__c FROM ProfitCenter__c where Id = : testProfitCenter.Id];
        return testProfitCenter;
    }
    
}