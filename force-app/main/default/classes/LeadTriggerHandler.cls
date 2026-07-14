public with sharing class LeadTriggerHandler extends TriggerHandler implements ITriggerHandler{

    private Map<Id, Lead> newMap;
    private Map<Id, Lead> oldMap;
    private List<Lead> TriggerNew;
    private List<Lead> TriggerOld;

    public LeadTriggerHandler(){
        this.newMap = (Map<Id, Lead>) Trigger.newMap;
        this.oldMap = (Map<Id, Lead>) Trigger.oldMap;
        this.TriggerNew = (List<Lead>) Trigger.New;
        this.TriggerOld = (List<Lead>) Trigger.Old;
    }

    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;

    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }

    public override void beforeInsert() {

    }
    public override void afterInsert() {
        CompanyInfo.processLead(TriggerNew, oldMap);
    }
    public override void beforeUpdate() {

    }
    public override void afterUpdate() {
        CompanyInfo.processLead(TriggerNew, oldMap);
    }
    public override void beforeDelete() {

    }
    public override void afterDelete() {

    }
    public override void afterUnDelete() {

    }
}