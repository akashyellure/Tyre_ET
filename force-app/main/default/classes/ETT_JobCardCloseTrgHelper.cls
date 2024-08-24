/* Author: Janardhan
* Class: ETT_JobCardCloseTrgHelper
* CreatedDate: 14/11/2021
* Desc:
* TestClass:ETT_JobCardCloseTrgHelperTest
* */
public class ETT_JobCardCloseTrgHelper {
    
    public static Set<Id> alreadyProcessed = new Set<Id>();
   
    
    @future(callout=true)
    public static void createJCCLinesInOracle(String jccId,DateTime CustmDate,String jccName){
        System.debug('jccId >>> '+jccId+' CustmDate >>> '+CustmDate+' jccName >>> '+jccName);
        Map<Id,list<ETT_Job_Card_Close_Lines__c>> jccIdVsJccLines = new  Map<Id,list<ETT_Job_Card_Close_Lines__c>>();
        alreadyProcessed.add(jccId);
        System.debug('Id old'+alreadyProcessed);
        for(ETT_Job_Card_Close__c JCC : [select id,Name, (SELECT Id,Name,Available_Quantity__c,Material_Total_Cost__c,Cost__c,ETT_Item_Description__c,ETT_Unique_Code__c,Issued_Quantity__c,Item_Name__c,Job_Card_Close__c,Job_Type__c,Unit_Cost__c,UOM__c FROM Job_Card_Close_Lines__r) FROM ETT_Job_Card_Close__c where Id=:jccId]){
            jccIdVsJccLines.put(JCC.Id,JCC.Job_Card_Close_Lines__r);
        }
        System.debug('Map of Id Lines '+jccIdVsJccLines);
        ETT_CreateJournalVoucher_Service.execute_pt req = new ETT_CreateJournalVoucher_Service.execute_pt();
        ETT_CreateJournalVoucher.Response_element response = new ETT_CreateJournalVoucher.Response_element();
        ETT_CreateJournalVoucher.Journal_Header dataH = new ETT_CreateJournalVoucher.Journal_Header();
        list<ETT_CreateJournalVoucher.Journal_Lines> journallineList = new list<ETT_CreateJournalVoucher.Journal_Lines>();
        ETT_CreateJournalVoucher.execute_element msg = new ETT_CreateJournalVoucher.execute_element();
        for(ETT_Job_Card_Close_Lines__c JCCL : jccIdVsJccLines.get(jccId)){
            //Journal Voucher Lines (Credit)
            ETT_CreateJournalVoucher.Journal_Lines lineCredit = new ETT_CreateJournalVoucher.Journal_Lines();                
            lineCredit.Segment1 = '01';
            lineCredit.Segment2 = '311004';
            lineCredit.Segment3 = '92001';
            lineCredit.Segment4 = '213002';
            lineCredit.Segment5 = '000000';
            lineCredit.Segment6 = '12101203';
            lineCredit.Segment7 = '00';
            lineCredit.Segment8 = '000';
            lineCredit.Segment9 = '000';
            lineCredit.DebitAmount = null;
            lineCredit.CreditAmount = JCCL.Material_Total_Cost__c;
            lineCredit.Description = 'Crediting Rawmaterial Cost from WIP Account. Job Card#'+JCCL.Name;
            journallineList.add(lineCredit);
            //Journal Voucher Lines (Debit)
            ETT_CreateJournalVoucher.Journal_Lines lineDebit = new ETT_CreateJournalVoucher.Journal_Lines();                
            lineDebit.Segment1 = '01';
            lineDebit.Segment2 = '311004';
            lineDebit.Segment3 = '92001';
            lineDebit.Segment4 = '213002';
            lineDebit.Segment5 = '000000';
            lineDebit.Segment6 = '54010501';
            lineDebit.Segment7 = '00';
            lineDebit.Segment8 = '000';
            lineDebit.Segment9 = '000';
            lineDebit.DebitAmount = JCCL.Material_Total_Cost__c;
            lineDebit.CreditAmount = null;
            lineDebit.Description = 'Debiting Rawmaterial Cost from WIP Account. Job Card#'+JCCL.Name;
            journallineList.add(lineDebit);
        }
        //System.debug('journallineList Size >>> '+journallineList.Size());
        ETT_Job_Card_Close__c Jcc = new ETT_Job_Card_Close__c();
        Jcc.Id = jccId;
        dataH.AuthInfo = New ETT_CreateJournalVoucher.AuthInfo();
        dataH.AuthInfo.SourceSystem = 'SalesForce';
        dataH.AuthInfo.Username = 'SalesForce';
        dataH.AuthInfo.Password = 'SalesForce123';
        dataH.Source = 'Tyre System';
        dataH.Category = 'Tyre System JV';
        dataH.Reference = jccName; //'123'; //jccName;
        dataH.Date_x = CustmDate == null ? system.now().date() : CustmDate.date();
        dataH.CurrencyCode = 'AED';
        dataH.Journal_Lines = journallineList;
        msg.Journal_Voucher = dataH;
        // System.debug('dataH >>> '+dataH);
        try{           
            response = req.execute(dataH);
        }catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETT_JobCardCloseTrgHelper', 'createJCCLinesInOracle', 'ETT_JobCardCloseTrg', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
            //throw new AuraHandledException(ex.getMessage()); 
        }
        System.debug('response >>> '+response);
        if(response != null){
            if(response.PV_OUT_STATUS == 'Y'){
               // Jcc.Request_Status__c ='Success';
                Jcc.JV_Request_Status__c='Scccess';
                //Jcc.EBS_Ref_No__c = response.PV_OUT_EBIZ_TRX_NO;
                Jcc.JV_EBS_Ref_No__c=response.PV_OUT_EBIZ_TRX_NO;
            }else{
                //Jcc.Request_Status__c ='Failed';
                Jcc.JV_Request_Status__c='Failed';
                Jcc.Error_Msg__c = response.PV_OUT_ERROR;
            }
        }
        
