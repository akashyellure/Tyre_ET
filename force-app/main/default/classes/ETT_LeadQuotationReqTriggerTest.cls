@isTest
public class ETT_LeadQuotationReqTriggerTest {

    @isTest
    public static void testCase1(){
    	
        /*List<Lead> lstLead = ETT_TestFactory.createLeads();
        insert lstLead;
        
        lstLead[0].LastName = 'Suhana';
        update lstLead;*/
        
        Id SuppRecType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Tyre_Supplier').getRecordTypeId();
        Lead le  = new Lead();
        le.recordTypeId = SuppRecType;
        le.LastName = 'Test43664';
        le.MiddleName ='Test4544';
        le.FirstName ='Test3535';
        le.Company = 'Test343423';
        le.MobilePhone ='877978789';
        insert le;

        le.LastName = 'Suhana';
        update le;        
    }
    
}