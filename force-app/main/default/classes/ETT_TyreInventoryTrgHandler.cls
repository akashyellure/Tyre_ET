/* *
* Author: Janardhan
* Created Date: 28/11/2021
* TestClass:ETT_TyreCollectionDetailsInCCTest
* DESC: 
* */
public class ETT_TyreInventoryTrgHandler {
    
    
    public static void createInspectionCards(list<ETT_Tyre_Inventory__c> trgNew,Map<Id,ETT_Tyre_Inventory__c> trgoldMap){
        
        list<ETT_Inspection_Card__c> newInspeCardList = new list<ETT_Inspection_Card__c>();
        
        if(trigger.isInsert){
            for(ETT_Tyre_Inventory__c ti : trgNew){
                if(ti.ETT_Inventory_Status__c == 'Approved by Receptionist'){
                    
                    ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
                    if(ti.Party_Type__c == 'Supplier'){
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId(); 
                    }else if(ti.Party_Type__c == 'Internal'){
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId();
                    }else if(ti.Party_Type__c == 'Internal Private'){
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal Private').getRecordTypeId();
                    }else{
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
                    }
                    
                    ic.ETT_Collection_Card__c = ti.ETT_Collection_Card__c;
                    ic.Tyre_Inventory__c = ti.Id;
                    ic.ETT_Country__c = ti.ETT_Country__c;
                    ic.ETT_Brand__c = ti.ETT_Brand__c;
                    ic.ETT_Pattern__c = ti.ETT_Pattern__c;
                    ic.ETT_Tyre_Size__c = ti.ETT_Tyre_Size_Master__c;
                    ic.ETT_Tyre_Serial_Number__c = ti.Serial_Number__c; 
                    ic.ETT_Tyre_Life__c =ti.ETT_Tyre_Life__c;
                  
                    
                    newInspeCardList.add(ic);
                }
            }
        }
        if(trigger.isUpdate){
            /*Set<Id> collectionIds = new Set<Id>();
            for(ETT_Tyre_Inventory__c ti : trgNew){
                if(ti.ETT_Collection_Card__c != null){
                    collectionIds.add(ti.ETT_Collection_Card__c);
                }
            }
            Map<Id, ETT_Collection_Card__c> ccMap = new Map<Id, ETT_Collection_Card__c>([SELECT Id, RecordTypeId, RecordType.Name FROM ETT_Collection_Card__c WHERE Id IN: collectionIds AND RecordTypeId =: Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId()]);*/
            for(ETT_Tyre_Inventory__c ti : trgNew){
                System.debug('ETT_Tyre_Inventory__c '+ti.ETT_Collection_Card__r.RecordTypeId);
                if(ti.ETT_Inventory_Status__c == 'Approved by Receptionist' && ti.ETT_Inventory_Status__c != trgoldMap.get(ti.Id).ETT_Inventory_Status__c){
                    
                    ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
                    //if(ti.ETT_Collection_Card__c != null && ccMap.containsKey(ti.ETT_Collection_Card__c)){
                    if(ti.Party_Type__c == 'Internal'){
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId();
                    }else if(ti.Party_Type__c == 'Internal Private'){
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal Private').getRecordTypeId(); 
                    }else if(ti.Party_Type__c == 'Supplier'){
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId(); 
                    }else{
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
                    }
                    ic.ETT_Collection_Card__c = ti.ETT_Collection_Card__c;
                    ic.Tyre_Inventory__c = ti.Id;
                    ic.ETT_Country__c = ti.ETT_Country__c;
                    ic.ETT_Brand__c = ti.ETT_Brand__c;
                    ic.ETT_Pattern__c = ti.ETT_Pattern__c;
                    ic.ETT_Tyre_Size__c = ti.ETT_Tyre_Size_Master__c;
                    ic.ETT_Tyre_Serial_Number__c = ti.Serial_Number__c; 
                    ic.ETT_Tyre_Life__c =ti.ETT_Tyre_Life__c;
                    ic.ETT_Account__c=ti.ETT_Account__c;
                   
                    
                    
                    newInspeCardList.add(ic);
                }
            }
            
        }
        insert newInspeCardList;
        
    }
  
