public class ETT_DeliveryNote_PDF_Controller {
    
    public List<ETT_Delivery_Line_Item__c> dnl { get; set; }
    public Set<String> collectionCards { get; set; }
    
    public ETT_DeliveryNote_PDF_Controller(ApexPages.StandardController controller){
        collectionCards = new Set<String>();
        dnl = [select id,ETT_Delivery_Note__r.Tyre_Estimation__c,ETT_Delivery_Note__r.ETT_Casing__c,Job_type__c,Tyre_Inventory__r.Job_Type__c,Tyre_Inventory__r.Tyre_Type__c,ETT_Tyre_size_Integration__c,Thred_Pattern__c  ,name,ETT_Delivery_Note__r.ETT_Account__r.Name,ETT_Delivery_Note__r.ETT_Account__r.Party_Type__c,ETT_Delivery_Note__r.Name,Tyre_Inventory__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Brand__r.Name, ETT_Delivery_Note__r.Party_Type__c, ETT_Delivery_Note__r.SubInventory__r.Name, 
               ETT_Delivery_Note__r.ETT_Address__c,ETT_Delivery_Note__r.ETT_Collection_Cards__c,ETT_Delivery_Note__r.Contact_Person__c,ETT_Delivery_Note__r.ETT_Date__c,ETT_Delivery_Note__r.ETT_Remark__c,ETT_Delivery_Note__r.ETT_Phone__c,ETT_Delivery_Note__r.ETT_Reference__c, ETT_Collection_Card__c, ETT_Collection_Card__r.Name, 
               ETT_Delivery_Note__r.Approved_By__c,Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.Serial_Number__c,ETT_Inspection_Card__r.ETT_Status__c,createdBy.Name from ETT_Delivery_Line_Item__c where ETT_Delivery_Note__c=:ApexPages.currentPage().getParameters().get('id')];
        for(ETT_Delivery_Line_Item__c dnli : dnl){
            if(dnli.ETT_Collection_Card__c != null && dnli.ETT_Collection_Card__r.Name != null){
                collectionCards.add(dnli.ETT_Collection_Card__r.Name);
            }
        }
        
    }
    
    
}