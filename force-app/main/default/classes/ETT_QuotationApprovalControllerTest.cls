@isTest
public class ETT_QuotationApprovalControllerTest {
    
    @testSetup 
    static void testDataSetup(){
        
        Lead leadObj = new Lead(
            LastName = 'Aadil',
            Company = 'supcshtst thirtytwo',
            Street = 'Dubai',
            Phone = '45656364',
            MobilePhone = '523543454',
            Status = 'New',
            CurrencyIsoCode = 'AED',
            HasOptedOutOfEmail = false,
            IsUnreadByOwner = false,
            DoNotCall = false,
            HasOptedOutOfFax = false,
            pi__Needs_Score_Synced__c = false,
            pi__pardot_hard_bounced__c = false,
            et4ae5__HasOptedOutOfMobile__c = false,
            et4ae5__Mobile_Country_Code__c = 'US',
            Duplicate_Lead__c = false,
            ETSALES_Country_Code_Company__c = 'UAE(+971)',
            ETSALES_ISD_Country_Code_Contact__c = 'UAE(+971)',
            ETSALES_Lead_Created__c = true,
            ETT_Fleet_Inspection_Required__c = false,
            ETT_Government__c = false,
            ETT_LLC__c = false,
            ETT_Lead_Approval_Stage__c = 'New',
            ETT_Party_Type__c = 'Supplier',
            ETT_Payment_Type__c = 'Cash',
            ETT_Scrap_Inspection_Required__c = false,
            ETT_Test_Tyre_Required__c = false,
            ETT_Trade_License_Number__c = '567876546789767',
            ETT_Trade_Licenses_Expiry_Date__c = Date.newInstance(2020,12,28),
            ETT_VAT_TRN__c = '657656343743322',
            ETT_isSupplierConvert__c = false,
            ETT_Final_Rejection__c = false);
        
        insert leadObj;
        
        leadObj.Status = 'Rejected';
        update leadObj;
        
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master = new ETT_Tyre_Size_Master__c(
            Name = '10.00-20',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '10.00 - 20 TRUCK TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = 'ALTURA',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Code__c = 'ALT',
            ETT_Status__c = true);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = 'ROAD TUF',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'ALTURA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'INDIA',
            CurrencyIsoCode = 'AED',
            ETT_Country_Code__c = 'IND',
            ETT_Status__c = true);
        
