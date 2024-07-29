@isTest
public class ETT_MoveOrderClassTest {
public static testmethod void tyreCollMethod2(){
        test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='ETT_Receptionist']; 
        User recp = new User(Alias = 'standt', Email='stanRecp@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='standaRecpser@testorg.com');
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('Test92J35464', 'Organization');
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = accountsList[0].Id;
        objCC.ETT_Opportunity__c = opp.Id;
        insert objCC;
        
        ETT_Price_Master__c pm = new ETT_Price_Master__c();
        pm.ETT_Party_Name__c = accountsList[0].Id;
        insert pm;
        
        ETT_Tyre_Master__c tm =  new ETT_Tyre_Master__c();
        insert tm;
        
        
        List<Account> accountsList2 = ETT_TestFactory.createAccounts('TeJK89ame35464', 'Organization');
        insert accountsList2;
        Opportunity opp2 = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp2;
        
        
        ETT_Collection_Card__c objCC2 = new ETT_Collection_Card__c();
        objCC2.ETT_Accounts__c = accountsList2[0].Id;
        objCC2.ETT_Opportunity__c = opp2.Id;
        objCC2.HasTyresWithoutPrice__c = false;
        insert objCC2;
        
        ETT_Tyre_Size_Master__c tsm = new ETT_Tyre_Size_Master__c();
        tsm.Name ='Size167';
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
        
        ETT_Tyre_Size_Master__c tsm2 = new ETT_Tyre_Size_Master__c();
        tsm2.Name ='Size134';
        insert tsm2;
        
        ETT_Pattern_Master__c pat2 = new ETT_Pattern_Master__c();
        pat2.Name ='Pat213';
        insert pat2;
        
        ETT_Country_Master__c coun2 = new ETT_Country_Master__c();
        coun2.Name ='Coun1689';
        insert coun2;
        
        ETT_Brand_Master__c bra2 = new ETT_Brand_Master__c();
        bra2.Name ='Bran178';
        insert bra2;
        
        
        
        ETT_Price_Master__c pm2 = new ETT_Price_Master__c();
        pm2.ETT_Party_Name__c = accountsList2[0].Id;
        insert pm2;
        
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c=pm2.Id;
        epi.ETT_Approval_Status__c ='Approved';
        insert epi;
        
        ETT_Tyre_Master__c tm2 =  new ETT_Tyre_Master__c();
        tm2.ETT_Brand_Name__c=bra.id;
        tm2.ETT_Tyre_Size__c=tsm.id;
        tm2.ETT_Original_Pattern__c=pat2.id;
        tm2.ETT_Country_Name__c=coun2.id;
        insert tm2;
        
        ETT_Tyre_Inventory__c tin = new ETT_Tyre_Inventory__c();
        tin.ETT_Account__c = accountsList2[0].Id;
        tin.ETT_Collection_Card__c = objCC2.Id;
        tin.Serial_Number__c = '243254454';
        tin.ETT_Inventory_Status__c='Draft';
        
        
        ETT_StagingNewTyreCollection__c stg = new ETT_StagingNewTyreCollection__c();
        stg.Brand_Name__c = 'test';
        stg.Collection_Card__c = objCC2.Id;
        stg.Country_Name__c = 'test';
        stg.Pattern_Name__c='test';
        stg.Size_Name__c ='test';
        
        
        ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = accountsList2[0].Id;
        tin2.ETT_Collection_Card__c = objCC2.Id;
        tin2.Serial_Number__c = '243254454';
        tin2.ETT_Inventory_Status__c='Draft';
        tin2.ETT_Brand__c = bra.Id;
        tin2.ETT_Country__c=coun.id;
        tin2.ETT_Pattern__c=pat.id;
        tin2.ETT_Tyre_Size_Master__c=tsm.Id;
        
        insert tin2;
        
        tin2.ETT_Brand__c = bra2.Id;
        tin2.ETT_Country__c=coun2.id;
        tin2.ETT_Pattern__c=pat2.id;
        tin2.ETT_Tyre_Size_Master__c=tsm2.Id; 
        update tin2;
        
        ETT_StagingNewTyreCollection__c stg2 = new ETT_StagingNewTyreCollection__c();
        stg2.Brand_Name__c = 'test';
        stg2.Collection_Card__c = objCC2.Id;
        stg2.Country_Name__c = 'test';
        stg2.Pattern_Name__c='test';
        stg2.Size_Name__c ='test';
        insert stg2;
        
       ETT_MoveOrderClass.updateCollectionCard(objCC2.Id,'Move_Order_Status__c');
        
        
        test.stopTest();
    }
}