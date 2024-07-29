trigger ETT_ToolMaterialAllocationTrigger on ETT_Tools_Allocation__c (before insert,before update,after insert,after update) {
   if(Trigger.isAfter){
       ETT_ToolMaterialsMasterTriggerUtility.postProcessingAllocation(Trigger.new,Trigger.oldMap);
   }
   if(Trigger.isBefore){
       ETT_ToolMaterialsMasterTriggerUtility.preProcessingAllocation(Trigger.new,Trigger.oldMap);
   }
}