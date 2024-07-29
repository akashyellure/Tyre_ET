/**
* Author: Janardhan
* Created Date:08/12/2021
* Test Class:ETT_DeliveryNote_AccCtrlTesthttps://icrm--tyre.sandbox.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage#
* 
**/
public class ETT_DeliveryNote_AccCtrl {
    
    @auraEnabled
    public static list<InspectionCardWrapper> getInsCards(string recordId, List<Id> quotationIds){
        
        
        List<Account> accountList = new List<Account>([SELECT Id, Party_Type__c FROM Account WHERE Id =: recordId AND Party_Type__c = 'Customer']);
        if(!accountList.isEmpty()){
            List<ETT_Inspection_Card__c> inspectionCardList = new List<ETT_Inspection_Card__c>();
            if(!quotationIds.isEmpty()){
                Set<Id> collectionIds = new Set<Id>();
                for(ETT_Quotation_Line_Item__c objQLI : [SELECT Id, Collection_Card__c From ETT_Quotation_Line_Item__c where ETT_Quotation__c IN: quotationIds]){
                    collectionIds.add(objQLI.Collection_Card__c);
                }
                inspectionCardList = [SELECT Id,Tyre_Inventory__c,Tyre_Inventory__r.Unit_Price__c,Tyre_Inventory__r.ETT_Brand__r.Name,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.Job_Type__c,Name,ETT_Account__r.Party_Type__c,ETT_Status__c,ETT_Collection_Card__r.Name,ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Phone__c ,ETT_Collection_Card__r.ETT_Vehicle_Detail__r.name,
                                      (SELECT Id,ETT_Job_Stages__c,ETT_Failed_Stage__c,ETT_Failed_Reason__c from Job_Cards__r where ETT_Job_Stages__c!='Painting') 
                                      From ETT_Inspection_Card__c where ETT_Collection_Card__c IN: collectionIds AND (ETT_Status__c='Send Back' OR ETT_Status__c='Accepted') AND Id not in (SELECT ETT_Inspection_Card__c FROM ETT_Delivery_Line_Item__c)];
            }else{
                inspectionCardList = [SELECT Id,Tyre_Inventory__c,Tyre_Inventory__r.Unit_Price__c,Tyre_Inventory__r.ETT_Brand__r.Name,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.Job_Type__c,Name,ETT_Account__r.Party_Type__c,ETT_Status__c,ETT_Collection_Card__r.Name,ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Phone__c ,ETT_Collection_Card__r.ETT_Vehicle_Detail__r.name,
                                      (SELECT Id,ETT_Job_Stages__c,ETT_Failed_Stage__c,ETT_Failed_Reason__c from Job_Cards__r where ETT_Job_Stages__c!='Painting') 
                                      From ETT_Inspection_Card__c where ETT_Collection_Card__r.ETT_Accounts__c =:recordId AND (ETT_Status__c='Send Back' OR ETT_Status__c='Accepted') AND Id not in (SELECT ETT_Inspection_Card__c FROM ETT_Delivery_Line_Item__c)];
                
            }
            
            Set<Id> tyreInventories = new Set<Id>();
            for(ETT_Inspection_Card__c objIC : inspectionCardList){
                tyreInventories.add(objIC.Tyre_Inventory__c);
            }
            
            
            
            Map<Id,Decimal> inspectionQuotationMap = new Map<Id,Decimal>();
            
            for(ETT_Quotation_Line_Item__c objQLI : [SELECT id, ETT_Unit_Price__c,ETT_Tyre_Inventory__r.ETT_Tyre_Inspection_Card__c FROM ETT_Quotation_Line_Item__c where ETT_Tyre_Inventory__c IN: tyreInventories]){
                if(!inspectionQuotationMap.containsKey(objQLI.ETT_Tyre_Inventory__r.ETT_Tyre_Inspection_Card__c)){
                    inspectionQuotationMap.put(objQLI.ETT_Tyre_Inventory__c,objQLI.ETT_Unit_Price__c);   
                }
            }
            
            
            Map<Id,String> inspectionBuffingMap = new Map<Id,String>();
            List<ETT_Job_Card_Close__c> jobCardCloseList = [SELECT Id, Job_Card__r.ETT_Inspection_Card__c,ThreadPattern__r.Name
                                                            FROM ETT_Job_Card_Close__c 
                                                            WHERE Job_Card__r.ETT_Inspection_Card__c IN :inspectionCardList];
            for (ETT_Job_Card_Close__c objJCLI : jobCardCloseList) {
                if (!inspectionBuffingMap.containsKey(objJCLI.Job_Card__r.ETT_Inspection_Card__c)) {
                    inspectionBuffingMap.put(objJCLI.Job_Card__r.ETT_Inspection_Card__c, objJCLI.ThreadPattern__r.Name);
                }
            }
            
 System.debug('ThredPattern222222222'+ inspectionBuffingMap);            
            /*

for(ETT_Job_Card_Line_Item__c objJCLI : [SELECT id, ETT_Job_Card__r.ETT_Inspection_Card__c, Desired_Tread_Pattern__c FROM ETT_Job_Card_Line_Item__c where ETT_Job_Card__r.ETT_Inspection_Card__c IN: inspectionCardList AND RecordType.Name='Buffing' AND Sequence__c=7 order by ETT_Revision_Number__c DESC]){
if(!inspectionBuffingMap.containsKey(objJCLI.ETT_Job_Card__r.ETT_Inspection_Card__c)){
inspectionBuffingMap.put(objJCLI.ETT_Job_Card__r.ETT_Inspection_Card__c,objJCLI.Desired_Tread_Pattern__c);   
}
}
*/
            
            
            List<InspectionCardWrapper> wrapInspectionCardList = new List<InspectionCardWrapper>();
            
            for(ETT_Inspection_Card__c objIC: inspectionCardList){
                InspectionCardWrapper tyreWrapper = new InspectionCardWrapper(objIC, (inspectionQuotationMap.containsKey(objIC.Tyre_Inventory__c) ? inspectionQuotationMap.get(objIC.Tyre_Inventory__c) : null), (inspectionBuffingMap.containsKey(objIC.Id) ? inspectionBuffingMap.get(objIC.Id) : ''));
                wrapInspectionCardList.add(tyreWrapper);
            }
            system.debug('Full wrapper class'+wrapInspectionCardList);
            return wrapInspectionCardList;
        }
        //Stage to delivery Note from Account Level 2
        
        List<ETT_Inspection_Card__c> iCardList =[select Id,Tyre_Inventory__c,Tyre_Inventory__r.Unit_Price__c,Tyre_Inventory__r.ETT_Brand__r.Name,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.Job_Type__c,Name,ETT_Account__r.Party_Type__c,ETT_Status__c,ETT_Collection_Card__r.Name,ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Phone__c ,ETT_Collection_Card__r.ETT_Vehicle_Detail__r.name,
                                                 (select Id,ETT_Job_Stages__c,ETT_Failed_Stage__c,ETT_Failed_Reason__c from Job_Cards__r where ETT_Job_Stages__c!='Painting') 
                                                 From ETT_Inspection_Card__c where ETT_Collection_Card__r.ETT_Accounts__c =:recordId AND ETT_Status__c='Send Back' AND Id not in (SELECT ETT_Inspection_Card__c FROM ETT_Delivery_Line_Item__c)];
        
        Map<Id,String> inspectionBuffingMap = new Map<Id,String>();
       /* 
        for(ETT_Job_Card_Line_Item__c objJCLI : [SELECT id, Desired_Tread_Pattern__c FROM ETT_Job_Card_Line_Item__c where ETT_Job_Card__r.ETT_Inspection_Card__c IN: iCardList AND RecordType.Name='Buffing' AND Sequence__c=7 order by ETT_Revision_Number__c DESC]){
            if(!inspectionBuffingMap.containsKey(objJCLI.ETT_Job_Card__r.ETT_Inspection_Card__c)){
                inspectionBuffingMap.put(objJCLI.ETT_Job_Card__r.ETT_Inspection_Card__c,objJCLI.Desired_Tread_Pattern__c);   
            }
        }
        */
        //job card close object records
        List<ETT_Job_Card_Close__c> jobCardCloseList = [SELECT Id, Job_Card__r.ETT_Inspection_Card__c,ThreadPattern__r.Name
                                                        FROM ETT_Job_Card_Close__c 
                                                        WHERE Job_Card__r.ETT_Inspection_Card__c IN :iCardList];
        for (ETT_Job_Card_Close__c objJCLI : jobCardCloseList) {
            if (!inspectionBuffingMap.containsKey(objJCLI.Job_Card__r.ETT_Inspection_Card__c)) {
                inspectionBuffingMap.put(objJCLI.Job_Card__r.ETT_Inspection_Card__c, objJCLI.ThreadPattern__r.Name);
            }
        }
       
        List<InspectionCardWrapper> wrapInspectionCardList = new List<InspectionCardWrapper>();
        
        for(ETT_Inspection_Card__c objIC: iCardList){
            InspectionCardWrapper tyreWrapper = new InspectionCardWrapper(objIC, 0.0, (inspectionBuffingMap.containsKey(objIC.Id) ? inspectionBuffingMap.get(objIC.Id) : ''));
            wrapInspectionCardList.add(tyreWrapper);
        }
        System.debug('wrapperList'+ wrapInspectionCardList);
        return wrapInspectionCardList;
    }
    
