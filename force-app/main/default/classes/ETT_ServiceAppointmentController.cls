/*
Created By   : Shweta Shinde
Created Date : 05/26/2020
Description  : This is for Service Appointment Controller
*/
public class ETT_ServiceAppointmentController {
    
    //This is for Preparing the Dynamic Pick list Values for Combination
    @AuraEnabled
    public static Map<String, String> getselectOptions(string fld) {
        
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        
        Schema.sObjectType objType = WorkOrder.getSObjectType();
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
    
    //WorkOrder Creation Page to skip the Service Appointments or whether we need to proceed the Service Appointments or Not
    @AuraEnabled
    public static string workOrderProcess(Account objAcct,WorkOrder objWorkOrder,ServiceAppointment objServiceAppt,AssignedResource objAssignedResource,boolean isSkipAppointment){
        
        System.debug('objWorkOrder: '+objWorkOrder);
        System.debug('You are inside function');
        ETT_Collection_Card__c objCollectionCard;
        DateTime currentTime = DateTime.now();
        list<AssignedResource> lstAssginedResources = [Select Id,ServiceAppointment.EarliestStartTime,ServiceAppointment.DueDate,ServiceResourceId,ETT_Vehicle_Detail__c,ServiceAppointmentId from
                                                       AssignedResource where ServiceAppointment.EarliestStartTime>=:currentTime and ServiceAppointment.Status not in ('Completed','Canceled')];
        if(!isSkipAppointment && objServiceAppt!=null){
            if(lstAssginedResources!=null && lstAssginedResources.size()>0){ 
                for(AssignedResource objExistingAssignedResource :lstAssginedResources){
                    if(((objServiceAppt.EarliestStartTime >= objExistingAssignedResource.ServiceAppointment.EarliestStartTime
                         && objServiceAppt.EarliestStartTime < objExistingAssignedResource.ServiceAppointment.Duedate) || 
                        (objServiceAppt.DueDate > objExistingAssignedResource.ServiceAppointment.EarliestStartTime && 
                         objServiceAppt.DueDate <= objExistingAssignedResource.ServiceAppointment.Duedate)))  {
                             throw new AuraHandledException('This Resource is already occupied with an appointments');
                         }
                    
                }
            }
            
        }
        if(isSkipAppointment){
            
            try{
                System.debug('objAcct: '+objAcct);
                System.debug('objWorkOrder: '+objWorkOrder);
                if(objAcct.Party_Type__c!='' && objAcct.ETT_Payment_Type__c!='' && objAcct.Party_Type__c=='Supplier' && objAcct.ETT_Payment_Type__c=='Cash'){
                    objWorkOrder.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
                    objWorkOrder.status = 'In progress';
                    insert objWorkOrder;
                    objCollectionCard = new ETT_Collection_Card__c();
                    objCollectionCard.ETT_Work_Order__c = objWorkOrder.Id;
                    objCollectionCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
                    
                }else if(objAcct.Party_Type__c!='' && objAcct.ETT_Payment_Type__c!='' && objAcct.Party_Type__c=='Customer'){
                    
                    objWorkOrder.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
                    objWorkOrder.status = 'In progress';
                    insert objWorkOrder;
                    objCollectionCard = new ETT_Collection_Card__c();
                    objCollectionCard.ETT_Work_Order__c = objWorkOrder.Id;
                    objCollectionCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();                    
                }
                //insert objWorkOrder;
                
                system.debug('****objWorkOrder****'+objWorkOrder);
                system.debug('****objCollectionCard****'+objCollectionCard);
                
                insert objCollectionCard;

                return objCollectionCard.Id;
            }Catch(Exception ex){
                throw new AuraException(ex.getLineNumber()+' : '+ex.getMessage());
            }
        }else{
            try{
                system.debug('*****objAcct****'+objAcct);
                system.debug('*****objWorkOrder****'+objWorkOrder);
                if(objAcct.Party_Type__c!='' && objAcct.ETT_Payment_Type__c!='' && objAcct.Party_Type__c=='Supplier' && objAcct.ETT_Payment_Type__c=='Cash'){
                    objWorkOrder.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
                    objWorkOrder.status = 'In progress';
                    insert objWorkOrder;
                    system.debug('*****objWorkOrder****'+objWorkOrder);
                    objServiceAppt.ParentRecordId = objWorkOrder.Id;
                    objServiceAppt.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
                    objServiceAppt.SchedStartTime = objServiceAppt.EarliestStartTime;
                    objServiceAppt.SchedEndTime = objServiceAppt.DueDate;
                    insert objServiceAppt;
                    system.debug('*****objServiceAppt****'+objServiceAppt);
                    objAssignedResource.ServiceAppointmentId = objServiceAppt.Id;
                    insert objAssignedResource;
                    system.debug('*****objServiceAppt****'+objServiceAppt);
                    objCollectionCard = new ETT_Collection_Card__c();
                    objCollectionCard.ETT_Accounts__c = objAcct.Id;
                    objCollectionCard.ETT_Collection_Status__c = 'New';
                    objCollectionCard.ETT_Driver__c = objAssignedResource.ServiceResourceId;
                    objCollectionCard.ETT_Service_Appointment__c = objAssignedResource.ServiceAppointmentId;
                    objCollectionCard.ETT_Vehicle_Detail__c = objAssignedResource.ETT_Vehicle_Detail__c;
                    objCollectionCard.ETT_Work_Order__c = objWorkOrder.Id;
                    objCollectionCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
                    system.debug('*****objCollectionCard****'+objCollectionCard);
                    insert objCollectionCard;
                    
                    list<ETT_Pricing_Information__c> lstPricingDetails = [select Id,ETT_Price__r.ETT_Party_Name__c,ETT_Brand__c,ETT_Country_of_Origin__c,
                                                                          
                                                                          ETT_Pattern__c,ETT_Tyre_Size__c from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c=:objAcct.Id];
                    list<WorkOrderLineItem> lstWorkOrderLineItems = new list<WorkOrderLineItem>();
                    list<ETT_Tyre_Master__c> lstTyreMasters= new list<ETT_Tyre_Master__c>();
                    lstTyreMasters = [select Id,ETT_Brand_Name__c,ETT_Country_Name__c,ETT_Original_Pattern__c,ETT_Tyre_Size__c
                                      ,ETT_Ply_Rate__c,ETT_Speed_Index__c,ETT_Rim_Size__c,ETT_Load_Index__c,ETT_Length__c from 
                                      ETT_Tyre_Master__c]; 
                    map<string,ETT_Tyre_Master__c> mapofTyreDetailsWithTyreMaster = new map<string,ETT_Tyre_Master__c>();
                    if(lstTyreMasters!=null && lstTyreMasters.size()>0){
                        for(ETT_Tyre_Master__c objTyreMaster :lstTyreMasters){
                            mapofTyreDetailsWithTyreMaster.put(objTyreMaster.ETT_Tyre_Size__c+'#'+objTyreMaster.ETT_Brand_Name__c
                                                               +'#'+objTyreMaster.ETT_Original_Pattern__c+'#'+objTyreMaster.ETT_Country_Name__c
                                                               ,objTyreMaster);
                        }
                    }
                    if(lstPricingDetails!=null && lstPricingDetails.size()>0){
                        for(ETT_Pricing_Information__c objPricingInfo :lstPricingDetails){
                            WorkOrderLineItem objWorkOrderLineItem = new WorkOrderLineItem();
                            objWorkOrderLineItem.ETT_Brand__c = objPricingInfo.ETT_Brand__c;
                            objWorkOrderLineItem.ETT_Tyre_Size__c = objPricingInfo.ETT_Tyre_Size__c;
                            objWorkOrderLineItem.ETT_Pattern__c =  objPricingInfo.ETT_Pattern__c;
                            objWorkOrderLineItem.ETT_Country_of_Origin__c = objPricingInfo.ETT_Country_of_Origin__c;
                            objWorkOrderLineItem.ETT_Collection_Card__c = objCollectionCard.Id;
                            objWorkOrderLineItem.ETT_Accounts__c =  objAcct.Id;
                            objWorkOrderLineItem.WorkOrderId = objWorkOrder.Id;
                            
                            if(objWorkOrderLineItem.ETT_Brand__c!=null && objWorkOrderLineItem.ETT_Tyre_Size__c!=null && objWorkOrderLineItem.ETT_Pattern__c
                               !=null && objWorkOrderLineItem.ETT_Country_of_Origin__c!=null &&
                               mapofTyreDetailsWithTyreMaster.containskey(objWorkOrderLineItem.ETT_Tyre_Size__c+'#'+
                                                                          objWorkOrderLineItem.ETT_Brand__c+'#'+objWorkOrderLineItem.ETT_Pattern__c+'#'
                                                                          +objWorkOrderLineItem.ETT_Country_of_Origin__c)){
                                                                              objWorkOrderLineItem.ETT_Load_Index__c  =  mapofTyreDetailsWithTyreMaster.get(objWorkOrderLineItem.ETT_Tyre_Size__c+'#'+
                                                                                                                                                            objWorkOrderLineItem.ETT_Brand__c+'#'+objWorkOrderLineItem.ETT_Pattern__c+'#'
                                                                                                                                                            +objWorkOrderLineItem.ETT_Country_of_Origin__c).ETT_Load_Index__c;
                                                                              objWorkOrderLineItem.ETT_Ply_Rate__c    =      mapofTyreDetailsWithTyreMaster.get(objWorkOrderLineItem.ETT_Tyre_Size__c+'#'+
                                                                                                                                                                objWorkOrderLineItem.ETT_Brand__c+'#'+objWorkOrderLineItem.ETT_Pattern__c+'#'
                                                                                                                                                                +objWorkOrderLineItem.ETT_Country_of_Origin__c).ETT_Ply_Rate__c; 
                                                                              
                                                                              objWorkOrderLineItem.ETT_S_Index__c      =  mapofTyreDetailsWithTyreMaster.get(objWorkOrderLineItem.ETT_Tyre_Size__c+'#'+
                                                                                                                                                             objWorkOrderLineItem.ETT_Brand__c+'#'+objWorkOrderLineItem.ETT_Pattern__c+'#'
                                                                                                                                                             +objWorkOrderLineItem.ETT_Country_of_Origin__c).ETT_Speed_Index__c; 
                                                                          }
                            lstWorkOrderLineItems.add(objWorkOrderLineItem);
                        }
                        
                        if(lstWorkOrderLineItems!=null && lstWorkOrderLineItems.size()>0){
                            try{
                                //insert lstWorkOrderLineItems;    
                            }Catch(Exception ex){
                                system.debug('****Exception Cause *****'+ex.getLineNumber()+'***get Message'+ex.getMessage());
                            }
                            
                        }
                    }
                    
                }else if(objAcct.Party_Type__c!='' && objAcct.ETT_Payment_Type__c!='' && objAcct.Party_Type__c=='Customer'){
                    
                    
                    
                    objWorkOrder.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
                    objWorkOrder.status = 'In progress';
                    insert objWorkOrder;
                    system.debug('*****objWorkOrder****'+objWorkOrder);
                    objServiceAppt.ParentRecordId = objWorkOrder.Id;
                    objServiceAppt.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
                    objServiceAppt.SchedStartTime = objServiceAppt.EarliestStartTime;
                    objServiceAppt.SchedEndTime = objServiceAppt.DueDate;
                    //objServiceAppt.Duration = 1;
                    insert objServiceAppt;
                    system.debug('*****objServiceAppt****'+objServiceAppt);
                    objAssignedResource.ServiceAppointmentId = objServiceAppt.Id;
                    insert objAssignedResource;
                    system.debug('*****objServiceAppt****'+objServiceAppt);
                    objCollectionCard = new ETT_Collection_Card__c();
                    objCollectionCard.ETT_Accounts__c = objAcct.Id;
                    objCollectionCard.ETT_Collection_Status__c = 'New';
                    objCollectionCard.ETT_Driver__c = objAssignedResource.ServiceResourceId;
                    objCollectionCard.ETT_Service_Appointment__c = objAssignedResource.ServiceAppointmentId;
                    objCollectionCard.ETT_Vehicle_Detail__c = objAssignedResource.ETT_Vehicle_Detail__c;
                    objCollectionCard.ETT_Work_Order__c = objWorkOrder.Id;
                    objCollectionCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
                    system.debug('*****objCollectionCard****'+objCollectionCard);
                    insert objCollectionCard;
                    
                    
                    list<ETT_Pricing_Information__c> lstPricingDetails = [select Id,ETT_Price__r.ETT_Party_Name__c,ETT_Brand__c,ETT_Country_of_Origin__c,
                                                                          ETT_Pattern__c,ETT_Tyre_Size__c from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c=:objAcct.Id];
                    
                    
                    
                    list<WorkOrderLineItem> lstWorkOrderLineItems = new list<WorkOrderLineItem>();
                    list<ETT_Tyre_Master__c> lstTyreMasters= new list<ETT_Tyre_Master__c>();
                    lstTyreMasters = [select Id,ETT_Brand_Name__c,ETT_Country_Name__c,ETT_Original_Pattern__c,ETT_Tyre_Size__c
                                      ,ETT_Ply_Rate__c,ETT_Speed_Index__c,ETT_Rim_Size__c,ETT_Load_Index__c,ETT_Length__c from 
                                      ETT_Tyre_Master__c]; 
                    map<string,ETT_Tyre_Master__c> mapofTyreDetailsWithTyreMaster = new map<string,ETT_Tyre_Master__c>();
                    if(lstTyreMasters!=null && lstTyreMasters.size()>0){
                        for(ETT_Tyre_Master__c objTyreMaster :lstTyreMasters){
                            mapofTyreDetailsWithTyreMaster.put(objTyreMaster.ETT_Tyre_Size__c+'#'+objTyreMaster.ETT_Brand_Name__c
                                                               +'#'+objTyreMaster.ETT_Original_Pattern__c+'#'+objTyreMaster.ETT_Country_Name__c
                                                               ,objTyreMaster);
                        }
                    }
                    if(lstPricingDetails!=null && lstPricingDetails.size()>0){
                        for(ETT_Pricing_Information__c objPricingInfo :lstPricingDetails){
                            WorkOrderLineItem objWorkOrderLineItem = new WorkOrderLineItem();
                            objWorkOrderLineItem.ETT_Brand__c = objPricingInfo.ETT_Brand__c;
                            objWorkOrderLineItem.ETT_Tyre_Size__c = objPricingInfo.ETT_Tyre_Size__c;
                            objWorkOrderLineItem.ETT_Pattern__c =  objPricingInfo.ETT_Pattern__c;
                            objWorkOrderLineItem.ETT_Country_of_Origin__c = objPricingInfo.ETT_Country_of_Origin__c;
                            objWorkOrderLineItem.ETT_Collection_Card__c = objCollectionCard.Id;
                            objWorkOrderLineItem.ETT_Accounts__c =  objAcct.Id;
                            objWorkOrderLineItem.WorkOrderId = objWorkOrder.Id;
                            if(objWorkOrderLineItem.ETT_Brand__c!=null && objWorkOrderLineItem.ETT_Tyre_Size__c!=null && objWorkOrderLineItem.ETT_Pattern__c
                               !=null && objWorkOrderLineItem.ETT_Country_of_Origin__c!=null &&
                               mapofTyreDetailsWithTyreMaster.containskey(objWorkOrderLineItem.ETT_Tyre_Size__c+'#'+
                                                                          objWorkOrderLineItem.ETT_Brand__c+'#'+objWorkOrderLineItem.ETT_Pattern__c+'#'
                                                                          +objWorkOrderLineItem.ETT_Country_of_Origin__c)){
                                                                              objWorkOrderLineItem.ETT_Load_Index__c  =  mapofTyreDetailsWithTyreMaster.get(objWorkOrderLineItem.ETT_Tyre_Size__c+'#'+
                                                                                                                                                            objWorkOrderLineItem.ETT_Brand__c+'#'+objWorkOrderLineItem.ETT_Pattern__c+'#'
                                                                                                                                                            +objWorkOrderLineItem.ETT_Country_of_Origin__c).ETT_Load_Index__c;
                                                                              objWorkOrderLineItem.ETT_Ply_Rate__c    =      mapofTyreDetailsWithTyreMaster.get(objWorkOrderLineItem.ETT_Tyre_Size__c+'#'+
                                                                                                                                                                objWorkOrderLineItem.ETT_Brand__c+'#'+objWorkOrderLineItem.ETT_Pattern__c+'#'
                                                                                                                                                                +objWorkOrderLineItem.ETT_Country_of_Origin__c).ETT_Ply_Rate__c; 
                                                                              
                                                                              objWorkOrderLineItem.ETT_S_Index__c      =  mapofTyreDetailsWithTyreMaster.get(objWorkOrderLineItem.ETT_Tyre_Size__c+'#'+
                                                                                                                                                             objWorkOrderLineItem.ETT_Brand__c+'#'+objWorkOrderLineItem.ETT_Pattern__c+'#'
                                                                                                                                                             +objWorkOrderLineItem.ETT_Country_of_Origin__c).ETT_Speed_Index__c; 
                                                                          }
                            lstWorkOrderLineItems.add(objWorkOrderLineItem);
                        }
                        
                        if(lstWorkOrderLineItems!=null && lstWorkOrderLineItems.size()>0){
                            try{
                                //insert lstWorkOrderLineItems;    
                            }Catch(Exception ex){
                                system.debug('****Exception Cause *****'+ex.getLineNumber()+'***get Message'+ex.getMessage());
                            }
                            
                        }
                    }
                    
                    
                    
                    
                    
                }
                
                return objCollectionCard.Id;
            }Catch(Exception ex){
                throw new AuraException(ex.getLineNumber()+' : '+ex.getMessage());
            }
        }
        
        
    }
    
    @AuraEnabled
    public static Contact objContactDetails(Id oppId){
        Opportunity oppObj = [select AccountId from Opportunity where id=:oppId];
        Contact objCon;
        if(oppObj!=null){
            objCon = [select Id,FirstName,LastName,Email,AccountId from Contact where AccountId =:oppObj.AccountId limit 1];  
        }
        system.debug('*****objCon****'+objCon);
        return objCon;
    }
    
}