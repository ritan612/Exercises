trigger OpportunityPdfDetails on Opportunity (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new OppDetailsPDFTriggerHandler().run();
}