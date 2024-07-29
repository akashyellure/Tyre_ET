@isTest
public class ETT_DynamicLookupController_Test {
    
    @isTest static void getResultsTest(){
        List<Lead> leadList =  ETT_TestFactory.createLeads();
        insert leadList;
        ETT_DynamicLookupController.getResults('Lead', 'ETSALES_Lead_Rating__c', 'Hot');
    }
    
    @isTest static void getFilteredResultsTest(){
        
        List<Lead> leadList =  ETT_TestFactory.createLeads();
        insert leadList;
        List<ETT_Brand_Master__c> brandMastersList = ETT_TestFactory.createBrandMasters();
        List<ETT_Pattern_Master__c> patternMastersList = ETT_TestFactory.createPatternMasters();
        List<ETT_Tyre_Size_Master__c> tyreMasterSizeList =  ETT_TestFactory.createTyreSizeMaster();
        ETT_Country_Master__c cntry = ETT_TestFactory.createCountries('TestCountry');
        patternMastersList[0].ETT_Status__c = true;
        patternMastersList[0].Name = 'Test Record';
        insert cntry;
        brandMastersList[0].name = 'Test Record';
        system.debug('tyreMasterSizeList '+tyreMasterSizeList[0]);
        insert patternMastersList;
      

        //tyreMasterSizeList[0].ETT_Original_Pattern__c = patternMastersList[0].id;
         insert tyreMasterSizeList;
        insert brandMastersList;
        List<ETT_Tyre_Master__c> tyreMastersList = ETT_TestFactory.createTyreMasters('Draft', patternMastersList[0].Id,cntry.Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id);
        insert tyreMastersList[0];
        system.debug('brand'+[select id,name from ETT_Pattern_Master__c where Name LIKE '%%']);
        system.debug('res '+[SELECT Id, ETT_Tyre_Size__r.ETT_Status__c From ETT_Tyre_Master__c]);
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Actual_Width__c = 210.0,
            ETT_Bead_Adjustment__c = 2.0,
            ETT_Brand_Code__c = 'ALT',
            ETT_Brand_Name__c = brandMastersList[0].id,
            ETT_Country_Code__c = 'IND',
            ETT_Country_Name__c = cntry.id,
            ETT_Country_Status__c = false,
            ETT_Item_Code_Refurbished__c = 'TR-10.00-20-ALT',
            ETT_Item_Code_Scrap__c = 'TS-10.00-20-ALT',
            ETT_Item_Code_Used__c = 'TU-10.00-20-ALT',
            ETT_Length__c = 3.2,
            ETT_Load_Index__c = '146/142',
            ETT_Original_Pattern__c = patternMastersList[0].id,
            ETT_Ply_Rate__c = '16',
            ETT_Rim_Size__c = 20.0,
            ETT_Speed_Index__c = 'J',
            ETT_Status__c = false,
            ETT_Tyre_Radiues__c = '24',
            ETT_Tyre_Size__c = tyreMasterSizeList[0].id,
            ETT_Tyre_Status__c = false,
            ETT_Vehicle_Type__c = 'Bus');
        insert ett_tyre_master;
        system.debug('tyreMastersList '+tyreMastersList);
        ETT_DynamicLookupController.getFilteredResults('ETT_Tyre_Size_Master__c', 'ETT_Tyre_Size__c', '', '', '', '', '');
        ETT_DynamicLookupController.getFilteredResults('ETT_Country_Master__c', 'ETT_Country_Name__c', '', '', '', '', '');
        ETT_DynamicLookupController.getFilteredResults('ETT_Brand_Master__c', 'ETT_Brand_Name__c', '', '', '', '', '');
        ETT_DynamicLookupController.getFilteredResults('ETT_Pattern_Master__c', 'ETT_Original_Pattern__c', 'test', 'Test', '', '', '');
        
    }
}