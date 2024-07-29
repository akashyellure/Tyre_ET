@isTest
public class ETT_createJobCardTest {
    
    private static testmethod void creatJobcard(){
        
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAmadtb934', 'Organization');
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        ETT_Price_Master__c pm2 = new ETT_Price_Master__c();
        pm2.ETT_Party_Name__c = accountsList[0].Id;
        insert pm2;
        
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c=pm2.Id;
        epi.ETT_Approval_Status__c ='Approved';
        insert epi;
        
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
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = accountsList[0].Id;
        objCC.ETT_Opportunity__c = opp.Id;
        objCC.ETT_Inspection_Done__c= true;
        insert objCC;
        
        ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = accountsList[0].Id;
        tin2.Serial_Number__c = '24325445476';
        tin2.ETT_Inventory_Status__c='Inspected - Approved';
        tin2.ETT_Brand__c = bra.Id;
        tin2.ETT_Country__c=coun.id;
        tin2.ETT_Pattern__c=pat.id;
        tin2.ETT_Tyre_Size_Master__c=tsm.Id;
        tin2.Purchase_Price__c = 100;
        tin2.ETT_Collection_Card__c =objCC.Id;
        insert tin2;

        
        ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
        objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId();
        objIC.Tyre_Inventory__c=tin2.id;
        objIC.ETT_Status__c = 'Accept';
        objIC.ETT_Collection_Card__c=objCC.Id;
        insert objIC;
        
        ETT_createJobCard.getUserDetails();
        ETT_createJobCard.createJobCard(objCC.Id,'Job Card Created');
    }

}