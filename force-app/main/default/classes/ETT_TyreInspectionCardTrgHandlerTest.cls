@isTest
public class ETT_TyreInspectionCardTrgHandlerTest {

    private static testmethod void createInspectCard(){
        
        Account objAcc = new Account();
        objAcc.Name = 'TestAccount';
        insert objAcc;
              
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = objAcc.Id;
        //objCC.ETT_Status__c = 'New';
        objCC.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId();
        insert objCC;
        
        
        ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
        objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId();
        objIC.ETT_Collection_Card__c = objCC.Id;
        objIC.ETT_Status__c = 'Pending';
        insert objIC;
        
        objIC.ETT_Status__c = 'Accept';
        update objIC;
    }
}