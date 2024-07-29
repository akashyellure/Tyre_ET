/*
  Created By:Shweta Shinde
  Created Date:03/27/2020
  Description :This is for Job Card Process 
*/
trigger ETT_JobCardTrg on ETT_Job_Card__c (before insert,before update,after update) {
    /*List<ETT_ORG_Setting__mdt> ettOrgSettingLst = [SELECT MasterLabel,DeveloperName FROM ETT_ORG_Setting__mdt where MasterLabel=:UserInfo.getProfileId()];
    if(ettOrgSettingLst!=null && ettOrgSettingLst.size()>0 && ETT_JobCardTriggerHandler.isFinshedInventories)
    ETT_JobCardTriggerHandler.jobCardFinishedInventoriesDetailsUpdate(trigger.newmap,trigger.oldmap); Kumaresan commented*/
    
    //Added by Kumaresan
    if(Trigger.isBefore){
        ETT_JobCardTriggerHandler.preProcessingOperation(Trigger.new,Trigger.oldMap);
    }
    if(Trigger.isAfter){
        ETT_JobCardTriggerHandler.postProcessingLogic(Trigger.new,Trigger.oldMap);
    }
}