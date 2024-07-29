/**
 * Created By: Janardhan Muddana
 * Created Date:25/02/2022
 * Description :
 * 
 * */
trigger ETT_TyreInspectionCardTrg on ETT_Inspection_Card__c (after Update) {
    
    ETT_TyreInspectionCardTrgHandler.InspectionConfirmationUpdate(trigger.NewMap,trigger.oldMap);

}