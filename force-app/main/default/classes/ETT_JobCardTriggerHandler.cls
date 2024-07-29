/*
Created By   :G.Krishnareddy
Created Date :27/03/2020
Description  :This is for Finshed Inventories Process and Collection Card and Work Order Status completion update.
*/
public class ETT_JobCardTriggerHandler {
    
    public static boolean isFinshedInventories = true;
    public static boolean isSobjStatusUpdate = true;
    
    //Bulkify for Finshed Invetories Process for Job Card Painting Stage
    public static void jobCardFinishedInventoriesDetailsUpdate(map<Id,ETT_Job_Card__c> mapOfNewJobCards,map<Id,ETT_Job_Card__c> mapOfOldJobCards){
        /*Kumaresan commented since not linked to JC 
        
        //This is Intialization of the Job Card Ids for the Painiting Stage
        set<Id> setOfJobCardIds = new set<Id>();  
        set<Id> setOfCollectionCardIds = new set<Id>();
        set<Id> setOfExstingJobCardsMatchCollectionCards = new set<Id>();
        //This is for Status Update for Collection Card,Work Order and Opportunity stages
        list<Sobject> lstSobjectStatusUpdates = new list<Sobject>();
        map<Id,list<ETT_WIP_Inventory__c>> mapOfJobCardIdswithWIPInvetories = new map<Id,list<ETT_WIP_Inventory__c>>();
        list<ETT_Finished_Inventory__c> lstFinishedInvetories = new list<ETT_Finished_Inventory__c>();
        list<ETT_Apex_Error_log__c> lstETTErrorLog = new list<ETT_Apex_Error_log__c>();
        //Collection Card with Job Card Count Details
        Map<Id,Integer> mapOfCollectionCardVSJobCardsCount = new map<Id,Integer>();
        map<Id,ETT_Finished_Inventory__c> mapOfJobCardwithFinishedInventory = new map<Id,ETT_Finished_Inventory__c>();
        //Exsting Job Card with Finished Invetories
        for(ETT_Finished_Inventory__c objFinishedInvetory :[Select Id,ETT_WIP_Inventory__r.ETT_Job_Card__c from ETT_Finished_Inventory__c where ETT_WIP_Inventory__r.ETT_Job_Card__c in : mapOfNewJobCards.keyset()]){
            mapOfJobCardwithFinishedInventory.put(objFinishedInvetory.ETT_WIP_Inventory__r.ETT_Job_Card__c,objFinishedInvetory);
        }

        //This is Preparation of the Job Card Ids for the Painiting Stage
        for(ETT_Job_Card__c objJobCard :[Select Id,ETT_Job_Stages__c,ETT_Painting_End_Time__c,ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c from ETT_Job_Card__c where id in :mapOfNewJobCards.values()]){ //RecordTypeId removed
            
            //String recordtypename = Schema.SObjectType.ETT_Job_Card__c.getRecordTypeInfosById().get(objJobCard.RecordTypeId).getname();
            String recordtypename='';
            System.debug('objJobCard.ETT_Job_Stages__c  : '+objJobCard.ETT_Job_Stages__c    );
            System.debug('mapOfOldJobCards.get(objJobCard.Id).ETT_Job_Stages__c  : '+mapOfOldJobCards.get(objJobCard.Id).ETT_Job_Stages__c  );

            //added by shweta on 9th Sept START
            if(objJobCard.ETT_Job_Stages__c =='Painting' && recordtypename=='Painting' && objJobCard.ETT_Painting_End_Time__c != null && objJobCard.ETT_Painting_End_Time__c!=mapOfOldJobCards.get(objJobCard.Id).ETT_Painting_End_Time__c){
                
                ETT_Tyre_Inventory__c objTyreInventory = [SELECT Id, ETT_Job_Card__c FROM ETT_Tyre_Inventory__c where ETT_Job_Card__c=:objJobCard.Id limit 1];
                objTyreInventory.ETT_Inventory_Status__c = 'Finished';
                update objTyreInventory;
                
                
                //added by shweta on 23rd Sept START

                ETT_Inspection_Card__c objInspectionCard = [SELECT Id, ETT_Collection_Card__c FROM ETT_Inspection_Card__c where Id=:objJobCard.ETT_Inspection_Card__c];                
                list<AggregateResult> lstAggregrateResult = [select count(id) inspectionCount,ETT_Status__c status from ETT_Inspection_Card__c where ETT_Collection_Card__c =:objInspectionCard.ETT_Collection_Card__c group by ETT_Status__c];
                
                Integer acceptedCount =0;
                Integer sendBackCount =0;
                Integer notInspected  =0;
                Integer totalCount=0;
                if(lstAggregrateResult!=null && lstAggregrateResult.size()>0){
                    for(AggregateResult objAggregreateResult :lstAggregrateResult){
                        string strStatus =(string)objAggregreateResult.get('status');
                        if(strStatus=='Accept'){
                            acceptedCount++;
                        }else if(strStatus=='Send Back'){
                            sendBackCount++;
                        }else{
                            notInspected++;
                        }
                        totalCount++;
                    }
                }                
                
                list<AggregateResult> lstAggregrateResultJobCard = [SELECT count(Id) countofJobCards, ETT_Job_Stages__c
                                                             FROM ETT_Job_Card__c where  ETT_Job_Stages__c = 'Painting' and ETT_Inspection_Card__r.ETT_Collection_Card__c = :objInspectionCard.ETT_Collection_Card__c group by ETT_Job_Stages__c];
                
                if(lstAggregrateResultJobCard!=null && lstAggregrateResultJobCard.size()>0){
                    
                    if(notInspected==0 && totalCount==(sendBackCount+acceptedCount) && totalCount==lstAggregrateResultJobCard.size()){
                        ETT_Collection_Card__c objCollectionCard = new ETT_Collection_Card__c();
                        objCollectionCard.Id =  objInspectionCard.ETT_Collection_Card__c;
                        objCollectionCard.ETT_Job_Card_Done__c = true; 
                        update objCollectionCard;
                    }
                }
                
                //added by shweta on 23rd Sept START
                
                
                
            }
            //added by shweta on 9th Sept STOP
                        
            if(objJobCard.ETT_Job_Stages__c =='Painting' && recordtypename=='Painting' && objJobCard.ETT_Painting_End_Time__c != null && objJobCard.ETT_Painting_End_Time__c!=mapOfOldJobCards.get(objJobCard.Id).ETT_Painting_End_Time__c){
                if(mapOfJobCardwithFinishedInventory!=null && mapOfJobCardwithFinishedInventory.containsKey(objJobCard.Id)){
                    continue;
                }else{
                    setOfJobCardIds.add(objJobCard.Id);
                    setOfCollectionCardIds.add(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c);
                }
             }
        }
        System.debug('*************************');
        System.debug(setOfJobCardIds);
        System.debug(setOfCollectionCardIds);        
        
        //Exsting Job Card Details based on existing Collection Card
        if(setOfCollectionCardIds!=null && setOfCollectionCardIds.size()>0){
            AggregateResult[] lstAggregrateJobCardResults = [select count(Id) countOfJobCards,ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c collectionCardDetails from ETT_Job_Card__c where  ETT_Job_Stages__c='Painting' and ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c in :setOfCollectionCardIds  Group by ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c];
            if(lstAggregrateJobCardResults!=null && lstAggregrateJobCardResults.size()>0) {
                for(AggregateResult objAggregrateResult :lstAggregrateJobCardResults){
                    mapOfCollectionCardVSJobCardsCount.put((Id)objAggregrateResult.get('collectionCardDetails'),(Integer)objAggregrateResult.get('countOfJobCards'));
                }
            }
        }
        
        
        //Job Card VS WIP Invetory Preparation
        if(setOfJobCardIds!=null && setOfJobCardIds.size()>0){
            for(ETT_WIP_Inventory__c objWIPInvetory :[Select Id,ETT_Job_Card__c from ETT_WIP_Inventory__c where ETT_Job_Card__c in :setOfJobCardIds]){
                if(mapOfJobCardIdswithWIPInvetories.containsKey(objWIPInvetory.ETT_Job_Card__c)){
                    mapOfJobCardIdswithWIPInvetories.get(objWIPInvetory.ETT_Job_Card__c).add(objWIPInvetory);
                }else{
                    mapOfJobCardIdswithWIPInvetories.put(objWIPInvetory.ETT_Job_Card__c,new list<ETT_WIP_Inventory__c>{objWIPInvetory});
                }
            } 
            
            system.debug('****mapOfJobCardIdswithWIPInvetories****'+mapOfJobCardIdswithWIPInvetories);
            
            //Finished Invetories Preparation
            for(ETT_Job_Card__c objJobCard :[Select Id,ETT_Painting_End_Time__c,ETT_Job_Stages__c,ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c,ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount from ETT_Job_Card__c where id in :mapOfNewJobCards.values()]){//RecordTypeId removed
                //String recordtypename = Schema.SObjectType.ETT_Job_Card__c.getRecordTypeInfosById().get(objJobCard.RecordTypeId).getname();
                String recordtypename='';
                if(objJobCard.ETT_Painting_End_Time__c!=mapOfOldJobCards.get(objJobCard.Id).ETT_Painting_End_Time__c && objJobCard.ETT_Job_Stages__c=='Painting' && recordtypename=='Painting'){
                    if(mapOfCollectionCardVSJobCardsCount.containsKey(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c)){
                        //Process for Collection Card and Work Order and Opportunity Closed Stages
                        system.debug('*****WorkOrderCount****'+objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount);
                        system.debug('*****JobCardCount****'+mapOfCollectionCardVSJobCardsCount.get(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c));

                        if(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount==1 && mapOfCollectionCardVSJobCardsCount.get(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c)==(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount)){
                            setOfExstingJobCardsMatchCollectionCards.add(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c );
                        }else if(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount>1 && mapOfCollectionCardVSJobCardsCount.get(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c)==(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount-1)){
                            setOfExstingJobCardsMatchCollectionCards.add(objJobCard.ETT_Inspection_Card__r.ETT_Collection_Line_Item__r.ETT_Collection_Card__c);   
                        }
                        
                        
                     
                    }
                    if(mapOfJobCardIdswithWIPInvetories.containsKey(objJobCard.Id)){
                        if(mapOfJobCardIdswithWIPInvetories.get(objJobCard.Id)!=null && mapOfJobCardIdswithWIPInvetories.get(objJobCard.Id).size()>0){
                            //Finished Inventory Preparation 
                            for(ETT_WIP_Inventory__c objWIPInventory :mapOfJobCardIdswithWIPInvetories.get(objJobCard.Id)){
                                ETT_Finished_Inventory__c objFinishedInventory = new ETT_Finished_Inventory__c();
                                objFinishedInventory.ETT_WIP_Inventory__c = objWIPInventory.Id;
                                objFinishedInventory.ETT_Job_Card__c      = objWIPInventory.ETT_Job_Card__c;
                                lstFinishedInvetories.add(objFinishedInventory);
                            }
                        }
                    }
                }
            }
            
            //This is finished Invetory Job Card Ids 
            set<Id> finishedInvetoryJobCardIds = new set<Id>();
            list<ETT_WIP_Inventory__c> lstDeleteWIPInvetories = new list<ETT_WIP_Inventory__c>();
            //Finshed Invetories process
            if(lstFinishedInvetories!=null && lstFinishedInvetories.size()>0 && isFinshedInventories){
                isFinshedInventories = false;
                Database.SaveResult[] lstFinshedInvetoriesSaveResults = Database.insert(lstFinishedInvetories,false);
                if(!lstFinshedInvetoriesSaveResults.isEmpty()){
                    for(integer i = 0; i<lstFinshedInvetoriesSaveResults.size(); i++) {
                        string succesStgMsg = '';
                        string failureStgMsg = '';
                        Database.SaveResult invMasterRes = lstFinshedInvetoriesSaveResults[i];
                        //Staging__c staging = percentInstance.stagingSucessAndError[i];
                        if(invMasterRes.isSuccess()) {
                            finishedInvetoryJobCardIds.add(lstFinshedInvetoriesSaveResults[i].Id);
                            succesStgMsg += 'Target Object Inserted Sucessfully:'+lstFinshedInvetoriesSaveResults[i].Id+';';
                        } else {
                            list<ETT_Apex_Error_log__c> lstErrorInfo = ETT_ErrorhandlingProcess.errorHandlingProcess(invMasterRes.getId(), invMasterRes.getErrors(),'Apex Class :ETT_JobCardTriggerHandler'+' '+'Apex Method :jobCardFinishedInventoriesDetailsUpdate');
                            lstETTErrorLog.addAll(lstErrorInfo);
                        }
                    }
                }
            }
            
            if(finishedInvetoryJobCardIds!=null && finishedInvetoryJobCardIds.size()>0){
                for(ETT_Finished_Inventory__c objFinishedInv :[Select Id,ETT_Job_Card__c,ETT_WIP_Inventory__c from ETT_Finished_Inventory__c
                                                              where Id in :finishedInvetoryJobCardIds]){
                    ETT_WIP_Inventory__c objWIPInv = new ETT_WIP_Inventory__c();
                    objWIPInv.Id                   = objFinishedInv.ETT_WIP_Inventory__c;
                    lstDeleteWIPInvetories.add(objWIPInv);                                              
                }
                
            }
            
            if(lstDeleteWIPInvetories!=null && lstDeleteWIPInvetories.size()>0){
                Database.DeleteResult[] lstWIPInvDeleteResults = Database.delete(lstDeleteWIPInvetories,false);
                 if(!lstWIPInvDeleteResults.isEmpty()){
                    for(integer i = 0; i<lstWIPInvDeleteResults.size(); i++) {
                        string succesStgMsg = '';
                        string failureStgMsg = '';
                        Database.deleteResult invMasterRes = lstWIPInvDeleteResults[i];
                        //Staging__c staging = percentInstance.stagingSucessAndError[i];
                        if(invMasterRes.isSuccess()) {
                            succesStgMsg += 'Target Object Inserted Sucessfully:'+lstWIPInvDeleteResults[i].Id+';';
                        } else {
                            list<ETT_Apex_Error_log__c> lstErrorInfo = ETT_ErrorhandlingProcess.errorHandlingProcess(invMasterRes.getId(), invMasterRes.getErrors(),'Apex Class :ETT_JobCardTriggerHandler'+' '+'Apex Method :jobCardFinishedInventoriesDetailsUpdate');
                            lstETTErrorLog.addAll(lstErrorInfo);
                        }
                    }
                 }
            }
            
            system.debug('******setOfExstingJobCardsMatchCollectionCards******'+setOfExstingJobCardsMatchCollectionCards);
            //Sobject Status Preparation for Collection Card and Opportunity and Work Order
            if(setOfExstingJobCardsMatchCollectionCards!=null && setOfExstingJobCardsMatchCollectionCards.size()>0){
                for(ETT_Collection_Card__c objCollectionCard :[Select Id,ETT_Work_Order__c,ETT_Work_Order__r.ETT_Opportunity__c from ETT_Collection_Card__c where id in :setOfExstingJobCardsMatchCollectionCards]){
                    Schema.SObjectType schemaobjCollectionCard  = Schema.getGlobalDescribe().get('ETT_Collection_Card__c');
                    SObject sobjCollectionCard = schemaobjCollectionCard.newSObject();
                    sobjCollectionCard.put('ETT_Completed__c',true);
                    sobjCollectionCard.put('Id',objCollectionCard.Id);
                    
                    Schema.SObjectType schemaobjWorkOrder  = Schema.getGlobalDescribe().get('WorkOrder');
                    SObject sobjWorkOrder = schemaobjWorkOrder.newSObject();
                    sobjWorkOrder.put('Status','Completed');
                    sobjWorkOrder.put('Id',objCollectionCard.ETT_Work_Order__c);
                    sobjWorkOrder.put('EndDate',DateTime.now());
                    
                    Schema.SObjectType schemaobjOpportunity  = Schema.getGlobalDescribe().get('Opportunity');
                    SObject sobjOppty = schemaobjOpportunity.newSObject();
                    sobjOppty.put('StageName','Closed Won');
                    sobjOppty.put('CloseDate',Date.Today());
                    sobjOppty.put('Id',objCollectionCard.ETT_Work_Order__r.ETT_Opportunity__c);
                    
                    
                    lstSobjectStatusUpdates.add(sobjCollectionCard);
                    lstSobjectStatusUpdates.add(sobjWorkOrder);
                    lstSobjectStatusUpdates.add(sobjOppty);
                }
            }
            
            system.debug('****lstSobjectStatusUpdates****'+lstSobjectStatusUpdates);
            //Collection Card and Work Order and Opportunity Status Updates 
            if(lstSobjectStatusUpdates!=null && lstSobjectStatusUpdates.size()>0 && isSobjStatusUpdate){
                isSobjStatusUpdate = false;
                Database.SaveResult[] lstSobjectStatusSaveResults = Database.update(lstSobjectStatusUpdates,false);
                if(!lstSobjectStatusSaveResults.isEmpty()){
                    for(integer i = 0; i<lstSobjectStatusSaveResults.size(); i++) {
                        string succesStgMsg = '';
                        string failureStgMsg = '';
                        Database.SaveResult invMasterRes = lstSobjectStatusSaveResults[i];
                        //Staging__c staging = percentInstance.stagingSucessAndError[i];
                        if(invMasterRes.isSuccess()) {
                            succesStgMsg += 'Target Object Inserted Sucessfully:'+lstSobjectStatusSaveResults[i].Id+';';
                        } else { 
                            list<ETT_Apex_Error_log__c> lstErrorInfo = ETT_ErrorhandlingProcess.errorHandlingProcess(invMasterRes.getId(), invMasterRes.getErrors(),'Apex Class :ETT_JobCardTriggerHandler'+' '+'Apex Method :jobCardFinishedInventoriesDetailsUpdate');
                            lstETTErrorLog.addAll(lstErrorInfo);
     
                        }
                    }
                }
            }
            
            if(lstETTErrorLog!=null && lstETTErrorLog.size()>0){
                insert lstETTErrorLog;
            }
            
        }*/
        
    }
    
