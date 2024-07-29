trigger ETT_TyreInventoryTrg on ETT_Tyre_Inventory__c (before insert,before update,after update,after insert,After Delete,After Undelete) {
    
    if(trigger.isAfter) {
        ETT_TyreInventoryTrgHandler.createInspectionCards(trigger.New, trigger.OldMap);
    }
    
    if(trigger.isBefore){
        
        if(trigger.isInsert){
            ETT_TyreInventoryTrgHandler.updatePriceInfoOnInsert(trigger.new);
            
        }
        if(trigger.isUpdate){
             ETT_TyreInventoryTrgHandler.updatePriceInUpdate(trigger.newMap,Trigger.oldMap);
        }
    }
    
    //Calculating tyre count and updating on Collection Card
    if(trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete || Trigger.isDelete)){
       ETT_TyreInventoryTrgHandler.updateCollCard(trigger.new, trigger.oldMap);
    }
 

}