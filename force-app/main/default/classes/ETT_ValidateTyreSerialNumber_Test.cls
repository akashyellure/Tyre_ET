@isTest
public class ETT_ValidateTyreSerialNumber_Test {
    
 public static testMethod void ETT_JobCardListControllerTest_Buffing_Accepted() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Organization');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days'
        );
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Actual_Width__c = 210.0,
            ETT_Bead_Adjustment__c = 2.0,
            ETT_Brand_Code__c = 'ALT',
            ETT_Brand_Name__c = ett_brand_master.id,
            ETT_Country_Code__c = 'IND',
            ETT_Country_Name__c = ett_country_master.id,
            ETT_Country_Status__c = false,
            ETT_Item_Code_Refurbished__c = 'TR-10.00-20-ALT',
            ETT_Item_Code_Scrap__c = 'TS-10.00-20-ALT',
            ETT_Item_Code_Used__c = 'TU-10.00-20-ALT',
            ETT_Length__c = 3.2,
            ETT_Load_Index__c = '146/142',
            ETT_Original_Pattern__c = ett_pattern_master.id,
            ETT_Ply_Rate__c = '16',
            ETT_Rim_Size__c = 20.0,
            ETT_Speed_Index__c = 'J',
            ETT_Status__c = false,
            ETT_Tyre_Radiues__c = '24',
            ETT_Tyre_Size__c = ett_tyre_size_master.id,
            ETT_Tyre_Status__c = false,
            ETT_Vehicle_Type__c = 'Bus');
        insert ett_tyre_master;
        
        ETT_Pricing_Information__c ett_pricing_information = new ETT_Pricing_Information__c(
            CurrencyIsoCode = 'AED',
            ETT_Tyre_Size__c = ett_tyre_size_master.id,
            ETT_Brand__c = ett_brand_master.id,
            ETT_Pattern__c = ett_pattern_master.id,
            ETT_Country_of_Origin__c = ett_country_master.id,
            ETT_Approval_Status__c = 'In Progress',
            ETT_Purchase_Price__c = 500.0,
            ETT_Price__c= ett_price_master.id);
        
    // insert ett_pricing_information;
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Not Inspected';
       objIC.ETT_Account__c = acc[0].id;
       insert objIC;
     ETT_Inspection_Card__c objIC2 = [select Id, ETT_Status__c,ETT_Collection_Card__c from ETT_Inspection_Card__c limit 1];
        
        objIC2.ETT_Status__c = 'Accept';
        objIC2.ETT_Brand__c = ett_brand_master.Id;
        update objIC2; 
 }
   
  
}