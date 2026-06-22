public with sharing class ResourceReservationTriggerHandler extends TriggerHandler implements ITriggerHandler{

    private Map<Id, Resource_reservation__c> newMap;
    private Map<Id, Resource_reservation__c> oldMap;
    private List<Resource_reservation__c> TriggerNew;
    private List<Resource_reservation__c> TriggerOld;
    
    public ResourceReservationTriggerHandler(){
        this.newMap = (Map<Id, Resource_reservation__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Resource_reservation__c>) Trigger.oldMap;
        this.TriggerNew= (List<Resource_reservation__c>) Trigger.New;
        this.TriggerOld= (List<Resource_reservation__c>) Trigger.Old;
    }
    
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
        ResourceReservation.checkReservation(TriggerNew,oldMap);
    }

    public override void afterInsert() {
        
    }

    public  override void beforeUpdate() {
         ResourceReservation.checkReservation(TriggerNew,oldMap);
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