public class ETT_DeliverLineItemTriggerHandler {
    
    public static void updateTyreInventoryStatus(List<ETT_Delivery_Line_Item__c> newList) {
        List<ETT_Tyre_Inventory__c> tyreInvList = new List<ETT_Tyre_Inventory__c>();
        Set<Id> collectionCardIds = new Set<Id>();
        Set<Id> insCardIds = new Set<Id>();
        for(ETT_Delivery_Line_Item__c dnl: [SELECT Id,ETT_Inspection_Card__c FROM ETT_Delivery_Line_Item__c WHERE Id In: newList]){
            insCardIds.add(dnl.ETT_Inspection_Card__c);
        }
        
        if(!insCardIds.isEmpty()){
            for(ETT_Tyre_Inventory__c ti : [SELECT Id, ETT_Status_TI__c,ETT_Tyre_Inspection_Card__c FROM ETT_Tyre_Inventory__c WHERE ETT_Tyre_Inspection_Card__c In:insCardIds ]){
                ti.ETT_Status_TI__c = 'Delivery Note Created';
                ti.ETT_Status_Changed_On__c= system.now();
                tyreInvList.add(ti);
            }
        }
        if(!tyreInvList.isEmpty()){
            update tyreInvList;
        }
    }
    
    
}