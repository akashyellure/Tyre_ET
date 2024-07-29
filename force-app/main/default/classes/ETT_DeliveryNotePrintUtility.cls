public class ETT_DeliveryNotePrintUtility {

    @AuraEnabled
    public static List <DeliveryNoteWrapper> fetchDeliveryNotes(string accountId) {
        List <DeliveryNoteWrapper> deliveryNotes = new List <DeliveryNoteWrapper>();
        Set<Id> collectionCardIds = new Set<Id>();
        for(ETT_Inspection_Card__c  iCards:  [select Id,ETT_Collection_Card__c, ETT_Collection_Card__r.Name,ETT_Collection_Card__r.ETT_Service_Appointment__c
                                              From ETT_Inspection_Card__c where ETT_Account__c = :accountId and ETT_Status__c='Send Back'])
        {
        	  collectionCardIds.add(iCards.ETT_Collection_Card__c);  
        }
        system.debug(collectionCardIds);
        for(ETT_Delivery_Note__c dnote: [SELECT Id, Name,ETT_Account__r.Party_Type__c, ETT_Account__r.Name, ETT_Account__c, ETT_Collection_Card__c, 
                                         ETT_Collection_Card__r.Name,ETT_Job_Card__c, ETT_Job_Card__r.Name, 
                                         ETT_Service_Appointment__r.AppointmentNumber FROM ETT_Delivery_Note__c 
                                         where ETT_Collection_Card__c in:collectionCardIds and Approved_By__c!=null]){
            DeliveryNoteWrapper wrapper = new DeliveryNoteWrapper();
            wrapper.isChecked = false;
            wrapper.deliveryId = dnote.Id;
            wrapper.deliveryNumber = dnote.Name;
                                             if(dnote.ETT_Account__r.Party_Type__c == 'Supplier'){
                                                 wrapper.casingType = 'Supplier Casing';
                                             }
                                             else if(dnote.ETT_Account__r.Party_Type__c == 'Customer'){
                                                 wrapper.casingType = 'Customer Casing';
                                             }
                                             else{
                                                 
                                             }
            wrapper.accountName = dnote.ETT_Account__r.Name;
            wrapper.accountId = dnote.ETT_Account__c;
            wrapper.collectionId = dnote.ETT_Collection_Card__c;
            wrapper.collectionNumber = dnote.ETT_Collection_Card__r.Name;
            wrapper.jobCardId = dnote.ETT_Job_Card__c;
            wrapper.jobCardNumber = dnote.ETT_Job_Card__r.Name;
            wrapper.serviceAppointmentId = dnote.ETT_Service_Appointment__c;
            wrapper.serviceAppointmentNumber = dnote.ETT_Service_Appointment__r.AppointmentNumber;
            deliveryNotes.add(wrapper);
        }
        return deliveryNotes;
    }
    
    
    public class DeliveryNoteWrapper{
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public string casingType {get;set;}
        @AuraEnabled public string deliveryId {get;set;}
        @AuraEnabled public string deliveryNumber {get;set;}
        @AuraEnabled public string accountName {get;set;}
        @AuraEnabled public string accountId {get;set;}
        @AuraEnabled public string collectionId {get;set;}
        @AuraEnabled public string collectionNumber {get;set;}
        @AuraEnabled public string jobCardId {get;set;}
        @AuraEnabled public string jobCardNumber {get;set;}
        @AuraEnabled public string serviceAppointmentId {get;set;}
        @AuraEnabled public string serviceAppointmentNumber {get;set;}
    }
}