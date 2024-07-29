public class ETT_TyreEstimation_CustomLkupCtrl {
	@AuraEnabled
    public static list<Tyre_Estimation__c> getTyreEstimationFilterList(string searchWord, String selectCustomerId, String selectInventoryId){
        String queryStr;
        queryStr = 'SELECT Id,Name from Tyre_Estimation__c where Name LIKE  \'%'+ searchWord +'%\' ';
        if(selectCustomerId != null && selectCustomerId != ''){
            queryStr += 'AND Account__c =: selectCustomerId ';
        }
        if(selectInventoryId != null && selectInventoryId != ''){
            queryStr += 'AND SubInventory__c =: selectInventoryId ';
        }
        return Database.Query(queryStr);
    }
}