@isTest
public class ETT_ServiceAppointmentController_test {
    
    @isTest(SeeAllData=true)
    public static void myTest() {
        
        ETT_ServiceAppointmentController.getselectOptions('ETT_Process__c');
        String accName = 'TestETTAcc'+Datetime.Now();
        
        List<Account> lstAcc = ETT_TestFactory.createAccounts(accName, 'Tyre Supplier');
        
        insert lstAcc;
        
        lstAcc[0].Party_Type__c = 'Supplier';
        lstAcc[0].ETT_Payment_Type__c = 'Cash';
        update lstAcc;
        
        List<ETT_Brand_Master__c> lstBrand = ETT_TestFactory.createBrandMasters();
        insert lstBrand;
        
        List<ETT_Tyre_Size_Master__c> lstTyreSize = ETT_TestFactory.createTyreSizeMaster();
        insert lstTyreSize;
        
        List<ETT_Pattern_Master__c> lstPattern = ETT_TestFactory.createPatternMasters();
        insert lstPattern;
        
        ETT_Country_Master__c objCountry = ETT_TestFactory.createCountries('Japan');
        insert objCountry;
        
        
        List<ETT_Tyre_Master__c> lstTyreMaster = ETT_TestFactory.createTyreMasters('Draft', lstPattern[0].Id, objCountry.Id, lstTyreSize[0].Id, lstBrand[0].Id);
        insert lstTyreMaster;

        lstTyreMaster[0].ETT_Load_Index__c = '20';
        lstTyreMaster[0].ETT_Ply_Rate__c = '20';
        lstTyreMaster[0].ETT_Speed_Index__c = '20';
        lstTyreMaster[0].ETT_Rim_Size__c = 20;
        lstTyreMaster[0].ETT_Length__c = 20;
		update lstTyreMaster;
        
        
        ETT_Price_Master__c objPM = new ETT_Price_Master__c();
        objPM.ETT_Party_Name__c = lstAcc[0].Id;
        insert objPM;
        
        ETT_Pricing_Information__c objPI = new ETT_Pricing_Information__c();
        objPI.ETT_Price__c =objPM.Id;
        objPI.ETT_Tyre_Size__c = lstTyreSize[0].Id;
        objPI.ETT_Brand__c = lstBrand[0].Id;
        objPI.ETT_Pattern__c = lstPattern[0].Id;
        objPI.ETT_Country_of_Origin__c = objCountry.Id;
        insert objPI;
        
        List<Account> lstAccCustomer = ETT_TestFactory.createAccounts('Rohan', 'Tyre Customer');
        
        insert lstAccCustomer;
        
        lstAccCustomer[0].Party_Type__c = 'Customer';
        lstAccCustomer[0].ETT_Payment_Type__c = 'Cash';
        update lstAccCustomer;
        
        
        ETT_Price_Master__c objPMCust = new ETT_Price_Master__c();
        objPMCust.ETT_Party_Name__c = lstAccCustomer[0].Id;
        insert objPMCust;
        
        ETT_Pricing_Information__c objPICust = new ETT_Pricing_Information__c();
        objPICust.ETT_Price__c =objPMCust.Id;
        objPICust.ETT_Tyre_Size__c = lstTyreSize[0].Id;
        objPICust.ETT_Brand__c = lstBrand[0].Id;
        objPICust.ETT_Pattern__c = lstPattern[0].Id;
        objPICust.ETT_Country_of_Origin__c = objCountry.Id;
        insert objPICust;
        
        
        Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Accountid= lstAcc[0].Id;
        insert cont;
        
        Opportunity objOpp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier', 'testOpp', 'Qualification', Date.today() + 180, lstAcc[0].Id);
        insert objOpp;
        
        ETT_ServiceAppointmentController.objContactDetails(objOpp.Id);
        
        WorkOrder objWorkOrder1 = new WorkOrder (AccountId = lstAcc[0].Id,StartDate = Datetime.Now());
        insert objWorkOrder1;
        
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'ETT_Collection Team'].Id,
            LastName = 'last'+Datetime.Now(),
            Email = 'test@amama.com',
            Username = 'test@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        
        
