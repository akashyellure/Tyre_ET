/*
Created Date:08-28-2020
Created By:G.Krishnareddy
Description :This is for Tyre Inspection Card Details Accepted or Rejected Creteria.
*/
public class ETT_TyreInspectionCardController {
    
  @auraenabled
    public static List<ETT_Inspection_Card__c> getInspectionCardTyreLife(string recordId){
        
        return [select Id,ETT_Tyre_Life__c from ETT_Inspection_Card__c where Id=:recordId];
        
    }
    
    
    @auraenabled
    public static List<ETT_Tyre_Rejection_Line_Item__c> getInspectionCardDetails(string recordId){
        return [SELECT Id,Name,ETT_Good_Condition__c,ETT_Number_of_cuts_0_10_mm__c,ETT_Number_of_cuts_11_to_25_mm__c,ETT_Number_of_cuts_26_to_38_mm__c,ETT_Number_of_cuts_39_to_50_mm__c,ETT_Number_of_cuts_51_mm_and_above__c,
                ETT_Inspection_Card__c,ETT_Inspection_Card__r.ETT_Tyre_Life__c,(select Id,Name,ETT_Status__c from Tyre_Rejection_Sub_Line_Items__r) 
                FROM ETT_Tyre_Rejection_Line_Item__c where ETT_Inspection_Card__c=:recordId];
        
    }
    
    
    @auraenabled
    public static List<ETT_Tyre_Rejection_Line_Item__c> getjobCardDetails(string recordId){
        
        return [SELECT Id,Name,ETT_Good_Condition__c,ETT_Inspection_Card__c,ETT_Job_Card__c ,(select Id,Name,ETT_Status__c from Tyre_Rejection_Sub_Line_Items__r) 
                FROM ETT_Tyre_Rejection_Line_Item__c where ETT_Job_Card__c =:recordId];
    }
    
    @auraenabled
    public static void createStagingQuotation(string recordId,Integer Price){
        
        List<ETT_Inspection_Card__c> lstInspectionCard = [SELECT Id, ETT_Collection_Line_Item__c FROM ETT_Inspection_Card__c where Id=:recordId];
        List<WorkOrderLineItem> lstWorkOrderLineItem = new List<WorkOrderLineItem>();
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        
        if(lstInspectionCard!=null && lstInspectionCard.size()>0){
            lstWorkOrderLineItem = [select Id,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Pattern__c,ETT_Country_of_Origin__c,
                                    ETT_Tyre_Size__r.Name,ETT_Brand__r.Name,ETT_Pattern__r.Name,ETT_Country_of_Origin__r.Name,
                                    ETT_Price__c,ETT_Minimum_Price__c,ETT_Maximum_Price__c,ETT_Collection_Card__c
                                    from WorkOrderLineItem 
                                    where Id=:lstInspectionCard[0].ETT_Collection_Line_Item__c];
        }
        
        List<ETT_Staging_Quotation_Request__c> lstStagingQuotation = [select Id from ETT_Staging_Quotation_Request__c where ETT_Inspection_Card__c=:recordId];
        
        for(WorkOrderLineItem obj:lstWorkOrderLineItem){
            if(lstStagingQuotation!=null && lstStagingQuotation.size()>0){
                lstStagingQuotation[0].ETT_Tyre_Size_Master__c = obj.ETT_Tyre_Size__c;
                lstStagingQuotation[0].ETT_Brand__c = obj.ETT_Brand__c;
                lstStagingQuotation[0].ETT_Pattern__c = obj.ETT_Pattern__c;
                lstStagingQuotation[0].ETT_Country__c = obj.ETT_Country_of_Origin__c;
                lstStagingQuotation[0].ETT_Purchase_Price__c = Price;
                lstStagingQuotation[0].ETT_Min_Range__c = obj.ETT_Minimum_Price__c;
                lstStagingQuotation[0].ETT_Max_Range__c = obj.ETT_Maximum_Price__c;
                lstStagingQuotation[0].ETT_Collection_Card__c = obj.ETT_Collection_Card__c;
                lstStagingQuotation[0].ETT_Approve_Stage__c = 'Pending for FM Approval';
                lstStagingQuotation[0].ETT_Inspection_Card__c = recordId;
                lstStagingQuotation[0].ETT_HOO_Price_Acceptance__c = true;
                lstStgQuotation.add(lstStagingQuotation[0]);
            }else{
                ETT_Staging_Quotation_Request__c objStgQuotation = new ETT_Staging_Quotation_Request__c();
                objStgQuotation.ETT_Tyre_Size_Master__c = obj.ETT_Tyre_Size__c;
                objStgQuotation.ETT_Brand__c = obj.ETT_Brand__c;
                objStgQuotation.ETT_Pattern__c = obj.ETT_Pattern__c;
                objStgQuotation.ETT_Country__c = obj.ETT_Country_of_Origin__c;
                objStgQuotation.ETT_Purchase_Price__c = Price;
                objStgQuotation.ETT_Min_Range__c = obj.ETT_Minimum_Price__c;
                objStgQuotation.ETT_Max_Range__c = obj.ETT_Maximum_Price__c;
                objStgQuotation.ETT_Collection_Card__c = obj.ETT_Collection_Card__c;
                objStgQuotation.ETT_Approve_Stage__c = 'Pending for FM Approval';
                objStgQuotation.ETT_Inspection_Card__c = recordId;
                objStgQuotation.ETT_HOO_Price_Acceptance__c = true;
                lstStgQuotation.add(objStgQuotation);
            }
        }
        if(lstStgQuotation!=null && lstStgQuotation.size()>0){
            try{
                upsert lstStgQuotation;
            }catch(Exception ex){
                System.debug('Exception: '+ex.getMessage());
            }
        }
        
    }
    
    
    @auraenabled
    public static void FMPriceApproval(string recordId,List<ETT_Staging_Quotation_Request__c> lstStgQuotation){
        
        System.debug('lstStgQuotation:'+lstStgQuotation);
        List<ETT_Staging_Quotation_Request__c> lstStagingQuotation = [select Id,ETT_FM_Price_Acceptance__c,ETT_Tyre_Size_Master__c,ETT_Brand__c,ETT_Pattern__c,ETT_Country__c,ETT_Purchase_Price__c,ETT_Min_Range__c,ETT_Max_Range__c,
                                                                      ETT_Collection_Card__c,ETT_Inspection_Card__c from ETT_Staging_Quotation_Request__c where ETT_Inspection_Card__c=:recordId];
        
        List<ETT_Collection_Card__c> objCC = [select Id,ETT_Accounts__c from ETT_Collection_Card__c where Id=:lstStagingQuotation[0].ETT_Collection_Card__c];
        List<ETT_Price_Master__c> objPriceMaster = [select Id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c=:objCC[0].ETT_Accounts__c];
        
        List<sObject> lstsObj = new List<sObject>();
        
        if(lstStgQuotation!=null && lstStgQuotation.size()>0){
            for(ETT_Staging_Quotation_Request__c obj:lstStagingQuotation){
                
                //if(obj.ETT_Approve_Stage__c=='Qualified'){
                if(obj.ETT_FM_Price_Acceptance__c==false){
                    obj.ETT_FM_Price_Acceptance__c = true;
                    obj.ETT_HOO_Price_Acceptance__c = true;
                    
                    
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
                }
                //}
            }
        }
        System.debug('lstsObj: '+lstsObj);
        
        if(lstsObj!=null && lstsObj.size()>0){
            try{
                upsert lstsObj;
            }catch(Exception ex){
                System.debug('Exception: '+ex.getMessage());
            }
        }
        
    }
    
    
    @auraenabled
    public static List<ETT_Staging_Quotation_Request__c> getStagingQuotation(string recordId){
        
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = [select Id,ETT_Tyre_Size_Master__r.Name,ETT_Tyre_Size_Master__c,ETT_Purchase_Price__c,ETT_Min_Range__c,ETT_Max_Range__c 
                                                                  from ETT_Staging_Quotation_Request__c 
                                                                  where ETT_Inspection_Card__c=:recordId];
        
        if(lstStgQuotation!=null && lstStgQuotation.size()>0){
            system.debug('lstStgQuotation :'+lstStgQuotation[1]);
            return lstStgQuotation;
        }
        
        return null;
    }
    
