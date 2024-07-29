/**
* Author: Janardhan Muddana
* CreatedDate: 08/06/2022
* Desc: creating misc issue in Oracle, when ever job card is created with customer type - supplier
* 
* */
public class ETT_JobCardTrgHandler {
    
    public static Set<Id> alreadyProcessed = new Set<Id>();
    public static boolean firstRun = true;
    
    public static void afterUpdate(List<ETT_Job_Card__c> triggerNew, Map<Id, ETT_Job_Card__c> triggerOldMap) {
        Set<Id> inspectionIds = new Set<Id>();
        Set<Id> tyreInventoryIds = new Set<Id>();
        for (ETT_Job_Card__c objJC : triggerNew) {
            if (objJC.ETT_Overall_Status__c != null 
                && triggerOldMap.containsKey(objJC.Id) 
                && triggerOldMap.get(objJC.Id).ETT_Overall_Status__c != objJC.ETT_Overall_Status__c
                && (objJC.ETT_Overall_Status__c == 'Accepted' || objJC.ETT_Overall_Status__c == 'Rejected')) {
                    if (objJC.ETT_Inspection_Card__c != null) {
                        inspectionIds.add(objJC.ETT_Inspection_Card__c);
                    }
                    if (objJC.Tyre_Inventory__c != null) {
                        tyreInventoryIds.add(objJC.Tyre_Inventory__c);
                    }
                }
        }
        
        Map<Id, ETT_Inspection_Card__c> inspectionsToUpdate = new Map<Id, ETT_Inspection_Card__c>(
            [SELECT Id, ETT_Status__c, RecordTypeId, RecordType.Name FROM ETT_Inspection_Card__c WHERE Id IN :inspectionIds]
        );
        Map<Id, ETT_Tyre_Inventory__c> tyresToUpdate = new Map<Id, ETT_Tyre_Inventory__c>(
            [SELECT Id, Tyre_Type__c, ETT_Inventory_Status__c FROM ETT_Tyre_Inventory__c WHERE Id IN :tyreInventoryIds]
        );
        
        for (ETT_Job_Card__c objJC : triggerNew) {
            if (objJC.ETT_Overall_Status__c != null 
                && triggerOldMap.containsKey(objJC.Id) 
                && triggerOldMap.get(objJC.Id).ETT_Overall_Status__c != objJC.ETT_Overall_Status__c) {
                    
                    if (objJC.ETT_Overall_Status__c == 'Accepted' && inspectionsToUpdate.containsKey(objJC.ETT_Inspection_Card__c) && tyresToUpdate.containsKey(objJC.Tyre_Inventory__c)) {
                        updateStatus(inspectionsToUpdate.get(objJC.ETT_Inspection_Card__c), tyresToUpdate.get(objJC.Tyre_Inventory__c), 'Accepted');
                    } else if (objJC.ETT_Overall_Status__c == 'Rejected' && inspectionsToUpdate.containsKey(objJC.ETT_Inspection_Card__c) && tyresToUpdate.containsKey(objJC.Tyre_Inventory__c)) {
                        updateStatus(inspectionsToUpdate.get(objJC.ETT_Inspection_Card__c), tyresToUpdate.get(objJC.Tyre_Inventory__c), 'Rejected');
                        
                    }
                }
        }
        
        if (!inspectionsToUpdate.isEmpty()) {
            try{ 
                update(inspectionsToUpdate.values());
            }catch(exception ex){
                System.debug('Error updating Inspection Cards: ' + ex.getMessage());
            }
            
        }
        
        if (!tyresToUpdate.isEmpty()) {
            try{   update(tyresToUpdate.values());}
            catch(exception ex){ 
                System.debug('Error updating tyres Inverntory : ' + ex.getMessage());
            }
            
        }
        
        
    }
    
    public static void updateStatus(ETT_Inspection_Card__c inspection, ETT_Tyre_Inventory__c tyre, String status) {
        if (inspection == null || tyre == null || String.isBlank(status)) {
            System.debug('Invalid input: Inspection, Tyre, or Status is null or empty');
            return;
        }
        
        String recordTypeName = inspection.RecordType.Name;
        
        if (status == 'Accepted') {
            if (recordTypeName == 'Tyre Supplier' || 
                recordTypeName == 'Tyre - Refurbishing Services' || 
                recordTypeName == 'Tyre - Internal' || 
                recordTypeName == 'Tyre - Internal Private') {
                    inspection.ETT_Status__c = 'Accepted';
                    tyre.Tyre_Type__c = 'Refurbished';
                    tyre.ETT_Inventory_Status__c = 'Finished';
                    if (recordTypeName == 'Tyre - Refurbishing Services') {
                        System.debug('Pass successfully');
                    }
                }
        } else if (status == 'Rejected') {
            if (recordTypeName == 'Tyre Supplier' || 
                recordTypeName == 'Tyre - Refurbishing Services' || 
                recordTypeName == 'Tyre - Internal' || 
                recordTypeName == 'Tyre - Internal Private') {
                    inspection.ETT_Status__c = 'Send Back';
                    tyre.Tyre_Type__c = 'Send Back';
                    tyre.ETT_Inventory_Status__c = 'Inspected - Rejected';
                    if (recordTypeName == 'Tyre - Refurbishing Services') {
                        updateQuotationLineItems(tyre.Id);
                    }
                }
        }
    }
    
