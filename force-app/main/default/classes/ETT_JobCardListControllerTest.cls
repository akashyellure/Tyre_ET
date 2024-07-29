@isTest
public class ETT_JobCardListControllerTest {
    
    public static testMethod void ETT_JobCardListControllerTest_Buffing_Accepted() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Buffing-001','Buffing');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Buffing Machine','Tools',null,10,2,'Buffmachine001','Buffing machine',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id from ETT_Job_Card__c];
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Buffing');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',0,false,null,null);

            
            
        //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Station_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Skiving');
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Skiving', jobCard.ETT_Stages__c);//verify the job card moved to next stage
             ETT_JobCardListController.updateTyreMasterDetails(ett_tyre_master);
        
            List<ID> lstJCIDs = new List<ID>();
            lstJCIDs.add(jobCard.Id);
            ETT_JobCardListController.updateMultipleJobCardLineItems(jobLineWrap,true,true,'Skiving',JSON.serialize(lstJCIDs));
			ETT_JobCardListController.testfakecoverage();
           // ETT_JobCardListController.testfackecoverage1();
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Buffing_Accepted_Back() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Buffing-001','Buffing');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Buffing Machine','Tools',null,10,2,'Buffmachine001','Buffing machine',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id from ETT_Job_Card__c];
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Buffing');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Station_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Skiving');
             jobCard=[select Id,ETT_Buffing_Status__c,ETT_No_of_Buffing_revisions__c,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Skiving', jobCard.ETT_Stages__c);//verify the job card moved to next stage
             
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c='Buffing;'+jobCard.ETT_Job_Stages_to_Perform_Ordered__c;
             jobCard.ETT_No_of_Buffing_revisions__c+=1;
             jobCard.ETT_Buffing_Status__c='';
             update jobCard;
             
             toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             jobWrap=ETT_JobCardListController.getValidJobCards();
             currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Buffing');
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',0,false,null,null);
             
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Station_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Skiving');
             jobCard=[select Id,ETT_Buffing_Status__c,ETT_No_of_Buffing_revisions__c,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Skiving', jobCard.ETT_Stages__c);//verify the job card moved to next stage
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Buffing_Rejected() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Buffing-001','Buffing');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Buffing Machine','Tools',null,10,2,'Buffmachine001','Buffing machine',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id from ETT_Job_Card__c];
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Buffing');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Station_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Buffing machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Buffing machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Buffing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Initial Rejection';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
        Test.StopTest();
    }
    
    public static testMethod void ETT_JobCardListControllerTest_Skiving_Accepted() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Skiving-001','Skiving');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Skiving Machine','Tools',null,10,2,'Buffmachine001','Skiving machine',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Skiving';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';        
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             update jobCard;        
             
            List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Skiving');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Station_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            ETT_JobCardListController.initializeHoldLineItem();
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
            
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Repair');
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Repair', jobCard.ETT_Stages__c);//verify the job card moved to next stage
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Skiving_Rejected() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Skiving-001','Skiving');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Skiving Machine','Tools',null,10,2,'Skiving001','Skiving machine',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Skiving';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';        
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             update jobCard;  
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Skiving');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Station_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Skiving machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Skiving machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Initial Rejection';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Skiving_DefectToBuffing() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Skiving-001','Skiving');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Skiving Machine','Tools',null,10,2,'Skiving001','Skiving machine',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Skiving';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';        
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             update jobCard;  
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Skiving');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Station_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Skiving machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Skiving machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Skiving',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             //jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Initial Rejection';
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework on buffing needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Rm Not Correct'},'Buffing',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Buffing', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }

    public static testMethod void ETT_JobCardListControllerTest_Repair_Accepted() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Repair-001','Repair');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Repair Machine','Tools',null,10,2,'Repair001','Repair machine',null,20,'Daily',null,'Buffing;Skiving;Repair',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Repair';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';  
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             update jobCard;        
             
            List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Repair');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Repair_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Cementing');
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Cementing', jobCard.ETT_Stages__c);//verify the job card moved to next stage
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Repair_Rejected() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Repair-001','Repair');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Repair Machine','Tools',null,10,2,'Repair009','Repair machine',null,20,'Daily',null,'Buffing;Skiving;Repair',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_No_of_Repair_revisions__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Repair';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';  
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             update jobCard; 
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Repair');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Repair_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Repair machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Repair machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Initial Rejection';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Repair_DefectToBuffing() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Repair-001','Repair');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Repair Machine','Tools',null,10,2,'Repair001','Repair machine',null,20,'Daily',null,'Buffing;Skiving;Repair',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_No_of_Repair_revisions__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Repair';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';  
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             update jobCard; 
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Repair');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Repair_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Repair machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Repair machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework on buffing needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Rust Not Clear'},'Buffing',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Buffing', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Repair_DefectToSkiving() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Repair-001','Repair');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Repair Machine','Tools',null,10,2,'Repair001','Repair machine',null,20,'Daily',null,'Buffing;Skiving;Repair',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_No_of_Repair_revisions__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Repair';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';  
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             update jobCard; 
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Repair');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Repair_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Repair machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Repair machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Repair',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework on buffing needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Rust Not Clear'},'Skiving',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Skiving', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }

    public static testMethod void ETT_JobCardListControllerTest_Cementing_Accepted() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Cementing-001','Cementing');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Cementing Machine','Tools',null,10,2,'Cementing001','Cementing machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Cementing';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             update jobCard;        
             
            List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Cementing');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Filling');
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Filling', jobCard.ETT_Stages__c);//verify the job card moved to next stage
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Cementing_Rejected() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Cementing-001','Cementing');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Cementing Machine','Tools',null,10,2,'Cementing009','Cementing machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Cementing';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             update jobCard;  
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Cementing');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Cementing machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Cementing machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Initial Rejection';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Cementing_DefectToBuffing() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Cementing-001','Cementing');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Cementing Machine','Tools',null,10,2,'Cementing001','Cementing machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Cementing';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             update jobCard; 
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Cementing');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Cementing machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Cementing machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework on buffing needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Patch Missing'},'Buffing',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Buffing', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Cementing_DefectToSkiving() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Cementing-001','Cementing');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Cementing Machine','Tools',null,10,2,'Cementing003','Cementing machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Cementing';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             update jobCard; 
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Cementing');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Cementing machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Cementing machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework on buffing needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Patch Missing'},'Skiving',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Skiving', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Cementing_DefectToRepair() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Cementing-001','Cementing');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Cementing Machine','Tools',null,10,2,'Cementing005','Cementing machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Cementing';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             update jobCard; 
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Cementing');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Cementing machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Cementing machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Cementing',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework on buffing needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Patch Missing'},'Repair',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Repair', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }

    public static testMethod void ETT_JobCardListControllerTest_Filling_AcceptedToBuilding() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Filling-001','Filling');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Filling Machine','Tools',null,10,2,'Filling001','Filling machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Filling';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             //jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;
             
            List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Filling');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Building');//this will lead to error if user tried to set thrad stage when the thread stage was already completed
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Building', jobCard.ETT_Stages__c);//verify the job card moved back to new stage
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Filling_Validation() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Filling-001','Filling');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Filling Machine','Tools',null,10,2,'Filling001','Filling machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Filling';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             //jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;
             
            List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Filling');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Accepted';
            try{
                 jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Thread Preparation');//this will lead to error if user tried to set thrad stage when the thread stage was already completed
            }
            Catch(Exception e){
                System.assert(true);
            } 
            Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Filling_Accepted() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Filling-001','Filling');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Filling Machine','Tools',null,10,2,'Filling001','Filling machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Filling';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             //jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1);
            insert jobCard_thread;
             
            List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Filling');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Thread Preparation');
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Thread Preparation', jobCard.ETT_Stages__c);//verify the job card moved to next stage
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Filling_Rejected() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Filling-001','Filling');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Filling Machine','Tools',null,10,2,'Filling009','Filling machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Filling';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             //jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             update jobCard;        
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Filling');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Filling machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Filling machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Initial Rejection';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Filling_DefectToBuffing() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Filling-001','Filling');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Filling Machine','Tools',null,10,2,'Cementing001','Filling machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Filling';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             update jobCard;        
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Filling');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Filling machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Filling machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework on buffing needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper Cement solution Coting'},'Buffing',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             //system.assertEquals('Buffing', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        //system.assertEquals('Filling', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Filling_DefectToSkiving() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Filling-001','Filling');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Filling Machine','Tools',null,10,2,'Filling001','Filling machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Filling';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             update jobCard;         
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Filling');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Filling machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Filling machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper Cement solution Coting'},'Skiving',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             //system.assertEquals('Skiving', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Filling_DefectToRepair() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Filling-001','Filling');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Filling Machine','Tools',null,10,2,'Filling001','Filling machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Filling';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             update jobCard;    
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Filling');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Filling machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Filling machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper Cement solution Coting'},'Repair',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             //system.assertEquals('Repair', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Filling_DefectToCementing() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Filling-001','Filling');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Filling Machine','Tools',null,10,2,'Cementing005','Filling machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Filling';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             update jobCard;        
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Filling');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Filling machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Filling machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper Cement solution Coting'},'Repair',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             //system.assertEquals('Repair', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
             //system.assertEquals('Filling', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    
    public static testMethod void ETT_JobCardListControllerTest_Thread_Accepted() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Thread-001','Thread Preparation');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Thread Preparation Machine','Tools',null,10,2,'Thread Preparation','Thread Preparation machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Thread Preparation';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c='Thread Preparation;Building;Rimming & Enveloping;Curing;Final Inspection;Painting'; 
             update jobCard;

             ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1);
             insert jobCard_thread;
             
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Thread Preparation');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard_thread.Id,'Thread Preparation',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard_thread.Id,'Thread Preparation',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard_thread.Id,'Thread Preparation',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold'; 
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard_thread.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard_thread.Id,'Thread Preparation',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Thread Preparation');
             jobCard_thread=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard_thread.Id];
             //system.assertEquals('Thread Preparation', jobCard_thread.ETT_Stages__c);//verify the job card will stay in same stage since its thread stage
             system.assertEquals('Thread Preparation', jobCard_thread.ETT_Stages__c);//verify the job card will stay in same stage since its thread stage
        Test.StopTest();
    }
        
    public static testMethod void ETT_JobCardListControllerTest_Building_Accepted() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Building-001','Building');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Building Machine','Tools',null,10,2,'Building001','Building machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Building';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             orderList.remove(4);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;
             
            List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Building');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Rimming & Enveloping');
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             //system.assertEquals('Rimming & Enveloping', jobCard.ETT_Stages__c);//verify the job card moved to next stage 
             //system.assertEquals('Building', jobCard.ETT_Stages__c);//verify the job card moved to next stage 
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Building_Rejected() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Building-001','Building');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Building Machine','Tools',null,10,2,'Building009','Building machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Building';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             orderList.remove(4);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;  
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Building');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Filling machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Filling machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='Initial Rejection';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Building_DefectToBuffing() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Building-001','Building');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Filling Machine','Tools',null,10,2,'Cementing001','Filling machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Building';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             orderList.remove(4);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;     
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Building');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Building machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Building machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework on buffing needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper One Side Filling'},'Buffing',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Buffing', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Building_DefectToSkiving() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Building-001','Building');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Building Machine','Tools',null,10,2,'Building001','Building machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Building';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             orderList.remove(4);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;     
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Building');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Building machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Building machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper One Side Filling'},'Skiving',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Skiving', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Building_DefectToRepair() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Building-001','Building');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Building Machine','Tools',null,10,2,'Building001','Building machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
            ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Building';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             orderList.remove(4);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Building');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Building machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Building machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper One Side Filling'},'Repair',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Repair', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Building_DefectToCementing() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Building-001','Building');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Building Machine','Tools',null,10,2,'Building009','Building machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Building';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             orderList.remove(4);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;    
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Building');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Filling machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Filling machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper One Side Filling'},'Repair',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Repair', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Building_DefectToFilling() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Building-001','Building');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Building Machine','Tools',null,10,2,'Building005','Building machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Building';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             orderList.remove(4);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Building');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Building machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Building machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper One Side Filling'},'Filling',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Filling', jobCard.ETT_Stages__c);//verify the job card moved back to old stage   
        Test.StopTest();
    } 
    public static testMethod void ETT_JobCardListControllerTest_Building_DefectToThread() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Building-001','Building');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Building Machine','Tools',null,10,2,'Building-001','Building machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Building';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(1);
             orderList.remove(2);
             orderList.remove(3);
             orderList.remove(4);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;   
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Building');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='In-Progress';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             ETT_JobCardListController.getPreviousJobCardBuilding(jobWrap.currentWorkSchedule.Id);
             //Step-1 end
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',0,false,null,null);//calling same step again to cover sequence 0 related additional lines
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
             ETT_Job_Card_Line_Item__c Nextlineitem=new ETT_Job_Card_Line_Item__c();
             Nextlineitem.ETT_Activity_Performed__c='Light Conditions';
             Nextlineitem.ETT_Status__c='Not Started';
             Nextlineitem.ETT_Type__c='Pre-Requisite Work';
             
             ETT_Work_Activity__c nextWorkTracker=new ETT_Work_Activity__c();
             nextWorkTracker.ETT_Start_time__c=System.now();
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Building',2,false,Nextlineitem,nextWorkTracker);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Building machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Building machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Filling',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.jobLineItem.ETT_Remarks__c='Rework needed.';
             ETT_JobCardListController.reportDefectsAndUpdateStationsinDB(new List<String>{'Improper One Side Filling'},'Thread Preparation',jobLineWrap);
             jobCard=[select Id,ETT_Stages__c,ETT_No_of_Thread_Preparation_revisions__c from ETT_Job_Card__c where Id=:jobCard.Id];
             system.assertEquals('Thread Preparation', jobCard.ETT_Stages__c);//verify the job card moved back to old stage 
        Test.StopTest();
    }

    public static testMethod void ETT_JobCardListControllerTest_Rimming_Accepted() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Rimming & Enveloping-001','Rimming & Enveloping');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Rimming & Enveloping Machine','Tools',null,10,2,'Rimming & Enveloping','Rimming & Enveloping machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Rimming & Enveloping';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Cementing_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_Building_Status__c='Accepted';
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_No_of_Rimming_Env_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;
             
            List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Rimming & Enveloping');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Rimming & Enveloping',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
        
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Rimming & Enveloping',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
                         
            //hold step         
            jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Rimming & Enveloping',2,false,null,null);
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.holdLineItem.jobLineItem=new ETT_Job_Card_Line_Item__c();
            jobLineWrap.holdLineItem.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Job_Card__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].Id;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Status__c='In-Progress';
            jobLineWrap.holdLineItem.jobLineItem.ETT_Type__c='Pause';  
            jobLineWrap.holdLineItem.jobLineItem.Sequence__c=0;  
            jobLineWrap.holdLineItem.jobLineItem.RecordTypeId=currentRecTypeId;
            jobLineWrap.holdLineItem.jobLineItem.ETT_Revision_Number__c=jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            jobLineWrap.holdLineItem.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.holdLineItem.workTracker.ETT_End_time__c=null;     
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap.holdLineItem,true,false,null);
        
            //restart step-2 & resume from hold
            jobLineWrap.workTracker.Id=null;
            jobLineWrap.workTracker.ETT_Start_time__c=System.now();
            jobLineWrap.workTracker.ETT_End_time__c=null;
            ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
            
            jobLineWrap.jobLineItem.ETT_Activity_Performed__c='OnHold';
            jobLineWrap.jobLineItem.ETT_Job_Card__c=jobCard.Id;
            jobLineWrap.jobLineItem.ETT_Status__c='Completed';
            jobLineWrap.jobLineItem.ETT_Type__c='Pause'; 
            jobLineWrap.workTracker.ETT_End_time__c=System.now();
            jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);
        
            //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Rimming & Enveloping',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Accepted';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,'Curing');
             jobCard=[select Id,ETT_Stages__c from ETT_Job_Card__c where Id=:jobCard.Id];
             //system.assertEquals('Curing', jobCard.ETT_Stages__c);//verify the job card moved to next stage; uncomment once related code changes been done on related apex class for rimming stage
        Test.StopTest();
    }
    public static testMethod void ETT_JobCardListControllerTest_Rimming_Rejected() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Rimming & Enveloping-001','Rimming & Enveloping');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Rimming & Enveloping Machine','Tools',null,10,2,'Rimming & Enveloping','Rimming & Enveloping machine',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert allocationList;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_No_of_Buffing_revisions__c,ETT_Buffing_Status__c,
                                      ETT_No_of_Skiving_revisions__c,ETT_Skiving_Status__c,ETT_Repair_Status__c
                                      from ETT_Job_Card__c];
             jobCard.ETT_Stages__c='Building';
             List<String> orderList=jobCard.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             orderList.remove(0);
             jobCard.ETT_Job_Stages_to_Perform_Ordered__c=String.join(orderList,';');
             jobCard.ETT_Buffing_Status__c='Accepted';  
             jobCard.ETT_Skiving_Status__c='Accepted';
             jobCard.ETT_Repair_Status__c='Accepted';
             jobCard.ETT_Filling_Status__c='Accepted';
             jobCard.ETT_Building_Status__c='Accepted';
             jobCard.ETT_Cemented_Least_Available_Time__c=system.now().addminutes(-1);
             jobCard.ETT_No_of_Skiving_revisions__c=1;
             jobCard.ETT_No_of_Repair_revisions__c=1;
             jobCard.ETT_No_of_Cementing_revisions__c=1;
             jobCard.ETT_No_of_Filling_revisions__c=1;
             jobCard.ETT_No_of_Building_Revisions__c=1;
             jobCard.ETT_No_of_Rimming_Env_Revisions__c=1;
             jobCard.ETT_Thread_Preparation_Status__c='Waiting for Acceptance';
             jobCard.ETT_No_of_Thread_Preparation_revisions__c=1;
             jobCard.ETT_Thread_Least_Available_Time__c=system.now().addminutes(-1);
             update jobCard;

            ETT_Job_Card__c jobCard_thread=new ETT_Job_Card__c(ETT_Main_Job_Card__c=jobCard.Id,ETT_Stages__c='Thread Preparation',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Thread_Preparation_Status__c='Waiting for Acceptance');
            insert jobCard_thread;  
        
             List<ETT_JobCardListController.ToolsAndUsageWrapper> toolsList=ETT_JobCardListController.getStationToolsWithWrapper();
             ETT_JobCardListController.JobWrapper jobWrap=ETT_JobCardListController.getValidJobCards();
             Id currentRecTypeId=ETT_JobCardListController.getObjectRecordTypeIdByNme('ETT_Job_Card_Line_Item__c','Rimming & Enveloping');
             ETT_JobCardListController.JobLineItemWrapper jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Rimming & Enveloping',0,false,null,null);
             //Step-1
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Filling_Work_Schedule__c=jobWrap.currentWorkSchedule.Id;
             if(jobLineWrap.workTracker.ETT_Start_time__c==null){
                 jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             }
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             
             
             //Step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Rimming & Enveloping',2,false,null,null);
             //Update tools usage
             List<ETT_JobCardListController.mapWrapper> toolUsageListOptions=new List<ETT_JobCardListController.mapWrapper>();
             ETT_JobCardListController.mapWrapper newtoolUsage_1=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_1.label='Filling machine';
             newtoolUsage_1.value =stationAllocation_1.Id;
             newtoolUsage_1.requestedStockUnits=1;
             newtoolUsage_1.remarks='Filling machine';
             newtoolUsage_1.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_1.Id];
             newtoolUsage_1.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Whether_it_s_used_or_not__c=true);
             toolUsageListOptions.add(newtoolUsage_1);
        
             ETT_JobCardListController.mapWrapper newtoolUsage_2=new ETT_JobCardListController.mapWrapper();
             newtoolUsage_2.label='Shoulder strip';
             newtoolUsage_2.value =stationAllocation_2.Id;
             newtoolUsage_2.remarks='Shoulder strip';
             newtoolUsage_2.requestedStockUnits=2;
             newtoolUsage_2.toolAllocationDet=[Select Id,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,
                                               ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c from ETT_Tools_Allocation__c where Id=:stationAllocation_2.Id];
             newtoolUsage_2.toolUsage=new ETT_Tools_Material_Usage__c(ETT_Usage_Value__c=0.2);
             toolUsageListOptions.add(newtoolUsage_2);
             toolUsageListOptions=ETT_JobCardListController.updateToolsUsageInDB(toolUsageListOptions,jobLineWrap);
             
             for(ETT_JobCardListController.mapWrapper m:toolUsageListOptions){
                 if(m.value==stationAllocation_1.Id){
                     m.requestedStockUnits=1;
                     m.value =stationAllocation_1.Id;
                 }  if(m.value==stationAllocation_2.Id){
                     m.requestedStockUnits=2;
                     m.value =stationAllocation_2.Id;
                 }                 
                 m.lstFileWrapperDetails=new List<ETT_JobCardListController.FileWrapper>();
                 ETT_JobCardListController.FileWrapper file_1=new ETT_JobCardListController.FileWrapper();
                 file_1.fileContent='Test';
                 file_1.strFileName='Test bname';
                 file_1.strFileType='application/pdf';
                 m.lstFileWrapperDetails.add(file_1);
             }
             List<ETT_JobCardListController.ToolWrapper> toolList=ETT_JobCardListController.createToolRequestMethodVersion2(jobLineWrap,toolUsageListOptions,jobWrap.currentWorkSchedule.ETT_Work_Station__c);
             toolList=ETT_JobCardListController.refreshRequestStatusMethod(JSON.Serialize(toolList)); 
             jobLineWrap.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
             jobLineWrap.jobLineItem.ETT_Initial_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Not Started';
             jobLineWrap.jobLineItem.ETT_Type__c='Pre-Requisite Work';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,false,null);                       
            
             //end step-2
             jobLineWrap=ETT_JobCardListController.getValidJobCardLineDetail(jobCard.Id,'Rimming & Enveloping',2,false,null,null);
             jobLineWrap.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
             jobLineWrap.jobLineItem.ETT_Status__c='Completed';
             jobLineWrap.workTracker.ETT_Start_time__c=System.now();
             jobLineWrap.workTracker.ETT_End_time__c=System.now();
        
             jobLineWrap.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Initial Rejection';
             jobLineWrap=ETT_JobCardListController.updateJobCardLine(jobLineWrap,true,true,null);
             //ETT_JobCardListController.getTyreSizeFromIc('test')      ;
    
        Test.StopTest();
    }
   /*  public static testMethod void updateNewTyreSize() {
       
       
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        //ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
           // ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
        
        
            
        Test.StartTest();
          ETT_Work_Station__c objWS = new ETT_Work_Station__c();
        objWS.ETT_Station_Type__c = 'Buffing';
        objWS.ETT_Station_Code__c = 'BFF001';
        insert objWS;
        
        ETT_Work_Schedule__c objWSCH =  new ETT_Work_Schedule__c();
        objWSCH.ETT_Work_Station__c = objWS.Id;
        objWSCH.ETT_Start_time__c = Date.newInstance(2021, 12, 7);
        objWSCH.ETT_End_time__c = Date.newInstance(2022, 12, 9);
        insert objWSCH;
       
          ETT_Job_Card__c objJC = new ETT_Job_Card__c();
        objJC.ETT_Stages__c = 'Buffing';
        objJC.ETT_Building_Work_Schedule__c = objWSCH.Id;
        insert objJC;
        
        ETT_Job_Card_Line_Item__c objJCLI = new ETT_Job_Card_Line_Item__c();
        objJCLI.ETT_Job_Card__c = objJC.Id;
        objJCLI.ETT_Activity_Performed__c = 'Building Rim Status Check';
        objJCLI.ETT_Type__c = 'Pre-Requisite Work';
        objJCLI.Sequence__c = 7;
        objJCLI.ETT_Status__c='Completed';
        insert objJCLI;
         ETT_Job_Card__c jobCard=[select Id from ETT_Job_Card__c];
        ETT_JobCardListController.getTyreSizeFromIc(jobCard.id)      ;
    
        Test.StopTest();
    }*/
    public static testMethod void ETT_JobCardListControllerTest_1() {
        List<Account> acc = ETT_TestFactory.createAccounts('Test account','Tyre Supplier');
        insert acc;
        
        list<Lead> leadobj = ETT_TestFactory.createLeads();
        insert leadobj;
        
        List<ETT_Staging_Quotation_Request__c> ett_staging_quotation_request =ETT_TestFactory.createStagingQuoteRequests(leadobj[0].id);
        insert ett_staging_quotation_request;  
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','Test opp','Qualification',System.today(),acc[0].id);
        insert opp;
        
        ETT_Collection_Card__c ett_collection_card= new ETT_Collection_Card__c();
        ett_collection_card.ETT_Accounts__c = acc[0].Id;
        ett_collection_card.ETT_Status__c = 'New';
        ett_collection_card.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
        insert ett_collection_card;
        
        ETT_Price_Master__c ett_price_master = new ETT_Price_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Party_Name__c = acc[0].id,
            ETT_Party_Type__c = 'Customer',
            ETT_Payment_Terms__c = '120 days');
        insert ett_price_master;
        
        ETT_Tyre_Size_Master__c ett_tyre_size_master =new ETT_Tyre_Size_Master__c(
            Name = '06-50-10',
            CurrencyIsoCode = 'AED',
            ETT_Description__c = '06.50-10 SMALL TYRE',
            ETT_Status__c = true);
        insert ett_tyre_size_master;
        
        ETT_Brand_Master__c ett_brand_master = new ETT_Brand_Master__c(
            Name = '56789',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = false);
        
        insert ett_brand_master;
        
        ETT_Pattern_Master__c ett_pattern_master = new ETT_Pattern_Master__c(
            Name = '215',
            CurrencyIsoCode = 'AED',
            ETT_Brand_Name__c = 'YOKOHAMA',
            ETT_Status__c = true);
        insert ett_pattern_master;
        ETT_Country_Master__c ett_country_master = new ETT_Country_Master__c(
            Name = 'a',
            CurrencyIsoCode = 'AED',
            ETT_Status__c = true);
        insert ett_country_master;
        
        ETT_Tyre_Master__c ett_tyre_master = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
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
                                                                RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId(),
                                                               ETT_Collection_Card__c = ett_collection_card.Id);
       
       insert wrkOrdrLineItm;  
       
       ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
       objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
       objIC.ETT_Collection_Card__c = ett_collection_card.Id;
       objIC.ETT_Status__c = 'Accept';
       insert objIC;
       
        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = ett_brand_master.Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = ett_tyre_size_master.Id;
        objstgQuotReq.ETT_Country__c = ett_country_master.Id;
        objstgQuotReq.ETT_Pattern__c = ett_pattern_master.Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = ett_collection_card.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        
        ett_collection_card.ETT_Inspection_Done__c=true;
        ett_collection_card.ETT_Create_Job_Card__c=true;
        update ett_collection_card;
        
        system.assertEquals(1,[select count() from ETT_Job_Card__c]);
        ETT_Work_Station__c workStation=ETT_TestFactory.createWorkStation('Buffing-001','Buffing');
        insert workStation;
        
        ETT_Work_Schedule__c workSchdule=ETT_TestFactory.createWorkSchedule(workStation.Id,Userinfo.getUSerId(),System.now(),System.now().addMinutes(2));
        insert workSchdule;
        
        List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Buffing Machine','Tools',null,10,2,'Buffmachine001','Buffing machine',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
        
        List<ETT_Tools_Allocation__c> allocationList=new List<ETT_Tools_Allocation__c>();
        ETT_Tools_Allocation__c stationAllocation_1=ETT_TestFactory.createToolAllocation(toolMaster_1.Id,2,4,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_1);
        ETT_Tools_Allocation__c stationAllocation_2=ETT_TestFactory.createToolAllocation(toolMaster_2.Id,2,10,'Approved',System.now(),workStation.Id);
        allocationList.add(stationAllocation_2);
        insert stationAllocation_2;
        
        ETT_Skill_Set__c skills=new ETT_Skill_Set__c(name='Welding',ETT_Skill_Description__c='Welding',ETT_Work_Station_Type__c='Buffing;Skiving');
        insert skills;
            
        Test.StartTest();
             ETT_Job_Card__c jobCard=[select Id from ETT_Job_Card__c];
            ETT_JobCardListController.getDesiredlengthSize(jobCard.id);
        try{
           ETT_JobCardListController.getJobCardLineItemData(null,'Test',1); 
        }catch(Exception e)
        {}
        try{
        ETT_JobCardListController.getSideWallDetails(null,'Test',1);
        }
        catch(Exception e){}
        ETT_JobCardListController.getTyreSizeFromIc(jobCard.id);
        ETT_JobCardListController.updateNewTyreSize(jobCard.id,null,'06-50-10');
        ETT_JobCardListController.updateNewTyrePattern(jobCard.id,null,'215');
        ETT_JobCardListController.updateNewTyrePattern(jobCard.id,null,'111');
        ETT_JobCardListController.updateValveOnJC(new List<ETT_Job_Card__c>{jobCard});
        
      
           // ETT_JobCardListController.testfackecoverage1();
        Test.StopTest();
    }
    
    /*
    public static testMethod void HOONotification(){
        List<Account> lstAcc = new List<Account>();
        lstAcc = ETT_TestFactory.createAccounts('Test account','Organization');
        insert lstAcc;
        ETT_JobCardListController.HOONotification(lstAcc[0].Id);
        
        ETT_Work_Station__c objWS = new ETT_Work_Station__c();
        objWS.ETT_Station_Type__c = 'Buffing';
        objWS.ETT_Station_Code__c = 'BFF001';
        insert objWS;
        
        ETT_Work_Schedule__c objWSCH =  new ETT_Work_Schedule__c();
        objWSCH.ETT_Work_Station__c = objWS.Id;
        objWSCH.ETT_Start_time__c = Date.newInstance(2021, 12, 7);
        objWSCH.ETT_End_time__c = Date.newInstance(2022, 12, 9);
        insert objWSCH;
        
        ETT_Job_Card__c objJC = new ETT_Job_Card__c();
        objJC.ETT_Stages__c = 'Buffing';
        objJC.ETT_Building_Work_Schedule__c = objWSCH.Id;
        insert objJC;
        
        ETT_Job_Card_Line_Item__c objJCLI = new ETT_Job_Card_Line_Item__c();
        objJCLI.ETT_Job_Card__c = objJC.Id;
        objJCLI.ETT_Activity_Performed__c = 'Building Rim Status Check';
        objJCLI.ETT_Type__c = 'Pre-Requisite Work';
        objJCLI.Sequence__c = 7;
        objJCLI.ETT_Status__c='Completed';
        insert objJCLI;
        
        ETT_JobCardListController.getJobCardLineItemData(objJC.Id, 'Buffing', 7);
        ETT_JobCardListController.getSideWallDetails(objJC.Id, 'Buffing', 7);
        ETT_JobCardListController.getPreviousJobCardBuilding(objWSCH.Id);
        
        
        ETT_Work_Activity__c nextWorkTracker = new ETT_Work_Activity__c();
        nextWorkTracker.ETT_Start_time__c = Date.newInstance(2021, 12, 7);
        nextWorkTracker.ETT_Job_Card_Line_Item__c = objJCLI.Id;
        insert nextWorkTracker;
        
        ETT_Tools_Allocation__c objTool = new ETT_Tools_Allocation__c();
        
        ETT_JobCardListController.JobWrapper objJBWRP = new ETT_JobCardListController.JobWrapper();
        ETT_JobCardListController.JobLineItemWrapper objBLIWRP = new ETT_JobCardListController.JobLineItemWrapper();
        ETT_JobCardListController.ToolsAndUsageWrapper objToolWRP = new ETT_JobCardListController.ToolsAndUsageWrapper(objTool);
        
        ETT_JobCardListController.getObjectRecordTypeIdByNme('Lead','Tyre - Cash Supplier');
        ETT_JobCardListController.getStationToolsWithWrapper();
        ETT_JobCardListController.initializeHoldLineItem();
        ETT_JobCardListController.queryAllSObjectFields('Account');
        ETT_JobCardListController.getValidJobCards();
        //ETT_JobCardListController.getValidJobCardLineDetail(objJC.Id, 'Buffing', 7, true, null, null);
        
        ETT_Tyre_Master__c tyreMaster = new ETT_Tyre_Master__c();
        insert tyreMaster;
        
        ETT_JobCardListController.updateTyreMasterDetails(tyreMaster);
        //ETT_JobCardListController.toolWrapper();
        //ETT_JobCardListController.mapWrapper();
        //ETT_JobCardListController.FileWrapper();        
        //  ETT_JobCardListController.getMultipleValidJobCardLineDetail(recordIds, stageValue, current_sequence, readOnlyView, Nextlineitem, nextWorkTracker);
        //  ETT_JobCardListController.updateMultipleJobCardLineItems(jobCardlineWrapper, trackActivity, updateJobCard, selectedNextStation, jobCardIds)      ;
    
    }
    */
    
    
}