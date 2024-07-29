/**
* Author:Janardhan
* CreatedDate: 24/02/2022
* Desc:
* testClass:ETT_CollectionCardSummaryClsTest
* */
public class ETT_CollectionCardSummaryCls {
    
    @auraEnabled
    public static list<ETT_Tyre_Inventory__c> getTyreInventoryDetails(string recordId){
        
        return [select id,ETT_Tyre_Size_Master__r.Name from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:recordId];
    }

}