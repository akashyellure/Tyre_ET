@isTest
public class ETT_CreateDeliveryNoteController_Test {
    public static testmethod void testCreateNewDeliveryNote(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAmadtb934', 'Organization');
        insert accountsList;
        
        ETT_SubInventory__c subInventoryObj = new ETT_SubInventory__c ();
        subInventoryObj.Name='test';
        insert subInventoryObj; 
        
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
        
        
        ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = accountsList[0].Id;
        tin2.Serial_Number__c = '24325445476';
        tin2.ETT_Inventory_Status__c='Inspected - Approved';
        tin2.ETT_Brand__c = bra.Id;
        tin2.ETT_Country__c=coun.id;
        tin2.ETT_Pattern__c=pat.id;
        tin2.ETT_Tyre_Size_Master__c=tsm.Id;
        tin2.Purchase_Price__c = 100;
        insert tin2;  
        
        Tyre_Estimation__c tyreEstimationObj = new Tyre_Estimation__c();
        tyreEstimationObj.Account__c = accountsList[0].Id;
        insert tyreEstimationObj;
        
        Tyre_Estimation_Line_Item__c tyreEstimationLI = new Tyre_Estimation_Line_Item__c();
        tyreEstimationLI.Tyre_Inventory__c = tin2.id;
        tyreEstimationLI.Tyre_Estimation__c = tyreEstimationObj.id;
        insert tyreEstimationLI;
        
        ETT_CreateDeliveryNoteController.getTyreDetails('serialVal', 'tyreSizeVal', 'brandVal', 'patternVal', 'tyreType', 'countryVal', 'customerId', 'subInventoryId', 'tyreEstimationId');
        ETT_CreateDeliveryNoteController.createEstimations(new List<Tyre_Estimation_Line_Item__c>{tyreEstimationLI}, accountsList[0].Id, subInventoryObj.id,tyreEstimationObj.id);
    }
}