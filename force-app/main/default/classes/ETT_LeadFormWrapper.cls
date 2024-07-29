/** 
Created By   : G.Krishnareddy
Created Date : 1/19/2020
Description  : This is Account Opening Form Wrapper
*/

//public with sharing class ETT_LeadFormWrapper {
public with sharing class ETT_LeadFormWrapper {
    
    @AuraEnabled  public list<ETT_Staging_Contacts__c> lstContactInfo ;
    @AuraEnabled  public list<ETT_Staging_Customer_Vehicle_Details__c> lstCustomerVehicleInfo ;
    @AuraEnabled  public list<ETT_Staging_Quotation_Request__c> lstQuotationRequestInfo ;   
    @AuraEnabled  public Lead leadObj; 
    
    
    //This is Contact Wrapper Information
    public class ContactInformation {
        @AuraEnabled public  integer conCount {get;set;}
        @AuraEnabled public  string conName {get;set;}
        @AuraEnabled public  string conDesignation {get;set;}   
        @AuraEnabled public  string conEmail {get;set;}
        @AuraEnabled public  string conMobile {get;set;}
    }
    
    //This is LPO Wrapper Information
    public class LPOWrapper {
        @AuraEnabled public  Integer lpoCount{get;set;}
        @AuraEnabled public  string lpoName{get;set;}
        @AuraEnabled public  string lpoDesignation{get;set;}
        @AuraEnabled public  string lpoSignature{get;set;}
        @AuraEnabled  public  string lpoSignInPersonName{get;set;}
    }
    
    //This is Trade References Wrapper Information 
    public class TradeReferenceWrapper { 
        @AuraEnabled public  Integer tradeCount{get;set;}
        @AuraEnabled public  string tradeSupplierName{get;set;}
        @AuraEnabled public  string tradeLengthOfRelationShip{get;set;}
        @AuraEnabled public  Decimal tradeCreditLimit{get;set;}
        @AuraEnabled public  string tradePaymentTerms{get;set;}
    }
    
    //This is Bank Reference Wrapper Information
    public class BankReferenceWrapper{
        @AuraEnabled public  Integer bankCount{get;set;}
        @AuraEnabled public  string bankRefName{get;set;}
        @AuraEnabled public  string bankRefAddress{get;set;}
        @AuraEnabled public  string bankRefAcctNum{get;set;}
        @AuraEnabled public  string bankRefStartsWith{get;set;}
    }
    
    // This is Customer Vehicle wrapper Information
    public class CustomerVehicleWrapper {
        @Auraenabled public Integer vehicleCount {get;set;} 
        @Auraenabled public string vehicleType {get;set;}
        @Auraenabled public string vehicleConfiguration {get;set;}
        @Auraenabled public string axilConfiguration {get;set;}
        @Auraenabled public string application {get;set;}
        @Auraenabled public Decimal vehiclesInFleet {get;set;}
        @Auraenabled public Decimal tyresInFleet {get;set;} 
        @Auraenabled public Decimal kmsCoveredYearly {get;set;}
    }
    
    //Purchase Information Wrapper
    public class PurchaseInformationWrapper{
        @Auraenabled public Integer purchaseCount {get;set;}
        @Auraenabled public string tyreSize {get;set;}
        @Auraenabled public string strtype {get;set;}
        @Auraenabled public string brand {get;set;}
        @Auraenabled public Decimal yearlyQty {get;set;}
        @Auraenabled public Decimal price {get;set;}
        @Auraenabled public string paymentTerms {get;set;}
        @Auraenabled public string vehicleType {get;set;}
        @Auraenabled public Decimal creditLimit {get;set;}
        @Auraenabled public string authorisedPerson {get;set;}
    }
    
    //Added Services Wrapper
    public class AddedServiceWrapper{
        @Auraenabled public Integer addedServiceCount{get;set;}
        @Auraenabled public string services{get;set;}
        @Auraenabled public boolean isOwn{get;set;}
        @Auraenabled public boolean isOutSource{get;set;}
        @Auraenabled public string detailsOfSupplier{get;set;}
    }
    
    //Quotation Request Wrapper
    /*public class QuotationRequestWrapper{
        @Auraenabled public string tyreSize;
        @Auraenabled public string qty;
        @Auraenabled public string retreadingCharges;
        @Auraenabled public string stockRetreadingCharges;
    }*/
    
    
}