@isTest
public class ETT_LeadFormController_Test {
    
    @isTest static void testMethod1(){
                Map<String,String> mapList = new  Map<String,String>();

        List<Lead> leadList =  ETT_TestFactory.createLeads();
        insert leadList;
        ETT_LeadFormController.getPickListValuesIntoList();
        ETT_LeadFormController.getLeadRecordTypeID('ET Tyre');
        ETT_LeadFormController.getDynamicPickListValuesIntoList('Lead','ETSALES_Lead_Rating__c');
        ETT_LeadFormController.getCustomerProfile(leadList[0].Id);
        List<String> moreFields = new List<String>{'LastName'};
         ETT_LeadFormController.searchRecord('Lead','ETSALES_Lead_Rating__c',moreFields,'Hot',2);
        
         List<ETT_Brand_Master__c> brandMastersList = ETT_TestFactory.createBrandMasters();
        List<ETT_Pattern_Master__c> patternMastersList = ETT_TestFactory.createPatternMasters();
        List<ETT_Staging_Contacts__c> stagingContactsList = ETT_TestFactory.createStagingContacts(leadList[0].Id);
        stagingContactsList[0].ETT_Lead__c = null;
        List<ETT_Staging_Customer_Vehicle_Details__c> createStagingCustVehicles = ETT_TestFactory.createStagingCustVehicles(leadList[0].Id);
        createStagingCustVehicles[0].ETT_Lead__c = null;
        List<ETT_Tyre_Size_Master__c> tyreMasterSizeList =  ETT_TestFactory.createTyreSizeMaster();
        insert tyreMasterSizeList;
        List<ETT_Staging_Quotation_Request__c> stagingQuoteList = ETT_TestFactory.createStagingQuoteRequests(leadList[0].Id);
        stagingQuoteList[0].ETT_Tyre_Size_Master__c = tyreMasterSizeList[0].Id;
        stagingQuoteList[0].ETT_Lead__c = null;
        List<ETT_Staging_Purchase_Information__c> stagingPurchaseList = ETT_TestFactory.createStagingPurchaseInformations(tyreMasterSizeList[0].Id,leadList[0].Id);
        List<ETT_Staging_Added_Service__c> stagingAddedList = ETT_TestFactory.createStagingAddedServices(leadList[0].Id);
        stagingAddedList[0].ETT_Lead__c = null;
        List<ETT_Staging_Customer_LPO__c> stagingCustomerLPOList = ETT_TestFactory.createStagingCustomerLPO(leadList[0].Id);
        List<ETT_Staging_Trade_Reference__c> stagingTradeReferencesList = ETT_TestFactory.createStagingTradeReferences(leadList[0].Id);
        stagingTradeReferencesList[0].ETT_Lead__c = null;
        List<ETT_Staging_Bank_Reference__c> stagingBankReferencesList = ETT_TestFactory.createStagingBankReferences(leadList[0].Id);
        stagingBankReferencesList[0].ETT_Lead__c = null;
        insert stagingContactsList;
        insert createStagingCustVehicles;
        insert stagingQuoteList;
        insert stagingPurchaseList;
        insert stagingAddedList;
        insert stagingCustomerLPOList;
        insert stagingTradeReferencesList;
        insert stagingBankReferencesList;
        
        ETT_Staging_Quotation_Request__c onn = new ETT_Staging_Quotation_Request__c();
        onn.ETT_New_Brand__c='testa';
        onn.ETT_New_Country__c='testb';
        onn.ETT_New_Pattern__c='testc';
        onn.ETT_New_Tyre_Size__c='testr';
        insert onn;
                
        Test.startTest();
        mapList.put('stgLeadJson',JSON.serialize(leadList[0]));
        mapList.put('stgContactJson',JSON.serialize(stagingContactsList));
        mapList.put('stgVehicleJson',JSON.serialize(createStagingCustVehicles));
        mapList.put('stgQuoteJson',JSON.serialize(stagingQuoteList));
        mapList.put('stgPurchaseJson',JSON.serialize(stagingPurchaseList));
        mapList.put('stgAddedServiceJson',JSON.serialize(stagingAddedList));
        mapList.put('stgCustomerLPOJson',JSON.serialize(stagingCustomerLPOList));
        mapList.put('stgTradeReferenceJson',JSON.serialize(stagingTradeReferencesList));
        mapList.put('stgBankReferenceJson',JSON.serialize(stagingBankReferencesList));
        
        
        List<Sobject> lstSobjectInfo = new List<Sobject>{stagingQuoteList[0]};
        ETT_LeadFormController.saveDML(mapList);
        Test.stopTest();
        
    }
    
    
    @isTest static void testSaveDML(){
        
        Group grp = new Group(Name = 'Inspection Card');
        insert grp;
        
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        Map<String,String> mapList = new  Map<String,String>();
        List<Lead> leadList =  ETT_TestFactory.createLeads();
        leadList[0].RecordTypeId = leadRecordTypeId;
        leadList[0].MobilePhone = '+971 254563645';
   
        
        insert leadList;
        List<ETT_Brand_Master__c> brandMastersList = ETT_TestFactory.createBrandMasters();
        List<ETT_Pattern_Master__c> patternMastersList = ETT_TestFactory.createPatternMasters();
        List<ETT_Staging_Contacts__c> stagingContactsList = ETT_TestFactory.createStagingContacts(leadList[0].Id);
        stagingContactsList[0].ETT_Lead__c = null;
        List<ETT_Staging_Customer_Vehicle_Details__c> createStagingCustVehicles = ETT_TestFactory.createStagingCustVehicles(leadList[0].Id);
        createStagingCustVehicles[0].ETT_Lead__c = null;
        List<ETT_Tyre_Size_Master__c> tyreMasterSizeList =  ETT_TestFactory.createTyreSizeMaster();
        insert tyreMasterSizeList;
        List<ETT_Staging_Quotation_Request__c> stagingQuoteList = ETT_TestFactory.createStagingQuoteRequests(leadList[0].Id);
        stagingQuoteList[0].ETT_Tyre_Size_Master__c = tyreMasterSizeList[0].Id;
        stagingQuoteList[0].ETT_Lead__c = null;
                

       

        List<ETT_Staging_Purchase_Information__c> stagingPurchaseList = ETT_TestFactory.createStagingPurchaseInformations(tyreMasterSizeList[0].Id,leadList[0].Id);
        List<ETT_Staging_Added_Service__c> stagingAddedList = ETT_TestFactory.createStagingAddedServices(leadList[0].Id);
        stagingAddedList[0].ETT_Lead__c = null;
        List<ETT_Staging_Customer_LPO__c> stagingCustomerLPOList = ETT_TestFactory.createStagingCustomerLPO(leadList[0].Id);
        List<ETT_Staging_Trade_Reference__c> stagingTradeReferencesList = ETT_TestFactory.createStagingTradeReferences(leadList[0].Id);
        stagingTradeReferencesList[0].ETT_Lead__c = null;
        List<ETT_Staging_Bank_Reference__c> stagingBankReferencesList = ETT_TestFactory.createStagingBankReferences(leadList[0].Id);
        stagingBankReferencesList[0].ETT_Lead__c = null;
        
        insert patternMastersList;
        insert brandMastersList;
        insert stagingContactsList;
        insert createStagingCustVehicles;
        insert stagingQuoteList;
        insert stagingPurchaseList;
        insert stagingAddedList;
        insert stagingCustomerLPOList;
        insert stagingTradeReferencesList;
        insert stagingBankReferencesList;
        
        List<ETT_Staging_Fleet_Inspection__c> stagingFleetInspectionsList = ETT_TestFactory.createStagingFleetInspections( leadList[0].Id,brandMastersList[0].Id,patternMastersList[0].Id, tyreMasterSizeList[0].Id);
        System.debug('Test  ' + stagingFleetInspectionsList);
        insert stagingFleetInspectionsList;
        List<ETT_FleetInspectionWrapper> lll = new List<ETT_FleetInspectionWrapper>();
        ETT_FleetInspectionWrapper l = new ETT_FleetInspectionWrapper();
        l.fileSourceType = 'Email';
        l.lstFileLoadWrapper = new List<ETT_FileUploadWrapper>();
       // l.objFleetInspection = stagingFleetInspectionsList[0];
        lll.add(l);
        List<ETT_Staging_Scrap_Inspection__c> stagingScrapInspectionsList = ETT_TestFactory.createStagingScrapInspections( leadList[0].Id,brandMastersList[0].Id,tyreMasterSizeList[0].Id);
        stagingScrapInspectionsList[0].ETT_Lead__c = null;
        insert stagingScrapInspectionsList;
        List<ETT_Staging_Test_Tyre__c> stagingTestTyresList =  ETT_TestFactory.createStagingTestTyres( leadList[0].Id,brandMastersList[0].Id);
        stagingTestTyresList[0].ETT_Lead__c = null;
        insert stagingTestTyresList;
        
  List< ETT_Vehicle_Details__c> vehicleList= new List< ETT_Vehicle_Details__c>();
        ETT_Vehicle_Details__c an=new ETT_Vehicle_Details__c();
        an.Name='test';
       an.ETT_Internal_Number__c='3456';
        vehicleList.add(an);
        insert vehicleList;
     
        ETT_Fleet_Inspection__c FleetInspection = new ETT_Fleet_Inspection__c();  
        /*FleetInspection.ETT_Account__c = acc.Id;*/
        FleetInspection.Lead__c = leadList[0].Id;
        insert FleetInspection;
        
    Fleet_Inspection_Line_Item__c FleetlineItem = new Fleet_Inspection_Line_Item__c();
        FleetlineItem.Fleet_Inspection__c = FleetInspection.id;
	//	insert FleetlineItem;
        
        Test.startTest();
        mapList.put('stgLeadJson',JSON.serialize(leadList[0]));
        mapList.put('stgContactJson',JSON.serialize(stagingContactsList));
        mapList.put('stgVehicleJson',JSON.serialize(createStagingCustVehicles));
        mapList.put('stgQuoteJson',JSON.serialize(stagingQuoteList));
        mapList.put('stgPurchaseJson',JSON.serialize(stagingPurchaseList));
        mapList.put('stgAddedServiceJson',JSON.serialize(stagingAddedList));
        mapList.put('stgCustomerLPOJson',JSON.serialize(stagingCustomerLPOList));
        mapList.put('stgTradeReferenceJson',JSON.serialize(stagingTradeReferencesList));
        mapList.put('stgBankReferenceJson',JSON.serialize(stagingBankReferencesList));
        mapList.put('stgFleetInspectionJson',JSON.serialize(stagingFleetInspectionsList));
        mapList.put('stgScrabInspectionJson',JSON.serialize(stagingScrapInspectionsList));
        mapList.put('stgTestTyreJson',JSON.serialize(stagingTestTyresList));
        
      
   
    // base64 encode the blob that contains our url param value
   

        
        List<Sobject> lstSobjectInfo = new List<Sobject>{stagingQuoteList[0]};
       
       
        
         ETT_LeadFormController.saveDML(mapList);
        
    //   ETT_LeadFormController.saveDMLForFleetInspection(mapList);
  
        
        ETT_LeadFormController.getselectOptions(leadList[0],'ETSALES_Lead_Rating__c');
        ETT_LeadFormController.processCasesInformation(lstSobjectInfo, leadList[0].Id);
      
        ETT_LeadFormController.getVehicleNumber('test');
        Test.stopTest();
        
    }
    
