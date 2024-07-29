@isTest
public class ETT_PrintDeliveryNoteControllerTest {
    
    @isTest
    public static void testCase1(){
        Test.startTest();
        user u = ETT_PrintDeliveryNoteController.fetchUser();
        Test.stopTest();
        System.assert(u != null);
    }
    @isTest
    public static void testCase2(){
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
        Contact con=new Contact();
        con.LastName = 'Test';
        con.AccountId=objAcc1.id;
        insert con;
        ETT_Collection_Card__c ett_collection_card = new ETT_Collection_Card__c(
            CurrencyIsoCode = 'AED',
            ETT_Accounts__c = objAcc1.id,
            ETT_All_Tyre_Rejected__c = false,
            ETT_CCL_Created__c = false,
            ETT_Check_In__c = DateTime.newInstance(2020,12,14,7,439,26392),
            ETT_Check_Out__c = DateTime.newInstance(2020,12,14,7,440,26438),
            ETT_Collection_Date__c = Date.newInstance(2020,12,07),
            ETT_Collection_Status__c = 'Accepted',
            ETT_Collection_Team_Submitted__c = true,
            ETT_Completed__c = false,
            ETT_Create_Job_Card__c = false,
            ETT_Estimation_Completed_By_Fm__c = false,
            ETT_Estimation_Completed_By_HOO__c = false,
            ETT_Factory_Manager_Approved__c = false,
            ETT_Head_Of_Operation_Approved__c = false,
            ETT_Inspection_Done__c = true,
            ETT_Job_Card_Done__c = false,
            ETT_Location__c = 'Dubai',
            ETT_Receptionist_Acceptance__c = false,
            ETT_Sales_Acceptance__c = false,
            //ETT_Status__c = 'Send Back',
            ETT_Submitted_For_Approval__c = false,
            ETT_Is_Active__c = false);
        
        insert ett_collection_card;
        
        ETT_Inspection_Card__c ett_inspection_card = new ETT_Inspection_Card__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = objAcc1.id,
            ETT_Chalk_Crayon_Yellow__c = true,
            ETT_Collection_Card__c = ett_collection_card.id,
            ETT_Contact__c = con.id,
            ETT_Cutting_Player__c = true,
            ETT_Electrical_Prob_In_Working_Condition__c = true,
            ETT_Handheld_Drop_Light__c = true,
            ETT_Industrial_Vacuum_Cleaner__c = true,
            ETT_Knife__c = true,
            ETT_Nail_Remover__c = true,
            ETT_Poking_Screwdriver__c = true,
            ETT_Spiral_Cement_Tool__c = true,
            ETT_Spreader_Light_Condition__c = true,
            ETT_Staple_Gun__c = true,
            ETT_Status__c = 'Send Back',
            ETT_Tyre_Life__c = '1',
            ETT_Tyre_Lift_In_Working_Condition__c = true,
            ETT_Tyre_Serial_Number__c = '1234',
            ETT_Tyre_Spreader_In_Working_Condition__c = true,
            ETT_Tyre_Tapping_Tool__c = true);
        
        insert ett_inspection_card;
        Test.startTest();
        List<ETT_Inspection_Card__c> result = ETT_PrintDeliveryNoteController.getJobCardIntoList(objAcc1.id);
        Test.stopTest();
        //  System.assert(u != null);
    }
    
    @isTest
    public static void testCase3(){
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
        List<ETT_Delivery_Line_Item__c> deliveryLineItemsList = ETT_TestFactory.createDeliveryLineItems(1,collectionCardsList[0].Id,inspectionsCardsList[0].Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id);
        deliveryLineItemsList[0].ETT_Delivery_Note__c = deliveryNotesList[2].id;
        insert deliveryLineItemsList[0];
        Map<String, String> mapDel = new Map<String, String>();
          Map<String, String> mapDel1 = new Map<String, String>();
        deliveryNotesList[2].id = null;
        deliveryLineItemsList[0].id = null;
        mapDel.put('deliveryNoteJson', JSON.serialize(deliveryNotesList[2]));
        mapDel.put('deliveryLineItemJson', JSON.serialize(deliveryLineItemsList));
        
        mapDel1.put('deliveryNoteJson', JSON.serialize(deliveryNotesList[2]));
         mapDel1.put('deliveryLineItemJson', JSON.serialize(new  List<ETT_Delivery_Line_Item__c>()));
        Test.startTest();
        List<ETT_Delivery_Line_Item__c> result = ETT_PrintDeliveryNoteController.getDeliveryLineItems(deliveryLineItemsList[0].id);
        ETT_PrintDeliveryNoteController.submitDeliveryNote(mapDel);
         ETT_PrintDeliveryNoteController.submitDeliveryNote(mapDel1);
        Test.stopTest();
    }
}