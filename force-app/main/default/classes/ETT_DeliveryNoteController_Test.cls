@isTest
public class ETT_DeliveryNoteController_Test {
    
    @isTest public static void testFetchUser(){
        
        ETT_DeliveryNoteController.fetchUser();
    }
    
    @isTest public static void testGetJobCardIntoList(){
        
        Map<String,String> mapList = new  Map<String,String>();
       /* List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;*/
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
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
        List<ETT_Estimate_Quotation__c>  estimateQuotationsList = ETT_TestFactory.createEstimateQuotations(collectionCardsList[0].Id,inspectionsCardsList[0].Id,tyreMasterSizeList[0].Id);
        insert estimateQuotationsList;
        List<ETT_Delivery_Note__c> deliveryNotesList = ETT_TestFactory.createDeliveryNotes('Tyre - Customer',objAcc1.Id,estimateQuotationsList[0].Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id );
        insert deliveryNotesList[2];
        List<ETT_Delivery_Line_Item__c> deliveryLineItemsList = ETT_TestFactory.createDeliveryLineItems(4,collectionCardsList[0].Id,inspectionsCardsList[0].Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id);
        deliveryLineItemsList[2].ETT_Delivery_Note__c = deliveryNotesList[2].id;
        
        
        ETT_DeliveryNoteController.getJobCardIntoList(objAcc1.Id);
        ETT_DeliveryNoteController.getJobCardIntoListForPrint(objAcc1.Id);
        insert deliveryLineItemsList[2];
        mapList.put('deliveryNoteJson', JSON.serialize(deliveryNotesList[0]));
        mapList.put('deliveryLineItemJson', JSON.serialize(deliveryLineItemsList));
        ETT_DeliveryNoteController.submitDeliveryNote(mapList);
        
    }
    
    @isTest public static void testGetJobCardIntoList1(){
        
        Map<String,String> mapList = new  Map<String,String>();
       /* List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;*/
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
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
        List<ETT_Estimate_Quotation__c>  estimateQuotationsList = ETT_TestFactory.createEstimateQuotations(collectionCardsList[0].Id,inspectionsCardsList[0].Id,tyreMasterSizeList[0].Id);
        insert estimateQuotationsList;
        List<ETT_Delivery_Note__c> deliveryNotesList = ETT_TestFactory.createDeliveryNotes('Tyre - Customer',objAcc1.Id,estimateQuotationsList[0].Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id );
        insert deliveryNotesList[2];
        deliveryNotesList[0].ETT_Casing__c = 'Supplier Casing';
        List<ETT_Delivery_Line_Item__c> deliveryLineItemsList = ETT_TestFactory.createDeliveryLineItems(1,collectionCardsList[0].Id,inspectionsCardsList[0].Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id);
        deliveryLineItemsList[0].ETT_Delivery_Note__c = deliveryNotesList[2].id;
        insert deliveryLineItemsList[0];
        try{
            ETT_DeliveryNoteController.getJobCardIntoList(objAcc1.Id);
            ETT_DeliveryNoteController.getJobCardIntoListForPrint(objAcc1.Id);
        }catch(exception e){
            system.debug('excep '+e); 
        }
        mapList.put('deliveryNoteJson', JSON.serialize(deliveryNotesList[0]));
       
        mapList.put('deliveryLineItemJson', JSON.serialize(deliveryLineItemsList));
        ETT_DeliveryNoteController.submitDeliveryNote(mapList);
        deliveryNotesList[0].ETT_Casing__c = 'Customer Casing';
        mapList.put('deliveryNoteJson', JSON.serialize(deliveryNotesList[0]));
       // ETT_DeliveryNoteController.submitDeliveryNote(mapList);
        
         mapList.put('deliveryLineItemJson', JSON.serialize(deliveryLineItemsList = ETT_TestFactory.createDeliveryLineItems(1,collectionCardsList[0].Id,inspectionsCardsList[0].Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id)));
        ETT_DeliveryNoteController.submitDeliveryNote(mapList);
        
    }
    
}