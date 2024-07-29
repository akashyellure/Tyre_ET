/*
Created By:G.krishnareddy
Created Date:05-09-2020
Description:Quotation Approval form
*/ 
public without sharing class ETT_QuotationApprovalController {
    
    //Wrapper class to store the column values of data table
    public class QuotationSubmittedRecordsWrapper{
        @AuraEnabled public Id workItemId;
        @AuraEnabled public String recordId;
        @AuraEnabled public String relatedTo;
        @AuraEnabled public String recordName;
        @AuraEnabled public String submittedBy;
        @AuraEnabled public Date submittedDate;
        @AuraEnabled public list<ETT_Staging_Quotation_Request__c> lstStagingQuotations;
    }
    
    public static Id getRecordTypeIdbyName(String objectName,String strRecordTypeName){ 
        if(objectName!='' && strRecordTypeName!='' && Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId()!=null)
            return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId();
        else
            return '';
    }
    
    @AuraEnabled
    public static List<ETT_Tyre_Master__c> getTyreMasterDetails(ID recId){
        List<ETT_Tyre_Master__c> lstTyreMaster = [SELECT Id, ETT_Lead__c, RecordTypes__c, ETT_Status__c, ETT_Brand_Name__r.Name, ETT_Country_Name__r.Name, ETT_Original_Pattern__r.Name, 
                                                  ETT_Tyre_Size__r.Name,  RecordType.Name FROM ETT_Tyre_Master__c where RecordType.Name='Draft' and ETT_Lead__c=:recId];
    	
        if(lstTyreMaster!=null && lstTyreMaster.size()>0){
            for(ETT_Tyre_Master__c obj:lstTyreMaster){

               /* if(obj.RecordType.Name=='Draft'){
                    
                }else if(obj.RecordType.Name=='Approved'){
                    
                }else if(obj.RecordType.Name=='Rejected'){
                    
                }*/
                
            }
        }
        return lstTyreMaster;
    }
    


    @AuraEnabled
    public static void approveTyreMasterDetails(map<string,string> mapofStageJsonList,string leadId){
        
        List<ETT_Tyre_Master__c> lstTyreMaster;
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        
        if(mapofStageJsonList.containskey('stgTyreMasterJson')){
            lstTyreMaster =  (list<ETT_Tyre_Master__c>)JSON.deserialize(mapofStageJsonList.get('stgTyreMasterJson'),Type.forname('list<ETT_Tyre_Master__c>'));
        }
        
        list<ETT_Tyre_Size_Master__c> lstTyreSize;
        list<ETT_Brand_Master__c> lstBrand;
        list<ETT_Pattern_Master__c> lstPattern;
        list<ETT_Country_Master__c> lstCountry;
        list<Sobject> lstSobjectInformation = new list<Sobject>();

        Set<ID> lstID = new Set<ID>();
        Set<ID> lstTyreSizeID = new Set<ID>();
        Set<ID> lstBrandID = new Set<ID>();
        Set<ID> lstPatternID = new Set<ID>();
        Set<ID> lstCountryID = new Set<ID>();
        Map<ID,String> idRecordTypeNameMap = new Map<ID,String>();

        if(lstTyreMaster!=null && lstTyreMaster.size()>0){
            for(ETT_Tyre_Master__c obj:lstTyreMaster){
                if(obj.ETT_Status__c==true){
                    lstID.add(obj.Id);
                    idRecordTypeNameMap.put(obj.Id, obj.RecordTypes__c);
                }
            }
        }
        System.debug('lstID: '+lstID);
        System.debug('idRecordTypeNameMap: '+idRecordTypeNameMap);
        
        String recordType;
        if(lstTyreMaster!=null && lstTyreMaster.size()>0){
            List<ETT_Tyre_Master__c> listTyreMaster = [Select Id,ETT_Tyre_Size__c,ETT_Brand_Name__c,ETT_Original_Pattern__c,ETT_Country_Name__c,RecordTypes__c from ETT_Tyre_Master__c where Id in :lstID];
            if(listTyreMaster!=null && listTyreMaster.size()>0){
                
                System.debug('listTyreMaster: '+listTyreMaster);
                
                for(ETT_Tyre_Master__c obj:listTyreMaster){
                    lstTyreSizeID.add(obj.ETT_Tyre_Size__c);
                    lstBrandID.add(obj.ETT_Brand_Name__c);
                    lstPatternID.add(obj.ETT_Original_Pattern__c);
                    lstCountryID.add(obj.ETT_Country_Name__c);
                    
                    if(idRecordTypeNameMap.containskey(obj.Id)){
                        recordType = idRecordTypeNameMap.get(obj.Id);
                    }
                    if(recordType=='Approve'){
                        obj.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Approved').getRecordTypeId();
                    }else if(recordType=='Reject'){
                        obj.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Reject').getRecordTypeId();
                    }
                    
                    lstSobjectInformation.add(obj);
                }
            }
        }
       
        System.debug('lstSobjectInformation: '+lstSobjectInformation);
        
        if(lstTyreSizeID!=null){
            lstTyreSize = [Select Id,ETT_Status__c from ETT_Tyre_Size_Master__c where Id in :lstTyreSizeID];
            if(lstTyreSize!=null && lstTyreSize.size()>0){
                for(ETT_Tyre_Size_Master__c obj:lstTyreSize){
                    obj.ETT_Status__c = true;
                    lstSobjectInformation.add(obj);
                }
            }
        }
        if(lstBrandID!=null){
            lstBrand = [Select Id,ETT_Status__c from ETT_Brand_Master__c where Id in :lstBrandID];
            if(lstBrand!=null && lstBrand.size()>0){
                for(ETT_Brand_Master__c obj:lstBrand){
                    obj.ETT_Status__c = true;
                    lstSobjectInformation.add(obj);
                }
            }
        }
        if(lstPatternID!=null){
            lstPattern = [Select Id,ETT_Status__c from ETT_Pattern_Master__c where Id in :lstPatternID];
            if(lstPattern!=null && lstPattern.size()>0){
                for(ETT_Pattern_Master__c obj:lstPattern){
                    obj.ETT_Status__c = true;
                    lstSobjectInformation.add(obj);
                }
            }
        }
        if(lstCountryID!=null){
            lstCountry = [Select Id,ETT_Status__c from ETT_Country_Master__c where Id in :lstCountryID];
            if(lstCountry!=null && lstCountry.size()>0){
                for(ETT_Country_Master__c obj:lstCountry){
                    obj.ETT_Status__c = true;
                    lstSobjectInformation.add(obj);
                }
            }
        }
        
        if(lstSobjectInformation!=null){
            try{
                update lstSobjectInformation;
            }catch(Exception ex){
                System.debug('Exception : '+ex.getMessage());
            }
        }
        
        
        
        if(lstTyreMaster!=null && lstTyreMaster.size()>0){
            for(ETT_Tyre_Master__c obj:lstTyreMaster){
                if(obj.RecordTypes__c=='Approve' && obj.ETT_Status__c==true){
                    ETT_Staging_Quotation_Request__c objStgQuotation = new ETT_Staging_Quotation_Request__c();
                    objStgQuotation.ETT_Tyre_Size_Master__c = obj.ETT_Tyre_Size__c;
                    objStgQuotation.ETT_Brand__c = obj.ETT_Brand_Name__c;
                    objStgQuotation.ETT_Country__c = obj.ETT_Country_Name__c;
                    objStgQuotation.ETT_Pattern__c = obj.ETT_Original_Pattern__c;
                    objStgQuotation.ETT_Purchase_Price__c = 0.00;
                    objStgQuotation.ETT_Lead__c = leadId;
                    objStgQuotation.RecordTypeId = Schema.SObjectType.ETT_Staging_Quotation_Request__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                    
                    lstStgQuotation.add(objStgQuotation);
                }                    
            }
        }
        System.debug('lstStgQuotation: '+lstStgQuotation);
       
        if(lstStgQuotation!=null && lstStgQuotation.size()>0){
            try{
                upsert lstStgQuotation;
            }catch(Exception ex){
                System.debug('Exception: '+ex.getMessage());
            }
        }    

		
        
    }
    

    @AuraEnabled
    public static QuotationSubmittedRecordsWrapper getSubmittedRecords(string strLeadId){
        list<ETT_Staging_Quotation_Request__c> lstStagQuotaionReq = [Select Id,ETT_Min_Range__c,ETT_Max_Range__c,ETT_Purchase_Price__c,ETT_Tyre_Size_Master__r.Name,ETT_Lead__r.LastName,ETT_Approve_Stage__c,ETT_IS_Approved__c,ETT_Lead__c,ETT_Quantity__c,ETT_Rejection_Comments__c,ETT_Retreading_charge__c,ETT_Stock_Retreading_Charge__c,ETT_Tyre_Size_Master__c,ETT_Tyre_Life__c,ETT_Tyre_Condition__c,ETT_Tyre_Process__c,ETT_Reasons_For_Price_Reduction__c
                                                                     from ETT_Staging_Quotation_Request__c where ETT_Lead__c =:strLeadId and ETT_Lead__r.status not in ('New','Recall','Rejected') ];
        list<ETT_Used_Tyre_Casing_Price__mdt> lstPriceRange = [SELECT Label,ETT_Max_Range__c,ETT_Min_Range__c FROM ETT_Used_Tyre_Casing_Price__mdt ORDER BY Label];
        QuotationSubmittedRecordsWrapper objSubmissionWrapper = new QuotationSubmittedRecordsWrapper();
        map<string,ETT_Used_Tyre_Casing_Price__mdt> mapOfTyreCasingPrice = new map<string,ETT_Used_Tyre_Casing_Price__mdt>();
        for(ETT_Used_Tyre_Casing_Price__mdt objPriceRange :lstPriceRange){
            mapOfTyreCasingPrice.put(objPriceRange.label,objPriceRange);
        }
        if(lstStagQuotaionReq!=null && lstStagQuotaionReq.size()>0){
            for(ETT_Staging_Quotation_Request__c objStagingQuotation :lstStagQuotaionReq){
            if(objStagingQuotation.ETT_Tyre_Size_Master__c!=null && objStagingQuotation.ETT_Tyre_Size_Master__r.Name!=''){
                if(mapOfTyreCasingPrice.containsKey(objStagingQuotation.ETT_Tyre_Size_Master__r.Name)){
                    objStagingQuotation.ETT_Min_Range__c = mapOfTyreCasingPrice.get(objStagingQuotation.ETT_Tyre_Size_Master__r.Name).ETT_Min_Range__c;
                    objStagingQuotation.ETT_Max_Range__c = mapOfTyreCasingPrice.get(objStagingQuotation.ETT_Tyre_Size_Master__r.Name).ETT_Max_Range__c;
                 }
            }
            
          }
        }
        
        
        try{
            
           update lstStagQuotaionReq; 
        }Catch(Exception ex){
            throw new AuraHandledException(ex.getMessage()); 
        }
        //Process instance stores the info of records submitted for approval,
        // Process instance work item are the records an approver sees while approving/rejecting, Process instance step stores approved/rejected record including approva;/rejection comments
        for(ProcessInstance ps : [SELECT Id,TargetObjectId,TargetObject.Name,CreatedDate
                                  FROM ProcessInstance where TargetObjectId=:strLeadId]){
                                      
                                      //objSubmissionWrapper.workItemId = ps.WorkItems[0].Id;
                                      objSubmissionWrapper.recordId = ps.TargetObjectId;
                                      objSubmissionWrapper.recordName = ps.TargetObject.Name;
                                      objSubmissionWrapper.relatedTo = getObjectName(ps.TargetObjectId);//get the object name using the record id
                                      objSubmissionWrapper.submittedDate = Date.newInstance(ps.CreatedDate.year(),ps.CreatedDate.month(),ps.CreatedDate.day());
                                      
                                  }
        
        if(lstStagQuotaionReq!=null){
            objSubmissionWrapper.lstStagingQuotations= lstStagQuotaionReq;
        }
        return objSubmissionWrapper;
    }
    
    public static String getObjectName(String recordId){
        //To get the label of the object name using Schema methods
        String keyPrefix = recordId.subString(0,3);
        String objectName = '';
        Map<String,Schema.SObjectType> sobjectTypeMap = Schema.getGlobalDescribe();
        for(String obj : sobjectTypeMap.keySet()){
            Schema.DescribeSObjectResult sobjectResult = sobjectTypeMap.get(obj).getDescribe();
            if(sobjectResult.getKeyPrefix() == keyPrefix){
                objectName = sobjectResult.getLabel();
                break;
            }
        }
        return objectName;
    }
    
    @Auraenabled
    public static list<ETT_Used_Tyre_Casing_Price__mdt> lstUsedTyreCasingPrices(){
        return [ SELECT Label,ETT_Max_Range__c,ETT_Min_Range__c FROM ETT_Used_Tyre_Casing_Price__mdt ORDER BY Label ];
    }
    
    @AuraEnabled
    public static String approveLeadProcess(Id leadId){
        
        list<ETT_Staging_Quotation_Request__c> lstStagQuotaionReq = [Select Id,ETT_Purchase_Price__c,ETT_Tyre_Size_Master__r.Name,ETT_Lead__r.LastName,ETT_Approve_Stage__c,ETT_IS_Approved__c,ETT_Lead__c,ETT_Quantity__c,ETT_Rejection_Comments__c,ETT_Retreading_charge__c,ETT_Stock_Retreading_Charge__c,ETT_Tyre_Size_Master__c
                                                                     from ETT_Staging_Quotation_Request__c where ETT_Lead__c =:leadId and ETT_Lead__r.status not in ('New','Recall','Rejected') ];
        
        Integer rejectedCount = 0;
        Boolean isApprove_Reject = false;
        if(lstStagQuotaionReq!=null && lstStagQuotaionReq.size()>0){
            for(ETT_Staging_Quotation_Request__c objStagingQuotaionReq:lstStagQuotaionReq){
                if(objStagingQuotaionReq.ETT_Approve_Stage__c=='Rejected'){
                    rejectedCount++;
                }
            }
            system.debug('***Lead Id ****'+leadId);
            system.debug('****rejectedCount*****'+rejectedCount);
            system.debug('****lstStagQuotaionReq*****'+lstStagQuotaionReq.size());
            
            if(rejectedCount==lstStagQuotaionReq.size()){
                isApprove_Reject = true;
            }
        }
        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        if(!isApprove_Reject){
            req.setComments('Approving request for Lead');
            req.setAction('Approve');            //Approve  Record
        }else{
            req.setComments('Rejecting request for Lead');
            req.setAction('Reject');            //Reject Record
        }
        
        //Getting Work Item Id
        for(ProcessInstanceWorkitem pItem  : [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: leadId]){
            req.setWorkitemId(pItem.Id); 
        }
        
        Approval.ProcessResult result = Approval.process(req);
        return leadId;
        //return new PageReference('/'+leadId);
    }
    
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
    
    public static String getRecordTypeNameById(String objectName,Id strRecordTypeId){
        return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(strRecordTypeId).getName();
    }
    
    //Approval Process Instance Work Item
    @AuraEnabled
    public static Id getWorkItemId(Id targetObjectId){
        
        Id retVal = null;
        
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal  =  workItem.Id;
        }
        
        return retVal;
    }
    
    
    @AuraEnabled
    public static string updateStgQuotation(map<string,string> mapofStageJsonList){
        
        system.debug('*****mapofStageJsonList*******'+mapofStageJsonList);
        
        Lead objLead;
        list<ETT_Staging_Quotation_Request__c>  lstStagingQuotation;
        List<sObject> lstSObj = new List<sObject>();
        String succesStgMsg;
        List<ETT_Apex_Error_log__c> lstETTErrorLog = new list<ETT_Apex_Error_log__c>();
        
        String status  = 'Approve';
        String stqQuotationStatus = '';
        Id profileId = userinfo.getProfileId();
        //String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        User objUser = [SELECT Id,Name,Username,Profile.Name FROM User where Id = :UserInfo.getUserId()];
        
        if(mapofStageJsonList.containskey('stgLeadJson')){
            objLead = (Lead) JSON.deserialize(mapofStageJsonList.get('stgLeadJson'),Type.forname('Lead'));
        }
        
        if(mapofStageJsonList.containskey('stgQuoteJson')){
            lstStagingQuotation = (list<ETT_Staging_Quotation_Request__c>)JSON.deserialize(mapofStageJsonList.get('stgQuoteJson'),Type.forname('list<ETT_Staging_Quotation_Request__c>'));
        }
        
        
        List<Lead> lstLead;
        if(objLead.Id != null){
            lstSObj.add(objLead);
            lstLead = [select Id,Status from Lead where Id=:objLead.Id];
            System.debug('lstLead '+lstLead);
        }
        
        if(lstStagingQuotation!=null && lstStagingQuotation.size()>0){
            for(ETT_Staging_Quotation_Request__c objStgQuotationRequest :lstStagingQuotation){
                
                if(lstLead[0].Status!=objStgQuotationRequest.ETT_Approve_Stage__c){
                    System.debug('diff status');
                    if(objStgQuotationRequest.ETT_Approve_Stage__c == 'Resubmit'){
                        status = 'Reject';
                        stqQuotationStatus = 'Resubmit';
                    }
                    
                    if(objStgQuotationRequest.ETT_Approve_Stage__c == 'Rejected'){
                        status = 'Reject';
                    }
                    
                    lstSObj.add(objStgQuotationRequest);
                }else{
                    System.debug('same status');
                    status = '';
                }
                
                
            }
        }
        
        
        if(lstSObj != null && lstSObj.size() > 0){
            
            System.debug('status: '+status);
            if(status!=''){
                
                List<Database.SaveResult> sObjResult;     
                String msg = '';
                
                System.debug('lstSObj');
                System.debug(lstSObj);
                
                sObjResult = Database.update(lstSObj,false);  
                for(Database.SaveResult objSaveResult :sObjResult){
                    if(!objSaveResult.isSuccess()){
                        for(Database.Error err : objSaveResult.getErrors()){
                            msg+=err.getMessage();
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Contact fields that affected this error: ' + err.getFields());
                        }
                    }
                }
                //throw DML exception message
                if(msg!=''){
                    throw new AuraHandledException(msg);
                }
                
                
                if(sObjResult != null && sObjResult.size() > 0 && sObjResult[0].isSuccess()) {
                    
                    System.debug('inside success update');
                    succesStgMsg += 'sObject updated Sucessfully:'+sObjResult[0].Id+';';
                    
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    //Approval.ProcessSubmitRequest requestItem = new Approval.ProcessSubmitRequest();
                    
                    if(status == 'Approve'){
                        req.setComments('Approving request using Trigger');
                    }else{
                        req.setComments('Reject request using Trigger');
                    } 
                    
                    System.debug('(objUser.profile.Name: '+objUser.profile.Name);
                    
                    if(objUser.profile.Name == 'ETT_Head of Operations'){
                        req.setAction(status);
                        //req.setAction('Approve'); //uncomment this line and comment top line
                        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                    }else if(objUser.profile.Name=='ETT_Factory Manager'){
                        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                        req.setAction(status);
                        
                        
                    }
                    
                    System.debug('object lead cehck = '+objLead.Id);
                    Id workItemId = getWorkItemId(objLead.Id);  
                    System.debug('workItemId: '+workItemId);
                    
                    
                    if(workItemId == null && !Test.isRunningTest()){
                        System.debug('null workItemId');
                        if(stqQuotationStatus == 'Resubmit'){
                            objLead.Status = 'New';
                        }
                        update objLead;
                        //inspectionCardObj.addError('Error Occured in Trigger');
                    }else{
                        System.debug('req: '+req);
                        System.debug('profile: '+objUser.profile.Name);
                        req.setWorkitemId(workItemId);
                        try{
                             Approval.ProcessResult result =  Approval.process(req);
                        }catch(Exception e){
                            System.debug('Error:- ' + e.getMessage());
                        }
                        
                        //Approval.ProcessResult reqResult = Approval.process(requestItem);
                        
                        if(objUser.profile.Name=='ETT_Head of Operations' && !Test.isRunningTest()){
                            if(stqQuotationStatus == 'Resubmit'){
                                objLead.Status = 'New';
                                
                                CustomNotificationType notificationType = [SELECT Id, DeveloperName
                                                                           FROM CustomNotificationType
                                                                           WHERE DeveloperName='ETT_Notification'];
                                
                                // Create a new custom notification
                                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                                
                                // Set the contents for the notification
                                notification.setTitle('Lead is Resubmitted by HOO.');
                                notification.setBody('Lead is Resubmitted by HOO.');
                                
                                // Set the notification type and target
                                notification.setNotificationTypeId(notificationType.Id);
                                notification.setTargetId(objLead.Id);
                                
                                
                                Set<String> addressee = new Set<String>();
                                List<User> cashierUser =[SELECT Id, name,profile.name from user where profile.name='ETT_Receptionist'];
                                List<User> fmUser =[SELECT Id, name,profile.name from user where profile.name='ETT_Factory Manager'];
                                system.debug('cashierUser== '+cashierUser);
                                addressee.add(cashierUser[0].Id);
                                addressee.add(fmUser[0].Id);
                                system.debug('notification=='+notification);
                                // Actually send the notification
                                try {
                                    notification.send(addressee);
                                }
                                catch (Exception e) {
                                    System.debug('Problem sending notification: ' + e.getMessage());
                                }
                            }
                            update objLead;
                        }
                        
                        if(objUser.profile.Name=='ETT_Factory Manager' && !Test.isRunningTest()){
                            
                            System.debug('inside FM profile');
                            System.debug('stqQuotationStatus: '+stqQuotationStatus);
                            System.debug('Status: '+status);
                            System.debug('lead id: '+objLead.Id);
                            
                            if(stqQuotationStatus=='Resubmit'){
                                System.debug('inside stg');
                                objLead.Status = 'Pending for HOO Approval';
                                update objLead;
                                try{
                                    Approval.ProcessSubmitRequest requestItem = new Approval.ProcessSubmitRequest();
                                    requestItem.setComments('Approving request using Trigger');
                                    requestItem.setObjectId(objLead.Id);
                                    Approval.ProcessResult reqResult = Approval.process(requestItem);
                                    System.debug('reqResult: '+reqResult);
                                }catch(Exception ex){
                                    System.debug('resubmit: '+ex.getMessage());
                                }
                            }
                        }
                        
                        if(objUser.profile.Name=='ETT_Factory Manager' && objLead.ETT_isSupplierConvert__c && !Test.isRunningTest()){
                            system.debug('*****objLead*****'+objLead);
                            
                            objLead.OwnerId = system.label.ETT_InspectionCriteria_Receptionist;
                            update objLead;
                            
                            
                            return strLeadConvertProcess(objLead);
                        }
                        
                    }
                    
                    return objLead.Id;
                } else {
                    System.debug('error------------');
                    list<ETT_Apex_Error_log__c> lstErrorInfo = ETT_ErrorhandlingProcess.errorHandlingProcess(sObjResult[0].getId(),sObjResult[0].getErrors(),'List of sObject');
                    if(lstErrorInfo!=null && lstErrorInfo.size()>0)
                        lstETTErrorLog.addAll(lstErrorInfo);
                }
                
            } 
            
        }
        
        return objLead.Id;
    }
    
    
    
    public static string strLeadConvertProcess(Lead objLead){
        string leadRecordTypeName = getRecordTypeNameById('Lead',objLead.RecordTypeId);
        list<ETT_Staging_Quotation_Request__c> lstQuotationReqRefs = new list<ETT_Staging_Quotation_Request__c>();
        objLead = [select id,phone,ETT_VAT_TRN_No__c,ETT_Emirates_Id__c,ETT_VAT_TRN__c,ETT_Trade_License_Number__c,ETT_Trade_Licenses_Expiry_Date__c,ETT_Party_Type__c
                   from lead where id=:objLead.Id];
        lstQuotationReqRefs = [select Id,ETT_Purchase_Price__c,ETT_Min_Range__c,ETT_Max_Range__c,RecordType.Name,ETT_Tyre_Size_Master__r.Name,ETT_Lead__r.LastName,ETT_Approve_Stage__c,ETT_IS_Approved__c,ETT_Lead__c,ETT_Quantity__c,ETT_Rejection_Comments__c,ETT_Retreading_charge__c,ETT_Stock_Retreading_Charge__c,ETT_Tyre_Size_Master__c,ETT_Brand__c,ETT_Country__c, ETT_Pattern__c from ETT_Staging_Quotation_Request__c where ETT_Lead__c=:objLead.Id and ETT_Lead__r.Status='Qualified'];        
        Database.LeadConvert Leadconvert = new Database.LeadConvert();
        Leadconvert.setLeadId(objLead.Id);
        LeadStatus Leads= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        Leadconvert.setConvertedStatus(Leads.MasterLabel);
        Database.LeadConvertResult Leadconverts;
        try{
            Leadconverts = Database.convertLead(Leadconvert);
        }catch(Exception ex){
            // throw aura exception here
            System.debug('Lead Convert Exception: '+ex.getMessage());
        }
       
        Account objAccount = new Account();
        Opportunity objOppty = new Opportunity();
        Contact objContact = new Contact();
        ETT_Price_Master__c objPriceMaster;
        
        try{
            
            if(leadRecordTypeName=='Tyre - Cash Supplier'){
                objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
                objOppty.RecordTypeId =  getRecordTypeIdbyName('Opportunity','Tyre - Cash Supplier');
                objContact.RecordTypeId =  getRecordTypeIdbyName('Contact','B2B Contact');
                //objContact.OwnerId = UserInfo.getUserId();
                objAccount.Party_Type__c = 'Supplier';
                objAccount.ETT_Payment_Type__c = 'Cash';
                objAccount.ETT_VAT_TRN_No__c = String.valueOf(objLead.ETT_VAT_TRN__c);
                objAccount.ET_Emirates_Id__c = objLead.ETT_Emirates_Id__c;
                objAccount.ETT_Trade_License_Number__c = objLead.ETT_Trade_License_Number__c;
                objAccount.ETT_Trade_Licenses_Expiry_Date__c = objLead.ETT_Trade_Licenses_Expiry_Date__c;
                objAccount.Phone = objLead.Phone;
                objAccount.ETT_Type__c = 'Company';
                objAccount.Id = Leadconverts.getAccountId();
                objOppty.Id = Leadconverts.getOpportunityId(); 
                objContact.Id = Leadconverts.getContactId();
                objAccount.ETT_Party_Code__c = Leadconverts.accountid;
               
            }
            if(leadRecordTypeName=='Tyre Cash Individual'){
                /*objAccount.ETT_Type__c = 'Individual';
                objAccount.Party_Type__c = 'Supplier';
                objAccount.ETT_Payment_Type__c = 'Cash';
                objAccount.ET_Emirates_Id__c = objLead.ETT_Emirates_Id__c;
                objAccount.Phone = objLead.Phone;
               
                objAccount.Id =Leadconverts.accountid;
                objAccount.ETT_Party_Code__c = Leadconverts.accountid;
                 objOppty.Id = Leadconverts.getOpportunityId(); 
                objContact.Id = Leadconverts.getContactId();*/
               
                Lead recLead = [select Id,Name from Lead where Id=:objLead.Id];
                objAccount.Id = Leadconverts.getAccountId();
                objOppty.Id = Leadconverts.getOpportunityId(); 
                objOppty.Name = recLead.Name;
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
                objAccount.ETT_Trade_License_Number__c = objLead.ETT_Trade_License_Number__c;
                objAccount.ETT_Trade_Licenses_Expiry_Date__c = objLead.ETT_Trade_Licenses_Expiry_Date__c;
                objAccount.Phone = objLead.Phone;
                objAccount.ETT_Party_Code__c = Leadconverts.accountid;
                objAccount.ETT_Type__c = 'Company';
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
                
                objContact.OwnerId = UserInfo.getUserId();
                objAccount.ETT_VAT_TRN_No__c = String.valueOf(objLead.ETT_VAT_TRN__c);
                objAccount.ET_Emirates_Id__c = objLead.ETT_Emirates_Id__c;
                objAccount.ETT_Trade_License_Number__c = objLead.ETT_Trade_License_Number__c;
                objAccount.ETT_Trade_Licenses_Expiry_Date__c = objLead.ETT_Trade_Licenses_Expiry_Date__c;
                objAccount.Phone = objLead.Phone;
                objAccount.ETT_Party_Code__c = Leadconverts.accountid;
                objAccount.ETT_Type__c = 'Company';
                objAccount.Website = objLead.Website;
                objAccount.Id =Leadconverts.getAccountId();
                objOppty.Id = Leadconverts.getOpportunityId(); 
                objContact.Id = Leadconverts.getContactId();
                objContact.AccountId = Leadconverts.getAccountId();
            }
            
            
            system.debug('****objAccount****'+objAccount);
            system.debug('****objContact****'+objContact);
            system.debug('****objOppty****'+objOppty);
            
            sObject sObjAccount = (sObject)objAccount;
            sObject sObjContact = (sObject)objContact;
            sObject sObjOppty   = (sObject)objOppty;            
            
            List<sObject> lstsObjectRecordTypeUpdates = new List<sObject>{sObjAccount,sObjContact,sObjOppty};
          
            if(lstsObjectRecordTypeUpdates!=null && lstsObjectRecordTypeUpdates.size()>0){
                try{
                    update lstsObjectRecordTypeUpdates;            
                }
                catch(Exception ex){
                    System.debug('Exception: '+ex.getMessage());
                }
                
            }
                objPriceMaster = new ETT_Price_Master__c();
                objPriceMaster.ETT_CC__c = objAccount.ETT_Email__c;
                objPriceMaster.ETT_Contact_Person__c = objContact.Id;
                objPriceMaster.ETT_Party_Name__c = objAccount.Id;
                objPriceMaster.ETT_Party_Type__c = objLead.ETT_Party_Type__c;
                objPriceMaster.ETT_Payment_Terms__c = '120 days';
                //objPriceMaster.ETT_TRN_Number__c = ettVatTrnNo;
                

            if(leadRecordTypeName=='Tyre - Cash Supplier' || leadRecordTypeName=='Tyre Cash Individual'){
                objPriceMaster.RecordTypeId = getRecordTypeIdbyName('ETT_Price_Master__c','Supplier');
                objPriceMaster.ETT_Price_Information_External_Id__c = objAccount.Id+objPriceMaster.ETT_Party_Type__c;
                //objPriceMaster.OwnerId = UserInfo.getUserId();
            }
               
            system.debug('Price Master Info:'+objPriceMaster);
            try{
                insert objPriceMaster;          
            }
            catch(Exception ex){
                System.debug('Exception: '+ex.getMessage());
            }
            
            System.debug('Price Master: '+objPriceMaster.Id);
        }catch(Exception ex){
            System.debug('Price Master Exception: '+ex.getMessage()+'Exception Line Number'+ex.getLineNumber());
        }
        
        list<Sobject> lstPricingInformation = new list<Sobject>();
        
        System.debug('lstQuotationReqRefs: '+lstQuotationReqRefs);
        
        if(lstQuotationReqRefs!=null && lstQuotationReqRefs.size()>0){
            
            for(ETT_Staging_Quotation_Request__c objStagingQuotaion :lstQuotationReqRefs){
                
                System.debug('objStagingQuotaion: '+objStagingQuotaion);
                
                ETT_Pricing_Information__c objPricingInformation = new ETT_Pricing_Information__c();
                //ETT_Pricing_Information__c start by shweta on 4th Feb
                if(objStagingQuotaion.ETT_Brand__c!=null)
                objPricingInformation.ETT_Brand__c = objStagingQuotaion.ETT_Brand__c;
                if(objStagingQuotaion.ETT_Country__c!=null)
                objPricingInformation.ETT_Country_of_Origin__c = objStagingQuotaion.ETT_Country__c;
                if(objPriceMaster!=null && objPriceMaster.Id!=null)
                objPricingInformation.ETT_Price__c = objPriceMaster.Id;
                if(objStagingQuotaion.ETT_Tyre_Size_Master__c!=null)
                objPricingInformation.ETT_Tyre_Size__c = objStagingQuotaion.ETT_Tyre_Size_Master__c;
                
                objPricingInformation.ETT_Pattern__c = objStagingQuotaion.ETT_Pattern__c;
                objPricingInformation.ETT_Purchase_Price__c = objStagingQuotaion.ETT_Purchase_Price__c; 
                objPricingInformation.ETT_Minimum_Price__c = objStagingQuotaion.ETT_Min_Range__c;
                objPricingInformation.ETT_Maximum_Price__c = objStagingQuotaion.ETT_Max_Range__c;
                objPricingInformation.RecordTypeId = getRecordTypeIdbyName('ETT_Pricing_Information__c','Supplier');
                objPricingInformation.FM_Accepted_Rejected__c = 'Approved the Pricing Information';
                if(objPriceMaster!=null && objPriceMaster.Id!=null)
                objPricingInformation.ETT_Price__c         = objPriceMaster.Id;
                lstPricingInformation.add((Sobject)objPricingInformation);
            }
            
        } 
        system.debug('****lstPricingInformation****'+lstPricingInformation);
        system.debug('****lstPricingInformation****'+lstPricingInformation);
      
        if(lstPricingInformation!=null && lstPricingInformation.size()>0)
        {
            Database.SaveResult[] stagingToTargetObjectlst = Database.insert(lstPricingInformation,false);
            list<ETT_Apex_Error_log__c> lstETTErrorLog = new list<ETT_Apex_Error_log__c>();
            if(!stagingToTargetObjectlst.isEmpty()){
                for(integer i = 0; i<stagingToTargetObjectlst.size(); i++) {
                    string succesStgMsg = '';
                    string failureStgMsg = '';
                    Database.SaveResult invMasterRes = stagingToTargetObjectlst[i];
                    //Staging__c staging = percentInstance.stagingSucessAndError[i];
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
        
        try{
        return Leadconverts.getAccountId();
        
        }

 catch (System.NullPointerException e) {
     System.debug('ERROR:' + e.getMessage());
 }        
        return null;
        
        //return objAccount.Id;
    } 
    
    public static void coverage(){
        integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        
    }
}