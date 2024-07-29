/*
Created By   : Sree Chandu
Created Date : 29/12/2020
Description  : This is a test data factory for ET_Tyre project
*/
@isTest
public class ETT_TestFactory {
    
    public static List<Lead> createLeads(){
        List<Lead> leadList = new List<Lead>();
        for(integer i =0; i<=5;i++){
            Lead ld = new Lead();
            ld.LastName = 'LastName';
            ld.Company = 'testCompany';
            ld.Phone = '+971 560446342';
            ld.MobilePhone = '+971 562273032';
            ld.Email = 'testEmail@123.com';
            ld.Street = 'Street';
            ld.ETSALES_Budget__c = 10000;
            ld.ETSALES_Lead_Rating__c = 'Hot';
            ld.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
            
            leadList.add(ld);
        }
        return leadList;
    }
    
    public Static List<Account> createAccounts(String accountName, String recTypeName){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        List<Account> accountsList = new List<Account>();
        for(integer i =0; i<=5;i++){
            Account acc = new Account();
            acc.RecordTypeId = accRecordTypeId;
            acc.Name = accountName+i;
            acc.AccountNumber = '12345'+i;
            acc.Phone = '+971 8547584'+i;
            acc.ETT_Name_of_Company__c = 'TestCompany'+i;
            //acc.ETT_Payment_Terms__c = 'Cash';
            //acc.ETT_Trade_License_Number__c = '12345'+i;
            acc.ETSALES_Trade_License_Number__c = '12345'+i;
            //acc.ETT_Trade_Licenses_Expiry_Date__c = system.today().addmonths(12);
            acc.ETSALES_Trade_License_Expiry_Date__c = system.today().addmonths(12);
            acc.ETT_VAT_TRN_No__c = '123456789123456'+i;
            acc.ETT_Chamber_of_Commerce_Certification_No__c = '12345'+i;
            //acc.ETT_Organization_Address__c = 'OrgAddress';
            //acc.ETT_Organization_Name__c = 'TestOrgName'+i;
            //acc.ETT_Organization_Phone__c = '123456789';
            accountsList.add(acc);
        }
        return accountsList; //Tyre Customer
    }
    
    public static Opportunity createOpportunity(String recTypeName, String name, String oppStage, Date oppCloseDate, String accId){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        Opportunity opp = new Opportunity(RecordTypeId = oppRecordTypeId,
                                          Name=name,
                                          StageName = oppStage,
                                          CloseDate = oppCloseDate,
                                          AccountId = accId
                                         );
        return opp;
    }
    
