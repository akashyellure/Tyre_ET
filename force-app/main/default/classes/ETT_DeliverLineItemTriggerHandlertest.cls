@isTest 

public class ETT_DeliverLineItemTriggerHandlertest {
    
    @isTest 
    
    Public static void Codecoverage(){
        
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert opp; //insert opportunity
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(objAcc1.Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;


 List<ETT_Tyre_Size_Master__c> tyreMasterSizeList =  ETT_TestFactory.createTyreSizeMaster();
        insert tyreMasterSizeList;
        
        List<ETT_Brand_Master__c> brandMastersList = ETT_TestFactory.createBrandMasters();
        insert brandMastersList;
        
        List<ETT_Inspection_Card__c> inspectionsCardsList = ETT_TestFactory.createInspectionCards('Tyre - Cash Supplier',objAcc1.Id,brandMastersList[0].Id,collectionCardsList[0].Id,tyreMasterSizeList[0].Id);
        inspectionsCardsList[0].ETT_Status__c ='Send Back';
        insert inspectionsCardsList;
        
        List<ETT_Estimate_Quotation__c>  estimateQuotationsList = ETT_TestFactory.createEstimateQuotations(collectionCardsList[0].Id,inspectionsCardsList[0].Id,tyreMasterSizeList[0].Id);
        insert estimateQuotationsList;
        
        List<ETT_Delivery_Note__c> deliveryNotesList = ETT_TestFactory.createDeliveryNotes('Tyre - Customer',objAcc1.Id,estimateQuotationsList[0].Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id );
        insert deliveryNotesList[2];
        
        List<ETT_Delivery_Line_Item__c> deliveryLineItemsList = ETT_TestFactory.createDeliveryLineItems(1,collectionCardsList[0].Id,inspectionsCardsList[0].Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id);
        deliveryLineItemsList[0].ETT_Delivery_Note__c = deliveryNotesList[2].id;
        insert deliveryLineItemsList[0];
        
        ETT_Tyre_Inventory__c ti= new ETT_Tyre_Inventory__c();
            ti.ETT_Account__c=objAcc1.id;
        ti.ETT_Status_Changed_On__c= system.now();
        ti.ETT_Status_TI__c= 'Delivery Note Created';
        ti.ETT_Tyre_Inspection_Card__c=inspectionsCardsList[0].id;
         insert ti;
        
      ETT_DeliverLineItemTriggerHandler.updateTyreInventoryStatus(deliveryLineItemsList);
        
    }

}