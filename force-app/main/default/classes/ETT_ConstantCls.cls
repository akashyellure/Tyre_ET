/*
Created Date:1/15/2020
Created By  :G.Krishnareddy
Description :We are maintaing the Constant Information for the entire ET Tyre Project.
*/
public class ETT_ConstantCls {
    //Ths Constant variable used for whenever that approval takes place then we need to compare and do that business logic part.
    public static final string strApproveStatus = 'Approved';
    public static final string strFMProfile = 'ETT_Factory Manager';
    public static final string quoteApproveField = 'ETT_IS_Approved__c';
    public static final boolean quoteApproved = true;
    //This is On Lead Converion we need to update that Related Information Lead to Account.So this field indocates to the same.
    public static final string strLeadConverionObjectField = 'ETT_Account__c';
    //This is after doing the update success track.
    public static final string strSucces = 'Success';
    //This is after doing the update failure track.
    public static final string strFailure = 'Object fields that affected this error: ';
    //This is tracking for Lead is not Qualified status
    public static final string strLeadNotqulifiedStatus = 'This Lead is not a Qualified Lead';
    //This is Error Log storage for salesforce any Object has failure then we are tracking the Object Name and Field Information. 
    public static final string strClassNameMethod = 'Class Name :ETT_LeadConvertProcessController'+' Method Name :leadConvertProcess';
    
    //This is for Refer as Lead is in Working progress
    public static final string strLeadStatus= 'Working';
    
    //This is for Fetching the Information from Sobject.
    public final static string conExternalConRecordTypeId = '';
    
    //This is for Fetching the Information from Sobject.
    public final static string conInternalConRecordTypeId = '';
    //Lead Object    
    public final static string strLeadObject = 'Lead';
    //
    public final static string strPurchaseInfoObject = 'ETT_Staging_Purchase_Information__c';
    //This is Staging Added Services Object
    public final static string strAddedServicesObject = 'ETT_Staging_Added_Service__c';
    //This is Staging Contact Object
    public final static string strStagingContactObject = 'ETT_Staging_Contacts__c';
    //This is Staging Bank Reference Object
    public final static string strStagingBankRefrenceObject = 'ETT_Staging_Bank_Reference__c';
    //This is Staging Customer LPO Object  
    public final static string strStagingCustomerLPOObject = 'ETT_Staging_Customer_LPO__c';
    //This is Staging Customer Vehicle Details
    public final static string strStagingCustomerVehicleDetailsObject = 'ETT_Staging_Customer_Vehicle_Details__c';
    //This is Staging Quotation Request Details
    public final static string strStagingQuotationReqObject = 'ETT_Staging_Quotation_Request__c';
    //This is Staging Trade References Details
    public final static string strStagingTradeReferencesObject = 'ETT_Staging_Trade_Reference__c';  
    //Query Field 
    public final static string strQueryFilter = 'ETT_Lead__c';

    //Query Added Services Fields
    public final static string strLeadQueryFields = 'IsDeleted, MasterRecordId, LastName, FirstName, Salutation, MiddleName, Suffix, Name, RecordTypeId, Title, Company, Street, City, State, PostalCode, Country, Latitude, Longitude, GeocodeAccuracy, Address, Phone, MobilePhone, Fax, Email, Website, PhotoUrl, Description, LeadSource, Status, Industry, Rating, AnnualRevenue, NumberOfEmployees, OwnerId, IsConverted, ConvertedDate, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId, IsUnreadByOwner, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, DoNotCall, HasOptedOutOfFax, LastViewedDate, LastReferencedDate, LastTransferDate, Jigsaw, JigsawContactId, EmailBouncedReason, EmailBouncedDate, IndividualId, ETT_Chamber_of_Commerce_Certification_No__c, ETT_Customer_Type__c, ETT_Emirate__c, ETT_Legal_Status__c, ETT_Location__c, ETT_Name_of_Chief_Executive_Officer__c, ETT_Name_of_Company__c, ETT_Name_of_Owners_Sponsors__c, ETT_Nature_of_Business__c, ETT_P_O_Box__c, ETT_Trade_License_Number__c, ETT_Trade_Licenses_Expiry_Date__c,ETT_VAT_TRN__c, ETT_Test_Tyre_Required__c, ETT_Expected_Retread_Millage__c, ETT_Recomended_Retreaded_Process__c, ETT_Fax__c, ETT_Payment_Terms__c, ETT_Chamber_of_Comm_Cert_Expiry_Date__c, ETT_Owner_Phone1__c, ETT_Sole_Proprietorship__c, ETT_Partnership__c, ETT_LLC__c, ETT_Designation__c, ETT_Government__c, ETT_Sponsor_Name__c, ETT_Web_Address__c, ETT_Credit_Limit__c, ETT_Quote_No__c, ETT_Quote_Date__c, Sales_Person_Name__c, ETT_Sales_Person_Email__c, ETT_Lead_Approval_Stage__c, ETT_Fleet_Inspection_Required__c, ETT_Scrap_Inspection_Required__c, ETT_Account_Number__c, ETT_Sales_Comments__c, ETT_Approve_Reject_Comments__c';
        
