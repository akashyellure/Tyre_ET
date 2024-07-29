public class ETT_SubInventory_CustomLkupCtrl {
    @AuraEnabled
    public static list<ETT_SubInventory__c> getSubInventoryFilterList(string searchWord){
        
        String queryStr;
        queryStr = 'SELECT Id,Name from ETT_SubInventory__c where Name LIKE  \'%'+ searchWord +'%\' ';
        
        return Database.Query(queryStr);
    }
    
}