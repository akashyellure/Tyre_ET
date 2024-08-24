trigger ETT_JobCardCloseTrg on ETT_Job_Card_Close__c (after Update) {
    if (Trigger.isUpdate) {

        for(ETT_Job_Card_Close__c objJCC : trigger.New){
           
            Map<String, Object> flowInputs = new Map<String, Object>();
            flowInputs.put('recordId', objJCC.Id);
            // Call the Flow
            Flow.Interview.Update_Status_of_Job_card_flow flow = new Flow.Interview.Update_Status_of_Job_card_flow(flowInputs);
            flow.start();
            if(!ETT_JobCardCloseTrgHelper.alreadyProcessed.contains(objJCC.Id) && objJCC.Status__c != trigger.oldMap.get(objJCC.Id).Status__c && objJCC.Status__c == 'Approved'){
                ETT_JobCardCloseTrgHelper.updateToolsItemMaster(trigger.NewMap,trigger.OldMap);
                
                if(objJCC.Job_Type__c == 'Tyre - Internal' || objJCC.Job_Type__c == 'Tyre Supplier' || objJCC.Job_Type__c=='Tyre - Internal Private'){
                    ETT_JobCardCloseTrgHelper.createMRInOracle(objJCC.Id);
                }
                else if(objJCC.Party_Type__c == 'Customer' ){
                    ETT_JobCardCloseTrgHelper.createJCCLinesInOracle(objJCC.Id,objJCC.createdDate,objJCC.Name);
                }
            }
        }
    }
}