@isTest
public class ETT_Utility_Test {
    static TestMethod void UnitTest1(){
        ETT_Utility.getPicklistValues( 'Account','CurrencyIsoCode');
        ETT_Utility.getFieldsForSobject('Account');
    }
}