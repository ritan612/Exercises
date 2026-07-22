@isTest
private class WebsiteService_Test {

    @isTest
    static void testGetOppDetails() {
        Account testAcc = TestUtils.createAccount('Acme Corp', '123-456-7890');

        Opportunity opp = TestUtils.createOpportunity('Big Deal', 'Prospecting');
        opp.AccountId = testAcc.Id;
        system.debug('RA: '+opp.AccountId);
        update opp;

        Test.startTest();
        Website_Service.OpportunityData result = Website_Service.getOppDetails(opp.Id);
        Test.stopTest();

        System.assertEquals('Acme Corp', result.companyName, 'Company Name should match Account Name');
        System.assertEquals('Big Deal', result.contactName, 'Contact Name should match Opportunity Name');
        System.assertEquals('123-456-7890', result.phone, 'Phone should match Account Phone');
    }

}