        ServiceResource objServiceResource = new ServiceResource();
        objServiceResource.Name = 'Rohan'+Datetime.Now();
        objServiceResource.ResourceType = 'T';
        objServiceResource.RelatedRecordId = u.Id;
        objServiceResource.IsActive=true;
        insert objServiceResource;
        
        ETT_Vehicle_Details__c objVehicle = new ETT_Vehicle_Details__c();
        objVehicle.Name = 'ETT Van';
        objVehicle.ETT_Plate_Code__c = '123';
        objVehicle.ETT_License_Registration__c = '1234567';
        objVehicle.ETT_Vehicle_Status__c = 'Owned';
        insert objVehicle;
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'TestOH';
        insert oh;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'India';
        objServiceTerritory.OperatingHoursId = oh.Id;
        objServiceTerritory.IsActive = true;
        insert objServiceTerritory;
        
        ServiceTerritoryMember objSTM = new ServiceTerritoryMember();
        objSTM.TerritoryType = 'P';
        objSTM.ServiceTerritoryId = objServiceTerritory.Id;
        objSTM.ServiceResourceId = objServiceResource.Id;
        objSTM.EffectiveStartDate = Date.today().addYears(-1);
        objSTM.EffectiveEndDate = Date.today().addYears(2);
        insert objSTM;
        
        ServiceAppointment objServiceAppt = new ServiceAppointment();
        objServiceAppt.ETT_Opportunity__c = objOpp.Id;
        objServiceAppt.Status = 'None';
        //objServiceAppt.EarliestStartTime = DateTime.Now().AddDays(+2);
        objServiceAppt.EarliestStartTime = objWorkOrder1.StartDate !=null ? (objWorkOrder1.StartDate ):(Date.today());
        objServiceAppt.DueDate = DateTime.Now().AddDays(+5);
        objServiceAppt.SchedStartTime = DateTime.Now().AddDays(+4);
        objServiceAppt.SchedEndTime = DateTime.Now().AddDays(+5);
        objServiceAppt.ParentRecordId = objWorkOrder1.Id;
        objServiceAppt.ServiceTerritoryId = objServiceTerritory.Id;
        objServiceAppt.Duration = 1;
        objServiceAppt.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        //insert objServiceAppt;
        
        
        AssignedResource objAssignedResource = new AssignedResource();
        objAssignedResource.ETT_Vehicle_Detail__c = objVehicle.Id;
        objAssignedResource.ServiceResourceId = objServiceResource.Id;
        //objAssignedResource.ServiceAppointmentId = objServiceAppt.Id;
        //insert objAssignedResource;
        
        WorkOrder objWorkOrder = new WorkOrder (AccountId = lstAcc[0].Id);
        //insert objWorkOrder;
        
        Test.startTest();
        ETT_ServiceAppointmentController.workOrderProcess(lstAcc[0], objWorkOrder, objServiceAppt, objAssignedResource, false);

        
        
        
        
                ServiceAppointment objServiceApptSkip = new ServiceAppointment();
        objServiceApptSkip.ETT_Opportunity__c = objOpp.Id;
        objServiceApptSkip.Status = 'None';
        //objServiceAppt.EarliestStartTime = DateTime.Now().AddDays(+2);
        objServiceApptSkip.EarliestStartTime = objWorkOrder1.StartDate !=null ? (objWorkOrder1.StartDate ):(Date.today());
        objServiceApptSkip.DueDate = DateTime.Now().AddDays(+5);
        objServiceApptSkip.SchedStartTime = DateTime.Now().AddDays(+4);
        objServiceApptSkip.SchedEndTime = DateTime.Now().AddDays(+5);
        objServiceApptSkip.ParentRecordId = objWorkOrder1.Id;
        objServiceApptSkip.ServiceTerritoryId = objServiceTerritory.Id;
        objServiceApptSkip.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        //insert objServiceAppt;
        
        
        AssignedResource objAssignedResourceSkip = new AssignedResource();
        objAssignedResourceSkip.ETT_Vehicle_Detail__c = objVehicle.Id;
        objAssignedResourceSkip.ServiceResourceId = objServiceResource.Id;
        //objAssignedResource.ServiceAppointmentId = objServiceAppt.Id;
        //insert objAssignedResource;
        
