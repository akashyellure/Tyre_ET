public class ETT_DeliveryNoteController {
    
    @AuraEnabled 
    public static user fetchUser(){
      User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                 FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    @AuraEnabled        
    public static List<ETT_Inspection_Card__c> getJobCardIntoList(Id accountId){
        
        Set<Id> collectionCardIdsSet = new Set<Id>();
        Set<Id> inspectionCardIdsSet = new Set<Id>();  
        set<id> collCardIds = new set<id>();
        Id ccId;
        for(ETT_Collection_Card__c col : [select id from ETT_Collection_Card__c where ETT_Accounts__c=:accountId]){
            collCardIds.add(col.id);
        }
         List<ETT_Inspection_Card__c> lstInspectionnCard = [SELECT Id, ETT_Collection_Card__c,ETT_Status__c,(select Id,ETT_Job_Stages__c from Job_Cards__r where (ETT_Job_Stages__c='Painting' and ETT_Painting_End_Time__c!=null) or ETT_Failed_Stage__c!='')
                                                           FROM ETT_Inspection_Card__c where ETT_Collection_Card__c = :collCardIds and 
                                                           Id not in (SELECT ETT_Inspection_Card__c FROM ETT_Delivery_Line_Item__c) and 
                                                           ETT_Collection_Card__r.ETT_Inspection_Done__c=true];
        
        System.debug('lstInspectionnCard: '+lstInspectionnCard);
        
        if(lstInspectionnCard!=null && lstInspectionnCard.size()>0){
            for(ETT_Inspection_Card__c IC:lstInspectionnCard){
                
                if(IC.ETT_Status__c=='Send Back' || (IC.Job_Cards__r.size()>0)) {
                    collectionCardIdsSet.add(IC.ETT_Collection_Card__c);
                    inspectionCardIdsSet.add(IC.Id);
                }
            }
        }
        System.debug('collectionCardIdsSet: '+collectionCardIdsSet);

        List<ETT_Delivery_Line_Item__c> lstDeliveryLineItems = [SELECT Id, ETT_Collection_Card__c, ETT_Collection_Card__r.ETT_Service_Appointment__c, ETT_Collection_Card__r.ETT_Phone__c ,ETT_Collection_Card__r.ETT_Vehicle_Detail__r.name FROM ETT_Delivery_Line_Item__c where ETT_Collection_Card__c in :collectionCardIdsSet];
         
        if(collectionCardIdsSet.isEmpty()){
            throw new AuraHandledException('There is no Delivery Note Pending for this account');            
        }
        /*
        if(lstDeliveryLineItems!=null && lstDeliveryLineItems.size() > 0){
            throw new AuraHandledException('There is no Delivery Note Pending for this account');
        }
        */
        return [select Id,Name,Brand__c,ETT_Account__r.Party_Type__c,ETT_Tyre_Size__c,ETT_Tyre_Size__r.Name,ETT_Brand__c,ETT_Brand__r.Name,ETT_Pattern__c,
                ETT_Pattern__r.Name,ETT_Tyre_Serial_Number__c,ETT_Status__c,ETT_Collection_Card__r.Name,ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Phone__c ,ETT_Collection_Card__r.ETT_Vehicle_Detail__r.name,ETT_Collection_Card__r.ETT_Service_Appointment__c,
                (select Id,ETT_Job_Stages__c,ETT_Failed_Stage__c,ETT_Failed_Reason__c from Job_Cards__r where ETT_Job_Stages__c!='Painting') 
                From ETT_Inspection_Card__c where Id in :inspectionCardIdsSet];
        
    }
    
    
    
    @AuraEnabled        
    public static List<ETT_Inspection_Card__c> getJobCardIntoListForPrint(Id accountId){
        return [select Id,ETT_Tyre_Size__c,ETT_Tyre_Size__r.Name,ETT_Brand__c,ETT_Brand__r.Name,ETT_Pattern__c,
                ETT_Pattern__r.Name,ETT_Tyre_Serial_Number__c,ETT_Status__c,ETT_Collection_Card__r.Name,ETT_Collection_Card__r.ETT_Service_Appointment__c,
                (select Id,ETT_Job_Stages__c,ETT_Failed_Stage__c,ETT_Failed_Reason__c from Job_Cards__r where ETT_Job_Stages__c!='Painting') 
                From ETT_Inspection_Card__c where ETT_Account__c = :accountId and ETT_Status__c='Send Back'];
    }
    
    @AuraEnabled  
    public static String submitDeliveryNote(map<string,string> mapOfObjects){
        system.debug('*****mapOfObjects*******'+mapOfObjects);
        
        ETT_Delivery_Note__c objDeliveryNote;
        list<ETT_Delivery_Line_Item__c> lstDeliveryLineItem; 
        
        if(mapOfObjects.containskey('deliveryNoteJson')){
            objDeliveryNote = (ETT_Delivery_Note__c) JSON.deserialize(mapOfObjects.get('deliveryNoteJson'),Type.forname('ETT_Delivery_Note__c'));
        }
        if(mapOfObjects.containskey('deliveryLineItemJson')){
            lstDeliveryLineItem =  (list<ETT_Delivery_Line_Item__c>)JSON.deserialize(mapOfObjects.get('deliveryLineItemJson'),Type.forname('list<ETT_Delivery_Line_Item__c>'));
        }
        
        if(objDeliveryNote!=null){
            
            try{
                Id customerRecordTypeId = Schema.SObjectType.ETT_Delivery_Note__c .getRecordTypeInfosByName().get('Tyre - Customer').getRecordTypeId();
                Id supplierRecordTypeId = Schema.SObjectType.ETT_Delivery_Note__c .getRecordTypeInfosByName().get('Tyre - Supplier').getRecordTypeId();
                System.debug('objDeliveryNote: '+objDeliveryNote);
                if(objDeliveryNote.ETT_Casing__c == 'Supplier Casing'){
                    objDeliveryNote.RecordTypeId = supplierRecordTypeId;
                }
                else  if(objDeliveryNote.ETT_Casing__c == 'Customer Casing')
                {
                    objDeliveryNote.RecordTypeId = customerRecordTypeId;                    
                }
                insert objDeliveryNote;
                System.debug('objDeliveryNote.Id: '+objDeliveryNote.Id);
            }Catch(Exception ex){
                system.debug('******Exception Cause *****'+ex.getMessage());
                throw new AuraHandledException(ex.getMessage());
            }
            
            if(objDeliveryNote.Id!=null){
                
                list<Sobject> lstSobjectInformation = new list<Sobject>();
                list<Sobject> lstUpdateSobjectInformation = new list<Sobject>();
                
                if(lstDeliveryLineItem!=null && lstDeliveryLineItem.size()>0){
                    for(ETT_Delivery_Line_Item__c objDeliveryLineItem :lstDeliveryLineItem){
                   
                        if(objDeliveryLineItem.ETT_Delivery_Note__c==null){
                            objDeliveryLineItem.ETT_Delivery_Note__c = objDeliveryNote.Id;
                        }
                        
                        if(objDeliveryLineItem.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objDeliveryLineItem);
                        }else{
                            lstSobjectInformation.add((Sobject)objDeliveryLineItem);
                        }
                        
                    }     
                 }
                
                if(lstSobjectInformation!=null && lstSobjectInformation.size()>0){
                    try{
                        System.debug(lstSobjectInformation);
                        insert lstSobjectInformation;
                        return objDeliveryNote.Id;
                    }Catch(Exception ex){
                        system.debug('***Exception Cause *****'+ex.getMessage());
                        throw new AuraHandledException(ex.getMessage());
                    }
                }
                
                if(lstUpdateSobjectInformation!=null && lstUpdateSobjectInformation.size()>0){
                    try{
                        update lstUpdateSobjectInformation;
                        return objDeliveryNote.Id;
                    }Catch(Exception ex){
                        system.debug('***Exception Cause *****'+ex.getMessage());
                        throw new AuraHandledException(ex.getMessage());
                    }
                }else if(objDeliveryNote!=null && objDeliveryNote.Id!=null){
                    return objDeliveryNote.Id;
                }
                
                
            }
            
        }
        return '';
    }
    
    @AuraEnabled 
    public static String getPhoneFromAccount(id accountId){
      Account acc = [Select id,Phone from Account where id =:accountId];
       String phonenumber = '';
        if(acc.Phone!=null)
        {
           phonenumber = String.valueOf(acc.Phone); 
        }
         
        
        return phonenumber;
    }
    
}