public class ETT_DeliveryNoteTriggerHandler {
    public static Set<Id> alreadyProcessed = new Set<Id>();
    @future(callout=true)
    public static void createDNLinesInOracle(String dnId,DateTime CustmDate,String dnName){
        System.debug('dnId >>> '+dnId+' CustmDate >>> '+CustmDate+' dnName >>> '+dnName);
        Map<Id,ETT_Delivery_Note__c> dnIdVsDn = new Map<Id,ETT_Delivery_Note__c>();
        //Map<Id,list<ETT_Delivery_Line_Item__c>> dnIdVsDnLines = new Map<Id,list<ETT_Delivery_Line_Item__c>>();
        alreadyProcessed.add(dnId);
        system.debug('alreadyProcessed : '+alreadyProcessed);
        for(ETT_Delivery_Note__c dn : [SELECT Id,Name,SubInventory_Code__c,SubInventory__r.ETT_Operating_Unit_Id__c, (SELECT Id,Name,Status__c,Brand__c,ETT_Brand_Master__c,ETT_Collection_Card__c,ETT_Confirmed_By__c,ETT_Delivery_Date_Time__c,ETT_Delivery_Note__c,ETT_Inspection_Card__c,ETT_Is_Checked__c,ETT_Job_Type__c,ETT_Pattern_Master__c,ETT_Prepared_By__c,ETT_Price__c,ETT_Quantity__c,ETT_Received_Date__c,ETT_Receiver_Designation__c,ETT_Receiver_Name__c,ETT_Tyre_Size__c,ETT_Vehicle_Number__c,Job_type__c,ETT_Delivery_Note__r.SubInventory_Code__c,Tyre_Inventory__r.Item_Code__c FROM Delivery_Line_Items__r) FROM ETT_Delivery_Note__c WHERE Id =: dnId]){
            dnIdVsDn.put(dn.Id,dn);
            //dnIdVsDnLines.put(dn.Id,dn.Delivery_Line_Items__r);
        }
        
        Map<String,list<ETT_Delivery_Line_Item__c>> icVsDli = new Map<String,list<ETT_Delivery_Line_Item__c>>();
        Map<String,list<ETT_InterOrgTransfer_DeliveryNote.Serialnumber_lines_element>> icVsSerLines = new Map<String,list<ETT_InterOrgTransfer_DeliveryNote.Serialnumber_lines_element>>();
        //Set<String> tsmNames = New Set<String>();
        //Map<String,TyreInventoryPriceSettings__c> tsmVsTips = new Map<String,TyreInventoryPriceSettings__c>();
        for(ETT_Delivery_Line_Item__c dli : [SELECT Id,Name,Brand__c,ETT_Brand_Master__c,ETT_Collection_Card__c,ETT_Confirmed_By__c,ETT_Delivery_Date_Time__c,ETT_Delivery_Note__c,ETT_Inspection_Card__c,ETT_Is_Checked__c,ETT_Job_Type__c,ETT_Pattern_Master__c,ETT_Prepared_By__c,ETT_Price__c,ETT_Quantity__c,ETT_Received_Date__c,ETT_Receiver_Designation__c,ETT_Receiver_Name__c,ETT_Tyre_Size__c,ETT_Vehicle_Number__c,Job_type__c,ETT_Delivery_Note__r.SubInventory_Code__c,Tyre_Inventory__r.Item_Code__c,ETT_Tyre_Size__r.Name,Tyre_Inventory__r.Serial_Number__c FROM ETT_Delivery_Line_Item__c WHERE ETT_Delivery_Note__c =: dnId]){
            //tsmNames.add(dli.ETT_Tyre_Size__r.Name);
            ETT_InterOrgTransfer_DeliveryNote.Serialnumber_lines_element serLine = New ETT_InterOrgTransfer_DeliveryNote.Serialnumber_lines_element();
            serLine.Serialnumber = dli.Tyre_Inventory__r.Serial_Number__c;
            system.debug('Item_Code__c >>> '+dli.Tyre_Inventory__r.Item_Code__c);
            if(!icVsDli.containsKey(dli.Tyre_Inventory__r.Item_Code__c)){
                icVsDli.put(dli.Tyre_Inventory__r.Item_Code__c, new List<ETT_Delivery_Line_Item__c>{dli});
                icVsSerLines.put(dli.Tyre_Inventory__r.Item_Code__c, new List<ETT_InterOrgTransfer_DeliveryNote.Serialnumber_lines_element>{serLine});
            }else if(icVsDli.containsKey(dli.Tyre_Inventory__r.Item_Code__c)){
                icVsDli.get(dli.Tyre_Inventory__r.Item_Code__c).add(dli);
                icVsSerLines.get(dli.Tyre_Inventory__r.Item_Code__c).add(serLine);
            }
        }
        System.debug('icVsDli >>> '+icVsDli);
        System.debug('icVsSerLines >>> '+icVsSerLines);
        //System.debug('tsmNames >>> '+tsmNames);
        //System.debug('tsmVsTips >>> '+tsmVsTips);
        ETT_InterOrgTransfer_Service.SyncInterOrgTransfersServiceBPEL_pt req = new ETT_InterOrgTransfer_Service.SyncInterOrgTransfersServiceBPEL_pt();
        ETT_InterOrgTransfer_Output.OutputParameters_element response = new ETT_InterOrgTransfer_Output.OutputParameters_element();
        ETT_InterOrgTransfer_DeliveryNote.Data_Header_type dataH = new ETT_InterOrgTransfer_DeliveryNote.Data_Header_type();
        list<ETT_InterOrgTransfer_DeliveryNote.Data_Lines_type> datalineList = new list<ETT_InterOrgTransfer_DeliveryNote.Data_Lines_type>();
        ETT_InterOrgTransfer_DeliveryNote.MessageXml msg = new ETT_InterOrgTransfer_DeliveryNote.MessageXml();
        ETT_InterOrgTransfer_DeliveryNote.MessageHeader msgHeader = new ETT_InterOrgTransfer_DeliveryNote.MessageHeader();
        dataH.TransactionType = 'XFER_REF_TYRES_TO_BRANCHES';
        dataH.FromOrg = '426';
        if(dnIdVsDn.size() > 0 && dnIdVsDn.containsKey(dnId))
            dataH.ToOrg = String.valueOf(dnIdVsDn.get(dnId).SubInventory__r.ETT_Operating_Unit_Id__c); //'345'; //SubInventory__r.ETT_Operating_Unit_Id__c
        dataH.TransactionDate = CustmDate == null ? system.now().date() : CustmDate.date();
        dataH.DocumentNumber = dnName;
        Integer loopCount = 0;
        if(icVsDli.Size() >= 0){
            for(String icode : icVsDli.keySet()){
                loopCount++;
                ETT_InterOrgTransfer_DeliveryNote.Data_Lines_type line = new ETT_InterOrgTransfer_DeliveryNote.Data_Lines_type();                
                line.LineNumber = String.ValueOf(loopCount);
                System.debug(loopCount+' <<< loopCount');
                line.ItemCode = icode;
                line.FromSubInventory = 'AUH-TF-MS'; 
                line.FromLocator = 'AUH-TF-MS.Retreaded Tyres.0';
                if(icVsDli.containsKey(icode)){
                    line.Quantity = String.ValueOf(icVsDli.get(icode).Size());
                    if(icVsDli.get(icode).Size() > 0){
                        line.ToSubInventory = icVsDli.get(icode)[0].ETT_Delivery_Note__r.SubInventory_Code__c; //dnl.Tyre_Inventory__c; //dn.SubInventory_Code__c //dnl.ETT_Delivery_Note__r.SubInventory_Code__c
                        line.ToLocator = icVsDli.get(icode)[0].ETT_Delivery_Note__r.SubInventory_Code__c+'.Retreaded Tyres.0'; //'AJM-IAA-MW.Retreaded Tyres.0'
                    }
                }
                line.SerialControlFlag = 'Y';
                if(icVsSerLines.Size() > 0 && icVsSerLines.containsKey(icode))
                    line.Serialnumber_lines = icVsSerLines.get(icode);
                datalineList.add(line);
            }
        }
        system.debug('datalineList >>> '+datalineList);
        msg.Data_Header = dataH;
        msg.Data_Lines_type = datalineList;
        try{           
            response = req.process(msg);
        }catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETT_DeliveryNoteTriggerHandler', 'createDNLinesInOracle', 'ETT_DeliveryNote', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
            System.debug('Exception : '+ex.getMessage());
            //throw new AuraHandledException(ex.getMessage()); 
        }
        system.debug('response >>> '+response);
        if(response != null){
            Integer maxSize = 255;
            ETT_Delivery_Note__c dn = new ETT_Delivery_Note__c();
            dn.Id = dnId;
            if(response.PV_OUT_STATUS == 'Y'){
                dn.Request_Status__c = 'Success';
                dn.Error_Msg__c = '';
                if(response.PV_OUT_EBS_REF_NO != null && response.PV_OUT_EBS_REF_NO.length() > maxSize )
                    dn.EBS_Ref_No__c = response.PV_OUT_EBS_REF_NO.substring(0, maxSize);
                else
                    dn.EBS_Ref_No__c = response.PV_OUT_EBS_REF_NO;
            }else{
                dn.Request_Status__c = 'Failed';
                //dn.EBS_Ref_No__c = '';
                if(response.PV_OUT_ERRORMESSAGE != null && response.PV_OUT_ERRORMESSAGE.length() > maxSize )
                    dn.Error_Msg__c = response.PV_OUT_ERRORMESSAGE.substring(0, maxSize);
                else
                    dn.Error_Msg__c = response.PV_OUT_ERRORMESSAGE;
            }
            update dn; 
        }
    }
    /*
    @future(callout=true)
    public static void createARInOracle(String dnId){
        system.debug('dnId=='+dnId);
        List<ETT_Delivery_Note__c> dnList = new List<ETT_Delivery_Note__c>([SELECT id,Name, CreatedDate, ETT_Reference__c, ETT_Date__c, ETT_Account__c,ETT_Account__r.AccountNumber, ETT_Account__r.Party_Type__c, (SELECT id, Status__c,Name,ETT_Tyre_size_Integration__c,ETT_Tyre_Size__c, ETT_Quantity__c, ETT_Price__c, ETT_Job_Type__c, ETT_Status__c from Delivery_Line_Items__r) 
                                                                            FROM ETT_Delivery_Note__c WHERE Id=: dnId AND ETT_Account__r.Party_Type__c = 'Customer']);
        system.debug('dnId=='+dnList);
        if(!dnList.isEmpty()){
            alreadyProcessed.add(dnId);
            
            ETT_ARInvoiceSchema.AMAN_INVOICE_element msg = new ETT_ARInvoiceSchema.AMAN_INVOICE_element();
            ETT_ARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt req = new ETT_ARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt();
            ETT_ARInvoiceOutput.OutputParameters_element response = new ETT_ARInvoiceOutput.OutputParameters_element();
            ETT_ARInvoiceOutput.InputParameters_element inputElement = new ETT_ARInvoiceOutput.InputParameters_element();
            
            for(ETT_Delivery_Note__c objDN : dnList){
                ETT_ARInvoiceSchema.INV_HEADER_element dataH = new ETT_ARInvoiceSchema.INV_HEADER_element();
                list<ETT_ARInvoiceSchema.INV_LINES_element> datalineList = new list<ETT_ARInvoiceSchema.INV_LINES_element>();
                dataH.BatchSource = 'Tyre';
                dataH.TransactionNumber = objDN.Name;
                dataH.TransactionDate = objDN.ETT_Date__c == null ? system.now().date() : objDN.ETT_Date__c.date();
                dataH.TransactionCurrency = 'AED';
                dataH.CustTrxType = 'TYRE';
                dataH.BillToCustomerNumber = objDN.ETT_Account__r.AccountNumber;
                dataH.Comments = objDN.ETT_Reference__c ;
                
                for(ETT_Delivery_Line_Item__c objDLI : objDN.Delivery_Line_Items__r){
                    Decimal price = 0;
                    if(objDLI.ETT_Price__c != null){
                        price = objDLI.ETT_Price__c;
                    }
                    ETT_ARInvoiceSchema.INV_LINES_element line = new ETT_ARInvoiceSchema.INV_LINES_element();                
                    line.line_number = Integer.valueOf(objDLI.Name.split('-')[1]);
                    line.line_type = 'RET_SVC';
                    line.Description = objDLI.ETT_Tyre_size_Integration__c+'-'+objDLI.ETT_Job_Type__c+'-'+objDLI.Status__c;
                    line.Quantity = 1; //objDLI.ETT_Quantity__c;
                    line.Rate = price;
                    line.Amount = price*1;//objDLI.ETT_Quantity__c;
                    line.Tax_Code = 'VAT AR RECOVER STD@5%';
                    line.Tax_Rate = 5;
                    line.Tax_Amount = (5.0 / 100) * line.Amount;//objDLI.ETT_Quantity__c);
                    line.Activity_Center = '213002';
                    line.Location = '311004';
                    line.Department = '94001';
                    line.Project = '000000';
                    datalineList.add(line);
                }
                System.debug('datalineList '+datalineList);
                ETT_ARInvoiceSchema.LINES_GROUP_element groupElement = new ETT_ARInvoiceSchema.LINES_GROUP_element();
                groupElement.INV_LINES = datalineList;
                msg.INV_HEADER = dataH;
                msg.LINES_GROUP = groupElement;
            }
            
            try{           
                response = req.process(msg);
                
            }catch(exception ex){
                UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETT_DeliveryNoteTriggerHandler', 'createARInOracle', '', UTIL_Logging.DEBUG_LEVEL_WARN);
                UTIL_Logging.logException(exLog);
                System.debug('ex '+ex.getStackTraceString());
                //throw new AuraHandledException(ex.getMessage()); 
            }
            if(response != null){
                System.debug('response '+response);
                Integer maxSize = 255;
                if(response.PV_OUT_STATUS == 'Y'){
                    dnList[0].Request_Status__c ='Success';
                    if(response.PV_OUT_EBIZ_TRX_NO != null && response.PV_OUT_EBIZ_TRX_NO.length() > maxSize)
                        dnList[0].EBS_Ref_No__c = response.PV_OUT_EBIZ_TRX_NO.substring(0, maxSize);
                    else
                        dnList[0].EBS_Ref_No__c = response.PV_OUT_EBIZ_TRX_NO;
                    //dnList[0].EBS_Ref_No__c = response.PV_OUT_EBIZ_TRX_NO;
                    dnList[0].Error_Msg__c = '';
                }else{
                    dnList[0].Request_Status__c ='Failed';
                    if(response.PV_OUT_ERROR != null && response.PV_OUT_ERROR.length() > maxSize)
                        dnList[0].Error_Msg__c = response.PV_OUT_ERROR.substring(0, maxSize);
                    else
                        dnList[0].Error_Msg__c = response.PV_OUT_ERROR;
                    //dnList[0].Error_Msg__c = response.PV_OUT_ERROR;
                    //dnList[0].EBS_Ref_No__c = '';
                }
                update dnList[0];
            }
            
        }
        
    }
   */ 
    @future(callout=true)
    public static void createARInOracle(String dnId){
        System.debug('dnId==' + dnId);
        
        List<ETT_Delivery_Note__c> dnList = [
            SELECT Id, Name, CreatedDate, ETT_Reference__c, ETT_Date__c, ETT_Account__c, 
            ETT_Account__r.AccountNumber, ETT_Account__r.Party_Type__c, 
            (SELECT Id, Status__c, Name, ETT_Tyre_size_Integration__c, 
             ETT_Tyre_Size__c, ETT_Quantity__c, ETT_Price__c, 
             ETT_Job_Type__c, ETT_Status__c 
             FROM Delivery_Line_Items__r  WHERE Job_type__c != 'Send Back') 
            FROM ETT_Delivery_Note__c 
            WHERE Id = :dnId AND ETT_Account__r.Party_Type__c = 'Customer'
        ];
        
        System.debug('dnList==' + dnList);
       
        if (!dnList.isEmpty()) {
            alreadyProcessed.add(dnId);
            
            ETT_ARInvoiceSchema.AMAN_INVOICE_element msg = new ETT_ARInvoiceSchema.AMAN_INVOICE_element();
            ETT_ARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt req = new ETT_ARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt();
            ETT_ARInvoiceOutput.OutputParameters_element response;
            ETT_ARInvoiceOutput.InputParameters_element inputElement = new ETT_ARInvoiceOutput.InputParameters_element();
            
            for (ETT_Delivery_Note__c objDN : dnList) {
                ETT_ARInvoiceSchema.INV_HEADER_element dataH = new ETT_ARInvoiceSchema.INV_HEADER_element();
                List<ETT_ARInvoiceSchema.INV_LINES_element> datalineList = new List<ETT_ARInvoiceSchema.INV_LINES_element>();
                
                dataH.BatchSource = 'Tyre';
                dataH.TransactionNumber = objDN.Name;
                dataH.TransactionDate = objDN.ETT_Date__c == null ? System.now().date() : objDN.ETT_Date__c.date();
                dataH.TransactionCurrency = 'AED';
                dataH.CustTrxType = 'TYRE';
                dataH.BillToCustomerNumber = objDN.ETT_Account__r.AccountNumber;
                dataH.Comments = objDN.ETT_Reference__c;
                
                // Group and summarize the delivery line items by tyre sizes
                Map<String, ETT_ARInvoiceSchema.INV_LINES_element> tyreSizeSummaryMap = new Map<String, ETT_ARInvoiceSchema.INV_LINES_element>();
                
                for (ETT_Delivery_Line_Item__c objDLI : objDN.Delivery_Line_Items__r) {
                    String tyreSize = objDLI.ETT_Tyre_size_Integration__c;
                    String statusOfArInvoice = 'SALES'; 
                    Decimal price = objDLI.ETT_Price__c != null ? objDLI.ETT_Price__c : 0;
                    System.debug('Selected Item Line' +objDLI);
                    if (!tyreSizeSummaryMap.containsKey(tyreSize)) {
                        ETT_ARInvoiceSchema.INV_LINES_element line = new ETT_ARInvoiceSchema.INV_LINES_element();
                        line.line_number = tyreSizeSummaryMap.size() + 1;
                        line.line_type = 'RET_SVC';
                        line.Description = tyreSize + '-' + objDLI.ETT_Job_Type__c + '-' + statusOfArInvoice;
                        line.Quantity = 0;
                        line.Rate = price;
                        line.Amount = 0;
                        line.Tax_Code = 'VAT AR RECOVER STD@5%';
                        line.Tax_Rate = 5;
                        line.Tax_Amount = 0;
                        line.Activity_Center = '213002';
                        line.Location = '311004';
                        line.Department = '94001';
                        line.Project = '000000';
                        
                        tyreSizeSummaryMap.put(tyreSize, line);
                    }
                    
                    ETT_ARInvoiceSchema.INV_LINES_element summaryLine = tyreSizeSummaryMap.get(tyreSize);
                    summaryLine.Quantity += objDLI.ETT_Quantity__c != null ? objDLI.ETT_Quantity__c : 1;
                    summaryLine.Amount += price * (objDLI.ETT_Quantity__c != null ? objDLI.ETT_Quantity__c : 1);
                    summaryLine.Tax_Amount += (5.0 / 100) * price * (objDLI.ETT_Quantity__c != null ? objDLI.ETT_Quantity__c : 1);
                }
                
                datalineList.addAll(tyreSizeSummaryMap.values());
                System.debug('datalineList ' + datalineList);
                
                
                ETT_ARInvoiceSchema.LINES_GROUP_element groupElement = new ETT_ARInvoiceSchema.LINES_GROUP_element();
                groupElement.INV_LINES = datalineList;
                
                msg.INV_HEADER = dataH;
                msg.LINES_GROUP = groupElement;
            }
            
            try {
                response = req.process(msg);
            } catch (Exception ex) {
                UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETT_DeliveryNoteTriggerHandler', 'createARInOracle', '', UTIL_Logging.DEBUG_LEVEL_WARN);
                UTIL_Logging.logException(exLog);
                System.debug('ex ' + ex.getStackTraceString());
            }
            
            if (response != null) {
                System.debug('response ' + response);
                Integer maxSize = 255;
                
                if (response.PV_OUT_STATUS == 'Y') {
                    dnList[0].Request_Status__c = 'Success';
                    dnList[0].EBS_Ref_No__c = (response.PV_OUT_EBIZ_TRX_NO != null && response.PV_OUT_EBIZ_TRX_NO.length() > maxSize) ? 
                        response.PV_OUT_EBIZ_TRX_NO.substring(0, maxSize) : 
                    response.PV_OUT_EBIZ_TRX_NO;
                    dnList[0].Error_Msg__c = '';
                } else {
                    dnList[0].Request_Status__c = 'Failed';
                    dnList[0].Error_Msg__c = (response.PV_OUT_ERROR != null && response.PV_OUT_ERROR.length() > maxSize) ? 
                        response.PV_OUT_ERROR.substring(0, maxSize) : 
                    response.PV_OUT_ERROR;
                }
                
                update dnList[0];
            }
        }

    }

    public static void updateTyreInventoryStatusApproved(List<ETT_Delivery_Note__c> newList, Map<Id,ETT_Delivery_Note__c> oldMap) {
        List<ETT_Tyre_Inventory__c> tyreInvList = new List<ETT_Tyre_Inventory__c>();
        Set<Id> collectionCardIds = new Set<Id>();
        Set<Id> insCardIds = new Set<Id>();
        
        for(ETT_Delivery_Note__c dn: [SELECT Id,ETT_Collection_Card__c,Approved_By__c,(SELECT Id,ETT_Inspection_Card__c FROM Delivery_Line_Items__r) FROM ETT_Delivery_Note__c WHERE Id In: newList]){
            
            if(dn.Approved_By__c != null && oldMap.get(dn.Id).Approved_By__c != dn.Approved_By__c){
                System.debug('dn.Delivery_Line_Items__r: '+dn.Delivery_Line_Items__r);
                for(ETT_Delivery_Line_Item__c dnl : dn.Delivery_Line_Items__r){
                    insCardIds.add(dnl.ETT_Inspection_Card__c);
                }
                collectionCardIds.add(dn.ETT_Collection_Card__c);
            }
        }
        if(!collectionCardIds.isEmpty()){
            for(ETT_Tyre_Inventory__c ti : [SELECT Id, ETT_Status_TI__c,ETT_Tyre_Inspection_Card__c FROM ETT_Tyre_Inventory__c WHERE ETT_Collection_Card__c In: collectionCardIds AND ETT_Tyre_Inspection_Card__c In:insCardIds ]){
                ti.ETT_Status_TI__c = 'Delivery Note Approved';
                ti.ETT_Status_Changed_On__c= system.now();
                tyreInvList.add(ti);
            }
        }
        if(!tyreInvList.isEmpty()){
            update tyreInvList;
        }
        
    }
    
    public static void updateTyreInventoryStatusCompleted(List<ETT_Delivery_Note__c> newList, Map<Id,ETT_Delivery_Note__c> oldMap) {
        List<ETT_Tyre_Inventory__c> tyreInvList = new List<ETT_Tyre_Inventory__c>();
        Set<Id> collectionCardIds = new Set<Id>();
        Set<Id> insCardIds = new Set<Id>();
        for(ETT_Delivery_Note__c dn: [SELECT Id,ETT_Collection_Card__c,ETT_Service_Appointment_Status__c,(SELECT Id,ETT_Inspection_Card__c FROM Delivery_Line_Items__r) FROM ETT_Delivery_Note__c WHERE Id In: newList]){
            System.debug('dn.ETT_Service_Appointment_Status__c: '+dn.ETT_Service_Appointment_Status__c);
            
            if(dn.ETT_Service_Appointment_Status__c != null && dn.ETT_Service_Appointment_Status__c == 'Completed' && oldMap.get(dn.Id).ETT_Service_Appointment_Status__c != dn.ETT_Service_Appointment_Status__c){
                for(ETT_Delivery_Line_Item__c dnl : dn.Delivery_Line_Items__r){
                    insCardIds.add(dnl.ETT_Inspection_Card__c);
                }
                collectionCardIds.add(dn.ETT_Collection_Card__c);
            }
        }
        
        
        if(!collectionCardIds.isEmpty()){
            for(ETT_Tyre_Inventory__c ti : [SELECT Id, ETT_Status_TI__c,ETT_Tyre_Inspection_Card__c FROM ETT_Tyre_Inventory__c WHERE ETT_Collection_Card__c In: collectionCardIds AND ETT_Tyre_Inspection_Card__c In:insCardIds ]){
                ti.ETT_Status_TI__c = 'Delivered';
                ti.ETT_Status_Changed_On__c= system.now();
                tyreInvList.add(ti);
            }
        }
        if(!tyreInvList.isEmpty()){
            update tyreInvList;
        }
        
    }
    
    /*public static void callThisCoverage(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }*/
    
    
    public static void isSubmittedForApproval(List<ETT_Delivery_Note__c> newList){
        
        System.debug('called 1');
        List<ETT_Tyre_Inventory__c> tyreInvList = new List<ETT_Tyre_Inventory__c>();
        Set<Id> collectionCardIds = new Set<Id>();
        Set<Id> insCardIds = new Set<Id>();
        Boolean isLocked = false;
        for(ETT_Delivery_Note__c dn: [SELECT Id,ETT_Collection_Card__c,ETT_Is_Submitted_for_Approval__c,ETT_Service_Appointment_Status__c,(SELECT Id,ETT_Inspection_Card__c FROM Delivery_Line_Items__r) FROM ETT_Delivery_Note__c WHERE Id In: newList]){
            if(dn.ETT_Is_Submitted_for_Approval__c){
                isLocked = true;
            }
            for(ETT_Delivery_Line_Item__c dnl : dn.Delivery_Line_Items__r){
                insCardIds.add(dnl.ETT_Inspection_Card__c);
            }
            collectionCardIds.add(dn.ETT_Collection_Card__c);
        }
        System.debug('called 2 '+collectionCardIds+' : isLocked: '+isLocked);
        
        if(!collectionCardIds.isEmpty() && isLocked){
            for(ETT_Tyre_Inventory__c ti : [SELECT Id, ETT_Status_TI__c,ETT_Tyre_Inspection_Card__c FROM ETT_Tyre_Inventory__c WHERE ETT_Collection_Card__c In: collectionCardIds AND ETT_Tyre_Inspection_Card__c In:insCardIds ]){
                ti.ETT_Status_TI__c = 'Delivery Note Submitted for Approval';
                ti.ETT_Status_Changed_On__c= system.now();
                tyreInvList.add(ti);
            }
        }
        System.debug('called 3 '+tyreInvList);
        if(!tyreInvList.isEmpty()){
            
            System.debug('called 4');
            update tyreInvList;
        }
        
    }
    
    
}