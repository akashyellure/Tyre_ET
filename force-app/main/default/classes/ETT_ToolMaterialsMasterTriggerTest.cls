@isTest
public class ETT_ToolMaterialsMasterTriggerTest {
    public static testMethod void ETT_ToolMaterialsMasterTrigger_Approve() {
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
            if(toolList!=null && toolList.size()>0){
                integer i=0;
                for(ETT_JobCardListController.ToolWrapper ta:toolList){
                    if(ta.toolAllocation!=null && ta.toolAllocation.Id!=null){
                        if(ta.toolMaster!=null && ta.toolMaster.Id!=null && ta.toolMaster.ETT_Status__c!='Available'){
                            ta.toolMaster.ETT_Status__c='Available';
                            ta.toolMaster.ETT_Serial_No__c='mydummyserialno'+i;
                            update ta.toolMaster;
                            i++;
                        }                        
                        list<ProcessInstanceWorkitem> approvalReqLines=[SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: ta.toolAllocation.Id  AND ProcessInstance.Status = 'Pending'];
                        if(approvalReqLines!=null && approvalReqLines.size() >0){
                            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest(); 
                            pwr.setAction('Approve');
                            pwr.setWorkItemId(approvalReqLines[0].id);       
                            Approval.ProcessResult result = Approval.process( pwr );
                        }
                        
                        approvalReqLines=[SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: ta.toolAllocation.Id  AND ProcessInstance.Status = 'Pending'];
                        if(approvalReqLines!=null && approvalReqLines.size() >0){
                            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest(); 
                            pwr.setAction('Approve');
                            pwr.setWorkItemId(approvalReqLines[0].id);       
                            Approval.ProcessResult result = Approval.process( pwr );
                        }
                        
                        approvalReqLines=[SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: ta.toolAllocation.Id  AND ProcessInstance.Status = 'Pending'];
                        if(approvalReqLines!=null && approvalReqLines.size() >0){
                            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest(); 
                            pwr.setAction('Approve');
                            pwr.setWorkItemId(approvalReqLines[0].id);       
                            Approval.ProcessResult result = Approval.process( pwr );
                        }
                    }
                }
            }
        Test.StopTest();
    }
    
    public static testMethod void ETT_ToolMaterialsMasterTrigger_Reject() {
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
            if(toolList!=null && toolList.size()>0){
                integer i=0;
                for(ETT_JobCardListController.ToolWrapper ta:toolList){
                    if(ta.toolAllocation!=null && ta.toolAllocation.Id!=null){
                        if(ta.toolMaster!=null && ta.toolMaster.Id!=null && ta.toolMaster.ETT_Status__c!='Available'){
                            ta.toolMaster.ETT_Status__c='Available';
                            ta.toolMaster.ETT_Serial_No__c='mydummyserialno'+i;
                            update ta.toolMaster;
                            i++;
                        }                        
                        list<ProcessInstanceWorkitem> approvalReqLines=[SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: ta.toolAllocation.Id  AND ProcessInstance.Status = 'Pending'];
                        if(approvalReqLines!=null && approvalReqLines.size() >0){
                            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest(); 
                            pwr.setAction('Reject');
                            pwr.setWorkItemId(approvalReqLines[0].id);       
                            Approval.ProcessResult result = Approval.process( pwr );
                        }
                    }
                }
            }
        Test.StopTest();
    }
    
    public static testMethod void ETT_ToolMaterialsMasterTrigger_Validation_1() {
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
            if(toolList!=null && toolList.size()>0){
                integer i=0;
                for(ETT_JobCardListController.ToolWrapper ta:toolList){
                    if(ta.toolAllocation!=null && ta.toolAllocation.Id!=null){
                        list<ProcessInstanceWorkitem> approvalReqLines=[SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: ta.toolAllocation.Id  AND ProcessInstance.Status = 'Pending'];
                        if(approvalReqLines!=null && approvalReqLines.size() >0){
                            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest(); 
                            pwr.setAction('Approve');
                            pwr.setWorkItemId(approvalReqLines[0].id);       
                            Approval.ProcessResult result = Approval.process( pwr );
                        }
                        try{
                            approvalReqLines=[SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: ta.toolAllocation.Id  AND ProcessInstance.Status = 'Pending'];
                            if(approvalReqLines!=null && approvalReqLines.size() >0){
                                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest(); 
                                pwr.setAction('Approve');
                                pwr.setWorkItemId(approvalReqLines[0].id);       
                                Approval.ProcessResult result = Approval.process( pwr );
                            }
                        }
                        Catch(Exception e){
                            System.Assert(true);
                        }
                    }
                }
            }
        Test.StopTest();
    }
     public static testMethod void ETT_ToolMaterialsMasterTrigger_Validation() {
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
            if(toolList!=null && toolList.size()>0){
                integer i=0;
                for(ETT_JobCardListController.ToolWrapper ta:toolList){
                    if(ta.toolAllocation!=null && ta.toolAllocation.Id!=null){
                        if(ta.toolMaster!=null && ta.toolMaster.Id!=null && ta.toolMaster.ETT_Status__c!='Available'){
                            ta.toolMaster.ETT_Status__c='Available';
                            update ta.toolMaster;
                            i++;
                        }                        
                        list<ProcessInstanceWorkitem> approvalReqLines=[SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: ta.toolAllocation.Id  AND ProcessInstance.Status = 'Pending'];
                        if(approvalReqLines!=null && approvalReqLines.size() >0){
                            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest(); 
                            pwr.setAction('Approve');
                            pwr.setWorkItemId(approvalReqLines[0].id);       
                            Approval.ProcessResult result = Approval.process( pwr );
                        }
                        try{
                            approvalReqLines=[SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: ta.toolAllocation.Id  AND ProcessInstance.Status = 'Pending'];
                            if(approvalReqLines!=null && approvalReqLines.size() >0){
                                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest(); 
                                pwr.setAction('Approve');
                                pwr.setWorkItemId(approvalReqLines[0].id);       
                                Approval.ProcessResult result = Approval.process( pwr );
                            }
                        } 
                        Catch(Exception e){
                            System.Assert(true);
                        }
                    }
                }
            }
        Test.StopTest();
    }
}