public class ETT_CreateNewEstimationsController {
    @auraEnabled 
    public static Tyre_Estimation__c getTyreEstimations(String estimationId){
        Tyre_Estimation__c objTyreEstimation=[select id,SubInventory__c,Account__c,Account__r.Name,SubInventory__r.Name from Tyre_Estimation__c where id=:estimationId]; 
        return objTyreEstimation; 
    }
 /*   
    @auraEnabled 
    public static list<TyreInventoryWrapper> getTyreDetails(String serialVal, String tyreSizeVal, String brandVal, String patternVal, String tyreType, String countryVal, String customerVal, string threadPattern, string subInventoryIdval) {
        System.debug('countryVal ' + countryVal);
        System.debug('TyreType ' + tyreType);
        System.debug('customerVal ' + customerVal);
        System.debug('SubInvnetoryID ' + subInventoryIdval);
        String query = 'SELECT Id, Tyre_Type__c,Party_Type__c,SubInventory__c, Unit_Price__c, Name, ETT_Tyre_Size_Master__r.Name, Serial_Number__c, ETT_Brand__r.Name, ETT_Pattern__r.Name, ETT_Country__r.Name, ETT_Collection_Card__r.Name, ETT_Account__r.Name from ETT_Tyre_Inventory__c WHERE Id NOT IN (SELECT Tyre_Inventory__c FROM Tyre_Estimation_Line_Item__c) AND ((Party_Type__c=\'Supplier\' OR Party_Type__c=\'Internal\') OR (Party_Type__c=\'Internal Private\' OR Party_Type__c=\'Null\')) ';
        System.debug('Sandip ' + query);
        Set<Id> setInventryIds = new Set<Id>();
        
        if (threadPattern != null && threadPattern != '') {
            System.debug('Sandip ' + threadPattern);
            List<ETT_Job_Card_Close__c> lstETTJobCardClose = [SELECT Id, Job_Card__c FROM ETT_Job_Card_Close__c WHERE Thread_Pattern__c = :threadPattern];
            System.debug('Sandip ' + lstETTJobCardClose);
            Set<Id> setJobIds = new Set<Id>();
            
            for (ETT_Job_Card_Close__c e : lstETTJobCardClose) {
                setJobIds.add(e.Job_Card__c);
            }
            
            List<ETT_Job_Card__c> lstETTJobCard = [SELECT Id, Tyre_Inventory__c FROM ETT_Job_Card__c WHERE Id IN :setJobIds];
            for (ETT_Job_Card__c jc : lstETTJobCard) {
                setInventryIds.add(jc.Tyre_Inventory__c);
            }
        }
        
        if (setInventryIds.size() > 0) {
            System.debug('setInventryIds' + setInventryIds);
            query += 'AND Id IN :setInventryIds ';
        }
        
        if (serialVal != null && serialVal != '') {
            query += 'AND Serial_Number__c = :serialVal ';
        }
        if (tyreSizeVal != null && tyreSizeVal != '') {
            query += 'AND ETT_Tyre_Size_Master__r.Name = :tyreSizeVal ';
        }
        if (brandVal != null && brandVal != '') {
            query += 'AND ETT_Brand__r.Name = :brandVal ';
        }
        if (patternVal != null && patternVal != '') {
            query += 'AND ETT_Pattern__r.Name = :patternVal ';
        }
        
        if (tyreType != null && tyreType != '') {
            query += 'AND Tyre_Type__c = :tyreType';
        } else {
            query += 'AND (Tyre_Type__c = \'Refurbished\' OR Tyre_Type__c  = \'New\' OR Tyre_Type__c  = \'Scrapped\') ';
        }
        if (countryVal != null && countryVal != '') {
            query += 'AND ETT_Country__r.Name = :countryVal ';
        }
        if (subInventoryIdval != null && subInventoryIdval != '') {
            query += 'AND SubInventory__c = :subInventoryIdval ';
        }
        
        Account accObj;
        if (customerVal != null && customerVal != '') {
            List<Account> accList = new List<Account>([SELECT Id, AccountNumber FROM Account WHERE Id = :customerVal]);
            if (!accList.isEmpty()) {
                accObj = accList[0];
            }
        }
        System.debug('accObj ' + accObj);
        Map<String, TyreInventoryPriceSettings__c> internalTyreInventoryPSMap = new Map<String, TyreInventoryPriceSettings__c>();
        Map<String, TyreInventoryPriceSettings__c> internalPrivateTyreInventoryPSMap = new Map<String, TyreInventoryPriceSettings__c>();
        Map<String, TyreInventoryPriceSettings__c> customerTyreInventoryPSMap = new Map<String, TyreInventoryPriceSettings__c>();
        
        for (TyreInventoryPriceSettings__c tyreInventory : [SELECT Name, Party_Type__c, Party_code__c, Selling_Price__c FROM TyreInventoryPriceSettings__c]) {
            if (tyreInventory.Party_Type__c == 'Internal') {
                internalTyreInventoryPSMap.put(tyreInventory.Name, tyreInventory);
            } else if (tyreInventory.Party_Type__c == 'Internal Private') {
                internalPrivateTyreInventoryPSMap.put(tyreInventory.Name, tyreInventory);
            } else if (tyreInventory.Party_Type__c == 'Customer' && customerVal != null && customerVal != '') {
                System.debug('in');
                customerTyreInventoryPSMap.put(tyreInventory.Party_code__c + '-' + tyreInventory.Name, tyreInventory);
            }
        }
        
        List<ETT_Tyre_Inventory__c> tyreList = Database.query(query + ' LIMIT 49000');
        
        List<TyreInventoryWrapper> wrapTyreInventoryList = new List<TyreInventoryWrapper>();
        for (ETT_Tyre_Inventory__c tyre : tyreList) {
            String mapKey = accObj != null ? accObj.AccountNumber + '-' + tyre.ETT_Tyre_Size_Master__r.Name : tyre.ETT_Tyre_Size_Master__r.Name;
            
            if (tyre.Party_Type__c == 'Internal') {
                if (internalTyreInventoryPSMap.containsKey(tyre.ETT_Tyre_Size_Master__r.Name)) {
                    Decimal sellingPrice = internalTyreInventoryPSMap.get(tyre.ETT_Tyre_Size_Master__r.Name).Selling_Price__c;
                    wrapTyreInventoryList.add(new TyreInventoryWrapper(tyre, sellingPrice));
                }
            } else if (tyre.Party_Type__c == 'Internal Private' && tyre.SubInventory__c == subInventoryIdval) {
                if (internalPrivateTyreInventoryPSMap.containsKey(tyre.ETT_Tyre_Size_Master__r.Name)) {
                    Decimal sellingPrice = internalPrivateTyreInventoryPSMap.get(tyre.ETT_Tyre_Size_Master__r.Name).Selling_Price__c;
                    wrapTyreInventoryList.add(new TyreInventoryWrapper(tyre, sellingPrice));
                }
            } else if (customerVal != null && customerVal != '' && (tyre.Party_Type__c == 'Customer' || tyre.Party_Type__c == 'Internal')) {
                if (customerTyreInventoryPSMap.containsKey(mapKey)) {
                    System.debug('in');
                    Decimal sellingPrice = customerTyreInventoryPSMap.get(mapKey).Selling_Price__c;
                    wrapTyreInventoryList.add(new TyreInventoryWrapper(tyre, sellingPrice));
                }
            }
        }
        System.debug('Wrap Tyre Inventory List: ' + wrapTyreInventoryList);
        return wrapTyreInventoryList;
    }
    
    */
    @auraEnabled 
public static list<TyreInventoryWrapper> getTyreDetails(String serialVal, String tyreSizeVal, String brandVal, String patternVal, String tyreType, String countryVal, String customerVal, string threadPattern, string subInventoryIdval) {
  
     String query = 'SELECT Id, Party_Type__c, Job_Type__c,SubInventory__c, Tyre_Type__c, Unit_Price__c, Name, ETT_Tyre_Size_Master__r.Name, Serial_Number__c, ETT_Brand__r.Name, ETT_Pattern__r.Name, ETT_Country__r.Name, ETT_Collection_Card__r.Name, ETT_Account__r.Name ' +
                   'FROM ETT_Tyre_Inventory__c ' +
                   'WHERE Id NOT IN (SELECT Tyre_Inventory__c FROM Tyre_Estimation_Line_Item__c) ' +
                   'AND ((Party_Type__c = \'Supplier\' OR Party_Type__c = \'Internal\') OR (Party_Type__c = \'Internal Private\' OR Party_Type__c = \'Null\'))';
    Set<Id> setInventryIds = new Set<Id>();

    if (threadPattern != null && threadPattern != '') {
        List<ETT_Job_Card_Close__c> lstETTJobCardClose = [SELECT Id, Job_Card__c FROM ETT_Job_Card_Close__c WHERE Thread_Pattern__c = :threadPattern];
        Set<Id> setJobIds = new Set<Id>();

        for (ETT_Job_Card_Close__c e : lstETTJobCardClose) {
            setJobIds.add(e.Job_Card__c);
        }

        List<ETT_Job_Card__c> lstETTJobCard = [SELECT Id, Tyre_Inventory__c FROM ETT_Job_Card__c WHERE Id IN :setJobIds];
        for (ETT_Job_Card__c jc : lstETTJobCard) {
            setInventryIds.add(jc.Tyre_Inventory__c);
        }
    }

  
    if (setInventryIds.size() > 0) {
        query += ' AND Id IN :setInventryIds';
    }

    if (serialVal != null && serialVal != '') {
        query += ' AND Serial_Number__c = :serialVal';
    }
    if (tyreSizeVal != null && tyreSizeVal != '') {
        query += ' AND ETT_Tyre_Size_Master__r.Name = :tyreSizeVal';
    }
    if (brandVal != null && brandVal != '') {
        query += ' AND ETT_Brand__r.Name = :brandVal';
    }
    if (patternVal != null && patternVal != '') {
        query += ' AND ETT_Pattern__r.Name = :patternVal';
    }
    if (tyreType != null && tyreType != '') {
        query += ' AND Tyre_Type__c = :tyreType';
    } else {
        query += ' AND (Tyre_Type__c = \'Refurbished\' OR Tyre_Type__c = \'New\' OR Tyre_Type__c = \'Scrapped\')';
    }
    if (countryVal != null && countryVal != '') {
        query += ' AND ETT_Country__r.Name = :countryVal';
    }
   /* if (subInventoryIdval != null && subInventoryIdval != '') {
      query += ' AND (Party_Type__c = \'Internal Private\' OR SubInventory__c = :subInventoryIdval)';
    }
*/


    Account accObj;
    if (customerVal != null && customerVal != '') {
        List<Account> accList = [SELECT Id, AccountNumber FROM Account WHERE Id = :customerVal];
        if (!accList.isEmpty()) {
            accObj = accList[0];
        }
    }
    System.debug('accObj ' + accObj);

    Map<String, TyreInventoryPriceSettings__c> internalTyreInventoryPSMap = new Map<String, TyreInventoryPriceSettings__c>();
   // Map<String, TyreInventoryPriceSettings__c> internalPrivateTyreInventoryPSMap = new Map<String, TyreInventoryPriceSettings__c>();
    Map<String, TyreInventoryPriceSettings__c> customerTyreInventoryPSMap = new Map<String, TyreInventoryPriceSettings__c>();

    for (TyreInventoryPriceSettings__c tyreInventory : [SELECT Name, Party_Type__c, Party_code__c,Send_Back_Price__c,Retread_Price__c,Repair_Price__c, Selling_Price__c FROM TyreInventoryPriceSettings__c]) {
        if (tyreInventory.Party_Type__c == 'Internal') {
            internalTyreInventoryPSMap.put(tyreInventory.Name, tyreInventory);
        } else if (tyreInventory.Party_Type__c == 'Internal Private') {
           // internalPrivateTyreInventoryPSMap.put(tyreInventory.Name, tyreInventory);
        } else if (tyreInventory.Party_Type__c == 'Customer' && customerVal != null && customerVal != '') {
            customerTyreInventoryPSMap.put(tyreInventory.Party_code__c + '-' + tyreInventory.Name, tyreInventory);
        }
    }
     System.debug('query '+query);
     System.debug('query@@@@ '+internalTyreInventoryPSMap);
    // Constructing final query with conditions
    List<ETT_Tyre_Inventory__c> tyreList;
    if (subInventoryIdval != null && subInventoryIdval != '') {
        tyreList = Database.query(query + ' LIMIT 49000');
      //  tyreList = Database.query(query + ' AND (Party_Type__c != \'Internal Private\' OR SubInventory__c = :subInventoryIdval) LIMIT 49000');
    } else {
        tyreList = Database.query(query + ' LIMIT 49000');
    }
    
   // List<ETT_Tyre_Inventory__c> tyreList = Database.query(query + ' LIMIT 49000');
    System.debug('tyreList size '+tyreList.size()+' values '+tyreList);
    List<TyreInventoryWrapper> wrapTyreInventoryList = new List<TyreInventoryWrapper>();
    for (ETT_Tyre_Inventory__c tyre : tyreList) {

        String mapKey = accObj != null ? accObj.AccountNumber + '-' + tyre.ETT_Tyre_Size_Master__r.Name : tyre.ETT_Tyre_Size_Master__r.Name;
        System.debug('Processing tyre: ' + tyre);
        System.debug('Map key: ' + mapKey);

        if (tyre.Party_Type__c == 'Internal' && customerVal == null && tyre.Party_Type__c!='Internal Private') {
            if (internalTyreInventoryPSMap.containsKey(tyre.ETT_Tyre_Size_Master__r.Name)) {
                Decimal sellingPrice = internalTyreInventoryPSMap.get(tyre.ETT_Tyre_Size_Master__r.Name).Selling_Price__c;
                System.debug('Selling Price (Internal): ' + sellingPrice);
                wrapTyreInventoryList.add(new TyreInventoryWrapper(tyre, sellingPrice));
            }
        } else if (tyre.Party_Type__c == 'Internal Private' && tyre.SubInventory__c == subInventoryIdval && tyre.Party_Type__c!='Internal' && tyre.Tyre_Type__c!='Send Back') {
            if (internalTyreInventoryPSMap.containsKey(tyre.ETT_Tyre_Size_Master__r.Name)) {
               // Decimal sellingPrice = internalTyreInventoryPSMap.get(tyre.ETT_Tyre_Size_Master__r.Name).Selling_Price__c;
                Decimal repairVSretredPrice;
                if(tyre.Job_Type__c=='Retread'){
                    repairVSretredPrice = internalTyreInventoryPSMap.get(tyre.ETT_Tyre_Size_Master__r.Name).Retread_Price__c; // Assume you have Retread_Price__c field
                }else if(tyre.Job_Type__c=='Repair'){
                    repairVSretredPrice = internalTyreInventoryPSMap.get(tyre.ETT_Tyre_Size_Master__r.Name).Repair_Price__c; 

                }
                 System.debug('Selling Price (Internal Private): ' + repairVSretredPrice);
                wrapTyreInventoryList.add(new TyreInventoryWrapper(tyre, repairVSretredPrice));
            }

        } else if (customerVal != null && customerVal != '' && (tyre.Party_Type__c == 'Customer' || tyre.Party_Type__c == 'Internal' || tyre.Party_Type__c=='Supplier')) {
            if (customerTyreInventoryPSMap.containsKey(mapKey)) {
                Decimal sellingPrice = customerTyreInventoryPSMap.get(mapKey).Selling_Price__c;
                System.debug('Selling Price (Internal - Customer): ' + sellingPrice);
                wrapTyreInventoryList.add(new TyreInventoryWrapper(tyre, sellingPrice));
            }
        }
        else if(tyre.Party_Type__c == 'Internal Private' && internalTyreInventoryPSMap.containsKey(tyre.ETT_Tyre_Size_Master__r.Name) && tyre.Tyre_Type__c=='Send Back'){
            Decimal sendBackPrice = internalTyreInventoryPSMap.get(tyre.ETT_Tyre_Size_Master__r.Name).Send_Back_Price__c;
            wrapTyreInventoryList.add(new TyreInventoryWrapper(tyre, sendBackPrice));
            System.debug('send back Price ( Internal Private): ' + sendBackPrice);
        }else{
            System.debug('No to Matched');
        }
    }
    System.debug('Wrap Tyre Inventory List: ' + wrapTyreInventoryList);
    return wrapTyreInventoryList;
}

    
    @auraEnabled 
    public static list<Tyre_Estimation_Line_Item__c> createEstimations(list<TyreInventoryWrapper> selectedTyres, String customerId, String subInventoryId, String tyreEstimationId){
        
        Savepoint sp = Database.setSavepoint();
        
        List<Tyre_Estimation_Line_Item__c> listOfEstimationLI = new List<Tyre_Estimation_Line_Item__c>();
        Tyre_Estimation__c tyreEstimationObj = new Tyre_Estimation__c();
        Boolean hasInternalPrivate = false;
        
        // Check if any selected tyre has Party_Type__c as Internal Private
        for (TyreInventoryWrapper objWrap : selectedTyres) {
            if (objWrap.objTI.Party_Type__c == 'Internal Private') {
                hasInternalPrivate = true;
                break;
            }
        }
        if(tyreEstimationId == null || tyreEstimationId == ''){
            if(customerId != null && customerId != ''){
                tyreEstimationObj.Account__c = customerId;
                tyreEstimationObj.Type__c = 'Customer';
            }
            if(subInventoryId != null && subInventoryId != ''){
                tyreEstimationObj.SubInventory__c = subInventoryId;
                tyreEstimationObj.Type__c = 'Internal';
            }
            if (hasInternalPrivate) {
                tyreEstimationObj.Type__c = 'Internal Private';
                tyreEstimationObj.SubInventory__c = subInventoryId;
            }
            tyreEstimationObj.Status__c='Pending'; 
            tyreEstimationObj.Payment_Terms__c='Cash';
            insert tyreEstimationObj;
        }
        try{
            for(TyreInventoryWrapper objWrap:selectedTyres){
                system.debug('entered');
                Tyre_Estimation_Line_Item__c objEstimationLI = new Tyre_Estimation_Line_Item__c();
                objEstimationLI.Tyre_Inventory__c=objWrap.objTI.id;
                if(tyreEstimationId != null && tyreEstimationId != ''){
                    objEstimationLI.Tyre_Estimation__c = tyreEstimationId;
                }else{
                    objEstimationLI.Tyre_Estimation__c = tyreEstimationObj.id;
                }
                objEstimationLI.origin__c = objWrap.objTI.ETT_Country__r.Name;
                objEstimationLI.Original_pattern__c = objWrap.objTI.ETT_Pattern__r.Name;
                objEstimationLI.Serial_No__c = objWrap.objTI.Serial_Number__c;
                objEstimationLI.Tyre_size__c = objWrap.objTI.ETT_Tyre_Size_Master__r.Name;
                objEstimationLI.Collection_Card_No__c = objWrap.objTI.ETT_Collection_Card__c;
                objEstimationLI.Unit_Price__c = objWrap.unitPrice;
                listOfEstimationLI.add(objEstimationLI);
            }
            if(!listOfEstimationLI.isEmpty()){
                insert listOfEstimationLI;    
            }
            return [select id,name,Tyre_Estimation__r.Id,Tyre_Estimation__r.Name from Tyre_Estimation_Line_Item__c where id=:listOfEstimationLI limit 1];
            
        }catch(Exception e){
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
            system.debug('---err-'+e.getMessage());
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage()+'--'+e.getCause()+'--'+e.getStackTraceString()); 
        }    
    }
    
    public class TyreInventoryWrapper {
        @AuraEnabled
        public ETT_Tyre_Inventory__c objTI {get; set;}
        @AuraEnabled
        public decimal unitPrice {get; set;}
        public TyreInventoryWrapper(){}
        public TyreInventoryWrapper(ETT_Tyre_Inventory__c tyreInventoryObj, decimal uPrice) {
            objTI = tyreInventoryObj;
            if(uPrice != null){
                unitPrice = uPrice;
            }else{
                unitPrice = 0;
            }
        }
    }
    
}