    @auraEnabled
    public static list<contact> getConRelatedAcc(string recordId){
        
        return [select id,name,mobilePhone,Account.BillingAddress from Contact where AccountId=:recordId];
        
    }
    
    @auraEnabled
    public static string createDeliveryNote(ETT_Delivery_Note__c dn,list<ETT_Delivery_Line_Item__c> dnlines){
        system.debug('dn==== :'+dn);
        Savepoint sp = Database.setSavepoint();
        
        try{
            
            insert dn;
            
            for(ETT_Delivery_Line_Item__c dnl : dnlines){
                dnl.ETT_Delivery_Note__c = dn.Id;
            }
            insert dnlines;
            
        }catch(Exception e) {
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());          
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());   
            
        }
        
        return dn.Id;
    }
    
    // wrapper class 
    public class InspectionCardWrapper {
        @AuraEnabled
        public ETT_Inspection_Card__c objIC {get; set;}
        @AuraEnabled
        public decimal unitPrice {get; set;}
        @AuraEnabled
        public String desiredTreadPattern {get; set;}
        
        //non parameterized wrapper constructor when its write whenever show error msg no-Aurg defined. 
        public InspectionCardWrapper(){}
        
        // parameterized construtor mapping tyreInventoryObj and decimal unit price
        public InspectionCardWrapper(ETT_Inspection_Card__c inspectionCardObj, decimal uPrice, String dTreadPattern) {
            objIC = inspectionCardObj;
            desiredTreadPattern = dTreadPattern;
            if(uPrice != null){
                unitPrice = uPrice;
            }else{
                unitPrice = null;
            }
        }
    }
}