public class ETT_Collection_Card_Pdf_Controller {
    
public Id recordId {get;set;}
    public ETT_Collection_Card__c objCollectioncard  {get;set;}    
    public Account account {get;set;}
    public List<ETT_Tyre_Inventory__c> tyreInventInfo { get; set; }
    public map<string,string> lstCC {get;set;}
    
    public ETT_Collection_Card_Pdf_Controller(ApexPages.StandardController controller){
        recordId = controller.getRecord().Id;  
       //lstWorkOrderLineItems = [Select Id,LineItemNumber,Status,ETT_Account__c,ETT_Collection_Card__r.name,ETT_Pattern__r.name,ETT_Minimum_Price__c,ETT_Maximum_Price__c,ETT_Tyre_Size__r.name,ETT_New_Tyre_Size__c,ETT_Code__c,ETT_Tyre_Size_Name__c,ETT_Brand_Name__c,ETT_Pattern_Name__c,ETT_Country_of_Origin__r.name,ETT_Remarks__c,ETT_S_Index__c,ETT_Load_Index__c,ETT_Ply_Rate__c,ETT_Tyre_Serial_Number__c,ETT_Country_of_Origin_Name__c from WorkOrderLineItem where ETT_Collection_Card__c =:ApexPages.currentPage().getParameters().get('id')];
       tyreInventInfo = [Select id,ETT_Inventory_Status__c,ETT_Pattern__r.Name,ETT_Tyre_Size_Master__r.Name,ETT_Brand__r.Name,Serial_Number__c,ETT_Country__r.Name,Ply_Rate__c,Load_Index__c,S_Index__c,Remarks__c from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:ApexPages.currentPage().getParameters().get('id')];
        
        objCollectioncard = [select Id,Name,ETT_Collection_Card_Created_Date__c,ETT_Contact__c,ETT_Account__c,ETT_Collection_Date__c,ETT_Accounts__c,ETT_Collection_Status__c,Driver_Name__c,ETT_VAT_TRN_No_c__c ,ETT_Inspector__r.name from ETT_Collection_Card__c where Id=:ApexPages.currentPage().getParameters().get('id')];
               system.debug('objCollectioncard'+objCollectioncard);

account = [select Id,Name,BillingStreet,Phone,CreatedBy.FirstName,CreatedBy.LastName,Fax,(select id,lastname from contacts) from Account where Id =: objCollectioncard.ETT_Accounts__c];
system.debug('account'+account);

    }
}