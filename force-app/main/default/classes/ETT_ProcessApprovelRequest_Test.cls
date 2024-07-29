@isTest
public class ETT_ProcessApprovelRequest_Test {

    @istest
    public static void testMethod1(){
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c(); 
        objCC.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
		insert objCC;

		ETT_Purchase_Order__c objPO = new ETT_Purchase_Order__c();
        objPO.ETT_Collection_Card__c = objCC.Id;
        objPO.ETT_Accepted_by_HOO__c = true;
        insert objPO;
        
        ETT_ProcessApprovelRequest.submitForApproval(objPO);
        ETT_ProcessApprovelRequest.approveRecord(objPO);
ETT_ProcessApprovelRequest.getWorkItemId(objPO.Id);

        
    }
    
}