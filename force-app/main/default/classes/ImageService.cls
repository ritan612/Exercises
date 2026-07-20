public with sharing class ImageService {
   
    
    @AuraEnabled(cacheable=true)
    public static List<String> getProductImages(Id productId) {
        List<String> imageUrls = new List<String>();
        
        if (productId == null) {
            return;
        }

        List<ContentDocumentLink> links = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :productId
        ];

        if (links.isEmpty()) {
            return;
        }

        List<Id> docIds = new List<Id>();
        for (ContentDocumentLink link : links) {
            docIds.add(link.ContentDocumentId);
        }

        List<ContentVersion> files = [
            SELECT Id 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :docIds 
            AND IsLatest = true 
            AND FileType IN ('PNG', 'JPG', 'JPEG', 'GIF')
        ];

        for (ContentVersion file : files) {
            String downloadUrl = '/sfc/servlet.shepherd/version/download/' + file.Id;
            imageUrls.add(downloadUrl);
        }

        return imageUrls;
    }
}
