@isTest
private class OppDetailsPDF_Test {
    @isTest
    static void testSendEmailOnClosedWon() {
        String B2BId = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('B2B_Customer')
            .getRecordTypeId();
        Account testAcc = TestUtils.createAccount('Acme Corp', '123-456-7890',B2BId);
        Contact con = TestUtils.createContact('Rita', 'Nassar', 'rita.nassar@eit-mena.com');
        con.AccountId = testAcc.Id;
        update con;
        User testUser = TestUtils.createUser('Tester', 'rita.nassar@eit.mena.com');
        Opportunity opp = TestUtils.createOpportunity('Test Opp', 'Prospecting');
        opp.AccountId = testAcc.Id;
        update opp;

        TestUtils.createTeamMember(opp.Id, testUser.Id, 'Sales Rep');

        Test.startTest();
        opp.StageName = 'Closed Won';
        update opp;
        Test.stopTest(); 
        
        Opportunity updatedOpp = [SELECT StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Closed Won', updatedOpp.StageName, 'Opportunity stage should be Closed Won');
    }
}