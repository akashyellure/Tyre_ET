@isTest
public class ETT_CollectionLineItemControllerTest {
    
    @testSetup
    public static void setupData(){
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Lead leadobj = new Lead(
            LastName = 'Aadil',
            Company = 'supcshtst thirtytwo',
            Street = 'Dubai',
            Phone = '45656364',
            MobilePhone = '523543454',
            //Status = 'Rejected',
            CurrencyIsoCode = 'AED',
            HasOptedOutOfEmail = false,
            IsUnreadByOwner = false,
            DoNotCall = false,
            HasOptedOutOfFax = false,
            pi__Needs_Score_Synced__c = false,
            pi__pardot_hard_bounced__c = false,
            et4ae5__HasOptedOutOfMobile__c = false,
            et4ae5__Mobile_Country_Code__c = 'US',
            Duplicate_Lead__c = false,
            ETSALES_Country_Code_Company__c = 'UAE(+971)',
            ETSALES_ISD_Country_Code_Contact__c = 'UAE(+971)',
            ETSALES_Lead_Created__c = true,
            ETT_Fleet_Inspection_Required__c = false,
            ETT_Government__c = false,
            ETT_LLC__c = false,
            ETT_Lead_Approval_Stage__c = 'New',
            ETT_Party_Type__c = 'Supplier',
            ETT_Payment_Type__c = 'Cash',
            ETT_Scrap_Inspection_Required__c = false,
            ETT_Test_Tyre_Required__c = false,
            ETT_Trade_License_Number__c = '567876546789767',
            ETT_Trade_Licenses_Expiry_Date__c = Date.newInstance(2020,12,28),
            ETT_VAT_TRN__c = '657656343743322',
            ETT_isSupplierConvert__c = false,
            ETT_Final_Rejection__c = false);
        insert leadobj;
        
        ETT_Collection_Card__c ett_collection_card = new ETT_Collection_Card__c(
            CurrencyIsoCode = 'AED',
            ETT_Accounts__c = acc.id,
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
            ETT_Inspection_Done__c = false,
            ETT_Job_Card_Done__c = false,
            ETT_Location__c = 'Dubai',
            ETT_Receptionist_Acceptance__c = false,
            ETT_Sales_Acceptance__c = false,
            ETT_Status__c = 'Collection Stage',
            ETT_Submitted_For_Approval__c = false,
            ETT_Is_Active__c = false);
        
        insert ett_collection_card;
        ETT_Staging_Quotation_Request__c ett_staging_quotation_request = new ETT_Staging_Quotation_Request__c(
            CurrencyIsoCode = 'AED',
            ETT_Accept_Quotation__c = false,
            ETT_Approve_Stage__c = 'Rejected',
            ETT_IS_Approved__c = false,
            ETT_Max_Range__c = 175.0,
            ETT_Min_Range__c = 140.0,
            ETT_Purchase_Price__c = 0.0,
            ETT_Quantity__c = 1.0,
            ETT_Tyre_Life__c = 'New',
            
            ETT_HOO_Price_Acceptance__c = false,
            ETT_FM_Price_Acceptance__c = false);
        //ETT_Collection_Card__c=  ett_collection_card.id,
        insert ett_staging_quotation_request;  
        
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            
            ETT_Party_Name__c = acc.id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        ETT_Tyre_Size_Master__c ett_tyre_size_master = new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
           
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
           
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
           
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
           
            ETT_Actual_Width__c = 210.0,
            ETT_Bead_Adjustment__c = 2.0,
            ETT_Brand_Code__c = 'ALT',
            ETT_Brand_Name__c = ett_brand_master.id,
            ETT_Country_Code__c = 'IND',
            ETT_Country_Name__c = ett_country_master.id,
            ETT_Country_Status__c = false,
            ETT_Item_Code_Refurbished__c = 'TR-10.00-20-ALT',
            ETT_Item_Code_Scrap__c = 'TS-10.00-20-ALT',
            ETT_Item_Code_Used__c = 'TU-10.00-20-ALT',
            ETT_Length__c = 3.2,
            ETT_Load_Index__c = '146/142',
            ETT_Original_Pattern__c = ett_pattern_master.id,
            ETT_Ply_Rate__c = '16',
            ETT_Rim_Size__c = 20.0,
            ETT_Speed_Index__c = 'J',
            ETT_Status__c = false,
            ETT_Tyre_Radiues__c = '24',
            ETT_Tyre_Size__c = ett_tyre_size_master.id,
            ETT_Tyre_Status__c = false,
            ETT_Vehicle_Type__c = 'Bus');
        insert ett_tyre_master;
        
