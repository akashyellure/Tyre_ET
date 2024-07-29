/**
 * Author:Janardhan
 * CreatedDate:12/12/2021
 * Desc: 
 * TestCLass: ETT_ShowAllDeliveryNotesTest
 * */
public class ETT_ShowAllDeliveryNotes {
    
    @auraEnabled
    public static list<ETT_Delivery_Note__c> getAllDeliveryNotes(string recordId){
        
        return [select id,Name,createdDate,CreatedBy.Name from ETT_Delivery_Note__c where ETT_Account__c=:recordId AND DN_Status__c='Approved' ORDER BY Name DESC];
    }

}