        WorkOrder objWorkOrderSkip = new WorkOrder (AccountId = lstAcc[0].Id);

ETT_ServiceAppointmentController.workOrderProcess(lstAcc[0], objWorkOrderSkip, objServiceApptSkip, objAssignedResourceSkip, true);



        
        
        ServiceAppointment objServiceApptCustomer = new ServiceAppointment();
        objServiceApptCustomer.ETT_Opportunity__c = objOpp.Id;
        objServiceApptCustomer.Status = 'None';
        //objServiceAppt.EarliestStartTime = DateTime.Now().AddDays(+2);
        objServiceApptCustomer.EarliestStartTime = objWorkOrder1.StartDate !=null ? (objWorkOrder1.StartDate ):(Date.today());
        objServiceApptCustomer.DueDate = DateTime.Now().AddDays(+5);
        objServiceApptCustomer.SchedStartTime = DateTime.Now().AddDays(+4);
        objServiceApptCustomer.SchedEndTime = DateTime.Now().AddDays(+5);
        //objServiceApptCustomer.ParentRecordId = objWorkOrder1.Id;
        objServiceApptCustomer.ServiceTerritoryId = objServiceTerritory.Id;
        objServiceApptCustomer.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        objServiceApptCustomer.Duration = 1;
        
        AssignedResource objAssignedResourceCustomer = new AssignedResource();
        objAssignedResourceCustomer.ETT_Vehicle_Detail__c = objVehicle.Id;
        objAssignedResourceCustomer.ServiceResourceId = objServiceResource.Id;

        
        WorkOrder objWOCustomer = new WorkOrder (AccountId = lstAccCustomer[0].Id);        
        ETT_ServiceAppointmentController.workOrderProcess(lstAccCustomer[0], objWOCustomer, objServiceApptCustomer, objAssignedResourceCustomer, false);
       
        
        
        ServiceAppointment objServiceApptCustomerFlag = new ServiceAppointment();
        objServiceApptCustomerFlag.ETT_Opportunity__c = objOpp.Id;
        objServiceApptCustomerFlag.Status = 'None';
        //objServiceAppt.EarliestStartTime = DateTime.Now().AddDays(+2);
        objServiceApptCustomerFlag.EarliestStartTime = objWorkOrder1.StartDate !=null ? (objWorkOrder1.StartDate ):(Date.today());
        objServiceApptCustomerFlag.DueDate = DateTime.Now().AddDays(+5);
        objServiceApptCustomerFlag.SchedStartTime = DateTime.Now().AddDays(+4);
        objServiceApptCustomerFlag.SchedEndTime = DateTime.Now().AddDays(+5);
        //objServiceApptCustomer.ParentRecordId = objWorkOrder1.Id;
        objServiceApptCustomerFlag.ServiceTerritoryId = objServiceTerritory.Id;
        objServiceApptCustomerFlag.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        objServiceApptCustomerFlag.Duration = 1;
        
        AssignedResource objAssignedResourceCustomerFlag = new AssignedResource();
        objAssignedResourceCustomerFlag.ETT_Vehicle_Detail__c = objVehicle.Id;
        objAssignedResourceCustomerFlag.ServiceResourceId = objServiceResource.Id;

