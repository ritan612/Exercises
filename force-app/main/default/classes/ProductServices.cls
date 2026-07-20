public with sharing class ProductServices {
    
    @AuraEnabled(cacheable=true)
    public static Integer getProductCount(String type, String country) {
        String baseQuery = 'SELECT COUNT() FROM PricebookEntry WHERE Pricebook2.Name = \'B2C Pricebook\' AND IsActive = true';
        if (type == 'Generator') {
            baseQuery += ' AND Product2.RecordTypeId = \'012g5000003E6i9AAC\'';
        } else if (type == 'Parts') {
            baseQuery += ' AND Product2.RecordTypeId = \'012g5000003E6lNAAS\'';
        }
        if (country != null && country != 'All') {
            baseQuery += ' AND Product2.Country_Of_Origin__c = :country';
        }
        return Database.countQuery(baseQuery);
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getAllProduct(Integer pageSize, Integer offsetValue, String country) {
        String query = 'SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Country_Of_Origin__c FROM PricebookEntry WHERE Pricebook2.Name = \'B2C Pricebook\' AND IsActive = true';
        if (country != null && country != 'All') {
            query += ' AND Product2.Country_Of_Origin__c = :country';
        }
        query += ' LIMIT :pageSize OFFSET :offsetValue';
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getGenerator(Integer pageSize, Integer offsetValue, String country) {
        String query = 'SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Country_Of_Origin__c FROM PricebookEntry WHERE Pricebook2.Name = \'B2C Pricebook\' AND Product2.RecordTypeId = \'012g5000003E6i9AAC\' AND IsActive = true';
        if (country != null && country != 'All') {
            query += ' AND Product2.Country_Of_Origin__c = :country';
        }
        query += ' LIMIT :pageSize OFFSET :offsetValue';
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getParts(Integer pageSize, Integer offsetValue, String country) {
        String query = 'SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Country_Of_Origin__c FROM PricebookEntry WHERE Pricebook2.Name = \'B2C Pricebook\' AND Product2.RecordTypeId = \'012g5000003E6lNAAS\' AND IsActive = true';
        if (country != null && country != 'All') {
            query += ' AND Product2.Country_Of_Origin__c = :country';
        }
        query += ' LIMIT :pageSize OFFSET :offsetValue';
        return Database.query(query);
    }
    

    @AuraEnabled(cacheable=false)
    public static productDetails getSingleProductDetails(Id id){
        Product2 currentProduct = [
            SELECT Id , Name, Serial_Number__c, Description, Country_Of_Origin__c, Average_Life_Expectancy__c, Image__c, Size__c, Phase__c , Engine_Type__c, Weight__c, Power_Generated__c, RecordType.DeveloperName
            FROM Product2
            WHERE Id = :id
            LIMIT 1
        ];

        productDetails pd = new productDetails(currentProduct.Id ,currentProduct.Name, currentProduct.Serial_Number__c, currentProduct.Description, currentProduct.Country_Of_Origin__c, currentProduct.Average_Life_Expectancy__c, currentProduct.Image__c, currentProduct.Size__c, currentProduct.Phase__c , currentProduct.Engine_Type__c, currentProduct.Weight__c, currentProduct.Power_Generated__c, currentProduct.recordType.DeveloperName);
        return pd;
    }

    public class productDetails {
    @AuraEnabled public Id prodid {get; set;}
    @AuraEnabled public String productName { get; set; }
    @AuraEnabled public String serialNumber { get; set; }
    @AuraEnabled public String description { get; set; }
    @AuraEnabled public String countryOfOrigin { get; set; }
    @AuraEnabled public Decimal averageLifeExpectancy { get; set; }
    @AuraEnabled public String image { get; set; }
    @AuraEnabled public String size { get; set; }
    @AuraEnabled public String phase { get; set; }
    @AuraEnabled public String engineType { get; set; }
    @AuraEnabled public Decimal weight { get; set; } 
    @AuraEnabled public Decimal powerGenerated { get; set; }
    @AuraEnabled public String recordTypeDeveloperName { get; set; }

    public ProductDetails(
        Id id,
        String name, 
        String serialNumber, 
        String description, 
        String countryOfOrigin, 
        Decimal averageLifeExpectancy, 
        String image, 
        String size, 
        String phase, 
        String engineType, 
        Decimal weight, 
        Decimal powerGenerated, 
        String recordTypeDeveloperName
    ) {
        this.prodid = id;
        this.productName = name;
        this.serialNumber = serialNumber;
        this.description = description;
        this.countryOfOrigin = countryOfOrigin;
        this.averageLifeExpectancy = averageLifeExpectancy;
        this.image = image;
        this.size = size;
        this.phase = phase;
        this.engineType = engineType;
        this.weight = weight;
        this.powerGenerated = powerGenerated;
        this.recordTypeDeveloperName = recordTypeDeveloperName;
    }
}

}