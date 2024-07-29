trigger ETT_JobCardTrigger on ETT_Job_Card__c (after insert, after update) {
    
    if(Trigger.isAfter && trigger.isInsert){
        if(ETT_JobCardTrgHandler.firstRun){ 
            ETT_JobCardTrgHandler.OracleHelper(trigger.newMap);
            ETT_JobCardTrgHandler.firstRun=false;
        } 
    }
    if(trigger.isAfter && trigger.isUpdate){ 
        ETT_JobCardTrgHandler.afterUpdate(trigger.new, trigger.oldMap);
    }
    
}