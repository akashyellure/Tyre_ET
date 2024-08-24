public class ETT_DeliveryNote_PDF_Controller {

    public List<ETT_Delivery_Line_Item__c> dnl { get; set; }
    public Set<String> collectionCards { get; set; }

    public ETT_DeliveryNote_PDF_Controller(ApexPages.StandardController controller) {
        collectionCards = new Set<String>();
        
        // Fetch the records without sorting
        dnl = [
            SELECT 
                Id,
                ETT_Delivery_Note__r.Tyre_Estimation__c,
                ETT_Delivery_Note__r.ETT_Casing__c,
                Job_type__c,
                Tyre_Inventory__r.Job_Type__c,
                Tyre_Inventory__r.Tyre_Type__c,
                ETT_Tyre_size_Integration__c,
                Thred_Pattern__c,
                Name,
                ETT_Delivery_Note__r.ETT_Account__r.Name,
                ETT_Delivery_Note__r.ETT_Account__r.Party_Type__c,
                ETT_Delivery_Note__r.ETT_Account__r.AccountNumber,
                ETT_Delivery_Note__r.Name,
                Tyre_Inventory__c,
                Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,
                Tyre_Inventory__r.ETT_Brand__r.Name,
                ETT_Delivery_Note__r.Party_Type__c,
                ETT_Delivery_Note__r.SubInventory__r.Name,
                ETT_Delivery_Note__r.ETT_Address__c,
                ETT_Delivery_Note__r.ETT_Collection_Cards__c,
                ETT_Delivery_Note__r.Contact_Person__c,
                ETT_Delivery_Note__r.ETT_Date__c,
                ETT_Delivery_Note__r.ETT_Remark__c,
                ETT_Delivery_Note__r.ETT_Phone__c,
                ETT_Delivery_Note__r.ETT_Reference__c,
                ETT_Collection_Card__c,
                ETT_Collection_Card__r.Name,
                ETT_Delivery_Note__r.Approved_By__c,
                Tyre_Inventory__r.ETT_Pattern__r.Name,
                Tyre_Inventory__r.Serial_Number__c,
                ETT_Inspection_Card__r.ETT_Status__c,
                CreatedBy.Name 
            FROM 
                ETT_Delivery_Line_Item__c 
            WHERE 
                ETT_Delivery_Note__c = :ApexPages.currentPage().getParameters().get('id')
        ];
        
        // Sort the records in Apex
        dnl.sort(new ComparatorClass());

        for (ETT_Delivery_Line_Item__c dnli : dnl) {
            if (dnli.ETT_Collection_Card__c != null && dnli.ETT_Collection_Card__r.Name != null) {
                collectionCards.add(dnli.ETT_Collection_Card__r.Name);
            }
        }
    }

    // Comparator class for sorting
    public class ComparatorClass implements Comparator<ETT_Delivery_Line_Item__c> {
        public Integer compare(ETT_Delivery_Line_Item__c a, ETT_Delivery_Line_Item__c b) {
            Map<String, Integer> sortOrder = new Map<String, Integer>{
                'Repair' => 1,
                'Retred' => 2,
                'Send Back' => 3
            };
            
            Integer aOrder = sortOrder.containsKey(a.Job_type__c) ? sortOrder.get(a.Job_type__c) : 4;
            Integer bOrder = sortOrder.containsKey(b.Job_type__c) ? sortOrder.get(b.Job_type__c) : 4;
            
            if (aOrder == bOrder) {
                return 0;
            } else if (aOrder < bOrder) {
                return -1;
            } else {
                return 1;
            }
        }
    }
}
