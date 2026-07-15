public with sharing class ProductServices {
    
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getAllProduct() {
        return [
            SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Country_Of_Origin__c
            FROM PricebookEntry
            WHERE Pricebook2.Name = 'B2C Pricebook' AND IsActive = true
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getGenerator() {
        return [
            SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Country_Of_Origin__c
            FROM PricebookEntry
            WHERE Pricebook2.Name = 'B2C Pricebook' 
            AND Product2.RecordTypeId = '012g5000003E6i9AAC' 
            AND IsActive = true
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getParts() {
        return [
            SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Country_Of_Origin__c
            FROM PricebookEntry
            WHERE Pricebook2.Name = 'B2C Pricebook' 
            AND Product2.RecordTypeId = '012g5000003E6lNAAS' 
            AND IsActive = true
        ];
    }
}