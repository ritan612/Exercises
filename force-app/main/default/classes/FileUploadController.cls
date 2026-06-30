public with sharing class FileUploadController {
    @AuraEnabled
    public static Id uploadFile(Id parentId, String base64Data, String fileName) {
        String base64Content = base64Data.substringAfter('base64,');
        ContentVersion cv = new ContentVersion(
            Title       = fileName,
            PathOnClient= fileName,
            VersionData = EncodingUtil.base64Decode(base64Content)
        );
        insert cv;
        Id docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        insert new ContentDocumentLink(
            ContentDocumentId = docId,
            LinkedEntityId    = parentId,
            ShareType         = 'V'
        );
        return cv.Id;
    }
}