public with sharing class OpportunityController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesByAccount(Id accountId) {
        if (accountId == null) {
            return new List<Opportunity>();
        }
        return [SELECT Id, Name 
                FROM Opportunity 
                WHERE AccountId = :accountId];
    }
}
