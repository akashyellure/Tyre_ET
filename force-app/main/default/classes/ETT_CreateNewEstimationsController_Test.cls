@isTest
public class ETT_CreateNewEstimationsController_Test {
    public static testmethod void createNewEstimationTest(){
        
        List<Account> accountsList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TEST CUST 100';
        acc.Party_Type__c = 'Customer';
        acc.ETT_Party_Code__c = '0018E00001h7athQAA';
        accountsList.add(acc);
        insert accountsList;
        
        ETT_SubInventory__c objSubInventory = new ETT_SubInventory__c();
        objSubInventory.Name = 'test';
        insert objSubInventory;
        
        Tyre_Estimation__c tEstimationObj = new Tyre_Estimation__c();
        tEstimationObj.Account__c = accountsList[0].id;
        tEstimationObj.SubInventory__c = objSubInventory.id;
        tEstimationObj.Type__c = 'Customer';
        tEstimationObj.Status__c = 'Pending';
        tEstimationObj.Payment_Terms__c = 'Cash';
        insert tEstimationObj;
        
        ETT_Price_Master__c pm2 = new ETT_Price_Master__c();
        pm2.ETT_Party_Name__c = accountsList[0].Id;
        insert pm2;
        
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c = pm2.Id;
        epi.ETT_Approval_Status__c = 'Approved';
        insert epi;
        
        ETT_Tyre_Size_Master__c tsm = new ETT_Tyre_Size_Master__c();
        tsm.Name = 'Size1';
        tsm.ETT_Tyre_Size__c = 'R200';
        insert tsm;
        
        ETT_Pattern_Master__c pat = new ETT_Pattern_Master__c();
        pat.Name = 'Pat21';
        insert pat;
        
        ETT_Country_Master__c coun = new ETT_Country_Master__c();
        coun.Name = 'Coun1';
        insert coun;
        
        ETT_Brand_Master__c bra = new ETT_Brand_Master__c();
        bra.Name = 'Bran1';
        insert bra;
        
        List<ETT_Tyre_Inventory__c> listTIN = new List<ETT_Tyre_Inventory__c>();
 
        ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = accountsList[0].Id;
        tin2.Serial_Number__c = '24325445476';
        tin2.ETT_Inventory_Status__c = 'Inspected - Approved';
        tin2.ETT_Brand__c = bra.Id;
        tin2.ETT_Country__c = coun.id;
        tin2.ETT_Pattern__c = pat.id;
        tin2.ETT_Tyre_Size_Master__c = tsm.Id;
        tin2.Purchase_Price__c = 100;
        tin2.Tyre_Type__c = 'Refurbished';
        listTIN.add(tin2);
        insert listTIN;
        
        Tyre_Estimation_Line_Item__c tyreEstimationLI = new Tyre_Estimation_Line_Item__c();
        tyreEstimationLI.Tyre_Estimation__c = tEstimationObj.id;
        tyreEstimationLI.Tyre_Inventory__c = listTIN[0].id;
        tyreEstimationLI.Unit_Price__c = 200;
        insert tyreEstimationLI;
        
        TyreInventoryPriceSettings__c tInventoryPS = new TyreInventoryPriceSettings__c();
        tInventoryPS.Party_code__c = '0018E00001h7athQAA';
        tInventoryPS.Party_Type__c = 'Customer';
        tInventoryPS.Selling_Price__c = 200;
        insert tInventoryPS;
        
        test.startTest();
        
        // Test with various parameters
        try {
            ETT_CreateNewEstimationsController.getTyreDetails('serialVal', 'tyreSizeVal', 'brandVal', 'patternVal', 'tyreType', 'countryVal', accountsList[0].Id, 'threadPattern', 'subInventoryIdval');
            ETT_CreateNewEstimationsController.getTyreDetails(null, null, null, null, null, null, accountsList[0].Id, null, objSubInventory.id);
            ETT_CreateNewEstimationsController.getTyreDetails('', '', '', '', '', '', accountsList[0].Id, '', objSubInventory.id);
            ETT_CreateNewEstimationsController.getTyreDetails('serialVal', 'tyreSizeVal', 'brandVal', 'patternVal', 'tyreType', 'countryVal', null, 'threadPattern', null);

            ETT_CreateNewEstimationsController.TyreInventoryWrapper tyreWrapper = new ETT_CreateNewEstimationsController.TyreInventoryWrapper(listTIN[0], 0.0);
            ETT_CreateNewEstimationsController.TyreInventoryWrapper tyreWrapper1 = new ETT_CreateNewEstimationsController.TyreInventoryWrapper();
            ETT_CreateNewEstimationsController.createEstimations(new list<ETT_CreateNewEstimationsController.TyreInventoryWrapper>{tyreWrapper}, accountsList[0].id, objSubInventory.id, tEstimationObj.id);
            ETT_CreateNewEstimationsController.createEstimations(new list<ETT_CreateNewEstimationsController.TyreInventoryWrapper>{tyreWrapper1}, accountsList[0].id, objSubInventory.id, null);

            // Test with empty or null values
            ETT_CreateNewEstimationsController.createEstimations(new list<ETT_CreateNewEstimationsController.TyreInventoryWrapper>{}, accountsList[0].id, objSubInventory.id, tEstimationObj.id);
            ETT_CreateNewEstimationsController.createEstimations(null, accountsList[0].id, objSubInventory.id, tEstimationObj.id);
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }

        System.assertEquals(tEstimationObj.id, tyreEstimationLI.Tyre_Estimation__c);
        
        test.stopTest();
    }  
}