/*
Created Date:08/28/2020
Created By:G.Krishnareddy
Description:This is for Confimed by FM Acceptance for Estimation for collection Card.
*/
public class ETT_EstimationController {
    
    //Get the estimation records
    @Auraenabled 
    public static list<ETT_Estimate_Quotation__c> /*Map<string,List<ETT_Estimate_Quotation__c>>*/ lstEstimationsInfo(Id collectionCardId){
        /*
        List<ETT_Estimate_Quotation__c> lstEstimations = [select Id,ETT_Collection_Card__r.ETT_Accounts__r.Name,ETT_Collection_Card__r.Name,ETT_Accept_Quotation__c,ETT_Work_Order_Line_Item__r.ETT_Collection_Card__r.Name,ETT_Tyre_Size__r.Name,ETT_Brand__r.Name,ETT_Account__r.ETT_Email__c,ETT_Contact__r.LastName,ETT_Country_of_Origin__r.Name,ETT_Max_Range__c,ETT_Min_Range__c,ETT_Pattern__r.Name,ETT_Price__c,ETT_Quantity__c,ETT_Tyre_Inspection_Card__c,ETT_Tyre_Inspection_Card__r.Name,ETT_Tyre_Serial_Number__c,ETT_Work_Order_Line_Item__c,
                                                          ETT_Brand__r.ETT_Brand_Code__c,ETT_Account__r.Name,ETT_Account__r.Fax,ETT_Account__r.Phone,ETT_Account__r.ShippingStreet,ETT_Account__r.BillingStreet,ETT_Work_Order_Line_Item__r.ETT_Collection_Card__c from ETT_Estimate_Quotation__c where ETT_Collection_Card__c=:collectionCardId and /*ETT_Accept_Quotation__c=false and*//* ETT_Collection_Card__r.ETT_Inspection_Done__c=true];
		
        Map<string,List<ETT_Estimate_Quotation__c>> estMap = new Map<string,List<ETT_Estimate_Quotation__c>>();
        String key;
        if(lstEstimations!=null && lstEstimations.size()>0){
            for(ETT_Estimate_Quotation__c est:lstEstimations){
                key = 'TU-'+est.ETT_Tyre_Size__r.Name+'-'+est.ETT_Brand__r.ETT_Brand_Code__c;
                if(estMap.containskey(key)){
                    List<ETT_Estimate_Quotation__c> lstExistingEstimations = new List<ETT_Estimate_Quotation__c>();
                    lstExistingEstimations = estMap.get(key);
                    lstExistingEstimations.add(est);
                    estMap.put(key,lstExistingEstimations);
                }else{
                    List<ETT_Estimate_Quotation__c> lstEst = new List<ETT_Estimate_Quotation__c>();
                    lstEst.add(est);
                    estMap.put(key,lstEst);
                }
            }
        }
        return estMap;
        */
        return [select Id,ETT_Collection_Card__r.ETT_Accounts__r.Name,ETT_Collection_Card__r.Name,ETT_Accept_Quotation__c,ETT_Work_Order_Line_Item__r.ETT_Collection_Card__r.Name,ETT_Tyre_Size__r.Name,ETT_Brand__r.Name,ETT_Account__r.ETT_Email__c,ETT_Contact__r.LastName,ETT_Country_of_Origin__r.Name,ETT_Max_Range__c,ETT_Min_Range__c,ETT_Pattern__r.Name,ETT_Price__c,ETT_Quantity__c,ETT_Tyre_Inspection_Card__c,ETT_Tyre_Inspection_Card__r.Name,ETT_Tyre_Serial_Number__c,ETT_Work_Order_Line_Item__c,
               ETT_Brand__r.ETT_Brand_Code__c,ETT_Account__r.Name,ETT_Account__r.Fax,ETT_Account__r.Phone,ETT_Account__r.ShippingStreet,ETT_Account__r.BillingStreet,ETT_Work_Order_Line_Item__r.ETT_Collection_Card__c from ETT_Estimate_Quotation__c where ETT_Collection_Card__c=:collectionCardId and /*ETT_Accept_Quotation__c=false and*/ ETT_Collection_Card__r.ETT_Inspection_Done__c=true];
    }
    
