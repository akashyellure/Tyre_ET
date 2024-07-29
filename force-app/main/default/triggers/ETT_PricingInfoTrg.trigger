trigger ETT_PricingInfoTrg on ETT_Pricing_Information__c (before insert) {
    
    ETT_PricingInfoTrgHelper.duplicationCheck(trigger.new);

}