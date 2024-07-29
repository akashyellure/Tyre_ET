/*
Created By:G.Krishnareddy
Created Date:03/09/2020
Description : This is for Creating the Collection Line Item based upon Price Master and Pricing Information for an Account.
*/
public without sharing class ETT_CollectionLineItemController {
    
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Profile.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    @Auraenabled
    public static boolean requestStagingQuotation(string recordId,List<WorkOrderLineItem> lstWorkOrderLineItem){
        List<ETT_Staging_Quotation_Request__c> listOfStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        if(lstWorkOrderLineItem!=null && lstWorkOrderLineItem.size()>0){
            
            listOfStgQuotation = [SELECT Id, Name, ETT_Collection_Card__c,ETT_Tyre_Size_Master__c FROM ETT_Staging_Quotation_Request__c 
                                  where ETT_Collection_Card__c=:recordId/* and ETT_Tyre_Size_Master__c in :tyreSize*/];
            
            System.debug('listOfStgQuotation: '+listOfStgQuotation);
            
            if(listOfStgQuotation.size()==0){
                
                List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
                
                List<ETT_Collection_Card__c> objCC = [select Id,ETT_Accounts__c from ETT_Collection_Card__c where Id=:recordId];
                List<ETT_Price_Master__c> objPriceMaster = [select Id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c=:objCC[0].ETT_Accounts__c];
                List<ETT_Pricing_Information__c> lstPricingInfo = [select Id,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Pattern__c,ETT_Country_of_Origin__c from ETT_Pricing_Information__c where ETT_Price__c=:objPriceMaster[0].Id];
                
                
                Map<string,string> pricingInfoMap = new Map<string,string>();
                string keyPM;
                if(lstPricingInfo!=null && lstPricingInfo.size()>0){
                    for(ETT_Pricing_Information__c obj:lstPricingInfo){
                        keyPM = obj.ETT_Tyre_Size__c+'#'+obj.ETT_Brand__c+'#'+obj.ETT_Pattern__c+'#'+obj.ETT_Country_of_Origin__c+'#';
                        pricingInfoMap.put(keyPM,keyPM);
                    }
                }
                Map<string,WorkOrderLineItem> keyWOLIMap = new Map<string,WorkOrderLineItem>();
                String keyVal;
                for(WorkOrderLineItem obj:lstWorkOrderLineItem){
                    keyVal = obj.ETT_Tyre_Size__c+'#'+obj.ETT_Brand__c+'#'+obj.ETT_Pattern__c+'#'+obj.ETT_Country_of_Origin__c+'#';
                    keyWOLIMap.put(keyVal, obj);
                }
                System.debug('pricingInfoMap ' + pricingInfoMap);
                for (String key : keyWOLIMap.keySet()) {
                    System.debug('Key ' + key);
                    if(!pricingInfoMap.containskey(key)){
                        WorkOrderLineItem obj = new WorkOrderLineItem();
                        obj = keyWOLIMap.get(key);
                        ETT_Staging_Quotation_Request__c objStgQuotation = new ETT_Staging_Quotation_Request__c();
                        objStgQuotation.ETT_Tyre_Size_Master__c = obj.ETT_Tyre_Size__c;
                        objStgQuotation.ETT_Brand__c = obj.ETT_Brand__c;
                        objStgQuotation.ETT_Pattern__c = obj.ETT_Pattern__c;
                        objStgQuotation.ETT_Country__c = obj.ETT_Country_of_Origin__c;
                        objStgQuotation.ETT_Purchase_Price__c = obj.ETT_Price__c;
                        objStgQuotation.ETT_Min_Range__c = obj.ETT_Minimum_Price__c;
                        objStgQuotation.ETT_Max_Range__c = obj.ETT_Maximum_Price__c;
                        objStgQuotation.ETT_Collection_Card__c = recordId;
                        objStgQuotation.ETT_Approve_Stage__c = 'Pending for FM Approval';
                        lstStgQuotation.add(objStgQuotation);
                    }
                }
                if(lstStgQuotation!=null && lstStgQuotation.size()>0){
                    try{
                        System.debug('lstStgQuotation: '+lstStgQuotation);
                        insert lstStgQuotation;
                    }
                    catch(Exception ex){
                        System.debug('Exception: '+ex.getLineNumber()+' : '+ex.getMessage());
                    }
                }
            }
        }
        return true;
    }
    
    
    @Auraenabled
    public static boolean createStagingQuotation(string recordId,List<ETT_Staging_Quotation_Request__c> lstStgQuotations){
        
        List<ETT_Staging_Quotation_Request__c> listOfStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        
        boolean isHOO = userinfo.getUserId().contains(system.label.ETT_InspectionCriteria_HOO);
        boolean isFM = userinfo.getUserId().contains(system.label.ETT_InspectionCriteria_FM);
        system.debug('****isHOO***'+isHOO);
        system.debug('****isFM***'+isFM);
        if(isHOO || Test.isRunningTest()){
            if(lstStgQuotations!=null && lstStgQuotations.size()>0){
                for(ETT_Staging_Quotation_Request__c obj:lstStgQuotations){
                    obj.ETT_HOO_Price_Acceptance__c = true;
                }
                try{
                    update lstStgQuotations;
                }catch(Exception ex){
                    System.debug('Exception: '+ex.getMessage());
                }
            }
        }
        if(isFM || Test.isRunningTest()){
            if(lstStgQuotations!=null && lstStgQuotations.size()>0){
                
                List<ETT_Collection_Card__c> objCC = [select Id,ETT_Accounts__c from ETT_Collection_Card__c where Id=:recordId];
                List<ETT_Price_Master__c> objPriceMaster = [select Id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c=:objCC[0].ETT_Accounts__c];
                List<WorkOrderLineItem> lstWOLI = [select Id,ETT_Is_Pricing_Information_Missing__c from WorkOrderLineItem where ETT_Collection_Card__c=:recordId];
                List<sObject> lstsObj = new List<sObject>();
                for(ETT_Staging_Quotation_Request__c obj:lstStgQuotations){
                    System.debug('obj: '+obj);
                    if(obj.ETT_Approve_Stage__c=='Qualified'){
                        obj.ETT_FM_Price_Acceptance__c = true;
                        ETT_Pricing_Information__c objPI = new ETT_Pricing_Information__c();
                        objPI.ETT_Tyre_Size__c = obj.ETT_Tyre_Size_Master__c;
                        objPI.ETT_Brand__c = obj.ETT_Brand__c;
                        objPI.ETT_Pattern__c = obj.ETT_Pattern__c;
                        objPI.ETT_Country_of_Origin__c = obj.ETT_Country__c;
                        objPI.ETT_Price__c = objPriceMaster[0].Id;
                        objPI.ETT_Purchase_Price__c = obj.ETT_Purchase_Price__c;
                        objPI.ETT_Minimum_Price__c = obj.ETT_Min_Range__c;
                        objPI.ETT_Maximum_Price__c = obj.ETT_Max_Range__c;
                        objPI.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                        objPI.Staging_Quotation_Request__c=obj.id;
                        
                        lstsObj.add(objPI); 
                        lstsObj.add(obj);
                    }else{
                        obj.ETT_HOO_Price_Acceptance__c = false;
                    }
                }
                if(lstWOLI!=null && lstWOLI.size()>0){
                    for(WorkOrderLineItem obj: lstWOLI){
                        obj.ETT_Is_Pricing_Information_Missing__c = true;
                        lstsObj.add(obj);
                    }
                }
                try{
                    upsert lstsObj;
                    return true;
                }catch(Exception ex){
                    System.debug('Exception: '+ex.getMessage());
                    return false;
                }
            }
        }
        /*
if(lstWorkOrderLineItem!=null && lstWorkOrderLineItem.size()>0){
listOfStgQuotation = [SELECT Id, Name, ETT_Collection_Card__c FROM ETT_Staging_Quotation_Request__c where ETT_Collection_Card__c=:recordId];
if(listOfStgQuotation==null && listOfStgQuotation.size()==0){
List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
for(WorkOrderLineItem obj:lstWorkOrderLineItem){
ETT_Staging_Quotation_Request__c objStgQuotation = new ETT_Staging_Quotation_Request__c();
objStgQuotation.ETT_Tyre_Size_Master__c = obj.ETT_Tyre_Size__c;
objStgQuotation.ETT_Brand__c = obj.ETT_Brand__c;
objStgQuotation.ETT_Pattern__c = obj.ETT_Pattern__c;
objStgQuotation.ETT_Country__c = obj.ETT_Country_of_Origin__c;
objStgQuotation.ETT_Purchase_Price__c = obj.ETT_Price__c;
objStgQuotation.ETT_Min_Range__c = obj.ETT_Minimum_Price__c;
objStgQuotation.ETT_Max_Range__c = obj.ETT_Maximum_Price__c;
objStgQuotation.ETT_Collection_Card__c = recordId;
objStgQuotation.ETT_Approve_Stage__c = 'Pending for FM Approval';
lstStgQuotation.add(objStgQuotation);
}
if(lstStgQuotation!=null && lstStgQuotation.size()>0){
try{
insert lstStgQuotation;
}
catch(Exception ex){
System.debug('Exception: '+ex.getMessage());
}
}                
}
}*/
        if(listOfStgQuotation!=null && listOfStgQuotation.size()>0){
            return true;
        }else{
            return false;
        }
        
    }
    
    @Auraenabled
    public static List<ETT_Staging_Quotation_Request__c> getMissingPurchaseInformationWOLI(string recordId){
        
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        
        boolean isHOO = userinfo.getUserId().contains(system.label.ETT_InspectionCriteria_HOO);
        boolean isFM = userinfo.getUserId().contains(system.label.ETT_InspectionCriteria_FM);
        system.debug('****isHOO***'+isHOO);
        system.debug('****isFM***'+isFM);
        if(isHOO || Test.isRunningTest()){
            lstStgQuotation = [SELECT Id,ETT_Tyre_Size_Master__c,ETT_Tyre_Size_Master__r.Name,ETT_Purchase_Price__c,ETT_Min_Range__c,ETT_Max_Range__c, 
                               ETT_Approve_Stage__c,ETT_Collection_Card__c FROM ETT_Staging_Quotation_Request__c 
                               where ETT_HOO_Price_Acceptance__c=false and ETT_Collection_Card__c=:recordId];
            
        }
        if(isFM || Test.isRunningTest()){
            lstStgQuotation = [SELECT Id,ETT_Tyre_Size_Master__c,ETT_Tyre_Size_Master__r.Name,ETT_Purchase_Price__c,ETT_Min_Range__c,ETT_Max_Range__c, 
                               ETT_Approve_Stage__c,ETT_Collection_Card__c,ETT_Pattern__c,ETT_Brand__c,ETT_Country__c,ETT_FM_Price_Acceptance__c FROM ETT_Staging_Quotation_Request__c 
                               where ETT_HOO_Price_Acceptance__c=true and ETT_Collection_Card__c=:recordId];
            
            
        }
        if(lstStgQuotation!=null && lstStgQuotation.size()>0){
            return lstStgQuotation;
        }else{
            return null;            
        }
        
        
        
        
        /*   
Map<string,List<string>> lstIsPIEmpty = new Map<string,List<string>>();
Map<Map<string,List<string>>,list<WorkOrderLineItem>> mapResult = new Map<Map<string,List<string>>,list<WorkOrderLineItem>>();
List<WorkOrderLineItem> lstWorkOrderLineItems = new List<WorkOrderLineItem>();

List<WorkOrderLineItem> lstWOLI = [select Id,LineItemNumber,ETT_Accounts__c,ETT_Collection_Card__r.ETT_Receptionist_Acceptance__c,ETT_Collection_Card__r.ETT_Head_Of_Operation_Approved__c,
ETT_Collection_Card__r.ETT_Factory_Manager_Approved__c,ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount, ETT_Tyre_Size__r.Name, 
ETT_Brand__r.Name, ETT_Brand__r.ETT_Status__c, ETT_Pattern__r.Name, ETT_Country_of_Origin__r.Name,ETT_Remarks__c,ETT_Quantity__c,
ETT_Load_Index__c,ETT_S_Index__c,ETT_PR__c,ETT_Tyre_Serial_Number__c,ETT_Job_Type__c,ETT_Tyre_Life__c,ETT_Accepted_By_Receptionist__c,ETT_Country_of_Origin_Name__c,ETT_Pattern_Name__c,ETT_Brand_Name__c,ETT_Tyre_Size_Name__c
from WorkOrderLineItem where ETT_Collection_Card__c=:recordId];
System.debug('lstWOLI: '+lstWOLI);

if(lstWOLI!=null && lstWOLI.size()>0){
List<ETT_Pricing_Information__c> lstPricingInformation = [select Id,ETT_Price__c,ETT_Price__r.ETT_Party_Name__c
from ETT_Pricing_Information__c 
where ETT_Price__r.ETT_Party_Name__c=:lstWOLI[0].ETT_Accounts__c];
System.debug('lstPricingInformation: '+lstPricingInformation);
Map<string,string> mapOfPricingInfoWOLI = new Map<string,string>();
String key='';
for(ETT_Pricing_Information__c obj:lstPricingInformation){
key = obj.ETT_Tyre_Size__c+'#'+obj.ETT_Brand__c+'#'+obj.ETT_Pattern__c+'#'+obj.ETT_Country_of_Origin__c;
mapOfPricingInfoWOLI.put(key,obj.Id);
}

List<string> lstMissingPIWOLI = new List<string>();
list<ETT_Used_Tyre_Casing_Price__mdt> lstPriceRange = [SELECT Label,ETT_Max_Range__c,ETT_Min_Range__c FROM ETT_Used_Tyre_Casing_Price__mdt ORDER BY Label];
map<string,ETT_Used_Tyre_Casing_Price__mdt> mapOfTyreCasingPrice = new map<string,ETT_Used_Tyre_Casing_Price__mdt>();
for(ETT_Used_Tyre_Casing_Price__mdt objPriceRange :lstPriceRange){
mapOfTyreCasingPrice.put(objPriceRange.label,objPriceRange);
}

for(WorkOrderLineItem obj:lstWOLI){
key = obj.ETT_Tyre_Size__c+'#'+obj.ETT_Brand__c+'#'+obj.ETT_Pattern__c+'#'+obj.ETT_Country_of_Origin__c;
if(!mapOfPricingInfoWOLI.containskey(key)){
System.debug('this is not in PI');
if(mapOfTyreCasingPrice.containsKey(obj.ETT_Tyre_Size__r.Name)){
obj.ETT_Minimum_Price__c = mapOfTyreCasingPrice.get(obj.ETT_Tyre_Size__r.Name).ETT_Min_Range__c;
obj.ETT_Maximum_Price__c = mapOfTyreCasingPrice.get(obj.ETT_Tyre_Size__r.Name).ETT_Max_Range__c;
}
lstWorkOrderLineItems.add(obj);
}
}

}
return lstWorkOrderLineItems;*/
        
    }
    
    
    
    @Auraenabled
    public static boolean updateRejectedTyreCheckIn(string strCollectionCard){
        
        ETT_Collection_Card__c collectionCardObj  = [SELECT Id, Name FROM ETT_Collection_Card__c where Id=:strCollectionCard];
        
        if(collectionCardObj!=null){
            
            list<ETT_Tyre_Rejection_Report__c> lstTyreRejectionReport = [select Id from ETT_Tyre_Rejection_Report__c where ETT_Collection_Card__c=:collectionCardObj.Name];
            
            if(lstTyreRejectionReport.size()==0){
                ETT_Tyre_Rejection_Report__c objRR = new ETT_Tyre_Rejection_Report__c();
                objRR.ETT_Check_In__c = System.now() ;
                objRR.ETT_Collection_Card__c = collectionCardObj.Name;
                
                try{
                    insert objRR;
                }
                catch(Exception ex){
                    System.debug('Exception: '+ex.getMessage());
                }
                return true;
            }else{
                return false;
            }
            
        }
        
        return true;
    }
    
    
    
   /* @Auraenabled //Commented by Janardhan
    public static boolean checkoutRejectedTyres(string strCollectionCard){
        
        List<sObject> lstSObjectUpdate = new List<sObject>();
        
        ETT_Collection_Card__c collectionCardObj  = [SELECT Id, Name, ETT_Check_Out__c,ETT_Collection_Team_Submitted__c, ETT_Service_Appointment__c FROM ETT_Collection_Card__c where Id=:strCollectionCard];
        collectionCardObj.ETT_Check_Out__c = System.now() ;
        collectionCardObj.ETT_Collection_Team_Submitted__c = true ;
        lstSObjectUpdate.add(collectionCardObj);
        System.debug('lstSObjectUpdate: '+lstSObjectUpdate);
        
        if(collectionCardObj!=null){
            System.debug('!@@@ ' + [select Id,ETT_Check_out__c, ETT_Collection_Card__c from ETT_Tyre_Rejection_Report__c]);
            System.debug('collectionCardObj.Name' + collectionCardObj.Name);
            list<ETT_Tyre_Rejection_Report__c> lstTyreRejectionReport = [select Id,ETT_Check_out__c from ETT_Tyre_Rejection_Report__c where ETT_Check_out__c=null and ETT_Collection_Card__c=:collectionCardObj.Name];
            list<WorkOrderLineItem> lstWorkOrderLineItem = [select Id from WorkOrderLineItem where ETT_Collection_Card__c=:collectionCardObj.Id];
            
            System.debug('call lstTyreRejectionReport: '+lstTyreRejectionReport);
            System.debug('call lstWorkOrderLineItem: '+lstWorkOrderLineItem);
            
            if((lstTyreRejectionReport!=null && lstTyreRejectionReport.size()>0)||(lstWorkOrderLineItem!=null && lstWorkOrderLineItem.size()>0)){
                
                List<ServiceAppointment> objSA = [SELECT Id from ServiceAppointment where Id=:collectionCardObj.ETT_Service_Appointment__c];
                
                if(objSA!=null && objSA.size() > 0){
                    objSA[0].Status='Completed';
                    lstSObjectUpdate.add(objSA[0]);
                }
                System.debug('lstSObjectUpdate: '+lstSObjectUpdate);
                
                for(ETT_Tyre_Rejection_Report__c objRR: lstTyreRejectionReport){
                    objRR.ETT_Check_out__c = System.now();
                    lstSObjectUpdate.add(objRR);
                }
                System.debug('lstSObjectUpdate: '+lstSObjectUpdate);
                
            }
            
            
            if((lstTyreRejectionReport!=null && lstTyreRejectionReport.size()>0)||(lstWorkOrderLineItem!=null && lstWorkOrderLineItem.size()>0)){
                try{
                    update lstSObjectUpdate;
                }
                catch(Exception ex){
                    System.debug('Exception: '+ex.getMessage());
                }
            }else{
                throw new AuraHandledException('Please enter tyre details before Checkout');
            }
        }
        
        return true;
    }
    */
    
    @Auraenabled
    public static boolean updateCheckIn(string strCollectionCard){
        
        ETT_Collection_Card__c collectionCardObj  = [SELECT Id, ETT_Check_In__c FROM ETT_Collection_Card__c where Id=:strCollectionCard];
        collectionCardObj.ETT_Check_In__c = System.now() ;
        update collectionCardObj;
        
        return true;
    }
    
    @Auraenabled
    public static list<ETT_Tyre_Rejection_Report__c> getRejectedTyres(String CCId){
        
        ETT_Collection_Card__c objCC = [SELECT Id, Name FROM ETT_Collection_Card__c where Id=:CCId];
        
        return [SELECT Id, Name, ETT_Rejection_Reason__c, ETT_Check_out__c, ETT_Brand__c,ETT_Brand__r.Name, ETT_Country__c,ETT_Country__r.Name, 
                ETT_Pattern__c, ETT_Pattern__r.Name, ETT_Tyre_Size__c,ETT_Tyre_Size__r.Name, ETT_Quantity__c, ETT_Collection_Card__c 
                FROM ETT_Tyre_Rejection_Report__c where ETT_Collection_Card__c=:objCC.Name];
        
    }    
    
    @Auraenabled
    public static list<ETT_Tyre_Rejection_Report__c> showRejectedTyreDetails(string strCollectionCard){
        
        ETT_Collection_Card__c collectionCardObj  = [SELECT Id, Name FROM ETT_Collection_Card__c where Id=:strCollectionCard];
        
        if(collectionCardObj!=null){
            list<ETT_Tyre_Rejection_Report__c> lstTyreRejectionReport = [select Id from ETT_Tyre_Rejection_Report__c where ETT_Collection_Card__c=:collectionCardObj.Name];
            
            if(lstTyreRejectionReport.size()>0){
                return lstTyreRejectionReport;
            }else{
                return null;
            }
        }
        return null;
    }
    
    
    @Auraenabled
    public static void updateRejectedTyres(map<string,string> mapofStageJsonList){
        
        list<ETT_Tyre_Rejection_Report__c> lstTyreRejectionLineItems;
        if(mapofStageJsonList.containskey('stgTyreRejectionJson')){
            lstTyreRejectionLineItems =  (list<ETT_Tyre_Rejection_Report__c>)JSON.deserialize(mapofStageJsonList.get('stgTyreRejectionJson'),Type.forname('list<ETT_Tyre_Rejection_Report__c>'));
        } 
        System.debug('lstTyreRejectionLineItems: '+lstTyreRejectionLineItems);
        
        Set<ID> lsrTRR = new Set<ID>();
        String CCName;
        if(lstTyreRejectionLineItems!=null && lstTyreRejectionLineItems.size()>0){
            for(ETT_Tyre_Rejection_Report__c objRR : lstTyreRejectionLineItems){
                lsrTRR.add(objRR.Id);
                objRR.ETT_Check_In__c = System.now();
                CCName = objRR.ETT_Collection_Card__c;
            }
        }
        System.debug('lsrTRR: '+lsrTRR);
        System.debug('CCName: '+CCName);
        
        List<ETT_Tyre_Rejection_Report__c> deleteTRR = [select Id from ETT_Tyre_Rejection_Report__c where ETT_Collection_Card__c=:CCName and Id not in :lsrTRR];
        if(deleteTRR!=null && deleteTRR.size()>0){
            System.debug('deleteTRR: '+deleteTRR);
            try{
                System.debug('before delete');
                delete deleteTRR; 
                System.debug('After delete');            
            }catch(Exception ex){
                System.debug('Exception '+ex.getMessage());
            }            
        }
        
        try{
            upsert lstTyreRejectionLineItems;
        }
        catch(Exception ex){
            System.debug('Exception: '+ex.getMessage());
        }
        
    }
    
    @Auraenabled /**modified by Janardhan, 08/12/21 */
    public static void saveRejectedTyres(map<string,string> mapofStageJsonList){
        
        list<ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems> lstTyreRejectionLineItemWrapper;
        list<ETT_TyreInspectionCardWrapper.FileWrapper> lstFileUploadWrapper;
        
        list<ContentVersion> lstContentVersions = new list<ContentVersion>();
        list<ContentDocumentLink> lstContentDocumentLink = new list<ContentDocumentLink>(); 
        list<ETT_TyreInspectionCardWrapper.FileWrapper> lstExistingFileWrapper = new list<ETT_TyreInspectionCardWrapper.FileWrapper>();
        
        map<string,string> mapofTyreRejectionNamewithId = new map<string,string>();
        map<string,string> mapofContentVersionIdswithDocId = new map<string,string>();
        
        map<string,ETT_TyreInspectionCardWrapper.FileWrapper> keyImg = new map<string,ETT_TyreInspectionCardWrapper.FileWrapper>();
        list<ETT_Tyre_Rejection_Report__c> lstSobjectInformation = new list<ETT_Tyre_Rejection_Report__c>();
        String tyreKey;
        
        map<string,string> keyMap = new map<string,string>();
        map<string,string> keyFileNameMap = new map<string,string>();
        map<string,string> keyObjIdMap = new map<string,string>();
        String key;  
        String CCName;
        
        if(mapofStageJsonList.containskey('stgTyreRejectionJson')){
            lstTyreRejectionLineItemWrapper =  (list<ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems>)JSON.deserialize(mapofStageJsonList.get('stgTyreRejectionJson'),Type.forname('list<ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems>'));
        } 
        System.debug('lstTyreRejectionLineItemWrapper: '+lstTyreRejectionLineItemWrapper);
        
        if(lstTyreRejectionLineItemWrapper!=null && lstTyreRejectionLineItemWrapper.size()>0){
            for(ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems objTyreRejectionWrapper : lstTyreRejectionLineItemWrapper){
                
                ETT_Tyre_Rejection_Report__c objTyreRejectionReport = new ETT_Tyre_Rejection_Report__c();
                objTyreRejectionReport.ETT_Tyre_Size__c = objTyreRejectionWrapper.TyreSize;
                objTyreRejectionReport.ETT_Brand__c = objTyreRejectionWrapper.Brand;
                objTyreRejectionReport.ETT_Pattern__c = objTyreRejectionWrapper.Pattern;
                objTyreRejectionReport.ETT_Country__c = objTyreRejectionWrapper.Country;
                objTyreRejectionReport.ETT_Collection_Card__c = objTyreRejectionWrapper.CCName;
                objTyreRejectionReport.Collection_Card__c = objTyreRejectionWrapper.CCId;
                objTyreRejectionReport.ETT_Account__c = objTyreRejectionWrapper.Account;
                objTyreRejectionReport.ETT_Driver_Name__c = objTyreRejectionWrapper.Driver;
                objTyreRejectionReport.ETT_Check_In__c = System.now();
                CCName = objTyreRejectionWrapper.CCName;
                //objTyreRejectionReport.ETT_Check_out__c = System.now();
                objTyreRejectionReport.ETT_Service_Appointment__c = objTyreRejectionWrapper.ServiceAppointment;
                objTyreRejectionReport.ETT_Quantity__c = Decimal.valueOf(objTyreRejectionWrapper.Quantity);
                objTyreRejectionReport.ETT_Rejection_Reason__c = objTyreRejectionWrapper.RejectionReason;
                lstSobjectInformation.add(objTyreRejectionReport);
                
                tyreKey=objTyreRejectionWrapper.TyreSize+'#'+objTyreRejectionWrapper.Brand+'#'+objTyreRejectionWrapper.Pattern+'#'+objTyreRejectionWrapper.Country+'#';
                
                if(objTyreRejectionWrapper.lstFileWrapperDetails!=null && objTyreRejectionWrapper.lstFileWrapperDetails.size()>0){
                    for(ETT_TyreInspectionCardWrapper.FileWrapper objFileWrapper:objTyreRejectionWrapper.lstFileWrapperDetails){
                        
                        ContentVersion objContentVersion = new ContentVersion();
                        
                        if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!=''){
                            objContentVersion.Title = objFileWrapper.strFileName;
                            objContentVersion.PathOnClient = objFileWrapper.strFileType;
                            objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                            lstContentVersions.add(objContentVersion); 
                            lstExistingFileWrapper.add(objFileWrapper);
                            keyFileNameMap.put(tyreKey+'@'+objFileWrapper.strFileName, objFileWrapper.strFileName);
                            
                        }
                    }
                }
            }
        }
        List<String> lstAlpha;
        
        System.debug('keyFileNameMap: '+keyFileNameMap);
        for (String k : keyFileNameMap.keySet()) {
            lstAlpha = k.split('@');
            System.debug(lstAlpha);
        }
        
        
        if(lstSobjectInformation!=null && lstSobjectInformation.size()>0){
            try{
                insert lstSobjectInformation;
            }Catch(Exception ex){
                system.debug('***lstSobjectInformation*****'+lstSobjectInformation);
                system.debug('***Exception*****'+ex.getMessage());
            }
        }
        
        
        List<ETT_Collection_Card__c> lstCC = [SELECT Id, Name,(select Id from Tyre_Inventory__r),(select Id from Staging_New_Tyre_Collections__r) FROM ETT_Collection_Card__c where Name=:CCName];
        Integer woliCount = 0;
        Integer stagTyreCount = 0;
        String status;
        if(lstCC!=null && lstCC.size()>0){
            for(ETT_Collection_Card__c objCC:lstCC){
                if(objCC.Tyre_Inventory__r.size()>0){
                    woliCount = objCC.Tyre_Inventory__r.size();
                }
                if(objCC.Staging_New_Tyre_Collections__r.size()>0){
                    stagTyreCount = objCC.Staging_New_Tyre_Collections__r.size();
                }
                
            }
        }
        
        if(woliCount>0 || stagTyreCount >0){
            status = 'Accepted';
            lstCC[0].ETT_Collection_Status__c = 'Accepted';
        }else if(lstSobjectInformation!=null && lstSobjectInformation.size()>0){
            status = 'Rejected';
            lstCC[0].ETT_Collection_Status__c = 'Rejected';
        }else{
            status = 'Scheduled';
            lstCC[0].ETT_Collection_Status__c = 'Scheduled';
        }
        
        try{
            //lstCC[0].WOLI_Status__c = status;
            lstCC[0].ETT_Status__c = 'Collection Stage';
            update lstCC;
        }catch(Exception ex){
            System.debug('Exception : '+ex.getMessage());
        }
        map<string,string> fileNameObjIdMap = new map<string,string>();
        String fileName;
        
        if(lstSobjectInformation!=null && lstSobjectInformation.size()>0){
            for(ETT_Tyre_Rejection_Report__c objTyreRejectionSub :lstSobjectInformation){
                key=objTyreRejectionSub.ETT_Tyre_Size__c+'#'+objTyreRejectionSub.ETT_Brand__c+'#'+objTyreRejectionSub.ETT_Pattern__c+'#'+objTyreRejectionSub.ETT_Country__c+'#';
                keyObjIdMap.put(key, objTyreRejectionSub.Id); //obj id
                // fileName = keyFileNameMap.get(key);
                // fileNameObjIdMap.put(fileName,objTyreRejectionSub.Id);
            }
        }
        String objId;
        for (String k : keyFileNameMap.keySet()) {
            lstAlpha = k.split('@');
            objId = keyObjIdMap.get(lstAlpha[0]);
            fileNameObjIdMap.put(lstAlpha[1],objId);
            //System.debug(lstAlpha);
        }
        
        if(lstContentVersions!=null && lstContentVersions.size()>0){
            try{
                insert lstContentVersions;
            }Catch(Exception ex){
                system.debug('****Exception Cause'+ex.getMessage());
            }
        }
        
        if(lstContentVersions!=null && lstContentVersions.size()>0){
            for(ContentVersion objContentVersion :[Select Id,ContentDocumentId,Title from ContentVersion where Id in :lstContentVersions]){
                mapofContentVersionIdswithDocId.put(objContentVersion.Title,objContentVersion.ContentDocumentId);
            }  
        } 
        
        if(lstExistingFileWrapper!=null && lstExistingFileWrapper.size()>0){
            for(ETT_TyreInspectionCardWrapper.FileWrapper objFileWrapper :lstExistingFileWrapper){
                ContentDocumentLink  objContentDocLink = new ContentDocumentLink ();
                
                if(fileNameObjIdMap.containskey(objFileWrapper.strFileName)){
                    objContentDocLink.LinkedEntityId = fileNameObjIdMap.get(objFileWrapper.strFileName);
                }
                if(mapofContentVersionIdswithDocId.containskey(objFileWrapper.strFileName)){
                    objContentDocLink.ContentDocumentId = mapofContentVersionIdswithDocId.get(objFileWrapper.strFileName);
                }
                
                objContentDocLink.shareType = 'V';
                System.debug(objContentDocLink);
                lstContentDocumentLink.add(objContentDocLink);
            } 
        }
        
        if(lstContentDocumentLink!=null && lstContentDocumentLink.size()>0){
            try{
                insert lstContentDocumentLink; 
            }Catch(Exception ex){
                system.debug('***Exception cause ****'+ex.getMessage());
            }
            
        }
        
        
        
        
    }
    
    @Auraenabled
    public static void deleteWorkOrderLineItem(List<String> delteItems){
        
        List<WorkOrderLineItem> lstWorkOrderLineItem = [select Id from WorkOrderLineItem where Id In :delteItems];
        delete lstWorkOrderLineItem;
        
    }
    
    
    @Auraenabled
    public static String updateInternalCLI(List<WorkOrderLineItem> objCollectionCard){
        update objCollectionCard;
        return '';
    }
    
    
    
    @Auraenabled
    public static boolean updateCheckOut(string strCollectionCard){
        
        ETT_Collection_Card__c collectionCardObj  = [SELECT Id, ETT_Check_Out__c FROM ETT_Collection_Card__c where Id=:strCollectionCard];
        collectionCardObj.ETT_Check_Out__c = System.now() ;
        update collectionCardObj;
        
        return true;
    }
    
    
    
    @Auraenabled
    //  public static list<WorkOrderLineItem> lstCollectionCardLineItems(string strCollectionCard){
    public static Map<Map<string,List<string>>,list<WorkOrderLineItem>> lstCollectionCardLineItems(string strCollectionCard){     
        
        Map<string,List<string>> lstIsPIEmpty = new Map<string,List<string>>();
        Map<Map<string,List<string>>,list<WorkOrderLineItem>> mapResult = new Map<Map<string,List<string>>,list<WorkOrderLineItem>>();
        
        List<WorkOrderLineItem> lstWOLI = [select Id,LineItemNumber,ETT_Is_Pricing_Information_Missing__c,ETT_Accounts__c,ETT_Collection_Card__r.ETT_Receptionist_Acceptance__c,ETT_Collection_Card__r.ETT_Head_Of_Operation_Approved__c,
                                           ETT_Collection_Card__r.ETT_Factory_Manager_Approved__c,ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Check_Out__c,ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount, ETT_Tyre_Size__r.Name, 
                                           ETT_Brand__r.Name, ETT_Brand__r.ETT_Status__c, ETT_Pattern__r.Name, ETT_Country_of_Origin__r.Name,ETT_Remarks__c,ETT_Quantity__c,
                                           ETT_Load_Index__c,ETT_S_Index__c,ETT_PR__c,ETT_Tyre_Serial_Number__c,ETT_Job_Type__c,ETT_Tyre_Life__c,ETT_Accepted_By_Receptionist__c,ETT_Country_of_Origin_Name__c,ETT_Pattern_Name__c,ETT_Brand_Name__c,ETT_Tyre_Size_Name__c
                                           from WorkOrderLineItem where ETT_Collection_Card__c=:strCollectionCard];
        System.debug('lstWOLI: '+lstWOLI);
        
        List<ETT_Collection_Card__c> lstCC = [select Id,ETT_Accounts__c,RecordTypeId  from ETT_Collection_Card__c where Id=:strCollectionCard];
        string ccRecordTypeName = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosById().get(lstCC[0].RecordTypeId).getname();
        
        if(lstWOLI!=null && lstWOLI.size()>0){
            List<ETT_Pricing_Information__c> lstPricingInformation = [select Id,ETT_Price__c,ETT_Price__r.ETT_Party_Name__c,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Pattern__c,ETT_Country_of_Origin__c
                                                                      from ETT_Pricing_Information__c 
                                                                      where ETT_Price__r.ETT_Party_Name__c=:lstCC[0].ETT_Accounts__c];
            System.debug('lstPricingInformation: '+lstPricingInformation);
            Map<string,string> mapOfPricingInfoWOLI = new Map<string,string>();
            String key='';
            for(ETT_Pricing_Information__c obj:lstPricingInformation){
                
                //added by shweta on 27th May start
                if(ccRecordTypeName=='Tyre - Refurbishing Services'){
                    key = obj.ETT_Tyre_Size__c;
                    mapOfPricingInfoWOLI.put(key,obj.Id);
                }else{
                    key = obj.ETT_Tyre_Size__c+'#'+obj.ETT_Brand__c+'#'+obj.ETT_Pattern__c+'#'+obj.ETT_Country_of_Origin__c;
                    mapOfPricingInfoWOLI.put(key,obj.Id);
                }
                
                //added by shweta on 27th May stop            
                
                //key = obj.ETT_Tyre_Size__c+'#'+obj.ETT_Brand__c+'#'+obj.ETT_Pattern__c+'#'+obj.ETT_Country_of_Origin__c;
                // mapOfPricingInfoWOLI.put(key,obj.Id);
            }
            System.debug('mapOfPricingInfoWOLI: '+mapOfPricingInfoWOLI);
            
            
            List<string> lstMissingPIWOLI = new List<string>();
            for(WorkOrderLineItem obj:lstWOLI){
                //key = obj.ETT_Tyre_Size__c+'#'+obj.ETT_Brand__c+'#'+obj.ETT_Pattern__c+'#'+obj.ETT_Country_of_Origin__c;
                //added by shweta on 27th May start
                if(ccRecordTypeName=='Tyre - Refurbishing Services'){
                    key = obj.ETT_Tyre_Size__c;
                }else{
                    key = obj.ETT_Tyre_Size__c+'#'+obj.ETT_Brand__c+'#'+obj.ETT_Pattern__c+'#'+obj.ETT_Country_of_Origin__c;                    
                }
                //added by shweta on 27th May stop
                //System.debug('key: '+key);
                
                if(!mapOfPricingInfoWOLI.containskey(key)){
                    System.debug('this is not in PI');
                    lstMissingPIWOLI.add(obj.LineItemNumber);
                }
            }
            if(lstMissingPIWOLI!=null && lstMissingPIWOLI.size()>0){
                lstIsPIEmpty.put('MissingPricingInformation',lstMissingPIWOLI);
                mapResult.put(lstIsPIEmpty,lstWOLI);
            }else{
                lstIsPIEmpty.put('ExistPricingInformation',null);
                mapResult.put(lstIsPIEmpty,lstWOLI);
            }
        }
        return mapResult;
        /*return [select Id,ETT_Collection_Card__r.ETT_Receptionist_Acceptance__c,ETT_Collection_Card__r.ETT_Head_Of_Operation_Approved__c,
ETT_Collection_Card__r.ETT_Factory_Manager_Approved__c,ETT_Collection_Card__c, ETT_Collection_Card__r.ETT_Check_out__c,ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount, ETT_Tyre_Size__r.Name, 
ETT_Brand__r.Name, ETT_Brand__r.ETT_Status__c, ETT_Pattern__r.Name, ETT_Country_of_Origin__r.Name,ETT_Remarks__c,ETT_Quantity__c,
ETT_Load_Index__c,ETT_S_Index__c,ETT_PR__c,ETT_Tyre_Serial_Number__c,ETT_Job_Type__c,ETT_Tyre_Life__c,ETT_Accepted_By_Receptionist__c,ETT_Country_of_Origin_Name__c,ETT_Pattern_Name__c,ETT_Brand_Name__c,ETT_Tyre_Size_Name__c
from WorkOrderLineItem where ETT_Collection_Card__c=:strCollectionCard];*/
    }
    
    
    @Auraenabled
    public static ETT_CollectionLineItemWrapper priceInfoData(string strAcctId, string strTyreSizeId, string patternSizeId, string brandId, string strCountryId, string partyType/*, string strJobType, string process*/){
        
        /*System.debug('strAcctId '+strAcctId);
        System.debug('strTyreSizeId '+strTyreSizeId);    
        System.debug('patternSizeId '+patternSizeId);    
        System.debug('brandId '+brandId);  
        System.debug('partyType '+partyType);    
        System.debug('strJobType '+strJobType);    
        System.debug('process '+process);    
        
        
        List<ETT_Pricing_Information__c> lstPriceInfo = new List<ETT_Pricing_Information__c>();
        ETT_CollectionLineItemWrapper objCollectionWrap = new ETT_CollectionLineItemWrapper();
        string strQuery = 'Select Id,';
        
        // System.debug('@@@  ' + );
        if(strJobType=='Repair'){
            if(partyType =='Customer' || partyType=='Internal Private Project'){
                strQuery+=' ETT_Repair_Price__c from ETT_Pricing_Information__c where ETT_Tyre_Size__c=\''+strTyreSizeId+'\' and ETT_Price__r.ETT_Party_Name__c=\''+strAcctId+'\' limit 1';
            }
        }else if(strJobType=='Retread'){
            if(partyType =='Customer' || partyType =='Internal Private Project' || partyType =='Internal Private Project'){
                if(process=='Procure'){
                    strQuery+=' ETT_Retread_Price_P__c, ETT_Retread_Price_H__c from ETT_Pricing_Information__c where ETT_Tyre_Size__c=\''+strTyreSizeId+'\' and ETT_Price__r.ETT_Party_Name__c=\''+strAcctId+'\' limit 1';
                }else if(process=='Hot'){
                    strQuery+=' ETT_Retread_Price_P__c, ETT_Retread_Price_H__c from ETT_Pricing_Information__c where ETT_Tyre_Size__c=\''+strTyreSizeId+'\' and ETT_Price__r.ETT_Party_Name__c=\''+strAcctId+'\' limit 1';
                }
            }else if(partyType =='Supplier'){
                strQuery+=' ETT_Purchase_Agreed_Price__c from ETT_Pricing_Information__c where ETT_Tyre_Size__c=\''+strTyreSizeId+'\' and ETT_Price__r.ETT_Party_Name__c=\''+strAcctId+'\' and ETT_Brand__c = \''+brandId+'\' and ETT_Country_of_Origin__c=\''+strCountryId+'\' limit 1';
            }
        }
        System.debug('strQuery: '+strQuery);
        lstPriceInfo = Database.query(strQuery); 
        */
        ETT_CollectionLineItemWrapper objCollectionWrap = new ETT_CollectionLineItemWrapper();
        List<ETT_Tyre_Master__c> lstTyreSizeMaster = [select Id,ETT_Ply_Rate__c,ETT_Load_Index__c,ETT_Speed_Index__c,ETT_Tyre_Size__r.Name from ETT_Tyre_Master__c where ETT_Brand_Name__c=:brandId and
                                                      ETT_Country_Name__c=:strCountryId and ETT_Original_Pattern__c=:patternSizeId
                                                      and ETT_Tyre_Size__c=:strTyreSizeId limit 1]; 
        
        //if(lstPriceInfo!=null && lstPriceInfo.size()>0 && lstTyreSizeMaster!=null && lstTyreSizeMaster.size()>0){
        if(lstTyreSizeMaster!=null && lstTyreSizeMaster.size()>0){
            objCollectionWrap.objPricingInfo    = null;  //lstPriceInfo[0];
            objCollectionWrap.objTyreSizeMaster =  lstTyreSizeMaster[0];                                     
        }else{
            throw new AuraHandledException('No Records found');
        }                                              
        return objCollectionWrap;
    }
    
    
    @Auraenabled
    public static void approveNewTyres(map<string,string> mapofStageJsonList){
        
        list<ETT_Tyre_Master__c> lstTyreMaster;            
        list<ETT_Tyre_Size_Master__c> lstTyreSize;
        list<ETT_Brand_Master__c> lstBrand;
        list<ETT_Pattern_Master__c> lstPattern;
        list<ETT_Country_Master__c> lstCountry;
        
        list<Sobject> lstSobjectInformation = new list<Sobject>();
        
        if(mapofStageJsonList.containskey('lstTyreMasterJson')){
            lstTyreMaster =  (list<ETT_Tyre_Master__c>)JSON.deserialize(mapofStageJsonList.get('lstTyreMasterJson'),Type.forname('list<ETT_Tyre_Master__c>'));
        }        
        Set<ID> lstID = new Set<ID>();
        Set<ID> lstTyreSizeID = new Set<ID>();
        Set<ID> lstBrandID = new Set<ID>();
        Set<ID> lstPatternID = new Set<ID>();
        Set<ID> lstCountryID = new Set<ID>();
        Map<ID,String> idPriceMap = new Map<ID,String>();
        Set<ID> setCCID = new Set<ID>();
        
        if(lstTyreMaster!=null && lstTyreMaster.size()>0){
            for(ETT_Tyre_Master__c obj:lstTyreMaster){
                lstID.add(obj.Id);
                //idPriceMap.put(obj.Id,obj.ETT_Price__c);
            }
        }
        System.debug('lstID: '+lstID);
        
        Map<id,id> mapCCNameTyreMaster = new Map<id,id>();            
        Map<id,string> mapCCNamePrice = new Map<id,string>();
        Map<ID,ID> mapOfTyreMasterTyreSize = new Map<ID,ID>();
        Map<ID,ID> mapOfTyreMasterBrand = new Map<ID,ID>();
        Map<ID,ID> mapOfTyreMasterCountry = new Map<ID,ID>();
        Map<ID,ID> mapOfTyreMasterPattern = new Map<ID,ID>();                        
        
        if(lstTyreMaster!=null && lstTyreMaster.size()>0){
            List<ETT_Tyre_Master__c> listTyreMaster = [Select Id,ETT_Tyre_Size__c,ETT_Brand_Name__c,ETT_Original_Pattern__c,ETT_Country_Name__c,ETT_Price__c,ETT_Collection_Card__c from ETT_Tyre_Master__c where Id in :lstID];
            if(listTyreMaster!=null && listTyreMaster.size()>0){
                System.debug('listTyreMaster: '+listTyreMaster);
                for(ETT_Tyre_Master__c obj:listTyreMaster){
                    /*if(idPriceMap.containsKey(obj.Id)){
obj.ETT_Price__c = idPriceMap.get(obj.Id);
}*/
                    lstTyreSizeID.add(obj.ETT_Tyre_Size__c);
                    lstBrandID.add(obj.ETT_Brand_Name__c);
                    lstPatternID.add(obj.ETT_Original_Pattern__c);
                    lstCountryID.add(obj.ETT_Country_Name__c);
                    /*if(obj.ETT_Collection_Card__c!=null){
setCCID.add(obj.ETT_Collection_Card__c);
mapCCNameTyreMaster.put(obj.ETT_Collection_Card__c,obj.Id);
mapCCNamePrice.put(obj.Id,obj.ETT_Price__c);
mapOfTyreMasterTyreSize.put(obj.Id,obj.ETT_Tyre_Size__c);
mapOfTyreMasterBrand.put(obj.Id,obj.ETT_Brand_Name__c);
mapOfTyreMasterCountry.put(obj.Id,obj.ETT_Country_Name__c);
mapOfTyreMasterPattern.put(obj.Id,obj.ETT_Original_Pattern__c);
}*/
                    obj.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Approved').getRecordTypeId();
                    lstSobjectInformation.add(obj);
                }
            }
        }
        
        /*
List<ETT_Collection_Card__c> lstCC = new List<ETT_Collection_Card__c>();
List<ETT_Price_Master__c> lstPriceMaster = new List<ETT_Price_Master__c>();        
Map<ID,ID> mapOfAccPriceMaster = new Map<ID,ID>();
ID tyreMasterId;
String tyreMasterPrice;
Set<ID> setAccIds = new Set<ID>();
if(setCCID !=null && setCCID.size()>0){
lstCC = [SELECT Id, ETT_Accounts__c, ETT_Opportunity__c, ETT_Brand__c, ETT_Country__c, ETT_Pattern__c, ETT_Tyre_Size__c FROM ETT_Collection_Card__c where Id in :setCCID];
if(lstCC!=null && lstCC.size()>0){
for(ETT_Collection_Card__c objCC:lstCC){
setAccIds.add(objCC.ETT_Accounts__c);
}
}
if(setAccIds!=null && setAccIds.size()>0){
lstPriceMaster = [SELECT Id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c in :setAccIds];                

if(lstPriceMaster!=null && lstPriceMaster.size()>0){
for(ETT_Price_Master__c objPM:lstPriceMaster){
mapOfAccPriceMaster.put(objPM.ETT_Party_Name__c,objPM.ID);
}                    
}
}
if(lstCC!=null && lstCC.size()>0){
for(ETT_Collection_Card__c objCC:lstCC){
System.debug('in loop: '+objCC);
ETT_Pricing_Information__c objPricingInformation = new ETT_Pricing_Information__c();
objPricingInformation.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();

if(mapOfAccPriceMaster.containskey(objCC.ETT_Accounts__c)){
objPricingInformation.ETT_Price__c = mapOfAccPriceMaster.get(objCC.ETT_Accounts__c)!=null?mapOfAccPriceMaster.get(objCC.ETT_Accounts__c):null;
}
if(mapCCNameTyreMaster.containskey(objCC.Id)){
tyreMasterId = mapCCNameTyreMaster.get(objCC.Id);
if(mapCCNamePrice.containskey(tyreMasterId)){
tyreMasterPrice = mapCCNamePrice.get(tyreMasterId);
objPricingInformation.ETT_Purchase_Price__c = Decimal.valueOf(tyreMasterPrice);
}
if(mapOfTyreMasterTyreSize.containskey(tyreMasterId)){
objPricingInformation.ETT_Tyre_Size__c = mapOfTyreMasterTyreSize.get(tyreMasterId)!=null?mapOfTyreMasterTyreSize.get(tyreMasterId):null;
}
if(mapOfTyreMasterBrand.containskey(tyreMasterId)){
objPricingInformation.ETT_Brand__c = mapOfTyreMasterBrand.get(tyreMasterId)!=null?mapOfTyreMasterBrand.get(tyreMasterId):null;
}
if(mapOfTyreMasterCountry.containskey(tyreMasterId)){
objPricingInformation.ETT_Country_of_Origin__c = mapOfTyreMasterCountry.get(tyreMasterId)!=null?mapOfTyreMasterCountry.get(tyreMasterId):null;
}
if(mapOfTyreMasterPattern.containskey(tyreMasterId)){
objPricingInformation.ETT_Pattern__c = mapOfTyreMasterPattern.get(tyreMasterId)!=null?mapOfTyreMasterPattern.get(tyreMasterId):null;
}
System.debug(objPricingInformation);
}
lstSobjectInformation.add(objPricingInformation);
}
}
}*/
        
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
                //update lstSobjectInformation;
                upsert lstSobjectInformation;
            }catch(Exception ex){
                System.debug('Exception : '+ex.getMessage());
            }
        }
        
    }
    
    @Auraenabled
    public static Map<String,list<Sobject>> getNewTyreDetails(string recordId){
        
        List<ETT_Tyre_Master__c> lstTyreMaster = [SELECT Id, Name, ETT_Price__c, ETT_Tyre_Size__c,ETT_Tyre_Size__r.Name,ETT_Brand_Name__r.Name,ETT_Brand__c,ETT_Original_Pattern__r.Name,ETT_Pattern__c,ETT_Country_Name__c,ETT_Country_Name__r.Name, RecordType.Name,ETT_Collection_Card__c 
                                                  FROM ETT_Tyre_Master__c 
                                                  where RecordType.Name='Draft' and ETT_Collection_Card__c=:recordId];
        Set<ID> tyreSizeSet = new Set<ID>();
        Set<ID> brandSet = new Set<ID>();
        Set<ID> patternSet = new Set<ID>();
        Set<ID> countrySet = new Set<ID>();
        
        if(lstTyreMaster!=null && lstTyreMaster.size()>0){
            for(ETT_Tyre_Master__c obj:lstTyreMaster){
                tyreSizeSet.add(obj.ETT_Tyre_Size__c);
                brandSet.add(obj.ETT_Brand__c);
                patternSet.add(obj.ETT_Pattern__c);
                countrySet.add(obj.ETT_Country_Name__c);
            }
        }
        List<ETT_Tyre_Size_Master__c> lstTyreSizeMaster = [SELECT Id, Name, ETT_Status__c FROM ETT_Tyre_Size_Master__c where ETT_Status__c = false and Id in :tyreSizeSet];
        List<ETT_Country_Master__c> lstCountryMaster = [SELECT Id, Name, ETT_Status__c FROM ETT_Country_Master__c where ETT_Status__c = false and Id in :brandSet];
        List<ETT_Pattern_Master__c> lstPatternMaster = [SELECT Id, Name, ETT_Status__c FROM ETT_Pattern_Master__c where ETT_Status__c = false and Id in :patternSet];
        List<ETT_Brand_Master__c> lstBrandMaster = [SELECT Id, Name, ETT_Status__c FROM ETT_Brand_Master__c where ETT_Status__c = false and Id in :countrySet];
        
        Map<String,list<Sobject>> objMap = new Map<String,list<Sobject>>();
        
        list<Sobject> lstSobjectTyreMaster = new list<Sobject>();
        for(ETT_Tyre_Master__c objTyreMaster:lstTyreMaster){
            lstSobjectTyreMaster.add(objTyreMaster);
        }
        objMap.put('ETT_Tyre_Master__c',lstSobjectTyreMaster);
        
        /*list<Sobject> lstSobjectTyreSize = new list<Sobject>();
for(ETT_Tyre_Size_Master__c objTyreSize:lstTyreSizeMaster){
lstSobjectTyreSize.add(objTyreSize);
}
objMap.put('ETT_Tyre_Size_Master__c',lstSobjectTyreSize);

list<Sobject> lstSobjectCountry = new list<Sobject>();
for(ETT_Country_Master__c objCountry:lstCountryMaster){
lstSobjectCountry.add(objCountry);
}
objMap.put('ETT_Country_Master__c',lstSobjectCountry);

list<Sobject> lstSobjectPattern = new list<Sobject>();
for(ETT_Pattern_Master__c objPattern:lstPatternMaster){
lstSobjectPattern.add(objPattern);
}
objMap.put('ETT_Pattern_Master__c',lstSobjectPattern);

list<Sobject> lstSobjectBrand = new list<Sobject>();
for(ETT_Brand_Master__c objBrand:lstBrandMaster){
lstSobjectBrand.add(objBrand);
}     
objMap.put('ETT_Brand_Master__c',lstSobjectBrand);
*/
        return objMap;
    }
    
    
    @Auraenabled
    public static string addNewTyreMasterDetails(list<WorkOrderLineItem> lstCollectionLineItemNewTyres,String leadId,string source){
        
        System.debug('lead: '+leadId);
        
        list<WorkOrderLineItem> lstWorkOrderLineItems = new list<WorkOrderLineItem>();
        list<ETT_Apex_Error_log__c> lstApexErrorLog = new list<ETT_Apex_Error_log__c>();
        ETT_Collection_Card__c objCC = new  ETT_Collection_Card__c();
        list<Sobject> lstSobjectTyreMaster = new list<Sobject>();        
        list<Sobject> lstSobjectInformation = new list<Sobject>();
        //code added by shweta on 28th Oct START
        
        if(lstCollectionLineItemNewTyres!=null && lstCollectionLineItemNewTyres.size()>0){
            
            Set<String> strTyreSizeNewText = new Set<String>();
            Set<String> strCountryNewText = new Set<String>();
            Set<String> strPatternNewText = new Set<String>();
            Set<String> strBrandNewText = new Set<String>();
            
            Map<String,String> tyreSizeMap = new Map<String,String>();
            Map<String,String> tyreSizeMaplst = new Map<String,String>();
            
            Map<String,String> brandMap = new Map<String,String>();
            Map<String,String> brandMaplst = new Map<String,String>();
            
            Map<String,String> patternMap = new Map<String,String>();
            Map<String,String> patternMaplst = new Map<String,String>();
            
            Map<String,String> countryMap = new Map<String,String>();
            Map<String,String> countryMaplst = new Map<String,String>();
            
            for(WorkOrderLineItem woli:lstCollectionLineItemNewTyres){
                if(woli.ETT_Tyre_Size_NewText__c!=''){
                    tyreSizeMap.put(woli.ETT_Tyre_Size_NewText__c,woli.ETT_Tyre_Size_NewText__c);
                    strTyreSizeNewText.add(woli.ETT_Tyre_Size_NewText__c);
                }
                if(woli.ETT_Brand_NewText__c!=''){
                    brandMap.put(woli.ETT_Brand_NewText__c,woli.ETT_Brand_NewText__c);
                    strBrandNewText.add(woli.ETT_Brand_NewText__c);
                }
                if(woli.ETT_Pattern_NewText__c!=''){
                    patternMap.put(woli.ETT_Pattern_NewText__c,woli.ETT_Pattern_NewText__c);
                    strPatternNewText.add(woli.ETT_Pattern_NewText__c);
                }
                if(woli.ETT_Country_NewText__c!=''){
                    countryMap.put(woli.ETT_Country_NewText__c,woli.ETT_Country_NewText__c);
                    strCountryNewText.add(woli.ETT_Country_NewText__c);
                }
                
            }
            List<ETT_Tyre_Size_Master__c> lstTyreSizeMaster;
            List<ETT_Country_Master__c> lstCountryMaster;
            List<ETT_Pattern_Master__c> lstPatternMaster;
            List<ETT_Brand_Master__c> lstBrandMaster;
            
            if(strTyreSizeNewText!=null)
                lstTyreSizeMaster = [SELECT Id, Name FROM ETT_Tyre_Size_Master__c where Name in :strTyreSizeNewText];
            if(strCountryNewText!=null)
                lstCountryMaster = [SELECT Id, Name FROM ETT_Country_Master__c where Name in :strCountryNewText];
            if(strPatternNewText!=null)
                lstPatternMaster = [SELECT Id, Name FROM ETT_Pattern_Master__c where Name in :strPatternNewText];
            if(strBrandNewText!=null)
                lstBrandMaster = [SELECT Id, Name FROM ETT_Brand_Master__c where Name in :strBrandNewText];
            
            if(lstTyreSizeMaster!=null && lstTyreSizeMaster.size()>0){
                for(ETT_Tyre_Size_Master__c objTyreSize:lstTyreSizeMaster){
                    tyreSizeMaplst.put(objTyreSize.Name,objTyreSize.Name);               
                }                
            }
            if(lstCountryMaster!=null && lstCountryMaster.size()>0){
                for(ETT_Country_Master__c objCountry:lstCountryMaster){
                    countryMaplst.put(objCountry.Name,objCountry.Name);               
                }                
            }
            if(lstPatternMaster!=null && lstPatternMaster.size()>0){
                for(ETT_Pattern_Master__c objPattern:lstPatternMaster){
                    patternMaplst.put(objPattern.Name,objPattern.Name);               
                }                
            }
            if(lstBrandMaster!=null && lstBrandMaster.size()>0){
                for(ETT_Brand_Master__c objBrand:lstBrandMaster){
                    brandMaplst.put(objBrand.Name,objBrand.Name);               
                }                        
            }
            
            
            for(String fieldName : tyreSizeMap.keySet()){
                System.debug('fieldName: '+fieldName); 
                if(!tyreSizeMaplst.containsKey(fieldName)){
                    ETT_Tyre_Size_Master__c objTyreSize = new ETT_Tyre_Size_Master__c();
                    objTyreSize.Name = fieldName;
                    // objTyreSize.ETT_Status__c = true;
                    lstSobjectInformation.add((Sobject)objTyreSize);
                }
            }
            for (String fieldName : brandMap.keySet()){
                if(!brandMaplst.containsKey(fieldName)){
                    ETT_Brand_Master__c objbrand = new ETT_Brand_Master__c();
                    objbrand.Name = fieldName;
                    //  objbrand.ETT_Status__c = true;
                    lstSobjectInformation.add((Sobject)objbrand);
                }
            }
            for (String fieldName : patternMap.keySet()){
                if(!patternMaplst.containsKey(fieldName)){
                    ETT_Pattern_Master__c objPattern = new ETT_Pattern_Master__c();
                    objPattern.Name = fieldName;
                    //  objPattern.ETT_Status__c = true;
                    lstSobjectInformation.add((Sobject)objPattern);
                }
            }
            for (String fieldName : countryMap.keySet()){
                if(!countryMaplst.containsKey(fieldName)){
                    ETT_Country_Master__c objCountry = new ETT_Country_Master__c();
                    objCountry.Name = fieldName;
                    //  objCountry.ETT_Status__c = true;
                    lstSobjectInformation.add((Sobject)objCountry);
                }
            }
            
            if(lstSobjectInformation!=null && lstSobjectInformation.size()>0){
                try{
                    //upsert lstSobjectInformation;
                    insert lstSobjectInformation;
                    
                }Catch(Exception ex){
                    system.debug('***Exception Cause *****'+ex.getMessage());
                    return ex.getMessage();
                }
            }
            
            List<ETT_Tyre_Size_Master__c> getlstTyreSizeMaster = [SELECT Id, Name FROM ETT_Tyre_Size_Master__c where Name in :strTyreSizeNewText];
            List<ETT_Country_Master__c> getlstCountryMaster = [SELECT Id, Name FROM ETT_Country_Master__c where Name in :strCountryNewText];
            List<ETT_Pattern_Master__c> getlstPatternMaster = [SELECT Id, Name FROM ETT_Pattern_Master__c where Name in :strPatternNewText];
            List<ETT_Brand_Master__c> getlstBrandMaster = [SELECT Id, Name FROM ETT_Brand_Master__c where Name in :strBrandNewText];
            
            Map<String,ID> tyreSizeNameIdMap = new Map<String,ID>();
            Map<String,ID> brandNameIdMap = new Map<String,ID>();
            Map<String,ID> patternNameIdMap = new Map<String,ID>();
            Map<String,ID> countryNameIdMap = new Map<String,ID>();
            
            for(ETT_Tyre_Size_Master__c objTS:getlstTyreSizeMaster){
                tyreSizeNameIdMap.put(objTS.Name,objTS.Id);
            }
            for(ETT_Brand_Master__c objBR:getlstBrandMaster){
                brandNameIdMap.put(objBR.Name,objBR.Id);
            }
            for(ETT_Pattern_Master__c objPRN:getlstPatternMaster){
                patternNameIdMap.put(objPRN.Name,objPRN.Id);
            }
            for(ETT_Country_Master__c objCNTR:getlstCountryMaster){
                countryNameIdMap.put(objCNTR.Name,objCNTR.Id);
            }            
            
            List<ETT_Inspection_Card__c> lstIC = new List<ETT_Inspection_Card__c>();
            List<Lead> lstLeads = new List<Lead>();
            
            if(source=='InspectionCard'){
                lstIC = [select Id from ETT_Inspection_Card__c where Id=:leadId];                
            }
            if(source=='Lead'){
                lstLeads = [select Id from Lead where Id=:leadId];                
            }
            
            for(WorkOrderLineItem woli:lstCollectionLineItemNewTyres){
                if(tyreSizeNameIdMap.containsKey(woli.ETT_Tyre_Size_NewText__c)){
                    woli.ETT_Tyre_Size__c = tyreSizeNameIdMap.get(woli.ETT_Tyre_Size_NewText__c);
                }
                if(brandNameIdMap.containsKey(woli.ETT_Brand_NewText__c)){
                    woli.ETT_Brand__c = brandNameIdMap.get(woli.ETT_Brand_NewText__c);
                }
                if(patternNameIdMap.containsKey(woli.ETT_Pattern_NewText__c)){
                    woli.ETT_Pattern__c = patternNameIdMap.get(woli.ETT_Pattern_NewText__c);
                }
                if(countryNameIdMap.containsKey(woli.ETT_Country_NewText__c)){
                    woli.ETT_Country_of_Origin__c = countryNameIdMap.get(woli.ETT_Country_NewText__c);
                }                
                
                ETT_Tyre_Master__c objTyreMaster = new ETT_Tyre_Master__c();
                objTyreMaster.ETT_Tyre_Size__c = tyreSizeNameIdMap.get(woli.ETT_Tyre_Size_NewText__c);
                objTyreMaster.ETT_Brand_Name__c = brandNameIdMap.get(woli.ETT_Brand_NewText__c);
                objTyreMaster.ETT_Country_Name__c = countryNameIdMap.get(woli.ETT_Country_NewText__c);
                objTyreMaster.ETT_Original_Pattern__c = patternNameIdMap.get(woli.ETT_Pattern_NewText__c);
                objTyreMaster.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Draft').getRecordTypeId();
                if(source=='InspectionCard'){
                    objTyreMaster.ETT_Tyre_Inspection_Card__c = lstIC[0].Id;                    
                }
                if(source=='Lead'){
                    objTyreMaster.ETT_Lead__c = lstLeads[0].Id;    
                }
                
                
                lstSobjectTyreMaster.add(objTyreMaster);
                if(woli.ETT_Tyre_Size_NewText__c!='' && woli.ETT_Brand_NewText__c!='' && woli.ETT_Country_NewText__c!='' && woli.ETT_Pattern_NewText__c!=''){
                    lstWorkOrderLineItems.add(woli);    
                }
                
            }
            
        }
        
        if(lstSobjectTyreMaster!=null && lstSobjectTyreMaster.size()>0){
            try{
                insert lstSobjectTyreMaster;
            }catch(Exception ex){
                System.debug('Exception: '+ex.getMessage());
                return ex.getMessage();
            }
        }
        return null;
    }
    
    
    
    
    
    
    
    
    @Auraenabled
    public static string collectionLineItemsProcess(list<WorkOrderLineItem> lstWorkOrderLineItems,string strCollectionCard,list<WorkOrderLineItem> lstCollectionLineItemNewTyres){
        
        list<ETT_Apex_Error_log__c> lstApexErrorLog = new list<ETT_Apex_Error_log__c>();
        ETT_Collection_Card__c objCC = new  ETT_Collection_Card__c();
        list<Sobject> lstSobjectTyreMaster = new list<Sobject>();        
        boolean isNewEntry = false;
        
        //code added by shweta on 28th Oct START
        if(lstCollectionLineItemNewTyres!=null && lstCollectionLineItemNewTyres.size()>0){
            
            Set<String> strTyreSizeNewText = new Set<String>();
            Set<String> strCountryNewText = new Set<String>();
            Set<String> strPatternNewText = new Set<String>();
            Set<String> strBrandNewText = new Set<String>();
            
            Map<String,String> tyreSizeMap = new Map<String,String>();
            Map<String,String> tyreSizeMaplst = new Map<String,String>();
            
            Map<String,String> brandMap = new Map<String,String>();
            Map<String,String> brandMaplst = new Map<String,String>();
            
            Map<String,String> patternMap = new Map<String,String>();
            Map<String,String> patternMaplst = new Map<String,String>();
            
            Map<String,String> countryMap = new Map<String,String>();
            Map<String,String> countryMaplst = new Map<String,String>();
            
            
            for(WorkOrderLineItem woli:lstCollectionLineItemNewTyres){
                if(woli.ETT_Tyre_Size_NewText__c!=''){
                    tyreSizeMap.put(woli.ETT_Tyre_Size_NewText__c,woli.ETT_Tyre_Size_NewText__c);
                    strTyreSizeNewText.add(woli.ETT_Tyre_Size_NewText__c);
                }
                if(woli.ETT_Brand_NewText__c!=''){
                    brandMap.put(woli.ETT_Brand_NewText__c,woli.ETT_Brand_NewText__c);
                    strBrandNewText.add(woli.ETT_Brand_NewText__c);
                }
                if(woli.ETT_Pattern_NewText__c!=''){
                    patternMap.put(woli.ETT_Pattern_NewText__c,woli.ETT_Pattern_NewText__c);
                    strPatternNewText.add(woli.ETT_Pattern_NewText__c);
                }
                if(woli.ETT_Country_NewText__c!=''){
                    countryMap.put(woli.ETT_Country_NewText__c,woli.ETT_Country_NewText__c);
                    strCountryNewText.add(woli.ETT_Country_NewText__c);
                }
                
            }
            List<ETT_Tyre_Size_Master__c> lstTyreSizeMaster;
            List<ETT_Country_Master__c> lstCountryMaster;
            List<ETT_Pattern_Master__c> lstPatternMaster;
            List<ETT_Brand_Master__c> lstBrandMaster;
            
            if(strTyreSizeNewText!=null)
                lstTyreSizeMaster = [SELECT Id, Name FROM ETT_Tyre_Size_Master__c where Name in :strTyreSizeNewText];
            if(strCountryNewText!=null)
                lstCountryMaster = [SELECT Id, Name FROM ETT_Country_Master__c where Name in :strCountryNewText];
            if(strPatternNewText!=null)
                lstPatternMaster = [SELECT Id, Name FROM ETT_Pattern_Master__c where Name in :strPatternNewText];
            if(strBrandNewText!=null)
                lstBrandMaster = [SELECT Id, Name FROM ETT_Brand_Master__c where Name in :strBrandNewText];
            
            if(lstTyreSizeMaster!=null && lstTyreSizeMaster.size()>0){
                for(ETT_Tyre_Size_Master__c objTyreSize:lstTyreSizeMaster){
                    tyreSizeMaplst.put(objTyreSize.Name,objTyreSize.Name);               
                }                
            }
            if(lstCountryMaster!=null && lstCountryMaster.size()>0){
                for(ETT_Country_Master__c objCountry:lstCountryMaster){
                    countryMaplst.put(objCountry.Name,objCountry.Name);               
                }                
            }
            if(lstPatternMaster!=null && lstPatternMaster.size()>0){
                for(ETT_Pattern_Master__c objPattern:lstPatternMaster){
                    patternMaplst.put(objPattern.Name,objPattern.Name);               
                }                
            }
            if(lstBrandMaster!=null && lstBrandMaster.size()>0){
                for(ETT_Brand_Master__c objBrand:lstBrandMaster){
                    brandMaplst.put(objBrand.Name,objBrand.Name);               
                }                        
            }
            
            
            list<Sobject> lstSobjectInformation = new list<Sobject>();
            
            for(String fieldName : tyreSizeMap.keySet()){
                System.debug('fieldName: '+fieldName); 
                if(!tyreSizeMaplst.containsKey(fieldName)){
                    ETT_Tyre_Size_Master__c objTyreSize = new ETT_Tyre_Size_Master__c();
                    objTyreSize.Name = fieldName;
                    // objTyreSize.ETT_Status__c = true;
                    lstSobjectInformation.add((Sobject)objTyreSize);
                    isNewEntry = true;
                }
            }
            for (String fieldName : brandMap.keySet()){
                if(!brandMaplst.containsKey(fieldName)){
                    ETT_Brand_Master__c objbrand = new ETT_Brand_Master__c();
                    objbrand.Name = fieldName;
                    //  objbrand.ETT_Status__c = true;
                    lstSobjectInformation.add((Sobject)objbrand);
                    isNewEntry = true;
                }
            }
            for (String fieldName : patternMap.keySet()){
                if(!patternMaplst.containsKey(fieldName)){
                    ETT_Pattern_Master__c objPattern = new ETT_Pattern_Master__c();
                    objPattern.Name = fieldName;
                    //  objPattern.ETT_Status__c = true;
                    lstSobjectInformation.add((Sobject)objPattern);
                    isNewEntry = true;
                }
            }
            for (String fieldName : countryMap.keySet()){
                if(!countryMaplst.containsKey(fieldName)){
                    ETT_Country_Master__c objCountry = new ETT_Country_Master__c();
                    objCountry.Name = fieldName;
                    //  objCountry.ETT_Status__c = true;
                    lstSobjectInformation.add((Sobject)objCountry);
                    isNewEntry = true;
                }
            }
            
            if(lstSobjectInformation!=null && lstSobjectInformation.size()>0){
                try{
                    upsert lstSobjectInformation;
                    //insert lstSobjectInformation;
                    
                }Catch(Exception ex){
                    system.debug('***Exception Cause *****'+ex.getMessage());
                    return ex.getMessage();
                }
            }
            
            List<ETT_Tyre_Size_Master__c> getlstTyreSizeMaster = [SELECT Id, Name FROM ETT_Tyre_Size_Master__c where Name in :strTyreSizeNewText];
            List<ETT_Country_Master__c> getlstCountryMaster = [SELECT Id, Name FROM ETT_Country_Master__c where Name in :strCountryNewText];
            List<ETT_Pattern_Master__c> getlstPatternMaster = [SELECT Id, Name FROM ETT_Pattern_Master__c where Name in :strPatternNewText];
            List<ETT_Brand_Master__c> getlstBrandMaster = [SELECT Id, Name FROM ETT_Brand_Master__c where Name in :strBrandNewText];
            
            Map<String,ID> tyreSizeNameIdMap = new Map<String,ID>();
            Map<String,ID> brandNameIdMap = new Map<String,ID>();
            Map<String,ID> patternNameIdMap = new Map<String,ID>();
            Map<String,ID> countryNameIdMap = new Map<String,ID>();
            
            for(ETT_Tyre_Size_Master__c objTS:getlstTyreSizeMaster){
                tyreSizeNameIdMap.put(objTS.Name,objTS.Id);
            }
            for(ETT_Brand_Master__c objBR:getlstBrandMaster){
                brandNameIdMap.put(objBR.Name,objBR.Id);
            }
            for(ETT_Pattern_Master__c objPRN:getlstPatternMaster){
                patternNameIdMap.put(objPRN.Name,objPRN.Id);
            }
            for(ETT_Country_Master__c objCNTR:getlstCountryMaster){
                countryNameIdMap.put(objCNTR.Name,objCNTR.Id);
            }            
            
            
            
            for(WorkOrderLineItem woli:lstCollectionLineItemNewTyres){
                if(tyreSizeNameIdMap.containsKey(woli.ETT_Tyre_Size_NewText__c)){
                    woli.ETT_Tyre_Size__c = tyreSizeNameIdMap.get(woli.ETT_Tyre_Size_NewText__c);
                }
                if(brandNameIdMap.containsKey(woli.ETT_Brand_NewText__c)){
                    woli.ETT_Brand__c = brandNameIdMap.get(woli.ETT_Brand_NewText__c);
                }
                if(patternNameIdMap.containsKey(woli.ETT_Pattern_NewText__c)){
                    woli.ETT_Pattern__c = patternNameIdMap.get(woli.ETT_Pattern_NewText__c);
                }
                if(countryNameIdMap.containsKey(woli.ETT_Country_NewText__c)){
                    woli.ETT_Country_of_Origin__c = countryNameIdMap.get(woli.ETT_Country_NewText__c);
                }                
                
                ETT_Tyre_Master__c objTyreMaster = new ETT_Tyre_Master__c();
                objTyreMaster.ETT_Tyre_Size__c = tyreSizeNameIdMap.get(woli.ETT_Tyre_Size_NewText__c);
                objTyreMaster.ETT_Brand_Name__c = brandNameIdMap.get(woli.ETT_Brand_NewText__c);
                objTyreMaster.ETT_Country_Name__c = countryNameIdMap.get(woli.ETT_Country_NewText__c);
                objTyreMaster.ETT_Original_Pattern__c = patternNameIdMap.get(woli.ETT_Pattern_NewText__c);
                objTyreMaster.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Draft').getRecordTypeId();
                objTyreMaster.ETT_Collection_Card__c = strCollectionCard;
                
                lstSobjectTyreMaster.add(objTyreMaster);
                if(woli.ETT_Tyre_Size_NewText__c!='' && woli.ETT_Brand_NewText__c!='' && woli.ETT_Country_NewText__c!='' && woli.ETT_Pattern_NewText__c!=''){
                    lstWorkOrderLineItems.add(woli);    
                }
                
            }
            
        }
        if(isNewEntry){
            if(lstSobjectTyreMaster!=null && lstSobjectTyreMaster.size()>0){
                try{
                    insert lstSobjectTyreMaster;
                }catch(Exception ex){
                    System.debug('Exception: '+ex.getMessage());
                }
            }
            //code added by shweta on 28th Oct STOP
        }
        if(lstWorkOrderLineItems!=null && lstWorkOrderLineItems.size()>0){
            try{
                System.debug('lstWorkOrderLineItems'+lstWorkOrderLineItems);
                for(Integer i=0;i<lstWorkOrderLineItems.size();i++){
                    lstWorkOrderLineItems[i].StartDate = System.now();
                    lstWorkOrderLineItems[i].EndDate = System.now();    
                    if(lstWorkOrderLineItems[i].ETT_Tyre_Size__c==null){
                        lstWorkOrderLineItems.remove(i);
                    }
                }
                System.debug('lstWorkOrderLineItems:');
                System.debug(lstWorkOrderLineItems);
                
                upsert lstWorkOrderLineItems;
                list<ETT_Tyre_Inventory__c> lstTyreInventories = new list<ETT_Tyre_Inventory__c>();
                if(lstWorkOrderLineItems!=null && lstWorkOrderLineItems.size()>0){
                    List<WorkOrderLineItem> lstobjWorkOrderLineItem = [select Id,ETT_Accounts__c,ETT_Brand__c,ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Collection_Date__c,ETT_Collection_Card__r.ETT_Accounts__c,ETT_Country_of_Origin__c,
                                                                       ETT_Pattern__c,ETT_Tyre_Size__c from WorkOrderLineItem where id in :lstWorkOrderLineItems];
                    
                    List<Account> lstAcc = [select Id,Name,ETT_Party_Code__c from Account where Id=:lstobjWorkOrderLineItem[0].ETT_Accounts__c];
                    
                    for(WorkOrderLineItem objWorkOrderLineItem : lstobjWorkOrderLineItem){
                        ETT_Tyre_Inventory__c objTyreInventory       = new ETT_Tyre_Inventory__c();
                        objTyreInventory.ETT_Account__c              = objWorkOrderLineItem.ETT_Collection_Card__r.ETT_Accounts__c;
                        objTyreInventory.ETT_Brand__c                = objWorkOrderLineItem.ETT_Brand__c;
                        objTyreInventory.ETT_Collection_Card__c      = objWorkOrderLineItem.ETT_Collection_Card__c;
                        objTyreInventory.ETT_Country__c              = objWorkOrderLineItem.ETT_Country_of_Origin__c;
                        objTyreInventory.ETT_Pattern__c              = objWorkOrderLineItem.ETT_Pattern__c;
                        objTyreInventory.ETT_Tyre_Size_Master__c     = objWorkOrderLineItem.ETT_Tyre_Size__c;   
                        objTyreInventory.ETT_Work_Order_Line_Item__c = objWorkOrderLineItem.Id; 
                        objTyreInventory.ETT_Status_TI__c            = 'Collected';	
                        objTyreInventory.ETT_Status_Changed_On__c    = system.now();
                        objTyreInventory.RecordTypeId                = Schema.SObjectType.ETT_Tyre_Inventory__c.getRecordTypeInfosByName().get('Collection Inventory').getRecordTypeId();                                             
                        lstTyreInventories.add(objTyreInventory); 
                    }
                }
                
                if(lstTyreInventories!=null && lstTyreInventories.size()>0){
                    try{
                        insert lstTyreInventories;
                    }Catch(Exception ex){
                        system.debug('****Exception Cause *****'+ex.getMessage());
                    }
                    
                }
                ETT_Collection_Card__c objCollectionCardDetails = [select Id,Name,ETT_Collection_Team_Submitted__c,ETT_Work_Order__c,ETT_Service_Appointment__c
                                                                   from ETT_Collection_Card__c where id=:lstWorkOrderLineItems[0].ETT_Collection_Card__c];
                objCC.ETT_Status__c = 'Collection Stage';
                
                if(lstWorkOrderLineItems!=null && lstWorkOrderLineItems[0].ETT_Collection_Card__c!=null){
                    list<Sobject> lstSobjects = new list<Sobject>();
                    //ServiceAppointment objServiceAppointment = new ServiceAppointment();
                    //objServiceAppointment.status = 'Completed';
                    //objServiceAppointment.Id = objCollectionCardDetails.ETT_Service_Appointment__c!=null?objCollectionCardDetails.ETT_Service_Appointment__c:null;
                    //lstSobjects.add(objServiceAppointment);
                    
                    WorkOrder objWorkOrder = new WorkOrder();
                    objWorkOrder.Id = objCollectionCardDetails.ETT_Work_Order__c!=null ?objCollectionCardDetails.ETT_Work_Order__c:null;
                    objWorkOrder.Status  = 'Completed';
                    lstSobjects.add(objWorkOrder);
                    
                    
                    
                    objCC.Id = lstWorkOrderLineItems[0].ETT_Collection_Card__c;
                    // objCC.ETT_Collection_Team_Submitted__c = true;
                    //objCC.ETT_Collection_Status__c = 'In Progress';
                    if(lstWorkOrderLineItems!=null && lstWorkOrderLineItems.size()>0){
                        //objCC.WOLI_Status__c = 'Accepted';
                        objCC.ETT_Collection_Status__c = 'Accepted';
                    }else{
                        List<ETT_Tyre_Rejection_Report__c> lstRejectionReport = [Select Id,Name,ETT_Collection_Card__c from ETT_Tyre_Rejection_Report__c where ETT_Collection_Card__c=:lstWorkOrderLineItems[0].ETT_Collection_Card__r.Name];
                        
                        if(lstRejectionReport!=null && lstRejectionReport.size()>0){
                            objCC.ETT_Collection_Status__c = 'Rejected';
                        }else{
                            objCC.ETT_Collection_Status__c = 'Scheduled';
                        }
                    }
                    lstSobjects.add(objCC);
                    
                    if(lstSobjects!=null && lstSobjects.size()>0){
                        try{
                            update lstSobjects;
                        }Catch(Exception ex){
                            System.debug(ex.getLineNumber());
                            System.debug(ex.getMessage());                            
                            throw new AuraHandledException(ex.getMessage());
                        }
                    }
                    update objCC;
                    
                    
                }
                
                // ETT_ProcessApprovelRequest.submitForApproval(objCC);
            }Catch(Exception ex){
                System.debug('getLineNumber: '+ex.getLineNumber());
                System.debug(ex.getMessage());
                throw new AuraHandledException(ex.getLineNumber()+ex.getMessage());
            }
            
            if(lstApexErrorLog!=null && lstApexErrorLog.size()>0){
                insert lstApexErrorLog;
            }
            
            /*ETT_Collection_Card__c collectionCardObj  = [SELECT Id, ETT_Check_Out__c FROM ETT_Collection_Card__c where Id=:strCollectionCard];
collectionCardObj.ETT_Check_Out__c = System.now() ;
update collectionCardObj;
*/
            return lstWorkOrderLineItems[0].ETT_Collection_Card__c;
        }
        
        return '';
    }
    //This is for After Tyre Details  Accepcting the Receptionist
    
    
    
    
    
    
    
    
    
    @Auraenabled
    public static string strSalesTeamAccpectance(list<WorkOrderLineItem> lstWorkOrderList,ETT_Collection_Card__c objCollectionCard){
        if(lstWorkOrderList!=null && lstWorkOrderList.size()>0){
            try{
                update lstWorkOrderList;
            }Catch(Exception ex){
                new AuraHandledException(ex.getMessage());
            }
        }
        objCollectionCard.ETT_Sales_Acceptance__c = true;
        update objCollectionCard;
        System.debug('strRecetionistAccpectance: '+objCollectionCard);
        //ETT_ProcessApprovelRequest.approveRecord(objCollectionCard);
        list<WorkOrderLineItem> lstWorkOrderDetails = [select Id,ETT_Tyre_Life__c,ETT_Collection_Card__r.ETT_Service_Appointment__r.ContactId,ETT_Collection_Card__r.ETT_Accounts__c,ETT_Accepted_By_Receptionist__c,ETT_Accounts__c,ETT_Collection_Card__c,ETT_Tyre_Price__c,ETT_Collection_Card__r.ETT_Service_Appointment__c,ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount, ETT_Tyre_Size__c, ETT_Brand__c,ETT_Tyre_Master__c, ETT_Pattern__c, ETT_Country_of_Origin__c,
                                                       ETT_Load_Index__c,ETT_S_Index__c,ETT_PR__c,ETT_Tyre_Serial_Number__c from WorkOrderLineItem where ETT_Collection_Card__c=:objCollectionCard.Id];
        list<ETT_Inspection_Card__c> lstInspectionCards = new list<ETT_Inspection_Card__c>();
        for(WorkOrderLineItem objWorkOrderLineItem :lstWorkOrderDetails){
            ETT_Inspection_Card__c objInspectionCard = new ETT_Inspection_Card__c();
            if(objWorkOrderLineItem.ETT_Accepted_By_Receptionist__c){
                objInspectionCard.ETT_Brand__c = objWorkOrderLineItem.ETT_Brand__c;
                objInspectionCard.ETT_Collection_Card__c = objWorkOrderLineItem.ETT_Collection_Card__c;
                objInspectionCard.ETT_Collection_Line_Item__c = objWorkOrderLineItem.Id;
                objInspectionCard.ETT_Tyre_Life__c = objWorkOrderLineItem.ETT_Tyre_Life__c; 
                objInspectionCard.ETT_Country__c = objWorkOrderLineItem.ETT_Country_of_Origin__c;
                objInspectionCard.ETT_Pattern__c = objWorkOrderLineItem.ETT_Pattern__c;
                objInspectionCard.ETT_Service_Appointment__c = objWorkOrderLineItem.ETT_Collection_Card__r.ETT_Service_Appointment__c;
                objInspectionCard.ETT_Tyre__c = objWorkOrderLineItem.ETT_Tyre_Master__c;
                objInspectionCard.ETT_Tyre_Size__c = objWorkOrderLineItem.ETT_Tyre_Size__c;
                objInspectionCard.ETT_Price_Master__c = objWorkOrderLineItem.ETT_Tyre_Price__c;
                objInspectionCard.ETT_Tyre_Serial_Number__c = objWorkOrderLineItem.ETT_Tyre_Serial_Number__c; 
                objInspectionCard.ETT_Account__c  = objWorkOrderLineItem.ETT_Collection_Card__r.ETT_Accounts__c;
                objInspectionCard.ETT_Contact__c = objWorkOrderLineItem.ETT_Collection_Card__r.ETT_Service_Appointment__r.ContactId;
                ETT_Collection_Card__c objCC = [SELECT Id, RecordType.Name FROM ETT_Collection_Card__c where Id=:objWorkOrderLineItem.ETT_Collection_Card__c limit 1];
                System.debug(objCC.RecordType.Name);
                String recordTypeName = objCC.RecordType.Name;
                objInspectionCard.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(); 
                lstInspectionCards.add(objInspectionCard);
            }
            
        }
        
        if(lstInspectionCards!=null && lstInspectionCards.size()>0){
            try{
                insert lstInspectionCards;
            }Catch(Exception ex){
                new AuraHandledException(ex.getMessage());
            }
        }
        
        return objCollectionCard.Id;
    }
    
    
    @Auraenabled
    public static string strRecetionistAccpectance(list<WorkOrderLineItem> lstWorkOrderList,ETT_Collection_Card__c objCollectionCard){
        if(lstWorkOrderList!=null && lstWorkOrderList.size()>0){
            try{
                update lstWorkOrderList;
            }Catch(Exception ex){
                new AuraHandledException(ex.getMessage());
            }
        }
        objCollectionCard.ETT_Receptionist_Acceptance__c = true;
        update objCollectionCard;
        System.debug('strRecetionistAccpectance: '+objCollectionCard);
        //ETT_ProcessApprovelRequest.approveRecord(objCollectionCard);
        list<WorkOrderLineItem> lstWorkOrderDetails = [select Id,ETT_Tyre_Life__c,ETT_Collection_Card__r.ETT_Service_Appointment__r.ContactId,ETT_Collection_Card__r.ETT_Accounts__c,ETT_Accepted_By_Receptionist__c,ETT_Accounts__c,ETT_Collection_Card__c,ETT_Tyre_Price__c,ETT_Collection_Card__r.ETT_Service_Appointment__c,ETT_Collection_Card__r.ETT_Work_Order__r.LineItemCount, ETT_Tyre_Size__c, ETT_Brand__c,ETT_Tyre_Master__c, ETT_Pattern__c, ETT_Country_of_Origin__c,
                                                       ETT_Load_Index__c,ETT_S_Index__c,ETT_PR__c,ETT_Tyre_Serial_Number__c from WorkOrderLineItem where ETT_Collection_Card__c=:objCollectionCard.Id];
        list<ETT_Inspection_Card__c> lstInspectionCards = new list<ETT_Inspection_Card__c>();
        list<ETT_Tyre_Inventory__c> tyreInvList = [SELECT Id, ETT_Status_TI__c FROM ETT_Tyre_Inventory__c WHERE ETT_Work_Order_Line_Item__c In:lstWorkOrderList AND ETT_Work_Order_Line_Item__r.ETT_Accepted_By_Receptionist__c=true];
        if(!tyreInvList.isEmpty()){
            for(ETT_Tyre_Inventory__c ti : tyreInvList){
                ti.ETT_Status_TI__c = 'Receptionist Accepted';
                ti.ETT_Status_Changed_On__c= system.now();
            }
            update tyreInvList;
        }
        for(WorkOrderLineItem objWorkOrderLineItem :lstWorkOrderDetails){
            ETT_Inspection_Card__c objInspectionCard = new ETT_Inspection_Card__c();
            if(objWorkOrderLineItem.ETT_Accepted_By_Receptionist__c){
                objInspectionCard.ETT_Brand__c = objWorkOrderLineItem.ETT_Brand__c;
                objInspectionCard.ETT_Collection_Card__c = objWorkOrderLineItem.ETT_Collection_Card__c;
                objInspectionCard.ETT_Collection_Line_Item__c = objWorkOrderLineItem.Id;
                objInspectionCard.ETT_Tyre_Life__c = objWorkOrderLineItem.ETT_Tyre_Life__c; 
                objInspectionCard.ETT_Country__c = objWorkOrderLineItem.ETT_Country_of_Origin__c;
                objInspectionCard.ETT_Pattern__c = objWorkOrderLineItem.ETT_Pattern__c;
                objInspectionCard.ETT_Service_Appointment__c = objWorkOrderLineItem.ETT_Collection_Card__r.ETT_Service_Appointment__c;
                objInspectionCard.ETT_Tyre__c = objWorkOrderLineItem.ETT_Tyre_Master__c;
                objInspectionCard.ETT_Tyre_Size__c = objWorkOrderLineItem.ETT_Tyre_Size__c;
                objInspectionCard.ETT_Price_Master__c = objWorkOrderLineItem.ETT_Tyre_Price__c;
                objInspectionCard.ETT_Tyre_Serial_Number__c = objWorkOrderLineItem.ETT_Tyre_Serial_Number__c; 
                objInspectionCard.ETT_Account__c  = objWorkOrderLineItem.ETT_Collection_Card__r.ETT_Accounts__c;
                objInspectionCard.ETT_Contact__c = objWorkOrderLineItem.ETT_Collection_Card__r.ETT_Service_Appointment__r.ContactId;
                
                ETT_Collection_Card__c objCC = [SELECT Id, RecordType.Name FROM ETT_Collection_Card__c where Id=:objWorkOrderLineItem.ETT_Collection_Card__c limit 1];
                String recordTypeName = objCC.RecordType.Name;
                objInspectionCard.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(); 
                
                
                lstInspectionCards.add(objInspectionCard);
            }
            
        }
        
        if(lstInspectionCards!=null && lstInspectionCards.size()>0){
            try{
                insert lstInspectionCards;
            }Catch(Exception ex){
                new AuraHandledException(ex.getMessage());
            }
        }
        
        return objCollectionCard.Id;
    }
    
    //This is for After Tyre Details  Accepcting the HOO
    @Auraenabled
    public static string strHOOAccpectance(ETT_Collection_Card__c objCollectionCard){
        objCollectionCard.ETT_Head_Of_Operation_Approved__c = true;
        update objCollectionCard;
        System.debug('strHOOAccpectance: '+objCollectionCard);
        //ETT_ProcessApprovelRequest.approveRecord(objCollectionCard);
        return objCollectionCard.Id;
    }
    
    //This is for After Tyre Details  Accepcting the FM
    @Auraenabled
    public static string strFMAccpectance(ETT_Collection_Card__c objCollectionCard){
        objCollectionCard.ETT_Factory_Manager_Approved__c = true;
        objCollectionCard.ETT_Status__c = 'Inspection Stage';
        update objCollectionCard;
        System.debug('strFMAccpectance: '+objCollectionCard);
        //ETT_ProcessApprovelRequest.approveRecord(objCollectionCard);
        
        return objCollectionCard.Id;
    }
    
    @AuraEnabled
    public static Map<String, String> getselectOptions(string fld) {
        
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        
        Schema.sObjectType objType = WorkOrderLineItem.getSObjectType();
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
    
    @Auraenabled
    public static string strApprovalProcessHandle(){
        
        return '';
    }
    
    @AuraEnabled
    public static string scrabTyreAttachmentHandle(map<string,string> mapofStageJsonList){
        //Temporarily Commented for deployment purpose
        list<ETT_SrabTyreWrapper> lstScrabTyreWrapper;
        list<ETT_Scrap_Tyre_Analysis__c> lstSrabTyreDetails;
        string strCollectionCardId;
        
        if(mapofStageJsonList.containskey('lstSrabTyreDetails')){
            lstSrabTyreDetails =  (list<ETT_Scrap_Tyre_Analysis__c>)JSON.deserialize(mapofStageJsonList.get('lstSrabTyreDetails'),Type.forname('list<ETT_Scrap_Tyre_Analysis__c>'));
        } 
        
        if(mapofStageJsonList.containskey('lstScrabTyreWrapper')){
            lstScrabTyreWrapper =  (list<ETT_SrabTyreWrapper>)JSON.deserialize(mapofStageJsonList.get('lstScrabTyreWrapper'),Type.forname('list<ETT_SrabTyreWrapper>'));
        } 
        
        if(mapofStageJsonList.containskey('filesToUpload')){
            strCollectionCardId =  mapofStageJsonList.get('strCollectionCardId');
        } 
        
        
        //public static string scrabTyreAttachmentHandle(list<ETT_SrabTyreWrapper> lstScrabTyreWrapper,list<ETT_Scrap_Tyre_Analysis__c> lstSrabTyreDetails,string strCollectionCardId){
        if(lstSrabTyreDetails!=null && lstSrabTyreDetails.size()>0){
            map<string,string> mapOfTyreDetailswithSrabTyreIds = new map<string,string>();
            map<string,list<ContentDocumentLink>> mapOfSrabedContentDocumentLink = new map<string,list<ContentDocumentLink>>();
            try{
                insert lstSrabTyreDetails; 
                for(ETT_Scrap_Tyre_Analysis__c objScrapTyre :[Select Id,ETT_Brand__r.Name,ETT_Country_of_Origin__r.Name,
                                                              ETT_Pattern__r.Name,ETT_Tyre_Size__r.Name from ETT_Scrap_Tyre_Analysis__c where Id in :lstSrabTyreDetails]){
                                                                  mapOfTyreDetailswithSrabTyreIds.put(objScrapTyre.ETT_Brand__r.Name+'#'+objScrapTyre.ETT_Country_of_Origin__r.Name+
                                                                                                      '#'+objScrapTyre.ETT_Pattern__r.Name+'#'+objScrapTyre.ETT_Tyre_Size__r.Name,
                                                                                                      objScrapTyre.Id);
                                                                  
                                                              }
                if(lstScrabTyreWrapper!=null && lstScrabTyreWrapper.size()>0){
                    map<string,string> mapofDocumentIdwithScrapTyreIds = new map<string,string>();
                    for(ETT_SrabTyreWrapper objSranWrapper :lstScrabTyreWrapper){
                        if(mapOfTyreDetailswithSrabTyreIds.containsKey(objSranWrapper.strKey)){
                            if(objSranWrapper.lstDocuments!=null && objSranWrapper.lstDocuments.size()>0){
                                for(ContentDocument objContentDocument :objSranWrapper.lstDocuments){
                                    mapofDocumentIdwithScrapTyreIds.put(objContentDocument.Id,mapOfTyreDetailswithSrabTyreIds.get(objSranWrapper.strKey));
                                }
                            }
                        }    
                    }
                    
                    list<ContentDocumentLink> lstContentDocumentDetails = [select Id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ContentDocumentId in : mapofDocumentIdwithScrapTyreIds.keyset()];
                    boolean isProcess = false;
                    if(lstContentDocumentDetails!=null && lstContentDocumentDetails.size()>0){
                        for(ContentDocumentLink objContentDocumentLink :lstContentDocumentDetails){
                            if(mapofDocumentIdwithScrapTyreIds.containsKey(objContentDocumentLink.Id)){
                                objContentDocumentLink.LinkedEntityId = mapofDocumentIdwithScrapTyreIds.get(objContentDocumentLink.Id);
                                isProcess = true;
                            }
                        }
                    }
                    if(isProcess){
                        update lstContentDocumentDetails;
                        return strCollectionCardId;
                    }
                } 
            }Catch(Exception ex){
                System.debug('@@  ' + ex.getMessage());
                throw new AuraHandledException(ex.getMessage());
            }
        }
        return '';
    }
    
    @Auraenabled
    public static List<ContentVersion> getContentId(ID fileId){
        
        System.debug('fileId: '+fileId);
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :fileId];
        System.debug('CDLs: '+CDLs);
        
        //if (CDLs.size() < 1) return new List<ContentDocument>(); 
        
        // Make a List of ContentDocument IDs
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); }        
        
        System.debug('CDIdList: '+CDIdList);
        //List<ContentDocument> entries = [SELECT Id, Title, FileType FROM ContentDocument WHERE ContentDocument.Id IN :CDIdList];
        List<ContentDocument> entries = [SELECT Id, Title, FileType FROM ContentDocument WHERE Id IN :CDIdList];
        System.debug('entries: '+entries);
        
        Set<ID> ContentDocumentIDs = new Set<ID>();
        if(entries!=null && entries.size()>0){
            for(ContentDocument en:entries){
                ContentDocumentIDs.add(en.Id);
            }
        }
        System.debug('ContentDocumentIDs: '+ContentDocumentIDs);
        
        List<ContentVersion> lstContentVersion = [SELECT Id,Title FROM ContentVersion WHERE ContentDocumentId IN :ContentDocumentIDs];
        System.debug('lstContentVersion: '+lstContentVersion);

        return lstContentVersion;
    }
}