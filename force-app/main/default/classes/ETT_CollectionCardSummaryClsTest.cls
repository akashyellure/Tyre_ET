@isTest
public class ETT_CollectionCardSummaryClsTest {
    
    private static testmethod void getTyreInveTest(){
         List<Account> lstAccount = ETT_TestFactory.createAccounts('accountName', 'Organization');
        insert lstAccount;
        
        Opportunity objOpp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier', 'OppTest', 'New', Date.valueOf('2023-01-01') , lstAccount[0].Id);
        insert objOpp;
        
        List<ETT_Collection_Card__c> lstCC = ETT_TestFactory.createCollectionCards(String.valueOf(lstAccount[0].Id), String.valueOf(objOpp.Id));
        insert lstCC;
        
        ETT_CollectionCardSummaryCls.getTyreInventoryDetails(lstCC[0].id);
    }

}