    public static void updatePriceInUpdate(Map<Id, ETT_Tyre_Inventory__c> trgNewMap, Map<Id, ETT_Tyre_Inventory__c> trgOldMap) {
    try {
        Set<Id> accIds = new Set<Id>();
        Map<String, Double> keyVsPrice = new Map<String, Double>();
        Map<String, String> keyVsPricInfoId = new Map<String, String>();
        List<ETT_Collection_Card__c> ccUpdateList = new List<ETT_Collection_Card__c>();
        Map<Id, Id> accIdVsPriceMasId = new Map<Id, Id>();
        List<ETT_Pricing_Information__c> insertPirceInfoList = new List<ETT_Pricing_Information__c>();
        Map<Id, Boolean> collCCIdVshasNewTyrewoPrice = new Map<Id, Boolean>();
        Map<String, Id> keyVsTyreMasterId = new Map<String, Id>();
        Map<String, Id> newPricingInfoVsPriceMasId = new Map<String, Id>();
        Map<String, Id> newPricingInfoVsCCId = new Map<String, Id>();
        Map<String, ETT_Tyre_Inventory__c> keyVsTyreInv = new Map<String, ETT_Tyre_Inventory__c>();

        for (ETT_Tyre_Inventory__c ti : trgNewMap.values()) {
            accIds.add(ti.ETT_Account__c);
        }

        for (ETT_Price_Master__c pm : [
            SELECT Id, ETT_Party_Name__c 
            FROM ETT_Price_Master__c 
            WHERE ETT_Party_Name__c = :accIds
        ]) {
            accIdVsPriceMasId.put(pm.ETT_Party_Name__c, pm.Id);
        }

        for (ETT_Pricing_Information__c pc : [
            SELECT Id, ETT_Price__r.ETT_Party_Name__c, ETT_Price__c, ETT_Tyre_Size__c, ETT_Brand__c, ETT_Pattern__c, ETT_Country_of_Origin__c, ETT_Purchase_Price__c 
            FROM ETT_Pricing_Information__c 
            WHERE ETT_Price__r.ETT_Party_Name__c = :accIds
        ]) {
            String keyVal = pc.ETT_Tyre_Size__c + '-' + pc.ETT_Brand__c + '-' + pc.ETT_Pattern__c + '-' + pc.ETT_Country_of_Origin__c;
            keyVsPrice.put(keyVal, pc.ETT_Purchase_Price__c);
            keyVsPricInfoId.put(keyVal, pc.Id);
        }

        for (ETT_Tyre_Master__c tm : [
            SELECT Id, ETT_Brand_Name__c, ETT_Tyre_Size__c, ETT_Original_Pattern__c, ETT_Country_Name__c 
            FROM ETT_Tyre_Master__c 
            WHERE RecordType.Name = 'Approved'
        ]) {
            String keyVal = tm.ETT_Tyre_Size__c + '-' + tm.ETT_Brand_Name__c + '-' + tm.ETT_Original_Pattern__c + '-' + tm.ETT_Country_Name__c;
            keyVsTyreMasterId.put(keyVal, tm.Id);
        }

        for (ETT_Tyre_Inventory__c ti : trgNewMap.values()) {
            if (ti.ETT_Tyre_Size_Master__c != trgOldMap.get(ti.Id).ETT_Tyre_Size_Master__c || 
                ti.ETT_Pattern__c != trgOldMap.get(ti.Id).ETT_Pattern__c ||
                ti.ETT_Brand__c != trgOldMap.get(ti.Id).ETT_Brand__c || 
                ti.ETT_Country__c != trgOldMap.get(ti.Id).ETT_Country__c || 
                ti.Purchase_Price__c == 0 || 
                ti.Pricing_Information__c == null) {

                String keyVal = ti.ETT_Tyre_Size_Master__c + '-' + ti.ETT_Brand__c + '-' + ti.ETT_Pattern__c + '-' + ti.ETT_Country__c;
                if (keyVsTyreMasterId.containsKey(keyVal)) {
                    ti.ETT_Tyre_Master__c = keyVsTyreMasterId.get(keyVal);
                }

                if (keyVsPrice.containsKey(keyVal)) {
                    ti.Pricing_Information__c = keyVsPricInfoId.get(keyVal);
                    ti.Purchase_Price__c = keyVsPrice.get(keyVal);
                    collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, false); 
                } else {
                    ti.Pricing_Information__c = null;
                    ti.Purchase_Price__c = 0;
                    if (ti.Party_Type__c != 'Internal' && ti.Party_Type__c != 'Internal Private') {
                        collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, true); 
                        newPricingInfoVsPriceMasId.put(keyVal, accIdVsPriceMasId.get(ti.ETT_Account__c));
                        newPricingInfoVsCCId.put(keyVal, ti.ETT_Collection_Card__c);
                        keyVsTyreInv.put(keyVal, ti);
                    }
                }
            }
        }

        for (String st : newPricingInfoVsPriceMasId.keySet()) {
            List<String> tempList = st.split('-');
            ETT_Tyre_Inventory__c tyreInv = keyVsTyreInv.get(st);
            if (tyreInv.Party_Type__c != 'Internal' && tyreInv.Party_Type__c != 'Internal Private') {
                ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();  
                epi.ETT_Price__c = newPricingInfoVsPriceMasId.get(st);
                epi.ETT_Approval_Status__c = 'New';
                epi.Collection_Card__c = newPricingInfoVsCCId.get(st);
                epi.RecordTypeId = tyreInv.Party_Type__c == 'Supplier' ? 
                    Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() : 
                    Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                epi.ETT_Brand__c = tempList[1];
                epi.ETT_Pattern__c = tempList[2];
                epi.ETT_Country_of_Origin__c = tempList[3];
                epi.ETT_Tyre_Size__c = tempList[0];
                epi.ETT_Purchase_Price__c = 0;
                insertPirceInfoList.add(epi);
            }
        }

        for (Id idval : collCCIdVshasNewTyrewoPrice.keySet()) {
            if (idval != null) {
                ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                cc.Id = idval;
                cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
                ccUpdateList.add(cc);
            }
        }

        if (!ccUpdateList.isEmpty()) {
            update ccUpdateList;
        }