    //Query Added Services Fields
    public final static string strAddedServicesQueryFields = 'ETT_Lead__c,ETT_Out_Source__c,ETT_Own__c,ETT_Services__c,Name,ETT_Supplier_Details__c';
    //Query Bank References Fields
    public final static string strBankReferencesQueryFields = 'ETT_Account_Number__c,ETT_Address__c,ETT_Bank_Name__c,ETT_Lead__c,Name,ETT_Starting_With__c';
    //Query Staging Contacts Fields
    public final static string strStagingContactsQueryFields = 'ETT_First_Name__c,ETT_Designation__c,ETT_Email__c,ETT_Lead__c,ETT_Phone__c,Name';
    //Query Staging Customer LPO Fields
    public final static string strStagingCustomerLPOQueryFields = 'ETT_Designation__c,ETT_Lead__c,ETT_LPO_Sign_Person_Name__c,ETT_Signature__c,Name';
    //Query Staging Customer Vehicle Details
    public final static string strStagingCustomerVehicleQueryFields = 'ETT_Application__c,ETT_Axil_Configuration__c,ETT_KMS_Covered_Yearly__c,ETT_Lead__c,Name,ETT_Tyres_In_Fleet__c,ETT_Vehicle_Configuration__c,ETT_Vehicle_In_Fleet__c,ETT_Vehicle_Type__c';
    //Query Staging Quotation Request Details
    public final static string strStagingQuotationRequestFields = 'ETT_Tyre_Size_Master__r.ETT_Tyre_Size__c,ETT_Approve_Stage__c,ETT_IS_Approved__c,ETT_Lead__c,ETT_Quantity__c,ETT_Rejection_Comments__c,ETT_Retreading_charge__c,Name,ETT_Stock_Retreading_Charge__c,ETT_Tyre_Size_Master__c';
    
    //Query Staging Purchase Information Details
    public final static string strStagingPurchaseFields = 'ETT_Credit_Limit__c,ETT_Authorized_Person__c,ETT_Tyre_Size_Master__r.ETT_Tyre_Size__c,ETT_Type__c,ETT_Brand_Master__r.Name,ETT_Yearly_Qty__c,ETT_Price__c,ETT_Payment_Terms__c';

    //Query Staging Trade Licences Details
    public final static string strTradeLicenceFields = 'ETT_Credit_Limit__c,ETT_Lead__c,ETT_Length_of_relationship__c,ETT_Payment_Terms__c,Name,ETT_Supplier_Name_Details__c';
    //This is Profile List for Quote Approval Process Submit
    public final static string strProfileName = 'ETT_Receptionist'; 
    //This is Error message for Insufficient Priviliges for Lead Process.
    public final static string strErrorMsg = 'You do not have sufficient Priviliges to Approve this record'; 
    //This is Error message for Insufficient Priviliges for Lead Process.
    public final static string strErrorStageMsg = 'You do not have sufficient Priviliges to Change the Status';
    //This is Error message for do not present Quotation Request for Lead Process.
    public final static string strErrorLeadSubmitErrorMsg = 'Please select at least One Quotation for Submit Approval';
    //This is Error Message for do not allow to change Lead Status on Creation of New Lead
    public final static string strErrorLeadCreationErrorMsg = 'Do not allow to change the Lead Status to any Other Status';
}