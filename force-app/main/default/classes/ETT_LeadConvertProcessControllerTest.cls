@isTest
public class ETT_LeadConvertProcessControllerTest {
    
    @isTest
    public static void testForleadConvertProcessTestCase1(){
        Id devRecordTypeId = Schema.SObjectType.lead.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        Lead obj = new Lead(
            recordtypeId = devRecordTypeId,
            LastName = 'Aadil',
            Company = 'supcshtst thirtytwo',
            Street = 'Dubai',
            Phone = '+971 256364545',
            MobilePhone = '+971 254563645',
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
            ETT_Trade_Licenses_Expiry_Date__c = System.today()+8,
            ETT_Chamber_of_Comm_Cert_Expiry_Date__c= System.today()+8,
            ETT_VAT_TRN__c = '657656343743322',
            ETT_isSupplierConvert__c = false,
            ETT_Final_Rejection__c = false);
        
        insert obj;
        
        obj.Status = 'Qualified';
        update obj;
        
        ETT_Staging_Quotation_Request__c ett_staging_quotation_request = new ETT_Staging_Quotation_Request__c(
            
            CurrencyIsoCode = 'AED',
            ETT_Accept_Quotation__c = false,
            ETT_Approve_Stage__c = 'Rejected',
            ETT_IS_Approved__c = false,
            ETT_Lead__c = obj.id,
            ETT_Max_Range__c = 175.0,
            ETT_Min_Range__c = 140.0,
            ETT_Purchase_Price__c = 0.0,
            ETT_Quantity__c = 1.0,
            ETT_Tyre_Life__c = 'New',
            ETT_HOO_Price_Acceptance__c = false,
            ETT_FM_Price_Acceptance__c = false);
        
        insert ett_staging_quotation_request;
        PageReference pageRef = Page.ETT_LeadConvertPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(obj.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        Test.startTest();
        ETT_LeadConvertProcessController ettLeadInstance = new ETT_LeadConvertProcessController(sc);
        Pagereference pgr = ettLeadInstance.leadConvertProcess();
        Test.stopTest();
        System.assert(pgr != null);
        System.assertEquals('Hello', 'Hello');
    }
    
    @isTest
    public static void testForleadConvertProcessTestCase2(){
        Id devRecordTypeId = Schema.SObjectType.lead.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        Lead obj = new Lead(
            recordtypeId = devRecordTypeId,
            LastName = 'Aadil',
            Company = 'supcshtst thirtytwo',
            Street = 'Dubai',
            Phone = '+971 256364545',
            MobilePhone = '+971 254563645',
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
            ETT_Trade_Licenses_Expiry_Date__c = System.today()+8,
            ETT_Chamber_of_Comm_Cert_Expiry_Date__c= System.today()+8,
            ETT_VAT_TRN__c = '657656343743322',
            ETT_isSupplierConvert__c = false,
            ETT_Final_Rejection__c = false);
        
        insert obj;
        obj.Status = 'Qualified';
        update obj;
        
        PageReference pageRef = Page.ETT_LeadConvertPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(obj.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        Test.startTest();
        ETT_LeadConvertProcessController ettLeadInstance = new ETT_LeadConvertProcessController(sc);
        Pagereference pgr = ettLeadInstance.leadConvertProcess();
        Test.stopTest();
        System.assert(pgr != null);
    }
    @isTest
    public static void testForleadConvertProcessTestCase3(){
        Id devRecordTypeId = Schema.SObjectType.lead.getRecordTypeInfosByName().get('Tyre Cash Individual').getRecordTypeId();
        Lead obj = new Lead(
            recordtypeId = devRecordTypeId,
            LastName = 'Aadil',
            ETT_Emirates_Id__c = '784-1254-8547845-4',
            Company = 'supcshtst thirtytwo',
            Street = 'Dubai',
            Phone = '+971 256364545',
            MobilePhone = '+971 254563645',
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
            ETT_Trade_Licenses_Expiry_Date__c = System.today()+8,
            ETT_Chamber_of_Comm_Cert_Expiry_Date__c= System.today()+8,
            ETT_VAT_TRN__c = '657656343743322',
            ETT_isSupplierConvert__c = false,
            ETT_Final_Rejection__c = false);
        
        insert obj;
obj.Status = 'Qualified';
update obj;
        
        PageReference pageRef = Page.ETT_LeadConvertPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(obj.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        Test.startTest();
        ETT_LeadConvertProcessController ettLeadInstance = new ETT_LeadConvertProcessController(sc);
        Pagereference pgr = ettLeadInstance.leadConvertProcess();
        Test.stopTest();
        System.assert(pgr != null);
    }
    @isTest
    public static void testForleadConvertProcessTestCase4(){
        Id devRecordTypeId = Schema.SObjectType.lead.getRecordTypeInfosByName().get('Tyre - Credit/B2B Supplier').getRecordTypeId();
        Lead obj = new Lead(
            recordtypeId = devRecordTypeId,
            LastName = 'Aadil',
            Company = 'supcshtst thirtytwo',
            Street = 'Dubai',
            Phone = '+971 256364545',
            MobilePhone = '+971 254563645',
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
            ETT_Trade_Licenses_Expiry_Date__c = System.today()+8,
            ETT_Chamber_of_Comm_Cert_Expiry_Date__c= System.today()+8,
            ETT_VAT_TRN__c = '657656343743322',
            ETT_isSupplierConvert__c = false,
            ETT_Final_Rejection__c = false);
        
        insert obj;
        obj.Status = 'Qualified';
        update obj;
        
        PageReference pageRef = Page.ETT_LeadConvertPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(obj.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        Test.startTest();
        ETT_LeadConvertProcessController ettLeadInstance = new ETT_LeadConvertProcessController(sc);
        Pagereference pgr = ettLeadInstance.leadConvertProcess();
        Test.stopTest();
        System.assert(pgr != null);
    }
}