    //Estimations confirmation details 
    //Modified By:Janardhan  
    @AuraEnabled
    public static string estimationConfirmation(list<ETT_Estimate_Quotation__c> lstEstimationQuotations){
        ETT_Purchase_Order__c objPurchaseOrder;
        if(lstEstimationQuotations!=null && lstEstimationQuotations.size()>0){
            try{
                System.debug('lstEstimationQuotations: '+lstEstimationQuotations);
                update lstEstimationQuotations;
                
                boolean isHOO = userinfo.getUserId().contains(system.label.ETT_InspectionCriteria_HOO);
                boolean isFM = userinfo.getUserId().contains(system.label.ETT_InspectionCriteria_FM);
                system.debug('****isHOO***'+isHOO);
                system.debug('****isFM***'+isFM);
                if(isHOO || Test.isRunningTest()){
                    lstEstimationQuotations = [select Id,ETT_Status__c,ETT_Tyre_Inspection_Card__c,ETT_Brand__c,ETT_Tyre_Size__c,ETT_Tyre_Inspection_Card__r.ETT_Status__c,ETT_Collection_Card__r.ETT_Accounts__c,ETT_Collection_Card__c,ETT_Price__c,ETT_Quantity__c,ETT_Accept_Quotation__c,ETT_Tyre_Size__r.Name,ETT_Brand__r.ETT_Brand_Code__c,ETT_Account__r.ETT_Email__c,
                                               ETT_Account__c,ETT_Collection_Card__r.ETT_Accounts__r.Fax,ETT_Collection_Card__r.ETT_Accounts__r.ETT_Email__c,ETT_Collection_Card__r.ETT_Accounts__r.Phone,ETT_Collection_Card__r.ETT_Accounts__r.ShippingStreet,ETT_Collection_Card__r.ETT_Accounts__r.BillingStreet from ETT_Estimate_Quotation__c where id in :lstEstimationQuotations
                                               and ETT_Accept_Quotation__c=true];
                        /*[select Id,ETT_Collection_Card__c,ETT_Quantity__c,ETT_Accept_Quotation__c,ETT_Tyre_Size__r.Name,ETT_Brand__r.ETT_Brand_Code__c,ETT_Account__r.ETT_Email__c,
                                               ETT_Account__r.Fax,ETT_Account__r.Phone,ETT_Account__r.ShippingStreet,ETT_Account__r.BillingStreet from ETT_Estimate_Quotation__c where id in :lstEstimationQuotations
                                               and ETT_Accept_Quotation__c=false];*/
                    
                    ETT_Collection_Card__c objCollectioCard = new ETT_Collection_Card__c();
                    objCollectioCard.Id = lstEstimationQuotations[0].ETT_Collection_Card__c;
                    objCollectioCard.ETT_Head_Of_Operation_Approved__c = True;
                    objCollectioCard.ETT_Estimation_Completed_By_HOO__c = true;
                    update objCollectioCard;
                }
                if(isFM || Test.isRunningTest()){
                    lstEstimationQuotations = [select Id,ETT_Status__c,ETT_Tyre_Inspection_Card__c,ETT_Brand__c,ETT_Tyre_Size__c,ETT_Tyre_Inspection_Card__r.ETT_Status__c,ETT_Collection_Card__r.ETT_Accounts__c,ETT_Collection_Card__c,ETT_Price__c,ETT_Quantity__c,ETT_Accept_Quotation__c,ETT_Tyre_Size__r.Name,ETT_Brand__r.ETT_Brand_Code__c,ETT_Account__r.ETT_Email__c,
                                               ETT_Account__c,ETT_Collection_Card__r.ETT_Accounts__r.Fax,ETT_Collection_Card__r.ETT_Accounts__r.ETT_Email__c,ETT_Collection_Card__r.ETT_Accounts__r.Phone,ETT_Collection_Card__r.ETT_Accounts__r.ShippingStreet,ETT_Collection_Card__r.ETT_Accounts__r.BillingStreet from ETT_Estimate_Quotation__c where id in :lstEstimationQuotations
                                               and ETT_Accept_Quotation__c=true];
                    ETT_Collection_Card__c objCollectioCard = new ETT_Collection_Card__c();
                    objCollectioCard.Id = lstEstimationQuotations[0].ETT_Collection_Card__c;
                    objCollectioCard.ETT_Estimation_Completed_By_FM__c = True;
                    objCollectioCard.ETT_Factory_Manager_Approved__c = true;
                    update objCollectioCard;
                }
                
                system.debug('****lstEstimationQuotations****'+lstEstimationQuotations);
                system.debug(lstEstimationQuotations[0].ETT_Collection_Card__c);
                
                if(lstEstimationQuotations!=null && lstEstimationQuotations.size()>0 && 
                   lstEstimationQuotations[0].ETT_Collection_Card__c!=null){
                       //ETT_ProcessApprovelRequest.approveRecord(new ETT_Collection_Card__c(Id=lstEstimationQuotations[0].ETT_Collection_Card__c));
                  }
                
                list<ETT_Purchase_Order_Line_Item__c> lstPurchaseOrderLineItem = new list<ETT_Purchase_Order_Line_Item__c>();
                boolean isAccepedEsimation = false;
                map<string,Integer> mapofItemCodewithQuantity = new map<string,Integer>();
                Integer i=0;
                map<string,boolean> mapofTyreswithAcceptesCretria = new map<string,boolean>();
                map<string,ETT_Estimate_Quotation__c> mapofEstimationnotQualified = new map<string,ETT_Estimate_Quotation__c>();
                
                for(ETT_Estimate_Quotation__c objEstimation :lstEstimationQuotations){
                    
                    if(objEstimation.ETT_Accept_Quotation__c && objEstimation.ETT_Status__c=='Accepted'){
                        isAccepedEsimation= true;
                        iF(objEstimation.ETT_Tyre_Size__c!=null && objEstimation.ETT_Brand__c!=null){
                            mapofTyreswithAcceptesCretria.put(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c,false);
                            if(mapofItemCodewithQuantity.containsKey(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c)){
                                if(mapofItemCodewithQuantity.get(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c)!=null && objEstimation.ETT_Quantity__c!=null){
                                    mapofItemCodewithQuantity.put(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c,Integer.valueOf(mapofItemCodewithQuantity.get(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c)+objEstimation.ETT_Quantity__c)); 
                                }   
                            }else{
                                mapofItemCodewithQuantity.put(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c,Integer.valueOf(objEstimation.ETT_Quantity__c));
                            }
                        }
                        
                    }
                    
                    
                }
                system.debug('****mapofItemCodewithQuantity****'+mapofItemCodewithQuantity);
                
                if(isAccepedEsimation){
                    
                    objPurchaseOrder = new ETT_Purchase_Order__c();
                    objPurchaseOrder.ETT_Account__c = lstEstimationQuotations[0].ETT_Collection_Card__r.ETT_Accounts__c;
                    objPurchaseOrder.ETT_Collection_Card__c = lstEstimationQuotations[0].ETT_Collection_Card__c;
                    objPurchaseOrder.ETT_Accepted_by_FM__c = true;
                    objPurchaseOrder.ETT_Accepted_by_HOO__c = true;
                    objPurchaseOrder.ETT_Address__c = lstEstimationQuotations[0].ETT_Collection_Card__r.ETT_Accounts__r.BillingStreet;
                    objPurchaseOrder.ETT_Type__c = 'Standard Purchase Order';
                    //objPurchaseOrder.ETT_Status__c = 'Accepted';
                    objPurchaseOrder.ETT_Status__c = 'Draft';
                    objPurchaseOrder.ETT_Ship_To__c = lstEstimationQuotations[0].ETT_Collection_Card__r.ETT_Accounts__r.ShippingStreet;
                    objPurchaseOrder.ETT_Bill_To__c = lstEstimationQuotations[0].ETT_Collection_Card__r.ETT_Accounts__r.BillingStreet;
                    objPurchaseOrder.ETT_Phone__c  = lstEstimationQuotations[0].ETT_Collection_Card__r.ETT_Accounts__r.Phone;
                    objPurchaseOrder.ETT_Payment_Terms__c = 'Immediate';
                    objPurchaseOrder.ETT_Order_Creation_Date__c = Date.today();
                    objPurchaseOrder.ETT_Last_Approved_Date__c = date.today();
                    objPurchaseOrder.ETT_Fax__c = lstEstimationQuotations[0].ETT_Collection_Card__r.ETT_Accounts__r.Fax;
                    objPurchaseOrder.ETT_Email__c = lstEstimationQuotations[0].ETT_Collection_Card__r.ETT_Accounts__r.ETT_Email__c;
                    objPurchaseOrder.ETT_Effective_Start_Date__c = Date.today();
                    //objPurchaseOrder.recordTypeId = Schema.SObjectType.ETT_Purchase_Order__c.getRecordTypeInfosByName().get('Tyre - Cash Supplier Accept PO').getRecordTypeId();
                    
                    
                }
                system.debug('****objPurchaseOrder****'+objPurchaseOrder);
                if(objPurchaseOrder!=null ){
                    try{
                        insert objPurchaseOrder;
                    }catch(exception ex){
                        system.debug('*****objPurchaseOrder****'+ex.getMessage());
                    }
                    
                }
                
                for(ETT_Estimate_Quotation__c objEstimation :lstEstimationQuotations){
                    if(objEstimation.ETT_Accept_Quotation__c){
                        isAccepedEsimation= true;
                        system.debug('****objPurchaseOrder****'+objPurchaseOrder);
                        
                        
                     /*   //BLOCK:1 if u comment BLOCK:1 code then uncomment below BLOCK:2
                        ETT_Purchase_Order_Line_Item__c objPurchaseOrderLineItem = new ETT_Purchase_Order_Line_Item__c();
                        objPurchaseOrderLineItem.ETT_Purchase_Order__c = objPurchaseOrder.Id;
                        objPurchaseOrderLineItem.ETT_Quantity__c =mapofItemCodewithQuantity.get(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c);     
                        objPurchaseOrderLineItem.ETT_UOM__c = 'Numbers';
                        objPurchaseOrderLineItem.ETT_Vat_Percentage__c = '5%';
                        objPurchaseOrderLineItem.ETT_Unit_Price__c = objEstimation.ETT_Price__c;
                        objPurchaseOrderLineItem.ETT_Type__c = 'Goods';
                        objPurchaseOrderLineItem.ETT_Item__c = 'TU-'+objEstimation.ETT_Tyre_Size__r.Name+'-'+objEstimation.ETT_Brand__r.ETT_Brand_Code__c;
                        
                        objPurchaseOrderLineItem.ETT_Accepted_by_FM__c = true;
                        objPurchaseOrderLineItem.ETT_Accepted_by_HOO__c = true;
                        objPurchaseOrderLineItem.ETT_Delivery_Date__c = Date.today();
                        objPurchaseOrderLineItem.recordTypeId = Schema.SObjectType.ETT_Purchase_Order_Line_Item__c.getRecordTypeInfosByName().get('Tyre - Cash Supplier Accept PO Line').getRecordTypeId();
                        lstPurchaseOrderLineItem.add(objPurchaseOrderLineItem);
                        mapofTyreswithAcceptesCretria.put(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c,true);
                        //BLOCK:1  end*/
                        
                        
                        /* BLOCK:2 commented bcz sangeetha requested to create multiple POLI each for WOLI *///BLOCK:2 
                        if(objEstimation.ETT_Tyre_Size__c!=null && objEstimation.ETT_Brand__c!=null && objEstimation.ETT_Status__c=='Accepted'){
                            if(mapofItemCodewithQuantity.containskey(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c)
                               && mapofTyreswithAcceptesCretria.containskey(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c) && 
                               mapofTyreswithAcceptesCretria.get(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c)==false){
                                   ETT_Purchase_Order_Line_Item__c objPurchaseOrderLineItem = new ETT_Purchase_Order_Line_Item__c();
                                   objPurchaseOrderLineItem.ETT_Purchase_Order__c = objPurchaseOrder.Id;
                                   objPurchaseOrderLineItem.ETT_Quantity__c =mapofItemCodewithQuantity.get(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c);     
                                   objPurchaseOrderLineItem.ETT_UOM__c = 'Numbers';
                                   objPurchaseOrderLineItem.ETT_Vat_Percentage__c = '5%';
                                   objPurchaseOrderLineItem.ETT_Unit_Price__c = objEstimation.ETT_Price__c;
                                   objPurchaseOrderLineItem.ETT_Type__c = 'Goods';
                                   objPurchaseOrderLineItem.ETT_Item__c = 'TU-'+objEstimation.ETT_Tyre_Size__r.Name+'-'+objEstimation.ETT_Brand__r.ETT_Brand_Code__c;
                                   
                                   objPurchaseOrderLineItem.ETT_Accepted_by_FM__c = true;
                                   objPurchaseOrderLineItem.ETT_Accepted_by_HOO__c = true;
                                   objPurchaseOrderLineItem.ETT_Delivery_Date__c = Date.today();
                                   //objPurchaseOrderLineItem.recordTypeId = Schema.SObjectType.ETT_Purchase_Order_Line_Item__c.getRecordTypeInfosByName().get('Tyre - Cash Supplier Accept PO Line').getRecordTypeId();
                                   lstPurchaseOrderLineItem.add(objPurchaseOrderLineItem);
                                   mapofTyreswithAcceptesCretria.put(objEstimation.ETT_Tyre_Size__c+'-'+objEstimation.ETT_Brand__c,true);
                               }
                        }
                       
                        
                        
                        
                        
                    }
                }
                
                system.debug('****lstPurchaseOrderLineItem****'+lstPurchaseOrderLineItem);
                
                if(lstPurchaseOrderLineItem!=null && lstPurchaseOrderLineItem.size()>0){
                    try{
                        insert lstPurchaseOrderLineItem;
                        
                        list<ETT_Tyre_Inventory__c> lstTyreInventory = [select Id,RecordTypeId,RecordType.Name from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:lstPurchaseOrderLineItem[0].ETT_Purchase_Order__r.ETT_Collection_Card__c];
                        
                        if(lstTyreInventory!=null && lstTyreInventory.size()>0){
                            for(ETT_Tyre_Inventory__c objTyreInvetory :lstTyreInventory){
                                if(objTyreInvetory.RecordTypeId!=null && objTyreInvetory.RecordType.Name=='Inspected Inventory'){
                                    //objTyreInvetory.RecordTypeId = Schema.SObjectType.ETT_Tyre_Inventory__c.getRecordTypeInfosByName().get('Tyre Asset').getRecordTypeId();
                                }
                                
                            }
                            
                            //update lstTyreInventory;
                        }
                        //list<ETT_Delivery_Note__c> lstDeliveryNotes = new list<ETT_Delivery_Note__c>();
                        lstPurchaseOrderLineItem = [select Id,ETT_Purchase_Order__r.ETT_Collection_Card__c
                                                    from ETT_Purchase_Order_Line_Item__c where Id in :lstPurchaseOrderLineItem]; 
                        
                        list<ETT_Inspection_Card__c> lstTyreInspectionCards = [select Id,ETT_Account__c,ETT_Brand__c,ETT_Account__r.Phone,
                                                                               ETT_Account__r.BillingStreet,ETT_Status__c from ETT_Inspection_Card__c
                                                                               where ETT_Collection_Card__c=:lstPurchaseOrderLineItem[0].ETT_Purchase_Order__r.ETT_Collection_Card__c];
                        if(lstTyreInspectionCards!=null && lstTyreInspectionCards.size()>0){
                            for(ETT_Inspection_Card__c objInspectionCard :lstTyreInspectionCards){
                                /* ETT_Delivery_Note__c objDeliveryNote   = new ETT_Delivery_Note__c();
                                    objDeliveryNote.ETT_Account__c         = objInspectionCard.ETT_Account__c;
                                    objDeliveryNote.ETT_Address__c         = objInspectionCard.ETT_Account__r.BillingStreet;
                                    objDeliveryNote.ETT_Brand_Name__c      = objInspectionCard.ETT_Brand__c;
                                    objDeliveryNote.ETT_Casing__c          = 'Supplier Casing';
                                    objDeliveryNote.ETT_Collection_Card__c = objInspectionCard.ETT_Collection_Card__c;
                                    objDeliveryNote.ETT_Pattern_Size__c    = objInspectionCard.ETT_Pattern__c;
                                    objDeliveryNote.ETT_Phone__c           = objInspectionCard.ETT_Account__r.Phone;
                                    objDeliveryNote.ETT_Reference__c       = '';
                                    objDeliveryNote.ETT_Serial_Number__c   = objInspectionCard.ETT_Tyre_Serial_Number__c;
                                    objDeliveryNote.ETT_Tyre_Size__c       = objInspectionCard.ETT_Tyre_Size__c;
                                    objDeliveryNote.ETT_Vehicle_Number__c  = objInspectionCard.ETT_Collection_Card__r.ETT_Vehicle_Detail__r.Name;
                                    lstDeliveryNotes.add(objDeliveryNote);
                                    }*/
                                
                                    /* if(lstDeliveryNotes!=null && lstDeliveryNotes.size()>0){
                                    try{
                                    insert lstDeliveryNotes;
                                    }Catch(Exception ex){
                                    system.debug('****Exception Cause ****'+lstDeliveryNotes);
                                    }
                                    }*/
                            }
                        }
                    }Catch(Exception ex){
                        system.debug('****Exception Cause ***'+ex.getMessage());
                    }
                    
                }
                
                
            }Catch(Exception ex){
                system.debug('****Exception Cause ***'+ex.getMessage());
                throw new AuraHandledException(ex.getMessage());
            }
            
        }
        if(objPurchaseOrder!=null)
            return objPurchaseOrder.Id;
        else{
            return lstEstimationQuotations[0].ETT_Collection_Card__c;    
        }
    }
      @AuraEnabled
    public static List<ETT_Inspection_Card__c> getTyreDetailsAcc(Id accountId){
                
        Set<ID> CollCardIds = new Set<ID>();
        
        for(ETT_Collection_Card__c objcc : [SELECT Id, ETT_Accounts__c FROM ETT_Collection_Card__c where ETT_Accounts__c =:accountId]){
            CollCardIds.add(objcc.Id);
        }
        
                // return [select id,ETT_Collection_Card__c,ETT_Collection_Card__r.Name,Tyre_Inventory__c,Tyre_Inventory__r.Process_Type__c,Tyre_Inventory__r.Party_Type__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.Pricing_Information__r.ETT_Purchase_Price__c,Tyre_Inventory__r.Pricing_Information__r.ETT_Repair_Price__c,Tyre_Inventory__r.Pricing_Information__r.ETT_Retread_Price_H__c,Tyre_Inventory__r.Pricing_Information__r.ETT_Retread_Price_P__c,Tyre_Inventory__r.Job_Type__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__c,Tyre_Size__c,ETT_Collection_Card__r.ETT_Collection_Date__c,ETT_Status__c from ETT_Inspection_Card__c where Tyre_Inventory__r.Quotation_Created__c=false AND ETT_Collection_Card__c=:collCardId AND (ETT_Status__c ='Accept' OR ETT_Status__c='Send Back')];

      return [select id,Tyre_Inventory__r.Process_Type__c,Tyre_Inventory__r.Party_Type__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.Pricing_Information__r.ETT_Purchase_Price__c,Tyre_Inventory__r.Pricing_Information__r.ETT_Repair_Price__c,Tyre_Inventory__r.Pricing_Information__r.ETT_Retread_Price_H__c,Tyre_Inventory__r.Pricing_Information__r.ETT_Retread_Price_P__c,ETT_Collection_Card__c,ETT_Collection_Card__r.Name,Tyre_Inventory__c,Tyre_Inventory__r.Job_Type__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__c,Tyre_Size__c,ETT_Collection_Card__r.ETT_Collection_Date__c,ETT_Status__c from ETT_Inspection_Card__c where Tyre_Inventory__r.Quotation_Created__c=false AND ETT_Collection_Card__c=:CollCardIds AND (ETT_Status__c ='Accept' OR ETT_Status__c='Send Back')];
        
        //ETT_Tyre_Size_Master__c,ETT_Tyre_Size_Master__r.Name,ETT_Collection_Card__c,ETT_Collection_Card__r.Name,ETT_Collection_Date__c,Job_Type__c,
      /*  list<WorkOrderLineItem> filterList  = new list<WorkOrderLineItem>();

        List<WorkOrderLineItem> lstWOLI = [select Id,ETT_Tyre_Size_Name__c,ETT_Tyre_Size__c,ETT_Tyre_Size__r.Name,
                                           ETT_Collection_Card__c,ETT_Collection_Card__r.Name,ETT_Collection_Card__r.ETT_Collection_Date__c,ETT_Job_Type__c,(select Id,ETT_Status__c from Inspection_Cards__r ) from WorkOrderLineItem where ETT_Quotation_Line_Creation__c=false AND ETT_Collection_Card__c=:setIDCC];
        
        
        for(WorkOrderLineItem wol : lstWOLI){
            
            for(ETT_Inspection_Card__c ins : wol.Inspection_Cards__r){
                
                if(ins.ETT_Status__c=='Accept' || ins.ETT_Status__c=='Send Back'){
                    
                    filterList.add(wol);
                }
            }
            
        }
        system.debug('--'+filterList.size());
        return filterList;
        */
    }
    
