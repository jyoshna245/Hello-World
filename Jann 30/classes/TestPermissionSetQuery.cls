@isTest

private class TestPermissionSetQuery{
    
    static testMethod void PermissionSetQuery_Test(){
        
        //Insert User
        User u = new User(
        FirstName = 'QTest',
        LastName = 'QUser',
        ProfileId = '00ed000000140eQAAQ',
        Email = 'queryuser@coca-cola.com',
        Username = 'queryuser@rfa.coca-cola.com',
        Alias = 'QUser',
        CommunityNickname = 'QUserComNick',
        TimeZoneSidKey = 'America/New_York',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US'
        );
        
        insert u;
        
        //Assign User to Group
        GroupMember gm = new GroupMember(
        GroupId = Label.PermissionSetGroup,
        UserOrGroupId = u.Id
        );
        
        insert gm;
        
        //Assign RFA Auditor Add On to User
        PermissionSetAssignment psa = new PermissionSetAssignment(
        PermissionSetId = '0PSd0000000r3p5GAA',
        AssigneeId = u.Id
        );
        
        insert psa;
        
        //Execute BatchApex
        Test.StartTest();
        PermissionSetQuery psq = new PermissionSetQuery();
        psq.query = 'SELECT SystemModstamp, Assignee.Name, Assignee.Profile.Name, PermissionSet.Label FROM PermissionSetAssignment WHERE PermissionSet.IsOwnedByProfile = false AND PermissionSet.Label = \'' + 'RFA Auditor Add On' + '\' ORDER BY SystemModstamp DESC';
        ID batchprocessid = Database.executeBatch(psq);
        Test.StopTest();
        
        User uCheck = [SELECT Id, Name, Email FROM User WHERE Id = :u.Id];
        System.AssertEquals(uCheck.Email, u.Email);
    }
}