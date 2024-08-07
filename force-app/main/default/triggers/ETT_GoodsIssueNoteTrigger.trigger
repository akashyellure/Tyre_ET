trigger ETT_GoodsIssueNoteTrigger on ETT_Goods_Issue_Note__c (after update) {
    // Ensure the trigger runs only after an update
    if (Trigger.isAfter && Trigger.isUpdate) {
        // Check if it's the first run to prevent recursive calls
        if (ETT_GoodsIssueNoteTriggerHandler.firstRun) {            
            // Call OracleHelper method
            ETT_GoodsIssueNoteTriggerHandler.OracleHelper(trigger.newMap,trigger.old);

            // Iterate through the updated records to check if the status is updated to "Success"
            for (ETT_Goods_Issue_Note__c newRecord : Trigger.new) {
                ETT_Goods_Issue_Note__c oldRecord = Trigger.oldMap.get(newRecord.Id);
                System.debug('Records'+newRecord.Misc_Issue_Status__c);
              

                // If the status is updated to "Success", call the updatequantityintoolmaster method
                if (newRecord.Misc_Issue_Status__c == 'Success' && oldRecord.Misc_Issue_Status__c != 'Success') {
                   ETT_GoodsIssueNoteTriggerHandler.updatequantityintoolmaster(trigger.New,Trigger.Oldmap);
                  
                    break; // Exit the loop after the first "Success" is found
                }
            }

            // Set firstRun to false to prevent recursive trigger calls
            ETT_GoodsIssueNoteTriggerHandler.firstRun = false;
        } 
    }
}
