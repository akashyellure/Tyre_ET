/*
Created By   : G.Krishnareddy
Created Date : 1/15/2019
Description  : This is for Lead form Controller
*/
public without sharing  class ETT_LeadFormController { 
    
    @AuraEnabled public string acctName;
    @AuraEnabled public string acctPOBox;
    @AuraEnabled public string acctLocation; 
    @AuraEnabled public string acctEmirate;
    @AuraEnabled public string acctPhone;
    @AuraEnabled public string acctFax;
    @AuraEnabled public string acctEmail;
    @AuraEnabled public string acctNatureOfBusiness;
    @AuraEnabled public boolean acctSoleProprietorship;
    @AuraEnabled public boolean acctPartnerShip;
    @AuraEnabled public boolean acctLLC;
    @AuraEnabled public boolean acctGove;
    @AuraEnabled public string  acctNameOfOwnersSponsors1;
    @AuraEnabled public string  acctNameOfOwnersSponsors2;
    @AuraEnabled public string  acctPhone1;
    @AuraEnabled public string  acctPhone2;
    @AuraEnabled public string  acctTradeLicenseNo;
    @AuraEnabled public Date    acctExpiryDate1;
    @AuraEnabled public Date    acctExpiryDate2;
    @AuraEnabled public string  acctChamberOfCommerceCertNo;   
    @AuraEnabled public string  acctVatTrnNo;   
    @AuraEnabled public ETT_LeadFormWrapper objETTLeadWrapper;
    
    
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = ETT_Customer_Vehicle_Details__c.ETT_Vehicle_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static Id getLeadRecordTypeID(String recTypeName) {
        //recTypeName = 'supplier';
        Id LeadRTID = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        return LeadRTID;
    } 

    
    @AuraEnabled        
    public static List<String> getDynamicPickListValuesIntoList(string objectName,string fieldName){
        List<String> pickListValuesList = new List<String>();
        //Get Object Dynamically
        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
                                    .get(objectName).getDescribe();
        // Get the field dynamically
        DescribeFieldResult fieldResult = objResult.fields.getMap()
                                  .get(fieldName).getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Dynamic in Values are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
     @AuraEnabled
     public static Lead getCustomerProfile(ID id){ 

         Lead leadObj = [SELECT Id, Name, LastName, Company, Street, Email,
                         Fax, Website, PostalCode, Address, Phone,
                         ETT_P_O_Box__c,ETT_Location__c,ETT_VAT_TRN__c,ETT_Nature_of_Business__c,
                         ETT_Legal_Status__c,ETT_Name_of_Owners_Sponsors_1__c,ETT_Name_of_Owners_Sponsors_2__c,
                         ETT_Owners_Sponers_Phone_2__c,ETT_Trade_License_Number__c,ETT_Trade_Licenses_Expiry_Date__c, ETT_Chamber_of_Commerce_Certification_No__c, ETT_Chamber_of_Comm_Cert_Expiry_Date__c, ETT_Name_of_Chief_Executive_Officer__c,
                         (SELECT Id, ETT_Lead__c, ETT_Designation__c, ETT_Email__c, ETT_Phone__c, ETT_First_Name__c,Name FROM Staging_Contacts__r),
                         (SELECT Id, ETT_Lead__c, ETT_Application__c, ETT_KMS_Covered_Yearly__c, ETT_Tyres_In_Fleet__c, ETT_Vehicle_Configuration__c, ETT_Vehicle_In_Fleet__c, ETT_Vehicle_Type__c, ETT_Axil_Configuration__c FROM Staging_Customer_Vehicle_Details__r where ETT_Lead__c=:id),
                         (SELECT Id, ETT_Authorized_Person__c, ETT_Lead__c, ETT_Price__c, ETT_Type__c, ETT_Yearly_Qty__c, ETT_Payment_Terms__c, ETT_Recomended_Retreaded_Process__c, ETT_Brand_Master__c, ETT_Credit_Limit__c, ETT_Tyre_Size_Master__c FROM Staging_Purchase_Informations__r where ETT_Lead__c=:id)
                        FROM Lead where Id=:id];
        system.debug('*****leadObj*****'+leadObj);
        return leadObj;

    } 
    
    //Lookup to get and prepopulate the Data
    @AuraEnabled
    public static List<sObject> searchRecord(String objectAPIName, String fieldAPIName, 
                                             List<String> moreFields, String searchText,
                                             Integer recordLimit)
    {
        
        List<sObject> objectList =  new List<sObject>();
        
        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
        
        String soqlQuery = 'SELECT Id, Name';
        if(!moreFields.isEmpty()){
            soqlQuery = soqlQuery + ',' + String.join(moreFields, ',') ;
        }
        soqlQuery = soqlQuery + ' FROM ' + objectAPIName + ' WHERE ' +
            + fieldAPIName +' LIKE '+ searchText + ' LIMIT '+ recordLimit;
        objectList = Database.query(soqlQuery);
        return objectList;
    }
    
    
    
    @AuraEnabled
    public static string saveDML(map<string,string> mapofStageJsonList){
        system.debug('*****mapofStageJsonList*******'+mapofStageJsonList);
        Lead objLead;
        list<ETT_Staging_Contacts__c> lstStagContacts; 
        list<ETT_Staging_Customer_Vehicle_Details__c> lstStagCustomerVehicles;
        list<ETT_Staging_Quotation_Request__c>  lstStagingQuotation;
        list<ETT_Staging_Purchase_Information__c>  lstStgPurchaseInformation;
        list<ETT_Staging_Added_Service__c>  lstStgAddedServices;
        list<ETT_Staging_Bank_Reference__c> lstStgBankingReferences;
        list<ETT_Staging_Trade_Reference__c> lstStgTrageReferences;
        list<ETT_Staging_Customer_LPO__c> lstStgCustomerLpos;
        list<Fleet_Inspection_Line_Item__c> lstStgFleetInspection;
        list<ETT_Staging_Scrap_Inspection__c> lstScrabInspection;
        list<ETT_FleetInspectionWrapper> lstFleetInspectionWrapper;
        list<ETT_Staging_Test_Tyre__c> lstStgTestTyres;
        list<ContentVersion> lstContentVesions = new list<ContentVersion>();
        list<ContentDocumentLink> lstContentDocumentLinks = new list<ContentDocumentLink>();
        map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
        if(mapofStageJsonList.containskey('stgLeadJson')){
            objLead = (Lead) JSON.deserialize(mapofStageJsonList.get('stgLeadJson'),Type.forname('Lead'));
        }
        if(mapofStageJsonList.containskey('stgContactJson')){
            lstStagContacts =  (list<ETT_Staging_Contacts__c>)JSON.deserialize(mapofStageJsonList.get('stgContactJson'),Type.forname('list<ETT_Staging_Contacts__c>'));
        }
        if(mapofStageJsonList.containskey('stgVehicleJson')){
            lstStagCustomerVehicles = (list<ETT_Staging_Customer_Vehicle_Details__c>)JSON.deserialize(mapofStageJsonList.get('stgVehicleJson'),Type.forname('list<ETT_Staging_Customer_Vehicle_Details__c>'));
        }
        if(mapofStageJsonList.containskey('stgQuoteJson')){
            lstStagingQuotation = (list<ETT_Staging_Quotation_Request__c>)JSON.deserialize(mapofStageJsonList.get('stgQuoteJson'),Type.forname('list<ETT_Staging_Quotation_Request__c>'));
        }
        if(mapofStageJsonList.containsKey('stgPurchaseJson')){
            lstStgPurchaseInformation = (list<ETT_Staging_Purchase_Information__c>)JSON.deserialize(mapofStageJsonList.get('stgPurchaseJson'),Type.forname('list<ETT_Staging_Purchase_Information__c>'));
        }
        
        if(mapofStageJsonList.containsKey('stgAddedServiceJson')){
            lstStgAddedServices = (list<ETT_Staging_Added_Service__c>)JSON.deserialize(mapofStageJsonList.get('stgAddedServiceJson'),Type.forname('list<ETT_Staging_Added_Service__c>'));
        }
        
        if(mapofStageJsonList.containsKey('stgCustomerLPOJson')){
            lstStgCustomerLpos = (list<ETT_Staging_Customer_LPO__c>)JSON.deserialize(mapofStageJsonList.get('stgCustomerLPOJson'),Type.forname('list<ETT_Staging_Customer_LPO__c>'));
        }
        
        if(mapofStageJsonList.containsKey('stgTradeReferenceJson')){
            lstStgTrageReferences = (list<ETT_Staging_Trade_Reference__c>)JSON.deserialize(mapofStageJsonList.get('stgTradeReferenceJson'),Type.forname('list<ETT_Staging_Trade_Reference__c>'));
        }
        
        if(mapofStageJsonList.containsKey('stgBankReferenceJson')){
            lstStgBankingReferences = (list<ETT_Staging_Bank_Reference__c>)JSON.deserialize(mapofStageJsonList.get('stgBankReferenceJson'),Type.forname('list<ETT_Staging_Bank_Reference__c>'));
        }
        
        if(mapofStageJsonList.containsKey('stgFleetInspectionJson')){
            lstStgFleetInspection = (list<Fleet_Inspection_Line_Item__c>)JSON.deserialize(mapofStageJsonList.get('stgFleetInspectionJson'),Type.forname('list<Fleet_Inspection_Line_Item__c>'));
        
        }
        
        if(mapofStageJsonList.containsKey('stgScrabInspectionJson')){
            lstScrabInspection = (list<ETT_Staging_Scrap_Inspection__c>)JSON.deserialize(mapofStageJsonList.get('stgScrabInspectionJson'),Type.forname('list<ETT_Staging_Scrap_Inspection__c>')); 
        }
        
        if(mapofStageJsonList.containsKey('stgFleetInspectionJson')){
            lstFleetInspectionWrapper = (list<ETT_FleetInspectionWrapper>)JSON.deserialize(mapofStageJsonList.get('stgFleetInspectionJson'),Type.forname('list<ETT_FleetInspectionWrapper>')); 
            System.debug(lstFleetInspectionWrapper);
        }
        
        if(mapofStageJsonList.containsKey('stgTestTyreJson')){
            lstStgTestTyres = (list<ETT_Staging_Test_Tyre__c>)JSON.deserialize(mapofStageJsonList.get('stgTestTyreJson'),Type.forname('list<ETT_Staging_Test_Tyre__c>'));
        }
        if(objLead!=null){
            try{
                System.debug(objLead);
                System.debug(objLead.RecordTypeId);
                
                System.debug(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId());
                
                if(objLead.RecordTypeId==Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre Cash Individual').getRecordTypeId()){
                   // objLead.Company = objLead.FirstName+' '+objLead.LastName;
                }else if(objLead.RecordTypeId==Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId()){
                  //  objLead.Company = objLead.FirstName+' '+objLead.LastName;
                }
                    
                upsert objLead;
            }Catch(Exception ex){
                system.debug('******Exception Cause *****'+ex.getMessage());
                throw new AuraHandledException(ex.getMessage());
                //return ex.getMessage();
            }
            
            list<Sobject> lstSobjectInformation = new list<Sobject>();
            list<Sobject> lstUpdateSobjectInformation = new list<Sobject>();
            
            if(objLead.Id!=null){
                system.debug('lstStagContacts '+lstStagContacts);
                //Staging Contacts
                if(lstStagContacts!=null && lstStagContacts.size()>0){
                    for(ETT_Staging_Contacts__c objStagingContact :lstStagContacts){
                        if(objStagingContact.Name!=''){
                            if(objStagingContact.ETT_Lead__c==null){
                                objStagingContact.ETT_Lead__c = objLead.Id;
                            }
                            if(objStagingContact.Id!=null){
                                lstUpdateSobjectInformation.add((Sobject)objStagingContact);
                            }else{
                                lstSobjectInformation.add((Sobject)objStagingContact);
                            }
                        }
                        
                    }     
                 }
                
                //Staging Customer Vehicle
                if(lstStagCustomerVehicles!=null && lstStagCustomerVehicles.size()>0){
                    for(ETT_Staging_Customer_Vehicle_Details__c objStgCustomerVehicle :lstStagCustomerVehicles){
                        if(objStgCustomerVehicle.ETT_Lead__c==null){
                            objStgCustomerVehicle.ETT_Lead__c = objLead.Id;
                         }
                        if(objStgCustomerVehicle.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objStgCustomerVehicle);
                        }else{
                            lstSobjectInformation.add((Sobject)objStgCustomerVehicle);
                        }
                        
                    }  
                }
                
                //lstStgTestTyres
                if(lstStgTestTyres!=null && lstStgTestTyres.size()>0){
                   for(ETT_Staging_Test_Tyre__c objStgTestTyre :lstStgTestTyres){
                        if(objStgTestTyre.ETT_Lead__c==null){
                            objStgTestTyre.ETT_Lead__c = objLead.Id;
                         }
                        if(objStgTestTyre.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objStgTestTyre);
                        }else{
                            lstSobjectInformation.add((Sobject)objStgTestTyre);
                        }
                        
                    }  
                }
                
                //Staging Purchase
                if(lstStgPurchaseInformation!=null && lstStgPurchaseInformation.size()>0){
                    for(ETT_Staging_Purchase_Information__c objStagingPurchaseInfo :lstStgPurchaseInformation){
                        if(objStagingPurchaseInfo.ETT_Lead__c==null){
                            objStagingPurchaseInfo.ETT_Lead__c = objLead.Id;
                        }
                        if(objStagingPurchaseInfo.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objStagingPurchaseInfo);
                        }else{
                            lstSobjectInformation.add((Sobject)objStagingPurchaseInfo);
                        }
                        
                    }
                }
                
                //Staging Added Service
                if(lstStgAddedServices!=null && lstStgAddedServices.size()>0){
                    for(ETT_Staging_Added_Service__c objAddedService :lstStgAddedServices){
                        if(objAddedService.ETT_Lead__c==null){
                            objAddedService.ETT_Lead__c = objLead.Id;
                        }
                        if(objAddedService.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objAddedService);
                        }else{
                            lstSobjectInformation.add((Sobject)objAddedService);
                        }
                        
                    }
                }
                
                //Staging LPOS
                if(lstStgCustomerLpos!=null && lstStgCustomerLpos.size()>0){
                    for(ETT_Staging_Customer_LPO__c objStgCustomerLPO :lstStgCustomerLpos){
                        if(objStgCustomerLPO.ETT_Lead__c==null){
                            objStgCustomerLPO.ETT_Lead__c = objLead.Id;
                        }
                        if(objStgCustomerLPO.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objStgCustomerLPO);
                        }else{
                            lstSobjectInformation.add((Sobject)objStgCustomerLPO);
                        }
                        
                    }
                }
                
                //Staging Banking References 
                if(lstStgBankingReferences!=null && lstStgBankingReferences.size()>0){
                    for(ETT_Staging_Bank_Reference__c objStgBankRef :lstStgBankingReferences){
                        if(objStgBankRef.ETT_Lead__c==null){
                            objStgBankRef.ETT_Lead__c = objLead.Id;
                        }
                        if(objStgBankRef.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objStgBankRef);
                        }else{
                            lstSobjectInformation.add((Sobject)objStgBankRef);
                        }                        
                    }
                }
                
                //Staging Trade References
                if(lstStgTrageReferences!=null && lstStgTrageReferences.size()>0){
                    for(ETT_Staging_Trade_Reference__c objStgTradeRef :lstStgTrageReferences){
                        if(objStgTradeRef.ETT_Lead__c==null){
                            objStgTradeRef.ETT_Lead__c = objLead.Id;
                        }
                        if(objStgTradeRef.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objStgTradeRef);
                        }else{
                            lstSobjectInformation.add((Sobject)objStgTradeRef);
                        }                        
                        
                    }
                }
                
                //Staging Fleet Inspection
                if(lstFleetInspectionWrapper!=null && lstFleetInspectionWrapper.size()>0){
                    for(ETT_FleetInspectionWrapper objStgFleetInspectionWrapper : lstFleetInspectionWrapper){
                        if(objStgFleetInspectionWrapper.objFleetInspection!=null && objStgFleetInspectionWrapper.objFleetInspection.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objStgFleetInspectionWrapper.objFleetInspection);
                        }else{
                            lstSobjectInformation.add((Sobject)objStgFleetInspectionWrapper.objFleetInspection);
                        }
                    }
                }
               
                //Staging Quotation Request
                 if(lstStagingQuotation!=null && lstStagingQuotation.size()>0){
                    
                    for(ETT_Staging_Quotation_Request__c objStgQuotationRequest :lstStagingQuotation){
                        
                        if(objStgQuotationRequest.ETT_Tyre_Size_Master__c!=null){
                            
                            if(objStgQuotationRequest.ETT_Lead__c==null){
                                objStgQuotationRequest.ETT_Lead__c = objLead.Id;
                            }
                            if(objStgQuotationRequest.Id!=null){
                                lstUpdateSobjectInformation.add((Sobject)objStgQuotationRequest);
                            }else{
                                lstSobjectInformation.add((Sobject)objStgQuotationRequest);
                            }
                        }
                    }
                }
                
                //Scrab Inspection Report
                if(lstScrabInspection!=null && lstScrabInspection.size()>0){
                    
                    for(ETT_Staging_Scrap_Inspection__c objStgSrabInspection :lstScrabInspection){
                        
                        if(objStgSrabInspection.ETT_Lead__c==null){
                            objStgSrabInspection.ETT_Lead__c = objLead.Id;
                        }
                        if(objStgSrabInspection.Id!=null){
                            lstUpdateSobjectInformation.add((Sobject)objStgSrabInspection);
                        }else{
                            lstSobjectInformation.add((Sobject)objStgSrabInspection);
                        }
                    }
                }
                
                if(lstSobjectInformation!=null && lstSobjectInformation.size()>0){
                    try{
                        System.debug('@@@  ' + lstSobjectInformation);
                      //upsert lstSobjectInformation;
                      insert lstSobjectInformation;
                      //processCasesInformation(lstSobjectInformation,objLead.ID);
                      return objLead.Id;
                    }Catch(Exception ex){
                       system.debug('***Exception Cause *****'+ex.getMessage());
                       return ex.getMessage();
                    }
                }
                
                map<string,string> mapofFleNamewithFleetInspectionIds = new map<string,string>();
                if(lstFleetInspectionWrapper!=null && lstFleetInspectionWrapper.size()>0){
                    System.debug('inside if files');
                   for(ETT_FleetInspectionWrapper objStgFleetInspectionWrapper : lstFleetInspectionWrapper){
                       System.debug('inside for files');
                       for(ETT_FileUploadWrapper  objFileUploadWrapper :objStgFleetInspectionWrapper.lstFileLoadWrapper){
                            ContentVersion objContentVersion = new ContentVersion();
                            objContentVersion.ContentLocation = 'S';
                            objContentVersion.VersionData = EncodingUtil.base64Decode(objFileUploadWrapper.strBase64Data);
                            objContentVersion.Title = objFileUploadWrapper.strFileName;
                            objContentVersion.PathOnClient = objFileUploadWrapper.strFileType;
                            lstContentVesions.add(objContentVersion);
                            mapofFleNamewithFleetInspectionIds.put(objFileUploadWrapper.strFileName,objStgFleetInspectionWrapper.objFleetInspection.Id);
                        }
                      }
                   } 
                
                if(lstContentVesions!=null && lstContentVesions.size()>0){
                    insert lstContentVesions;
                    
                    for(ContentVersion objContentVersion :[Select Id,ContentDocumentId,Title from ContentVersion where Id in :lstContentVesions]){
                      mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
                    }
                    
                    for(ContentVersion objContentVersion :lstContentVesions){
                        ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                        objContentDocumentLink.LinkedEntityId = mapofFleNamewithFleetInspectionIds.containsKey(objContentVersion.Title)?mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Title):null;
                        objContentDocumentLink.ShareType = 'V';
                        objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.containsKey(objContentVersion.Id)?mapofFleNamewithFleetInspectionIds.get(objContentVersion.Id):null;
                        lstContentDocumentLinks.add(objContentDocumentLink);
                    }
                    
                    if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
                        insert lstContentDocumentLinks;
                    }
                  }
                
                if(lstUpdateSobjectInformation!=null && lstUpdateSobjectInformation.size()>0){
                    try{
                      //upsert lstSobjectInformation;
                      update lstUpdateSobjectInformation;
                      return objLead.Id;
                    }Catch(Exception ex){
                       system.debug('***Exception Cause *****'+ex.getMessage());
                       return ex.getMessage();
                    }
                }else if(objLead!=null && objLead.Id!=null){
                    return objLead.Id;
                }
              
             }
        }
        return '';
    }    
    //by goldy singh
     @AuraEnabled
    public static string saveDMLForFleetInspection(map<string,string> mapofStageJsonList){
        system.debug('*****mapofStageJsonList*******'+mapofStageJsonList);
        Lead objLead;
        ETT_Fleet_Inspection__c FleetInspection;
        list<ETT_FleetInspectionWrapper> lstFleetInspectionWrapper;
        list<ETT_Staging_Test_Tyre__c> lstStgTestTyres;
        list<ContentVersion> lstContentVesions = new list<ContentVersion>();
        list<ContentDocumentLink> lstContentDocumentLinks = new list<ContentDocumentLink>();
        map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
        if(mapofStageJsonList.containskey('stgLeadJson')){
            objLead = (Lead) JSON.deserialize(mapofStageJsonList.get('stgLeadJson'),Type.forname('Lead'));
        }
       
        if(mapofStageJsonList.containsKey('stgFleetInspectionJson')){
            
            FleetInspection = (ETT_Fleet_Inspection__c)JSON.deserialize(mapofStageJsonList.get('stgFleetInspectionJson'),Type.forname('ETT_Fleet_Inspection__c'));
          System.debug('FleetInspection'+FleetInspection);
        }
       
        
        if(mapofStageJsonList.containsKey('stgFleetInspectionLineItemJson')){
            lstFleetInspectionWrapper = (list<ETT_FleetInspectionWrapper>)JSON.deserialize(mapofStageJsonList.get('stgFleetInspectionLineItemJson'),Type.forname('list<ETT_FleetInspectionWrapper>')); 
            System.debug('listoflineitem'+lstFleetInspectionWrapper);
        }
        
        if(objLead!=null){
            try{
                System.debug(objLead);
                System.debug(objLead.RecordTypeId);
                
                System.debug(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId());
                
                if(objLead.RecordTypeId==Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre Cash Individual').getRecordTypeId()){
                   // objLead.Company = objLead.FirstName+' '+objLead.LastName;
                }else if(objLead.RecordTypeId==Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId()){
                  //  objLead.Company = objLead.FirstName+' '+objLead.LastName;
                }
                    
               // upsert objLead;
            }Catch(Exception ex){
                system.debug('******Exception Cause *****'+ex.getMessage());
                throw new AuraHandledException(ex.getMessage());
                //return ex.getMessage();
            }
            
            list<Sobject> lstSobjectInformation = new list<Sobject>();
            list<Sobject> lstUpdateSobjectInformation = new list<Sobject>();
            
            if(objLead.Id!=null){
              //Staging Fleet Inspection
              if(FleetInspection.id==null){
                  FleetInspection.Lead__c = objLead.Id;
                    insert FleetInspection;
                  
                  //Staging Fleet Inspection
                if(lstFleetInspectionWrapper!=null && lstFleetInspectionWrapper.size()>0){
                  //  List<>
               
                    for(ETT_FleetInspectionWrapper objStgFleetInspectionWrapper : lstFleetInspectionWrapper){
                      
                        if(objStgFleetInspectionWrapper.objFleetInspection!=null){
                           objStgFleetInspectionWrapper.objFleetInspection.Fleet_Inspection__c = FleetInspection.id;
                            objStgFleetInspectionWrapper.objFleetInspection.FileSourceTemp__c = objStgFleetInspectionWrapper.fileSourceType;
                            lstSobjectInformation.add((Sobject)objStgFleetInspectionWrapper.objFleetInspection);
                           
                        }
                    }
                }
                  
                }
                Map<String,Id> inspectionLineItemMap = new Map<String,Id>();
           
                if(lstSobjectInformation!=null && lstSobjectInformation.size()>0){
                    System.debug('after document insertion10');
                     upsert lstSobjectInformation; 
                    List<Fleet_Inspection_Line_Item__c> inspectionLineItemsList = [Select id,ETT_Tread_Depth_Original__c,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Pattern__c,FileSourceTemp__c from Fleet_Inspection_Line_Item__c where ID IN:lstSobjectInformation];
                    List<ETT_Tyre_Master__c> tyreDetails = [SELECT id,Name,ETT_Original_Depth__c,ETT_Tyre_Size__c,ETT_Brand_Name__c,ETT_Original_Pattern__c FROM ETT_Tyre_Master__c];
        			 List<ETT_Tyre_Master__c> updatetyreDetails = new  List<ETT_Tyre_Master__c>();
                    for(Fleet_Inspection_Line_Item__c insLItem:inspectionLineItemsList)
                    {
                        inspectionLineItemMap.put(insLItem.FileSourceTemp__c, insLItem.id);
                        
                        if(insLItem.ETT_Tyre_Size__c!=null&&insLItem.ETT_Brand__c!=null&&insLItem.ETT_Pattern__c!=null)
                        {
                            for(ETT_Tyre_Master__c tyremaster :tyreDetails )
                            {
                                
                                if(tyremaster.ETT_Tyre_Size__c==insLItem.ETT_Tyre_Size__c &&
                                   tyremaster.ETT_Brand_Name__c==insLItem.ETT_Brand__c  && 
                                   tyremaster.ETT_Original_Pattern__c==insLItem.ETT_Pattern__c &&
                                   insLItem.ETT_Tread_Depth_Original__c!=null&&
                                   (tyremaster.ETT_Original_Depth__c==null||tyremaster.ETT_Original_Depth__c==''))
                                {
                                    ETT_Tyre_Master__c updatetyremaster = tyremaster;
                                   updatetyremaster.ETT_Original_Depth__c =  insLItem.ETT_Tread_Depth_Original__c;
                                    
                                    updatetyreDetails.add(updatetyremaster);
                                    break;
                                }
                                
                            } 
                        }
                        
                    }
                       System.debug('lstSobjectInformationertion'+lstSobjectInformation);
                    if(updatetyreDetails.size()>0)
                    {
                        update updatetyreDetails;
                    }
                   
                }

                map<string,string> mapofFleNamewithFleetInspectionIds = new map<string,string>();
                if(lstFleetInspectionWrapper!=null && lstFleetInspectionWrapper.size()>0){
                    System.debug('inside if files');
                   for(ETT_FleetInspectionWrapper objStgFleetInspectionWrapper : lstFleetInspectionWrapper){
                       System.debug('inside for files');
                       if(objStgFleetInspectionWrapper.lstFileLoadWrapper!=null)
                       {
                         for(ETT_FileUploadWrapper  objFileUploadWrapper :objStgFleetInspectionWrapper.lstFileLoadWrapper){
                            ContentVersion objContentVersion = new ContentVersion();
                            objContentVersion.ContentLocation = 'S';
                               System.debug('controller file name='+objFileUploadWrapper.strFileName);
                             System.debug('controller file strFileType='+objFileUploadWrapper.strFileType);
                             System.debug('controller file encode='+EncodingUtil.base64Decode(objFileUploadWrapper.strBase64Data));
                           
                            objContentVersion.VersionData = EncodingUtil.base64Decode(objFileUploadWrapper.strBase64Data);
                            String tempNameStr = objFileUploadWrapper.strFileName;
                             List<String> filenamesbreak = tempNameStr.split('\\.');
                             System.debug('filenamesbreak='+filenamesbreak);
                             DateTime dt = DateTime.now();
                             String suffix = dt.format('hh_mm_ss') + '_'+dt.millisecond();
                             String imagenamewithsuffix = filenamesbreak[0] +'_'+suffix+'.'+filenamesbreak[1];
                             objContentVersion.Title = imagenamewithsuffix;
                             //objContentVersion.PathOnClient = objFileUploadWrapper.strFileType;
                             objContentVersion.PathOnClient = imagenamewithsuffix;
                            lstContentVesions.add(objContentVersion);
                           Id inspectionLineItemId = inspectionLineItemMap.get(objStgFleetInspectionWrapper.fileSourceType);
                          mapofFleNamewithFleetInspectionIds.put(imagenamewithsuffix,objStgFleetInspectionWrapper.objFleetInspection.Id);
                       //     mapofFleNamewithFleetInspectionIds.put(objFileUploadWrapper.strFileName,inspectionLineItemId);
                        }  
                       }
                       
                      }
                   } 
                
        
                if(lstContentVesions!=null && lstContentVesions.size()>0){
                   // insert lstContentVesions;
                     try{
                    insert lstContentVesions;
                         System.debug('inserted sucessfully');
                }Catch(Exception ex){
                    system.debug('****Exception Cause'+ex.getMessage());
                }
                   System.debug('after document insertion');
                    
                    for(ContentVersion objContentVersion :[Select Id,ContentDocumentId,Title from ContentVersion where Id in :lstContentVesions]){
                      mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
                    }
                        System.debug('after document insertion2');
                    for(ContentVersion objContentVersion :lstContentVesions){
                            System.debug('after document insertion3');
                        ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                             System.debug('after document insertion4.Title='+objContentVersion.Title);
                        System.debug('get id from Map='+mapofFleNamewithFleetInspectionIds.get(objContentVersion.Title));
                        objContentDocumentLink.LinkedEntityId = mapofFleNamewithFleetInspectionIds.containsKey(objContentVersion.Title)?mapofFleNamewithFleetInspectionIds.get(objContentVersion.Title):null;
                      //        objContentDocumentLink.LinkedEntityId = inspectionLineItemMap.containsKey(objContentVersion.Title)?mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Title):null;
                            System.debug('after document insertion5');
                        objContentDocumentLink.ShareType = 'V';
                             System.debug('after document insertion6');
                        //objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.containsKey(objContentVersion.Id)?mapofFleNamewithFleetInspectionIds.get(objContentVersion.Id):null;
                             objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.containsKey(objContentVersion.Id)?mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id):null;
                           System.debug('after document insertion7');
                        lstContentDocumentLinks.add(objContentDocumentLink);
                       
                    }
                      
                    if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
                          
                        insert lstContentDocumentLinks;
                          
                    }
                  }
                  if(objLead!=null && objLead.Id!=null){
                    return objLead.Id;
                }
              
             }
        }
        return '';
    }
    
    public static void processCasesInformation(list<Sobject> lstSobjectInfo,string leadId){
       if(lstSobjectInfo!=null && lstSobjectInfo.size()>0){
        Integer matchCaseNo = 0;
           Group objGroup = [SELECT Id, Name, OwnerId FROM Group where Name = 'Inspection Card'];
           System.debug('objGroup: '+objGroup.Id);
           
        Id supplierRecordTypeId ;
           try{
              supplierRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ETT Supplier').getRecordTypeId();
           }catch(Exception e){
               
           }
        list<Case> lstChildCases = new list<Case>();            
        for(Sobject sobj : lstSobjectInfo){
            if(sobj.getSObjectType()==Schema.ETT_Staging_Quotation_Request__c.getSObjectType()){
                ETT_Staging_Quotation_Request__c objStatgingQuotation = (ETT_Staging_Quotation_Request__c)sobj;
                if(objStatgingQuotation.ETT_New_Brand__c!='' ||
                   objStatgingQuotation.ETT_New_Country__c!='' ||
                   objStatgingQuotation.ETT_New_Pattern__c!='' ||
                   objStatgingQuotation.ETT_New_Tyre_Size__c!=''){ 
                   
                    matchCaseNo++;    
                    Case stgQuotationChildCase = new Case();
                       if(supplierRecordTypeId != null){
                          stgQuotationChildCase.RecordTypeId = supplierRecordTypeId;  
                       }
                    //stgQuotationChildCase.RecordTypeId = supplierRecordTypeId;
                    stgQuotationChildCase.Status = 'New';
                    stgQuotationChildCase.Subject = 'Create a new entry into Tyre Master';
                    stgQuotationChildCase.ETT_Staging_Quotation_Request__c = objStatgingQuotation.Id;
                    stgQuotationChildCase.ETT_Brand__c = objStatgingQuotation.ETT_Brand__c;
                    stgQuotationChildCase.ETT_Country_Master__c  = objStatgingQuotation.ETT_Country__c ;
                    stgQuotationChildCase.ETT_Pattern__c = objStatgingQuotation.ETT_Pattern__c;
                    stgQuotationChildCase.ETT_Tyre_Size__c = objStatgingQuotation.ETT_Tyre_Size_Master__c;
                       
                    stgQuotationChildCase.OwnerId = objGroup.Id;
                    lstChildCases.add(stgQuotationChildCase);
                }
            }
        }
            if(matchCaseNo>0){
                System.debug('objGroup: '+objGroup);
                Case stgParentCase = new Case();
                stgParentCase.Status = 'New';
                stgParentCase.Subject = 'Parent Lead for New Tyre Master Details Found';  
                stgParentCase.OwnerId = objGroup.Id;
                
                System.debug('stgParentCase: '+stgParentCase);  
                try{
                	insert stgParentCase;    
                }catch(Exception ex){
                    System.debug(ex.getLineNumber()+' : '+ex.getMessage());
                }
                
                if(lstChildCases!=null && lstChildCases.size()>0){
                    for(Case objChildCase :lstChildCases){
                       objChildCase.ParentId = stgParentCase.Id;
                    }
                    try{
                        insert lstChildCases;
                    }Catch(Exception ex){
                        system.debug(ex.getLineNumber()+' : '+ex.getMessage());
                    }
                    
                }
                
            }
      }
    }
    
    //This is for Preparing the Dynamic Pick list Values for Combination
    @AuraEnabled
    public static Map<String, String> getselectOptions(sObject objObject, string fld) {
        
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        
        Schema.sObjectType objType = objObject.getSObjectType();
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
    
    //Added by Goldy singh
    @AuraEnabled
    public static String getVehicleNumber(String internalNo){
       String VehicleNumber = '';
        List<ETT_Vehicle_Details__c> VehicleDetaillist  = [Select id ,Name from ETT_Vehicle_Details__c Where ETT_Internal_Number__c =:internalNo] ;
        if(VehicleDetaillist.Size()>0){
            VehicleNumber = VehicleDetaillist[0].Name;
            
        }
        
        
        
        return VehicleNumber;
    }
    //Added By Goldy Singh
     @AuraEnabled
    public static Lead getLeadInfo(Id leadId){
        Lead lead = [Select id, Name,ETT_Location__c,ETT_Party_Type__c from Lead Where Id=:leadId];
        return lead;
    }
    
    @AuraEnabled
    public static String getPressure(String tyreSize,String VehicleType)
    {
        String pressure = '';
        
        List<ETT_Tyre_Pressure_Information__mdt> entList = [SELECT DeveloperName, Label,Tyre_Pressure__c
                                                            FROM ETT_Tyre_Pressure_Information__mdt ];
        
        for(ETT_Tyre_Pressure_Information__mdt meta:entList)
        {
            String label = meta.Label;
            
            if(label.contains(VehicleType)&&label.contains(tyreSize))   
            {
                pressure = meta.Tyre_Pressure__c;
            }
        }
        return pressure;
    }
     //Added By Goldy Singh
     @AuraEnabled
    public static String getOriginalDepth(String tyreSize,String tyreBrand, String tyrePattern)
    {
        String OriginalDepth = '';
        List<ETT_Tyre_Master__c> tyreDetails = [SELECT id,Name,ETT_Original_Depth__c FROM ETT_Tyre_Master__c where ETT_Tyre_Size__c=:tyreSize and ETT_Brand_Name__c=:tyreBrand and ETT_Original_Pattern__c=:tyrePattern ];
        System.debug('tyreDetails='+tyreDetails);
        if(tyreDetails.Size()>0)
        {
            OriginalDepth =  tyreDetails[0].ETT_Original_Depth__c;
        }
        
        return OriginalDepth;
    }
    
    
}