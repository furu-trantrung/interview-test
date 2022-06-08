trigger ContactTrigger on Contact (before insert, after insert, before update, after update, before delete, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            ContactTriggerHandler.handleAfterUpdate(Trigger.OldMap, Trigger.New);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ContactTriggerHandler.handleAfterInsert(Trigger.New);
        }
        if(Trigger.isDelete){
            ContactTriggerHandler.handleAfterDelete(Trigger.Old);
        }
    }
}