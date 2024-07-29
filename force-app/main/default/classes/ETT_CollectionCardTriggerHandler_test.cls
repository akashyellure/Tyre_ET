@isTest
public class ETT_CollectionCardTriggerHandler_test {
    
    @isTest static void myTest(){        
        map<Id,ETT_Collection_Card__c> mapOfNewCollectionCards = new map<Id,ETT_Collection_Card__c>();
        map<Id,ETT_Collection_Card__c> mapOfOldCollectionCards = new map<Id,ETT_Collection_Card__c>();
        List<ETT_Collection_Card__c> newList = new List<ETT_Collection_Card__c>();
        
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
        
        Account objAcc2 = new Account();
        objAcc2.Name = 'Second Account';
        insert objAcc2;
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = objAcc1.Id;
        objCC.ETT_Inspection_Done__c = true;
        objCC.ETT_Estimation_Completed_By_HOO__c = false;
        objCC.Move_Order_Status__c = 'Draft';
        objCC.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId();
        insert objCC;
        
        newList.add(objCC);
        
        ETT_Tyre_Rejection_Report__c objRT = new ETT_Tyre_Rejection_Report__c();
        objRT.Collection_Card__c = objCC.Id;
        insert objRT;
        
        WorkOrderLineItem obj = new WorkOrderLineItem();
        obj.ETT_Collection_Card__c = objCC.Id;
        //insert obj;
        
        objCC.ETT_Estimation_Completed_By_HOO__c = true;
        objCC.ETT_Accounts__c = objAcc2.Id;
        objCC.Move_Order_Status__c = 'Confirmed';
        update objCC;
        
        ETT_Collection_Card__c objCC1 = new ETT_Collection_Card__c();
        objCC1.Id = objCC.Id;
        objCC1.ETT_Estimation_Completed_By_HOO__c = false;
        mapOfOldCollectionCards.put(objCC1.Id,objCC1);
        
        mapOfNewCollectionCards.put(objCC.Id,objCC);
        
        ETT_Inspection_Card__c objInspectionCard = new ETT_Inspection_Card__c();
        objInspectionCard.ETT_Status__c = 'Accept';
        objInspectionCard.ETT_Collection_Card__c = objCC.Id;
        insert objInspectionCard;
        
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
        
        ETT_Price_Master__c pm2 = new ETT_Price_Master__c();
        pm2.ETT_Party_Name__c = objAcc1.Id;
        insert pm2;
        
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c=pm2.Id;
        epi.ETT_Approval_Status__c ='Approved';
        insert epi;
        
        ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = objAcc1.Id;
        tin2.Serial_Number__c = '24325445476';
        tin2.ETT_Inventory_Status__c='Inspected - Approved';
        tin2.ETT_Brand__c = bra.Id;
        tin2.ETT_Country__c=coun.id;
        tin2.ETT_Pattern__c=pat.id;
        tin2.ETT_Tyre_Size_Master__c=tsm.Id;
        tin2.Purchase_Price__c = 100;
        tin2.ETT_Collection_Card__c = objCC.Id;
        insert tin2; 
        
        TyreInventoryPriceSettings__c tyreIPS = new TyreInventoryPriceSettings__c();
        tyreIPS.Party_Type__c = 'Internal';
        tyreIPS.Purchase_Price__c = 200;
        insert tyreIPS;
        
        test.startTest();
        
        ETT_CollectionCardTriggerHandler.isCollectionInventoryRecursive = true;
        ETT_CollectionCardTriggerHandler.colletionCardHandlerAfterUpdate(mapOfNewCollectionCards, mapOfOldCollectionCards);
        ETT_CollectionCardTriggerHandler.createJobCard(mapOfNewCollectionCards, mapOfOldCollectionCards);
        ETT_CollectionCardTriggerHandler.sendRejectedTyreDetails(newList);
        ETT_CollectionCardTriggerHandler.updateTyreInventoryStatus(newList, mapOfOldCollectionCards);
        ETT_CollectionCardTriggerHandler.sendMOConfirmedNotification(newList);
        ETT_CollectionCardTriggerHandler.createMoveOrderInOracle(objCC.Id);
        ETT_CollectionCardTriggerHandler.createMRInOracle(objCC.Id,system.today(),objCC.Name);
          
        test.stopTest();
    }
    
}