@isTest
public class TestUtils {

    public static Lead createLead(String LName,String Comp ,String Web ,String Cntry, Boolean doInsert) {
        Lead testlead = new Lead(
            LastName = LName,
            Company = Comp,
            Website = Web,
            Country = Cntry);
        
        
        if(doInsert) {
            insert testlead;
        }
        return testLead;
    }
    
    public static User createUser(String lastName, String email) {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(
            LastName = lastName,
            Email = email,
            Username = email + '.testuser',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        insert u;
        return u;
    }

    public static Opportunity createOpportunity(String name, String stageName) {
        Opportunity opp = new Opportunity(
            Name = name,
            StageName = stageName,
            CloseDate = Date.today().addDays(10)
        );
        insert opp;
        return opp;
    }

    public static OpportunityTeamMember createTeamMember(Id oppId, Id userId, String role) {
        OpportunityTeamMember otm = new OpportunityTeamMember(
            OpportunityId = oppId,
            UserId = userId,
            TeamMemberRole = role
        );
        insert otm;
        return otm;
    }
    
    
    public static Product2 createProduct(String name, String country, String serialNum, Decimal lifeExpectancy) {
        Product2 prod = new Product2(
            Name = name,
            Country_Of_Origin__c = country,
            Serial_Number__c = serialNum,
            Average_Life_Expectancy__c = lifeExpectancy,
            IsActive = true
        );
        insert prod;
        return prod;
    }
    
    public static ContentVersion createContentVersion(String title, String pathOnClient, Blob fileData) {
        ContentVersion cv = new ContentVersion(
            Title = title,
            PathOnClient = pathOnClient,
            VersionData = fileData,
            IsMajorVersion = true
        );
        insert cv;
        return cv;
    }

    public static ContentDocumentLink createContentDocumentLink(Id contentDocumentId, Id linkedEntityId) {
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = contentDocumentId,
            LinkedEntityId = linkedEntityId,
            ShareType = 'V'
        );
        insert cdl;
        return cdl;
    }

    public static Pricebook2 createB2CPricebook() {
        Pricebook2 pb = new Pricebook2(
            Name = 'Test B2C Pricebook',
            IsActive = true
        );
        insert pb;
        return pb;
    }

    public static void createPricebookEntry(Id pricebookId, Id productId, Decimal unitPrice) {
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = productId,
            UnitPrice = unitPrice,
            IsActive = true
        );
        insert pbe;
    }

    public static Account createAccount(String name, String phone, String recordType) {
        
        Account acc = new Account(
            Name = name,
            Phone = phone,
            RecordTypeId = recordType
        );
        insert acc;
        return acc;
    }

    public static Account createPersonAccount(String firstname, String lastname, String email) {
        Account acc = new Account(
            FirstName = firstname,
            LastName = lastname,
            PersonEmail = email,
            RecordTypeId = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('B2C_Customer')
            .getRecordTypeId()

        );
        insert acc;
        return acc;
    }
    
     public static Contact createContact(String firstname, String lastname, String email) {
        Contact con = new Contact(
            FirstName = firstname,
            LastName = lastname,
            Email = email
        );
        insert con;
        return con;
    }
}