    @AuraEnabled
    public static List<ETT_Inspection_Card__c>  getTyreDetails(Id collCardId){

        /** ---commented by Janardhan ----***
        Set<ID> setIDCC = new Set<ID>();
        List<ETT_Collection_Card__c> lstCC = [SELECT Id, ETT_Accounts__c FROM ETT_Collection_Card__c where ETT_Accounts__c =:accountId];
        if(lstCC!=null && lstCC.size()>0){
            for(ETT_Collection_Card__c objcc : lstCC){
                setIDCC.add(objcc.Id);
            }
        } ***/
        
        ETT_Collection_Card__c ettColl=   [select id,ETT_Accounts__c from ETT_Collection_Card__c  where id=:collCardId limit 1];
        system.debug('ettColl'+ettColl);
        return [select id,ETT_Collection_Card__c,ETT_Collection_Card__r.Name,Tyre_Inventory__c,Tyre_Inventory__r.Process_Type__c,Tyre_Inventory__r.Party_Type__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.Pricing_Information__r.ETT_Purchase_Price__c,Tyre_Inventory__r.Pricing_Information__r.ETT_Repair_Price__c,Tyre_Inventory__r.Pricing_Information__r.ETT_Retread_Price_H__c,Tyre_Inventory__r.Pricing_Information__r.ETT_Retread_Price_P__c,Tyre_Inventory__r.Job_Type__c,
                Tyre_Inventory__r.ETT_Tyre_Size_Master__c,Tyre_Size__c,ETT_Collection_Card__r.ETT_Collection_Date__c,
                ETT_Status__c from ETT_Inspection_Card__c where 
                Tyre_Inventory__r.Quotation_Created__c=false AND ETT_Collection_Card__r.ETT_Accounts__c=:ettColl.ETT_Accounts__c AND (ETT_Status__c ='Accept' OR ETT_Status__c='Send Back')];
        
       /* list<WorkOrderLineItem> filterList  = new list<WorkOrderLineItem>();
        List<WorkOrderLineItem> lstWOLI = [select Id,ETT_Tyre_Size_Name__c,ETT_Tyre_Size__c,ETT_Tyre_Size__r.Name,
                                           ETT_Collection_Card__c,ETT_Collection_Card__r.Name,ETT_Collection_Card__r.ETT_Collection_Date__c,ETT_Job_Type__c,(select Id,ETT_Status__c from Inspection_Cards__r where (ETT_Status__c='Accept' OR ETT_Status__c='Send Back')) from WorkOrderLineItem where ETT_Collection_Card__c=:accountId];
       
         for(WorkOrderLineItem wol : lstWOLI){
            
            for(ETT_Inspection_Card__c ins : wol.Inspection_Cards__r){
                
                if(ins.ETT_Status__c=='Accept' || ins.ETT_Status__c=='Send Back'){
                    
                    filterList.add(wol);
                }
            }
            
        }    
        
        return filterList;*/
        
    }
    
