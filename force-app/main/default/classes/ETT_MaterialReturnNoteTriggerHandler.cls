public class ETT_MaterialReturnNoteTriggerHandler {

    public static Set<Id> alreadyProcessed = new Set<Id>();
    public static boolean firstRun = true;
    
    public static void OracleHelper(List<ETT_Material_Return_Note__c> lstNew){

    for (ETT_Material_Return_Note__c objCC : lstNew) {
        ETT_Material_Return_Note__c oldCC =(ETT_Material_Return_Note__c)Trigger.oldMap.get(objCC.ID);
        
        if(objCC.Status__c == 'Approved' && objCC.Status__c != oldCC.Status__c){
            System.debug('createMRInOracle');
            createMRInOracle(objCC.Id,objCC.CreatedDate,objCC.Name);
        }
    }

}

   @future(callout=true)
    public static void createMRInOracle(String ccId,DateTime CustmDate,String ccName){
        System.debug('ccId >>> '+ccId+' CustmDate >>> '+CustmDate+' ccName >>> '+ccName);
        Map<String,list<ETT_MiscReceipt.Serialnumber_lines_element>> icVsSerLines = new Map<String,list<ETT_MiscReceipt.Serialnumber_lines_element>>();
        Set<String> tsmNames = New Set<String>();
        Map<String,TyreInventoryPriceSettings__c> tsmVsTips = new Map<String,TyreInventoryPriceSettings__c>();
       
        System.debug('icVsSerLines >>> '+icVsSerLines);
        System.debug('tsmNames >>> '+tsmNames);
        System.debug('tsmVsTips >>> '+tsmVsTips);
        ETT_MiscReceipt.MessageXml msg = new ETT_MiscReceipt.MessageXml();
        ETT_MiscReceipt_Service.SyncCreateMiscellaneousReceiptsServiceBPEL_pt req = new ETT_MiscReceipt_Service.SyncCreateMiscellaneousReceiptsServiceBPEL_pt();
        ETT_MiscReceipt_Output.OutputParameters_element response = new ETT_MiscReceipt_Output.OutputParameters_element();
        ETT_MiscReceipt.Data_Header_type dataH = new ETT_MiscReceipt.Data_Header_type();
        list<ETT_MiscReceipt.Data_Lines_type> datalineList = new list<ETT_MiscReceipt.Data_Lines_type>();
        dataH.TransactionType = 'REC_USED_TYRE_FRM_BRANCHES';
        dataH.TransactionDate = CustmDate == null ? system.now().date() : CustmDate.date();
        dataH.DocumentNumber = ccName;
        Integer loopCount = 0;
            for(Material_Return_Lines__c mLine : [select Id, Material_Return_Note__c, GIN_No__c, Item_Code__c, Return_Qty__c, Process_Name__c, Item_Description__c, UOM__c, Value__c, Issued_Quantity__c, Average_Rate__c from Material_Return_Lines__c where Material_Return_Note__c=:ccId]){
                loopCount++;
                ETT_MiscReceipt.Data_Lines_type line = new ETT_MiscReceipt.Data_Lines_type();                
                line.LineNumber = String.ValueOf(loopCount);
                line.ItemCode = mLine.Item_Code__c;
                line.OrgId = '426';
                line.Subinventory = 'AUH-TF-MS';
                line.Locator = 'AUH-TF-MS.Used Tyres.0';
                line.Quantity = string.valueof(mLine.Return_Qty__c);
				line.UnitCost =string.valueof( mLine.Average_Rate__c);
				line.SerialControlFlag = 'Y';
                datalineList.add(line);
            }
        system.debug('datalineList >>> '+datalineList);
        msg.Data_Header = dataH;
        msg.Data_Lines_type = datalineList;
        try{        
            system.debug('datalineList >>> '+msg);

            response = req.process(msg);
        }catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETT_CollectionCardTriggerHandler', 'createMRInOracle', 'ETT_CollectionCardTrg', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
            //throw new AuraHandledException(ex.getMessage()); 
        }
        system.debug('response >>> '+response);
        if(response != null){
            Integer maxSize = 255;
            ETT_Material_Return_Note__c cc = New ETT_Material_Return_Note__c(); 
            cc.Id = ccId;
            if(response.PV_OUT_STATUS == 'Y'){
                cc.MRI_Request_Status__c = 'Success';
                if(response.PV_OUT_EBS_REF_NO != null && response.PV_OUT_EBS_REF_NO.length() > maxSize )
                    cc.MRI_EBS_Ref_No__c = response.PV_OUT_EBS_REF_NO.substring(0, maxSize); 
                else
                    cc.MRI_EBS_Ref_No__c = response.PV_OUT_EBS_REF_NO;
                cc.MRI_Error_Msg__c = '';
            }else{
                cc.MRI_Request_Status__c = 'Failed';
                cc.MRI_EBS_Ref_No__c = '';
                if(response.PV_OUT_ERRORMESSAGE != null && response.PV_OUT_ERRORMESSAGE.length() > maxSize )
                    cc.MRI_Error_Msg__c = response.PV_OUT_ERRORMESSAGE.substring(0, maxSize);
                else
                    cc.MRI_Error_Msg__c = response.PV_OUT_ERRORMESSAGE;
            }
            update cc;
        }
    }
    
    
}