@isTest
public class ETT_DeliveryAppointmentControllerTest {
    

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
        
        Opportunity oppInternal = ETT_TestFactory.createOpportunity('Tyre Internal','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert oppInternal; //insert opportunity        
        
        Contact con=new Contact();
        con.LastName = 'Test';
        con.AccountId=opp.AccountId;
        insert con; //insert contact
        
        

        
        
        PageReference pageRef = Page.ETT_DeliveryAppointment;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ETT_DeliveryAppointmentController objDeliveryApt = new ETT_DeliveryAppointmentController(sc);
        objDeliveryApt.isSkipAppointment = true;
        objDeliveryApt.serviceAppointmentRedirect();
        //objDeliveryApt.deliveryAppointmentRedirect();
        
        
        ETT_DeliveryAppointmentController.AssignedResourceWrapper objAssignedResourceWrapper = new ETT_DeliveryAppointmentController.AssignedResourceWrapper();
        objAssignedResourceWrapper.strServiceAppointmentNumber = '001';
        objAssignedResourceWrapper.strServiceResourceName = 'Anil';
        objAssignedResourceWrapper.strVehicleName = 'ETT_VAN';
        objAssignedResourceWrapper.startTime = DateTime.Now().AddDays(+2);
        objAssignedResourceWrapper.endTime = DateTime.Now().AddDays(+5);
        

        
       /* ServiceResource objServiceResource = new ServiceResource();
        objServiceResource.Name = 'Rohan';
        objServiceResource.ResourceType = 'T';
        objServiceResource.IsActive=true;
        insert objServiceResource;*/
        
        PageReference pageRefService = Page.ETT_DeliveryAppointment;
        Test.setCurrentPage(pageRefService);
        pageRefService.getParameters().put('Id', String.valueOf(oppService.Id));
        ApexPages.StandardController scService = new ApexPages.StandardController(oppService);
        
        ETT_DeliveryAppointmentController objDeliveryAptService = new ETT_DeliveryAppointmentController(scService);
        objDeliveryAptService.isSkipAppointment = true;
        objDeliveryAptService.serviceAppointmentRedirect();
        //objDeliveryAptService.deliveryAppointmentRedirect();
        
        PageReference pageRefB2B = Page.ETT_DeliveryAppointment;
        Test.setCurrentPage(pageRefB2B);
        pageRefB2B.getParameters().put('Id', String.valueOf(oppB2B.Id));
        ApexPages.StandardController scB2B = new ApexPages.StandardController(oppB2B);
        
        ETT_DeliveryAppointmentController objDeliveryAptB2B = new ETT_DeliveryAppointmentController(scB2B);
        objDeliveryAptB2B.isSkipAppointment = true;
        objDeliveryAptB2B.serviceAppointmentRedirect();
        
        objDeliveryAptB2B.DeliveryNote = 'Test Note';
        objDeliveryAptB2B.DeliveryNoteId = '001';
        objDeliveryAptB2B.isDeliveryAptBooked = true;
        objDeliveryAptB2B.oppObj = oppB2B;
        
        PageReference pageRefInternal = Page.ETT_DeliveryAppointment;
        Test.setCurrentPage(pageRefInternal);
        pageRefInternal.getParameters().put('Id', String.valueOf(oppInternal.Id));
        ApexPages.StandardController scInternal = new ApexPages.StandardController(oppInternal);
        
        ETT_DeliveryAppointmentController objDeliveryAptInternal = new ETT_DeliveryAppointmentController(scInternal);
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
        ETT_DeliveryAppointmentController.lstAssignedResources();
        objDeliveryApt.isSkipAppointment = true;
        objDeliveryApt.skipAppointment();        
		        

        map<string,string> mapofStageJsonList = new map<string,string> ();
        ETT_FileUploadWrapper wrp = new ETT_FileUploadWrapper();
        wrp.fileSourceType = 'Test';
        wrp.strFileType = 'Test';
        wrp.strBase64Data = 'Test';
        wrp.strFileName = 'Test';
        list<ETT_FileUploadWrapper> lstWrapper = new list<ETT_FileUploadWrapper>{wrp};
        mapofStageJsonList.put('filesToUpload', JSON.serialize(lstWrapper));
        ID DeliveryAppointmentId;
        ETT_DeliveryAppointmentController.uploadSignedDeliveryNote(mapofStageJsonList, DeliveryAppointmentId);        
       
        objDeliveryApt.deliveryAppointmentRedirect();
        //objDeliveryAptService.deliveryAppointmentRedirect();
        //objDeliveryAptB2B.deliveryAppointmentRedirect();
        //objDeliveryAptInternal.deliveryAppointmentRedirect();
        
        
        
        test.stopTest();
        
        
    }
    @istest
    public static void testCase1(){
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
        insert opp;
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tyre Refurbishing Services').getRecordTypeId();
        opp.RecordTypeId = devRecordTypeId;
        update opp;
        PageReference pageRef = Page.ETT_DeliveryAppointment;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        Contact con=new Contact();
        con.LastName = 'Test';
        con.AccountId=opp.AccountId;
        insert con;
        ETT_Collection_Card__c ett_collection_card = new ETT_Collection_Card__c(
            CurrencyIsoCode = 'AED',
            ETT_Accounts__c = objAcc1.id,
            ETT_All_Tyre_Rejected__c = false,
            ETT_CCL_Created__c = false,
            ETT_Check_In__c = DateTime.newInstance(2020,12,14,7,439,26392),
            ETT_Check_Out__c = DateTime.newInstance(2020,12,14,7,440,26438),
            ETT_Collection_Date__c = Date.newInstance(2020,12,07),
            ETT_Collection_Status__c = 'Accepted',
            ETT_Collection_Team_Submitted__c = true,
            ETT_Completed__c = false,
            ETT_Create_Job_Card__c = false,
            ETT_Estimation_Completed_By_Fm__c = false,
            ETT_Estimation_Completed_By_HOO__c = false,
            ETT_Factory_Manager_Approved__c = false,
            ETT_Head_Of_Operation_Approved__c = false,
            ETT_Inspection_Done__c = true,
            ETT_Job_Card_Done__c = false,
            ETT_Location__c = 'Dubai',
            ETT_Receptionist_Acceptance__c = false,
            ETT_Sales_Acceptance__c = false,
            ETT_Status__c = 'Collection Stage',
            ETT_Submitted_For_Approval__c = false,
            ETT_Is_Active__c = false);
        
        insert ett_collection_card;
        
        ETT_Inspection_Card__c ett_inspection_card = new ETT_Inspection_Card__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = objAcc1.id,
            ETT_Chalk_Crayon_Yellow__c = true,
            ETT_Collection_Card__c = ett_collection_card.id,
            ETT_Contact__c = con.id,
            ETT_Cutting_Player__c = true,
            ETT_Electrical_Prob_In_Working_Condition__c = true,
            ETT_Handheld_Drop_Light__c = true,
            ETT_Industrial_Vacuum_Cleaner__c = true,
            ETT_Knife__c = true,
            ETT_Nail_Remover__c = true,
            ETT_Poking_Screwdriver__c = true,
            ETT_Spiral_Cement_Tool__c = true,
            ETT_Spreader_Light_Condition__c = true,
            ETT_Staple_Gun__c = true,
            ETT_Status__c = 'Send Back',
            ETT_Tyre_Life__c = '1',
            ETT_Tyre_Lift_In_Working_Condition__c = true,
            ETT_Tyre_Serial_Number__c = '1234',
            ETT_Tyre_Spreader_In_Working_Condition__c = true,
            ETT_Tyre_Tapping_Tool__c = true);
        
