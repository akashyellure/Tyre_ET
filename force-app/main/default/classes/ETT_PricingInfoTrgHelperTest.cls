@isTest
public class ETT_PricingInfoTrgHelperTest {

    public static testmethod void testDuplicate(){
        List<Account> accountsList = ETT_TestFactory.createAccounts('TJ89ntName34434', 'Organization');
        insert accountsList;
        
        ETT_Price_Master__c pm2 = new ETT_Price_Master__c();
        pm2.ETT_Party_Name__c = accountsList[0].Id;
        insert pm2;
        
          ETT_Tyre_Size_Master__c tsm = new ETT_Tyre_Size_Master__c();
        tsm.Name ='Size1';
        insert tsm;
        
        ETT_Pattern_Master__c pat = new ETT_Pattern_Master__c();
        pat.Name ='Pat21';
        insert pat;
        
        ETT_Country_Master__c coun = new ETT_Country_Master__c();
        coun.Name ='Coun1';
        insert coun;
        
        ETT_Brand_Master__c bra = new ETT_Brand_Master__c();
        bra.Name ='Bran1';
        insert bra;
        
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c=pm2.Id;
        epi.ETT_Tyre_Size__c=tsm.Id;
        epi.ETT_Brand__c=bra.Id;
        epi.ETT_Country_of_Origin__c=coun.Id;
        epi.ETT_Pattern__c=pat.Id;
        epi.ETT_Approval_Status__c ='Approved';
        insert epi;
        
    }
}