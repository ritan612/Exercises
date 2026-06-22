public with sharing class IdentifierTriggerHandler extends TriggerHandler implements ITriggerHandler{

    private Map<Id, Offer__C> newMap;
    private Map<Id, Offer__c> oldMap;
    private List<Offer__c> TriggerNew;
    private List<Offer__c> TriggerOld;
    
    public IdentifierTriggerHandler(){
        this.newMap = (Map<Id, Offer__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Offer__c>) Trigger.oldMap;
        this.TriggerNew= (List<Offer__c>) Trigger.New;
        this.TriggerOld= (List<Offer__c>) Trigger.Old;
    }
    
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
        Identifier.generateOfferIdentifiers(TriggerNew,oldMap);
    }
    public override void afterInsert() {
        
    }
    public  override void beforeUpdate() {
        Identifier.generateOfferIdentifiers(TriggerNew,oldMap);
    }
    public override void afterUpdate() {

    }
    
    public override void beforeDelete() {
        
    }
    
    public override void afterDelete() {
        
    }
    
    public override void afterUnDelete() {
        
    }
}