        if (!insertPirceInfoList.isEmpty()) {
            insert insertPirceInfoList;
        }
    } catch (Exception e) {
        // Log the error for debugging purposes
        System.debug('Exception in updatePriceInUpdate: ' + e.getMessage());
        
    }
}
    
    public static void updatePriceInfoOnInsert(list<ETT_Tyre_Inventory__c> trgNew) {
        try {
            set<id> accIds = new set<id>();
            map<string,double> keyVsPrice = new map<string,double>();
            map<string,String> keyVsPricInfoId = new map<string,string>();
            list<ETT_Collection_Card__c> ccUpdateList = new list<ETT_Collection_Card__c>();    
            map<id,id> accIdVsPriceMasId = new map<id,id>();
            list<ETT_Pricing_Information__c> insertPirceInfoList = new list<ETT_Pricing_Information__c>();
            Map<id,boolean> collCCIdVshasNewTyrewoPrice = new map<id,boolean>();
            map<string,id> keyVsTyreMasterId = new map<string,id>();
            map<string,id> newPricingInfoVsPriceMasId = new map<string,id>();
            map<string,id> newPricingInfoVsCCId = new map<string,id>();
            map<string,ETT_Tyre_Inventory__c> keyVsTyreInv = new map<string,ETT_Tyre_Inventory__c>();
            
            for(ETT_Tyre_Inventory__c ti : trgNew) {
                accIds.add(ti.ETT_Account__c);
            }
            
            for(ETT_Price_Master__c pm : [select id, ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c = :accIds]) {
                accIdVsPriceMasId.put(pm.ETT_Party_Name__c, pm.Id);
            }
            
            for(ETT_Tyre_Master__c tm : [select id, ETT_Brand_Name__c, ETT_Tyre_Size__c, ETT_Original_Pattern__c, ETT_Country_Name__c from ETT_Tyre_Master__c where recordType.Name = 'Approved']) {
                string keyval = tm.ETT_Tyre_Size__c + '-' + tm.ETT_Brand_Name__c + '-' + tm.ETT_Original_Pattern__c + '-' + tm.ETT_Country_Name__c;
                keyVsTyreMasterId.put(keyval, tm.Id);
            }
            
            for(ETT_Pricing_Information__c pc : [select id, ETT_Price__c, ETT_Price__r.ETT_Party_Name__c, ETT_Tyre_Size__c, ETT_Brand__c, ETT_Pattern__c, ETT_Country_of_Origin__c, ETT_Purchase_Price__c from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c = :accIds]) {
                string keyVal = pc.ETT_Tyre_Size__c + '-' + pc.ETT_Brand__c + '-' + pc.ETT_Pattern__c + '-' + pc.ETT_Country_of_Origin__c;
                keyVsPrice.put(keyVal, pc.ETT_Purchase_Price__c);
                keyVsPricInfoId.put(keyVal, pc.Id);
            }
            
            for(ETT_Tyre_Inventory__c ti : trgNew) {
                string keyVal = ti.ETT_Tyre_Size_Master__c + '-' + ti.ETT_Brand__c + '-' + ti.ETT_Pattern__c + '-' + ti.ETT_Country__c;
                
                if(keyVsTyreMasterId.containsKey(keyVal)) {
                    ti.ETT_Tyre_Master__c = keyVsTyreMasterId.get(keyVal);
                }
                
                if(ti.Party_Type__c == 'Supplier') {
                    ti.Stockable__c = true;
                    ti.Tyre_Type__c = 'Used';
                }
                
                if(keyVsPrice.containsKey(keyVal)) {
                    ti.Pricing_Information__c = keyVsPricInfoId.get(keyVal);
                    ti.Purchase_Price__c = keyVsPrice.get(keyVal);
                    collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, false); 
                } else {
                    ti.Pricing_Information__c = null;
                    ti.Purchase_Price__c = 0;
                    if(ti.Party_Type__c != 'Internal' && ti.Party_Type__c != 'Internal Private') {
                        collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, true); 
                    }
                    
                    if(ti.ETT_Inventory_Status__c != 'Approved by Receptionist' && ti.Party_Type__c != 'Internal' && ti.Party_Type__c != 'Internal Private') {
                        newPricingInfoVsPriceMasId.put(keyVal, accIdVsPriceMasId.get(ti.ETT_Account__c));
                        newPricingInfoVsCCId.put(keyVal, ti.ETT_Collection_Card__c);
                        keyVsTyreInv.put(keyVal, ti);
                    }
                }
            }
            
            // Make list of new pricing information from set
            for(string st : newPricingInfoVsPriceMasId.keySet()) {
                List<String> tempList = st.split('-');
                ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();  
                epi.ETT_Price__c = newPricingInfoVsPriceMasId.get(st);
                epi.ETT_Approval_Status__c = 'New';
                epi.Collection_Card__c = newPricingInfoVsCCId.get(st);
                
                if(keyVsTyreInv.get(st).Party_Type__c == 'Supplier') {
                    epi.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                } else {
                    epi.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                }
                
                epi.ETT_Brand__c = tempList[1];
                if(tempList[2] != 'null') epi.ETT_Pattern__c = tempList[2];
                if(tempList[3] != 'null') epi.ETT_Country_of_Origin__c = tempList[3];
                if(tempList[0] != 'null') epi.ETT_Tyre_Size__c = tempList[0];
                epi.ETT_Purchase_Price__c = 0;
                insertPirceInfoList.add(epi);
            }
            
            for(id idval : collCCIdVshasNewTyrewoPrice.keyset()) {
                if(idval != null) {
                    ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                    cc.Id = idval;
                    cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
                    ccUpdateList.add(cc);   
                }
            }
            
            update ccUpdateList;
            insert insertPirceInfoList;
        } catch (Exception e) {
            // Handle the exception appropriately, e.g., by logging the error
            System.debug('An error occurred in updatePriceInfoOnInsert: ' + e.getMessage());
        }
    }

    
     /* public static void updatePriceInfoOnInsert(list<ETT_Tyre_Inventory__c> trgNew) {
    set<id> accIds = new set<id>();
    map<string,double> keyVsPrice = new map<string,double>();
    map<string,String> keyVsPricInfoId = new map<string,string>();
    list<ETT_Collection_Card__c> ccUpdateList = new list<ETT_Collection_Card__c>();    
    map<id,id> accIdVsPriceMasId = new map<id,id>();
    list<ETT_Pricing_Information__c> insertPirceInfoList = new list<ETT_Pricing_Information__c>();
    Map<id,boolean> collCCIdVshasNewTyrewoPrice = new map<id,boolean>();
    map<string,id> keyVsTyreMasterId = new map<string,id>();
    map<string,id> newPricingInfoVsPriceMasId = new map<string,id>();
    map<string,id> newPricingInfoVsCCId = new map<string,id>();
    map<string,ETT_Tyre_Inventory__c> keyVsTyreInv = new map<string,ETT_Tyre_Inventory__c>();

    for(ETT_Tyre_Inventory__c ti : trgNew) {
        accIds.add(ti.ETT_Account__c);
    }

    for(ETT_Price_Master__c pm : [select id, ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c = :accIds]) {
        accIdVsPriceMasId.put(pm.ETT_Party_Name__c, pm.Id);
    }

    for(ETT_Tyre_Master__c tm : [select id, ETT_Brand_Name__c, ETT_Tyre_Size__c, ETT_Original_Pattern__c, ETT_Country_Name__c from ETT_Tyre_Master__c where recordType.Name = 'Approved']) {
        string keyval = tm.ETT_Tyre_Size__c + '-' + tm.ETT_Brand_Name__c + '-' + tm.ETT_Original_Pattern__c + '-' + tm.ETT_Country_Name__c;
        keyVsTyreMasterId.put(keyval, tm.Id);
    }

    for(ETT_Pricing_Information__c pc : [select id, ETT_Price__c, ETT_Price__r.ETT_Party_Name__c, ETT_Tyre_Size__c, ETT_Brand__c, ETT_Pattern__c, ETT_Country_of_Origin__c, ETT_Purchase_Price__c from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c = :accIds]) {
        string keyVal = pc.ETT_Tyre_Size__c + '-' + pc.ETT_Brand__c + '-' + pc.ETT_Pattern__c + '-' + pc.ETT_Country_of_Origin__c;
        keyVsPrice.put(keyVal, pc.ETT_Purchase_Price__c);
        keyVsPricInfoId.put(keyVal, pc.Id);
    }

    for(ETT_Tyre_Inventory__c ti : trgNew) {
        string keyVal = ti.ETT_Tyre_Size_Master__c + '-' + ti.ETT_Brand__c + '-' + ti.ETT_Pattern__c + '-' + ti.ETT_Country__c;

        if(keyVsTyreMasterId.containsKey(keyVal)) {
            ti.ETT_Tyre_Master__c = keyVsTyreMasterId.get(keyVal);
        }

        if(ti.Party_Type__c == 'Supplier') {
            ti.Stockable__c = true;
            ti.Tyre_Type__c = 'Used';
        }

        if(keyVsPrice.containsKey(keyVal)) {
            ti.Pricing_Information__c = keyVsPricInfoId.get(keyVal);
            ti.Purchase_Price__c = keyVsPrice.get(keyVal);
            collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, false); 
        } else {
            ti.Pricing_Information__c = null;
            ti.Purchase_Price__c = 0;
            if(ti.Party_Type__c != 'Internal' && ti.Party_Type__c != 'Internal Private') {
                collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, true); 
            }

            if(ti.ETT_Inventory_Status__c != 'Approved by Receptionist' && ti.Party_Type__c != 'Internal' && ti.Party_Type__c != 'Internal Private') {
                newPricingInfoVsPriceMasId.put(keyVal, accIdVsPriceMasId.get(ti.ETT_Account__c));
                newPricingInfoVsCCId.put(keyVal, ti.ETT_Collection_Card__c);
                keyVsTyreInv.put(keyVal, ti);
            }
        }
    }

    // Make list of new pricing information from set
    for(string st : newPricingInfoVsPriceMasId.keySet()) {
        List<String> tempList = st.split('-');
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();  
        epi.ETT_Price__c = newPricingInfoVsPriceMasId.get(st);
        epi.ETT_Approval_Status__c = 'New';
        epi.Collection_Card__c = newPricingInfoVsCCId.get(st);

        if(keyVsTyreInv.get(st).Party_Type__c == 'Supplier') {
            epi.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        } else {
            epi.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        }

        epi.ETT_Brand__c = tempList[1];
        if(tempList[2] != 'null') epi.ETT_Pattern__c = tempList[2];
        if(tempList[3] != 'null') epi.ETT_Country_of_Origin__c = tempList[3];
        if(tempList[0] != 'null') epi.ETT_Tyre_Size__c = tempList[0];
        epi.ETT_Purchase_Price__c = 0;
        insertPirceInfoList.add(epi);
    }

    for(id idval : collCCIdVshasNewTyrewoPrice.keyset()) {
        if(idval != null) {
            ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
            cc.Id = idval;
            cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
            ccUpdateList.add(cc);   
        }
    }

    update ccUpdateList;
    insert insertPirceInfoList;
} */
    
    /*
    public static void updatePriceInUpdate(Map<Id, ETT_Tyre_Inventory__c> trgNewMap, Map<Id, ETT_Tyre_Inventory__c> trgOldMap) {
    Set<Id> accIds = new Set<Id>();
    Map<String, Double> keyVsPrice = new Map<String, Double>();
    Map<String, String> keyVsPricInfoId = new Map<String, String>();
    List<ETT_Collection_Card__c> ccUpdateList = new List<ETT_Collection_Card__c>();
    Map<Id, Id> accIdVsPriceMasId = new Map<Id, Id>();
    List<ETT_Pricing_Information__c> insertPirceInfoList = new List<ETT_Pricing_Information__c>();
    Map<Id, Boolean> collCCIdVshasNewTyrewoPrice = new Map<Id, Boolean>();
    Map<String, Id> keyVsTyreMasterId = new Map<String, Id>();
    Map<String, Id> newPricingInfoVsPriceMasId = new Map<String, Id>();
    Map<String, Id> newPricingInfoVsCCId = new Map<String, Id>();
    Map<String, ETT_Tyre_Inventory__c> keyVsTyreInv = new Map<String, ETT_Tyre_Inventory__c>();

    for (ETT_Tyre_Inventory__c ti : trgNewMap.values()) {
        accIds.add(ti.ETT_Account__c);
    }

    for (ETT_Price_Master__c pm : [
        SELECT Id, ETT_Party_Name__c 
        FROM ETT_Price_Master__c 
        WHERE ETT_Party_Name__c = :accIds
    ]) {
        accIdVsPriceMasId.put(pm.ETT_Party_Name__c, pm.Id);
    }

    for (ETT_Pricing_Information__c pc : [
        SELECT Id, ETT_Price__r.ETT_Party_Name__c, ETT_Price__c, ETT_Tyre_Size__c, ETT_Brand__c, ETT_Pattern__c, ETT_Country_of_Origin__c, ETT_Purchase_Price__c 
        FROM ETT_Pricing_Information__c 
        WHERE ETT_Price__r.ETT_Party_Name__c = :accIds
    ]) {
        String keyVal = pc.ETT_Tyre_Size__c + '-' + pc.ETT_Brand__c + '-' + pc.ETT_Pattern__c + '-' + pc.ETT_Country_of_Origin__c;
        keyVsPrice.put(keyVal, pc.ETT_Purchase_Price__c);
        keyVsPricInfoId.put(keyVal, pc.Id);
    }

    for (ETT_Tyre_Master__c tm : [
        SELECT Id, ETT_Brand_Name__c, ETT_Tyre_Size__c, ETT_Original_Pattern__c, ETT_Country_Name__c 
        FROM ETT_Tyre_Master__c 
        WHERE RecordType.Name = 'Approved'
    ]) {
        String keyVal = tm.ETT_Tyre_Size__c + '-' + tm.ETT_Brand_Name__c + '-' + tm.ETT_Original_Pattern__c + '-' + tm.ETT_Country_Name__c;
        keyVsTyreMasterId.put(keyVal, tm.Id);
    }

    for (ETT_Tyre_Inventory__c ti : trgNewMap.values()) {
        if (ti.ETT_Tyre_Size_Master__c != trgOldMap.get(ti.Id).ETT_Tyre_Size_Master__c || 
            ti.ETT_Pattern__c != trgOldMap.get(ti.Id).ETT_Pattern__c ||
            ti.ETT_Brand__c != trgOldMap.get(ti.Id).ETT_Brand__c || 
            ti.ETT_Country__c != trgOldMap.get(ti.Id).ETT_Country__c || 
            ti.Purchase_Price__c == 0 || 
            ti.Pricing_Information__c == null) {

            String keyVal = ti.ETT_Tyre_Size_Master__c + '-' + ti.ETT_Brand__c + '-' + ti.ETT_Pattern__c + '-' + ti.ETT_Country__c;
            if (keyVsTyreMasterId.containsKey(keyVal)) {
                ti.ETT_Tyre_Master__c = keyVsTyreMasterId.get(keyVal);
            }

            if (keyVsPrice.containsKey(keyVal)) {
                ti.Pricing_Information__c = keyVsPricInfoId.get(keyVal);
                ti.Purchase_Price__c = keyVsPrice.get(keyVal);
                collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, false); 
            } else {
                ti.Pricing_Information__c = null;
                ti.Purchase_Price__c = 0;
                if (ti.Party_Type__c != 'Internal' && ti.Party_Type__c != 'Internal Private') {
                    collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, true); 
                    newPricingInfoVsPriceMasId.put(keyVal, accIdVsPriceMasId.get(ti.ETT_Account__c));
                    newPricingInfoVsCCId.put(keyVal, ti.ETT_Collection_Card__c);
                    keyVsTyreInv.put(keyVal, ti);
                }
            }
        }
    }

    for (String st : newPricingInfoVsPriceMasId.keySet()) {
        List<String> tempList = st.split('-');
        ETT_Tyre_Inventory__c tyreInv = keyVsTyreInv.get(st);
        if (tyreInv.Party_Type__c != 'Internal' && tyreInv.Party_Type__c != 'Internal Private') {
            ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();  
            epi.ETT_Price__c = newPricingInfoVsPriceMasId.get(st);
            epi.ETT_Approval_Status__c = 'New';
            epi.Collection_Card__c = newPricingInfoVsCCId.get(st);
            epi.RecordTypeId = tyreInv.Party_Type__c == 'Supplier' ? 
                Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() : 
                Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            epi.ETT_Brand__c = tempList[1];
            epi.ETT_Pattern__c = tempList[2];
            epi.ETT_Country_of_Origin__c = tempList[3];
            epi.ETT_Tyre_Size__c = tempList[0];
            epi.ETT_Purchase_Price__c = 0;
            insertPirceInfoList.add(epi);
        }
    }

    for (Id idval : collCCIdVshasNewTyrewoPrice.keySet()) {
        if (idval != null) {
            ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
            cc.Id = idval;
            cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
            ccUpdateList.add(cc);
        }
    }

    if (!ccUpdateList.isEmpty()) {
        update ccUpdateList;
    }

    if (!insertPirceInfoList.isEmpty()) {
        insert insertPirceInfoList;
    }
}
*/

    /*
    public static void updatePriceInfoOnInsert(list<ETT_Tyre_Inventory__c> trgNew){//Whie Tyre Inventory Inserting
        
        set<id> accIds = new set<id>();
        map<string,double> keyVsPrice = new  map<string,double>();
        map<string,String> keyVsPricInfoId = new  map<string,string>();
        list<ETT_Collection_Card__c> ccUpdateList = new list<ETT_Collection_Card__c>();    
        map<id,id> accIdVsPriceMasId = new map<id,id>();
        list<ETT_Pricing_Information__c> insertPirceInfoList = new  list<ETT_Pricing_Information__c>();
        Map<id,boolean> collCCIdVshasNewTyrewoPrice = new map<id,boolean>();
        map<string,id> keyVsTyreMasterId = new map<string,id>();
        map<string,id> newPricingInfoVsPriceMasId = new map<string,id>();//to remove duplicate pricing information
        map<string,id> newPricingInfoVsCCId = new map<string,id>();//to Map collcard id to pricing infomation
        map<string,ETT_Tyre_Inventory__c> keyVsTyreInv = new map<string,ETT_Tyre_Inventory__c>();
        
        for(ETT_Tyre_Inventory__c ti : trgNew){
            
            accIds.add(ti.ETT_Account__c);
        }
        for(ETT_Price_Master__c pm : [select id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c=:accIds]){
            
            accIdVsPriceMasId.put(pm.ETT_Party_Name__c,pm.Id);
        }       
        
        for(ETT_Tyre_Master__c tm : [select id,ETT_Brand_Name__c,ETT_Tyre_Size__c,ETT_Original_Pattern__c,ETT_Country_Name__c from ETT_Tyre_Master__c where recordType.Name='Approved']){
            string keyval = tm.ETT_Tyre_Size__c+'-'+tm.ETT_Brand_Name__c+'-'+tm.ETT_Original_Pattern__c+'-'+tm.ETT_Country_Name__c;
            keyVsTyreMasterId.put(keyval,tm.Id);
            
        }
        
        for(ETT_Pricing_Information__c pc : [select id,ETT_Price__c, ETT_Price__r.ETT_Party_Name__c,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Pattern__c,ETT_Country_of_Origin__c,ETT_Purchase_Price__c from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c=:accIds]){
            string keyVal = pc.ETT_Tyre_Size__c+'-'+pc.ETT_Brand__c+'-'+pc.ETT_Pattern__c+'-'+pc.ETT_Country_of_Origin__c;
            keyVsPrice.put( keyVal,pc.ETT_Purchase_Price__c);
            keyVsPricInfoId.put(keyVal,pc.Id);
        }
        
        for(ETT_Tyre_Inventory__c ti : trgNew){
            
            string keyVal = ti.ETT_Tyre_Size_Master__c+'-'+ti.ETT_Brand__c+'-'+ti.ETT_Pattern__c+'-'+ti.ETT_Country__c;
            
            if(keyVsTyreMasterId.containskey(keyVal)){
                // system.debug('--val--'+keyVsTyreMasterId.get(keyVal));
                ti.ETT_Tyre_Master__c = keyVsTyreMasterId.get(keyVal);
            }
            
            if(ti.Party_Type__c == 'Supplier'){
                ti.Stockable__c = true;
                ti.Tyre_Type__c ='Used';
            }
         

            if(keyVsPrice.containsKey(keyVal)){
                ti.Pricing_Information__c = keyVsPricInfoId.get(keyVal);
                ti.Purchase_Price__c = keyVsPrice.get(keyVal);
                collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c,false); 
            }else{
                ti.Pricing_Information__c = null;
                ti.Purchase_Price__c = 0;
                if(ti.Party_Type__c !='Internal' || ti.Party_Type__c!='Internal Private'){
                    
                    collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c,true); 
                    system.debug('HASE TYRE TURE'+collCCIdVshasNewTyrewoPrice);
                  }
                
                if(ti.ETT_Inventory_Status__c != 'Approved by Receptionist'&& ti.Party_Type__c != 'Internal'|| ti.Party_Type__c!='Internal Private'){
                    
                    newPricingInfoVsPriceMasId.put(keyVal, accIdVsPriceMasId.get(ti.ETT_Account__c));
                    newPricingInfoVsCCId.put(keyVal,ti.ETT_Collection_Card__c);
                    keyVsTyreInv.put(keyVal,ti);
                    
                }
                system.debug('--'+newPricingInfoVsPriceMasId);
                system.debug('--'+newPricingInfoVsCCId);
                system.debug('--'+keyVsTyreInv);

            }
            
        }
        
        //make list of new pricing information from set
        for(string st : newPricingInfoVsPriceMasId.keySet()){
            system.debug('-priceId-'+newPricingInfoVsPriceMasId.get(st));
            system.debug('-priceId-'+st);
            List<String> tempList = st.split('-');
            //Create Pricing information that is not there in supplier price master
            ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();  
            epi.ETT_Price__c = newPricingInfoVsPriceMasId.get(st);
            epi.ETT_Approval_Status__c ='New';
            epi.Collection_Card__c= newPricingInfoVsCCId.get(st);
            if(keyVsTyreInv.get(st).Party_Type__c =='Supplier'){
                epi.RecordTypeId =   Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
  
            }else{
             epi.RecordTypeId =   Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
 
            }
            epi.ETT_Brand__c = tempList[1];
            system.debug('==========>'+tempList[2]);
            system.debug('==========>'+String.isblank(tempList[2]));
             if( tempList[2]!='null')epi.ETT_Pattern__c =tempList[2];
             if( tempList[3]!='null')epi.ETT_Country_of_Origin__c = tempList[3];
             if( tempList[0]!='null') epi.ETT_Tyre_Size__c = tempList[0];
            epi.ETT_Purchase_Price__c = 0;
            insertPirceInfoList.add(epi);
            system.debug('sandip' + insertPirceInfoList);
        }
        for(id idval : collCCIdVshasNewTyrewoPrice.keyset() ){
            if(idval != null){
                ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                cc.Id = idval;
                cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
                ccUpdateList.add(cc);   
            }
        }
        update ccUpdateList;
        insert insertPirceInfoList;
    }
*/
   /* public static void updatePriceInUpdate(Map<Id,ETT_Tyre_Inventory__c> trgNewMap,Map<Id,ETT_Tyre_Inventory__c> trgOldMap){
       
            set<id> accIds = new set<id>();
            map<string,double> keyVsPrice = new  map<string,double>();
            map<string,String> keyVsPricInfoId = new  map<string,string>();
            list<ETT_Collection_Card__c> ccUpdateList = new list<ETT_Collection_Card__c>();
            map<id,id> accIdVsPriceMasId = new map<id,id>();
            list<ETT_Pricing_Information__c> insertPirceInfoList = new  list<ETT_Pricing_Information__c>();
            Map<id,boolean> collCCIdVshasNewTyrewoPrice = new map<id,boolean>();
            map<string,id> keyVsTyreMasterId = new map<string,id>();
            map<string,id> newPricingInfoVsPriceMasId = new map<string,id>();//to remove duplicate pricing information
            map<string,id> newPricingInfoVsCCId = new map<string,id>();//to Map collcard id to pricing infomation
             map<string,ETT_Tyre_Inventory__c> keyVsTyreInv = new map<string,ETT_Tyre_Inventory__c>();

            for(ETT_Tyre_Inventory__c ti : trgNewMap.values()){
                
                accIds.add(ti.ETT_Account__c);
            }
       
            for(ETT_Price_Master__c pm : [select id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c=:accIds]){
                
                accIdVsPriceMasId.put(pm.ETT_Party_Name__c,pm.Id);
            }
            for(ETT_Pricing_Information__c pc : [select id,ETT_Price__r.ETT_Party_Name__c,ETT_Price__c,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Pattern__c,ETT_Country_of_Origin__c,ETT_Purchase_Price__c from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c=:accIds]){
                string keyVal = pc.ETT_Tyre_Size__c+'-'+pc.ETT_Brand__c+'-'+pc.ETT_Pattern__c+'-'+pc.ETT_Country_of_Origin__c;
                keyVsPrice.put( keyVal,pc.ETT_Purchase_Price__c);
                keyVsPricInfoId.put(keyVal,pc.Id);
                
            }
            for(ETT_Tyre_Master__c tm : [select id,ETT_Brand_Name__c,ETT_Tyre_Size__c,ETT_Original_Pattern__c,ETT_Country_Name__c from ETT_Tyre_Master__c where recordType.Name='Approved']){
                string keyval = tm.ETT_Tyre_Size__c+'-'+tm.ETT_Brand_Name__c+'-'+tm.ETT_Original_Pattern__c+'-'+tm.ETT_Country_Name__c;
                keyVsTyreMasterId.put(keyval,tm.Id);
                
            }
       
            for(ETT_Tyre_Inventory__c ti : trgNewMap.values()){
                
                
                if(ti.ETT_Tyre_Size_Master__c!= trgOldMap.get(ti.id).ETT_Tyre_Size_Master__c || ti.ETT_Pattern__c!= trgOldMap.get(ti.id).ETT_Pattern__c ||
                   ti.ETT_Brand__c!= trgOldMap.get(ti.id).ETT_Brand__c || ti.ETT_Country__c!= trgOldMap.get(ti.id).ETT_Country__c || ti.Purchase_Price__c == 0 || ti.Pricing_Information__c == null){
                       
                       string keyVal = ti.ETT_Tyre_Size_Master__c+'-'+ti.ETT_Brand__c+'-'+ti.ETT_Pattern__c+'-'+ti.ETT_Country__c;
                       if(keyVsTyreMasterId.containskey(keyVal)){
                           ti.ETT_Tyre_Master__c = keyVsTyreMasterId.get(keyVal);
                       }
                       
                       if(keyVsPrice.containsKey(keyVal)){
                           ti.Pricing_Information__c = keyVsPricInfoId.get(keyVal);
                           ti.Purchase_Price__c = keyVsPrice.get(keyVal);
                           collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c,false); 
                           
                       }else{
                           ti.Pricing_Information__c = null;
                           ti.Purchase_Price__c = 0;
                           collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c,true); 
                           
                           newPricingInfoVsPriceMasId.put(keyVal, accIdVsPriceMasId.get(ti.ETT_Account__c));
                           newPricingInfoVsCCId.put(keyVal,ti.ETT_Collection_Card__c);
                           keyVsTyreInv.put(keyVal,ti);
                       }
                       
                   }
                
            }
              
            //make list of new pricing information from set
            for(string st : newPricingInfoVsPriceMasId.keySet()){
                
                List<String> tempList = st.split('-');
                //Create Pricing information that is not there in supplier price master
                ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();  
                epi.ETT_Price__c = newPricingInfoVsPriceMasId.get(st);
                epi.ETT_Approval_Status__c ='New';
                epi.Collection_Card__c = newPricingInfoVsCCId.get(st);
                if(keyVsTyreInv.get(st).Party_Type__c =='Supplier'){
                    epi.RecordTypeId =   Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                    
                }else{
                    epi.RecordTypeId =   Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                    
                }  
                epi.ETT_Brand__c = tempList[1];
                epi.ETT_Pattern__c = tempList[2];
                epi.ETT_Country_of_Origin__c = tempList[3];
                epi.ETT_Tyre_Size__c = tempList[0];
                epi.ETT_Purchase_Price__c = 0;
                insertPirceInfoList.add(epi);
            }
            for(id idval : collCCIdVshasNewTyrewoPrice.keyset() ){
                ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                if(idval != null){
                    cc.Id = idval;
                    cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
                    ccUpdateList.add(cc);   
                }
            }
            if(ccUpdateList.size()>0 && ccUpdateList != null){
                update ccUpdateList;
            }
            
            insert insertPirceInfoList;
        
    }
    */
    /*
    public static void updatePriceInUpdate(Map<Id, ETT_Tyre_Inventory__c> trgNewMap, Map<Id, ETT_Tyre_Inventory__c> trgOldMap) {
    Set<Id> accIds = new Set<Id>();
    Map<String, Double> keyVsPrice = new Map<String, Double>();
    Map<String, String> keyVsPricInfoId = new Map<String, String>();
    List<ETT_Collection_Card__c> ccUpdateList = new List<ETT_Collection_Card__c>();
    Map<Id, Id> accIdVsPriceMasId = new Map<Id, Id>();
    List<ETT_Pricing_Information__c> insertPirceInfoList = new List<ETT_Pricing_Information__c>();
    Map<Id, Boolean> collCCIdVshasNewTyrewoPrice = new Map<Id, Boolean>();
    Map<String, Id> keyVsTyreMasterId = new Map<String, Id>();
    Map<String, Id> newPricingInfoVsPriceMasId = new Map<String, Id>();
    Map<String, Id> newPricingInfoVsCCId = new Map<String, Id>();
    Map<String, ETT_Tyre_Inventory__c> keyVsTyreInv = new Map<String, ETT_Tyre_Inventory__c>();

    for (ETT_Tyre_Inventory__c ti : trgNewMap.values()) {
        accIds.add(ti.ETT_Account__c);
    }

    for (ETT_Price_Master__c pm : [
        SELECT Id, ETT_Party_Name__c 
        FROM ETT_Price_Master__c 
        WHERE ETT_Party_Name__c = :accIds
    ]) {
        accIdVsPriceMasId.put(pm.ETT_Party_Name__c, pm.Id);
    }

    for (ETT_Pricing_Information__c pc : [
        SELECT Id, ETT_Price__r.ETT_Party_Name__c, ETT_Price__c, ETT_Tyre_Size__c, ETT_Brand__c, ETT_Pattern__c, ETT_Country_of_Origin__c, ETT_Purchase_Price__c 
        FROM ETT_Pricing_Information__c 
        WHERE ETT_Price__r.ETT_Party_Name__c = :accIds
    ]) {
        String keyVal = pc.ETT_Tyre_Size__c + '-' + pc.ETT_Brand__c + '-' + pc.ETT_Pattern__c + '-' + pc.ETT_Country_of_Origin__c;
        keyVsPrice.put(keyVal, pc.ETT_Purchase_Price__c);
        keyVsPricInfoId.put(keyVal, pc.Id);
    }

    for (ETT_Tyre_Master__c tm : [
        SELECT Id, ETT_Brand_Name__c, ETT_Tyre_Size__c, ETT_Original_Pattern__c, ETT_Country_Name__c 
        FROM ETT_Tyre_Master__c 
        WHERE RecordType.Name = 'Approved'
    ]) {
        String keyVal = tm.ETT_Tyre_Size__c + '-' + tm.ETT_Brand_Name__c + '-' + tm.ETT_Original_Pattern__c + '-' + tm.ETT_Country_Name__c;
        keyVsTyreMasterId.put(keyVal, tm.Id);
    }

    for (ETT_Tyre_Inventory__c ti : trgNewMap.values()) {
        if (ti.ETT_Tyre_Size_Master__c != trgOldMap.get(ti.Id).ETT_Tyre_Size_Master__c || 
            ti.ETT_Pattern__c != trgOldMap.get(ti.Id).ETT_Pattern__c ||
            ti.ETT_Brand__c != trgOldMap.get(ti.Id).ETT_Brand__c || 
            ti.ETT_Country__c != trgOldMap.get(ti.Id).ETT_Country__c || 
            ti.Purchase_Price__c == 0 || 
            ti.Pricing_Information__c == null) {

            String keyVal = ti.ETT_Tyre_Size_Master__c + '-' + ti.ETT_Brand__c + '-' + ti.ETT_Pattern__c + '-' + ti.ETT_Country__c;
            if (keyVsTyreMasterId.containsKey(keyVal)) {
                ti.ETT_Tyre_Master__c = keyVsTyreMasterId.get(keyVal);
            }

            if (keyVsPrice.containsKey(keyVal)) {
                ti.Pricing_Information__c = keyVsPricInfoId.get(keyVal);
                ti.Purchase_Price__c = keyVsPrice.get(keyVal);
                collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, false); 
            } else {
                ti.Pricing_Information__c = null;
                ti.Purchase_Price__c = 0;
                if(ti.Party_Type__c !='Internal'|| ti.Party_Type__c!='Internal Private'){
                    collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c, true); 
                }
                
                newPricingInfoVsPriceMasId.put(keyVal, accIdVsPriceMasId.get(ti.ETT_Account__c));
                newPricingInfoVsCCId.put(keyVal, ti.ETT_Collection_Card__c);
                keyVsTyreInv.put(keyVal, ti);
            }
        }
    }

    for (String st : newPricingInfoVsPriceMasId.keySet()) {
        List<String> tempList = st.split('-');
        ETT_Tyre_Inventory__c tyreInv = keyVsTyreInv.get(st);
        if (tyreInv.Party_Type__c != 'Internal' || tyreInv.Party_Type__c!='Internal Private') {
            ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();  
            epi.ETT_Price__c = newPricingInfoVsPriceMasId.get(st);
            epi.ETT_Approval_Status__c = 'New';
            epi.Collection_Card__c = newPricingInfoVsCCId.get(st);
            epi.RecordTypeId = tyreInv.Party_Type__c == 'Supplier' ? 
                Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() : 
                Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            epi.ETT_Brand__c = tempList[1];
            epi.ETT_Pattern__c = tempList[2];
            epi.ETT_Country_of_Origin__c = tempList[3];
            epi.ETT_Tyre_Size__c = tempList[0];
            epi.ETT_Purchase_Price__c = 0;
            insertPirceInfoList.add(epi);
        }
    }

    for (Id idval : collCCIdVshasNewTyrewoPrice.keySet()) {
        if (idval != null) {
            ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
            cc.Id = idval;
            cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
            ccUpdateList.add(cc);
        }
    }

    if (!ccUpdateList.isEmpty()) {
        update ccUpdateList;
    }

    if (!insertPirceInfoList.isEmpty()) {
        insert insertPirceInfoList;
    }
}
*/

    
    public static void updateCollCard(list<ETT_Tyre_Inventory__c> trgNew,Map<Id,ETT_Tyre_Inventory__c> trgOldMap){
        
        Set<Id> collCardIdset = new Set<Id>();
        Map<Id, ETT_Tyre_Inventory__c> tyreInventoryMap = new Map<Id, ETT_Tyre_Inventory__c>();
        if(Trigger.isInsert || Trigger.isUndelete){
            for(ETT_Tyre_Inventory__c tyre :trgNew)
            {
                collCardIdset.add(tyre.ETT_Collection_Card__c);
                if(tyre.Pricing_Information__c != null){
                    tyreInventoryMap.put(tyre.Pricing_Information__c,tyre);
                }
            }
            
            updatePricing(tyreInventoryMap);
        }
        if(Trigger.isUpdate){
            for(ETT_Tyre_Inventory__c tyre : [SELECT Id, Pricing_Information__c, Pricing_Information__r.Job_Type__c, Job_Type__c, ETT_Collection_Card__c FROM ETT_Tyre_Inventory__c
                                             WHERE Id IN: trgNew])
            {
                if(tyre.ETT_Collection_Card__c !=trgOldMap.get(tyre.Id).ETT_Collection_Card__c){
                    collCardIdset.add(tyre.ETT_Collection_Card__c);  
                }
                if(tyre.Pricing_Information__c != null && (tyre.Pricing_Information__c != trgOldMap.get(tyre.Id).Pricing_Information__c || tyre.Job_Type__c != trgOldMap.get(tyre.Id).Job_Type__c)){
                    tyreInventoryMap.put(tyre.Pricing_Information__c,tyre);
                    //System.debug('tyre.Pricing_Information__r.Job_Type__c '+tyre.Pricing_Information__r.Job_Type__c);
                }
            }
            
            updatePricing(tyreInventoryMap);
        }
        
        if(Trigger.isDelete){
            
            for(ETT_Tyre_Inventory__c tyre :trgOldMap.values())
            {
                collCardIdset.add(tyre.ETT_Collection_Card__c);
            }
        }
        
        list<ETT_Collection_Card__c> ccList = [select id,name,(select id from Tyre_Inventory__r) from ETT_Collection_Card__c where Id=:collCardIdset];
        
        for(ETT_Collection_Card__c cc : ccList){
            
            cc.No_of_Tyres__c = cc.Tyre_Inventory__r.size();
        }
        update ccList;
    }
    
    Public static void updatePricing(Map<Id, ETT_Tyre_Inventory__c> tyreInventoryMap){
        List<ETT_Pricing_Information__c> pricingToUpdate = new List<ETT_Pricing_Information__c>([SELECT Id, Job_Type__c FROM ETT_Pricing_Information__c WHERE Id IN: tyreInventoryMap.keySet()]);
        for(ETT_Pricing_Information__c objPricing : pricingToUpdate){
            if(tyreInventoryMap.containsKey(objPricing.Id)){
                objPricing.Job_Type__c = tyreInventoryMap.get(objPricing.Id).Job_Type__c;
            }
        }
        if(!pricingToUpdate.isEmpty()){
            update pricingToUpdate;
        }
    }
    
}