        ETT_Pricing_Information__c ett_pricing_information = new ETT_Pricing_Information__c(
            CurrencyIsoCode = 'AED',
            ETT_Tyre_Size__c = ett_tyre_size_master.id,
            ETT_Brand__c = ett_brand_master.id,
            ETT_Pattern__c = ett_pattern_master.id,
            ETT_Country_of_Origin__c = ett_country_master.id,
            ETT_Approval_Status__c = 'In Progress',
            ETT_Purchase_Price__c = 500.0,
            ETT_Price__c= ett_price_master.id);
        
        insert ett_pricing_information;
        
        Case c = new Case();
        insert c;
        WorkOrder wrkOrdr = new WorkOrder(Case = c);
        insert wrkOrdr;
        WorkOrderLineItem wrkOrdrLineItm= new WorkOrderLineItem(WorkOrderId  = wrkOrdr.Id,
                                                                ETT_Tyre_Size__c = ett_tyre_size_master.id,
                                                                ETT_Brand__c = ett_brand_master.id,
                                                                ETT_Pattern__c = ett_pattern_master.id,
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId(),
                                                                ETT_Collection_Card__c = ett_collection_card.Id);
        
        insert wrkOrdrLineItm;  
    }
    @isTest
    public static void testForfetchUser(){
        Test.startTest();
        User u = ETT_CollectionLineItemController.fetchUser();
        Test.stopTest();
        System.assert(u != null);
    }
    @isTest
    public static void testForrequestStagingQuotation(){
        ETT_Pricing_Information__c ett_pricing_info = [SELECT id FROM ETT_Pricing_Information__c LIMIT 1];
        ETT_Tyre_Size_Master__c ett_tyre_size_master = [SELECT id FROM ETT_Tyre_Size_Master__c LIMIT 1];
        ETT_Brand_Master__c ett_brand_master = [SELECT id FROM ETT_Brand_Master__c LIMIT 1];
        ETT_Pattern_Master__c ett_pattern_master = [SELECT id FROM ETT_Pattern_Master__c LIMIT 1];
        ETT_Collection_Card__c ett_collection_card = [SELECt id FROM ETT_Collection_Card__c LIMIT 1];
        Case c = new Case();
        insert c;
        WorkOrder wrkOrdr = new WorkOrder(Case = c);
        insert wrkOrdr;
        WorkOrderLineItem wrkOrdrLineItm= new WorkOrderLineItem(WorkOrder  = wrkOrdr,
                                                                ETT_Tyre_Size__c = ett_tyre_size_master.id,
                                                                ETT_Brand__c = ett_brand_master.id,
                                                                ETT_Pattern__c = ett_pattern_master.id);
        //insert wrkOrdrLineItm;
        // ETT_Collection_Card__c ett_collection_card = [SELECt id FROM ETT_Collection_Card__c LINIT 1];
        
        Test.startTest();
        Boolean result = ETT_CollectionLineItemController.requestStagingQuotation(ett_collection_card.id ,  new List<WorkOrderLineItem>{wrkOrdrLineItm});
        
        ETT_CollectionLineItemController.strSalesTeamAccpectance(new List<WorkOrderLineItem>{wrkOrdrLineItm}, ett_collection_card);
        ETT_CollectionLineItemController.strRecetionistAccpectance(new List<WorkOrderLineItem>{wrkOrdrLineItm}, ett_collection_card);

        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = ett_collection_card.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        ETT_CollectionLineItemController.getContentId(ett_collection_card.id);
        Test.stopTest();
        System.assert(result);
    }
    
    @isTest
    public static void testForcreateStagingQuotation(){
        
        ETT_Staging_Quotation_Request__c ett_staging_quotation_request = new ETT_Staging_Quotation_Request__c(
            CurrencyIsoCode = 'AED',
            ETT_Accept_Quotation__c = false,
            ETT_Approve_Stage__c = 'Qualified',
            ETT_IS_Approved__c = false,
            ETT_Max_Range__c = 175.0,
            ETT_Min_Range__c = 140.0,
            ETT_Purchase_Price__c = 0.0,
            ETT_Quantity__c = 1.0,
            ETT_Tyre_Life__c = 'New',
            
            ETT_HOO_Price_Acceptance__c = false,
            ETT_FM_Price_Acceptance__c = false);
        //ETT_Collection_Card__c=  ett_collection_card.id,
        insert ett_staging_quotation_request;  
        
        Account acc = new Account();
        acc.Name = 'TestCollectionAcc';
        insert acc;
        ETT_Collection_Card__c ett_collection_card = new ETT_Collection_Card__c(
            CurrencyIsoCode = 'AED',
            ETT_Accounts__c = acc.id,
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
            ETT_Inspection_Done__c = false,
            ETT_Job_Card_Done__c = false,
            ETT_Location__c = 'Dubai',
            ETT_Receptionist_Acceptance__c = false,
            ETT_Sales_Acceptance__c = false,
            ETT_Status__c = 'Collection Stage',
            ETT_Submitted_For_Approval__c = false,
            ETT_Is_Active__c = false);
        
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc.id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        Test.startTest();
        Boolean result = ETT_CollectionLineItemController.createStagingQuotation(ett_collection_card.id ,  new List<ETT_Staging_Quotation_Request__c>{ett_staging_quotation_request});
        Test.stopTest();
        System.assert(result); 
    }
    
    @isTest
    public static void testForgetMissingPurchaseInformationWOLI(){
        ETT_Collection_Card__c ett_collection_card = [SELECt id FROM ETT_Collection_Card__c LIMIT 1];
        Test.startTest();
        List<ETT_Staging_Quotation_Request__c> result = ETT_CollectionLineItemController.getMissingPurchaseInformationWOLI(ett_collection_card.id);
        Test.stopTest();
    }
    @isTest
    public static void testForupdateRejectedTyreCheckIn(){
        ETT_Collection_Card__c ett_collection_card = [SELECt id FROM ETT_Collection_Card__c LIMIT 1];
        Test.startTest();
        boolean result = ETT_CollectionLineItemController.updateRejectedTyreCheckIn(ett_collection_card.id);
        Test.stopTest();
        System.assert(result);
    }
    @isTest
    public static void testForcheckoutRejectedTyres(){
        Account acc = [SELECT id FROM Account LIMIT 1];
        ETT_Pricing_Information__c ett_tyre_size_master = [SELECT id FROM ETT_Pricing_Information__c LIMIT 1];
        ETT_Brand_Master__c ett_brand_master = [SELECT id FROM ETT_Brand_Master__c LIMIT 1];
        ETT_Pattern_Master__c ett_pattern_master = [SELECT id FROM ETT_Pattern_Master__c LIMIT 1];
        
        ETT_Country_Master__c ett_country_master = [SELECT id FROM ETT_Country_Master__c LIMIT 1];
        ETT_Tyre_Rejection_Report__c ett_tyre_rejection_report = new ETT_Tyre_Rejection_Report__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = acc.id,
            ETT_Brand__c = ett_brand_master.id,
            ETT_Country__c = ett_country_master.id,
            ETT_Pattern__c = ett_pattern_master.id,
            ETT_Collection_Card__c = 'CC-100297',
            ETT_Check_In__c = DateTime.newInstance(2020,12,4,8,480,28800),
            
            ETT_Rejection_Reason__c = 'Testing',
            ETT_Quantity__c = 2.0);
        insert ett_tyre_rejection_report;
        
        //ETT_Tyre_Size__c = ett_tyre_size_master.id,
        ETT_Collection_Card__c ett_collection_card = [SELECt id FROM ETT_Collection_Card__c LIMIT 1];
        Test.startTest();
       // boolean result = ETT_CollectionLineItemController.checkoutRejectedTyres(ett_collection_card.id);
        Test.stopTest();
        //System.assert(result);
    }
    @isTest
    public static void testForupdateCheckIn(){
        ETT_Collection_Card__c ett_collection_card = [SELECt id FROM ETT_Collection_Card__c LIMIT 1];
        Test.startTest();
        boolean result = ETT_CollectionLineItemController.updateCheckIn(ett_collection_card.id);
        Test.stopTest();
        System.assert(result);
    }
    @isTest
    public static void testForgetRejectedTyres(){
        Account acc = [SELECT id FROM Account LIMIT 1];
        ETT_Pricing_Information__c ett_tyre_size_master = [SELECT id FROM ETT_Pricing_Information__c LIMIT 1];
        ETT_Brand_Master__c ett_brand_master = [SELECT id FROM ETT_Brand_Master__c LIMIT 1];
        ETT_Pattern_Master__c ett_pattern_master = [SELECT id FROM ETT_Pattern_Master__c LIMIT 1];
        
        ETT_Country_Master__c ett_country_master = [SELECT id FROM ETT_Country_Master__c LIMIT 1];
        ETT_Collection_Card__c collectInstance = [SELECT Name FROM ETT_Collection_Card__c LIMIT 1];
        ETT_Tyre_Rejection_Report__c ett_tyre_rejection_report = new ETT_Tyre_Rejection_Report__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = acc.id,
            ETT_Brand__c = ett_brand_master.id,
            ETT_Country__c = ett_country_master.id,
            ETT_Pattern__c = ett_pattern_master.id,
            ETT_Collection_Card__c = collectInstance.Name,
            ETT_Check_In__c = DateTime.newInstance(2020,12,4,8,480,28800),
            
            ETT_Rejection_Reason__c = 'Testing',
            ETT_Quantity__c = 2.0);
        insert ett_tyre_rejection_report;
        Map<String, String> mapObj = new Map<String, String>();
        mapObj.put('stgTyreRejectionJson', JSON.serialize(new List<ETT_Tyre_Rejection_Report__c>{ett_tyre_rejection_report}));
        list<ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems> jsontr = new list<ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems>();
        ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems  wrp = new ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems();
        wrp.quantity = '3';
        ETT_TyreInspectionCardWrapper.FileWrapper filwrp = new ETT_TyreInspectionCardWrapper.FileWrapper();
        filwrp.fileContent = 'Test';
        filwrp.fileSourceType = 1;
        filwrp.strFileName = 'Test';
        filwrp.strFileType = 'txt';
        filwrp.strRejectionName = ett_tyre_rejection_report.Name;
        filwrp.parentId = ett_tyre_rejection_report.Id;
        wrp.lstFileWrapperDetails = new List<ETT_TyreInspectionCardWrapper.FileWrapper>{filwrp};
            wrp.CCName = collectInstance.Name;
        jsontr.add(wrp);
        Map<String, String> mapObj1 = new Map<String, String>();
        mapObj1.put('stgTyreRejectionJson', JSON.serialize(jsontr));
        
        WorkOrder wo = new WorkOrder();
        wo.subject ='title';
        insert wo;
        WorkOrderLineItem woli = new WorkOrderLineItem();
        woli.workOrderId = wo.Id;
        woli.description = 'abcd';
        woli.ETT_Collection_Card__c = collectInstance.Id;
        insert woli;
        Test.startTest();
        list<ETT_Tyre_Rejection_Report__c> result = ETT_CollectionLineItemController.getRejectedTyres(String.valueOf(collectInstance.id));
        list<ETT_Tyre_Rejection_Report__c> result1 = ETT_CollectionLineItemController.showRejectedTyreDetails(collectInstance.id);
        ETT_CollectionLineItemController.updateRejectedTyres(mapObj);
        ETT_CollectionLineItemController.saveRejectedTyres(mapObj1);
        ETT_CollectionLineItemController.lstCollectionCardLineItems(collectInstance.id);
        
        ETT_CollectionLineItemController.priceInfoData(acc.id, [SELECT id FROM ETT_Tyre_Size_Master__c LIMIT 1][0].id,ett_pattern_master.id, ett_brand_master.id, ett_country_master.id, 'Customer'/*, 'Retread', 'Procure'*/);
        Test.stopTest();
        System.assert(result != null);
    }
    @isTest
    public static void testForshowRejectedTyreDetails(){
        ETT_Collection_Card__c ett_collection_card = [SELECt id FROM ETT_Collection_Card__c LIMIT 1];
        Test.startTest();
        boolean result = ETT_CollectionLineItemController.updateRejectedTyreCheckIn(ett_collection_card.id);
        Test.stopTest();
        System.assert(result);
    }
    @isTest
    public static void testCasegetNewTyreDetails(){
        
        ETT_Tyre_Master__c etMaster = [SELECT id, recordtypeid FROM ETT_Tyre_Master__c LIMIT 1];
        
        ETT_Collection_Card__c collectInstance = [SELECT Name, ETT_Sales_Acceptance__c FROM ETT_Collection_Card__c LIMIT 1];
        Id devRecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Draft').getRecordTypeId();
        etMaster.recordtypeid = devRecordTypeId;
        etMaster.ETT_Collection_Card__c = collectInstance.Id;
        //update etMaster;
        Test.startTest();
        ETT_CollectionLineItemController.getNewTyreDetails(collectInstance.id);
        
        Test.stopTest();
    }
    
    @isTest
    static void testForaddNewTyreMasterDetails(){
        Lead ld = [SELECT id FROM Lead LIMIt 1];
        Account acc = [SELECT id FROM Account LIMIT 1];
        ETT_Tyre_Size_Master__c ett_tyre_size_master = [SELECT id, Name FROM ETT_Tyre_Size_Master__c LIMIT 1];
        
        
        ///ETT_Pricing_Information__c ett_tyre_size_master = [SELECT id FROM ETT_Pricing_Information__c LIMIT 1];
        ETT_Brand_Master__c ett_brand_master = [SELECT id, Name  FROM ETT_Brand_Master__c LIMIT 1];
        ETT_Pattern_Master__c ett_pattern_master = [SELECT id, Name  FROM ETT_Pattern_Master__c LIMIT 1];
        
        ETT_Country_Master__c ett_country_master = [SELECT id, Name  FROM ETT_Country_Master__c LIMIT 1];
        ETT_Collection_Card__c collectInstance = [SELECT Name, ETT_Sales_Acceptance__c FROM ETT_Collection_Card__c LIMIT 1];
        Case c = new Case();
        insert c;
        WorkOrder wrkOrdr = new WorkOrder(Case = c);
        insert wrkOrdr;
        WorkOrderLineItem wrkOrdrLineItm= new WorkOrderLineItem(workOrderId   = wrkOrdr.ID,
                                                                
                                                                ETT_Brand__c = ett_brand_master.id,
                                                                ETT_Pattern__c = ett_pattern_master.id);
        wrkOrdrLineItm.ETT_Tyre_Size_NewText__c = ett_tyre_size_master.Name;
        wrkOrdrLineItm.ETT_Country_NewText__c = ett_country_master.Name;
        wrkOrdrLineItm.ETT_Pattern_NewText__c = ett_pattern_master.Name;
        wrkOrdrLineItm.ETT_Brand_NewText__c = ett_brand_master.Name;
        List<WorkOrderLineItem> lineitemList = [SELECT ETT_Country_NewText__c, ETT_Pattern_NewText__c, ETT_Brand_NewText__c, ETT_Tyre_Size_NewText__c ,
                                                ETT_Country_of_Origin__c, ETT_Pattern__c, ETT_Brand__c, ETT_Tyre_Size__c FROM WorkOrderLineItem];
        lineitemList = new List<WorkOrderLineItem>{wrkOrdrLineItm};
            WorkOrderLineItem wrkOrdrLineItm1= new WorkOrderLineItem(workOrderId   = wrkOrdr.ID,
                                                                     ETT_Tyre_Size__c = ett_tyre_size_master.id,
                                                                     ETT_Brand__c = ett_brand_master.id,
                                                                     ETT_Pattern__c = ett_pattern_master.id);
        
        ETT_Scrap_Tyre_Analysis__c scrap = new ETT_Scrap_Tyre_Analysis__c(NAme= 'Test');
        scrap.ETT_Tyre_Size__c = ett_tyre_size_master.id;
        scrap.ETT_Brand__c = ett_brand_master.id;
        scrap.ETT_Pattern__c = ett_pattern_master.id;
        scrap.ETT_Country_of_Origin__c = ett_country_master.id;
        scrap.ETT_Collection_Card__c = collectInstance.id;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        
        ETT_SrabTyreWrapper srapWrap = new ETT_SrabTyreWrapper();
        srapWrap.lstDocuments =cdList;
        srapWrap.strKey  = ett_brand_master.Name+'#'+ett_country_master.Name+
            '#'+ett_pattern_master.Name+'#'+ett_tyre_size_master.Name;
        MAp<String, String> srapMap = new Map<String, String>();
        srapMap.put('lstSrabTyreDetails', JSON.serialize(new List<ETT_Scrap_Tyre_Analysis__c>{scrap}));
        srapMap.put('lstScrabTyreWrapper', JSON.serialize(new List<ETT_SrabTyreWrapper>{srapWrap}));
        srapMap.put('filesToUpload', JSON.serialize(collectInstance));
        
        Map<String, String> mapForapproveNewTyres = new Map<String, String>();
        ETT_Tyre_Master__c etMaster = [SELECT id, recordtypeid FROM ETT_Tyre_Master__c LIMIT 1];
        mapForapproveNewTyres.put('lstTyreMasterJson', JSON.serialize(new List<ETT_Tyre_Master__c>{etMaster}));
        Test.startTest();
        ETT_CollectionLineItemController.addNewTyreMasterDetails(lineitemList, ld.id, 'Lead');  
        try{
            ETT_CollectionLineItemController.collectionLineItemsProcess(lineitemList, collectInstance.id, new List<WorkOrderLineItem>{wrkOrdrLineItm1});
            ETT_CollectionLineItemController.strSalesTeamAccpectance(lineitemList, collectInstance);
        }catch(exception e){
            
        }
        ETT_CollectionLineItemController.getselectOptions('Status');
        ETT_CollectionLineItemController.strApprovalProcessHandle();
        ETT_CollectionLineItemController.strFMAccpectance(collectInstance);
        ETT_CollectionLineItemController.strHOOAccpectance(collectInstance);
        ETT_CollectionLineItemController.scrabTyreAttachmentHandle(srapMap);
        ETT_CollectionLineItemController.approveNewTyres(mapForapproveNewTyres);
        ETT_CollectionLineItemController.updateCheckOut(collectInstance.id);
        ETT_CollectionLineItemController.deleteWorkOrderLineItem(new List<String>{collectInstance.id});
        Test.stopTest();
    }
}