@isTest
public class ETT_ServiceResourcesController_test {
    
    
    @isTest(SeeAllData=false)
    static  void Controller_TestClass(){
        Account acc = new Account();
        acc.Name = 'Test1'+Datetime.Now();
        insert acc;
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        Contact con = new Contact();
        con.LastName = 'Test';
        // con.RecordTypeId = conRecordTypeId;
        con.AccountId = acc.Id;
        insert con;
        Opportunity opportunity = new Opportunity(
            IsPrivate = false,
            AccountId = acc.Id,
            Name = 'ABC FZ LLC',
            StageName = 'Qualification',
            Probability = 10.0,
            recordtypeid = oppRecordTypeId,
            CloseDate = Date.newInstance(2021,12,31),
            ForecastCategoryName = 'Pipeline',
            CurrencyIsoCode = 'AED',
            IsExcludedFromTerritory2Filter = false,
            Budget_Confirmed__c = false,
            Legal_Contract_Status__c = false,
            IsClosedOpportunity__c = false,
            isLegalContractCreated__c = false,
            isSalesAgreementCreated__c = false,
            isPricingCreated__c = false,
            ETSALES_Discovery_Completed__c = false,
            ETSALES_Prospect_Number__c = 'Lead# 00000346',
            ROI_Analysis_Completed__c = false);
        insert opportunity;
        opportunity = [SELECT Name , Recordtype.Name, AccountId FROM Opportunity WHERE id = :opportunity.id];
        PageReference pageRef = Page.ETT_ServiceAppointmentCalender;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('isChecked', String.valueOf(true));
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        ETT_ServiceResourcesController testAccPlan = new ETT_ServiceResourcesController(sc);
        Test.startTest();
        testAccPlan.changeSkipAppointmentValue();
        testAccPlan.getpriorityOptions();
        testAccPlan.skipAppointment();
        testAccPlan.isSkipAppointment = true; 
        testAccPlan.serviceAppointmentRedirect();
        testAccPlan.objServiceAppointment = new ServiceAppointment();
        testAccPlan.objServiceAppointment.earliestStartTime = System.today()+1;
        testAccPlan.objServiceAppointment.DueDate= System.today()+5;
        testAccPlan.serviceAppointmentRedirect();
        testAccPlan.skipAppointment();
        testAccPlan.isSkipAppointment = false; 
        testAccPlan.serviceAppointmentRedirect();
        ETT_ServiceResourcesController.lstAssignedResources();
        
        ETT_ServiceResourcesController.AssignedResourceWrapper objAssignedResource = new ETT_ServiceResourcesController.AssignedResourceWrapper();
        objAssignedResource.startTime = Date.today();
        objAssignedResource.endTime = Date.today();
        objAssignedResource.strServiceAppointmentNumber = '123';
        objAssignedResource.strServiceResourceName = 'Anil';
        objAssignedResource.strVehicleName = 'ETT Bus';
        
         WorkType wType = new WorkType();
        
        Id workType_recordTypeId = Schema.SObjectType.WorkType.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        wType.ETI_Due_Date__c = 7;
        wType.DurationType = 'Minutes';
        wType.Name = 'Tyre Delivery';
        wType.EstimatedDuration = 30;
        wType.RecordTypeId = workType_recordTypeId;
        insert wType;

        testAccPlan.isDeliveryAppointment = true;
        testAccPlan.deliveryWorkType();
        
        WorkType wTypeTC = new WorkType();
        Id workType_recordTypeIdTC = Schema.SObjectType.WorkType.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        wTypeTC.ETI_Due_Date__c = 7;
        wTypeTC.DurationType = 'Minutes';
        wTypeTC.Name = 'Tyre Collection';
        wTypeTC.EstimatedDuration = 30;
        wTypeTC.RecordTypeId = workType_recordTypeIdTC;
        insert wTypeTC;

        
        
        testAccPlan.isDeliveryAppointment = false;
        testAccPlan.deliveryWorkType();     
        testAccPlan.callThisMethod();
        Test.stopTest();
    }
    
