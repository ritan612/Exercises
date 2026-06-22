trigger IdentifierTrigger on Offer__c (before insert, before update) {
    new IdentifierTriggerHandler().run();
}