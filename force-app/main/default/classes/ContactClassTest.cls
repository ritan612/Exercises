@isTest
public class ContactClassTest {

    @testSetup
    static void setupData() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        List<Contact> testContacts = new List<Contact>{
            new Contact(LastName = 'Smith', AccountId = acc.Id),
            new Contact(FirstName = null, LastName = 'Doe', AccountId = acc.Id),
            new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id)
        };
        insert testContacts;
    }

    @isTest
    public static void verifyBulkContacts() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        List<Contact> existingContacts = [SELECT Id, FirstName, LastName FROM Contact WHERE AccountId = :acc.Id];

        Test.startTest();
        
        List<Contact> contactsToInsert = new List<Contact>();
        contactsToInsert.add(new Contact(LastName = 'Smith', AccountId = acc.Id ));
        insert contactsToInsert;

        existingContacts[1].FirstName = 'Jane'; 
        update existingContacts[1];

        Test.stopTest();
    }
}