        insert ett_inspection_card;
        ETT_Delivery_Note__c ett_delivery_note = new ETT_Delivery_Note__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = objAcc1.id,
            ETT_Is_Delivery_Appointment_Booked__c = false);
        insert ett_delivery_note;
        
        ETT_Delivery_Line_Item__c ett_delivery_line_item = new ETT_Delivery_Line_Item__c(
            CurrencyIsoCode = 'AED',
            ETT_Collection_Card__c = ett_collection_card.id,
            ETT_Delivery_Note__c = ett_delivery_note.id,
            ETT_Inspection_Card__c = ett_inspection_card.id,
            ETT_Is_Checked__c = false,
            ETT_Job_Type__c = 'Retread');
        insert ett_delivery_line_item;

        
        ETT_DeliveryAppointmentController testAccPlan = new ETT_DeliveryAppointmentController(sc);
        testAccPlan.deliveryAppointmentRedirect();
    }
    
    
    /*
@istest (SeeAllData=true)
public static void testCase1(){
Account objAcc1 = new Account();
objAcc1.Name = 'First Account';
insert objAcc1;
Opportunity opp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier','TestOppName', 'Qualification', system.today().adddays(20), objAcc1.Id);
insert opp;

PageReference pageRef = Page.ETT_DeliveryAppointment;
Test.setCurrentPage(pageRef);
pageRef.getParameters().put('Id', String.valueOf(opp.Id));
ApexPages.StandardController sc = new ApexPages.StandardController(opp);

Contact con=new Contact();
con.LastName = 'Test';
con.AccountId=opp.AccountId;
insert con;
ETT_Collection_Card__c ett_collection_card = new ETT_Collection_Card__c(
CurrencyIsoCode = 'AED',
ETT_Accounts__c = objAcc1.id,
ETT_All_Tyre_Rejected__c = false,
ETT_CCL_Created__c = false,
ETT_Check_In__c = DateTime.newInstance(2020,12,14,7,439,26392),
ETT_Check_Out__c = DateTime.newInstance(2020,12,14,7,440,26438),
ETT_Collection_Date__c = Date.newInstance(2020,12,07),
ETT_Collection_Status__c = 'Accepted',
ETT_Collection_Team_Submitted__c = true,
ETT_Completed__c = false,
ETT_Create_Job_Card__c = false,
ETT_Estimation_Completed_By_Fm__c = false,
ETT_Estimation_Completed_By_HOO__c = false,
ETT_Factory_Manager_Approved__c = false,
ETT_Head_Of_Operation_Approved__c = false,
ETT_Inspection_Done__c = true,
ETT_Job_Card_Done__c = false,
ETT_Location__c = 'Dubai',
ETT_Receptionist_Acceptance__c = false,
ETT_Sales_Acceptance__c = false,
ETT_Status__c = 'Collection Stage',
ETT_Submitted_For_Approval__c = false,
ETT_Is_Active__c = false);

insert ett_collection_card;

ETT_Inspection_Card__c ett_inspection_card = new ETT_Inspection_Card__c(
CurrencyIsoCode = 'AED',
ETT_Account__c = objAcc1.id,
ETT_Chalk_Crayon_Yellow__c = true,
ETT_Collection_Card__c = ett_collection_card.id,
ETT_Contact__c = con.id,
ETT_Cutting_Player__c = true,
ETT_Electrical_Prob_In_Working_Condition__c = true,
ETT_Handheld_Drop_Light__c = true,
ETT_Industrial_Vacuum_Cleaner__c = true,
ETT_Knife__c = true,
ETT_Nail_Remover__c = true,
ETT_Poking_Screwdriver__c = true,
ETT_Spiral_Cement_Tool__c = true,
ETT_Spreader_Light_Condition__c = true,
ETT_Staple_Gun__c = true,
ETT_Status__c = 'Send Back',
ETT_Tyre_Life__c = '1',
ETT_Tyre_Lift_In_Working_Condition__c = true,
ETT_Tyre_Serial_Number__c = '1234',
ETT_Tyre_Spreader_In_Working_Condition__c = true,
ETT_Tyre_Tapping_Tool__c = true);

insert ett_inspection_card;
ETT_DeliveryAppointmentController testAccPlan = new ETT_DeliveryAppointmentController(sc);
testAccPlan.isDeliveryAppointment = false;
testAccPlan.deliveryWorkType();
testAccPlan.isSkipAppointment = false;
testAccPlan.skipAppointment();
testAccPlan.getpriorityOptions();
ETT_DeliveryAppointmentController.lstAssignedResources();
}
*/
    
}