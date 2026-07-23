public with sharing class AutoCaseFieldAssignTriggerHandler extends TriggerHandler implements ITriggerHandler{
    
    private Map<Id, Case> newMap;
    private Map<Id, Case> oldMap;
    private List<Case> TriggerNew;
    private List<Case> TriggerOld; 
    
    public AutoCaseFieldAssignTriggerHandler() {
        this.newMap = (Map<Id, Case>) Trigger.newMap;
        this.oldMap = (Map<Id, Case>) Trigger.oldMap;
        this.TriggerNew = (List<Case>) Trigger.New;
        this.TriggerOld = (List<Case>) Trigger.Old;
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
        AutoCaseFieldAssign.assignFields(this.TriggerNew);

    }
    public override void beforeUpdate() {
        
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