        WorkOrder objWOCustomerFlag = new WorkOrder (AccountId = lstAccCustomer[0].Id);                
        ETT_ServiceAppointmentController.workOrderProcess(lstAccCustomer[0], objWOCustomerFlag, objServiceApptCustomerFlag, objAssignedResourceCustomerFlag, true);
        Test.stopTest();        
        
        
        
        
        //workOrderProcess(Account objAcct,WorkOrder objWorkOrder,ServiceAppointment objServiceAppt,AssignedResource objAssignedResource,boolean isSkipAppointment){
        /*
ETT_ServiceResourcesController.AssignedResourceWrapper objAssignedResource = new ETT_ServiceResourcesController.AssignedResourceWrapper();
objAssignedResource.strServiceAppointmentNumber = '1234';
objAssignedResource.startTime = System.now();
objAssignedResource.endTime = System.now();
objAssignedResource.strServiceResourceName = 'Anil';
objAssignedResource.strVehicleName = 'Bus';



PageReference pageRef = Page.ETT_ServiceAppointmentCalender;
Test.setCurrentPage(pageRef);

Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId();

Account testAccount = new Account();
testAccount.Name = 'Test Account';
testAccount.RecordTypeId = accRecordTypeId;
testAccount.Phone = '+971 68867598';
testAccount.AccountNumber = '123';
insert testAccount;

Contact cont = new Contact();
cont.FirstName='Test';
cont.LastName='Test';
cont.Accountid= testAccount.id;
insert cont;

Opportunity objOpp = new Opportunity();
objOpp.Name = 'Test Opp';
objOpp.StageName = 'Qualification';
objOpp.CloseDate = System.today();
objOpp.AccountId = testAccount.Id;
insert objOpp;

ApexPages.CurrentPage().getparameters().put('id', objOpp.id);
ApexPages.CurrentPage().getparameters().put('isChecked', 'true');
ApexPages.StandardController sc = new ApexPages.standardController(objOpp);

ETT_ServiceResourcesController objServiceResource = new ETT_ServiceResourcesController(sc);

objServiceResource.isSkipAppointment = true;
//objServiceResource.isSkipAppointment = true;        
objServiceResource.DeliveryNote = 'testNote';
objServiceResource.isDeliveryAppointment = true;
objServiceResource.isDeliveryAptBooked = true;
objServiceResource.DeliveryNoteId = 'dummyId';
//objServiceResource.
List<WorkType> lstWorkTypes = new List<WorkType>();
Id devRecordTypeId = Schema.SObjectType.WorkType.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
WorkType obj = new WorkType();
obj.Name = 'Tyre Collection';
obj.EstimatedDuration = 120;
obj.DurationType = 'Minutes';
obj.RecordTypeId = devRecordTypeId;

WorkType obj_2 = new WorkType();
obj_2.Name = 'Tyre Delivery';
obj_2.EstimatedDuration = 100;
obj_2.DurationType = 'Minutes';
obj_2.RecordTypeId = devRecordTypeId;

lstWorkTypes.add(obj);
lstWorkTypes.add(obj_2);
System.debug('lstWorkTypes: '+lstWorkTypes);
insert lstWorkTypes;

System.debug('lstWorkTypes: '+lstWorkTypes);
list<WorkType> lstWorkTypesDemo = [select id,Name from WorkType where RecordType.Name='Tyre - Cash Supplier' Order by Name Desc];
System.debug('lstWorkTypesDemo: '+lstWorkTypesDemo);        



objServiceResource.getpriorityOptions();
objServiceResource.changeSkipAppointmentValue();


objServiceResource.skipAppointment();
objServiceResource.isSkipAppointment = false;
objServiceResource.skipAppointment();

objServiceResource.deliveryWorkType();
objServiceResource.isDeliveryAppointment = false;
objServiceResource.deliveryWorkType();
//objServiceResource.selectedPriority();

//objServiceResource.deliveryWorkType();
//
// ETT_ServiceResourcesController.selectedPriority objSelectPriority = new ETT_ServiceResourcesController.selectedPriority();
objServiceResource.selectedPriority = 'High';



//PageReference serviceAppointmentRedirect()
//ETT_ServiceResourcesController.serviceAppointmentRedirect();

Id oppTyreCashSupplierRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();        
Opportunity objOppSupplier = new Opportunity();
objOppSupplier.RecordTypeId = oppTyreCashSupplierRecordTypeId;
insert objOppSupplier;


Id oppTyreCashSupplierRecordTypeId2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tyre Refurbishing Services').getRecordTypeId();        
Opportunity objOppSupplier2 = new Opportunity();
objOppSupplier2.RecordTypeId = oppTyreCashSupplierRecordTypeId2;
insert objOppSupplier2;

Id oppTyreCashSupplierRecordTypeId3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tyre - Credit/B2B Supplier').getRecordTypeId();        
Opportunity objOppSupplier3 = new Opportunity();
objOppSupplier3.RecordTypeId = oppTyreCashSupplierRecordTypeId3;
insert objOppSupplier3;

//ETT_ServiceResourcesController.serviceAppointmentRedirect();

*/
        
        
        
        
    }
    
}