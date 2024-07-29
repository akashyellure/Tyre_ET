@isTest
public class ETT_PurchaseOrderControllerTest {
    
    @isTest
    static void testCase1(){
        
          Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
        Contact con = new Contact();
        con.LastName = 'Test';
        con.AccountId = objAcc1.Id;
        insert con;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert opp;
        List<ETT_Brand_Master__c> brandMastersList = ETT_TestFactory.createBrandMasters();
        insert brandMastersList;
        List<ETT_Tyre_Size_Master__c> tyreMasterSizeList =  ETT_TestFactory.createTyreSizeMaster();
        insert tyreMasterSizeList;
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(objAcc1.Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
        List<ETT_Inspection_Card__c> inspectionsCardsList = ETT_TestFactory.createInspectionCards('Tyre - Cash Supplier',objAcc1.Id,brandMastersList[0].Id,collectionCardsList[0].Id,tyreMasterSizeList[0].Id);
        inspectionsCardsList[0].ETT_Status__c ='Send Back';
        insert inspectionsCardsList;
       
       
        
        
        ETT_Purchase_Order__c ett_purchase_order = new ETT_Purchase_Order__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = objAcc1.Id,
            ETT_Accepted_by_FM__c = true,
            ETT_Accepted_by_HOO__c = true,
            ETT_Address__c = 'pune',
            ETT_Bill_To__c = 'pune',
            ETT_Effective_Start_Date__c = Date.newInstance(2020,11,25),
            ETT_Last_Approved_Date__c = Date.newInstance(2020,11,25),
            ETT_Order_Creation_Date__c = Date.newInstance(2020,11,25),
            ETT_Payment_Terms__c = 'Immediate',
            ETT_Phone__c = '3434343443',
            ETT_Status__c = 'Accepted',
            ETT_Collection_Card__c = collectionCardsList[0].Id,
            ETT_Type__c = 'Standard Purchase Order');
        insert ett_purchase_order;
        
        ETT_Purchase_Order_Line_Item__c ett_purchase_order_line_item = new ETT_Purchase_Order_Line_Item__c(
            CurrencyIsoCode = 'AED',
            ETT_Purchase_Order__c = ett_purchase_order.Id,
            ETT_Accepted_by_FM__c = true,
            ETT_Accepted_by_HOO__c = true,
            ETT_Delivery_Date__c = Date.newInstance(2020,11,25),
            ETT_Item__c = 'TU-BIKE TYRE-SML',
            ETT_Quantity__c = 1.0,
            ETT_Type__c = 'Goods',
            ETT_UOM__c = 'Numbers',
            ETT_Unit_Price__c = 50.0,
            ETT_Vat_Percentage__c = '5%');
        insert ett_purchase_order_line_item;
        
        
        Test.startTest();
        ETT_PurchaseOrderController.purchaseOrderApprovalLineItems(new List<ETT_Purchase_Order_Line_Item__c>{ett_purchase_order_line_item});
        ETT_PurchaseOrderController.lstPurchaseLineItems(ett_purchase_order.id);
        Test.stopTest();
    }
}