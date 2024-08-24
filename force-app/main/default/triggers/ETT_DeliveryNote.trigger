trigger ETT_DeliveryNote on ETT_Delivery_Note__c (before insert, after Update) {
    /*if(trigger.isBefore && trigger.isInsert){
        for(ETT_Delivery_Note__c objDN : trigger.New){
            if(!ETT_DeliveryNoteTriggerHandler.alreadyProcessed.contains(objDN.Id)){
                ETT_DeliveryNoteTriggerHandler.createARInOracle(objDN.Id);
            }
        }
    }*/
    if(trigger.isAfter && trigger.isUpdate){
        for(ETT_Delivery_Note__c objDN : trigger.New){
            if(!ETT_DeliveryNoteTriggerHandler.alreadyProcessed.contains(objDN.Id) && objDN.DN_Status__c != trigger.oldMap.get(objDN.Id).DN_Status__c && objDN.DN_Status__c == 'Approved'){
                if(objDN.Party_Type__c == 'Internal' && objDN.SubInventory__c != null){
                    System.debug('Internal');
                    ETT_DeliveryNoteTriggerHandler.createDNLinesInOracle(objDN.Id,objDN.ETT_Date__c,objDN.Name);
                }
                if(objDN.Party_Type__c == 'Customer' && objDN.ETT_Account__c != null){
                    System.debug('Customer');
                    ETT_DeliveryNoteTriggerHandler.createARInOracle(objDN.Id);
                }
            }
        }
    }
}