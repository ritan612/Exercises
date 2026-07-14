@isTest
private class CompanyInfo_Test {

    @isTest
    static void testLeadProcess() {
        Lead testLead = new Lead(
            LastName = 'Nassar',
            Company = 'Google',
            Website = 'https://www.google.com',
            Country = 'United States'
        );
        insert testLead;

        Test.setMock(HttpCalloutMock.class, new CompanyInfoMock());

        Test.startTest();
        CompanyInfo.processLead(new List<Lead>{testLead}, null);
        Test.stopTest();

        Lead updatedLead = [SELECT NumberOfEmployees, Company_Biography__c, Company_Logo__c, Foundation_date__c, Street, City, StateCode, PostalCode, Country  FROM Lead WHERE Id = :testLead.Id];
        
        System.assertEquals(156500, updatedLead.NumberOfEmployees);
        System.assertEquals('This is a default description.', updatedLead.Company_Biography__c);
        System.assertEquals('https://logos-marques.com/wp-content/uploads/2021/03/Nouveau-logo-Google-500x313.png', updatedLead.Company_Logo__c);
        System.assertEquals(Date.newInstance(1998, 9, 4), updatedLead.Foundation_date__c);
        System.assertEquals('United States', updatedLead.Country);
        System.assertEquals('1600 Amphitheatre Parkway', updatedLead.Street);
        System.assertEquals('Mountain View', updatedLead.City);
        System.assertEquals('CA', updatedLead.StateCode);
        System.assertEquals('94043', updatedLead.PostalCode);
        
    }
}