trigger ETT_MaterialReturnNoteTrigger on ETT_Material_Return_Note__c (after update) {
    
    if(Trigger.isAfter && trigger.isupdate){ 
        if(ETT_MaterialReturnNoteTriggerHandler.firstRun){            
            ETT_MaterialReturnNoteTriggerHandler.OracleHelper(trigger.new);
            ETT_MaterialReturnNoteTriggerHandler.firstRun=false;
        } 
    }
}