        try {
            
            update Jcc; 
        } catch (DmlException e) {
            System.debug('Error updating job cards: ' + e.getMessage());
            // Handle exception appropriately, e.g., add error logging or rethrow
        }
        
    }
    
    @future(callout=true)
    public static void createMRInOracle(String jccId){
        
        List<ETT_Job_Card_Close__c> jccList = new List<ETT_Job_Card_Close__c>([SELECT id, Name,Collection_Date__c,Transaction_Date__c,Job_Card__r.Name,Tyre_Type__c, Job_Card__r.Tyre_Inventory__r.Item_Code__c, Job_Card__r.Tyre_Inventory__r.Serial_Number__c, (SELECT id, Name, Material_Total_Cost__c,Cost__c, Job_Card_Close__c, Job_Card_Close__r.Tyre_Type__c, Job_Card_Close__r.Job_Card__c, Job_Card_Close__r.Job_Card__r.Tyre_Inventory__c, Job_Card_Close__r.Job_Card__r.Tyre_Inventory__r.Item_Code__c FROM Job_Card_Close_Lines__r) 
                                                                               FROM ETT_Job_Card_Close__c WHERE Id=: jccId]);
        System.debug('JccList'+jccList);
        if(!jccList.isEmpty()){
            alreadyProcessed.add(jccId);
            
            ETT_MiscReceipt.MessageXml msg = new ETT_MiscReceipt.MessageXml();
            ETT_MiscReceipt_Service.SyncCreateMiscellaneousReceiptsServiceBPEL_pt req = new ETT_MiscReceipt_Service.SyncCreateMiscellaneousReceiptsServiceBPEL_pt();
            ETT_MiscReceipt_Output.OutputParameters_element response = new ETT_MiscReceipt_Output.OutputParameters_element();
            
            for(ETT_Job_Card_Close__c objJCC : jccList){
                ETT_MiscReceipt.Data_Header_type dataH = new ETT_MiscReceipt.Data_Header_type();
                list<ETT_MiscReceipt.Data_Lines_type> datalineList = new list<ETT_MiscReceipt.Data_Lines_type>();
                if(objJCC.Tyre_Type__c == 'Scrapped'){
                    System.debug('Scrapped');
                    dataH.TransactionType = 'JOB_CARD_COMPLTN_SCR_TYRE'; 
                }else if(objJCC.Tyre_Type__c == 'Refurbished'){
                    System.debug('Refurbished');
                    dataH.TransactionType = 'JOB_CARD_COMPLTN_REF_TYRE'; 
                }
                dataH.TransactionDate =objJCC.Transaction_Date__c == null ? System.now().date() : objJCC.Transaction_Date__c.date();
                dataH.DocumentNumber = objJCC.Job_Card__r.Name;
                Decimal totalCostLines=0;
                for(ETT_Job_Card_Close_Lines__c objJCCL : objJCC.Job_Card_Close_Lines__r){
                    if(objJCCL.Material_Total_Cost__c != null){
                        totalCostLines += objJCCL.Material_Total_Cost__c;
                    }
                }
                ETT_MiscReceipt.Data_Lines_type line = new ETT_MiscReceipt.Data_Lines_type();                
                line.LineNumber = '1';
                line.ItemCode = objJCC.Job_Card__r.Tyre_Inventory__r.Item_Code__c;
                line.OrgId = '426';
                line.Subinventory = 'AUH-TF-MS';
                String tyreType;
                if(objJCC.Tyre_Type__c == 'Scrapped'){
                    tyreType = 'Scrapped Tyres'; 
                }else if(objJCC.Tyre_Type__c == 'Refurbished'){
                    tyreType = 'Retreaded Tyres'; 
                }
                line.Locator = 'AUH-TF-MS.'+tyreType+'.0';
                line.Quantity = '1';
                line.UnitCost = String.valueOf(totalCostLines);
                line.SerialControlFlag = 'Y';
                ETT_MiscReceipt.Serialnumber_lines_element serialLines = new ETT_MiscReceipt.Serialnumber_lines_element();
                serialLines.Serialnumber = objJCC.Job_Card__r.Tyre_Inventory__r.Serial_Number__c;
                line.Serialnumber_lines = new List<ETT_MiscReceipt.Serialnumber_lines_element>{serialLines};
                    datalineList.add(line);
                
                msg.Data_Header = dataH;
                msg.Data_Lines_type = datalineList;
            }
            
            try{           
                response = req.process(msg);
            }catch(exception ex){
                UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETT_MiscellaneousTrgHandler', 'showData', '', UTIL_Logging.DEBUG_LEVEL_WARN);
                UTIL_Logging.logException(exLog);
                //throw new AuraHandledException(ex.getMessage()); 
            }
            if(response != null){
                System.debug('response --> '+response);
                if(response.PV_OUT_STATUS == 'Y'){
                    jccList[0].Request_Status__c ='Success';
                    jccList[0].EBS_Ref_No__c = response.PV_OUT_EBS_REF_NO;
                    jccList[0].Error_Msg__c = '';
                }else{
                    jccList[0].Request_Status__c ='Failed';
                    jccList[0].Error_Msg__c = response.PV_OUT_ERRORMESSAGE;
                    jccList[0].EBS_Ref_No__c = '';
                }
            }
            update jccList[0]; 
        }
        
    }
    
    public static void updateToolsItemMaster(Map<id,ETT_Job_Card_Close__c> trgNewMap,Map<id,ETT_Job_Card_Close__c> trgOldMap){
        System.debug('Inside');
        Set<Id> approvedJobCardIds = new Set<Id>();
        Map<Id,Decimal> toolMasIDVsIssuedQty = new  Map<Id,Decimal>();
        List<ETT_Tools_Master__c> updatedToolsMaster = new  List<ETT_Tools_Master__c>();
        for(ETT_Job_Card_Close__c jc : trgNewMap.values()){ 
            if(jc.Status__c != trgOldMap.get(jc.Id).Status__c && jc.Status__c == 'Approved'){
                   approvedJobCardIds.add(jc.Id);
            }
         
            
        }
        for(ETT_Job_Card_Close_Lines__c jcl : [select id,Item_Name__c,Issued_Quantity__c from ETT_Job_Card_Close_Lines__c where Issued_Quantity__c!=null AND Job_Card_Close__c=:approvedJobCardIds]){
            if(!toolMasIDVsIssuedQty.containsKey(jcl.Item_Name__c) ){
                toolMasIDVsIssuedQty.put(jcl.Item_Name__c,jcl.Issued_Quantity__c);
            }else{
                if(jcl.Issued_Quantity__c!=null)
                    toolMasIDVsIssuedQty.put(jcl.Item_Name__c,toolMasIDVsIssuedQty.get(jcl.Item_Name__c)+jcl.Issued_Quantity__c);
            }
        }
        
        for(ETT_Tools_Master__c tool : [select id,ETT_Allocated_Units__c from ETT_Tools_Master__c where Id=:toolMasIDVsIssuedQty.keyset()]){
            Decimal Allocatedunits = tool.ETT_Allocated_Units__c == Null ? 0:tool.ETT_Allocated_Units__c;
            Decimal updatedAllocatedUnits  = Allocatedunits - toolMasIDVsIssuedQty.get(tool.id);
            if (updatedAllocatedUnits < 0) {
                throw new AuraHandledException('Allocated units cannot be negative');
            }
            tool.ETT_Allocated_Units__c = updatedAllocatedUnits;
            updatedToolsMaster.add(tool);
            
        }
        System.debug('Tool master'+updatedToolsMaster);
        update updatedToolsMaster;
        
    }
  
    
}