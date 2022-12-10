trigger ContactObjectTrigger on Contact (before update, before insert) {
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            if(RecursiveFixer.firstRun){
                RecursiveFixer.firstRun = false;
                PrimaryContactValidationForUpdate.validationMethodForUpdate(Trigger.newMap, Trigger.oldMap);
                UpdatePrimaryContactTriggerHandler.updateContactWithPrimaryPhone(Trigger.newMap, Trigger.oldMap);
            }
        }
        else if(Trigger.isInsert){
            if(RecursiveFixer.firstRun){
                RecursiveFixer.firstRun = false;
                PrimaryContactValidationForInsert.validationMethodForInsert(Trigger.new);
                InsertPrimaryContactTriggerHandler.insertContactWithPrimaryPhone(Trigger.new);
            }
        }
    }
}