public class ETT_CreateDeliveryNoteController {
    
    @auraEnabled 
    public static list<Tyre_Estimation_Line_Item__c> getTyreDetails(String serialVal, String tyreSizeVal, String brandVal, String patternVal, String tyreType, String countryVal,String customerId, String subInventoryId, String tyreEstimationId){
        System.debug('countryVal '+countryVal);
        System.debug('TyreType '+TyreType);
        String query='Select Id,Unit_Price__c,Tyre_Estimation__r.Name,Tyre_Inventory__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.ETT_Brand__r.Name,Tyre_Inventory__r.ETT_Country__r.Name,Tyre_Inventory__r.Tyre_Type__c,Tyre_Inventory__r.Serial_Number__c,Collection_Card_No__r.Name from Tyre_Estimation_Line_Item__c where Tyre_Inventory__c NOT IN (SELECT Tyre_Inventory__c FROM ETT_Delivery_Line_Item__c) AND ((Tyre_Inventory__r.Party_Type__c=\'Supplier\' OR Tyre_Inventory__r.Party_Type__c=\'Internal\') OR (Tyre_Inventory__r.Party_Type__c=\'Internal Private\' OR Tyre_Inventory__r.Party_Type__c=\'Null\'))';
        //return [SELECT Id,Tyre_Type__c,Unit_Price__c,Name,ETT_Tyre_Size_Master__r.Name,Serial_Number__c,ETT_Brand__r.Name,ETT_Pattern__r.Name,ETT_Country__r.Name,ETT_Collection_Card__r.Name,ETT_Account__r.Name from ETT_Tyre_Inventory__c where Id IN (SELECT Tyre_Inventory__c FROM Tyre_Estimation_Line_Item__c) AND (Party_Type__c='Supplier' OR Party_Type__c='Internal Project') LIMIT 49000];
        if(customerId != null && customerId != ''){
            query += 'AND Tyre_Estimation__r.Account__c =: customerId ';
        }else if(subInventoryId != null && subInventoryId != ''){
            query += 'AND Tyre_Estimation__r.SubInventory__c =: subInventoryId ';
        }
        if(tyreEstimationId != null && tyreEstimationId != ''){
            query += 'AND Tyre_Estimation__c =: tyreEstimationId ';
        }
        system.debug('query After'+ query);
        
        /*else{
query += ') ';
} */
        if(serialVal != null && serialVal != ''){
            query += 'AND Tyre_Inventory__r.Serial_Number__c =: serialVal ';
        }
        if(tyreSizeVal != null && tyreSizeVal != ''){
            query += 'AND Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name =: tyreSizeVal ';
        }
        if(brandVal != null && brandVal != ''){
            query += 'AND Tyre_Inventory__r.ETT_Brand__r.Name =: brandVal ';
        }
        if(patternVal != null && patternVal != ''){
            query += 'AND Tyre_Inventory__r.ETT_Pattern__r.Name =: patternVal ';
        }
        if(tyreType != null && tyreType != ''){
            query += 'AND Tyre_Inventory__r.Tyre_Type__c =: tyreType ';
        }else{
            query += 'AND (Tyre_Inventory__r.Tyre_Type__c = \'Refurbished\' OR Tyre_Inventory__r.Tyre_Type__c  = \'New\' OR Tyre_Inventory__r.Tyre_Type__c  = \'Scrapped\') ';
        }
        if(countryVal != null && countryVal != ''){
            query += 'AND Tyre_Inventory__r.ETT_Country__r.Name =: countryVal ';
        }
        System.debug('query '+query);
        return Database.query(query+' LIMIT 49000');
    }
    //Create Delivery Note Method
    @auraEnabled
    public static List<ETT_Delivery_Line_Item__c> createEstimations(List<Tyre_Estimation_Line_Item__c> selectedTyres, String customerId, String subInventoryId,String tyreEstimationId) {
            
            Savepoint sp = Database.setSavepoint();
            
            List<ETT_Delivery_Line_Item__c> listOfDeliveryNote = new List<ETT_Delivery_Line_Item__c>();
            ETT_Delivery_Note__c deliveryNoteObj = new ETT_Delivery_Note__c();
            
            if (String.isNotBlank(customerId)) {
                deliveryNoteObj.ETT_Account__c = customerId;   
            }
            if (String.isNotBlank(subInventoryId)) {
                deliveryNoteObj.SubInventory__c = subInventoryId;   
            }
            if (String.isNotBlank(tyreEstimationId)) {
                deliveryNoteObj.Tyre_Estimation__c = tyreEstimationId; 
                deliveryNoteObj.ETT_Casing__c = 'Own';  
            }
            
            deliveryNoteObj.DN_Status__c = 'New';
            deliveryNoteObj.ETT_Date__c = System.now();
            deliveryNoteObj.ETT_Job_Type__c = 'Accepted';
            
            insert deliveryNoteObj;
            
            try {
                Set<Id> tyreInventories = new Set<Id>();
                Map<Id, ETT_Inspection_Card__c> inspectionsMap = new Map<Id, ETT_Inspection_Card__c>();
                Map<Id, String> threadPatternsMap = new Map<Id, String>();
                
                // Collect Tyre Inventory IDs
                for (Tyre_Estimation_Line_Item__c objTELI : selectedTyres) {
                    if (objTELI.Tyre_Inventory__c != null) {
                        tyreInventories.add(objTELI.Tyre_Inventory__c);
                    }
                }
                
                // Retrieve corresponding Inspection Cards
                for (ETT_Inspection_Card__c objInspection : [
                    SELECT Id, Tyre_Inventory__c 
                    FROM ETT_Inspection_Card__c 
                    WHERE Tyre_Inventory__c IN :tyreInventories
                ]) {
                    if (objInspection.Tyre_Inventory__c != null) {
                        inspectionsMap.put(objInspection.Tyre_Inventory__c, objInspection);
                    }
                }
                // Retrieve corresponding Thread Patterns
                for (ETT_Job_Card_Close__c jobCardClose : [
                    SELECT Id, Job_Card__r.ETT_Inspection_Card__c, ThreadPattern__r.Name, Job_Card__r.Tyre_Inventory__c 
                    FROM ETT_Job_Card_Close__c 
                    WHERE Job_Card__r.Tyre_Inventory__c IN :tyreInventories
                ]) {
                    if (jobCardClose.Job_Card__r.Tyre_Inventory__c != null) {
                        threadPatternsMap.put(jobCardClose.Job_Card__r.Tyre_Inventory__c, jobCardClose.ThreadPattern__r.Name);
                    }
                }
                
                // Create Delivery Line Items
                for (Tyre_Estimation_Line_Item__c objTELI : selectedTyres) {
                    ETT_Delivery_Line_Item__c objDeliveryLineItem = new ETT_Delivery_Line_Item__c();
                    objDeliveryLineItem.Tyre_Inventory__c = objTELI.Tyre_Inventory__c;
                    objDeliveryLineItem.ETT_Delivery_Note__c = deliveryNoteObj.Id;
                    objDeliveryLineItem.ETT_Collection_Card__c = objTELI.Collection_Card_No__c;
                    objDeliveryLineItem.ETT_Job_Type__c=objTELI.Tyre_Inventory__r.Tyre_Type__c;
                    objDeliveryLineItem.ETT_Price__c = objTELI.Unit_Price__c; // Set the price field

                    
                    // Set the ETT_Tyre_Size__c and ETT_Tyre_Size_Integration__c fields
                    if (objTELI.Tyre_Inventory__r.ETT_Tyre_Size_Master__r != null) {
                        objDeliveryLineItem.ETT_Tyre_Size_Integration__c = objTELI.Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name;
                        objDeliveryLineItem.ETT_Tyre_Size__c = objTELI.Tyre_Inventory__r.ETT_Tyre_Size_Master__c;
                    }
                    if (objTELI.Tyre_Inventory__r.ETT_Brand__r != null) {
                        objDeliveryLineItem.ETT_Brand_Master__c = objTELI.Tyre_Inventory__r.ETT_Brand__r.Id;
                    }
                    if (objTELI.Tyre_Inventory__r.ETT_Pattern__r != null) {
                        objDeliveryLineItem.ETT_Pattern_Master__c = objTELI.Tyre_Inventory__r.ETT_Pattern__r.Id;
                    }
                    // Set the Thred_Pattern__c field
                    if (threadPatternsMap.containsKey(objTELI.Tyre_Inventory__c)) {
                        objDeliveryLineItem.Thred_Pattern__c = threadPatternsMap.get(objTELI.Tyre_Inventory__c);
                    }
                    
                    if (inspectionsMap.containsKey(objTELI.Tyre_Inventory__c)) {
                        objDeliveryLineItem.ETT_Inspection_Card__c = inspectionsMap.get(objTELI.Tyre_Inventory__c).Id;
                    }
                    
                    
                    listOfDeliveryNote.add(objDeliveryLineItem);
                }
                
                if (!listOfDeliveryNote.isEmpty()) {
                    insert listOfDeliveryNote;
                }
                
                return [
                    SELECT Id, Name, ETT_Delivery_Note__r.Name, ETT_Delivery_Note__r.Id 
                    FROM ETT_Delivery_Line_Item__c 
                    WHERE Id IN :listOfDeliveryNote
                ];
                
            } catch (Exception e) {
                System.debug('Error on line ' + e.getLineNumber());
                System.debug('Error trace: ' + e.getStackTraceString());
                System.debug('Error message: ' + e.getMessage());
                Database.rollback(sp);
                throw new AuraHandledException(e.getMessage() + ' -- ' + e.getCause() + ' -- ' + e.getStackTraceString());
            }
        }
    
    
    
    
    
    
}