    @AuraEnabled
    public static List<ET_Tyre_Wallet__c> getTrafficFine(Id accountId){
        
        List<ET_Tyre_Wallet__c> lstTyreWallet = new List<ET_Tyre_Wallet__c>();
        List<Case> lstCase = [select Id from Case where AccountId = :accountId];
        Set<Id> lstId = new Set<Id>();
        
        if(lstCase!=null && lstCase.size()>0){
            for(Case obj:lstCase){
                lstId.add(obj.Id);
            }
        }
        
        if(lstId!=null && lstId.size()>0){
            lstTyreWallet = [select Id,CaseNumber__c,CaseNumber__r.CaseNumber,Adjustment__c,Status__c from ET_Tyre_Wallet__c where Status__c='Not Paid' and CaseNumber__c in :lstId];   
        }
        
        return lstTyreWallet;
        
    }
    
    
    @AuraEnabled
    public static void createQuotations(List<ETT_Quotation_Line_Item__c> lstQuotation,ID accountId,string Email,String KindAtten,double claimAmount,list<ET_Tyre_Wallet__c> selectedWallet){
       
        system.debug('List Quoteline'+lstQuotation);
        Savepoint sp = Database.setSavepoint();
        
        if(lstQuotation!=null && lstQuotation.size()>0){
            
            try{
                ETT_Quotation__c objQuot = new ETT_Quotation__c();
                objQuot.ETT_Account__c = accountId;
                objQuot.Email__c =Email;
                objQuot.Kind_Atten__c=KindAtten;
                objQuot.Claim_Amount__c=claimAmount;
                insert objQuot;
                
                //Update selected wallet to paid and map to Quotation
                if(selectedWallet!= null && selectedWallet.size()>0){
                    for(ET_Tyre_Wallet__c wal :selectedWallet){
                        wal.Quotation__c =objQuot.Id;
                    }
                    update selectedWallet;
                    
                }
                
                set<id> tyreInveIds = new set<id>();
                for(ETT_Quotation_Line_Item__c objQT : lstQuotation){
                    objQT.ETT_Quotation__c = objQuot.Id;
                    tyreInveIds.add(objQT.ETT_Tyre_Inventory__c);
                }
                insert lstQuotation;
                system.debug('--lstQu--'+lstQuotation);
                list<ETT_Tyre_Inventory__c> updateTyreInventory = new  list<ETT_Tyre_Inventory__c>();
                
              
                for(ETT_Tyre_Inventory__c ty : [select id,Quotation_Created__c from ETT_Tyre_Inventory__c where id=:tyreInveIds]){
                    
                    ty.Quotation_Created__c = true;
                    updateTyreInventory.add(ty);
                }
                update updateTyreInventory;
                
             /*** commented by Janardhan    
                //Sending Notification to HOO for Quotation Approval
                // Get the Id for our custom notification type
                CustomNotificationType notificationType = [SELECT Id, DeveloperName
                                                           FROM CustomNotificationType
                                                           WHERE DeveloperName='ETT_Notification'];
                
                // Create a new custom notification
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                
                // Set the contents for the notification
                notification.setTitle('A New Quotation is Generated');
                notification.setBody('A New Quotation is Generated');
                
                // Set the notification type and target
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(objQuot.Id);
                //PageReference orderPage = new PageReference('/ETT_Material_Requisition_Approval');
                //String pgRef = '{ type: "standard__navItemPage",attributes:{apiName:ETT_Material_Requisition_Approval}}';
                //notification.setTargetPageRef(pgRef);
                
                Set<String> addressee = new Set<String>();
                List<User> cashierUser =[SELECT Id, name,profile.name from user where profile.name='ETT_Head of Operations'];
                system.debug('cashierUser== '+cashierUser);
                addressee.add(cashierUser[0].Id);
                system.debug('notification=='+notification);
                // Actually send the notification
                try {
                    notification.send(addressee);
                }
                catch (Exception e) {
                    System.debug('Problem sending notification: ' + e.getMessage());
                }

                
                --**/
            }
            catch(Exception e){
                system.debug('---ca'+e.getCause());
                system.debug('----Line'+e.getLineNumber());
                system.debug('---Trac-'+e.getStackTraceString());
                system.debug('---Type-'+e.getTypeName());
                Database.rollback(sp);
                throw new AuraHandledException('Something went wrong: '+ e.getMessage());
               
            }
        }
    }
    
    
    @Auraenabled
    public static List<ETT_Quotation__c> getQuotationsForApproval(){
        
        List<ETT_Quotation__c> lstMR = [select Id, Name, ETT_Head_Of_Operation_Acceptance__c from ETT_Quotation__c where ETT_Head_Of_Operation_Acceptance__c='' order by Name];
        return lstMR;
        
    }
    