    @auraenabled
    public static List<ETT_Tyre_Inventory__c> getRelatedWOLI(string recordId){
        system.debug('This is a recordId :'+recordId);
        List<ETT_Inspection_Card__c> lstInspectionCard = [SELECT Id,ETT_Tyre_Serial_Number__c,Tyre_Inventory__c FROM ETT_Inspection_Card__c where Id=:recordId];
        if(lstInspectionCard!=null && lstInspectionCard.size()>0){
            List<ETT_Tyre_Inventory__c> lstTyreInventory = [select Id,ETT_Tyre_Size_Master__c,ETT_Brand__c,ETT_Pattern__c,ETT_Country__c,Serial_Number__c,
                                                            ETT_Tyre_Size_Master__r.Name,ETT_Brand__r.Name,ETT_Pattern__r.Name,ETT_Country__r.Name 
                                                            from ETT_Tyre_Inventory__c 
                                                            where Id=:lstInspectionCard[0].Tyre_Inventory__c];
            if(lstTyreInventory!=null && lstTyreInventory.size()>0){
                return lstTyreInventory;
            }else{
                return null;
            }
        }
        return null;
    }
    
    @auraenabled
    public static Boolean checkDuplicateInspection(List<WorkOrderLineItem> lstWorkOrderLineItem,Id TyreInspectionCardId){
        Boolean duplicatePresent = false;
        if(lstWorkOrderLineItem!=null && lstWorkOrderLineItem.size()>0){   
            ETT_Inspection_Card__c currentInspectionCard = [Select id,Name,ETT_Tyre_Serial_Number__c from ETT_Inspection_Card__c where id=:TyreInspectionCardId];
            List<ETT_Inspection_Card__c> inspectionCardList =  [Select Id,Name,ETT_Tyre_Serial_Number__c,ETT_Brand__c from ETT_Inspection_Card__c];
            Id updatedBrand = lstWorkOrderLineItem[0].ETT_Brand__c;
            String currentSerialNumber = currentInspectionCard.ETT_Tyre_Serial_Number__c;  
            System.debug('currentSerialNumber='+currentSerialNumber);
            System.debug('updatedBrand='+updatedBrand);
            for(ETT_Inspection_Card__c ins:inspectionCardList)
            {
                if(ins.id!=TyreInspectionCardId)
                {
                    if(ins.ETT_Tyre_Serial_Number__c==currentSerialNumber&&ins.ETT_Brand__c==updatedBrand)
                    {
                        System.debug('duplicatePresent=');
                        duplicatePresent = true;
                        return true;
                     //   break;
                    }
                    
                }
            }
            
            
        }
        return duplicatePresent;
    }
    
    
     @auraenabled
    public static Boolean checkCollectionCard(Id TyreInspectionCardId){
        
        ETT_Inspection_Card__c currentInspectionCard = [Select id,Name,ETT_Collection_Card__c from ETT_Inspection_Card__c where id=:TyreInspectionCardId];
        
        Boolean collectionPresent = false;
        
        if(currentInspectionCard.ETT_Collection_Card__c != null)
        {
           collectionPresent = true; 
        }
        return collectionPresent;
    }
    @auraenabled
    public static List<ETT_Tyre_Inventory__c> updateRelatedWOLI(List<ETT_Tyre_Inventory__c> lstTyreInventory,Id TyreInspectionCardId){
        
        ETT_Inspection_Card__c getOldInsCardDetails = [Select Id,Name,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Country__c,ETT_Pattern__c,ETT_Tyre_Serial_Number__c from ETT_Inspection_Card__c where id =: TyreInspectionCardId];
        List<ETT_Tyre_Master__c> tyremasterList = [Select id,ETT_Brand_Name__c,ETT_Country_Name__c,ETT_Original_Pattern__c,ETT_Tyre_Size__c from ETT_Tyre_Master__c];
        System.debug('lstTyreInventory: '+lstTyreInventory);
        
        if(lstTyreInventory!=null && lstTyreInventory.size()>0){
            try{
                /*Id TyreSize = lstTyreInventory[0].ETT_Tyre_Size_Master__c;
                Id Brand = lstTyreInventory[0].ETT_Brand__c;
                Id Pattern = lstTyreInventory[0].ETT_Pattern__c;
                Id Country = lstTyreInventory[0].ETT_Country__c;*/
                
                update lstTyreInventory;
               /*Id oldTyreSize = getOldInsCardDetails.ETT_Tyre_Size__c;
                Id oldBrand = getOldInsCardDetails.ETT_Brand__c;
                Id oldPattern = getOldInsCardDetails.ETT_Pattern__c;
                Id oldCountry = getOldInsCardDetails.ETT_Country__c;
                
                System.debug('getOldInsCardDetails.ETT_Tyre_Size__c='+oldTyreSize);
                System.debug('getOldInsCardDetails.ETT_Brand__c='+oldBrand);
                System.debug('New TyreSize='+TyreSize);
                System.debug('New Brand='+Brand);
                if(oldTyreSize!=TyreSize ||oldBrand!=Brand )
                {
                    System.debug('Inside If Pattern='+Pattern);
                    System.debug('Inside If Country='+Country);
                    System.debug('Inside If TyreSize='+TyreSize);
                    System.debug('Inside If Brand='+Brand);
                    getOldInsCardDetails.preApproval_Pattern__c = Pattern;
                    getOldInsCardDetails.preApproval_Country__c = Country;
                    getOldInsCardDetails.preApproval_TyreSize__c=TyreSize;
                    getOldInsCardDetails.preApproval_Brand__c= Brand;
                    update getOldInsCardDetails;
                    
                    Approval.ProcessSubmitRequest Req = new Approval.ProcessSubmitRequest();
                    Req.setComments('Update Inspection Card Approval') ;
                    Req.setObjectId(TyreInspectionCardId);
                    String processName = Label.ETT_Update_Inspection_Card;
                    Req.setProcessDefinitionNameOrId(processName);
                    System.debug('Approval process going to rasie for work line item='+TyreInspectionCardId);
                    
                    Approval.ProcessResult result = Approval.process(Req);
                    
                    System.debug('Approval process rasied for work line item='+TyreInspectionCardId);
                    
                }
                else{
                    if(oldPattern!=Pattern ||oldCountry!=Country)
                    {
                        boolean match = false;
                        for(ETT_Tyre_Master__c tyreMaster:tyremasterList)
                        {
                            if(tyreMaster.ETT_Brand_Name__c==Brand&&tyreMaster.ETT_Tyre_Size__c==TyreSize&&tyreMaster.ETT_Country_Name__c==Country&&tyreMaster.ETT_Original_Pattern__c==Pattern) 
                            {
                                match = true ;
                                break;
                            }
                        }
                        if(match)
                        {
                            System.debug('Inside Else');
                            update lstWorkOrderLineItem;
                            System.debug('Inside Else Pattern='+Pattern);
                            System.debug('Inside Else Country='+Country);
                            System.debug('Inside Else TyreSize='+TyreSize);
                            System.debug('Inside Else Brand='+Brand);
                            getOldInsCardDetails.ETT_Pattern__c = Pattern;
                            getOldInsCardDetails.ETT_Country__c = Country;
                            getOldInsCardDetails.ETT_Tyre_Size__c=TyreSize;
                            getOldInsCardDetails.ETT_Brand__c= Brand;
                            
                            update getOldInsCardDetails;
                        }
                        else
                        {
                            System.debug('Inside If Pattern='+Pattern);
                            System.debug('Inside If Country='+Country);
                            System.debug('Inside If TyreSize='+TyreSize);
                            System.debug('Inside If Brand='+Brand);
                            getOldInsCardDetails.preApproval_Pattern__c = Pattern;
                            
                            getOldInsCardDetails.preApproval_Country__c = Country;
                            getOldInsCardDetails.preApproval_TyreSize__c=TyreSize;
                            getOldInsCardDetails.preApproval_Brand__c= Brand;
                            update getOldInsCardDetails;
                            
                            Approval.ProcessSubmitRequest Req = new Approval.ProcessSubmitRequest();
                            Req.setComments('Update Inspection Card Approval') ;
                            Req.setObjectId(TyreInspectionCardId);
                            String processName = Label.ETT_Update_Inspection_Card;
                            Req.setProcessDefinitionNameOrId(processName);
                            System.debug('Approval process going to rasie for work line item='+TyreInspectionCardId);
                            
                            Approval.ProcessResult result = Approval.process(Req);
                            
                            System.debug('Approval process rasied for work line item='+TyreInspectionCardId);
                        }
                        
                    }
                    
                }*/
            }catch(Exception ex){
                System.debug('Exception: '+ex.getMessage());
            } 
        } 
        
        return null;
    }
    
