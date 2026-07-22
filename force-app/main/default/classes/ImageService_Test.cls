@isTest
private class ImageService_Test {

    @isTest
    static void testGetProductImagesSuccess() {
        Product2 prod = TestUtils.createProduct('Generator X', 'France', 'SN-999', 12.0);

        ContentVersion cv = TestUtils.createContentVersion(
            'Product Image',
            'sample.jpg',
            Blob.valueOf('Fake Image Data')
        );

        ContentVersion insertedCv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        TestUtils.createContentDocumentLink(insertedCv.ContentDocumentId, prod.Id);

        Test.startTest();
        List<String> imageUrls = ImageService.getProductImages(prod.Id);
        Test.stopTest();

        System.assertEquals(1, imageUrls.size(), 'Should return 1 image URL');
        System.assert(imageUrls[0].contains(cv.Id), 'URL should contain the ContentVersion Id');
    }
}