    @isTest(SeeAllData=false)
    static  void Controller_TestClass2(){
        Account acc = new Account();
        acc.Name = 'Test2'+Datetime.Now();
        insert acc;
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tyre Refurbishing Services').getRecordTypeId();
        Contact con = new Contact();
        con.LastName = 'Test';
        // con.RecordTypeId = conRecordTypeId;
        con.AccountId = acc.Id;
        insert con;
        Opportunity opportunity = new Opportunity(
            IsPrivate = false,
            AccountId = acc.Id,
            Name = 'ABC FZ LLC',
            StageName = 'Qualification',
            Probability = 10.0,
            recordtypeid = oppRecordTypeId,
            CloseDate = Date.newInstance(2021,12,31),
            ForecastCategoryName = 'Pipeline',
            CurrencyIsoCode = 'AED',
            IsExcludedFromTerritory2Filter = false,
            Budget_Confirmed__c = false,
            Legal_Contract_Status__c = false,
            IsClosedOpportunity__c = false,
            isLegalContractCreated__c = false,
            isSalesAgreementCreated__c = false,
            isPricingCreated__c = false,
            ETSALES_Discovery_Completed__c = false,
            ETSALES_Prospect_Number__c = 'Lead# 00000346',
            ROI_Analysis_Completed__c = false);
        insert opportunity;
        opportunity = [SELECT Name , Recordtype.Name, AccountId FROM Opportunity WHERE id = :opportunity.id];
        PageReference pageRef = Page.ETT_ServiceAppointmentCalender;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('isChecked', String.valueOf(true));
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        ETT_ServiceResourcesController testAccPlan = new ETT_ServiceResourcesController(sc);
        Test.startTest();
        testAccPlan.isSkipAppointment = false;
        testAccPlan.serviceAppointmentRedirect();
        testAccPlan.objServiceAppointment = new ServiceAppointment();
        testAccPlan.objServiceAppointment.earliestStartTime = System.today()+1;
        testAccPlan.objServiceAppointment.DueDate= System.today()+5;
        testAccPlan.isSkipAppointment = false; 
        testAccPlan.serviceAppointmentRedirect();
        
        Test.stopTest();
        
        
        
    }
    
    
    @isTest(SeeAllData=false)
    static  void Controller_TestClass3(){
        Account acc = new Account();
        acc.Name = 'Test3'+Datetime.Now();
        insert acc;
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tyre - Credit/B2B Supplier').getRecordTypeId();
        Contact con = new Contact();
        con.LastName = 'Test';
        // con.RecordTypeId = conRecordTypeId;
        con.AccountId = acc.Id;
        insert con;
        Opportunity opportunity = new Opportunity(
            IsPrivate = false,
            AccountId = acc.Id,
            Name = 'ABC FZ LLC',
            StageName = 'Qualification',
            Probability = 10.0,
            recordtypeid = oppRecordTypeId,
            CloseDate = Date.newInstance(2021,12,31),
            ForecastCategoryName = 'Pipeline',
            CurrencyIsoCode = 'AED',
            IsExcludedFromTerritory2Filter = false,
            Budget_Confirmed__c = false,
            Legal_Contract_Status__c = false,
            IsClosedOpportunity__c = false,
            isLegalContractCreated__c = false,
            isSalesAgreementCreated__c = false,
            isPricingCreated__c = false,
            ETSALES_Discovery_Completed__c = false,
            ETSALES_Prospect_Number__c = 'Lead# 00000346',
            ROI_Analysis_Completed__c = false);
        insert opportunity;
        opportunity = [SELECT Name , Recordtype.Name, AccountId FROM Opportunity WHERE id = :opportunity.id];
        PageReference pageRef = Page.ETT_ServiceAppointmentCalender;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('isChecked', String.valueOf(true));
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        ETT_ServiceResourcesController testAccPlan = new ETT_ServiceResourcesController(sc);
        Test.startTest();
       
        testAccPlan.isSkipAppointment = false;
        testAccPlan.serviceAppointmentRedirect();
        testAccPlan.objServiceAppointment = new ServiceAppointment();
        testAccPlan.objServiceAppointment.earliestStartTime = System.today()+1;
        testAccPlan.objServiceAppointment.DueDate= System.today()+5;
        testAccPlan.objServiceAppointment.Status = 'Scheduled';
        testAccPlan.objServiceAppointment.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByName().get('Tyre - Credit/B2B Supplier').getRecordTypeId();
            
        ETT_Vehicle_Details__c objVehicle = new ETT_Vehicle_Details__c();
        objVehicle.Name = 'ETT Van';
        objVehicle.ETT_Plate_Code__c = '123';
        objVehicle.ETT_License_Registration__c = '1234567';
        objVehicle.ETT_Vehicle_Status__c = 'Owned';
        insert objVehicle;
        
        
        AssignedResource objAR = new AssignedResource();
        objAR.ServiceAppointmentId = testAccPlan.objServiceAppointment.Id;
        objAR.ETT_Vehicle_Detail__c = objVehicle.Id;
		//insert objAR;
        
        testAccPlan.isSkipAppointment = false; 
        testAccPlan.serviceAppointmentRedirect();

        ETT_ServiceResourcesController.lstAssignedResources();
        
        Test.stopTest();
    }
    