        insert ett_country_master;
        Id devRecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Draft').getRecordTypeId();
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            recordtypeId = devRecordTypeId,
            ETT_Tyre_Size__c = ett_tyre_size_master.id,
            ETT_Country_Name__c = ett_country_master.id,
            ETT_Lead__c = leadObj.id,
            ETT_Original_Pattern__c = ett_pattern_master.id,
            ETT_Brand_Name__c = ett_brand_master.id,
            CurrencyIsoCode = 'AED',
            ETT_Actual_Width__c = 210.0,
            ETT_Bead_Adjustment__c = 2.0,
            ETT_Brand_Code__c = 'ALT',
            ETT_Country_Code__c = 'IND',
            ETT_Country_Status__c = false,
            ETT_Item_Code_Refurbished__c = 'TR-10.00-20-ALT',
            ETT_Item_Code_Scrap__c = 'TS-10.00-20-ALT',
            ETT_Item_Code_Used__c = 'TU-10.00-20-ALT',
            ETT_Length__c = 3.2,
            ETT_Load_Index__c = '146/142',
            ETT_Ply_Rate__c = '16',
            ETT_Rim_Size__c = 20.0,
            ETT_Speed_Index__c = 'J',
            ETT_Status__c = true,
            ETT_Tyre_Radiues__c = '24',
            ETT_Tyre_Status__c = false,
            ETT_Vehicle_Type__c = 'Bus');
        
        insert ett_tyre_master;
        
        ETT_Staging_Quotation_Request__c ett_staging_quotation_request = new ETT_Staging_Quotation_Request__c(
            
            CurrencyIsoCode = 'AED',
            ETT_Accept_Quotation__c = false,
            ETT_Approve_Stage__c = 'Rejected',
            ETT_Brand__c = ett_brand_master.id,
            ETT_Country__c = ett_country_master.id,
            ETT_IS_Approved__c = false,
            ETT_Lead__c = leadObj.id,
            ETT_Max_Range__c = 175.0,
            ETT_Min_Range__c = 140.0,
            ETT_Pattern__c = ett_pattern_master.id,
            ETT_Purchase_Price__c = 0.0,
            ETT_Quantity__c = 1.0,
            ETT_Tyre_Life__c = 'New',
            ETT_Tyre_Size_Master__c = ett_tyre_size_master.id,
            ETT_HOO_Price_Acceptance__c = false,
            ETT_FM_Price_Acceptance__c = false);
        insert ett_staging_quotation_request;
    }
    @isTest
    static void testCase1(){
        Lead leadObj = [SELECT id FROM lead LIMIt 1];
        ETT_Tyre_Master__c ett_tyre_master = [SELECT ETT_Actual_Width__c, ETT_Bead_Adjustment__c, ETT_Brand_Code__c,
                                              ETT_Country_Code__c, ETT_Country_Status__c, ETT_Item_Code_Refurbished__c,
                                              ETT_Item_Code_Scrap__c, ETT_Item_Code_Used__c, ETT_Length__c, ETT_Load_Index__c, 
                                              ETT_Ply_Rate__c, ETT_Rim_Size__c, ETT_Speed_Index__c, ETT_Status__c, ETT_Tyre_Radiues__c,
                                              ETT_Tyre_Status__c, ETT_Vehicle_Type__c, recordtypeId, ETT_Tyre_Size__c, ETT_Country_Name__c,
                                              ETT_Lead__c, ETT_Original_Pattern__c, ETT_Brand_Name__c, CurrencyIsoCode
                                              FROM ETT_Tyre_Master__c LIMIT 1];
        
        ett_tyre_master.RecordTypes__c = 'Approve';
        ett_tyre_master.ETT_Status__c = true;
        
        Map<String, String> mapObj = new Map<String, String>();
        mapObj.put('stgTyreMasterJson', JSON.serialize(new List<ETT_Tyre_Master__c>{ett_tyre_master}));
        mapObj.put('leadId', JSON.serialize(leadObj.id));
        Test.startTest();
        // ETT_QuotationApprovalController.getRecordTypeIdbyName('Account', 'Test');
        ETT_QuotationApprovalController.getTyreMasterDetails(leadObj.id);
        ETT_QuotationApprovalController.approveTyreMasterDetails(mapObj, leadObj.id);
        Test.stopTest();
    }
    
    @isTest
    static void testcase2(){
        Lead ld = [SELECT status, id, RecordTypeId FROM Lead LIMIt 1];
        ld.Status = 'Qualified';
        update ld;
        Test.startTest();
        
        ETT_QuotationApprovalController.getSubmittedRecords(ld.id);
        String result = ETT_QuotationApprovalController.getObjectName(ld.id);
        ETT_QuotationApprovalController.lstUsedTyreCasingPrices();
         //ETT_QuotationApprovalController.approveLeadProcess(ld.id);
        ETT_QuotationApprovalController.getselectOptions(ld, 'Status');
        Test.stopTest();
        System.assert(result == 'lead');
        
    }
    
    @isTest
    static void testcase3(){
        Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('ET Tyre').getRecordTypeId();
        Lead ld = [SELECT status, id FROM Lead LIMIt 1];
        ld.Status = 'Qualified';
        ld.RecordTypeId = devRecordTypeId;
        update ld;
        ETT_Staging_Quotation_Request__c ett_staging_quotation_request1 = [SELECT id FROM ETT_Staging_Quotation_Request__c LIMIt 1];
        ETT_Staging_Quotation_Request__c ett_staging_quotation_request = new ETT_Staging_Quotation_Request__c(
            id = ett_staging_quotation_request1.Id,
            CurrencyIsoCode = 'AED',
            ETT_Accept_Quotation__c = false,
            ETT_Approve_Stage__c = 'Rejected',
            ETT_IS_Approved__c = false,
            ETT_Lead__c = ld.id,
            ETT_Max_Range__c = 175.0,
            ETT_Min_Range__c = 140.0,
            ETT_Purchase_Price__c = 0.0,
            ETT_Quantity__c = 1.0,
            ETT_Tyre_Life__c = 'New',
            ETT_HOO_Price_Acceptance__c = false,
            ETT_FM_Price_Acceptance__c = false);
        
        Map<String, String> mapObj = new Map<String, String>();
        mapObj.put('stgLeadJson', JSON.serialize(ld));  
        mapObj.put('stgQuoteJson', JSON.serialize(new List<ETT_Staging_Quotation_Request__c>{ett_staging_quotation_request}));
        Test.startTest();
        ETT_QuotationApprovalController.updateStgQuotation(mapObj);
        
        Test.stopTest();
        //System.assert(result == 'lead');
        
    }
    @isTest
    public static void testCase4(){
        Lead ld = [SELECT status, id, RecordTypeId FROM Lead LIMIt 1];
        Test.startTest();
        ETT_QuotationApprovalController.strLeadConvertProcess(ld);
        Test.stopTest();
    }
     @isTest
    public static void testCase5(){
        Lead ld = [SELECT status, id, RecordTypeId FROM Lead LIMIt 1];
        ld.MobilePhone = '+971 548754584';
        ld.Status = 'Qualified';
        ld.Phone = '+971 548754584';
        ld.ETT_Chamber_of_Comm_Cert_Expiry_Date__c = System.today()+8;
        ld.ETT_Trade_Licenses_Expiry_Date__c = System.today()+8;
        Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        ld.RecordTypeId = devRecordTypeId;
        update ld;
        Test.startTest();
        ETT_QuotationApprovalController.strLeadConvertProcess(ld);
        Test.stopTest();
    }
     @isTest
    public static void testCase6(){
        Lead ld = [SELECT status, id, RecordTypeId FROM Lead LIMIt 1];
        ld.MobilePhone = '+971 548754584';
        ld.Phone = '+971 548754584';
        ld.ETT_Emirates_Id__c  = '784-8745-9854785-8';
        ld.ETT_Chamber_of_Comm_Cert_Expiry_Date__c = System.today()+8;
        ld.ETT_Trade_Licenses_Expiry_Date__c = System.today()+8;
        ld.Status = 'Qualified';
        Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre Cash Individual').getRecordTypeId();
        ld.RecordTypeId = devRecordTypeId;
        update ld;
        Test.startTest();
        ETT_QuotationApprovalController.strLeadConvertProcess(ld);
        Test.stopTest();
    }
    
     @isTest
    public static void testCase7(){
        Lead ld = [SELECT status, id, RecordTypeId FROM Lead LIMIt 1];
        ld.MobilePhone = '+971 548754584';
        ld.Status = 'Qualified';
        ld.Phone = '+971 548754584';
        ld.ETT_Chamber_of_Comm_Cert_Expiry_Date__c = System.today()+8;
        ld.ETT_Trade_Licenses_Expiry_Date__c = System.today()+8;
        Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        ld.RecordTypeId = devRecordTypeId;
        update ld;
        Test.startTest();
        ETT_QuotationApprovalController.strLeadConvertProcess(ld);
        Test.stopTest();
    }
    
     @isTest
    public static void testCase8(){
        Lead ld = [SELECT status, id, RecordTypeId FROM Lead LIMIt 1];
        ld.MobilePhone = '+971 548754584';
        ld.Status = 'Qualified';
        ld.Phone = '+971 548754584';
        ld.ETT_Chamber_of_Comm_Cert_Expiry_Date__c = System.today()+8;
        ld.ETT_Trade_Licenses_Expiry_Date__c = System.today()+8;
        Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Credit/B2B Supplier').getRecordTypeId();
        ld.RecordTypeId = devRecordTypeId;
        update ld;
        Test.startTest();
        ETT_QuotationApprovalController.strLeadConvertProcess(ld);
        Test.stopTest();
    }
    
    @isTest
    public static void testCase9(){
        ETT_QuotationApprovalController.coverage();
    }
    
}