    @auraenabled
    public static string tyreInsectionJobCardProcess(string strInspectionJson,string strInspectionSkillJson,string partyType){
        System.debug('strInspectionJson: '+strInspectionJson);
        System.debug('strInspectionSkillJson: '+strInspectionSkillJson);
        System.debug('partyType: '+partyType);
        
        ETT_TyreInspectionCardWrapper.InspectionTechincalSkill objInsectionSkill = (ETT_TyreInspectionCardWrapper.InspectionTechincalSkill) JSON.deserialize(strInspectionSkillJson,Type.forname('ETT_TyreInspectionCardWrapper.InspectionTechincalSkill'));
        ETT_Inspection_Card__c objInsepctionCard =  (ETT_Inspection_Card__c)JSON.deserialize(strInspectionJson,Type.forname('ETT_Inspection_Card__c'));                       
        list<Sobject> lstSobjectsUpdate = new list<Sobject>();
        
        system.debug('*******lstSobjectsUpdate****'+lstSobjectsUpdate);
        list<ETT_Tyre_Rejection_Line_Item__c> lstTyreRejectionLineItem = new list<ETT_Tyre_Rejection_Line_Item__c>();
        list<ETT_Tyre_Rejection_Sub_Line_Item__c> lstTyreRejectionSubLineItems = new list<ETT_Tyre_Rejection_Sub_Line_Item__c>();
        list<ContentVersion> lstContentVersions = new list<ContentVersion>();
        list<ContentDocumentLink> lstContentDocumentLink = new list<ContentDocumentLink>(); 
        list<ETT_TyreInspectionCardWrapper.FileWrapper> lstExistingFileWrapper = new list<ETT_TyreInspectionCardWrapper.FileWrapper>();
        list<ETT_TyreInspectionCardWrapper.FileWrapperNTC> lstExistingFileWrapperNTC = new list<ETT_TyreInspectionCardWrapper.FileWrapperNTC>();
        if(objInsectionSkill.lstTyreRejectionLineItems!=null && objInsectionSkill.lstTyreRejectionLineItems.size()>0){
            for(ETT_TyreInspectionCardWrapper.TyreRejectionLineItem objTyreRejectionLineItem :objInsectionSkill.lstTyreRejectionLineItems){
                System.debug('objTyreRejectionLineItem: '+objTyreRejectionLineItem);
                System.debug('goodCondition: '+objTyreRejectionLineItem.goodCondition);
                if(objTyreRejectionLineItem.goodCondition=='No'){
                    ETT_Tyre_Rejection_Line_Item__c objTyreRejectionLine = new ETT_Tyre_Rejection_Line_Item__c();
                    //objTyreRejectionLine.ETT_Inspection_Card__c = objInsepctionCard.Id;
                    objTyreRejectionLine.ETT_Job_Card__c = objInsectionSkill.JobCardId;
                    objTyreRejectionLine.ETT_Job_Stage__c = objInsectionSkill.jobCardStage;
                    objTyreRejectionLine.ETT_Version__c = Double.valueOf(objInsectionSkill.revision);
                    
                    objTyreRejectionLine.ETT_Good_Condition__c  = objTyreRejectionLineItem.goodCondition;
                    objTyreRejectionLine.Name = objTyreRejectionLineItem.tyreRejectionName;
                    objTyreRejectionLine.Bead_wire_loosening__c = objTyreRejectionLineItem.strBeadwireloosening;
                    
                    if(objTyreRejectionLineItem.cuts_0_to_10!=null && objTyreRejectionLineItem.cuts_0_to_10.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_0_to_10){
                            objTyreRejectionLine.ETT_Number_of_cuts_0_10_mm__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        }
                    }
                    if(objTyreRejectionLineItem.cuts_11_to_25!=null && objTyreRejectionLineItem.cuts_11_to_25.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_11_to_25){
                            objTyreRejectionLine.ETT_Number_of_cuts_11_to_25_mm__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        }
                    }
                    if(objTyreRejectionLineItem.cuts_26_to_38!=null && objTyreRejectionLineItem.cuts_26_to_38.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_26_to_38){
                            objTyreRejectionLine.ETT_Number_of_cuts_26_to_38_mm__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        }
                    }
                    if(objTyreRejectionLineItem.cuts_39_to_50!=null && objTyreRejectionLineItem.cuts_39_to_50.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_39_to_50){
                            objTyreRejectionLine.ETT_Number_of_cuts_39_to_50_mm__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        }
                    }
                    if(objTyreRejectionLineItem.cuts_51!=null && objTyreRejectionLineItem.cuts_51.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_51){
                            objTyreRejectionLine.ETT_Number_of_cuts_51_mm_and_above__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        } 
                    }
                    if(Schema.SObjectType.ETT_Tyre_Rejection_Line_Item__c.getRecordTypeInfosByName().get(objTyreRejectionLineItem.strRecordTypeName).getRecordTypeId()!=null)
                        objTyreRejectionLine.RecordTypeId = Schema.SObjectType.ETT_Tyre_Rejection_Line_Item__c.getRecordTypeInfosByName().get(objTyreRejectionLineItem.strRecordTypeName).getRecordTypeId();
                    lstTyreRejectionLineItem.add(objTyreRejectionLine);
                }
            }
            
        }

        system.debug('*****lstTyreRejectionLineItem***'+lstTyreRejectionLineItem);
        if(lstTyreRejectionLineItem!=null && lstTyreRejectionLineItem.size()>0){
            try{
                insert lstTyreRejectionLineItem;
            }Catch(Exception ex){
                system.debug('****Exception ****'+ex.getMessage());
            }
            
        }
        
        system.debug('*****After lstTyreRejectionLineItem****'+lstTyreRejectionLineItem);
        map<string,string> mapOfRejectionNamewithId = new map<string,string>();
        if(lstTyreRejectionLineItem!=null && lstTyreRejectionLineItem.size()>0){
            for(ETT_Tyre_Rejection_Line_Item__c objRejectionLineItem :lstTyreRejectionLineItem){
                system.debug('*****objRejectionLineItem Name****'+objRejectionLineItem.Name);
                mapOfRejectionNamewithId.put(objRejectionLineItem.Name,objRejectionLineItem.Id); 
            }
            system.debug('*****mapOfRejectionNamewithId****'+mapOfRejectionNamewithId);
            if(objInsectionSkill.lstTyreRejectionLineItems!=null && objInsectionSkill.lstTyreRejectionLineItems.size()>0){
                for(ETT_TyreInspectionCardWrapper.TyreRejectionLineItem objTyreRejectionLineItem :objInsectionSkill.lstTyreRejectionLineItems){
                    if(objTyreRejectionLineItem.lstTyreRejectionSubLineItems!=null && objTyreRejectionLineItem.lstTyreRejectionSubLineItems.size()>0){
                        for(ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem objSubLineItem :objTyreRejectionLineItem.lstTyreRejectionSubLineItems){
                            system.debug('*****objSubLineItem*****'+objSubLineItem);
                            if(objTyreRejectionLineItem.goodCondition!='Yes'){
                                
                                ETT_Tyre_Rejection_Sub_Line_Item__c objTyreRejectionSubLine = new ETT_Tyre_Rejection_Sub_Line_Item__c();
                                objTyreRejectionSubLine.ETT_Cause_Of_Rejection__c = objSubLineItem.strCauseOfRejection;
                                objTyreRejectionSubLine.ETT_Other_Comments__c = objSubLineItem.strOtherComments;
                                objTyreRejectionSubLine.ETT_Recommendations__c = objSubLineItem.strRecommendations;
                                objTyreRejectionSubLine.ETT_Status__c = objSubLineItem.strStatus;
                                objTyreRejectionSubLine.Name = objSubLineItem.strRejectionName;
                                
                                system.debug('*****Rejection Name*****'+objSubLineItem.strRejectionName);
                                
                                if(mapOfRejectionNamewithId.containsKey(objTyreRejectionLineItem.tyreRejectionName)){
                                    objTyreRejectionSubLine.ETT_Tyre_Rejection_Line_Item__c  =  mapOfRejectionNamewithId.get(objTyreRejectionLineItem.tyreRejectionName);
                                }//strStatus
                                lstTyreRejectionSubLineItems.add(objTyreRejectionSubLine);
                                if(objSubLineItem.strStatus=='Rejected' && objSubLineItem.lstFileWrapperDetails!=null && objSubLineItem.lstFileWrapperDetails.size()>0){
                                    for(ETT_TyreInspectionCardWrapper.FileWrapper objFileWrapper :objSubLineItem.lstFileWrapperDetails){
                                        ContentVersion objContentVersion = new ContentVersion();
                                        
                                        if(objFileWrapper.strFileName!=null && objFileWrapper.strFileType!=null && objFileWrapper.fileContent!=null && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=null){
                                            System.debug('objFileWrapper: '+objFileWrapper);
                                            objContentVersion.Title = objFileWrapper.strFileName;
                                            objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                            objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                            lstContentVersions.add(objContentVersion);  
                                            lstExistingFileWrapper.add(objFileWrapper);
                                            
                                        }
                                        system.debug('****lstExistingFileWrapper*****'+lstExistingFileWrapper);
                                    }
                                }
                            }
                        } 
                    }
                    
                }
                
            }
            
            if(lstTyreRejectionSubLineItems!=null && lstTyreRejectionSubLineItems.size()>0){
                try{
                    insert lstTyreRejectionSubLineItems;
                }Catch(Exception ex){
                    system.debug('***lstTyreRejectionSubLineItems*****'+lstTyreRejectionSubLineItems);
                }
                
            }
            
            system.debug('*****lstTyreRejectionSubLineItems****'+lstTyreRejectionSubLineItems);
            
            map<string,string> mapofTyreRejectionNamewithId = new map<string,string>();
            map<string,string> mapofContentVersionIdswithDocId = new map<string,string>();
            
            if(lstTyreRejectionSubLineItems!=null && lstTyreRejectionSubLineItems.size()>0){
                for(ETT_Tyre_Rejection_Sub_Line_Item__c objTyreRejectionSub :lstTyreRejectionSubLineItems){
                    mapofTyreRejectionNamewithId.put(objTyreRejectionSub.Name,objTyreRejectionSub.Id);
                } 
            } 
            
            system.debug('****mapofTyreRejectionNamewithId****'+mapofTyreRejectionNamewithId);
            
            if(lstContentVersions!=null && lstContentVersions.size()>0)
            {
                try{
                    insert lstContentVersions;
                }Catch(Exception ex){
                    system.debug('****Exception Cause'+ex.getMessage());
                }
            }
            
            system.debug('****lstContentVersions****'+lstContentVersions);
            
            if(lstContentVersions!=null && lstContentVersions.size()>0){
                for(ContentVersion objContentVersion :[Select Id,ContentDocumentId,Title from ContentVersion where Id in :lstContentVersions]){
                    mapofContentVersionIdswithDocId.put(objContentVersion.Title,objContentVersion.ContentDocumentId);
                }  
            } 
            
            if(lstExistingFileWrapper!=null && lstExistingFileWrapper.size()>0){
                for(ETT_TyreInspectionCardWrapper.FileWrapper objFileWrapper :lstExistingFileWrapper){
                    ContentDocumentLink  objContentDocLink = new ContentDocumentLink ();
                    system.debug('****objFileWrapper.strRejectionName****'+objFileWrapper.strRejectionName);
                    system.debug('****objFileWrapper.strRejectionName****'+mapofTyreRejectionNamewithId.containsKey(objFileWrapper.strRejectionName));
                    if(mapofTyreRejectionNamewithId.containskey(objFileWrapper.strRejectionName)){
                        objContentDocLink.LinkedEntityId = mapofTyreRejectionNamewithId.get(objFileWrapper.strRejectionName);
                    }
                    if(mapofContentVersionIdswithDocId.containskey(objFileWrapper.strFileName)){
                        objContentDocLink.ContentDocumentId = mapofContentVersionIdswithDocId.get(objFileWrapper.strFileName);
                    }
                    
                    objContentDocLink.shareType = 'V';
                    lstContentDocumentLink.add(objContentDocLink);
                } 
            }
            
            if(lstExistingFileWrapperNTC!=null && lstExistingFileWrapperNTC.size()>0){
                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :lstExistingFileWrapperNTC){
                    ContentDocumentLink  objContentDocLink = new ContentDocumentLink ();
                    system.debug('****objFileWrapper.strRejectionName****'+objFileWrapper.strRejectionName);
                    system.debug('****objFileWrapper.strRejectionName****'+mapofTyreRejectionNamewithId.containsKey(objFileWrapper.strRejectionName));
                    
                    if(mapOfRejectionNamewithId.containskey(objFileWrapper.strRejectionName)){
                        objContentDocLink.LinkedEntityId = mapOfRejectionNamewithId.get(objFileWrapper.strRejectionName);
                    }
                    if(mapofContentVersionIdswithDocId.containskey(objFileWrapper.strFileName)){
                        objContentDocLink.ContentDocumentId = mapofContentVersionIdswithDocId.get(objFileWrapper.strFileName);
                    }
                    
                    objContentDocLink.shareType = 'V';
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
            
            system.debug('***lstContentDocumentLink*****'+lstContentDocumentLink);
            system.debug('****mapofContentVersionIdswithDocId****'+mapofContentVersionIdswithDocId);
            system.debug('****lstContentVersions****'+lstContentVersions);
            system.debug('****lstContentVersions****'+lstContentVersions.size());
            system.debug('****lstExistingFileWrapper***'+lstExistingFileWrapper);
            system.debug('****lstExistingFileWrapper***'+lstExistingFileWrapper.size());

            
        }  
        
        
        return objInsectionSkill.JobCardId;
        
    }
    
    @auraenabled
    public static string tyreInsectionCardProcess(string strInspectionJson,string strInspectionSkillJson,string partyType){
        
        System.debug('strInspectionJson: '+strInspectionJson);
        System.debug('strInspectionSkillJson: '+strInspectionSkillJson);
        System.debug('partyType: '+partyType);
        
        ETT_TyreInspectionCardWrapper.InspectionTechincalSkill objInsectionSkill = (ETT_TyreInspectionCardWrapper.InspectionTechincalSkill) JSON.deserialize(strInspectionSkillJson,Type.forname('ETT_TyreInspectionCardWrapper.InspectionTechincalSkill'));
        ETT_Inspection_Card__c objInsepctionCard =  (ETT_Inspection_Card__c)JSON.deserialize(strInspectionJson,Type.forname('ETT_Inspection_Card__c'));                       
        list<Sobject> lstSobjectsUpdate = new list<Sobject>();
        if(objInsepctionCard!=null && objInsectionSkill!=null){
            integer inspectedCount = 0;
            ETT_Inspection_Card__c objInspectionDetail = [select Id,ETT_Account__c,ETT_Collection_Card__r.ETT_Accounts__c,ETT_Contact__c,ETT_Collection_Card__r.ETT_Work_Order__r.contactId,ETT_Tyre_Serial_Number__c,ETT_Collection_Card__r.ETT_Service_Appointment__r.contactId,
                                                          ETT_Account__r.fax,ETT_Account__r.ETT_Email__c,ETT_Account__r.BillingStreet,ETT_Brand__c,ETT_Collection_Card__c,
                                                          ETT_Country__c,ETT_Pattern__c,ETT_Collection_Line_Item__c,ETT_Status__c,
                                                          ETT_Tyre_Size__c,ETT_Tyre_Size__r.Name from ETT_Inspection_Card__c where id=:objInsepctionCard.Id limit 1];
            
            
            System.debug('objInspectionDetail: '+objInspectionDetail);
            
            list<ETT_Used_Tyre_Casing_Price__mdt> lstPriceRange = [SELECT Label,ETT_Max_Range__c,ETT_Min_Range__c FROM ETT_Used_Tyre_Casing_Price__mdt ORDER BY Label];
            
            System.debug('lstPriceRange: '+lstPriceRange);
            
            map<string,ETT_Used_Tyre_Casing_Price__mdt> mapOfTyreCasingPrice = new map<string,ETT_Used_Tyre_Casing_Price__mdt>();
            
            for(ETT_Used_Tyre_Casing_Price__mdt objPriceRange :lstPriceRange){
                mapOfTyreCasingPrice.put(objPriceRange.label,objPriceRange);
            }
            
            if(objInsepctionCard!=null){
                
                System.debug('inside objInsepctionCard');
                list<ETT_Estimate_Quotation__c> eixstingQuotaionList = [select Id from ETT_Estimate_Quotation__c where ETT_Tyre_Inspection_Card__c=:objInsepctionCard.Id limit 1];
                
                System.debug('eixstingQuotaionList: '+eixstingQuotaionList.size());
                
                
                
     
                
                
                
                
                
                
                
                ETT_Estimate_Quotation__c objEstimation = new ETT_Estimate_Quotation__c();
                list<ETT_Pricing_Information__c> lstPricingInfo = [select Id,ETT_Purchase_Price__c,ETT_Brand__c,ETT_Country_of_Origin__c,
                                                                   ETT_Pattern__c,ETT_Price__r.ETT_Party_Name__c,
                                                                   ETT_Minimum_Price__c,ETT_Maximum_Price__c,ETT_Tyre_Size__c
                                                                   from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c=:
                                                                   objInsepctionCard.ETT_Account__c and ETT_Brand__c=:objInsepctionCard.ETT_Brand__c
                                                                   and ETT_Country_of_Origin__c=:objInsepctionCard.ETT_Country__c and 
                                                                   ETT_Pattern__c=:objInsepctionCard.ETT_Pattern__c and ETT_Tyre_Size__c=:objInsepctionCard.ETT_Tyre_Size__c
                                                                  ];
                
                System.debug('lstPricingInfo: '+lstPricingInfo);
                
                if(objInspectionDetail.ETT_Tyre_Size__c!=null && mapOfTyreCasingPrice.containsKey(objInspectionDetail.ETT_Tyre_Size__r.Name)){
                    System.debug('inside min max');
                    objEstimation.ETT_Min_Range__c = mapOfTyreCasingPrice.get(objInspectionDetail.ETT_Tyre_Size__r.Name).ETT_Min_Range__c;
                    objEstimation.ETT_Max_Range__c = mapOfTyreCasingPrice.get(objInspectionDetail.ETT_Tyre_Size__r.Name).ETT_Max_Range__c;
                }
                objEstimation.ETT_Account__c = objInspectionDetail.ETT_Account__c;
                objEstimation.ETT_Tyre_Inspection_Card__c = objInspectionDetail.Id;//
                //objEstimation.ETT_Address__c = objInspectionDetail.ETT_Account__r.BillingStreet;
                //objEstimation.ETT_Contact__c = objInspectionDetail.ETT_Contact__c;
                objEstimation.ETT_Brand__c = objInspectionDetail.ETT_Brand__c;
                objEstimation.ETT_Country_of_Origin__c = objInspectionDetail.ETT_Country__c;
                objEstimation.ETT_Pattern__c = objInspectionDetail.ETT_Pattern__c;
                objEstimation.ETT_Tyre_Size__c = objInspectionDetail.ETT_Tyre_Size__c;
                //objEstimation.ETT_Work_Order_Line_Item__c = objInspectionDetail.ETT_Collection_Line_Item__c;
                objEstimation.ETT_Quantity__c = 1;
                //objEstimation.ETT_Email__c = objInspectionDetail.ETT_Account__r.ETT_Email__c;
                //objEstimation.ETT_Fax__c =   objInspectionDetail.ETT_Account__r.Fax;  
                objEstimation.ETT_Collection_Card__c = objInspectionDetail.ETT_Collection_Card__c;
                if(objInsepctionCard.ETT_Status__c=='Accept')
                    objEstimation.ETT_Status__c = 'Accepted';
                if(lstPricingInfo!=null && lstPricingInfo.size()>0){
                    objEstimation.ETT_Price__c = lstPricingInfo[0].ETT_Purchase_Price__c;
                }
                
                if(objInsepctionCard.ETT_Status__c=='Send Back'){
                    objEstimation.ETT_Price__c = 0;
                    objEstimation.ETT_Status__c = 'Rejected';
                }
                system.debug('****objEstimation****'+objEstimation);
                if(eixstingQuotaionList.isEmpty()){
                    if(objEstimation!=null){
                        try{
                            insert objEstimation;
                        }Catch(Exception ex){
                            system.debug('***Exception ex***'+ex.getLineNumber());
                        }
                    }
                }
                
                //objEstimation.ETT_Price__c = 0;
                
            }
            System.debug(objInsepctionCard);
            System.debug(objInsectionSkill); 
            //added by sree
            list<ETT_Tyre_Inventory__c> tyreInvList = [SELECT Id, ETT_Status_TI__c FROM ETT_Tyre_Inventory__c WHERE ETT_Work_Order_Line_Item__c =:objInspectionDetail.ETT_Collection_Line_Item__c AND ETT_Work_Order_Line_Item__r.ETT_Accepted_By_Receptionist__c=true];
            if(!tyreInvList.isEmpty()){
                for(ETT_Tyre_Inventory__c ti : tyreInvList){
                    if(objInsepctionCard.ETT_Status__c=='Accept'){
                        ti.ETT_Status_Changed_On__c= system.now();
                        ti.ETT_Status_TI__c = 'Inspection Team Accepted';
                    }
                    
                    if(objInsepctionCard.ETT_Status__c=='Send Back'){
                        ti.ETT_Status_Changed_On__c= system.now();
                        ti.ETT_Status_TI__c = 'Inspection Team Rejected	';
                    }
                    ti.ETT_Tyre_Inspection_Card__c = objInspectionDetail.Id;
                }
                update tyreInvList;
            }
            if(objInsectionSkill.isSuportingToolsavilable){
                objInsepctionCard.ETT_Poking_Screwdriver__c = true;
                objInsepctionCard.ETT_Chalk_Crayon_Yellow__c = true;
                objInsepctionCard.ETT_Cutting_Player__c = true;
                objInsepctionCard.ETT_Handheld_Drop_Light__c = true;
                objInsepctionCard.ETT_Staple_Gun__c = true;
                objInsepctionCard.ETT_Tyre_Tapping_Tool__c = true;
                objInsepctionCard.ETT_Nail_Remover__c = TRUE;
                objInsepctionCard.ETT_Spiral_Cement_Tool__c = true;
                objInsepctionCard.ETT_Knife__c = true;
                objInsepctionCard.ETT_Industrial_Vacuum_Cleaner__c = true;
                
            }
            if(objInsectionSkill.isEletornicProbinWorkingCondition){
                objInsepctionCard.ETT_Electrical_Prob_In_Working_Condition__c = true;
            }         
            if(objInsectionSkill.isTyreSprederisWorkingCondtion)
                objInsepctionCard.ETT_Tyre_Spreader_In_Working_Condition__c = true;
            if(objInsectionSkill.isSpreadLightCondtion)
                objInsepctionCard.ETT_Spreader_Light_Condition__c = true;
            if(objInsectionSkill.isTyreLiftinWorkingCondition)
                objInsepctionCard.ETT_Tyre_Lift_In_Working_Condition__c = true;
            
            if(objInsepctionCard!=null){
                if(objInsepctionCard.ETT_Status__c=='Send Back' && objInsepctionCard.RecordTypeId == Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId()){
                    objInsepctionCard.ETT_Status__c='Scrap';
                } 
                objInsepctionCard.ETT_Account__c= objInspectionDetail.ETT_Account__c;
                objInsepctionCard.Inspection_Technician__c = userinfo.getUserId();
                objInsepctionCard.ETT_End_Time__c = system.now();
                update objInsepctionCard; 
            }
            
            list<AggregateResult> lstAggregrateResult = [select count(id) inspectionCount,ETT_Status__c status from ETT_Inspection_Card__c where ETT_Collection_Card__c =:objInspectionDetail.ETT_Collection_Card__c group by ETT_Status__c];
            
            Integer acceptedCount =0;
            Integer sendBackCount =0;
            Integer notInspected  =0;
            Integer totalCount=0;
            if(lstAggregrateResult!=null && lstAggregrateResult.size()>0){
                for(AggregateResult objAggregreateResult :lstAggregrateResult){
                    string strStatus =(string)objAggregreateResult.get('status');
                    if(strStatus=='Accept'){
                        acceptedCount++;
                    }else if(strStatus=='Send Back'){
                        sendBackCount++;
                    }else{
                        notInspected++;
                    }
                    totalCount++;
                }
            }
            
            if(notInspected==0 && totalCount==(sendBackCount+acceptedCount)){
                ETT_Collection_Card__c objCollectionCard = new ETT_Collection_Card__c();
                objCollectionCard.Id =  objInspectionDetail.ETT_Collection_Card__c;
                objCollectionCard.ETT_Inspection_Done__c = true; 
                update objCollectionCard;
                
                //added by shweta on 8th Sept 2020 START
                //Tyre - Refurbishing Services
                
                ETT_Inspection_Card__c objIC = [SELECT Id, RecordTypeId,RecordType.Name FROM ETT_Inspection_Card__c where Id=:objInspectionDetail.Id];
                if(objIC.RecordType.Name == 'Tyre - Refurbishing Services'){
                    
                    //added by shweta on 8th Sept 2020 STOP       
                }         
            }
            
        }
        
        
        system.debug('*******lstSobjectsUpdate****'+lstSobjectsUpdate);
        list<ETT_Tyre_Rejection_Line_Item__c> lstTyreRejectionLineItem = new list<ETT_Tyre_Rejection_Line_Item__c>();
        list<ETT_Tyre_Rejection_Sub_Line_Item__c> lstTyreRejectionSubLineItems = new list<ETT_Tyre_Rejection_Sub_Line_Item__c>();
        list<ContentVersion> lstContentVersions = new list<ContentVersion>();
        list<ContentDocumentLink> lstContentDocumentLink = new list<ContentDocumentLink>(); 
        list<ETT_TyreInspectionCardWrapper.FileWrapper> lstExistingFileWrapper = new list<ETT_TyreInspectionCardWrapper.FileWrapper>();
        list<ETT_TyreInspectionCardWrapper.FileWrapperNTC> lstExistingFileWrapperNTC = new list<ETT_TyreInspectionCardWrapper.FileWrapperNTC>();
        if(objInsectionSkill.lstTyreRejectionLineItems!=null && objInsectionSkill.lstTyreRejectionLineItems.size()>0){
            for(ETT_TyreInspectionCardWrapper.TyreRejectionLineItem objTyreRejectionLineItem :objInsectionSkill.lstTyreRejectionLineItems){
                System.debug('objTyreRejectionLineItem: '+objTyreRejectionLineItem);
                System.debug('goodCondition: '+objTyreRejectionLineItem.goodCondition);
                System.debug('goodCondition: '+objTyreRejectionLineItem.strBeadwireloosening);
                System.debug('cuts: '+objTyreRejectionLineItem.strCuts);
                if(objTyreRejectionLineItem.goodCondition=='No'){
                    ETT_Tyre_Rejection_Line_Item__c objTyreRejectionLine = new ETT_Tyre_Rejection_Line_Item__c();
                    objTyreRejectionLine.ETT_Inspection_Card__c = objInsepctionCard.Id;
                    objTyreRejectionLine.ETT_Good_Condition__c  = objTyreRejectionLineItem.goodCondition;
                    objTyreRejectionLine.Name = objTyreRejectionLineItem.tyreRejectionName;
                    objTyreRejectionLine.Bead_wire_loosening__c = objTyreRejectionLineItem.strBeadwireloosening == null ? false :objTyreRejectionLineItem.strBeadwireloosening;
                    objTyreRejectionLine.Bead_bundle_crack__c = objTyreRejectionLineItem.strBeadBundleCrack == null ? false :objTyreRejectionLineItem.strBeadBundleCrack;
                    objTyreRejectionLine.Turn_up_Chafour_Loose__c = objTyreRejectionLineItem.strBeadTurnupChafourLoose == null ? false :objTyreRejectionLineItem.strBeadTurnupChafourLoose;
                    objTyreRejectionLine.Hard_Bead__c = objTyreRejectionLineItem.strBeadHardBead == null ? false :objTyreRejectionLineItem.strBeadHardBead;
                   
                    objTyreRejectionLine.Spot__c = objTyreRejectionLineItem.strTyreInteriorSpot == null ? false : objTyreRejectionLineItem.strTyreInteriorSpot;
                    objTyreRejectionLine.Extended__c = objTyreRejectionLineItem.strTyreInteriorExtended== null ? false :objTyreRejectionLineItem.strTyreInteriorExtended ;
                    objTyreRejectionLine.Not_Repairable__c = objTyreRejectionLineItem.strTyreInteriorNotRepairable== null ? false :objTyreRejectionLineItem.strTyreInteriorNotRepairable ;
                 	
                    objTyreRejectionLine.Cut__c = objTyreRejectionLineItem.strCuts == null ? '0' :objTyreRejectionLineItem.strCuts;
                    objTyreRejectionLine.Nail_Punctures__c = objTyreRejectionLineItem.strNailPun == null ? '0' :objTyreRejectionLineItem.strNailPun;
                   //Added below lines by Janardhan - 16.12.2021
                    if(objTyreRejectionLineItem.tyreRejectionName == 'CrownArea'){
                    objTyreRejectionLine.Buttress_Crack_Shoulder_Crack__c=objTyreRejectionLineItem.Buttress_Crack_Shoulder_Crack;
                    objTyreRejectionLine.Strain_Mark__c=objTyreRejectionLineItem.Strain_Mark;
                    objTyreRejectionLine.Groove_Channel_Crack__c=objTyreRejectionLineItem.Groove_Channel_Crack;
                    objTyreRejectionLine.Thread_wornout__c= objTyreRejectionLineItem.Thread_wornout;
                    objTyreRejectionLine.Uneven_Wear__c= objTyreRejectionLineItem.Uneven_Wear;
                    objTyreRejectionLine.Excessive_One_sided_Wear__c= objTyreRejectionLineItem.Excessive_One_sided_Wear;
                    objTyreRejectionLine.Steer_Axle_Rpd_Shoulder_Wear_1_Shoulder__c= objTyreRejectionLineItem.Steer_Axle_Rpd_Shoulder_Wear_1_Shoulder;   
                    objTyreRejectionLine.Steer_Axle_Rpd_Shuldr_Wear_Both_Shoulder__c= objTyreRejectionLineItem.Steer_Axle_Rpd_Shuldr_Wear_Both_Shoulder;   
                    objTyreRejectionLine.Drive_Axle_Rpd_Shoulder_Wear_1_Shoulder__c= objTyreRejectionLineItem.Drive_Axle_Rpd_Shoulder_Wear_1_Shoulder;   
                    objTyreRejectionLine.Drive_Axle_Rpd_Shuldr_Wear_Both_Shoulder__c= objTyreRejectionLineItem.Drive_Axle_Rpd_Shuldr_Wear_Both_Shoulder;   
                    objTyreRejectionLine.Trailer_Axle_Rpd_Shulder_Wear_1_Shoulder__c= objTyreRejectionLineItem.Trailer_Axle_Rpd_Shulder_Wear_1_Shoulder;   
                    objTyreRejectionLine.Trailer_Axle_Rpd_Shuldr_Wear_Both_Shlder__c= objTyreRejectionLineItem.Trailer_Axle_Rpd_Shuldr_Wear_Both_Shlder;   

                    objTyreRejectionLine.Approval_Status__c = objTyreRejectionLineItem.Approval_Status;
                    }
                    if(objTyreRejectionLineItem.cuts_0_to_10!=null && objTyreRejectionLineItem.cuts_0_to_10.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_0_to_10){
                            objTyreRejectionLine.ETT_Number_of_cuts_0_10_mm__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        }
                    }
                    if(objTyreRejectionLineItem.cuts_11_to_25!=null && objTyreRejectionLineItem.cuts_11_to_25.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_11_to_25){
                            objTyreRejectionLine.ETT_Number_of_cuts_11_to_25_mm__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        }
                    }
                    if(objTyreRejectionLineItem.cuts_26_to_38!=null && objTyreRejectionLineItem.cuts_26_to_38.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_26_to_38){
                            objTyreRejectionLine.ETT_Number_of_cuts_26_to_38_mm__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        }
                    }
                    if(objTyreRejectionLineItem.cuts_39_to_50!=null && objTyreRejectionLineItem.cuts_39_to_50.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_39_to_50){
                            objTyreRejectionLine.ETT_Number_of_cuts_39_to_50_mm__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        }
                    }
                    if(objTyreRejectionLineItem.cuts_51!=null && objTyreRejectionLineItem.cuts_51.size()>0){
                        for(ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj:objTyreRejectionLineItem.cuts_51){
                            objTyreRejectionLine.ETT_Number_of_cuts_51_mm_and_above__c = Decimal.valueOf(obj.selectedValue);
                            if(obj.file!=null && obj.file.size()>0){
                                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :obj.file){
                                    ContentVersion objContentVersion = new ContentVersion();
                                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                        objContentVersion.Title = objFileWrapper.strFileName;
                                        objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                        objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                        lstContentVersions.add(objContentVersion);  
                                        lstExistingFileWrapperNTC.add(objFileWrapper);
                                        
                                    }
                                    system.debug('****lstExistingFileWrapperNTC*****'+lstExistingFileWrapperNTC);
                                }
                            }
                        } 
                    }
                    if(Schema.SObjectType.ETT_Tyre_Rejection_Line_Item__c.getRecordTypeInfosByName().get(objTyreRejectionLineItem.strRecordTypeName).getRecordTypeId()!=null)
                        objTyreRejectionLine.RecordTypeId = Schema.SObjectType.ETT_Tyre_Rejection_Line_Item__c.getRecordTypeInfosByName().get(objTyreRejectionLineItem.strRecordTypeName).getRecordTypeId();
                    lstTyreRejectionLineItem.add(objTyreRejectionLine);
                }
            }
            
        }
        try{
            List<ETT_Tyre_Rejection_Line_Item__c> lstDeleteOldTyres = [SELECT Id,Name,ETT_Good_Condition__c,ETT_Inspection_Card__c,(select Id,Name,ETT_Status__c from Tyre_Rejection_Sub_Line_Items__r) 
                                                                       FROM ETT_Tyre_Rejection_Line_Item__c where ETT_Inspection_Card__c=:objInsepctionCard.Id];
            if(lstDeleteOldTyres!=null && lstDeleteOldTyres.size()>0){
                delete lstDeleteOldTyres;	                    
            }
        }catch(Exception ex){
            system.debug('****Exception ****'+ex.getMessage());
        }
        system.debug('*****lstTyreRejectionLineItem***'+lstTyreRejectionLineItem);
        if(lstTyreRejectionLineItem!=null && lstTyreRejectionLineItem.size()>0){
            try{
                insert lstTyreRejectionLineItem;
                for(ETT_Tyre_Rejection_Line_Item__c vItm : lstTyreRejectionLineItem){
                    if(vItm.Name == 'CrownArea' || vItm.Name == 'TyreInterior'){
                		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        			 	req1.setComments('Submitting request');
        			 	req1.setObjectId(vItm.id);
                     	Approval.ProcessResult result = Approval.process(req1);
                    }
            	}

        // Submit the approval request for the Opportunity
       
            }Catch(Exception ex){
                system.debug('****Exception ****'+ex.getMessage());
            }
            
        }
        
        system.debug('*****After lstTyreRejectionLineItem****'+lstTyreRejectionLineItem);
        map<string,string> mapOfRejectionNamewithId = new map<string,string>();
        if(lstTyreRejectionLineItem!=null && lstTyreRejectionLineItem.size()>0){
            for(ETT_Tyre_Rejection_Line_Item__c objRejectionLineItem :lstTyreRejectionLineItem){
                system.debug('*****objRejectionLineItem Name****'+objRejectionLineItem.Name);
                mapOfRejectionNamewithId.put(objRejectionLineItem.Name,objRejectionLineItem.Id); 
            }
            system.debug('*****mapOfRejectionNamewithId****'+mapOfRejectionNamewithId);
            if(objInsectionSkill.lstTyreRejectionLineItems!=null && objInsectionSkill.lstTyreRejectionLineItems.size()>0){
                for(ETT_TyreInspectionCardWrapper.TyreRejectionLineItem objTyreRejectionLineItem :objInsectionSkill.lstTyreRejectionLineItems){
                    if(objTyreRejectionLineItem.lstTyreRejectionSubLineItems!=null && objTyreRejectionLineItem.lstTyreRejectionSubLineItems.size()>0){
                        for(ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem objSubLineItem :objTyreRejectionLineItem.lstTyreRejectionSubLineItems){
                            system.debug('*****objSubLineItem*****'+objSubLineItem);
                            system.debug('*****objSubLineItem*****'+objSubLineItem.strNOC);
                             system.debug('*****objSubLineItem*****'+objSubLineItem.strNOS);
                             system.debug('*****objSubLineItem*****'+objSubLineItem.strSOS1);
                             system.debug('*****objSubLineItem*****'+objSubLineItem.strSOS2);
                            if(objTyreRejectionLineItem.goodCondition!='Yes'){
                                
                                ETT_Tyre_Rejection_Sub_Line_Item__c objTyreRejectionSubLine = new ETT_Tyre_Rejection_Sub_Line_Item__c();
                                objTyreRejectionSubLine.ETT_Cause_Of_Rejection__c = objSubLineItem.strCauseOfRejection;
                                objTyreRejectionSubLine.ETT_Other_Comments__c = objSubLineItem.strOtherComments;
                                objTyreRejectionSubLine.ETT_Recommendations__c = objSubLineItem.strRecommendations;
                                objTyreRejectionSubLine.ETT_Other_Comment_By_Tech__c = objSubLineItem.OtherCommentByTech;
                                objTyreRejectionSubLine.Percentage__c = objSubLineItem.strPercentage;
                                objTyreRejectionSubLine.No_of_Cuts__c = objSubLineItem.strNOC;
                                objTyreRejectionSubLine.No_of_Separation__c = objSubLineItem.strNOS;
                                objTyreRejectionSubLine.Size_of_Separation_1__c = objSubLineItem.strSOS1;
                                objTyreRejectionSubLine.Size_of_Separation_2__c = objSubLineItem.strSOS2;
                                objTyreRejectionSubLine.Size_of_Separation_3__c = objSubLineItem.strSOS3;
                                objTyreRejectionSubLine.Size_of_Separation_4__c = objSubLineItem.strSOS4;
                                objTyreRejectionSubLine.Size_of_Separation_5__c = objSubLineItem.strSOS5;
                                objTyreRejectionSubLine.Size_of_Separation_6__c = objSubLineItem.strSOS6; 
                                objTyreRejectionSubLine.Size_of_Separation_7__c = objSubLineItem.strSOS7;
                                objTyreRejectionSubLine.Size_of_Separation_8__c = objSubLineItem.strSOS8;
                                objTyreRejectionSubLine.Size_of_Separation_9__c = objSubLineItem.strSOS9;
                                objTyreRejectionSubLine.Size_of_Separation_10__c = objSubLineItem.strSOS10;
                                objTyreRejectionSubLine.ETT_Status__c = objSubLineItem.strStatus;
                                objTyreRejectionSubLine.Name = objSubLineItem.strRejectionName;
                                system.debug('*****Rejection Name*****'+objSubLineItem.strRejectionName);
                                  system.debug('*****Percentage__c *****'+objSubLineItem.strRejectionName);
                                if(mapOfRejectionNamewithId.containsKey(objTyreRejectionLineItem.tyreRejectionName)){
                                    objTyreRejectionSubLine.ETT_Tyre_Rejection_Line_Item__c  =  mapOfRejectionNamewithId.get(objTyreRejectionLineItem.tyreRejectionName);
                                }//strStatus
                                lstTyreRejectionSubLineItems.add(objTyreRejectionSubLine);
                                if(objSubLineItem.strStatus=='Rejected' && objSubLineItem.lstFileWrapperDetails!=null && objSubLineItem.lstFileWrapperDetails.size()>0){
                                    for(ETT_TyreInspectionCardWrapper.FileWrapper objFileWrapper :objSubLineItem.lstFileWrapperDetails){
                                        ContentVersion objContentVersion = new ContentVersion();
                                        if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!='' && objFileWrapper.strRejectionName!=''){
                                            objContentVersion.Title = objFileWrapper.strFileName;
                                            objContentVersion.PathOnClient = objFileWrapper.strFileType;
                                            objContentVersion.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                                            lstContentVersions.add(objContentVersion);  
                                            lstExistingFileWrapper.add(objFileWrapper);
                                            
                                        }
                                        system.debug('****lstExistingFileWrapper*****'+lstExistingFileWrapper);
                                    }
                                }
                            }
                        } 
                    }
                    
                }
                
            }
            
            if(lstTyreRejectionSubLineItems!=null && lstTyreRejectionSubLineItems.size()>0){
                try{
                    insert lstTyreRejectionSubLineItems;
                    for(ETT_Tyre_Rejection_Sub_Line_Item__c vItm : lstTyreRejectionSubLineItems){
                     System.debug('vItm.Name--->'+vItm.Name);
                     if(vItm.Name == 'Cuts and Snags' || vItm.Name == 'Aging Crack/Weathering' || vItm.Name == 'Sidewall Separation' || vItm.Name == 'Kinked/Distorted Beads Condition'){
                       try {
                		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        			 	req1.setComments('Submitting request');
        			 	req1.setObjectId(vItm.id);
                     	Approval.ProcessResult result = Approval.process(req1);
                       }Catch(Exception ex){
                    		
                    		system.debug('***lstTyreRejectionSubLineItems error message-->'+ex.getMessage());
                		}
                    }
                    }
                    
                    
                }Catch(Exception ex){
                    system.debug('***lstTyreRejectionSubLineItems*****'+lstTyreRejectionSubLineItems);
                    system.debug('***lstTyreRejectionSubLineItems error message-->'+ex.getMessage());
                }
                
            }
            
            system.debug('*****lstTyreRejectionSubLineItems****'+lstTyreRejectionSubLineItems);
            
            map<string,string> mapofTyreRejectionNamewithId = new map<string,string>();
            map<string,string> mapofContentVersionIdswithDocId = new map<string,string>();
            
            if(lstTyreRejectionSubLineItems!=null && lstTyreRejectionSubLineItems.size()>0){
                for(ETT_Tyre_Rejection_Sub_Line_Item__c objTyreRejectionSub :lstTyreRejectionSubLineItems){
                    mapofTyreRejectionNamewithId.put(objTyreRejectionSub.Name,objTyreRejectionSub.Id);
                } 
            } 
            
            system.debug('****mapofTyreRejectionNamewithId****'+mapofTyreRejectionNamewithId);
            
            if(lstContentVersions!=null && lstContentVersions.size()>0)
            {
                try{
                    insert lstContentVersions;
                }Catch(Exception ex){
                    system.debug('****Exception Cause'+ex.getMessage());
                }
            }
            
            system.debug('****lstContentVersions****'+lstContentVersions);
            
            if(lstContentVersions!=null && lstContentVersions.size()>0){
                for(ContentVersion objContentVersion :[Select Id,ContentDocumentId,Title from ContentVersion where Id in :lstContentVersions]){
                    mapofContentVersionIdswithDocId.put(objContentVersion.Title,objContentVersion.ContentDocumentId);
                }  
            } 
            
            if(lstExistingFileWrapper!=null && lstExistingFileWrapper.size()>0){
                for(ETT_TyreInspectionCardWrapper.FileWrapper objFileWrapper :lstExistingFileWrapper){
                    ContentDocumentLink  objContentDocLink = new ContentDocumentLink ();
                    system.debug('****objFileWrapper.strRejectionName****'+objFileWrapper.strRejectionName);
                    system.debug('****objFileWrapper.strRejectionName****'+mapofTyreRejectionNamewithId.containsKey(objFileWrapper.strRejectionName));
                    if(mapofTyreRejectionNamewithId.containskey(objFileWrapper.strRejectionName)){
                        objContentDocLink.LinkedEntityId = mapofTyreRejectionNamewithId.get(objFileWrapper.strRejectionName);
                    }
                    if(mapofContentVersionIdswithDocId.containskey(objFileWrapper.strFileName)){
                        objContentDocLink.ContentDocumentId = mapofContentVersionIdswithDocId.get(objFileWrapper.strFileName);
                    }
                    
                    objContentDocLink.shareType = 'V';
                    lstContentDocumentLink.add(objContentDocLink);
                } 
            }
            
            if(lstExistingFileWrapperNTC!=null && lstExistingFileWrapperNTC.size()>0){
                for(ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapper :lstExistingFileWrapperNTC){
                    ContentDocumentLink  objContentDocLink = new ContentDocumentLink ();
                    system.debug('****objFileWrapper.strRejectionName****'+objFileWrapper.strRejectionName);
                    system.debug('****objFileWrapper.strRejectionName****'+mapofTyreRejectionNamewithId.containsKey(objFileWrapper.strRejectionName));
                    
                    if(mapOfRejectionNamewithId.containskey(objFileWrapper.strRejectionName)){
                        objContentDocLink.LinkedEntityId = mapOfRejectionNamewithId.get(objFileWrapper.strRejectionName);
                    }
                    if(mapofContentVersionIdswithDocId.containskey(objFileWrapper.strFileName)){
                        objContentDocLink.ContentDocumentId = mapofContentVersionIdswithDocId.get(objFileWrapper.strFileName);
                    }
                    
                    objContentDocLink.shareType = 'V';
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
            
            system.debug('***lstContentDocumentLink*****'+lstContentDocumentLink);
            system.debug('****mapofContentVersionIdswithDocId****'+mapofContentVersionIdswithDocId);
            system.debug('****lstContentVersions****'+lstContentVersions);
            system.debug('****lstContentVersions****'+lstContentVersions.size());
            system.debug('****lstExistingFileWrapper***'+lstExistingFileWrapper);
            system.debug('****lstExistingFileWrapper***'+lstExistingFileWrapper.size());
            if((objInsepctionCard.ETT_Status__c=='Accept' || objInsepctionCard.ETT_Status__c=='Send Back') &&  partyType=='Supplier'){
                list<ETT_Tyre_Inventory__c> lstTyreInventory = [select Id,RecordTypeId from ETT_Tyre_Inventory__c
                                                                where ETT_Tyre_Inspection_Card__c=:objInsepctionCard.Id];
                list<ETT_Pricing_Information__c> lstPricingInfo = [select Id,ETT_Purchase_Price__c,ETT_Brand__c,ETT_Country_of_Origin__c,
                                                                   ETT_Pattern__c,ETT_Price__r.ETT_Party_Name__c,
                                                                   ETT_Minimum_Price__c,ETT_Maximum_Price__c,ETT_Tyre_Size__c
                                                                   from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c=:
                                                                   objInsepctionCard.ETT_Account__c and ETT_Brand__c=:objInsepctionCard.ETT_Brand__c
                                                                   and ETT_Country_of_Origin__c=:objInsepctionCard.ETT_Country__c and 
                                                                   ETT_Pattern__c=:objInsepctionCard.ETT_Pattern__c and ETT_Tyre_Size__c=:objInsepctionCard.ETT_Tyre_Size__c
                                                                  ];
                if(lstTyreInventory!=null && lstTyreInventory.size()>0){
                    lstTyreInventory[0].RecordTypeId = Schema.SObjectType.ETT_Tyre_Inventory__c.getRecordTypeInfosByDeveloperName().get('ETT_Inspected_Inventory').getRecordTypeId();
                    lstTyreInventory[0].ETT_Tyre_Inspection_Card__c = objInsepctionCard.Id;
                    try{
                        update lstTyreInventory;
                    }Catch(Exception ex){
                        system.debug('***Exception cause ****'+ex.getMessage());
                    }
                    
                }
                
                
                
                /* if(lstPricingInfo!=null && lstPricingInfo.size()>0){
ETT_Estimate_Quotation__c objEstimation = new ETT_Estimate_Quotation__c();
objEstimation.ETT_Min_Range__c = lstPricingInfo[0].ETT_Minimum_Price__c;
objEstimation.ETT_Max_Range__c = lstPricingInfo[0].ETT_Maximum_Price__c;
objEstimation.ETT_Account__c = lstPricingInfo[0].ETT_Price__r.ETT_Party_Name__c;
objEstimation.ETT_Tyre_Inspection_Card__c = objInsepctionCard.Id;
objEstimation.ETT_Brand__c = lstPricingInfo[0].ETT_Brand__c;
objEstimation.ETT_Country_of_Origin__c = lstPricingInfo[0].ETT_Country_of_Origin__c;
objEstimation.ETT_Pattern__c = lstPricingInfo[0].ETT_Pattern__c;
objEstimation.ETT_Tyre_Size__c = lstPricingInfo[0].ETT_Tyre_Size__c;
objEstimation.ETT_Work_Order_Line_Item__c = objInsepctionCard.ETT_Collection_Line_Item__c;
objEstimation.ETT_Quantity__c = 1;
if(objInsepctionCard.ETT_Status__c=='Accept')
objEstimation.ETT_Price__c = lstPricingInfo[0].ETT_Purchase_Price__c;
else if(objInsepctionCard.ETT_Status__c=='Send Back'){
objEstimation.ETT_Price__c = 0;
}
try
{
insert objEstimation;
}  Catch(Exception ex){
system.debug('***Exception cause ****'+ex.getMessage()); 
}
}*/
            }
        }  
        
        
        return objInsepctionCard.Id;
    }
    
    
    @AuraEnabled
    public static List < String > getselectOptions() {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = ETT_Inspection_Card__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values =
            fieldMap.get('ETT_Tyre_Life__c').getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    
    @AuraEnabled
    public static List<ETT_Tyre_Master__c> getNewTyreDetailsfromIC(string recordId){
        
        List<ETT_Tyre_Master__c> lstTyreMaster = [select Id,Name,ETT_Tyre_Inspection_Card__c,ETT_Tyre_Size__r.Name, ETT_Brand_Name__r.Name, ETT_Original_Pattern__r.Name ,ETT_Country_Name__r.Name 
                                                  from ETT_Tyre_Master__c where ETT_Tyre_Inspection_Card__c=:recordId and RecordType.Name='Draft'];
        
        if(lstTyreMaster!=null && lstTyreMaster.size()>0){
            return lstTyreMaster;
        }else{
            return null;
        }
        
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
            }
        }
        
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
                    obj.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Approved').getRecordTypeId();
                    lstSobjectInformation.add(obj);
                }
            }
        }
        
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
                upsert lstSobjectInformation;
            }catch(Exception ex){
                System.debug('Exception : '+ex.getMessage());
            }
        }
        
    }
  
    
}