    @Auraenabled
    public static List<ETT_Quotation_Line_Item__c> getQuotationLineItems(Id Id){
        
        return [SELECT Id, Name, ETT_Tyre_Size_Name__c, ETT_Job_Type__c, ETT_Status__c,ETT_Unit_Price__c, ETT_Quantity__c, ETT_Total__c,ETT_Total_Price__c,ETT_Quotation__c FROM ETT_Quotation_Line_Item__c where ETT_Quotation__c=:Id];
        
    }
    
    
    @AuraEnabled 
    public static void sendMailMethodTest(String mMail ,String mSubject ,String mbody, String leadId,String folderId,String templateId ){
        
      /*  //public static void sendEmail(String emailTo, String emailCC, String emailSubject, String emailBody){
        //Flag to track whether email is sent successfully
        Boolean isSuccess = false;
        String emailBody;
        //Body of attachment in email. It can be replaced with standard sf attachment
        Blob body = Blob.valueOf('Sample Body for email attachment');
        
        //Creating email attachmentattachment specifying content type and file name   
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('text/plain');
        attach.setFileName('testAttachment.txt');
   
        //Setting attachment as non-inline attachment.
        attach.setInline(false);
        //Assigning blob to email body
        attach.Body = body;

        
        
        
    // Reference the attachment page, pass in the account ID
    PageReference pdf = Page.ETT_QuotationPDF;
    //pdf.getParameters().put('id',(String)account.id);
    pdf.setRedirect(true);

    // Take the PDF content
  //  Blob b = pdf.getContent();
    Blob b;
    if(!test.isRunningTest()){
      	b = pdf.getContent();
     }
     else{
        b=Blob.valueof('Test Class');
     }    
        

    // Create the email attachment
    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
    efa.setFileName('attachment.pdf');
    efa.setBody(b);





        
        //Creating singleEmailMessage object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        
        //Splitting TO email addresses and adding in array
       
         List<string> toAddresses = new List<string>();
        toAddresses.add(mMail);
        
        //Assigning TO address array
        mail.setToAddresses(toAddresses);
        
        //Splitting CC email addresses and adding in array
       
        //Assigning CC address array        
       // mail.setCCAddresses(ccAddresses);
        //Setting reply to email address
        //mail.setReplyTo('replyto email address');
        mail.setSubject(mSubject);
        //Setting content of the email
        mail.setPlainTextBody((emailBody==null?'This email body is empty':emailBody));
        //Optionally you can use below line to add HTML formatted body for email
        //mail.setHtmlBody('<h1>Dear User</h1>');
        //Assigning attachment to email
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
    
        //Sending email. If any execption occurs, it will be displayed in page
        try{
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
            if(results[0].success){
                isSuccess = TRUE;
            }else{
                isSuccess = FALSE;
            }
        } catch(Exception ex){
            isSuccess = FALSE;
        }
    //return isSuccess;
            
            
            
            
            
        /*
        List<string> toEmailAddress = new List<string>();
        toEmailAddress.add(mMail);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(toEmailAddress);
        email.setSubject(mSubject);
        email.setPlainTextBody(mbody);
        email.setHtmlBody(mbody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        */
        /*
        string leadName = '';
        String leadOwnerName = '' ;
        
        list<EmailTemplate> em = new list<EmailTemplate>();
        em = [SELECT Id,Subject,Body,HtmlValue From EmailTemplate where id =: templateId limit 1];
        
        if(leadId != null ){ 
            Lead ldObj = [select id,name,Owner.Name from Lead where Id =: leadId];
            leadName = ldObj.name;
            if(ldObj.Owner.Name != null){
                leadOwnerName = String.ValueOf(ldObj.Owner.Name);
            }
        }
        List<EmailMessage> emailmessageList =  new List<EmailMessage>();
        emailmessageList = [select id, Subject,TextBody from emailmessage where EmailTemplateId =: templateId order By createddate desc limit 1];
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(mMail);
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName('HIC Global Solutions'); 
        mail.setSubject(mSubject);
        
        string htmlReplace = '' ;
        if(mbody != null && mbody != ''){
            htmlReplace = mbody; 
        }
        
        if(htmlReplace != null &&  htmlReplace.containsIgnoreCase('{!Lead.Name}')){
            htmlReplace = htmlReplace.replace('{!Lead.Name}',leadName)+'<br/>'; 
        }
        if(htmlReplace != null &&  htmlReplace.containsIgnoreCase('{!Lead.OwnerFullName}')){
            htmlReplace = htmlReplace.replace('{!Lead.OwnerFullName}',leadOwnerName)+'<br/>'; 
        }
        
        mail.setHtmlBody(mbody);
        mail.setTargetObjectId(leadId); 
        mail.setTreatTargetObjectAsRecipient(true);
        mail.setTreatBodiesAsTemplate(true);
        mail.setTemplateId(em.get(0).id);
        mails.add(mail);
        
        Messaging.sendEmail(mails);
*/
    }   
    
    
    