    @isTest(SeeAllData=false)
    static  void Controller_TestClass4(){
        Account acc = new Account();
        acc.Name = 'Test4'+Datetime.Now();
        insert acc;
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tyre Internal').getRecordTypeId();
        Contact con = new Contact();
        con.LastName = 'Test';
        // con.RecordTypeId = conRecordTypeId;
        con.AccountId = acc.Id;
        insert con;
        Opportunity opportunity = new Opportunity(
            IsPrivate = false,
            AccountId = acc.Id,
            Name = 'ABC FZ LLC',
            StageName = 'Qualification',
            Probability = 10.0,
            recordtypeid = oppRecordTypeId,
            CloseDate = Date.newInstance(2021,12,31),
            ForecastCategoryName = 'Pipeline',
            CurrencyIsoCode = 'AED',
            IsExcludedFromTerritory2Filter = false,
            Budget_Confirmed__c = false,
            Legal_Contract_Status__c = false,
            IsClosedOpportunity__c = false,
            isLegalContractCreated__c = false,
            isSalesAgreementCreated__c = false,
            isPricingCreated__c = false,
            ETSALES_Discovery_Completed__c = false,
            ETSALES_Prospect_Number__c = 'Lead# 00000346',
            ROI_Analysis_Completed__c = false);
        insert opportunity;
        opportunity = [SELECT Name , Recordtype.Name, AccountId FROM Opportunity WHERE id = :opportunity.id];
        PageReference pageRef = Page.ETT_ServiceAppointmentCalender;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('isChecked', String.valueOf(true));
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        ETT_ServiceResourcesController testAccPlan = new ETT_ServiceResourcesController(sc);
        Test.startTest();
        
        testAccPlan.isSkipAppointment = false;
        testAccPlan.serviceAppointmentRedirect();
        testAccPlan.objServiceAppointment = new ServiceAppointment();
        testAccPlan.objServiceAppointment.earliestStartTime = System.today()+1;
        testAccPlan.objServiceAppointment.DueDate= System.today()+5;
        testAccPlan.isSkipAppointment = false; 
        testAccPlan.serviceAppointmentRedirect();
        
        Test.stopTest();
    }
   
     @isTest(SeeAllData=false)
    static  void Controller_TestClass5(){
        Account acc = new Account();
        acc.Name = 'Test5'+Datetime.Now();
        insert acc;
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tyre - Cash Individual').getRecordTypeId();
        Contact con = new Contact();
        con.LastName = 'Test';
        // con.RecordTypeId = conRecordTypeId;
        con.AccountId = acc.Id;
        insert con;
        Opportunity opportunity = new Opportunity(
            IsPrivate = false,
            AccountId = acc.Id,
            Name = 'ABC FZ LLC',
            StageName = 'Qualification',
            Probability = 10.0,
            recordtypeid = oppRecordTypeId,
            CloseDate = Date.newInstance(2021,12,31),
            ForecastCategoryName = 'Pipeline',
            CurrencyIsoCode = 'AED',
            IsExcludedFromTerritory2Filter = false,
            Budget_Confirmed__c = false,
            Legal_Contract_Status__c = false,
            IsClosedOpportunity__c = false,
            isLegalContractCreated__c = false,
            isSalesAgreementCreated__c = false,
            isPricingCreated__c = false,
            ETSALES_Discovery_Completed__c = false,
            ETSALES_Prospect_Number__c = 'Lead# 00000346',
            ROI_Analysis_Completed__c = false);
        insert opportunity;
        opportunity = [SELECT Name , Recordtype.Name, AccountId FROM Opportunity WHERE id = :opportunity.id];
        PageReference pageRef = Page.ETT_ServiceAppointmentCalender;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('isChecked', String.valueOf(true));
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        ETT_ServiceResourcesController testAccPlan = new ETT_ServiceResourcesController(sc);
        Test.startTest();
        
        testAccPlan.isSkipAppointment = false;
        testAccPlan.serviceAppointmentRedirect();
        testAccPlan.objServiceAppointment = new ServiceAppointment();
        testAccPlan.objServiceAppointment.earliestStartTime = System.today()+1;
        testAccPlan.objServiceAppointment.DueDate= System.today()+5;
        testAccPlan.isSkipAppointment = false; 
        testAccPlan.serviceAppointmentRedirect();
        
        Test.stopTest();
    }
   
    
}