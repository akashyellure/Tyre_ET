@isTest 

Public Class ETT_DeliveryNote_PDF_Controllertest{
    
    @isTest
    Public static void Codecoverage(){
        
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
       
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert opp;
        
        Contact con=new Contact();
        con.LastName = 'Test';
        // con.AccountId=opp.AccountId;
        insert con;
        
        ETT_Delivery_Note__c ett_delivery_note = new ETT_Delivery_Note__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = objAcc1.id,
            ETT_Is_Delivery_Appointment_Booked__c = false);
        insert ett_delivery_note;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = objAcc1.Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
        objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        objIC.ETT_Collection_Card__c = ett_collection_card.Id;
        objIC.ETT_Status__c = 'Accept';
        insert objIC;
        
        ETT_Delivery_Line_Item__c ett_delivery_line_item = new ETT_Delivery_Line_Item__c(
            CurrencyIsoCode = 'AED',
            ETT_Collection_Card__c = ett_collection_card.id,
            ETT_Delivery_Note__c = ett_delivery_note.id,
            ETT_Inspection_Card__c = objIC.id,
            ETT_Is_Checked__c = false,
            ETT_Job_Type__c = 'Retread');
        insert ett_delivery_line_item;
        
        ApexPages.StandardController controlr=new ApexPages.StandardController(ett_delivery_note);
        ApexPages.currentPage().getParameters().put('id',ett_delivery_note.id);
        ETT_DeliveryNote_PDF_Controller deiveryNote = new ETT_DeliveryNote_PDF_Controller(controlr);        
        
    }
}