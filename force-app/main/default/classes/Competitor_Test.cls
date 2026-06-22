@isTest
private class Competitor_Test {

    @testSetup
    static void setupTestData() {

        Account acc = new Account(Name = 'Test Account Corp');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id
        );
        insert opp;

        Quote q = new Quote(
            Name = 'Test Quote',
            OpportunityId = opp.Id
        );
        insert q;
    }

    @isTest
    static void testAssignCompetitorToAccountSuccess() {

        Account acc = [SELECT Id FROM Account LIMIT 1];
        Quote q = [SELECT Id FROM Quote LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();

        Competitor__c quoteComp = new Competitor__c(
           Account__c = acc.Id,
           Quote__c = q.Id
        );
        insert quoteComp;

        Test.stopTest();

        List<Competitor__c> activeCompetitors = [SELECT Id, Opportunity__c, Quote__c, Name FROM Competitor__c];
        System.assertEquals(2, activeCompetitors.size(), 'An automatic opportunity competitor should have been generated.');

        Boolean foundOppComp = false;
        for (Competitor__c c : activeCompetitors) {
            if (c.Opportunity__c == opp.Id && c.Name == 'Comp Test Opp') {
                foundOppComp = true;
            }
        }
        System.assertEquals(true, foundOppComp, 'The automated competitor should point to the correct Opportunity and have the correct name prefix.');
    }

    @isTest
    static void testCheckCompetitorLinksValidationError() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Quote q = [SELECT Id FROM Quote LIMIT 1];

        Competitor__c existingComp = new Competitor__c(
            Account__c = acc.Id,
            Quote__c = q.Id
        );
        insert existingComp;

        Test.startTest();

        Competitor__c duplicateComp = new Competitor__c(
            Account__c = acc.Id,
            Quote__c = q.Id
        );

        try {
            insert duplicateComp;
            System.assert(false, 'The code should have thrown a validation error and failed.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('This account is already related to a quote through a competitor'), 
                          'The validation rule did not throw the expected error message.');
        }

        Test.stopTest();
    }
}