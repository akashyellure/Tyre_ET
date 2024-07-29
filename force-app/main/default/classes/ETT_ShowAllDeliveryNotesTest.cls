@isTest
public class ETT_ShowAllDeliveryNotesTest {
    
    private static testmethod void showDN(){
        
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('Test92J35464', 'Organization');
        insert accountsList;
        
        ETT_ShowAllDeliveryNotes.getAllDeliveryNotes(accountsList[0].id);
    }

}