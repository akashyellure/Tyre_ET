@isTest
public class ETT_LeadTriggerHandlerTest {
    @testSetup
    public static void setupdata(){
        Lead lead = new Lead(
            LastName = 'Aadil',
            Company = 'supcshtst thirtytwo',
            Street = 'Dubai',
            Phone = '523543454',
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
            ETT_Trade_License_Number__c = '5678765467897678',
            ETT_Trade_Licenses_Expiry_Date__c = Date.newInstance(2020,12,28),
            ETT_VAT_TRN__c = '657656343743322',
            ETT_isSupplierConvert__c = false,
            ETT_Final_Rejection__c = false);
        insert lead;
        
        lead.Status = 'Rejected';
        update lead;
        
        ETT_Staging_Quotation_Request__c ett_staging_quotation_request = new ETT_Staging_Quotation_Request__c(
            CurrencyIsoCode = 'AED',
            ETT_Accept_Quotation__c = false,
            ETT_Approve_Stage__c = 'Rejected',
            ETT_IS_Approved__c = false,
            ETT_Lead__c = lead.id,
            ETT_Max_Range__c = 175.0,
            ETT_Min_Range__c = 140.0,
            ETT_Purchase_Price__c = 0.0,
            ETT_Quantity__c = 1.0,
            ETT_Tyre_Life__c = 'New',
            ETT_HOO_Price_Acceptance__c = false,
            ETT_FM_Price_Acceptance__c = false);
        
        insert ett_staging_quotation_request;
        
       
        
    }
    @isTest
    public static void testCase1(){
        Lead lead = [SELECT status FROM Lead LIMIT 1];
        lead.Status = 'New';
        try{
             update lead;
        }catch(Exception e){
            
        }
    }
     @isTest
    public static void testCase2(){
        Lead lead = [SELECT status FROM Lead LIMIT 1];
        lead.Status = 'ReCall';
        try{
             update lead;
        }catch(Exception e){
            
        }
    }
     @isTest
    public static void testCase3(){
         ETT_Staging_Quotation_Request__c ett_staging_quotation_request = [SELECT ETT_Approve_Stage__c FROM ETT_Staging_Quotation_Request__c LIMIT 1];
        ett_staging_quotation_request.ETT_Approve_Stage__c = 'Approved';
        update ett_staging_quotation_request;
        Lead lead = [SELECT status FROM Lead LIMIT 1];
        lead.Status = 'Qualified';
        try{
             update lead;
        }catch(Exception e){
            
        }
    }
      @isTest
    public static void testCase4(){
         ETT_Staging_Quotation_Request__c ett_staging_quotation_request = [SELECT ETT_Approve_Stage__c FROM ETT_Staging_Quotation_Request__c LIMIT 1];
        ett_staging_quotation_request.ETT_Approve_Stage__c = 'Approved';
        update ett_staging_quotation_request;
        Lead lead = [SELECT status FROM Lead LIMIT 1];
        lead.Status = 'Pending for HOO Approval';
        try{
            update lead;
            lead.Status = 'New';
            update lead;
        }catch(Exception e){
            
        }
    }
      @isTest
    public static void testCase5(){
         ETT_Staging_Quotation_Request__c ett_staging_quotation_request = [SELECT ETT_Approve_Stage__c FROM ETT_Staging_Quotation_Request__c LIMIT 1];
        ett_staging_quotation_request.ETT_Approve_Stage__c = 'Approved';
        update ett_staging_quotation_request;
        Lead lead = [SELECT status FROM Lead LIMIT 1];
        lead.Status = 'Qualified';
        try{
             update lead;
            ETT_LeadTriggerHandler.qualifiedLeadsConvertProcess(new List<String>{lead.id});
        }catch(Exception e){
            
        }
    }
}