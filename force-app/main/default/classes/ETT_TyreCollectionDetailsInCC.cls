/**
* Author:Janardhan
* CreatedDate:24/11/2021
* TestClass: ETT_TyreCollectionDetailsInCCTest
* Desc: Removed approval process concept,bcz unable to remove approve/reject btns from approval histroy
* */
public without sharing class ETT_TyreCollectionDetailsInCC {
    
    @AuraEnabled
    public static boolean getMoveOrderDetails(string recordId){
        //system.debug('this is a recordID: ' +recordId);
        List<ETT_Collection_Card__c> ccList = new List<ETT_Collection_Card__c>([SELECT Id, MO_EBS_Ref_No__c, (SELECT Id, Item_Code__c FROM Tyre_Inventory__r) FROM ETT_Collection_Card__c 
                                                                                WHERE Id =: recordId AND RecordTypeId =: Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId()]);
        if(!ccList.isEmpty() && ccList[0].MO_EBS_Ref_No__c != null){
            Map<String, Integer> tyreQuantity = new Map<String, Integer>();
            for(ETT_Tyre_Inventory__c objTI : ccList[0].Tyre_Inventory__r){
                if(!tyreQuantity.containsKey(objTI.Item_Code__c)){
                    tyreQuantity.put(objTI.Item_Code__c,0);
                }
                tyreQuantity.put(objTI.Item_Code__c,tyreQuantity.get(objTI.Item_Code__c)+1);
            }
            System.debug('tyreQuantity '+tyreQuantity);
            HttpRequest req = new HttpRequest();
            // Query the custom metadata type to get the endpoint details
            ET_SOA_Endpoint__mdt md = [SELECT DeveloperName, LiveEndpoint__c, TestEndpoint__c FROM ET_SOA_Endpoint__mdt WHERE DeveloperName = 'Get_Move_Order_Details'];
            // Determine if you are in the sandbox environment
            Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            // Set the endpoint based on the environment
            String endpoint;
            if (isSandbox) {
                endpoint = md.TestEndpoint__c;
            } else {
                endpoint = md.LiveEndpoint__c;
            }
            // Append the request number to the endpoint
            endpoint += '?request_number=' + ccList[0].MO_EBS_Ref_No__c;

          //  String endpoint = 'https://etdevsoa.et.ae/soa-infra/resources/EBS_Tyre_Integration/MoveOrder/MoveOrderDetailsRestService?request_number='+ccList[0].MO_EBS_Ref_No__c;
        
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Basic U2FsZXNGb3JjZTpzYWxlc2ZvcmNlMTIz');
           
            // Create a new http object to send the request object
            // A response object is generated as a result of the request
            Http http = new Http();
            HTTPResponse res;
            if(!Test.isRunningTest()){
                res = http.send(req);
            }else{
                res = new HTTPResponse();
                res.setStatusCode(200);
                String body = '{"Status" : "S",'+
  								'"Message" : "Move Order Found",'+
                                  '"GetMoveOrderResponse" : {'+
                                    '"GetMoveOrderResponseDetail" : [ {'+
                                      '"requestNumber" : "5763526",'+
                                      '"moveOrderDescription" : null,'+
                                      '"organizationId" : 345,'+
                                      '"moveOrderTypeName" : "Manufacturing Pick",'+
                                      '"fromSubinventoryCode" : null,'+
                                      '"transactionTypeName" : "Move Order Transfer",'+
                                      '"item" : "test123",'+
                                      '"itemDescription" : "BATTERY-70AH SOLITE KOREA PN: CMF-85D26R",'+
                                      '"toSubinventoryCode" : null,'+
                                      '"quantity" : 1,'+
                                      '"quantityDelivered" : 1,'+
                                      '"moveOrderStatus" : "Pre Approved",'+
                                      '"createdBy" : 12741,'+
                                      '"creationDate" : "2022-08-20T07:07:35.000+04:00"'+
                                    '} ]}}';
                res.setBody(body);
            }
            //System.debug(res.getBody());
            if(res.getStatusCode() == 200){
                Map<String, Integer> MOQuantityMap = new Map<String, Integer>();
                MoveOrderDetailsResponseWrapper response = new MoveOrderDetailsResponseWrapper();
                response = MoveOrderDetailsResponseWrapper.parse(res.getBody());
                if(response.GetMoveOrderResponse != null){
                    for(MoveOrderDetailsResponseWrapper.cls_GetMoveOrderResponseDetail MODetail : response.GetMoveOrderResponse.GetMoveOrderResponseDetail){
                        if(MODetail.item != null && !MOQuantityMap.containsKey(MODetail.item)){
                            MOQuantityMap.put(MODetail.item,MODetail.quantityDelivered);
                        }
                        //MOQuantityMap.put(MODetail.item,MOQuantityMap.get(MODetail.item)+1);
                    }
                    System.debug('MOQuantityMap '+MOQuantityMap);
                    boolean isMOConfirmed = true;
                    for(String itemCode : tyreQuantity.keySet()){
                        if(!MOQuantityMap.containsKey(itemCode) || (MOQuantityMap.containsKey(itemCode) && MOQuantityMap.get(itemCode) != tyreQuantity.get(itemCode))){
                            isMOConfirmed = false;
                        }
                    }
                    System.debug('isMOConfirmed '+isMOConfirmed);
                    return isMOConfirmed;
                }
            }else{
                return false;
            }
        }else{
            return true;
        }
        return true;
    }
    @AuraEnabled
    public static list<ETT_Tyre_Inventory__c> getTyreInventoryDetials(string recordId){
        
        return [select Id,ETT_Tyre_Size_Master__c,ETT_Tyre_Size_Master__r.Name,Temp_Size_Name__c,ETT_Brand__c,ETT_Brand__r.Name,Temp_Brand_Name__c,ETT_Pattern__c,ETT_Pattern__r.Name,Temp_Pattern_Name__c,ETT_Country__c,
                ETT_Country__r.Name,Temp_Country_Name__c, ETT_Tyre_Life__c,Serial_Number__c,Job_Type__c,Claim_Process__c,Process_Type__c,Remarks__c, ETT_Inventory_Status__c from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:recordId];
    }
    @AuraEnabled
    public static list<ETT_StagingNewTyreCollection__c> getStagTyreDetials(string recordId){
        return [select Id,Size_Name__c,Brand_Name__c,Pattern_Name__c,Country_Name__c,Tyre_Serial_No__c,Job_Type__c,Process_Type__c from ETT_StagingNewTyreCollection__c where Collection_Card__c=:recordId];
    }
    
    @AuraEnabled
    public static user getUserInfo(){
        return [Select id,Name,profile.Name from user where Id=:userinfo.getUserId()];
    }
    
    @AuraEnabled
    public static list<ETT_Tyre_Master__c> getTyreMasterDetails(string recordId){
        return [select id,ETT_Status__c,Name,ETT_Tyre_Size__r.Name,ETT_Brand_Name__r.Name,ETT_Original_Pattern__r.Name,ETT_Country_Name__r.Name from ETT_Tyre_Master__c where recordType.Name='Draft' AND ETT_Collection_Card__c=:recordId];
    }   
    
    @AuraEnabled
    public static list<ETT_Pricing_Information__c> getPricingConfirmDetails(string recordId){
        //Id accId = [select id,ETT_Accounts__c from ETT_Collection_Card__c where id=:recordId].ETT_Accounts__c;
        //Id priceMasterId = [select id from ETT_Price_Master__c where ETT_Party_Name__c=:accId].Id;
        
        return [select id,ETT_Tyre_Size__r.Name,ETT_Brand__r.Name,ETT_Country_of_Origin__r.Name,ETT_Pattern__r.Name,ETT_Minimum_Price__c,ETT_Maximum_Price__c,ETT_Purchase_Price__c,ETT_Repair_Price__c,ETT_Selling_Price_P__c,ETT_Selling_Price_H__c,ETT_Retread_Price_P__c,ETT_Retread_Price_H__c from ETT_Pricing_Information__c where (ETT_Approval_Status__c='New' OR ETT_Approval_Status__c='In Progress') AND Collection_Card__c=:recordId];
         
    }
    
    
    @AuraEnabled
    public static void updateTyreMasterDetails(list<ETT_Tyre_Master__c> tyreList,string recordId){
        system.debug('this is a recordID: ' +recordId);
        Savepoint sp = Database.setSavepoint();
        list<ETT_Pricing_Information__c> newPriceConList = new list<ETT_Pricing_Information__c>(); 
        ETT_Collection_Card__c CollRec = [select id,ETT_Accounts__c,RecordType.Name from ETT_Collection_Card__c where id=:recordId];
        Id priceMasterId = [select id,RecordType.Name from ETT_Price_Master__c where ETT_Party_Name__c=:CollRec.ETT_Accounts__c].Id;
        set<id> brandIds = new set<id>();
        set<id> sizeIds = new set<id>();
        set<id> patternIds = new set<id>();
        set<id> countryIds = new set<id>();
        list<ETT_Brand_Master__c> brandMasterUpdate = new list<ETT_Brand_Master__c>();
        list<ETT_Tyre_Size_Master__c> tyreMasterUpdate = new list<ETT_Tyre_Size_Master__c>();
        list<ETT_Pattern_Master__c> patterMasterUpdate = new  list<ETT_Pattern_Master__c>();
        list<ETT_Country_Master__c> countryMasterUpdate = new  list<ETT_Country_Master__c>();
        
        for(ETT_Tyre_Master__c tm : tyreList){
            
            tm.recordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Approved').getRecordTypeId();
            ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();	
            epi.ETT_Price__c = priceMasterId;
            epi.ETT_Approval_Status__c ='New';
            if(CollRec.RecordType.Name =='Supplier'){
                epi.RecordTypeId =   Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                
            }else{
                epi.RecordTypeId =   Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                
            }
            epi.ETT_Brand__c = tm.ETT_Brand_Name__c;
            epi.ETT_Pattern__c = tm.ETT_Original_Pattern__c;
            epi.ETT_Country_of_Origin__c = tm.ETT_Country_Name__c;
            epi.ETT_Tyre_Size__c = tm.ETT_Tyre_Size__c;
            epi.ETT_Purchase_Price__c = 0;
            epi.Collection_Card__c=recordId;
            newPriceConList.add(epi);
            brandIds.add(tm.ETT_Brand_Name__c);
            sizeIds.add(tm.ETT_Tyre_Size__c);
            patternIds.add(tm.ETT_Original_Pattern__c);
            countryIds.add(tm.ETT_Country_Name__c);
        }
        for(string str : brandIds){
            
            ETT_Brand_Master__c br = new ETT_Brand_Master__c();
            br.Id = str;
            br.ETT_Status__c = true;
            brandMasterUpdate.add(br);
        }
         for(string str : sizeIds){
            
            ETT_Tyre_Size_Master__c tr = new ETT_Tyre_Size_Master__c();
            tr.Id = str;
            tr.ETT_Status__c = true;
            tyreMasterUpdate.add(tr);
        }
         for(string str : patternIds){
            
            ETT_Pattern_Master__c tr = new ETT_Pattern_Master__c();
            tr.Id = str;
            tr.ETT_Status__c = true;
            patterMasterUpdate.add(tr);
        }
        for(string str : countryIds){
            
            ETT_Country_Master__c tr = new ETT_Country_Master__c();
            tr.Id = str;
            tr.ETT_Status__c = true;
            countryMasterUpdate.add(tr);
        }
        
        try{
           
            update tyreList;
            insert newPriceConList;
            update countryMasterUpdate;
            update patterMasterUpdate;
            update tyreMasterUpdate;
            update brandMasterUpdate;
            //After Hoo approval we are sending to Sales Person
            ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
            cc.Id = recordId;
            cc.Approval_Status__c='Pending with Sales Person';
            update cc;
            
        }catch(Exception e) {
            Database.rollback(sp);
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
            system.debug('---Type-'+e.getMessage());
            throw new AuraHandledException(e.getMessage());   
            
        }
        
    }
    @AuraEnabled
    public static void updatePricingConfirmDetails(list<ETT_Pricing_Information__c> priceList,string recordId){
        
        User objUser = [SELECT Id,Name,Username,Profile.Name FROM User where Id = :UserInfo.getUserId()]; 
        Id AccId  = [select id,ETT_Accounts__c from ETT_Collection_Card__c where id=:recordId].ETT_Accounts__c; 
        
        list<ETT_Tyre_Inventory__c> newTyreInvList = new list<ETT_Tyre_Inventory__c>();
        
        string remarks ='';
        Savepoint sp = Database.setSavepoint();
        try{
            for(ETT_Pricing_Information__c pr: priceList){
                
                if(objUser.Profile.Name=='ETT_Head of Operations' || objUser.Profile.Name == 'System Administrator'){ 
                    pr.ETT_Buying_Price_Comments__c ='Updated by HOO';
                }else if(objUser.Profile.Name=='ETT_Sales Team' ){
                    pr.ETT_Buying_Price_Comments__c ='Updated by Sales Person';
                }else {
                    pr.ETT_Buying_Price_Comments__c ='Updated by FM';
                }
                         
            }
            update priceList;
            
             ETT_Collection_Card__c cc2 = new ETT_Collection_Card__c();
             cc2.Id = recordId;
            
            if(objUser.Profile.Name=='ETT_Head of Operations' || objUser.Profile.Name == 'System Administrator'){
                
               
                cc2.Approval_Status__c='Pending with FM';
                
               
              /*  //approval process
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approved by HOO');
                req.setAction('Approve');
                Id workItemId  = getWorkItemId(recordId); //CollecCard Id
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);*/
                
            }else if(objUser.Profile.Name=='ETT_Sales Team'){
              
                cc2.Approval_Status__c='Pending with HOO';                
                               
            }
             update cc2;
            if(objUser.Profile.Name=='ETT_Factory Manager'  || objUser.Profile.Name == 'System Administrator'){
                
             
                for(ETT_StagingNewTyreCollection__c stg : [select id,Job_Type__c,Process_Type__c,Tyre_Serial_No__c,Tyre_Life__c,Brand__c,Pattern__c,Tyre_Size__c,Country__c,Collection_Card__c from ETT_StagingNewTyreCollection__c where Collection_Card__c=:recordId]){
                    
                    ETT_Tyre_Inventory__c tyre = new ETT_Tyre_Inventory__c();
                    tyre.ETT_Collection_Card__c = stg.Collection_Card__c;
                    tyre.ETT_Account__c = AccId;
                    tyre.ETT_Brand__c = stg.Brand__c;
                    tyre.ETT_Country__c = stg.Country__c;
                    tyre.ETT_Tyre_Size_Master__c = stg.Tyre_Size__c;
                    tyre.ETT_Pattern__c = stg.Pattern__c;
                    tyre.ETT_Inventory_Status__c ='Approved by Receptionist';
                    tyre.Process_Type__c = stg.Process_Type__c;
                    tyre.ETT_Tyre_Life__c = stg.Tyre_Life__c;
                    tyre.Serial_Number__c = stg.Tyre_Serial_No__c;
                    tyre.Job_Type__c = stg.Job_Type__c;
                    tyre.Stockable__c = true;
                    tyre.Tyre_Type__c = 'Used';
                    
                    newTyreInvList.add(tyre);
                }
                
                insert newTyreInvList;
                
                list<ETT_Tyre_Inventory__c> updateTyreInv = new list<ETT_Tyre_Inventory__c>();
                for(ETT_Tyre_Inventory__c ty : [select Id,Name,ETT_Inventory_Status__c from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:recordId AND ETT_Inventory_Status__c='Draft' ]){
                    
                    ty.ETT_Inventory_Status__c ='Approved by Receptionist';
                    updateTyreInv.add(ty);
                }
                update updateTyreInv;
                
                ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                cc.Id = recordId;
                cc.Approval_Status__c='Approved';
                cc.ETT_Collection_Status__c ='Accepted';
                
                update cc;
                
                //approval process
               /* Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approved by FM');
                req.setAction('Approve');
                Id workItemId  = getWorkItemId(recordId); //CollecCard Id
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);*/
            }
            
          
            
        }catch(Exception e) {
            System.debug('Exception ---> '+e.getStackTraceString());
            Database.rollback(sp);
            //throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static Map<String, String> getselectOptions(string fld) {
        
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        
        Schema.sObjectType objType = ETT_Tyre_Inventory__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
            options.put(a.getValue(), a.getLabel());
        }
        
        allOpts.sort();
        System.debug(options);
        return options;
    }
    @AuraEnabled
    public static void updateCollectionCard(string recordId,String fieldName){
        
        ETT_Collection_Card__c cc = [SELECT Id, RecordTypeId, Approval_Status__c, ETT_Collection_Status__c FROM ETT_Collection_Card__c WHERE Id = :recordId LIMIT 1];
        User objUser = [SELECT Id, Name, Username, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        
        String recordTypeDevName = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosById().get(cc.RecordTypeId).getDeveloperName();
        
        if (fieldName.equals('ETT_Check_In__c')) {
            cc.ETT_Check_In__c = System.now();
        } else if (fieldName.equals('ETT_Check_Out__c')) {
            cc.ETT_Check_Out__c = System.now();
            
            if (recordTypeDevName.equals('ETT_Tyre_Internal')) {
                if (objUser.Profile.Name.equals('ETT_Collection Team(Platform)') || objUser.Profile.Name.equals('ETT_Collection Team')) {
                    cc.Approval_Status__c = 'Pending with Storekeeper';
                } else if (objUser.Profile.Name.equals('ETT_Storekeeper')) {
                    cc.Approval_Status__c = 'Pending with Reception';
                    cc.ETT_Collection_Status__c = 'Accepted';
                }
            } else {
                cc.Approval_Status__c = 'Pending with Reception';
                cc.ETT_Collection_Status__c = 'Accepted';
            }
        }
        
        try { 
              system.debug('cc=='+cc);
              update cc;
              
               /* Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Collection Team request');
                req1.setObjectId(recordId);
                req1.setSubmitterId(userinfo.getuserid());
                
                Approval.ProcessResult result = Approval.process(req1);*/
         
            
        }catch(Exception e) {
            System.debug('Exception ---> '+e.getStackTraceString());
            //throw new AuraHandledException(e.getMessage());    
        }
    }

  /*  @AuraEnabled
    public static void insertNewStagNewTyreInven(list<ETT_Tyre_Inventory__c> newTyreInvent,List<ETT_StagingNewTyreCollection__c> stagTyre,List<ETT_StagingNewTyreCollection__c> updateStagTyre,list<ETT_Tyre_Inventory__c> updateTyreInventory,Id recordId){
        //ETT_StagingNewTyreCollection__c will have all the tyres not we have in tyremaster
        ETT_Collection_Card__c cc  = [select id,Name,ETT_Accounts__c,ETT_Accounts__r.Party_Type__c,ETT_Opportunity__c,RecordTypeId from ETT_Collection_Card__c where id=:recordId ]; 
        
        list<ETT_Price_Master__c> priceMas = [select id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c=:cc.ETT_Accounts__c];
         
      
        
        Savepoint sp = Database.setSavepoint();
        
        try{
            if(priceMas.size() == 0){
                
                ETT_Price_Master__c ep = new ETT_Price_Master__c();
                ep.Opportunity__c = cc.ETT_Opportunity__c;
                ep.ETT_Party_Name__c = cc.ETT_Accounts__c;
                // ep.RecordTypeId = Schema.SObjectType.ETT_Price_Master__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                ep.ETT_Price_Information_External_Id__c =  cc.ETT_Accounts__c+cc.ETT_Accounts__r.Party_Type__c;
                ep.ETT_Party_Type__c = cc.ETT_Accounts__r.Party_Type__c;
                insert ep;
            }
            
            if(updateStagTyre.size()>0 && updateStagTyre != null){
                
                update updateStagTyre;
            } 
            if(updateTyreInventory.size()>0 && updateTyreInventory != null){
                
                update updateTyreInventory;
            } 
            
            if(newTyreInvent.size()>0 && newTyreInvent != null){
                Set<String> brands = new Set<String>();
                Set<String> serialNos = new Set<String>();
                Set<String> tyreLife = new Set<String>();
                Map<String,ETT_Tyre_Inventory__c> inventoryMap = new Map<String,ETT_Tyre_Inventory__c>();
                for(ETT_Tyre_Inventory__c tin : newTyreInvent){
                    if(cc.ETT_Accounts__c != null)
                        tin.ETT_Account__c = cc.ETT_Accounts__c;
                    if(tin.ETT_Brand__c != null){
                        brands.add(tin.ETT_Brand__c);
                    }
                    if(tin.Serial_Number__c != null){
                        serialNos.add(tin.Serial_Number__c);
                    }
                    if(tin.ETT_Tyre_Life__c != null){
                        tyreLife.add(tin.ETT_Tyre_Life__c);
                    }
                }
                List<ETT_Tyre_Inventory__c> tyreInventoryList=[SELECT ETT_Brand__c,Serial_Number__c,ETT_Tyre_Life__c FROM ETT_Tyre_Inventory__c WHERE ETT_Brand__c IN:brands 
                                 OR Serial_Number__c IN:serialNos OR ETT_Tyre_Life__c IN:tyreLife];
                for(ETT_Tyre_Inventory__c objTyreInventory : tyreInventoryList){
					inventoryMap.put(objTyreInventory.ETT_Brand__c+'#'+objTyreInventory.Serial_Number__c+'#'+objTyreInventory.ETT_Tyre_Life__c, objTyreInventory);                    
                }
                System.debug('inventoryMap --> '+inventoryMap);
                Boolean isDuplicate = false;
                for(ETT_Tyre_Inventory__c tin : newTyreInvent){
                    if(inventoryMap.containsKey(tin.ETT_Brand__c+'#'+tin.Serial_Number__c+'#'+tin.ETT_Tyre_Life__c)){
                      	isDuplicate = true;
                    }
                }
                
                if(isDuplicate){
                    AuraHandledException auraEx = new AuraHandledException('Tyre Serial Number with Tyre Life should be unique for every record');
                    auraEx.setMessage('Tyre Serial Number with Tyre Life should be unique for every record');
                    throw auraEx;
                    //throw new AuraHandledException(''); 
                }else{
                    insert newTyreInvent;
                }
                
            }
            System.debug('after return');
            if(stagTyre.size()>0 && stagTyre != null){
                
                cc.Has_New_Tyres__c = True;
                insert stagTyre;
                update cc;
            }
            
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            if(cc.RecordTypeId == Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId()){
                String[] toAddresses = new String[]{'store.bijoy@et.com.preprod2'};
                List<User> userList = [SELECT Email FROM User WHERE Profile.Name = 'ETT_Head of Operations'];
                for(User u : userList) {
                    toAddresses.add(u.email);
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);
                mail.setUseSignature(false);
                mail.setSaveAsActivity(false);
                mail.setSenderDisplayName('ET');
                mail.setTargetObjectId(userList[0].Id);
                //mail.setTemplateId(et.Id);
                //mail.setHTMLBody(et.body);
                mail.setSubject('Confirm Move Order');
                mail.setPlainTextBody('Hi Team, \n\n Please confirm Move Order for Collection Card - '+cc.Name);
                mail.setWhatId(recordId);
                messages.add(mail);
            }
            
            if(!messages.isEmpty()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
        }catch(Exception e) {
            Database.rollback(sp);
            system.debug('---Type-'+e.getMessage());
            throw new AuraHandledException(e.getMessage());   
            
        }
        
    }
    */
       @AuraEnabled
    public static void insertNewStagNewTyreInven(
        List<ETT_Tyre_Inventory__c> newTyreInvent,
        List<ETT_StagingNewTyreCollection__c> stagTyre,
        List<ETT_StagingNewTyreCollection__c> updateStagTyre,
        List<ETT_Tyre_Inventory__c> updateTyreInventory,
        Id recordId) 
    {
        ETT_Collection_Card__c cc = [
            SELECT Id, Name, ETT_Accounts__c,ETT_Store_Name__c, ETT_Accounts__r.Party_Type__c, ETT_Opportunity__c, RecordTypeId 
            FROM ETT_Collection_Card__c 
            WHERE Id = :recordId
        ];
        Id tyreInternalRecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId();
        Id tyreInternalPrivateRecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal Private').getRecordTypeId();
        // Debug the retrieved RecordTypeIds
        System.debug('Tyre - Internal RecordTypeId: ' + tyreInternalRecordTypeId);
        System.debug('Tyre - Internal Private RecordTypeId: ' + tyreInternalPrivateRecordTypeId);

       // Skip price master creation if Record Type is 'Tyre - Internal' or 'Tyre - Internal Private'
        if (cc.RecordTypeId != tyreInternalRecordTypeId && cc.RecordTypeId != tyreInternalPrivateRecordTypeId) {
            List<ETT_Price_Master__c> priceMas = [
                SELECT Id, ETT_Party_Name__c 
                FROM ETT_Price_Master__c 
                WHERE ETT_Party_Name__c = :cc.ETT_Accounts__c
            ];
         System.debug('Price Master records found: ' + priceMas.size());
            if (priceMas.isEmpty()) {
                ETT_Price_Master__c ep = new ETT_Price_Master__c();
                ep.Opportunity__c = cc.ETT_Opportunity__c;
                ep.ETT_Party_Name__c = cc.ETT_Accounts__c;
                ep.ETT_Price_Information_External_Id__c = cc.ETT_Accounts__c + cc.ETT_Accounts__r.Party_Type__c;
                ep.ETT_Party_Type__c = cc.ETT_Accounts__r.Party_Type__c;
                insert ep;
                  System.debug('Inserting new Price Master record: ' + ep);
            }else{
                 System.debug('Price Master record already exists, no need to create a new one');
            }
            
        }

        Savepoint sp = Database.setSavepoint();

        try {
            if (updateStagTyre != null && !updateStagTyre.isEmpty()) {
                update updateStagTyre;
            }

            if (updateTyreInventory != null && !updateTyreInventory.isEmpty()) {
                update updateTyreInventory;
            }

            if (newTyreInvent != null && !newTyreInvent.isEmpty()) {
                Set<String> brands = new Set<String>();
                Set<String> serialNos = new Set<String>();
                Set<String> tyreLife = new Set<String>();
                Map<String, ETT_Tyre_Inventory__c> inventoryMap = new Map<String, ETT_Tyre_Inventory__c>();

                for (ETT_Tyre_Inventory__c tin : newTyreInvent) {
                    if (cc.ETT_Accounts__c != null) {
                        tin.ETT_Account__c = cc.ETT_Accounts__c;
                    }
                    if(cc.ETT_Store_Name__c!=null){
                        tin.SubInventory__c=cc.ETT_Store_Name__c;
                    }
                    if (tin.ETT_Brand__c != null) {
                        brands.add(tin.ETT_Brand__c);
                    }
                    if (tin.Serial_Number__c != null) {
                        serialNos.add(tin.Serial_Number__c);
                    }
                    if (tin.ETT_Tyre_Life__c != null) {
                        tyreLife.add(tin.ETT_Tyre_Life__c);
                    }
                }
                cc.No_of_Tyre__c = newTyreInvent.size();

                List<ETT_Tyre_Inventory__c> tyreInventoryList = [
                    SELECT ETT_Brand__c, Serial_Number__c, ETT_Tyre_Life__c 
                    FROM ETT_Tyre_Inventory__c 
                    WHERE ETT_Brand__c IN :brands 
                       OR Serial_Number__c IN :serialNos 
                       OR ETT_Tyre_Life__c IN :tyreLife
                ];

                for (ETT_Tyre_Inventory__c objTyreInventory : tyreInventoryList) {
                    inventoryMap.put(
                        objTyreInventory.ETT_Brand__c + '#' + objTyreInventory.Serial_Number__c + '#' + objTyreInventory.ETT_Tyre_Life__c,
                        objTyreInventory
                    );
                }

                Boolean isDuplicate = false;

                for (ETT_Tyre_Inventory__c tin : newTyreInvent) {
                    if (inventoryMap.containsKey(tin.ETT_Brand__c + '#' + tin.Serial_Number__c + '#' + tin.ETT_Tyre_Life__c)) {
                        isDuplicate = true;
                        break;
                    }
                }

                if (isDuplicate) {
                    AuraHandledException auraEx = new AuraHandledException('Tyre Serial Number with Tyre Life should be unique for every record');
                    auraEx.setMessage('Tyre Serial Number with Tyre Life should be unique for every record');
                    throw auraEx;
                } else {
                    insert newTyreInvent;
                }
            }

            if (stagTyre != null && !stagTyre.isEmpty()) {
                cc.Has_New_Tyres__c = true;
                insert stagTyre;
                update cc;
            }

            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            if (cc.RecordTypeId == Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId()) {
                String[] toAddresses = new String[] { 'store.bijoy@et.com.preprod2' };
                List<User> userList = [SELECT Email FROM User WHERE Profile.Name = 'ETT_Head of Operations'];
                for (User u : userList) {
                    toAddresses.add(u.Email);
                }

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);
                mail.setUseSignature(false);
                mail.setSaveAsActivity(false);
                mail.setSenderDisplayName('ET');
                mail.setTargetObjectId(userList[0].Id);
                mail.setSubject('Confirm Move Order');
                mail.setPlainTextBody('Hi Team, \n\n Please confirm Move Order for Collection Card - ' + cc.Name);
                mail.setWhatId(recordId);
                messages.add(mail);
            }

            if (!messages.isEmpty()) {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
        } catch (Exception e) {
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void deleteRecord(string recordId){
        Database.delete(recordId);
    }
    
    
    @AuraEnabled
    public static void approvalProcess (string recordId){ //ByClicking Approve by Recp
        
        User objUser = [SELECT Id,Name,Username,Profile.Name FROM User where Id = :UserInfo.getUserId()];
        //boolean hasTyreWOPrice = [Select id,HasTyresWithoutPrice__c from ETT_Collection_Card__c where id=:recordId].HasTyresWithoutPrice__c;
        ETT_Collection_Card__c ccRec = [select id,HasTyresWithoutPrice__c,RecordType.Name from ETT_Collection_Card__c where id=:recordId];
        list<ETT_StagingNewTyreCollection__c> newTyreColl = [select id from ETT_StagingNewTyreCollection__c where Collection_Card__c=:recordId];
            
        if(objUser.Profile.Name == 'ETT_Receptionist' || objUser.Profile.Name == 'System Administrator'){
            
            ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
            cc.Id = recordId;
            
            if(ccRec.HasTyresWithoutPrice__c ==  false){
                //Get all draft tyre details
               cc.Approval_Status__c = 'Approved';
               cc.ETT_Collection_Status__c='Inspection Cards Created';
                
                list<ETT_Tyre_Inventory__c> updateTyreInv = new list<ETT_Tyre_Inventory__c>();
                for(ETT_Tyre_Inventory__c ty : [select Id,Name,ETT_Inventory_Status__c from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:recordId AND ETT_Inventory_Status__c='Draft' ]){
                    
                    ty.ETT_Inventory_Status__c ='Approved by Receptionist';
                    updateTyreInv.add(ty);
                }
                
                update updateTyreInv;
            }else{
                if(ccRec.RecordType.Name == 'Tyre - Refurbishing Services' && newTyreColl.size()<1){
                    cc.Approval_Status__c = 'Pending with Sales Person';
               }else{
                    cc.Approval_Status__c = 'Pending with HOO';
               }
               
            }
           
            try{
           		update cc;
            }catch(Exception e){
                System.debug('Exception-->  '+e.getStackTraceString());
            }
            
            //approval process
           /* Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approved by Receptionist');
            req.setAction('Approve');
            Id workItemId  = getWorkItemId(recordId); //CollecCard Id
            req.setWorkitemId(workItemId);
            Approval.ProcessResult result =  Approval.process(req);*/
            
            
        }
        
    }  
   /* public static Id getWorkItemId(Id targetObjectId) {
        
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p 
                                                 where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }
        return retVal;
    }*/
}