      @isTest static void testsaveDMLForFleetInspection(){
        
        Group grp = new Group(Name = 'Inspection Card');
        insert grp;
        
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        Map<String,String> mapList = new  Map<String,String>();
        List<Lead> leadList =  ETT_TestFactory.createLeads();
        leadList[0].RecordTypeId = leadRecordTypeId;
        leadList[0].MobilePhone = '+971 254563645';
   
        
        insert leadList;
        List<ETT_Brand_Master__c> brandMastersList = ETT_TestFactory.createBrandMasters();
        List<ETT_Pattern_Master__c> patternMastersList = ETT_TestFactory.createPatternMasters();
        List<ETT_Staging_Contacts__c> stagingContactsList = ETT_TestFactory.createStagingContacts(leadList[0].Id);
        stagingContactsList[0].ETT_Lead__c = null;
        List<ETT_Staging_Customer_Vehicle_Details__c> createStagingCustVehicles = ETT_TestFactory.createStagingCustVehicles(leadList[0].Id);
        createStagingCustVehicles[0].ETT_Lead__c = null;
        List<ETT_Tyre_Size_Master__c> tyreMasterSizeList =  ETT_TestFactory.createTyreSizeMaster();
        insert tyreMasterSizeList;
        List<ETT_Staging_Quotation_Request__c> stagingQuoteList = ETT_TestFactory.createStagingQuoteRequests(leadList[0].Id);
        stagingQuoteList[0].ETT_Tyre_Size_Master__c = tyreMasterSizeList[0].Id;
        stagingQuoteList[0].ETT_Lead__c = null;
                

       

        List<ETT_Staging_Purchase_Information__c> stagingPurchaseList = ETT_TestFactory.createStagingPurchaseInformations(tyreMasterSizeList[0].Id,leadList[0].Id);
        List<ETT_Staging_Added_Service__c> stagingAddedList = ETT_TestFactory.createStagingAddedServices(leadList[0].Id);
        stagingAddedList[0].ETT_Lead__c = null;
        List<ETT_Staging_Customer_LPO__c> stagingCustomerLPOList = ETT_TestFactory.createStagingCustomerLPO(leadList[0].Id);
        List<ETT_Staging_Trade_Reference__c> stagingTradeReferencesList = ETT_TestFactory.createStagingTradeReferences(leadList[0].Id);
        stagingTradeReferencesList[0].ETT_Lead__c = null;
        List<ETT_Staging_Bank_Reference__c> stagingBankReferencesList = ETT_TestFactory.createStagingBankReferences(leadList[0].Id);
        stagingBankReferencesList[0].ETT_Lead__c = null;
        
        insert patternMastersList;
        insert brandMastersList;
        insert stagingContactsList;
        insert createStagingCustVehicles;
        insert stagingQuoteList;
        insert stagingPurchaseList;
        insert stagingAddedList;
        insert stagingCustomerLPOList;
        insert stagingTradeReferencesList;
        insert stagingBankReferencesList;
        
        List<ETT_Staging_Fleet_Inspection__c> stagingFleetInspectionsList = ETT_TestFactory.createStagingFleetInspections( leadList[0].Id,brandMastersList[0].Id,patternMastersList[0].Id, tyreMasterSizeList[0].Id);
        System.debug('Test  ' + stagingFleetInspectionsList);
        insert stagingFleetInspectionsList;
        List<ETT_FleetInspectionWrapper> lll = new List<ETT_FleetInspectionWrapper>();
        ETT_FleetInspectionWrapper l = new ETT_FleetInspectionWrapper();
        l.fileSourceType = 'Email';
        l.lstFileLoadWrapper = new List<ETT_FileUploadWrapper>();
       // l.objFleetInspection = stagingFleetInspectionsList[0];
        lll.add(l);
        List<ETT_Staging_Scrap_Inspection__c> stagingScrapInspectionsList = ETT_TestFactory.createStagingScrapInspections( leadList[0].Id,brandMastersList[0].Id,tyreMasterSizeList[0].Id);
        stagingScrapInspectionsList[0].ETT_Lead__c = null;
        insert stagingScrapInspectionsList;
        List<ETT_Staging_Test_Tyre__c> stagingTestTyresList =  ETT_TestFactory.createStagingTestTyres( leadList[0].Id,brandMastersList[0].Id);
        stagingTestTyresList[0].ETT_Lead__c = null;
        insert stagingTestTyresList;
        
  List< ETT_Vehicle_Details__c> vehicleList= new List< ETT_Vehicle_Details__c>();
        ETT_Vehicle_Details__c an=new ETT_Vehicle_Details__c();
        an.Name='test';
       an.ETT_Internal_Number__c='3456';
        vehicleList.add(an);
        insert vehicleList;
     
        ETT_Fleet_Inspection__c FleetInspection = new ETT_Fleet_Inspection__c();  
        /*FleetInspection.ETT_Account__c = acc.Id;*/
        FleetInspection.Lead__c = leadList[0].Id;
     //   insert FleetInspection;
        
    Fleet_Inspection_Line_Item__c FleetlineItem = new Fleet_Inspection_Line_Item__c();
       // FleetlineItem.Fleet_Inspection__c = FleetInspection.id;
	//	insert FleetlineItem;
        
        Test.startTest();
        mapList.put('stgLeadJson',JSON.serialize(leadList[0]));
        mapList.put('stgContactJson',JSON.serialize(stagingContactsList));
        mapList.put('stgVehicleJson',JSON.serialize(createStagingCustVehicles));
        mapList.put('stgQuoteJson',JSON.serialize(stagingQuoteList));
        mapList.put('stgPurchaseJson',JSON.serialize(stagingPurchaseList));
        mapList.put('stgAddedServiceJson',JSON.serialize(stagingAddedList));
        mapList.put('stgCustomerLPOJson',JSON.serialize(stagingCustomerLPOList));
        mapList.put('stgTradeReferenceJson',JSON.serialize(stagingTradeReferencesList));
        mapList.put('stgBankReferenceJson',JSON.serialize(stagingBankReferencesList));
        mapList.put('stgFleetInspectionJson',JSON.serialize(FleetInspection));
        mapList.put('stgScrabInspectionJson',JSON.serialize(stagingScrapInspectionsList));
        mapList.put('stgTestTyreJson',JSON.serialize(stagingTestTyresList));
        
      
   
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
        
       ETT_LeadFormController.saveDMLForFleetInspection(mapList);
                    ETT_LeadFormController.getLeadInfo(leadList[0].Id);
     
        Test.stopTest();
        
    }
}