public with sharing class OppDetailsPDFTriggerHandler extends TriggerHandler implements ITriggerHandler{
    
    private Map<Id, Opportunity> newMap;
    private Map<Id, Opportunity> oldMap;
    private List<Opportunity> TriggerNew;
    private List<Opportunity> TriggerOld;
    
    public OppDetailsPDFTriggerHandler() {
        this.newMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.oldMap = (Map<Id, Opportunity>) Trigger.oldMap;
        this.TriggerNew = (List<Opportunity>) Trigger.New;
        this.TriggerOld = (List<Opportunity>) Trigger.Old;
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

    }
    public override void beforeUpdate() {

    }
    public override void afterUpdate() {
        OppDetailsPDF.sendEmail(TriggerNew, oldMap);
        
    }
    public override void beforeDelete() {

    }
    public override void afterDelete() {

    }
    public override void afterUnDelete() {

    }
}