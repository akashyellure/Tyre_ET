/*
Created By   : G.Krishnareddy
Created Date : 20/02/2020
Description  : This is for Once that Account Opening form got approved then we need to convert that Lead and auto update the detais.
*/ 
public without sharing class ETT_LeadConvertProcessController {
    
    Public Lead objLead;
    
    public ETT_LeadConvertProcessController(ApexPages.StandardController controller){
        objLead = (Lead)controller.getRecord();
    }
    
    public  Pagereference leadConvertProcess() {
        List<ETT_ORG_Setting__mdt> ettOrgSettingLst = [SELECT MasterLabel,DeveloperName FROM ETT_ORG_Setting__mdt where MasterLabel=:UserInfo.getProfileId()];
        if(objLead!=null && objLead.status=='Qualified' && ettOrgSettingLst!=null && ettOrgSettingLst.size()>0){
            string strLeadId = objLead.Id;
            string leadRecordTypeName = getRecordTypeNameById('Lead',objLead.RecordTypeId);
            
            
            
            //added by shweta on 28th Feb Start
            list<ETT_Staging_Quotation_Request__c> lstQuotationReqRefs = new list<ETT_Staging_Quotation_Request__c>();
            lstQuotationReqRefs = [select Id,ETT_Purchase_Price__c,ETT_Min_Range__c,ETT_Max_Range__c,RecordType.Name,ETT_Tyre_Size_Master__r.Name,ETT_Lead__r.LastName,ETT_Approve_Stage__c,ETT_IS_Approved__c,ETT_Lead__c,ETT_Quantity__c,ETT_Rejection_Comments__c,ETT_Retreading_charge__c,ETT_Stock_Retreading_Charge__c,ETT_Tyre_Size_Master__c,
                                   ETT_Brand__c,ETT_Country__c, ETT_Pattern__c from ETT_Staging_Quotation_Request__c where 
                                   ETT_Lead__c=:strLeadId and ETT_Lead__r.status='Qualified'];
            
            map<string,string> mapofLeadwithAcctId = new map<string,string>();
            list<Sobject> lstSobjectStagingInfo = new list<Sobject>();
            
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(strLeadId);
            //LeadStatus Leads= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true and MasterLabel='Qualified' LIMIT 1];
            LeadStatus Leads= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            Leadconvert.setConvertedStatus(Leads.MasterLabel);
            Database.LeadConvertResult Leadconverts = Database.convertLead(Leadconvert);
            
            //ID accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(leadRecordTypeName).getRecordTypeId();
            ID accRecordTypeId;
            System.debug('leadRecordTypeName: '+leadRecordTypeName);
            if(leadRecordTypeName=='Tyre - Refurbishing Services'){
                accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
                //accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Tyre Customer').getRecordTypeId();
                System.debug('accRecordTypeId: '+accRecordTypeId);
            }else{
                 accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
                //ID accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId();
                System.debug('accRecordTypeId: '+accRecordTypeId);
            }
            
            
            Account objAccount;
            Opportunity objOppty;
            Contact objContact;
            ETT_Price_Master__c objPriceMaster;
            
            try{
                objAccount = new Account();
                objContact = new Contact();
                objOppty = new Opportunity();
                System.debug('leadRecordTypeName: '+leadRecordTypeName);
               
                if(leadRecordTypeName=='Tyre - Cash Supplier'){
                    System.debug('inside tyre cash supplier');
                    objContact.OwnerId = UserInfo.getUserId();
                    objAccount.Party_Type__c = 'Supplier';
                    objAccount.ETT_Payment_Type__c = 'Cash';
                    objAccount.ETT_VAT_TRN_No__c = String.valueOf(objLead.ETT_VAT_TRN__c);
                    objAccount.ET_Emirates_Id__c = objLead.ETT_Emirates_Id__c;
                    objAccount.RecordTypeId = accRecordTypeId;
                    //if(objLead.ETT_Trade_License_Number__c!=''){
                        //objAccount.ETT_Trade_License_Number__c = objLead.ETT_Trade_License_Number__c;                        
                        objAccount.ETSALES_Trade_License_Number__c = objLead.ETT_Trade_License_Number__c;                        
                    //}
                    objAccount.ETT_Email__c = objLead.Email;
                    
                    //objAccount.ETT_Trade_Licenses_Expiry_Date__c = objLead.ETT_Trade_Licenses_Expiry_Date__c;
                    objAccount.ETSALES_Trade_License_Expiry_Date__c = objLead.ETT_Trade_Licenses_Expiry_Date__c;
                    objAccount.Phone = objLead.Phone;
                    objAccount.ETT_Party_Code__c = Leadconverts.accountid;
                    objAccount.ETT_Type__c = 'Company';
                    objAccount.Website = objLead.Website;
                    objAccount.Id =Leadconverts.getAccountId();
                    objOppty.Id = Leadconverts.getOpportunityId(); 
                    objContact.Id = Leadconverts.getContactId();
                    objContact.AccountId = Leadconverts.getAccountId();
                    //objContact.AccountId = Leadconverts.getContactId();
                    objOppty.RecordTypeId =  getRecordTypeIdbyName('Opportunity','Tyre - Cash Supplier');
                    //objContact.RecordTypeId =  getRecordTypeIdbyName('Contact','Tyre Supplier');
                    objContact.RecordTypeId =  getRecordTypeIdbyName('Contact','B2B Contact');
                }
                if(leadRecordTypeName=='Tyre Cash Individual'){
                    RecordType accRecTypeId = [Select id from RecordType where sObjectType = 'Account' and DeveloperName ='Person_B2C'];
                    /*objAccount.ETT_Type__c = 'Individual';
                    objAccount.Party_Type__c = 'Supplier';
                    objAccount.ETT_Payment_Type__c = 'Cash';
                    objAccount.ET_Emirates_Id__c = objLead.ETT_Emirates_Id__c;
                    objAccount.Phone = objLead.Phone;
                    objAccount.ETT_Party_Code__c = Leadconverts.accountid;
                    objAccount.Id =Leadconverts.accountid;
                    objAccount.FirstName = 'sneha';
                    objAccount.LastName = 'akhade';              
                    objAccount.PersonEmail = 'akhade@gm.com';
                    objAccount.PersonMailingCity = 'dubai';
                    objAccount.PersonMailingStreet = 'dubai';
                    objAccount.PersonMailingState =  'dubai';
                    objAccount.RecordTypeId = accRecTypeId.Id;
                    //objAccount.RecordTypeId = accRecTypeId.Id;
                    // objContact.Id = Leadconverts.getContactId();
                    //objContact.RecordTypeId =  getRecordTypeIdbyName('Contact','Tyre Supplier');
                    //objContact.AccountId = Leadconverts.getAccountId();*/
                    //Lead recLead = [select Id,Name from Lead where Id=:objLead.Id];
                    List<Account> lstAcc = [SELECT Id, Name FROM Account  where Id=:Leadconverts.getAccountId()];
                    objAccount.Id = Leadconverts.getAccountId();
                    objOppty.Id = Leadconverts.getOpportunityId(); 
                    objOppty.Name = lstAcc[0].Name; //recLead.Name;
                    objOppty.RecordTypeId =  getRecordTypeIdbyName('Opportunity','Tyre - Cash Individual');
                }
                if(leadRecordTypeName=='Tyre - Refurbishing Services'){
                    
                    System.debug('inside Tyre - Refurbishing Services');
                    
                    objOppty.RecordTypeId =  getRecordTypeIdbyName('Opportunity','Tyre Refurbishing Services');
                    //objContact.RecordTypeId =  getRecordTypeIdbyName('Contact','Tyre Customer');
                    objContact.RecordTypeId =  getRecordTypeIdbyName('Contact','B2B Contact');
                    //objAccount.RecordTypeId =  getRecordTypeIdbyName('Account','Tyre Customer');
                    objAccount.RecordTypeId =  getRecordTypeIdbyName('Account','Organization');
                    objContact.OwnerId = UserInfo.getUserId();
                    objAccount.Party_Type__c = 'Customer';
                    objAccount.ETT_Payment_Type__c = 'Cash';
                    objAccount.ETT_VAT_TRN_No__c = String.valueOf(objLead.ETT_VAT_TRN__c);
                    //objAccount.ET_Emirates_Id__c = objLead.ETT_Emirates_Id__c;
                    //objAccount.ETT_Trade_License_Number__c = objLead.ETT_Trade_License_Number__c;
                    objAccount.ETSALES_Trade_License_Number__c = objLead.ETT_Trade_License_Number__c;
                    //objAccount.ETT_Trade_Licenses_Expiry_Date__c = objLead.ETT_Trade_Licenses_Expiry_Date__c;
                    objAccount.ETSALES_Trade_License_Expiry_Date__c = objLead.ETT_Trade_Licenses_Expiry_Date__c;
                    objAccount.Phone = objLead.Phone;
                    objAccount.ETT_Party_Code__c = Leadconverts.accountid;
                    objAccount.ETT_Type__c = 'Company';
                    objAccount.ETT_Email__c = objLead.Email;
                    objAccount.Website = objLead.Website;
                    objAccount.Id =Leadconverts.accountid;
                    objOppty.Id = Leadconverts.getOpportunityId(); 
                    objContact.Id = Leadconverts.getContactId();
                    objContact.AccountId = Leadconverts.getAccountId();
                }
                if(leadRecordTypeName=='Tyre - Credit/B2B Supplier'){
                    
                    System.debug('inside B2B Credit');
                    System.debug(objLead);
                    //
                    if(objLead.ETT_Party_Type__c=='Supplier'){
                        objAccount.Party_Type__c = 'Supplier';
                        objAccount.ETT_Payment_Type__c = 'Credit';
                        objAccount.RecordTypeId =  getRecordTypeIdbyName('Account','Organization');
                        objContact.RecordTypeId =  getRecordTypeIdbyName('Contact','B2B Contact');
                        objOppty.RecordTypeId =  getRecordTypeIdbyName('Opportunity','Tyre - Credit/B2B Supplier');
                    }else if(objLead.ETT_Party_Type__c=='Customer'){
                        objAccount.Party_Type__c = 'Customer';
                        objAccount.ETT_Payment_Type__c = 'Credit';
                       // objAccount.RecordTypeId =  getRecordTypeIdbyName('Account','Tyre Customer');
                       // objContact.RecordTypeId =  getRecordTypeIdbyName('Contact','Tyre Customer');
                        objAccount.RecordTypeId =  getRecordTypeIdbyName('Account','Organization');
                        objContact.RecordTypeId =  getRecordTypeIdbyName('Contact','B2B Contact');                        
                        objOppty.RecordTypeId =  getRecordTypeIdbyName('Opportunity','Tyre - Credit/B2B Supplier');                        
                    }
                    objAccount.ETT_Email__c = objLead.Email;
                    objContact.OwnerId = UserInfo.getUserId();
                    objAccount.ETT_VAT_TRN_No__c = String.valueOf(objLead.ETT_VAT_TRN__c);
                    objAccount.ET_Emirates_Id__c = objLead.ETT_Emirates_Id__c;
                    //objAccount.ETT_Trade_License_Number__c = objLead.ETT_Trade_License_Number__c;
                    objAccount.ETSALES_Trade_License_Number__c = objLead.ETT_Trade_License_Number__c;
                    //objAccount.ETT_Trade_Licenses_Expiry_Date__c = objLead.ETT_Trade_Licenses_Expiry_Date__c;
                    objAccount.ETSALES_Trade_License_Expiry_Date__c = objLead.ETT_Trade_Licenses_Expiry_Date__c;
                    objAccount.Phone = objLead.Phone;
                    objAccount.ETT_Party_Code__c = Leadconverts.accountid;
                    objAccount.ETT_Type__c = 'Company';
                    objAccount.Website = objLead.Website;
                    objAccount.Id =Leadconverts.getAccountId();
                    objOppty.Id = Leadconverts.getOpportunityId(); 
                    objContact.Id = Leadconverts.getContactId();
                    objContact.AccountId = Leadconverts.getAccountId();
                }
                
                System.debug('objOppty: '+objOppty);
                System.debug('objAccount: '+objAccount);
                System.debug('objContact: '+objContact);
                
                //objOppty.OwnerId = UserInfo.getUserId();
                sObject sObjOppty = (sObject)objOppty;            
                sObject sObjAccount = (sObject)objAccount;  
                sObject sObjContact = (sObject)objContact;

                System.debug('sObjOppty: '+sObjOppty);
                
                List<sObject> lstsObjectRecordTypeUpdates = new List<sObject>();
                if(leadRecordTypeName=='Tyre Cash Individual'){
                    lstsObjectRecordTypeUpdates.add(sObjAccount);
                    lstsObjectRecordTypeUpdates.add(sObjOppty);
                    //List<sObject> lstsObjectRecordTypeUpdates = new List<sObject>{sObjOppty};
                }else{
                    lstsObjectRecordTypeUpdates.add(sObjAccount);
                    lstsObjectRecordTypeUpdates.add(sObjContact);
                    lstsObjectRecordTypeUpdates.add(sObjOppty);
                    //List<sObject> lstsObjectRecordTypeUpdates = new List<sObject>{sObjAccount,sObjContact,sObjOppty};
                }
                
                System.debug('lstsObjectRecordTypeUpdates');
                System.debug(lstsObjectRecordTypeUpdates);   
                
                if(lstsObjectRecordTypeUpdates!=null && lstsObjectRecordTypeUpdates.size()>0){
                    try{
                        update lstsObjectRecordTypeUpdates;       
                    }Catch(Exception ex){
                        system.debug(ex.getCause());
                        system.debug('****Exception Casue ****'+ex.getLineNumber()+' : '+ex.getMessage());
                    }
                    
                }
                List<Lead> lstLead = [select Id,ETT_Party_Type__c,Phone,ETT_VAT_TRN__c,Address,Street,CreatedById from Lead where Id=:objLead.Id];
                System.debug('create ETT_Price_Master__c object');
                objPriceMaster = new ETT_Price_Master__c();
                objPriceMaster.ETT_CC__c = objAccount.ETT_Email__c;
                objPriceMaster.ETT_Contact_Person__c = objContact.Id;
                objPriceMaster.ETT_Party_Name__c = objAccount.Id;
                objPriceMaster.ETT_Party_Type__c = lstLead[0].ETT_Party_Type__c;
                objPriceMaster.ETT_Payment_Terms__c = '120 days';
                objPriceMaster.ETT_Phone__c = lstLead[0].Phone;
                objPriceMaster.ETT_TRN_Number__c = lstLead[0].ETT_VAT_TRN__c;
                objPriceMaster.ETT_Customer_Address__c = String.valueOf(lstLead[0].Street);
                objPriceMaster.ETT_Created_By__c = lstLead[0].CreatedById;
                objPriceMaster.ETT_Created_Date__c = Date.valueOf(System.now());
                objPriceMaster.ETT_Sales_Person__c = lstLead[0].CreatedById;
                //objPriceMaster.ETT_TRN_Number__c = ettVatTrnNo;
                objPriceMaster.ETT_Price_Information_External_Id__c = objAccount.Id+objPriceMaster.ETT_Party_Type__c;
                System.debug('objLead.ETT_Party_Type__c: '+objLead.ETT_Party_Type__c);
                objPriceMaster.RecordTypeId = getRecordTypeIdbyName('ETT_Price_Master__c',objLead.ETT_Party_Type__c);
                objPriceMaster.OwnerId = UserInfo.getUserId();
                insert objPriceMaster;
                System.debug('objPriceMaster id: '+objPriceMaster.Id);
            }catch(Exception ex){
                System.debug('objPriceMaster Exception: '+ex.getMessage());
            }
            
            system.debug('*****lstQuotationReqRefs*****'+lstQuotationReqRefs);
            list<Sobject> lstPricingInformation = new list<Sobject>();
            if(lstQuotationReqRefs!=null && lstQuotationReqRefs.size()>0){
                for(ETT_Staging_Quotation_Request__c objStagingQuotaion :lstQuotationReqRefs){
                    
                    //ETT_Pricing_Information__c start by shweta on 4th Feb
                    ETT_Pricing_Information__c objPricingInformation = new ETT_Pricing_Information__c();
                    objPricingInformation.ETT_Brand__c = objStagingQuotaion.ETT_Brand__c!=null?objStagingQuotaion.ETT_Brand__c:null;
                    objPricingInformation.ETT_Country_of_Origin__c = objStagingQuotaion.ETT_Country__c!=null ?objStagingQuotaion.ETT_Country__c:null;
                    objPricingInformation.ETT_Price__c = objPriceMaster!=null?objPriceMaster.Id:null;
                    
                    objPricingInformation.ETT_Pattern__c = objStagingQuotaion.ETT_Pattern__c;
                    objPricingInformation.ETT_Tyre_Size__c = objStagingQuotaion.ETT_Tyre_Size_Master__c;
                    objPricingInformation.ETT_Purchase_Price__c = objStagingQuotaion.ETT_Purchase_Price__c; 
                    objPricingInformation.ETT_Minimum_Price__c = objStagingQuotaion.ETT_Min_Range__c;
                    objPricingInformation.ETT_Maximum_Price__c = objStagingQuotaion.ETT_Max_Range__c;
                    objPricingInformation.FM_Accepted_Rejected__c = 'Approved the Pricing Information';
                    objPricingInformation.ETT_Price__c         = objPriceMaster.Id;
                    
                    /*if(objStagingQuotaion.RecordTypeId!=''){
                        String recTypeName = Schema.getGlobalDescribe().get('ETT_Staging_Quotation_Request__c').getDescribe().getRecordTypeInfosById().get(objStagingQuotaion.RecordTypeId).getName();
                        System.debug('recTypeName: '+recTypeName);
                        if(recTypeName == 'Supplier'){
                            objPricingInformation.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                        }else{
                            objPricingInformation.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                        }
                    } */                   
                    objPricingInformation.RecordTypeId = getRecordTypeIdbyName('ETT_Pricing_Information__c','Supplier');
                    System.debug(objPricingInformation);
                    
                    lstPricingInformation.add((Sobject)objPricingInformation);
                }
                
            }
            
            if(lstPricingInformation!=null && lstPricingInformation.size()>0)
            {
                Database.SaveResult[] stagingToTargetObjectlst = Database.insert(lstPricingInformation,false);
                
                list<ETT_Apex_Error_log__c> lstETTErrorLog = new list<ETT_Apex_Error_log__c>();
                if(!stagingToTargetObjectlst.isEmpty()){
                    for(integer i = 0; i<stagingToTargetObjectlst.size(); i++) {
                        string succesStgMsg = '';
                        string failureStgMsg = '';
                        Database.SaveResult invMasterRes = stagingToTargetObjectlst[i];
                        //Staging__c staging = percentInjobShr.RowCause = Schema.ETT_Pricing_Information__Share.RowCause.Manual;stance.stagingSucessAndError[i];
                        if(invMasterRes.isSuccess()) {
                            
                            succesStgMsg += 'Target Object Inserted Sucessfully:'+stagingToTargetObjectlst[i].Id+';';
                        } else {
                            for(Database.Error err : invMasterRes.getErrors()) {
                                ETT_Apex_Error_log__c objErrorLog =  new ETT_Apex_Error_log__c(); 
                                objErrorLog.ETT_Error_Message__c = err.getStatusCode() + ': ' + err.getMessage()+' '+ETT_ConstantCls.strFailure + err.getFields();
                                objErrorLog.ETT_Class__c = ETT_ConstantCls.strClassNameMethod;
                                objErrorLog.ETT_S_Object_Id__c    = invMasterRes.getId();
                                objErrorLog.ETT_Line_Number__c    = string.valueOf(err.getFields());
                                objErrorLog.ETT_Log_Time__c       = Datetime.now();
                                lstETTErrorLog.add(objErrorLog);
                            }
                            
                        } 
                    }
                }
                
                
                if(!lstETTErrorLog.isEmpty()){
                    insert lstETTErrorLog;
                }
                
                system.debug('****lstETTErrorLog*****'+lstETTErrorLog);
                
            }
            
            System.debug('objAccount.Id: '+objAccount);
            
            return new Pagereference('/'+objAccount.Id);
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot convert un qualified leads.'));
            return null;
        }
        
    }   
    
    
    
    
    public static Id getRecordTypeIdbyName(String objectName,String strRecordTypeName){ 
        if(objectName!='' && strRecordTypeName!='' && Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId()!=null)
            return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId();
        else
            return '';
    }
    
    
    
    public static String getRecordTypeNameById(String objectName,Id strRecordTypeId){
        return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(strRecordTypeId).getName();
    }
    
    
}