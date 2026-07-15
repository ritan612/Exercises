public with sharing class ProductServices {
    
    @AuraEnabled(cacheable=true)
    public static Integer getProductCount(String type, String country) {
        String baseQuery = 'SELECT COUNT() FROM PricebookEntry WHERE Pricebook2.Name = \'B2C Pricebook\' AND IsActive = true';
        if (type == 'Generator') {
            baseQuery += ' AND Product2.RecordTypeId = \'012g5000003E6i9AAC\'';
        } else if (type == 'Parts') {
            baseQuery += ' AND Product2.RecordTypeId = \'012g5000003E6lNAAS\'';
        }
        
        // Dynamic country filtering
        if (country != null && country != 'All') {
            baseQuery += ' AND Product2.Country_Of_Origin__c = :country';
        }
        return Database.countQuery(baseQuery);
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getAllProduct(Integer pageSize, Integer offsetValue, String country) {
        String query = 'SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Country_Of_Origin__c ' +
                       'FROM PricebookEntry ' +
                       'WHERE Pricebook2.Name = \'B2C Pricebook\' AND IsActive = true';
        if (country != null && country != 'All') {
            query += ' AND Product2.Country_Of_Origin__c = :country';
        }
        query += ' LIMIT :pageSize OFFSET :offsetValue';
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getGenerator(Integer pageSize, Integer offsetValue, String country) {
        String query = 'SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Country_Of_Origin__c ' +
                       'FROM PricebookEntry ' +
                       'WHERE Pricebook2.Name = \'B2C Pricebook\' AND Product2.RecordTypeId = \'012g5000003E6i9AAC\' AND IsActive = true';
        if (country != null && country != 'All') {
            query += ' AND Product2.Country_Of_Origin__c = :country';
        }
        query += ' LIMIT :pageSize OFFSET :offsetValue';
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getParts(Integer pageSize, Integer offsetValue, String country) {
        String query = 'SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Country_Of_Origin__c ' +
                       'FROM PricebookEntry ' +
                       'WHERE Pricebook2.Name = \'B2C Pricebook\' AND Product2.RecordTypeId = \'012g5000003E6lNAAS\' AND IsActive = true';
        if (country != null && country != 'All') {
            query += ' AND Product2.Country_Of_Origin__c = :country';
        }
        query += ' LIMIT :pageSize OFFSET :offsetValue';
        return Database.query(query);
    }

    @AuraEnabled(cacheable=false)
    public static productDetails getSingleProductDetails(Id id){
        Product2 currentProduct = [
            SELECT Id , Name
            FROM Product2
            WHERE Id = :id
            limit 1
        ];

        productDetails pd = new productDetails(currentProduct.Name);
        return pd;
    }

    public class productDetails {
        @AuraEnabled public String productName {get;set;}

        public productDetails(String Name) {
            this.productName = Name;
        }
    }
}