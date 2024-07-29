@isTest 
public class ETT_DeliveryNoteTriggerHandlertest {
    
    @isTest 
    Public static void Codecoverage(){
        
        map<Id,ETT_Delivery_Note__c> mapOfOldDeliveryNote = new map<Id,ETT_Delivery_Note__c>();
        
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert opp; //insert opportunity
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(objAcc1.Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
        
        ETT_Inspection_Card__c objInspectionCard = new ETT_Inspection_Card__c();
        objInspectionCard.ETT_Status__c = 'Accept';
        objInspectionCard.ETT_Collection_Card__c = collectionCardsList[0].Id;
        insert objInspectionCard;
        
        List<ETT_Delivery_Note__c> deliveryNotesList = new List<ETT_Delivery_Note__c>();
        ETT_Delivery_Note__c objDN = new ETT_Delivery_Note__c();
        objDN.Approved_By__c = 'Suresh';
        objDN.ETT_Collection_Card__c = collectionCardsList[0].Id;
        deliveryNotesList.add(objDN);
        insert deliveryNotesList; 
        
        mapOfOldDeliveryNote.put(objDN.Id,objDN);
        
        ETT_Delivery_Line_Item__c ett_delivery_line_item = new ETT_Delivery_Line_Item__c(
            CurrencyIsoCode = 'AED',
            ETT_Collection_Card__c = collectionCardsList[0].id,
            ETT_Delivery_Note__c = deliveryNotesList[0].id,
            ETT_Inspection_Card__c = objInspectionCard.id,
            ETT_Is_Checked__c = false,
            ETT_Job_Type__c = 'Retread' );
        insert ett_delivery_line_item;
        
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
        
        /*ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = objAcc1.Id;
        tin2.Serial_Number__c = '24325445476';
        tin2.ETT_Inventory_Status__c='Inspected - Approved';
        tin2.ETT_Brand__c = bra.Id;
        tin2.ETT_Country__c=coun.id;
        tin2.ETT_Pattern__c=pat.id;
        tin2.ETT_Tyre_Size_Master__c=tsm.Id;
        tin2.Purchase_Price__c = 100;
        insert tin2;
        
        tin2.ETT_Status_TI__c = 'Delivery Note Submitted for Approval';
        tin2.ETT_Status_Changed_On__c= system.now();
        update tin2; */
        
        ETT_DeliveryNoteTriggerHandler.updateTyreInventoryStatusApproved(deliveryNotesList, mapOfOldDeliveryNote);
        ETT_DeliveryNoteTriggerHandler.updateTyreInventoryStatusCompleted(deliveryNotesList, mapOfOldDeliveryNote);
        ETT_DeliveryNoteTriggerHandler.isSubmittedForApproval(deliveryNotesList);
    }
    
    
    @isTest static void testETTDeliveryNote(){
        
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        objAcc1.Party_Type__c='Customer';
        insert objAcc1;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert opp; //insert opportunity
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(objAcc1.Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
        
        List<ETT_Delivery_Note__c> deliveryNotesList = new List<ETT_Delivery_Note__c>();
        ETT_Delivery_Note__c objDN = new ETT_Delivery_Note__c();
        objDN.Approved_By__c = 'Suresh';
        objDN.ETT_Collection_Card__c = collectionCardsList[0].Id;
        objDN.ETT_Account__c = objAcc1.Id;
        objDN.ETT_Is_Submitted_for_Approval__c = true;
        deliveryNotesList.add(objDN);
        insert deliveryNotesList; 
        
        objDN.DN_Status__c = 'Approved';
        update objDN;
        
        ETT_Inspection_Card__c objInspectionCard = new ETT_Inspection_Card__c();
        objInspectionCard.ETT_Status__c = 'Accept';
        objInspectionCard.ETT_Collection_Card__c = collectionCardsList[0].Id;
        insert objInspectionCard;
        
        ETT_Delivery_Line_Item__c ett_delivery_line_item = new ETT_Delivery_Line_Item__c(
            CurrencyIsoCode = 'AED',
            ETT_Collection_Card__c = collectionCardsList[0].id,
            ETT_Delivery_Note__c = deliveryNotesList[0].id,
            ETT_Inspection_Card__c = objInspectionCard.id,
            ETT_Is_Checked__c = false,
            ETT_Job_Type__c = 'Retread');
        insert ett_delivery_line_item;
        
        ETT_Price_Master__c pm2 = new ETT_Price_Master__c();
        pm2.ETT_Party_Name__c = objAcc1.Id;
        insert pm2;
        
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c=pm2.Id;
        epi.ETT_Approval_Status__c ='Approved';
        insert epi;
        
        ETT_Tyre_Master__c tm =  new ETT_Tyre_Master__c();
        tm.ETT_Item_Code_Used__c = 'test123';
        insert tm;
        
        ETT_Tyre_Size_Master__c tsm = new ETT_Tyre_Size_Master__c();
        tsm.Name ='Size1967';
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
        
        ETT_Tyre_Inventory__c tin3 = new ETT_Tyre_Inventory__c();
        tin3.ETT_Account__c = objAcc1.Id;
        tin3.ETT_Collection_Card__c = collectionCardsList[0].id;
        tin3.Serial_Number__c = '243254454';
        tin3.ETT_Inventory_Status__c='Draft';
        tin3.ETT_Brand__c = bra.Id;
        tin3.ETT_Country__c=coun.id;
        tin3.ETT_Pattern__c=pat.id;
        tin3.ETT_Tyre_Size_Master__c=tsm.Id;
        tin3.ETT_Tyre_Master__c = tm.Id;
        tin3.ETT_Tyre_Inspection_Card__c = objInspectionCard.Id;
        insert tin3;
        
        test.startTest();
        //New ETT_InterOrgTransfer_DeliveryNote.Serialnumber_lines_element();
        //ETT_DeliveryNoteTriggerHandler.callThisCoverage();
        //Test.setMock(WebServiceMock.class,new WebServiceMockImpl());
        
        ETT_DeliveryNoteTriggerHandler.createARInOracle(deliveryNotesList[0].Id);
        ETT_DeliveryNoteTriggerHandler.createDNLinesInOracle(objDN.id,system.today(),objDN.Name);
        try{
        	ETT_DeliveryNoteTriggerHandler.isSubmittedForApproval(deliveryNotesList);
        }catch(Exception ex){}
        test.stopTest();
    }
}