@isTest
private class ClosedWonOpportunityController_Test {

    @isTest
    static void testCreateClosedWonOppSuccess() {
        Account testAcc = TestUtils.createPersonAccount('Rita', 'Nassar', 'rita.nassar@eit-mena.com');


        Id standardPbId = Test.getStandardPricebookId();

        Pricebook2 b2cPricebook = TestUtils.createB2CPricebook();
        system.debug('Money: '+b2cPricebook);
        Product2 testProduct = TestUtils.createProduct('Generator X', 'France', 'SN-001', 10.0);
        TestUtils.createPricebookEntry(standardPbId, testProduct.Id, 300);
        TestUtils.createPricebookEntry(b2cPricebook.Id, testProduct.Id, 150);

        List<Id> productIds = new List<Id>{ testProduct.Id };
        system.debug('@@ : '+testAcc.Id);
        system.debug('$$ : '+productIds);

        Test.startTest();
        ClosedWonOpportunityController.ResultWrapper result = 
            ClosedWonOpportunityController.createClosedWonOpp(testAcc.Id, productIds);
        Test.stopTest();

        System.assertNotEquals(null, result.recordId, 'Opportunity Record ID should not be null');
        System.assertEquals(true, result.isSuccess, 'Result wrapper should indicate success');

        List<OpportunityLineItem> lineItems = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :result.recordId];
        System.assertEquals(1, lineItems.size(), 'One Opportunity Line Item should be created');
    }

}