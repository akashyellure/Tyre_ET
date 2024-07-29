@isTest public class ETT_getPickListValues_Test {
    @isTest
    
    public static void codecoverage(){
           Lead lead = new Lead();
        lead.Company = 'test';
        lead.LastName = 'dubai';
        insert lead;
        
        Account acc = new Account();
        acc.Name = 'Test account';
        insert acc;
        
        Contact cont = new Contact();
       // cont.Phone = '+971 546789765';
        cont.AccountId = acc.Id;
        cont.LastName = 'devpleena';
        insert cont;
        
        ETT_Fleet_Inspection__c FleetInspection = new ETT_Fleet_Inspection__c();
        FleetInspection.ETT_Account__c = acc.Id;
        FleetInspection.Lead__c = lead.Id;
        insert FleetInspection;
        
        getPickListValues.getDetailsOnLoad();
    }

}