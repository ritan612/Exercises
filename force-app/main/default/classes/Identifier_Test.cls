@isTest
public class Identifier_Test {
    @isTest
    static void testGenerateOfferIdentifiers(){
        Opportunity opp1=new Opportunity( Name ='Test1', StageName ='Prospecting', CloseDate = Date.today().addDays(10), Identifier__c ='EIT' );

        Opportunity opp2=new Opportunity( Name ='Test2', StageName ='Prospecting', CloseDate = Date.today().addDays(10), Identifier__c ='ABC' );

        insert new List<Opportunity>{opp1, opp2};
        
        List<Offer__c> bulkOffers = new List<Offer__c>();

        Offer__c offer1 = new Offer__c(Name = 'Offer 1', Opportunity__c = opp1.Id);
        Offer__c offer2 = new Offer__c(Name = 'Offer 2', Opportunity__c = opp1.Id);
        
        bulkOffers.add(offer1);
        bulkOffers.add(offer2);

        insert bulkOffers;

        List<Offer__c> insertedOffers = [
            SELECT Id, Identifier__c, Opportunity__c 
            FROM Offer__c 
            WHERE Id IN :bulkOffers 
            ORDER BY Name ASC
        ];

        System.assertEquals('EIT-000', insertedOffers[0].Identifier__c, 'The first offer should start at 000');
        System.assertEquals('EIT-001', insertedOffers[1].Identifier__c, 'The second offer should increment to 001');

        Offer__c offerToUpdate = insertedOffers[1];
        offerToUpdate.Opportunity__c = opp2.Id;
        
        update offerToUpdate;

        Offer__c updatedOffer = [
            SELECT Id, Identifier__c 
            FROM Offer__c 
            WHERE Id = :offerToUpdate.Id
        ];

        System.assertEquals('ABC-000', updatedOffer.Identifier__c, 'The offer identifier should recalculate when changed to a new opportunity');
    }
}