@isTest
private class ProductService_Test {

    @isTest
    static void testProductServicesMethods() {
        Pricebook2 b2cPricebook = TestUtils.createB2CPricebook();
        Product2 testProduct = TestUtils.createProduct('Test Generator', 'France', 'SN-12345', 10.5);
        
        Id standardPbId = Test.getStandardPricebookId();
        TestUtils.createPricebookEntry(standardPbId, testProduct.Id, 100);
        
        PricebookEntry b2cEntry = TestUtils.createPricebookEntry(b2cPricebook.Id, testProduct.Id, 150);

        Test.startTest();
        
        Integer allCount = ProductServices.getProductCount('All', 'France');
        Integer generatorCount = ProductServices.getProductCount('Generator', 'All');
        
        List<PricebookEntry> allProducts = ProductServices.getAllProduct(10, 0, 'France');
        List<PricebookEntry> generators = ProductServices.getGenerator(10, 0, 'France');
        List<PricebookEntry> parts = ProductServices.getParts(10, 0, 'France');
        
        ProductServices.productDetails details = ProductServices.getSingleProductDetails(testProduct.Id);
        
        Test.stopTest();

        System.assertNotEquals(null, allCount, 'Count should not be null');
        System.assertEquals(1, allProducts.size(), 'Should return 1 PricebookEntry');
        System.assertEquals(testProduct.Id, details.prodid, 'Product ID should match');
        System.assertEquals('SN-12345', details.serialNumber, 'Serial number should match');
    }
}