@isTest
public class ETT_ErrorhandlingProcess_Test {
    
    @isTest static void testErrorhandlingProcess(){
        
        //List<Lead> leadList =  ETT_TestFactory.createLeads();
        List<Lead> leadList = new List<Lead>();
        for(integer i =0; i<=5;i++){
            Lead ld = new Lead();
            ld.LastName = 'LastName';
            ld.Company = 'testCompany';
            ld.Phone = '123456780';
            ld.MobilePhone = '987654321';
            ld.Email = 'testEmail@123.com';
            ld.Street = 'Street';
            ld.ETSALES_Budget__c = 10000;
            ld.ETSALES_Lead_Rating__c = 'Hot';
            leadList.add(ld);
        }
        
        leadList[0].MobilePhone = '-987654321p';
        leadList[0].RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();


        List<Database.SaveResult> results = Database.insert(leadList, false);
        list<Database.Error> errList = new list<Database.Error>();
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                for (Database.Error error : result.getErrors()) {
                    errList.add(error);
                    System.debug('Error returned: ' + error.getStatusCode() +' - '+ error.getMessage());
                }
            }
        }
        
        ETT_ErrorhandlingProcess.errorHandlingProcess(results[0].getId(), errList, 'ETT_ErrorhandlingProcess_Test');
    }
    
}