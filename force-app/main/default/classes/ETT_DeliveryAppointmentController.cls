public class ETT_DeliveryAppointmentController {
    
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
    //public map<string,string> getMapFieldLabel{get;set;}
    public map<String,String> getMapFieldLabel {get;set;}
                    
    //Constructor to Prepare the Objects intiation
    public ETT_DeliveryAppointmentController(ApexPages.StandardController controller){
        
        getMapFieldLabel = new map<String,String>();
        
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
        
        //added by shweta
        Set<Id> collectionCardIdsSet = new Set<Id>();
        Set<Id> deliveryNoteIdsSet = new Set<Id>();        
        
        Id ccId, dnId;
        List<AggregateResult> lstCollectionCard = [SELECT count(Id) countofInspections, ETT_Collection_Card__c collectionCard,ETT_Status__c ettStatus
                                                   FROM ETT_Inspection_Card__c where ETT_Account__c = :oppObj.AccountId and ETT_Collection_Card__r.ETT_Inspection_Done__c=true group by ETT_Collection_Card__c,ETT_Status__c];
        
        if(lstCollectionCard!= null && lstCollectionCard.size() > 0){ 
            for(AggregateResult agg:lstCollectionCard){ 
                ccId = (Id)agg.get('collectionCard'); 
                collectionCardIdsSet.add(ccId);
            }
            System.debug('collectionCardIdsSet: '+collectionCardIdsSet);
            
            List<AggregateResult> objDLI = [SELECT count(Id) cid, ETT_Delivery_Note__c FROM ETT_Delivery_Line_Item__c where ETT_Collection_Card__c in :collectionCardIdsSet group by ETT_Delivery_Note__c];
            System.debug('objDLI: '+objDLI);
            
            for(AggregateResult agg:objDLI){ 
                dnId = (Id)agg.get('ETT_Delivery_Note__c'); 
                deliveryNoteIdsSet.add(dnId);
            }
            
            
            List<ETT_Delivery_Note__c> lstDeliveryNote = [SELECT Id, Name, ETT_Is_Delivery_Appointment_Booked__c FROM ETT_Delivery_Note__c where ETT_Is_Delivery_Appointment_Booked__c=false and Id in :deliveryNoteIdsSet];

            
           
            
            System.debug('lstDeliveryNote: '+lstDeliveryNote);
            for(ETT_Delivery_Note__c dn:lstDeliveryNote){
                DeliveryNote = dn.Name;
                DeliveryNoteId = dn.Id;
                getMapFieldLabel.put(dn.Id, dn.Name);
            }
            if(DeliveryNoteId==null){
                isDeliveryAptBooked = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Delivery Appointment is already booked for Delivery Note'));
            }
            /*
            ETT_Delivery_Line_Item__c objDLI = [SELECT Id, ETT_Collection_Card__c,ETT_Delivery_Note__r.Name FROM ETT_Delivery_Line_Item__c where ETT_Collection_Card__c in :collectionCardIdsSet limit 1];
            DeliveryNote = objDLI.ETT_Delivery_Note__r.Name;
            DeliveryNoteId = objDLI.ETT_Delivery_Note__c;
            
            ServiceAppointment objServiceAppointment = [SELECT Id, ETT_Delivery_Note__c FROM ServiceAppointment where ETT_Delivery_Note__c=:DeliveryNoteId];
            if(objServiceAppointment!=null){
                isDeliveryAptBooked = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Delivery Appointment is already booked for Delivery Note '+DeliveryNote));
            }
            */
        }

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
    
    public String selectedPriority{get;set;}
    
    public List<SelectOption> getpriorityOptions() {
        List<SelectOption> priorityOptions = new List<SelectOption>();
        priorityOptions.add(new SelectOption('Supplier Collection','Supplier Collection'));
        priorityOptions.add(new SelectOption('ET Delivery','ET Delivery'));
        return priorityOptions;
    }
    
    /*
    This logic has been to Create a Work Order and Service Appointment and Service Resource based
    Calender avilable dates.
    */
    
    
    public PageReference serviceAppointmentRedirect(){
        
        List<RecordType> lstRecordTypes = [SELECT Id, Name, SobjectType FROM RecordType where SobjectType='Opportunity' and Id=:oppObj.RecordTypeId];

        if(lstRecordTypes[0].Name=='Tyre - Cash Supplier'){
            list<AssignedResource> lstAssinedResources =[select Id,ETT_Vehicle_Detail__c,ServiceResource.Name,ETT_Vehicle_Detail__r.Name,ServiceAppointment.AppointmentNumber,ServiceAppointment.earliestStartTime,ServiceAppointment.DueDate from AssignedResource where 
                                                         ServiceResourceId=:objAssignedResource.serviceResourceId and ETT_Vehicle_Detail__c!=null 
                                                         and ServiceAppointment.RecordType.Name in ('Tyre - Cash Supplier','Tyre - Credit/B2B Supplier','Tyre - Refurbishing Services','Tyre - Return Appointment') and 
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
                System.debug('selectedPriority: '+selectedPriority);
                // insert objWorkOrder;
                if(objServiceAppointment!=null){

                    System.debug('selectedPriority: '+selectedPriority);
                    
                    objServiceAppointment.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();  
                    objServiceAppointment.SchedStartTime = objServiceAppointment.EarliestStartTime;
                    objServiceAppointment.SchedEndTime = objServiceAppointment.DueDate; 
                    objServiceAppointment.ParentRecordId = objWorkOrder.Id;
                    objServiceAppointment.ETT_Opportunity__c = oppObj.Id;
                    //objServiceAppointment.Delivery__c = objServiceAppointment.Delivery__c; //selectedPriority;
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
                    objCollectionCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId(); 
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
    
        return new Pagereference('/'+oppObj.Id);
    }
    
    public PageReference deliveryAppointmentRedirect(){
        
        List<RecordType> lstRecordTypes = [SELECT Id, Name, SobjectType FROM RecordType where SobjectType='Opportunity' and Id=:oppObj.RecordTypeId];
        
        if(lstRecordTypes[0].Name=='Tyre - Cash Supplier'){
            list<AssignedResource> lstAssinedResources = [select Id,ETT_Vehicle_Detail__c,ServiceResource.Name,ETT_Vehicle_Detail__r.Name,ServiceAppointment.AppointmentNumber,ServiceAppointment.earliestStartTime,ServiceAppointment.DueDate from AssignedResource where 
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
                if(objServiceAppointment!=null){
                    objServiceAppointment.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Return Appointment').getRecordTypeId();  
                    objServiceAppointment.SchedStartTime = objServiceAppointment.EarliestStartTime;
                    objServiceAppointment.SchedEndTime = objServiceAppointment.DueDate; 
                    //objServiceAppointment.ParentRecordId = objWorkOrder.Id;
                    objServiceAppointment.ETT_Opportunity__c = oppObj.Id;
                    objServiceAppointment.ETT_Delivery_Note__c = DeliveryNoteId;
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
                /*
                
                ETT_Delivery_Note__c objDNote = [SELECT Id, Name, ETT_Is_Delivery_Appointment_Booked__c FROM ETT_Delivery_Note__c where Id=:DeliveryNoteId];            

                if(DeliveryNoteId != null){
                    objDNote.ETT_Is_Delivery_Appointment_Booked__c = true;
                    try{
                        update objDNote;
                    }catch(Exception ex){
                        apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,ex.getMessage()));
                    }
                }
                */
                
                
            }       
            
        }
        
        if(lstRecordTypes[0].Name=='Tyre Refurbishing Services'){
            list<AssignedResource> lstAssinedResources = [select Id,ETT_Vehicle_Detail__c,ServiceResource.Name,ETT_Vehicle_Detail__r.Name,ServiceAppointment.AppointmentNumber,ServiceAppointment.earliestStartTime,ServiceAppointment.DueDate from AssignedResource where 
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
                    objServiceAppointment.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Return Appointment').getRecordTypeId();  
                    objServiceAppointment.SchedStartTime = objServiceAppointment.EarliestStartTime;
                    objServiceAppointment.SchedEndTime = objServiceAppointment.DueDate; 
                    //objServiceAppointment.ParentRecordId = objWorkOrder.Id;
                    objServiceAppointment.ETT_Opportunity__c = oppObj.Id;
                    objServiceAppointment.ETT_Delivery_Note__c = DeliveryNoteId;
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
                
                
                ETT_Delivery_Note__c objDNote = [SELECT Id, Name, ETT_Is_Delivery_Appointment_Booked__c FROM ETT_Delivery_Note__c where Id=:DeliveryNoteId];            

                if(DeliveryNoteId != null){
                    objDNote.ETT_Is_Delivery_Appointment_Booked__c = true;
                    try{
                        update objDNote;
                    }catch(Exception ex){
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
        public  string strServiceResourceName;
        public  string strVehicleName;
        public  string strServiceAppointmentNumber;
        public  DateTime startTime;
        public  DateTime endTime;
    }
    
    @AuraEnabled
    public static void uploadSignedDeliveryNote(map<string,string> mapofStageJsonList,Id DeliveryAppointmentId){
        
        list<ETT_FileUploadWrapper> lstFileUploadWrapper;
        
        if(mapofStageJsonList.containskey('filesToUpload')){
            lstFileUploadWrapper =  (list<ETT_FileUploadWrapper>)JSON.deserialize(mapofStageJsonList.get('filesToUpload'),Type.forname('list<ETT_FileUploadWrapper>'));
        }
        
        
        if(lstFileUploadWrapper!=null && lstFileUploadWrapper.size()>0){
            list<ContentVersion> lstContentVesions = new list<ContentVersion>();
            list<ContentDocumentLink> lstContentDocumentLinks = new list<ContentDocumentLink>();
            list<Attachment> lstAttachments = new list<Attachment>();           
            for(ETT_FileUploadWrapper objFileUploadWrapper :lstFileUploadWrapper){
                Attachment objAttachment=new Attachment();      
                objAttachment.Name=objFileUploadWrapper.strFileName;
                Blob bodyBlob=EncodingUtil.base64Decode(objFileUploadWrapper.strBase64Data);
                objAttachment.body=bodyBlob;
                objAttachment.parentId= DeliveryAppointmentId; 
                lstAttachments.add(objAttachment);
            }
            
            try{ 
              insert lstAttachments;  
              system.debug('***lstAttachments*****'+lstAttachments);
            }Catch(Exception ex){
                system.debug('****Exception Cause ****'+ex.getMessage());
            }
           
        }
        
    }
    
}