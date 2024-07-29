trigger ETT_StagNewTyreCollTrg on ETT_StagingNewTyreCollection__c (before insert,before update) {
    
    if(trigger.isInsert){
        ETT_StagNewTyreCollTrgHandler.createPricingInfoAndOthers(trigger.new);
    }
    
}