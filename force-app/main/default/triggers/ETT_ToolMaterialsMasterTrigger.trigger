trigger ETT_ToolMaterialsMasterTrigger on ETT_Tools_Master__c (before update,after update) {
   if(Trigger.isAfter){
       ETT_ToolMaterialsMasterTriggerUtility.postProcessingAllocation(Trigger.new,Trigger.oldMap);
   }
   if(Trigger.isBefore){
       ETT_ToolMaterialsMasterTriggerUtility.preProcessingAllocation(Trigger.new,Trigger.oldMap);
   }
}