    @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody, String leadId,String folderId,String templateId ){
        // Define the email
    /*    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
 
        // Reference the attachment page and pass in the account ID
        PageReference pdf =  Page.ETT_QuotationPDF;
        pdf.getParameters().put('id','a5S3M0000008oviUAA'); 
        pdf.getParameters().put('accId','0013M00000QNEujQAH'); 
        //pdf.setRedirect(true);
 
        // Take the PDF content
        Blob b;
        if(!test.isRunningTest()){
        	b = pdf.getContent();
        }
        else{
            b=Blob.valueof('Test Class');
        }
 
        // Create the email attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('ETT_Quotation.pdf');
        efa.setBody(b);
 
        String addresses;
       if (account.Contacts[0].Email != null) {
            addresses = account.Contacts[0].Email;
            // Loop through the whole list of contacts and their emails
            for (Integer i = 1; i < account.Contacts.size(); i++) {
                if (account.Contacts[i].Email != null) {
                    addresses += ':' + account.Contacts[i].Email;
                }
            }
        }

        //String[] toAddresses = addresses.split(':', 0);
        
        List<string> toAddresses = new List<string>();
        toAddresses.add(mMail);
        //string body = 'Dear Customer,';
        
         String body = 'Dear Customer,  \n\n';
            body += 'Please find an attached quotation for your reference.\n\n';
            body +='\nRegards'+','+'\nEmirates Transport, \nHead Of Operations';
        
        
        // Sets the paramaters of the email
        email.setSubject( 'Emirates Transport Quotation' );
        email.setToAddresses( toAddresses );
        email.setPlainTextBody( body );
 
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
        // Sends the email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
		
       */
    }

    @AuraEnabled 
    public static void acceptRejectQuotation(Id Id,String status){

        List<ETT_Quotation__c> lstQuotation = [select Id from ETT_Quotation__c where Id=:Id];

        if(lstQuotation!=null && lstQuotation.size()>0){
            for(ETT_Quotation__c obj:lstQuotation){
                if(status=='Accept'){
                    obj.ETT_Head_Of_Operation_Acceptance__c = 'Accepted';
                }else{
                    obj.ETT_Head_Of_Operation_Acceptance__c = 'Rejected';
                }
            }
            try{
                update lstQuotation;
            }
            catch(Exception ex){
                System.debug('Exception: '+ex.getMessage());
            }
        }
        
    }
    
    /*---Added by Janardhan ---*/
    @AuraEnabled 
    public static user getuserLoggedInfo(){
        return [select id,profile.Name from user where Id=:userInfo.getUserId()];
    }
    
    @AuraEnabled 
    public static list<contact> getContactsFromAccountID(string accId){
        
        return [select id,name,email from contact where accountid=:accId];
        
    }
     @AuraEnabled
    public static list<ETT_Pricing_Information__c> getPricingInfoFromAccId(string AccId){
        
      
        return [select ETT_Tyre_Size__r.Name,ETT_Purchase_Price__c  from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c =:AccId AND ETT_Tyre_Size__r.Name != null];
    }
    
    @AuraEnabled
    public static list<ETT_Tyre_Inventory__c> getTyreInventory(string collCardId){
        
        return [select id,Process_Type__c,Job_Type__c,Party_Type__c,ETT_Tyre_Size_Master__r.Name,Pricing_Information__r.ETT_Purchase_Price__c,Pricing_Information__r.ETT_Repair_Price__c,Pricing_Information__r.ETT_Retread_Price_H__c,Pricing_Information__r.ETT_Retread_Price_P__c from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:collCardId];
        //ID accId  = [select id,ETT_Accounts__c from ETT_Collection_Card__c where Id=:collCardId].ETT_Accounts__c;
        //return [select ETT_Tyre_Size__r.Name,ETT_Purchase_Price__c  from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c =:accId AND ETT_Tyre_Size__r.Name != null];
    } 

}