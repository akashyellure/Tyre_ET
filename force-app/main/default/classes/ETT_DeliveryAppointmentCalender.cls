public class ETT_DeliveryAppointmentCalender {
    
    public Opportunity oppObj;
    public WorkOrder objWorkOrder{get;set;}
    public ServiceAppointment objServiceAppointment{get;set;}
    public AssignedResource objAssignedResource{get;set;}
    public boolean isSkipAppointment{get;set;}
    public boolean isDeliveryAppointment{get;set;}
    public Contact objContact{get;set;}
    public WorkType objWorkType{get;set;}
    public string DeliveryNote{get;set;}
    public string DeliveryNoteId{get;set;}
    public boolean isDeliveryAptBooked{get;set;}
    public String selectedPriority{get;set;}
    
    
    //Constructor to Prepare the Objects intiation
    public ETT_DeliveryAppointmentCalender(ApexPages.StandardController controller){
        //isSkipAppointment = false;
        oppObj = (Opportunity)controller.getRecord();
        System.debug(oppObj);
        
        objWorkOrder = new WorkOrder();
        objServiceAppointment = new ServiceAppointment();
        objAssignedResource = new AssignedResource();
        objWorkType = new WorkType();
        objContact = [select Id,LastName from Contact where AccountId=:oppObj.AccountId limit 1];
        list<WorkType> lstWorkTypes = [select id,Name from workType where RecordType.Name='Tyre - Cash Supplier' Order by Name Desc];
        if(lstWorkTypes!=null && lstWorkTypes.size()>0){
            for(WorkType objExistingWorkType :lstWorkTypes){
                if(objWorkType.Name!=''){ 
                    objWorkType = objExistingWorkType;
                }
            }
        }    
        
    }

    
    public List<SelectOption> getpriorityOptions() {
        List<SelectOption> priorityOptions = new List<SelectOption>();
        //countryOptions.add(new SelectOption('','-None-'));
        priorityOptions.add(new SelectOption('Supplier Collection','Supplier Collection'));
        priorityOptions.add(new SelectOption('ET Delivery','ET Delivery'));
        return priorityOptions;
    }
    
    
    public void deliveryWorkType(){
        if(isDeliveryAppointment){
            WorkType objExistingWorkType = [select id,Name from workType where RecordType.Name='Tyre - Cash Supplier' and Name='Tyre Delivery'];
            objWorkType = objExistingWorkType;     
        }else{
            WorkType objExistingWorkType = [select id,Name from workType where RecordType.Name='Tyre - Cash Supplier' and Name='Tyre Collection'];
            objWorkType = objExistingWorkType;
        }
        
    }
    
    
    public void skipAppointment(){
        if(isSkipAppointment)
            isSkipAppointment = false;else
                isSkipAppointment = true;   
    }    
    /*
This logic has been to Create a Work Order and Service Appointment and Service Resource based
Calender avilable dates.
*/
    
    
    public PageReference serviceAppointmentRedirect(){

        System.debug('oppObj: '+oppObj.RecordTypeId);
        List<RecordType> lstRecordTypes = [SELECT Id, Name, SobjectType FROM RecordType where SobjectType='Opportunity' and Id=:oppObj.RecordTypeId];
        System.debug('rec name: '+lstRecordTypes[0].Name);
        
        if(lstRecordTypes[0].Name=='Tyre - Cash Supplier'){
            
            /* if(isSkipAppointment){ //if appointment is skipped

if(objWorkOrder!=null){
list<WorkType> lstWorkTypes = [select id,Name,RecordType.Name from workType where RecordType.Name in ('Tyre - Cash Supplier') and Name='Tyre Collection'];

if(lstWorkTypes!=null && lstWorkTypes.size()>0){
if(lstWorkTypes[0].Name=='Tyre Collection'){
objWorkOrder.WorkTypeId = lstWorkTypes[0].Id;
}
}    
list<Contact> lstContact = [select Id,Account.Phone,Account.BillingStreet from contact where AccountId=:oppObj.AccountId limit 1];        
objWorkOrder.AccountId = oppObj.AccountId;
if(lstContact!=null && lstContact.size()>0){
objWorkOrder.ContactId = lstContact[0].Id;
}
objWorkOrder.ETT_Opportunity__c = oppObj.Id;
objWorkOrder.RecordTypeId = objWorkOrder.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();    

try{
insert objWorkOrder;
} Catch(Exception ex){
apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
}
// insert objWorkOrder;

System.debug('isSkipAppointment: '+isSkipAppointment);

}
}else{*/
            
            if(!isSkipAppointment){ 
                selectedPriority = 'ET Delivery';
                if(objServiceAppointment.earliestStartTime==objServiceAppointment.DueDate){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'Earliest Start Permitted date and Due date could not be same'));
                    return null;
                }
                
                if(objServiceAppointment.earliestStartTime>objServiceAppointment.DueDate){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'Due date could not be older than a start date'));
                    return null;
                }
            }else{
                selectedPriority = 'Supplier Collection';
            }  
            List<RecordType> lstServiceAppointmentIds = [Select Id from RecordType where Name in ('Tyre - Cash Supplier','Tyre - Credit/B2B Supplier','Tyre - Refurbishing Services','Tyre - Return Appointment') and SobjectType  = 'ServiceAppointment'];            
            Set<ID> serviceAppointmentRecordTypeId = new Set<ID>();
            
            if(lstServiceAppointmentIds!=null && lstServiceAppointmentIds.size()>0){
                for(RecordType rec:lstServiceAppointmentIds){
                    serviceAppointmentRecordTypeId.add(rec.Id);
                }
            }
            
            list<AssignedResource> lstAssinedResources =[select Id,ETT_Vehicle_Detail__c,ServiceResource.Name,ETT_Vehicle_Detail__r.Name,ServiceAppointment.AppointmentNumber,ServiceAppointment.earliestStartTime,ServiceAppointment.DueDate 
                                                         from AssignedResource where 
                                                         ETT_Vehicle_Detail__c!=null and 
                                                         (ServiceResourceId=:objAssignedResource.serviceResourceId or
                                                          ETT_Vehicle_Detail__c=:objAssignedResource.ETT_Vehicle_Detail__c) and 
                                                         ServiceAppointment.RecordTypeId in :serviceAppointmentRecordTypeId and 
                                                         ServiceAppointment.earliestStartTime<=:objServiceAppointment.earliestStartTime and 
                                                         ServiceAppointment.duedate>=:objServiceAppointment.earliestStartTime and
                                                         ServiceAppointment.status not in ('Completed','Canceled')
                                                        ];            
            system.debug('****lstAssinedResources*****'+lstAssinedResources);
            
            if(lstAssinedResources!=null && lstAssinedResources.size()>0){
                for(AssignedResource objAssignResource :lstAssinedResources){
                    System.debug('vehicle: '+objAssignResource.ETT_Vehicle_Detail__c+' : '+objAssignedResource.ETT_Vehicle_Detail__c);
                    
                    if(objAssignResource.ServiceResourceId==objAssignedResource.serviceResourceId){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'The Appointment slot is already booked for this Service Resource'));
                    }else{
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'The Appointment slot is already booked for this Vehicle'));
                    }
                    
                    
                }
                return null;
            }
            
            if(objWorkOrder!=null){
                list<WorkType> lstWorkTypes = [select id,Name,RecordType.Name from workType where RecordType.Name in ('Tyre - Cash Supplier') and Name='Tyre Collection'];
                
                if(lstWorkTypes!=null && lstWorkTypes.size()>0){
                    if(lstWorkTypes[0].Name=='Tyre Collection'){
                        objWorkOrder.WorkTypeId = lstWorkTypes[0].Id;
                    }
                }    
                list<Contact> lstContact = [select Id,Account.Phone,Account.BillingStreet from contact where AccountId=:oppObj.AccountId limit 1];        
                objWorkOrder.AccountId = oppObj.AccountId;
                if(lstContact!=null && lstContact.size()>0){
                    objWorkOrder.ContactId = lstContact[0].Id;
                }
                objWorkOrder.ETT_Opportunity__c = oppObj.Id;
                objWorkOrder.RecordTypeId = objWorkOrder.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();    
                
                try{
                    insert objWorkOrder;
                } Catch(Exception ex){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                }
                // insert objWorkOrder;
                
                System.debug('isSkipAppointment: '+isSkipAppointment);
                
                if(objServiceAppointment!=null){
                    objServiceAppointment.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Return Appointment').getRecordTypeId();  
                    objServiceAppointment.SchedStartTime = objServiceAppointment.EarliestStartTime;
                    objServiceAppointment.SchedEndTime = objServiceAppointment.DueDate; 
                    objServiceAppointment.ParentRecordId = objWorkOrder.Id;
                    objServiceAppointment.ETT_Opportunity__c = oppObj.Id;
                    //objServiceAppointment.Delivery__c = selectedPriority;
                    system.debug('****objServiceAppointment****'+objServiceAppointment);
                }
                
                try{
                    insert objServiceAppointment;
                    system.debug('****objServiceAppointment****'+objServiceAppointment);
                } Catch(Exception ex){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                }
                
                if(objAssignedResource!=null){
                    objAssignedResource.ServiceAppointmentId = objServiceAppointment.Id;
                    try{
                        insert  objAssignedResource;
                        system.debug('******objAssignedResource******'+objAssignedResource);
                    }Catch(Exception ex){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                    }
                }
                
                
            }       
            //}
        }
        
        if(lstRecordTypes[0].Name=='Tyre Refurbishing Services'){
            list<AssignedResource> lstAssinedResources =[select Id,ETT_Vehicle_Detail__c,ServiceResource.Name,ETT_Vehicle_Detail__r.Name,ServiceAppointment.AppointmentNumber,ServiceAppointment.earliestStartTime,ServiceAppointment.DueDate from AssignedResource where 
                                                         ServiceResourceId=:objAssignedResource.serviceResourceId and ETT_Vehicle_Detail__c!=null 
                                                         and ServiceAppointment.RecordType.Name in ('Tyre Refurbishing Services','Tyre - Cash Supplier','Tyre - Credit/B2B Supplier','Tyre - Return Appointment') and 
                                                         ServiceAppointment.earliestStartTime>=:objServiceAppointment.earliestStartTime and ServiceAppointment.duedate<=:objServiceAppointment.DueDate and
                                                         ServiceAppointment.status not in ('Completed','Canceled')
                                                        ];
            system.debug('****lstAssinedResources*****'+lstAssinedResources);
            if(lstAssinedResources!=null && lstAssinedResources.size()>0){
                for(AssignedResource objAssignResource :lstAssinedResources){
                    if(objAssignResource.ETT_Vehicle_Detail__c==objAssignedResource.ETT_Vehicle_Detail__c){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'The Appointment slot is already booked'));
                    }else{
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'The Appointment slot is already booked'));
                    }
                }
                return null;
            }
            if(objWorkOrder!=null){
                list<WorkType> lstWorkTypes = [select id,Name,RecordType.Name from workType where RecordType.Name in ('Tyre Refurbishing Services') and Name='Tyre Collection'];
                
                
                if(lstWorkTypes!=null && lstWorkTypes.size()>0){
                    if(lstWorkTypes[0].Name=='Tyre Collection'){
                        objWorkOrder.WorkTypeId = lstWorkTypes[0].Id;
                    }
                }    
                list<Contact> lstContact = [select Id,Account.Phone,Account.BillingStreet from contact where AccountId=:oppObj.AccountId limit 1];        
                objWorkOrder.AccountId = oppObj.AccountId;
                if(lstContact!=null && lstContact.size()>0){
                    objWorkOrder.ContactId = lstContact[0].Id;
                }
                objWorkOrder.ETT_Opportunity__c = oppObj.Id;
                objWorkOrder.RecordTypeId = objWorkOrder.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();    
                
                try{
                    insert objWorkOrder;
                } Catch(Exception ex){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                }
                // insert objWorkOrder;
                if(objServiceAppointment!=null){
                    objServiceAppointment.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();  
                    objServiceAppointment.SchedStartTime = objServiceAppointment.EarliestStartTime;
                    objServiceAppointment.SchedEndTime = objServiceAppointment.DueDate; 
                    objServiceAppointment.ParentRecordId = objWorkOrder.Id;
                    objServiceAppointment.ETT_Opportunity__c = oppObj.Id;
                    system.debug('****objServiceAppointment****'+objServiceAppointment);
                }
                
                try{
                    insert objServiceAppointment;
                    system.debug('****objServiceAppointment****'+objServiceAppointment);
                } Catch(Exception ex){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                }
                
                if(objAssignedResource!=null){
                    objAssignedResource.ServiceAppointmentId = objServiceAppointment.Id;
                    try{
                        insert  objAssignedResource;
                        system.debug('******objAssignedResource******'+objAssignedResource);
                    }Catch(Exception ex){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                    }
                    ETT_Collection_Card__c objCollectionCard = new ETT_Collection_Card__c();
                    objCollectionCard.ETT_Accounts__c = oppObj.AccountId;
                    objCollectionCard.ETT_Collection_Status__c = 'New';
                    objCollectionCard.ETT_Driver__c = objAssignedResource.ServiceResourceId;
                    objCollectionCard.ETT_Service_Appointment__c = objServiceAppointment.Id;
                    objCollectionCard.ETT_Vehicle_Detail__c = objAssignedResource.ETT_Vehicle_Detail__c;
                    objCollectionCard.ETT_Work_Order__c = objWorkOrder.Id;
                    objCollectionCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(); 
                    if(lstContact!=null && lstContact.size()>0){
                        objCollectionCard.ETT_Location__c = lstContact[0].Account.BillingStreet;
                    }
                    
                    try{
                        insert objCollectionCard; 
                    }
                    Catch(Exception ex){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                    }
                }
            }       
            
        }
        
        if(lstRecordTypes[0].Name=='Tyre - Credit/B2B Supplier'){
            list<AssignedResource> lstAssinedResources =[select Id,ETT_Vehicle_Detail__c,ServiceResource.Name,ETT_Vehicle_Detail__r.Name,ServiceAppointment.AppointmentNumber,ServiceAppointment.earliestStartTime,ServiceAppointment.DueDate from AssignedResource where 
                                                         ServiceResourceId=:objAssignedResource.serviceResourceId and ETT_Vehicle_Detail__c!=null 
                                                         and ServiceAppointment.RecordType.Name in ('Tyre Refurbishing Services','Tyre - Cash Supplier','Tyre - Credit/B2B Supplier','Tyre - Return Appointment') and 
                                                         ServiceAppointment.earliestStartTime>=:objServiceAppointment.earliestStartTime and ServiceAppointment.duedate<=:objServiceAppointment.DueDate and
                                                         ServiceAppointment.status not in ('Completed','Canceled')
                                                        ];
            system.debug('****lstAssinedResources*****'+lstAssinedResources);
            if(lstAssinedResources!=null && lstAssinedResources.size()>0){
                for(AssignedResource objAssignResource :lstAssinedResources){
                    if(objAssignResource.ETT_Vehicle_Detail__c==objAssignedResource.ETT_Vehicle_Detail__c){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'The Appointment slot is already booked'));
                    }else{
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'The Appointment slot is already booked'));
                    }
                }
                return null;
            }
            if(objWorkOrder!=null){
                list<WorkType> lstWorkTypes = [select id,Name,RecordType.Name from workType where RecordType.Name in ('Tyre - Credit/B2B Supplier') and Name='Tyre Collection'];
                
                
                if(lstWorkTypes!=null && lstWorkTypes.size()>0){
                    if(lstWorkTypes[0].Name=='Tyre Collection'){
                        objWorkOrder.WorkTypeId = lstWorkTypes[0].Id;
                    }
                }    
                list<Contact> lstContact = [select Id,Account.Phone,Account.BillingStreet from contact where AccountId=:oppObj.AccountId limit 1];        
                objWorkOrder.AccountId = oppObj.AccountId;
                if(lstContact!=null && lstContact.size()>0){
                    objWorkOrder.ContactId = lstContact[0].Id;
                }
                objWorkOrder.ETT_Opportunity__c = oppObj.Id;
                objWorkOrder.RecordTypeId = objWorkOrder.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Tyre - Credit/B2B Supplier').getRecordTypeId();    
                
                try{
                    insert objWorkOrder;
                } Catch(Exception ex){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                }
                // insert objWorkOrder;
                if(objServiceAppointment!=null){
                    objServiceAppointment.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Credit/B2B Supplier').getRecordTypeId();  
                    objServiceAppointment.SchedStartTime = objServiceAppointment.EarliestStartTime;
                    objServiceAppointment.SchedEndTime = objServiceAppointment.DueDate; 
                    objServiceAppointment.ParentRecordId = objWorkOrder.Id;
                    objServiceAppointment.ETT_Opportunity__c = oppObj.Id;
                    system.debug('****objServiceAppointment****'+objServiceAppointment);
                }
                
                try{
                    insert objServiceAppointment;
                    system.debug('****objServiceAppointment****'+objServiceAppointment);
                } Catch(Exception ex){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                }
                
                if(objAssignedResource!=null){
                    objAssignedResource.ServiceAppointmentId = objServiceAppointment.Id;
                    try{
                        insert  objAssignedResource;
                        system.debug('******objAssignedResource******'+objAssignedResource);
                    }Catch(Exception ex){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                    }
                    ETT_Collection_Card__c objCollectionCard = new ETT_Collection_Card__c();
                    objCollectionCard.ETT_Accounts__c = oppObj.AccountId;
                    objCollectionCard.ETT_Collection_Status__c = 'New';
                    objCollectionCard.ETT_Driver__c = objAssignedResource.ServiceResourceId;
                    objCollectionCard.ETT_Service_Appointment__c = objServiceAppointment.Id;
                    objCollectionCard.ETT_Vehicle_Detail__c = objAssignedResource.ETT_Vehicle_Detail__c;
                    objCollectionCard.ETT_Work_Order__c = objWorkOrder.Id;
                    objCollectionCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Credit/B2B Supplier').getRecordTypeId(); 
                    if(lstContact!=null && lstContact.size()>0){
                        objCollectionCard.ETT_Location__c = lstContact[0].Account.BillingStreet;
                    }
                    
                    try{
                        insert objCollectionCard; 
                    }
                    Catch(Exception ex){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                    }
                }
            }       
            
        }        
        
        if(lstRecordTypes[0].Name=='Tyre Internal'){
            list<AssignedResource> lstAssinedResources =[select Id,ETT_Vehicle_Detail__c,ServiceResource.Name,ETT_Vehicle_Detail__r.Name,ServiceAppointment.AppointmentNumber,ServiceAppointment.earliestStartTime,ServiceAppointment.DueDate 
                                                         from AssignedResource 
                                                         where 
                                                         ServiceResourceId=:objAssignedResource.serviceResourceId and 
                                                         ETT_Vehicle_Detail__c!=null and 
                                                         ServiceAppointment.RecordType.Name in ('Tyre - Cash Supplier','Tyre - Credit/B2B Supplier','Tyre - Refurbishing Services','Tyre - Return Appointment','Tyre - Internal') and 
                                                         ServiceAppointment.earliestStartTime>=:objServiceAppointment.earliestStartTime and 
                                                         ServiceAppointment.duedate<=:objServiceAppointment.DueDate and
                                                         ServiceAppointment.status not in ('Completed','Canceled')
                                                        ];
            system.debug('****lstAssinedResources*****'+lstAssinedResources);
            if(lstAssinedResources!=null && lstAssinedResources.size()>0){
                for(AssignedResource objAssignResource :lstAssinedResources){
                    if(objAssignResource.ETT_Vehicle_Detail__c==objAssignedResource.ETT_Vehicle_Detail__c){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'The Appointment slot is already booked'));
                    }else{
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'The Appointment slot is already booked'));
                    }
                }
                return null;
            }
            if(objWorkOrder!=null){
                list<WorkType> lstWorkTypes = [select id,Name,RecordType.Name from workType where RecordType.Name in ('Tyre - Internal') and Name='Tyre Collection'];
                
                
                if(lstWorkTypes!=null && lstWorkTypes.size()>0){
                    if(lstWorkTypes[0].Name=='Tyre Collection'){
                        objWorkOrder.WorkTypeId = lstWorkTypes[0].Id;
                    }
                }    
                list<Contact> lstContact = [select Id,Account.Phone,Account.BillingStreet from contact where AccountId=:oppObj.AccountId limit 1];        
                objWorkOrder.AccountId = oppObj.AccountId;
                if(lstContact!=null && lstContact.size()>0){
                    objWorkOrder.ContactId = lstContact[0].Id;
                }
                objWorkOrder.ETT_Opportunity__c = oppObj.Id;
                objWorkOrder.RecordTypeId = objWorkOrder.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId();    
                
                try{
                    insert objWorkOrder;
                } Catch(Exception ex){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                }
                // insert objWorkOrder;
                if(objServiceAppointment!=null){
                    
                    objServiceAppointment.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId();  
                    objServiceAppointment.SchedStartTime = objServiceAppointment.EarliestStartTime;
                    objServiceAppointment.SchedEndTime = objServiceAppointment.DueDate; 
                    objServiceAppointment.ParentRecordId = objWorkOrder.Id;
                    objServiceAppointment.ETT_Opportunity__c = oppObj.Id;
                    system.debug('****objServiceAppointment****'+objServiceAppointment);
                }
                
                try{
                    insert objServiceAppointment;
                    system.debug('****objServiceAppointment****'+objServiceAppointment);
                } Catch(Exception ex){
                    apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                }
                
                if(objAssignedResource!=null){
                    objAssignedResource.ServiceAppointmentId = objServiceAppointment.Id;
                    try{
                        insert  objAssignedResource;
                        system.debug('******objAssignedResource******'+objAssignedResource);
                    }Catch(Exception ex){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                    }
                    ETT_Collection_Card__c objCollectionCard = new ETT_Collection_Card__c();
                    objCollectionCard.ETT_Accounts__c = oppObj.AccountId;
                    objCollectionCard.ETT_Collection_Status__c = 'New';
                    objCollectionCard.ETT_Driver__c = objAssignedResource.ServiceResourceId;
                    objCollectionCard.ETT_Service_Appointment__c = objServiceAppointment.Id;
                    objCollectionCard.ETT_Vehicle_Detail__c = objAssignedResource.ETT_Vehicle_Detail__c;
                    objCollectionCard.ETT_Work_Order__c = objWorkOrder.Id;
                    objCollectionCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId(); 
                    if(lstContact!=null && lstContact.size()>0){
                        objCollectionCard.ETT_Location__c = lstContact[0].Account.BillingStreet;
                    }
                    
                    try{
                        insert objCollectionCard; 
                    }
                    Catch(Exception ex){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                    }
                }
            }       
            
        }       
        
        return new Pagereference('/'+oppObj.Id);
    }
    
    
    @RemoteAction
    public static list<AssignedResourceWrapper> lstAssignedResources(){
        list<AssignedResourceWrapper> lstAssignedWrapper = new list<AssignedResourceWrapper>();
        for(AssignedResource objAssinedResources :[select Id,ServiceResource.Name,ETT_Vehicle_Detail__r.Name,ServiceAppointment.AppointmentNumber,ServiceAppointment.earliestStartTime,ServiceAppointment.DueDate from AssignedResource where ETT_Vehicle_Detail__c!=null 
                                                   and ServiceAppointment.RecordType.Name in ('Tyre - Cash Supplier','Tyre - Refurbishing Services','Tyre - Credit/B2B Supplier','Tyre - Return Appointment')  and ServiceAppointment.status not in ('Completed','Canceled','None')
                                                  ]){
                                                      AssignedResourceWrapper objAssinedResourceWrap     = new AssignedResourceWrapper();
                                                      objAssinedResourceWrap.strServiceResourceName      =  objAssinedResources.ServiceResource.Name;
                                                      objAssinedResourceWrap.strVehicleName              =  objAssinedResources.ETT_Vehicle_Detail__r.Name;
                                                      objAssinedResourceWrap.strServiceAppointmentNumber =  objAssinedResources.ServiceAppointment.AppointmentNumber;
                                                      objAssinedResourceWrap.startTime                   =  objAssinedResources.ServiceAppointment.earliestStartTime;
                                                      objAssinedResourceWrap.endTime                     =  objAssinedResources.ServiceAppointment.DueDate; 
                                                      lstAssignedWrapper.add(objAssinedResourceWrap);
                                                  }
        return lstAssignedWrapper;
    }
    
    
    public class AssignedResourceWrapper{
        public  string strServiceResourceName{get;set;}
        public  string strVehicleName{get;set;}
        public  string strServiceAppointmentNumber{get;set;}
        public  DateTime startTime{get;set;}
        public  DateTime endTime{get;set;}
    }
    
    
}