    public static List<ETT_Staging_Contacts__c> createStagingContacts(String leadId){
        List<ETT_Staging_Contacts__c> stagingContactsList = new List<ETT_Staging_Contacts__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Contacts__c sc = new ETT_Staging_Contacts__c();
            sc.ETT_First_Name__c = 'Fname';
            sc.Name = 'Lname';
            sc.ETT_Phone__c = '9987654321';
            sc.ETT_Lead__c = leadId;
            sc.ETT_Email__c = 'testmail@gmail.com';
            stagingContactsList.add(sc);
        }
        return stagingContactsList;
    }
    
    public static List<ETT_Staging_Customer_Vehicle_Details__c> createStagingCustVehicles(String leadId){
        List<ETT_Staging_Customer_Vehicle_Details__c> stagingCustVehList = new List<ETT_Staging_Customer_Vehicle_Details__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Customer_Vehicle_Details__c scv = new ETT_Staging_Customer_Vehicle_Details__c();
            scv.ETT_Vehicle_In_Fleet__c = 123;
            scv.ETT_Lead__c = leadId;
            scv.ETT_Tyres_In_Fleet__c =10.0;
            stagingCustVehList.add(scv);
        }
        return stagingCustVehList;
    }
    
    public static List<ETT_Tyre_Size_Master__c> createTyreSizeMaster(){
        List<ETT_Tyre_Size_Master__c> tyreSizeMasterList = new List<ETT_Tyre_Size_Master__c>();
        for(integer i =0; i<=5;i++){
            ETT_Tyre_Size_Master__c tsm = new ETT_Tyre_Size_Master__c();
            tsm.Name = 'TestName'+i;
            tsm.ETT_Tyre_Size__c = '06-50-10';
            tsm.ETT_Description__c = '06.50-10 SMALL TYRE';
            tsm.ETT_Status__c = true;
            tyreSizeMasterList.add(tsm);
        }
        return tyreSizeMasterList;
    }
    
    public static List<ETT_Staging_Purchase_Information__c> createStagingPurchaseInformations(String sizeMasterId,String leadId){
        List<ETT_Staging_Purchase_Information__c> stagingPurchaseList = new List<ETT_Staging_Purchase_Information__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Purchase_Information__c spi = new ETT_Staging_Purchase_Information__c();
            spi.ETT_Tyre_Size_Master__c = sizeMasterId;
            spi.ETT_Lead__c = leadId;
            stagingPurchaseList.add(spi);
        }
        return stagingPurchaseList;
    }
    
    public static List<ETT_Staging_Quotation_Request__c> createStagingQuoteRequests(String leadId){
        List<ETT_Staging_Quotation_Request__c> stagingQuoteList = new List<ETT_Staging_Quotation_Request__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Quotation_Request__c sqr = new ETT_Staging_Quotation_Request__c();
            sqr.ETT_Lead__c = leadId;
            stagingQuoteList.add(sqr);
        }
        return stagingQuoteList;
    }
    
    public static List<ETT_Staging_Added_Service__c> createStagingAddedServices(String leadId){
        List<ETT_Staging_Added_Service__c> stagingAddedList = new List<ETT_Staging_Added_Service__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Added_Service__c sar = new ETT_Staging_Added_Service__c();
            sar.ETT_Lead__c = leadId;
            sar.ETT_Services__c = 'Maintenance';
            sar.ETT_Own__c = true;
            stagingAddedList.add(sar);
        }
        return stagingAddedList;
    }
    
    public static List<ETT_Staging_Customer_LPO__c> createStagingCustomerLPO(String leadId){
        List<ETT_Staging_Customer_LPO__c> stagingCustomerLPOList = new List<ETT_Staging_Customer_LPO__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Customer_LPO__c scl = new ETT_Staging_Customer_LPO__c();
            scl.ETT_Lead__c = leadId;
            stagingCustomerLPOList.add(scl);
        }
        return stagingCustomerLPOList;
    }
    
    public static List<ETT_Staging_Trade_Reference__c> createStagingTradeReferences(String leadId){
        List<ETT_Staging_Trade_Reference__c> stagingTradeReferencesList = new List<ETT_Staging_Trade_Reference__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Trade_Reference__c str = new ETT_Staging_Trade_Reference__c();
            str.ETT_Lead__c = leadId;
            str.ETT_Supplier_Name_Details__c = 'TestName';
            str.ETT_Payment_Terms__c = '30 days';
            str.ETT_Credit_Limit__c = 10.0;
            stagingTradeReferencesList.add(str);
        }
        return stagingTradeReferencesList;
    }
    
    public static List<ETT_Staging_Bank_Reference__c> createStagingBankReferences(String leadId){
        List<ETT_Staging_Bank_Reference__c> stagingBankReferencesList = new List<ETT_Staging_Bank_Reference__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Bank_Reference__c sbr = new ETT_Staging_Bank_Reference__c();
            sbr.ETT_Lead__c = leadId;
            sbr.ETT_Bank_Name__c = 'TestBank'+i;
            sbr.ETT_Address__c = 'Test';
            stagingBankReferencesList.add(sbr);
        }
        return stagingBankReferencesList;
    }
    
    public static List<ETT_Brand_Master__c> createBrandMasters(){
        List<ETT_Brand_Master__c> brandMastersList = new List<ETT_Brand_Master__c>();
        for(integer i =0; i<=5;i++){
            ETT_Brand_Master__c bm = new ETT_Brand_Master__c();
            bm.Name = 'TestBrand'+i;
            bm.ETT_Status__c = true;
            brandMastersList.add(bm);
        }
        return brandMastersList;
    }   
    
    public static List<ETT_Pattern_Master__c> createPatternMasters(){
        List<ETT_Pattern_Master__c> patternMastersList = new List<ETT_Pattern_Master__c>();
        for(integer i =0; i<=5;i++){
            ETT_Pattern_Master__c pm = new ETT_Pattern_Master__c();
            pm.Name = 'TestBrand'+i;
            pm.ETT_Pattern_Code__c = '1234'+i;
            patternMastersList.add(pm);
        }
        return patternMastersList;
    } 
    
    public static List<ETT_Staging_Fleet_Inspection__c> createStagingFleetInspections(String leadId,String brandMasterId,String patternMasterId, String tyreSizeMasterId){
        List<ETT_Staging_Fleet_Inspection__c> stagingFleetInspectionsList = new List<ETT_Staging_Fleet_Inspection__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Fleet_Inspection__c sfi = new ETT_Staging_Fleet_Inspection__c();
            sfi.ETT_Lead__c = leadId;
            sfi.Name = 'TestFleet'+i;
            sfi.ETT_Location__c = 'TestLoc';
            sfi.ETT_Vehicle_Number__c = '1234';
            sfi.ETT_Vehicle_Configuration__c = 'Config';
            sfi.ETT_Date__c = system.today();
            sfi.ETT_Pattern_Master__c = patternMasterId;
            sfi.ETT_Brand__c = brandMasterId;
            sfi.ETT_PR__c = 'TestPR'+i;
            sfi.ETT_LI__c =10.0;
            sfi.ETT_Tyre_Size__c = tyreSizeMasterId;
            stagingFleetInspectionsList.add(sfi);
        }
        return stagingFleetInspectionsList;
    }
    
    public static List<ETT_Staging_Scrap_Inspection__c> createStagingScrapInspections(String leadId,String brandMasterId,String tyreSizeMasterId){
        List<ETT_Staging_Scrap_Inspection__c> stagingScrapInspectionsList = new List<ETT_Staging_Scrap_Inspection__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Scrap_Inspection__c si = new ETT_Staging_Scrap_Inspection__c();
            si.ETT_Tyre_Serial_Number__c ='1234';
            si.ETT_Lead__c = leadId;
            si.ETT_Casing_Brand_lookup__c = brandMasterId;
            si.ETT_Tyre_Size__c = tyreSizeMasterId;
            stagingScrapInspectionsList.add(si);
        }
        return stagingScrapInspectionsList;
    } 
    
    public static List<ETT_Staging_Test_Tyre__c> createStagingTestTyres(String leadId,String brandMasterId){
        List<ETT_Staging_Test_Tyre__c> stagingTestTyresList = new List<ETT_Staging_Test_Tyre__c>();
        for(integer i =0; i<=5;i++){
            ETT_Staging_Test_Tyre__c stt = new ETT_Staging_Test_Tyre__c();
            stt.Name = 'TestCust'+i;
            stt.ETT_Vehicle_Number__c ='1234';
            stt.ETT_Location__c = '12345';
            stt.ETT_Date__c = system.today();
            stt.ETT_Brand__c = brandMasterId;
            stt.ETT_Lead__c = leadId;
            stt.ETT_Inspection_Date__c = system.today()+5;
            stt.ETT_Inspector_Name__c = 'InspectorName'+i;
            stt.ETT_Tyre_Serial_Number__c = '1234';
            stagingTestTyresList.add(stt);
        }
        return stagingTestTyresList;
    } 
    
    public static List<ETT_Collection_Card__c> createCollectionCards(String accId, String oppId){
        List<ETT_Collection_Card__c> collectionCardsList = new List<ETT_Collection_Card__c>();
        for(integer i =0; i<=5;i++){
            ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
            cc.ETT_Accounts__c =accId;
            cc.ETT_Opportunity__c = oppId;
            collectionCardsList.add(cc);
        }
        return collectionCardsList;
    }
    
    
    public static List<ETT_Inspection_Card__c> createInspectionCards(String recTypeName,String accId,String brandMasterId, String collectionCradId,String tyreSizeMasterId){
        Id inspectionRecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        List<ETT_Inspection_Card__c> inspectionsCardsList = new List<ETT_Inspection_Card__c>();
        for(integer i =0; i<=5;i++){
            ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
            ic.RecordTypeId = inspectionRecordTypeId;
            ic.ETT_Account__c = accId;
            ic.ETT_Brand__c = brandMasterId;
            ic.ETT_Collection_Card__c = collectionCradId;
            ic.ETT_Tyre_Size__c = tyreSizeMasterId;
            inspectionsCardsList.add(ic);
        }
        return inspectionsCardsList;
    } 
    
    public static List<ETT_Estimate_Quotation__c> createEstimateQuotations(String collectionCardId,String inspectionsCardId, String tyreSizeMasterId){
        List<ETT_Estimate_Quotation__c> estimateQuotationsList = new List<ETT_Estimate_Quotation__c>();
        for(integer i =0; i<=5;i++){
            ETT_Estimate_Quotation__c eq = new ETT_Estimate_Quotation__c();
            eq.ETT_Collection_Card__c = collectionCardId;
            eq.ETT_Tyre_Inspection_Card__c = inspectionsCardId;
            eq.ETT_Tyre_Size__c = tyreSizeMasterId;
            estimateQuotationsList.add(eq);
        }
        return estimateQuotationsList;
    }
    
    public static List<ETT_Delivery_Note__c> createDeliveryNotes(String recTypeName,String accId,String estimateQuotationId, String tyreSizeMasterId,String brandMasterId){
        Id recordTypeId = Schema.SObjectType.ETT_Delivery_Note__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        List<ETT_Delivery_Note__c> deliveryNotesList = new List<ETT_Delivery_Note__c>();
        for(integer i =0; i<=5;i++){
            ETT_Delivery_Note__c dn = new ETT_Delivery_Note__c();
            dn.ETT_Account__c = accId;
            dn.Estimate_Quotation__c = estimateQuotationId;
            dn.ETT_Tyre_Size__c = tyreSizeMasterId;
            dn.ETT_Brand_Name__c = brandMasterId;
            deliveryNotesList.add(dn);
        }
        return deliveryNotesList;
    }
    
    public static List<ETT_Delivery_Line_Item__c> createDeliveryLineItems(Integer size, String collectionCardId,String inspectionsCardId,String tyreSizeMasterId,String brandMasterId){
        List<ETT_Delivery_Line_Item__c> deliveryLineItemsList = new List<ETT_Delivery_Line_Item__c>();
        for(integer i =1; i<=size;i++){
            ETT_Delivery_Line_Item__c dli = new ETT_Delivery_Line_Item__c();
            dli.ETT_Tyre_Size__c = tyreSizeMasterId;
            dli.ETT_Brand_Master__c = brandMasterId;
            dli.ETT_Collection_Card__c = collectionCardId;
            dli.ETT_Prepared_By__c = userinfo.getUserId();
            dli.ETT_Inspection_Card__c = inspectionsCardId;
            deliveryLineItemsList.add(dli);
        }
        return deliveryLineItemsList;
    }
    
    public static ETT_Country_Master__c createCountries(String name){
        ETT_Country_Master__c cntry = new ETT_Country_Master__c();
        cntry.ETT_Country_Code__c = '971';
        cntry.Name = name;
        cntry.ETT_Status__c = true;
        
        return cntry;
    }
    
    public static List<ETT_Tyre_Master__c> createTyreMasters(String recTypeName, String patternMasterId,String countryId,String tyreSizeMasterId,String brandMasterId){
        Id recordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        List<ETT_Tyre_Master__c> tyreMastersList = new List<ETT_Tyre_Master__c>();
        for(integer i =1; i<=5;i++){
            ETT_Tyre_Master__c tm = new ETT_Tyre_Master__c();
            tm.ETT_Tyre_Size__c = tyreSizeMasterId;
            tm.ETT_Brand_Name__c = brandMasterId;
            tm.ETT_Pattern__c = patternMasterId;
            tm.ETT_Vehicle_Type__c = 'Bus';
            tm.ETT_Country__c = countryId;
            tyreMastersList.add(tm);
        }
        return tyreMastersList;
    }
    
    
    public static ETT_Work_Station__c createWorkStation(String stationCode,String stationType){
        ETT_Work_Station__c workStation=new ETT_Work_Station__c(ETT_Station_Code__c=stationCode,ETT_Station_Type__c=stationType);
        return workStation;
    }
    
    public static ETT_Work_Schedule__c createWorkSchedule(Id workStationId,Id userId,Datetime startTime,Datetime endTime){
        ETT_Work_Schedule__c workSchdule=new ETT_Work_Schedule__c(ETT_Start_time__c=startTime,ETT_End_time__c=endTime,ETT_Work_Station__c=workStationId,ETT_Technician__c=userId);
        return workSchdule;
    }
  
    public static ETT_Tools_Master__c createToolMaster(String toolname,String recTypeName,Decimal depth,Decimal factoryUnits,Decimal indvUnitVal,String itemCode,String itemDesc,String kgPErMtr,Decimal mainStockVal,String mainFrequency,
                                                         Id patternMasterId,String prodAreas,String type,String serialNo,string status,String suppliername,String trackDepriciable,String depriciableBehaviour,Decimal threadWidth,String unitText,String unitType,String usageType){
        Id recordTypeId = Schema.SObjectType.ETT_Tools_Master__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        ETT_Tools_Master__c toolMaster=new ETT_Tools_Master__c();
        toolMaster.name=toolname;
        toolMaster.RecordTypeId=recordTypeId;
        toolMaster.ETT_Depth__c=depth;
        toolMaster.ETT_Allocated_Units__c=factoryUnits;
        toolMaster.ETT_Individual_Unit_Value__c=indvUnitVal;
        toolMaster.ETT_Unique_Code__c=itemCode;
        toolMaster.ETT_Item_Description__c=itemDesc;
        toolMaster.ETT_KG_Per_Mtr__c=kgPErMtr;
        toolMaster.ETT_Main_Stock_Units__c=mainStockVal;
        toolMaster.ETT_Maintenance_Frquency__c=mainFrequency;
        toolMaster.ETT_Pattern_Master__c=patternMasterId;
        toolMaster.ETT_Production_Areas__c=prodAreas;
        toolMaster.ETT_Tool_type__c=type;
        toolMaster.ETT_Serial_No__c=serialNo;
        toolMaster.ETT_Status__c=status;
        toolMaster.ETT_Supplier__c=suppliername;
        toolMaster.ETT_Track_Depreciable_Item_Usage_at_JC__c=trackDepriciable;
        toolMaster.Depreciable_item_selection_behaviour__c=depriciableBehaviour;
        toolMaster.ETT_Tread_Width__c=threadWidth;
        toolMaster.Unit_Text__c=unitText;
        toolMaster.ETT_Unit_type__c=unitType;
        toolMaster.ETT_Usage_type__c=usageType;        
        return toolMaster;
    }
    
     public static ETT_Tools_Allocation__c createToolAllocation(Id toolMasterId,Decimal alloCatedUnits,Decimal totalStockVal,String status,Datetime startTime,Id assignedWorkStationId){
        ETT_Tools_Allocation__c stationAllocation=new ETT_Tools_Allocation__c(ETT_Assigned_Work_Station__c=assignedWorkStationId,ETT_Allocated_Units_to_Station__c=alloCatedUnits,ETT_Allocated_Stocks__c=totalStockVal,Allocation_Status__c=status,ETT_Tools_Master__c=toolMasterId,ETT_Usage_Start_time__c=startTime);
        return stationAllocation;
    }
}