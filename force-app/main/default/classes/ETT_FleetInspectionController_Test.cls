@isTest  public class ETT_FleetInspectionController_Test {
    @isTest 
    public static void ETT_FleetInspectionController(){
        
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test1';
        insert acc;
        
        
        ETT_Vehicle_Details__c objVehicle = new ETT_Vehicle_Details__c();
        objVehicle.Name = 'ETT Van';
        objVehicle.ETT_Plate_Code__c = '123';
        objVehicle.ETT_License_Registration__c = '1234567';
        objVehicle.ETT_Vehicle_Status__c = 'Owned';
        insert objVehicle;
        ETT_FleetInspectionController.getAccountInfo(acc.Id);
        ETT_FleetInspectionController.getVehicleNumber('A567D5');
        
    }
    @isTest static void testsaveDMLForFleetInspection(){
        
        
        Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        Map<String,String> mapList = new  Map<String,String>();
        List<Account> AccList = ETT_TestFactory.createAccounts('Rohan', 'Tyre Supplier');
        AccList[0].RecordTypeId = AccountRecordTypeId;
        insert AccList;
        
        
        
        List<ETT_FleetInspectionWrapper> lll = new List<ETT_FleetInspectionWrapper>();
        ETT_FleetInspectionWrapper l = new ETT_FleetInspectionWrapper();
        l.fileSourceType = 'Email';
        l.lstFileLoadWrapper = new List<ETT_FileUploadWrapper>();
        // l.objFleetInspection = stagingFleetInspectionsList[0];
        lll.add(l);
        
        
        
        List< ETT_Vehicle_Details__c> vehicleList= new List< ETT_Vehicle_Details__c>();
        ETT_Vehicle_Details__c an=new ETT_Vehicle_Details__c();
        an.Name='test';
        an.ETT_Internal_Number__c='3456';
        vehicleList.add(an);
        insert vehicleList;
        
        ETT_Fleet_Inspection__c FleetInspection = new ETT_Fleet_Inspection__c();  
        /*FleetInspection.ETT_Account__c = acc.Id;*/
        FleetInspection.ETT_Account__c = AccList[0].Id;
        //   insert FleetInspection;
        
        Fleet_Inspection_Line_Item__c FleetlineItem = new Fleet_Inspection_Line_Item__c();
        // FleetlineItem.Fleet_Inspection__c = FleetInspection.id;
        //	insert FleetlineItem;
        
        Test.startTest();
        mapList.put('stgAccountJson',JSON.serialize(AccList[0]));
        
        mapList.put('stgFleetInspectionJson',JSON.serialize(FleetInspection));
        
        
        // base64 encode the blob that contains our url param value
        
        Blob beforeblob = Blob.valueOf('TestFilePath');
        ETT_FileUploadWrapper fileUploadWrapper = new ETT_FileUploadWrapper();
        fileUploadWrapper.fileSourceType = 'FL';
        fileUploadWrapper.strFileName= 'Test.img';
        fileUploadWrapper.strBase64Data = EncodingUtil.base64Encode(beforeblob);
        fileUploadWrapper.strFileType= 'Image/JPEG';
        ETT_FleetInspectionWrapper fleetInspectionWrapper = new ETT_FleetInspectionWrapper();
        fleetInspectionWrapper.lstFileLoadWrapper = new List<ETT_FileUploadWrapper>{fileUploadWrapper};
            fleetInspectionWrapper.fileSourceType = 'FL' ;
        fleetInspectionWrapper.objFleetInspection = FleetlineItem;
        System.debug('fleetInspectionWrapper jspn='+JSON.serialize(fleetInspectionWrapper));
        //  List<Sobject> lstSobjectInfo = new List<Sobject>{stagingQuoteList[0]};
        List<ETT_FleetInspectionWrapper> fleetInspectionWrapperlist = new  List<ETT_FleetInspectionWrapper>();
        fleetInspectionWrapperlist.add(fleetInspectionWrapper);
        mapList.put('stgFleetInspectionLineItemJson',JSON.serialize(fleetInspectionWrapperlist));
        
        //   ETT_LeadFormController.saveDML(mapList);
        ETT_FleetInspectionController.getselectOptions(AccList[0], 'Party_Type__c');
        ETT_FleetInspectionController.saveDMLForFleetInspection(mapList);
        ETT_FleetInspectionController.getPressure('rt56','ghh78');
        ETT_FleetInspectionController.getOriginalDepth('12.45','Ring','PSR');
        
        Test.stopTest();
    }
}