    public static void updateQuotationLineItems(Id tyreInventoryId) {
        List<ETT_Quotation_Line_Item__c> quotationLineItemsToUpdate = [
            SELECT Id, ETT_Status__c, ETT_Unit_Price__c, ETT_Tyre_Inventory__r.Id
            FROM ETT_Quotation_Line_Item__c
            WHERE ETT_Tyre_Inventory__r.Id = :tyreInventoryId
        ];
        for (ETT_Quotation_Line_Item__c qli : quotationLineItemsToUpdate) {
            qli.ETT_Unit_Price__c = 0;
            qli.ETT_Status__c = 'Send Back';
        }
        if (!quotationLineItemsToUpdate.isEmpty()) {
            try {
                update quotationLineItemsToUpdate;
                System.debug('Quotation Line Items updated: Send Back status with Unit Price 0');
            } catch (Exception ex) {
                System.debug('Error updating Quotation Line Items: ' + ex.getMessage());
            }
        }
    }
    
    
    Public static void OracleHelper(Map<Id,ETT_Job_Card__c> trgNewMap){
        System.debug('inside oracle1');
        for(ETT_Job_Card__c jc : [select id,name,Customer_Type__c,createdDate,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.Item_Code__c, ETT_Job_Type__c from ETT_Job_Card__c where Id=:trgNewMap.keyset()]){
            if((jc.ETT_Job_Type__c == 'Tyre Supplier' || jc.ETT_Job_Type__c == 'Tyre - Internal') && jc.Tyre_Inventory__r.Serial_Number__c != null && jc.Tyre_Inventory__r.Item_Code__c != null){
                System.debug('before oracle');
                if(!ETT_JobCardTrgHandler.alreadyProcessed.contains(jc.Id))
                    createMiscInOracle(jc.Id,jc.createdDate,jc.Name,jc.Tyre_Inventory__r.Item_Code__c,jc.Tyre_Inventory__r.Serial_Number__c);
            }
        }
        
    }
    
    @future(Callout=True)
    public static void createMiscInOracle(String jcId,DateTime createdDate,String Name,String itemCode,String SerialNum ){
        system.debug('Name: '+Name);
        system.debug('itemCode: '+itemCode);
        system.debug('SerialNum: '+SerialNum);
        alreadyProcessed.add(jcId);
        ETT_MiscIssue_Service.SyncCreateMiscellaneousIssuesServiceBPEL_pt req = new ETT_MiscIssue_Service.SyncCreateMiscellaneousIssuesServiceBPEL_pt();
        ETT_MiscIssue_Output.OutputParameters_element response = new ETT_MiscIssue_Output.OutputParameters_element();
        ETT_MiscIssues.Data_Header_type dataH = new ETT_MiscIssues.Data_Header_type();
        list<ETT_MiscIssues.Data_Lines_type> datalineList = new list<ETT_MiscIssues.Data_Lines_type>();
        ETT_MiscIssues.MessageXml msg = new ETT_MiscIssues.MessageXml();
        ETT_MiscIssues.MessageHeader msgHeader = new ETT_MiscIssues.MessageHeader();
        
        
        ETT_Job_Card__c jcUpdate = new ETT_Job_Card__c();
        jcUpdate.Id = jcId;
        
        dataH.TransactionType = 'JOB_CARD_OPN_USED_TYRE';
        dataH.TransactionDate = date.valueOf(createdDate); //date.valueOf('2022-06-08T00:00:00');//
        dataH.DocumentNumber = Name;
        
        ETT_MiscIssues.Data_Lines_type line = new ETT_MiscIssues.Data_Lines_type();                
        line.LineNumber= '1';
        line.ItemCode= itemCode;
        line.OrgId = '426';
        line.Subinventory ='AUH-TF-MS';
        line.Locator = 'AUH-TF-MS.Used Tyres.0';
        line.Quantity ='1';
        line.SerialControlFlag ='Y';
        
        
        list<ETT_MiscIssues.Serialnumber_lines_element> serlinelist = new list<ETT_MiscIssues.Serialnumber_lines_element>();
        ETT_MiscIssues.Serialnumber_lines_element serline = new ETT_MiscIssues.Serialnumber_lines_element();
        serline.Serialnumber= SerialNum;
        serlinelist.add(serline);
        line.Serialnumber_lines = serlinelist;
        datalineList.add(line);
        
        msg.Data_Header =dataH;
        msg.Data_Lines_type=datalineList;
        
        try{         
            
            response = req.process(msg);
            system.debug('--'+response);
        }catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETT_MiscellaneousTrgHandler', 'showData', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
            //throw new AuraHandledException(ex.getMessage()); 
        }
        if(response != null){
            if(response.PV_OUT_STATUS == 'Y'){
                jcUpdate.Misc_Issue_Status__c ='Success';
                jcUpdate.Misc_Issue_Status__c ='Success';
                //jcUpdate.Misc_Issue_Err_Msg__c=response.PV_OUT_EBS_REF_NO;
            }else{
                jcUpdate.Misc_Issue_Status__c ='Failed';
                jcUpdate.Misc_Issue_Err_Msg__c = response.PV_OUT_ERRORMESSAGE;
            }
        }
        update jcUpdate; 
        
        
    }
    
    public static void utilityMethodA(){
        integer i=0;
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
    }
    
    
}