@isTest
public class ETT_DeliveryAppointmentCalendar_Test {
    @isTest(SeeAllData=true)
    public static void testMethod1(){
        
        Map<String,String> mapList = new  Map<String,String>();
        
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1; //insert account
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert opp; //insert opportunity
        
        Opportunity oppService = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert oppService; //insert opportunity
        
        Opportunity oppB2B = ETT_TestFactory.createOpportunity('Tyre - Credit/B2B Supplier','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert oppB2B; //insert opportunity
        
        Opportunity oppInternal = ETT_TestFactory.createOpportunity('Tyre Internal','TestOppNameInternal', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert oppInternal; //insert opportunity        
        
        Contact con=new Contact();
        con.LastName = 'Test';
        con.AccountId=opp.AccountId;
        insert con; //insert contact
        
        

		/*        

        WorkOrder WO = new WorkOrder (AccountId = objAcc1.Id);
        insert WO;
        
        OperatingHours objOH = new OperatingHours();
        objOH.Name = 'TestOH';
        insert objOH; 
        
        ServiceTerritory objST = new ServiceTerritory();
        objST.Name = 'Test Territory';
        objST.OperatingHoursId = objOH.Id;
        objST.IsActive = TRUE;
        insert objST;
        
        ServiceTerritoryMember objSTM = new ServiceTerritoryMember();
        objSTM.TerritoryType = 'P';
        objSTM.ServiceTerritoryId = objST.Id;
        objSTM.ServiceResourceId = objServiceResource.Id;
        objSTM.EffectiveStartDate = Date.today().addYears(+1);
        objSTM.EffectiveEndDate = Date.today().addYears(+10);
        objSTM.OperatingHoursId = objOH.Id;
        insert objSTM;
        
        DateTime EarliestStartTime = DateTime.Now().AddDays(+3);
        DateTime DueDate = DateTime.Now().AddDays(+5);
        
        System.debug('EarliestStartTime: '+EarliestStartTime);
        System.debug('DueDate: '+DueDate);
        
        
        ServiceAppointment appnt = new ServiceAppointment();
        appnt.ParentRecordId = wo.Id;
        appnt.ServiceTerritoryId = objST.Id;
        //appnt.status = 'Scheduled';
        appnt.SchedStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
            datetime enddate = wo.StartDate !=null ? wo.StartDate.addDays(1) :Date.today().addDays(1);
        appnt.EarliestStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
            appnt.DueDate =  wo.StartDate !=null ? wo.StartDate.addDays(2) :Date.today().addDays(2);
        appnt.SchedEndTime = enddate;
        
        insert appnt;
        
        /*ServiceAppointment objServiceAppointment = new ServiceAppointment();
        objServiceAppointment.ETT_Opportunity__c = opp.Id;
        objServiceAppointment.Status = 'New';
        objServiceAppointment.ServiceTerritoryId = objST.Id;
        objServiceAppointment.EarliestStartTime = EarliestStartTime;
        objServiceAppointment.DueDate = DueDate;
        //objServiceAppointment.SchedStartTime = DateTime.Now().AddDays(+4);
        //objServiceAppointment.SchedEndTime = DateTime.Now().AddDays(+5);
        objServiceAppointment.ParentRecordId = WO.Id;
        objServiceAppointment.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        insert objServiceAppointment;*/
        /*
        AssignedResource objAssignedResource = new AssignedResource();
        objAssignedResource.ETT_Vehicle_Detail__c = objVehicle.Id;
        objAssignedResource.ServiceResourceId = objServiceResource.Id;
        objAssignedResource.ServiceAppointmentId = appnt.Id;
        insert objAssignedResource;
		*/        
        
        PageReference pageRef = Page.ETT_DeliveryAppointmentCalender;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ETT_DeliveryAppointmentCalender objDeliveryApt = new ETT_DeliveryAppointmentCalender(sc);
        objDeliveryApt.isSkipAppointment = true;
        objDeliveryApt.serviceAppointmentRedirect();
        
        
        
        ETT_DeliveryAppointmentCalender.AssignedResourceWrapper objAssignedResourceWrapper = new ETT_DeliveryAppointmentCalender.AssignedResourceWrapper();
        objAssignedResourceWrapper.strServiceAppointmentNumber = '001';
        objAssignedResourceWrapper.strServiceResourceName = 'Anil';
        objAssignedResourceWrapper.strVehicleName = 'ETT_VAN';
        objAssignedResourceWrapper.startTime = DateTime.Now().AddDays(+2);
        objAssignedResourceWrapper.endTime = DateTime.Now().AddDays(+5);
        

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'staett', Email='standarduserforETT@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserett@testorg.com');
		insert u;
        
        ServiceResource objServiceResource = new ServiceResource();
        objServiceResource.Name = 'Rohan';
        objServiceResource.ResourceType = 'T';
        objServiceResource.IsActive=true;
        objServiceResource.RelatedRecordId = u.Id;
        insert objServiceResource;
        
        ETT_Vehicle_Details__c objVehicle = new ETT_Vehicle_Details__c();
        objVehicle.Name = 'ETTBus';
        objVehicle.ETT_Plate_Code__c = '123';
        objVehicle.ETT_Vehicle_Status__c = 'Owned';
        insert objVehicle;
        
        
         // work Type
        workType wType = new workType();
        //Id workType_recordTypeId = Schema.SObjectType.workType.getRecordTypeInfosByDeveloperName().get('ETI_Inspection_work_Type').getRecordTypeId();
        wType.ETI_Due_Date__c = 7;
        wType.DurationType = 'Minutes';
        wType.Name = 'Inspection';
        wType.EstimatedDuration = 30;
        //wType.RecordTypeId = workType_recordTypeId;
        insert wType;
       
        // workorder
         workOrder wo = new workOrder();
        Id recordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Inspection_Work_Order').getRecordTypeId();
        wo.StartDate = Datetime.Now();
        wo.Subject = 'Inspection';
        wo.ETI_Schedule_Appointment__c = true;
        wo.Street  = 'Alfahidhi';
        wo.City = 'Dubai';
        wo.PostalCode = '531116';
        wo.Country ='United Arab Emirates';
        wo.ContactId = con.Id;
        wo.WorkTypeId = wType.Id;
       
        insert wo;
       
       
        OperatingHours objOH = new OperatingHours();
        objOH.Name = 'TestOH';
        insert objOH; 
        
        ServiceTerritory objST = new ServiceTerritory();
        objST.Name = 'Test Territory';
        objST.OperatingHoursId = objOH.Id;
        objST.IsActive = TRUE;
        insert objST;
        
        ServiceTerritoryMember objSTM = new ServiceTerritoryMember();
        objSTM.TerritoryType = 'P';
        objSTM.ServiceTerritoryId = objST.Id;
        objSTM.ServiceResourceId = objServiceResource.Id;
        objSTM.EffectiveStartDate = Date.today().addYears(+1);
        objSTM.EffectiveEndDate = Date.today().addYears(+10);
        objSTM.OperatingHoursId = objOH.Id;
        insert objSTM;
        
        
        // Create Service Appointment
        ServiceAppointment appnt = new ServiceAppointment();
        appnt.ParentRecordId = wo.Id;
        appnt.status = 'None';
        appnt.SchedStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
        datetime enddate = wo.StartDate !=null ? wo.StartDate.addDays(1) :Date.today().addDays(1);
        appnt.EarliestStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
        appnt.DueDate =  wo.StartDate !=null ? wo.StartDate.addDays(2) :Date.today().addDays(2);
        appnt.SchedEndTime = enddate;
        String appntmntRecTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByDeveloperName().get('Inspection_Service_Appointment').getRecordTypeId();
        appnt.RecordTypeId = appntmntRecTypeId;
        appnt.ETI_isScheduleMailSent__c = false;
        appnt.ContactId = con.Id;
     appnt.ServiceTerritoryId = objST.Id;
        insert appnt;
        
        
        
        
        
        
        
        
        
        List<ServiceResource> lstServiceResource = [select Id from ServiceResource limit 1];        
        List<ETT_Vehicle_Details__c> lstVehicleDetails = [select Id from ETT_Vehicle_Details__c limit 1];
        List<ServiceAppointment> lstServiceAppointment = [select Id from ServiceAppointment limit 1];
        
      
        
      /*  AssignedResource objAssignedResource = new AssignedResource();
        objAssignedResource.ETT_Vehicle_Detail__c = lstVehicleDetails[0].Id;
        objAssignedResource.ServiceResourceId = lstServiceResource[0].Id;
        objAssignedResource.ServiceAppointmentId = appnt.Id; //lstServiceAppointment[0].Id;
        insert objAssignedResource;*/
        
        ETT_DeliveryAppointmentCalender.lstAssignedResources();
        
        
        
        
        
        
        PageReference pageRefService = Page.ETT_DeliveryAppointmentCalender;
        Test.setCurrentPage(pageRefService);
        pageRefService.getParameters().put('Id', String.valueOf(oppService.Id));
        ApexPages.StandardController scService = new ApexPages.StandardController(oppService);
        
        ETT_DeliveryAppointmentCalender objDeliveryAptService = new ETT_DeliveryAppointmentCalender(scService);
        objDeliveryAptService.isSkipAppointment = true;
        objDeliveryAptService.serviceAppointmentRedirect();
        
        
        PageReference pageRefB2B = Page.ETT_DeliveryAppointmentCalender;
        Test.setCurrentPage(pageRefB2B);
        pageRefB2B.getParameters().put('Id', String.valueOf(oppB2B.Id));
        ApexPages.StandardController scB2B = new ApexPages.StandardController(oppB2B);
        
        ETT_DeliveryAppointmentCalender objDeliveryAptB2B = new ETT_DeliveryAppointmentCalender(scB2B);
        objDeliveryAptB2B.isSkipAppointment = true;
        objDeliveryAptB2B.serviceAppointmentRedirect();
        
        objDeliveryAptB2B.DeliveryNote = 'Test Note';
        objDeliveryAptB2B.DeliveryNoteId = '001';
        objDeliveryAptB2B.isDeliveryAptBooked = true;
        objDeliveryAptB2B.oppObj = oppB2B;
        
        PageReference pageRefInternal = Page.ETT_DeliveryAppointmentCalender;
        Test.setCurrentPage(pageRefInternal);
        pageRefInternal.getParameters().put('Id', String.valueOf(oppInternal.Id));
        ApexPages.StandardController scInternal = new ApexPages.StandardController(oppInternal);
        
        ETT_DeliveryAppointmentCalender objDeliveryAptInternal = new ETT_DeliveryAppointmentCalender(scInternal);
        objDeliveryAptInternal.isSkipAppointment = true;
        objDeliveryAptInternal.serviceAppointmentRedirect();
        
        objDeliveryApt.getpriorityOptions();
        objDeliveryApt.isDeliveryAppointment = true;
        objDeliveryApt.deliveryWorkType();
        
        objDeliveryApt.isDeliveryAppointment = false;
        objDeliveryApt.deliveryWorkType();
        
        WorkOrder objworkorder=new WorkOrder();
        test.startTest();
        list<WorkType> lstWorkTypes = [select id,Name,RecordType.Name from workType where RecordType.Name in ('Tyre - Cash Supplier') and Name='Tyre Collection'];
        
        objDeliveryApt.isSkipAppointment = false;
        objDeliveryApt.skipAppointment();
        //objDeliveryApt.serviceAppointmentRedirect();
        ETT_DeliveryAppointmentCalender.lstAssignedResources();
        objDeliveryApt.isSkipAppointment = true;
        objDeliveryApt.skipAppointment();        
        

        
        
      /*  ETT_DeliveryAppointmentCalender.AssignedResourceWrapper objAssignedResourceWrapper = new ETT_DeliveryAppointmentCalender.AssignedResourceWrapper();
        objAssignedResourceWrapper.strServiceResourceName = 'Anil';
        objAssignedResourceWrapper.strServiceAppointmentNumber = '001';
        objAssignedResourceWrapper.strVehicleName = 'ETT Van';
        objAssignedResourceWrapper.startTime = System.now();
        objAssignedResourceWrapper.endTime = System.now();*/
        
        
        test.stopTest();
        
    }
    
}