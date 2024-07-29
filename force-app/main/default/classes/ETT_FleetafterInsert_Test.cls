@isTest public class ETT_FleetafterInsert_Test {
    
    @isTest public static void CodeCoverage(){
        
        Lead lead = new Lead();
        lead.Company = 'test';
        lead.LastName = 'dubai';
        lead.Phone = '98765432';
        insert lead;
        
        Account acc = new Account();
        acc.Name = 'Test account';
        insert acc;
        
        Contact cont = new Contact();
        cont.Phone = '+971 546789765';
        cont.AccountId = acc.Id;
        cont.LastName = 'devpleena';
        insert cont;
        
        ETT_Fleet_Analysis_Request__c fleetAnalysisRequest = new ETT_Fleet_Analysis_Request__c();
        fleetAnalysisRequest.ETT_Customer_Name__c = lead.Company;
        fleetAnalysisRequest.ETT_Account__c = acc.id;
        fleetAnalysisRequest.Lead__c = lead.Id;
        insert fleetAnalysisRequest;
  }
    
}