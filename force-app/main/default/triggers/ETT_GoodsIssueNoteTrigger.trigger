trigger ETT_GoodsIssueNoteTrigger on ETT_Goods_Issue_Note__c (after update) {
    
    if(Trigger.isAfter && trigger.isupdate){
        if(ETT_GoodsIssueNoteTriggerHandler.firstRun){            
            ETT_GoodsIssueNoteTriggerHandler.OracleHelper(trigger.newMap,trigger.old);
            ETT_GoodsIssueNoteTriggerHandler.updatequantityintoolmaster(trigger.New,Trigger.Oldmap);
            ETT_GoodsIssueNoteTriggerHandler.firstRun=false;
        } 
    }
}