    public static void preProcessingOperation(List<ETT_Job_Card__c> newList,Map<Id,ETT_Job_Card__c> oldMap){
      /*  List<ETT_Job_Card__c> childJobCardsToUpdate=new List<ETT_Job_Card__c>();
        for(ETT_Job_Card__c jc:newList){
            
            //rejecting the building stage rejection against thread stage
            if(oldMap!=null && jc.ETT_Main_Job_Card__c==null && jc.ETT_Thread_Preparation_Status__c=='Waiting for Acceptance' && oldMap.get(jc.Id).ETT_Thread_Preparation_Status__c=='Resubmitted by Building'){
                List<String> stageListOrdered=new List<String>();
                String currentStageValue='';
                String nextStageValue='Building';
                Boolean isNextStagePresent=false;
                Integer currentStageIndex;
                
                String stageCombined=jc.ETT_Job_Stages_to_Perform_Ordered__c;
                if(String.isNotBlank(stageCombined)){
                    stageListOrdered=stageCombined.split(';');                    
                    for(Integer i=0;i<stageListOrdered.size();i++){
                        if(stageListOrdered[i]=='Thread Preparation' && currentStageIndex==null){
                            currentStageIndex=i;
                        }
                        if(stageListOrdered[i]==nextStageValue){
                            isNextStagePresent=true;
                        }
                    }
                    if(stageListOrdered.size()>0 && currentStageIndex!=null){
                        stageListOrdered.remove(currentStageIndex);
                        if(stageListOrdered.size()>0){
                            if(isNextStagePresent){
                                jc.ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                            }
                            else{
                                jc.ETT_Job_Stages_to_Perform_Ordered__c='Building;'+String.join(stageListOrdered,';');
                            }
                        }
                        else{
                            jc.ETT_Job_Stages_to_Perform_Ordered__c='Building';
                        }
                        jc.ETT_Stages__c='Building';
                        jc.ETT_Building_Status__c='Resubmitted by Supervisor';
                        jc.ETT_No_of_Building_Revisions__c+=(jc.ETT_No_of_Building_Revisions__c+1);
                    }
                }
            }
            //approving the building stage rejection against thread stage
            else if(oldMap!=null && jc.ETT_Main_Job_Card__c==null && jc.ETT_No_of_Thread_Preparation_revisions__c!=null && oldMap.get(jc.Id).ETT_No_of_Thread_Preparation_revisions__c!=jc.ETT_No_of_Thread_Preparation_revisions__c && jc.ETT_Thread_Preparation_Status__c=='Resubmitted by Building'){
                String jobQueryStr='Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+' from ETT_Job_Card__c where ETT_Main_Job_Card__c=\''+jc.Id+'\'';
                for(ETT_Job_Card__c jcCh:Database.query(jobQueryStr)){
                    if(jcCh.ETT_Main_Job_Card__c!=null && jcCh.ETT_Stages__c=='Thread Preparation'){
                        if(jcCh.ETT_Thread_Preparation_Status__c=='Waiting for Acceptance'){
                            jcCh.ETT_Thread_Preparation_Status__c=(String.isNotBlank(jcCh.ETT_Stages__c) ? 'Resubmitted by Building' : '');
                            jcCh.ETT_No_of_Thread_Preparation_revisions__c+=1;
                            childJobCardsToUpdate.add(jcCh);
                        }
                    }
                }                
            }
            
            if(oldMap==null){
                jc.ETT_Overall_Status__c='Not Started';
            }
            else if(jc.ETT_Buffing_Status__c=='Rejected' || jc.ETT_Skiving_Status__c=='Rejected' || jc.ETT_Repair_Status__c=='Rejected' || jc.ETT_Thread_Preparation_Status__c=='Rejected'){//other stage fields to be added later
                jc.ETT_Overall_Status__c='Rejected';
            }
            else if(jc.ETT_Buffing_Status__c=='Accepted' && jc.ETT_Skiving_Status__c=='Accepted' && jc.ETT_Repair_Status__c=='Accepted' && jc.ETT_Thread_Preparation_Status__c=='Accepted'){//other stage fields to be added later
                jc.ETT_Overall_Status__c='Accepted';
            }
            else if(String.isNotBlank(jc.ETT_Buffing_Status__c) || String.isNotBlank(jc.ETT_Skiving_Status__c) || String.isNotBlank(jc.ETT_Repair_Status__c) || String.isNotBlank(jc.ETT_Thread_Preparation_Status__c) || String.isNotBlank(jc.ETT_Quality_Check_Status__c)){//other stage fields to be added later
                jc.ETT_Overall_Status__c='In-Progress';
            }
            
            if(jc.ETT_Quality_Check_Status__c=='Accepted'){
                jc.ETT_Overall_Status__c='Accepted';
            }
        }
        if(childJobCardsToUpdate.size()>0){
            update childJobCardsToUpdate;
        }*/
    }
    
    public static void postProcessingLogic(List<ETT_Job_Card__c> newList,Map<Id,ETT_Job_Card__c> oldMap){        
        
    }
    
}