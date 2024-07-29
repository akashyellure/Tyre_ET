/*
Created By:Shweta Shinde
Created Date:09/29/2020
Description :This is for Collection Card Process 
*/
trigger ETT_CollectionCardTrg on ETT_Collection_Card__c (After update) {
    if(trigger.isAfter && trigger.isUpdate) {
        List<ETT_ORG_Setting__mdt> ettOrgSettingLst = [SELECT MasterLabel,DeveloperName FROM ETT_ORG_Setting__mdt where MasterLabel=:UserInfo.getProfileId()];
        if(ettOrgSettingLst!=null && ettOrgSettingLst.size()>0 && ETT_CollectionCardTriggerHandler.isInspectionRecursive){
            //ETT_CollectionCardTriggerHandler.colletionCardHandlerAfterUpdate(trigger.newmap,trigger.oldmap);
        }
        Map<ID, Schema.RecordTypeInfo> ccRtMap = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosById();
        List<ETT_Collection_Card__c> ccNotificationToSend = new List<ETT_Collection_Card__c>();
        List<ETT_Collection_Card__c> ccNotificationToConfirmMO = new List<ETT_Collection_Card__c>();
        for (ETT_Collection_Card__c objCC : Trigger.new) {
            ETT_Collection_Card__c oldCC = Trigger.oldMap.get(objCC.ID);
            if(objCC.ETT_Create_Job_Card__c!=oldCC.ETT_Create_Job_Card__c && objCC.ETT_Create_Job_Card__c==true){
                ETT_CollectionCardTriggerHandler.createJobCard(trigger.newmap,trigger.oldmap);
            }else if(objCC.ETT_Inspection_Done__c!=oldCC.ETT_Inspection_Done__c && objCC.ETT_Inspection_Done__c==true && objCC.ETT_Create_Job_Card__c == true){
                ETT_CollectionCardTriggerHandler.createJobCard(trigger.newmap,trigger.oldmap);
            }
            System.debug(objCC.ETT_Check_Out__c+' <<< >>> '+objCC.Move_Order_Status__c	+' <<< >>> '+ccRtMap.get(objCC.RecordTypeId).getDeveloperName()+' <<< >>> ');
            if(objCC.Move_Order_Status__c	 == 'Confirmed' && objCC.Move_Order_Status__c	 != oldCC.Move_Order_Status__c	 && ccRtMap.get(objCC.RecordTypeId).getDeveloperName() == 'ETT_Tyre_Internal'){
                System.debug('createMoveOrderInOracle');
                ccNotificationToSend.add(objCC);
                ETT_CollectionCardTriggerHandler.createMoveOrderInOracle(objCC.Id);
            }
            if(objCC.ETT_Collection_Status__c == 'Inspection Completed' && objCC.ETT_Collection_Status__c != oldCC.ETT_Collection_Status__c && ccRtMap.get(objCC.RecordTypeId).getDeveloperName() == 'ETT_Tyre_Internal'){
                System.debug('createMRInOracle');
                ETT_CollectionCardTriggerHandler.createMRInOracle(objCC.Id,objCC.CreatedDate,objCC.Name);
            }
            /*if(objCC.Move_Order_Status__c != null && objCC.Move_Order_Status__c != oldCC.Move_Order_Status__c && objCC.Move_Order_Status__c == 'Confirmed' && ccRtMap.get(objCC.RecordTypeId).getDeveloperName() == 'ETT_Tyre_Internal'){
                System.debug('Notification');
                ccNotificationToSend.add(objCC);
                //ETT_CollectionCardTriggerHandler.sendMOConfirmedNotification(objCC.Id,objCC.CreatedDate,objCC.Name);
            }*/
            /*if(objCC.MO_EBS_Ref_No__c != null && objCC.MO_EBS_Ref_No__c != oldCC.MO_EBS_Ref_No__c && ccRtMap.get(objCC.RecordTypeId).getDeveloperName() == 'ETT_Tyre_Internal'){
                System.debug('Notification');
                ccNotificationToConfirmMO.add(objCC);
            }*/
        }
        if(!ccNotificationToSend.isEmpty()){
            ETT_CollectionCardTriggerHandler.sendMOConfirmedNotification(ccNotificationToSend);
        }
        /*if(!ccNotificationToConfirmMO.isEmpty()){
            ETT_CollectionCardTriggerHandler.sendNotificationToConfirmMO(ccNotificationToConfirmMO);
        }*/
    }
}