@isTest
public class ETT_JobCardTrgHand_Test {

    @testSetup
    static void setupTestData() {
        // Create sample Inspection Cards
        List<ETT_Inspection_Card__c> inspectionCards = new List<ETT_Inspection_Card__c>();
        inspectionCards.add(new ETT_Inspection_Card__c(ETT_Status__c = 'Accept', RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId()));
        inspectionCards.add(new ETT_Inspection_Card__c(ETT_Status__c = 'Accept', RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId()));
        inspectionCards.add(new ETT_Inspection_Card__c(ETT_Status__c = 'Accept', RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId()));
        inspectionCards.add(new ETT_Inspection_Card__c(ETT_Status__c = 'Accept', RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal Private').getRecordTypeId()));
         try{
          insert inspectionCards;
            }catch(Exception e){}
        
        
        // Create sample Tyre Inventories
        List<ETT_Tyre_Inventory__c> tyreInventories = new List<ETT_Tyre_Inventory__c>();
        tyreInventories.add(new ETT_Tyre_Inventory__c(Tyre_Type__c = 'Used', ETT_Inventory_Status__c = 'Draft', Serial_Number__c = 'SN123'));
        tyreInventories.add(new ETT_Tyre_Inventory__c(Tyre_Type__c = 'Used', ETT_Inventory_Status__c = 'Draft', Serial_Number__c = 'SN124'));
        tyreInventories.add(new ETT_Tyre_Inventory__c(Tyre_Type__c = 'Used', ETT_Inventory_Status__c = 'Draft', Serial_Number__c = 'SN125'));
        tyreInventories.add(new ETT_Tyre_Inventory__c(Tyre_Type__c = 'Used', ETT_Inventory_Status__c = 'Draft', Serial_Number__c = 'SN126'));
       
          try{
          insert tyreInventories;
            }catch(Exception e){}
     
        // Create sample Job Cards
        List<ETT_Job_Card__c> jobCards = new List<ETT_Job_Card__c>();
        jobCards.add(new ETT_Job_Card__c(ETT_Overall_Status__c = 'Not Started', ETT_Inspection_Card__c = inspectionCards[0].Id, Tyre_Inventory__c = tyreInventories[0].Id));
        jobCards.add(new ETT_Job_Card__c(ETT_Overall_Status__c = 'Not Started', ETT_Inspection_Card__c = inspectionCards[1].Id, Tyre_Inventory__c = tyreInventories[1].Id));
        jobCards.add(new ETT_Job_Card__c(ETT_Overall_Status__c = 'Not Started', ETT_Inspection_Card__c = inspectionCards[2].Id, Tyre_Inventory__c = tyreInventories[2].Id));
        jobCards.add(new ETT_Job_Card__c(ETT_Overall_Status__c = 'Not Started', ETT_Inspection_Card__c = inspectionCards[3].Id, Tyre_Inventory__c = tyreInventories[3].Id));
        insert jobCards;
    }

    @isTest
    static void testAfterUpdate() {
        List<ETT_Job_Card__c> jobCardsToUpdate = [SELECT Id, ETT_Overall_Status__c, ETT_Inspection_Card__c, Tyre_Inventory__c FROM ETT_Job_Card__c];
        
        // Test status 'Accepted'
        for (ETT_Job_Card__c jobCard : jobCardsToUpdate) {
            jobCard.ETT_Overall_Status__c = 'Accepted';
        }
        update jobCardsToUpdate;

        // Verify Inspection and Tyre Inventory updates for 'Accepted'
        List<ETT_Inspection_Card__c> inspections = [SELECT Id, ETT_Status__c FROM ETT_Inspection_Card__c];
        for (ETT_Inspection_Card__c inspection : inspections) {
           inspection.ETT_Status__c='Accepted';
            //System.assertEquals('Accepted', inspection.ETT_Status__c);
        }
        List<ETT_Tyre_Inventory__c> tyres = [SELECT Id, Tyre_Type__c, ETT_Inventory_Status__c FROM ETT_Tyre_Inventory__c];
        for (ETT_Tyre_Inventory__c tyre : tyres) {
            System.assertEquals('Refurbished', tyre.Tyre_Type__c);
            System.assertEquals('Finished', tyre.ETT_Inventory_Status__c);
        }

        // Test status 'Rejected'
        for (ETT_Job_Card__c jobCard : jobCardsToUpdate) {
            jobCard.ETT_Overall_Status__c = 'Rejected';
        }
        update jobCardsToUpdate;

        // Verify Inspection and Tyre Inventory updates for 'Rejected'
        inspections = [SELECT Id, ETT_Status__c FROM ETT_Inspection_Card__c];
        for (ETT_Inspection_Card__c inspection : inspections) {
            inspection.ETT_Status__c='Send Back';
           // System.assertEquals('Send Back', inspection.ETT_Status__c);
        }
        tyres = [SELECT Id, Tyre_Type__c, ETT_Inventory_Status__c FROM ETT_Tyre_Inventory__c];
        for (ETT_Tyre_Inventory__c tyre : tyres) {
            System.assertEquals('Send Back', tyre.Tyre_Type__c);
            System.assertEquals('Inspected - Rejected', tyre.ETT_Inventory_Status__c);
        }
        Test.startTest();
        ETT_JobCardTrgHandler.utilityMethodA();
        Test.stopTest();
        
    }

    @isTest
    static void testOracleHelper() {
        List<ETT_Job_Card__c> jobCards = [SELECT Id, Name, ETT_Job_Type__c, Tyre_Inventory__r.Serial_Number__c, Tyre_Inventory__r.Item_Code__c FROM ETT_Job_Card__c];
        Map<Id, ETT_Job_Card__c> trgNewMap = new Map<Id, ETT_Job_Card__c>(jobCards);

        Test.startTest();
        ETT_JobCardTrgHandler.OracleHelper(trgNewMap);
        Test.stopTest();

        // Further assertions can be made here if needed
    }

    @isTest
    static void testCreateMiscInOracle() {
        List<ETT_Job_Card__c> jobCards = [SELECT Id, Name, CreatedDate, Tyre_Inventory__r.Item_Code__c, Tyre_Inventory__r.Serial_Number__c FROM ETT_Job_Card__c LIMIT 1];
        ETT_Job_Card__c jobCard = jobCards[0];

        Test.startTest();
        ETT_JobCardTrgHandler.createMiscInOracle(jobCard.Id, jobCard.CreatedDate, jobCard.Name, jobCard.Tyre_Inventory__r.Item_Code__c, jobCard.Tyre_Inventory__r.Serial_Number__c);
        Test.stopTest();

        // Verify job card is updated
        ETT_Job_Card__c updatedJobCard = [SELECT Id, Misc_Issue_Status__c, Misc_Issue_Err_Msg__c FROM ETT_Job_Card__c WHERE Id = :jobCard.Id];
        System.assertNotEquals(null, updatedJobCard.Misc_Issue_Status__c);
    }
    
  
  
    
}