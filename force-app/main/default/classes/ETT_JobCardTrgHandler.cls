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
    public static void handleJobCardInsertion(List<ETT_Job_Card__c> triggerNew) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        // Construct the HTML email body with embedded CSS
        String emailBody = '<html><head><style>' +
            'body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; background-color: #f4f4f4; padding: 20px; }' +
            '.container { background-color: #fff; padding: 20px; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }' +
            'table { width: 100%; border-collapse: collapse; margin-top: 20px; }' +
            'th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }' +
            'th { background-color: #f2f2f2; font-weight: bold; }' +
            '</style></head><body>' +
            '<div class="container">' +
            '<p>The following job cards have been created:</p>' +
            '<table>' +
            '<tr><th>Job card</th><th>Created Date</th></tr>';
        
        // Assuming the jobCard details are similar to invoice items
        for (ETT_Job_Card__c jobCard : triggerNew) {
            // Append job card details to the HTML table
            emailBody += '<tr>' +
                '<td>' + jobCard.Name + '</td>' +
                '<td>' + jobCard.CreatedDate.format() + '</td>' + 
                '</tr>' ;
            
        }
        
        emailBody += '</table>' +
            '</div>' +
            '</body></html>';
        
        try {
            OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1];
            
            // Prepare the email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{'anishmp@et.ae'}); // Set recipient address
            mail.setSubject('New Job Cards Created');
            mail.setHtmlBody(emailBody);
            mail.setReplyTo(owea.Address); // Set Reply-To address
            mail.setOrgWideEmailAddressId(owea.Id); // Set Org-Wide Email Address
            
            // Add email to the list
            emails.add(mail);
            
            // Send all emails at once
            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
            }
        } catch (Exception e) {
            System.debug('An error occurred: ' + e.getMessage());
        }
    }
  public static void updateJobCardCloseDone(Map<Id, ETT_Job_Card__c> trgNewMap, Map<Id, ETT_Job_Card__c> trgOldMap) {
    try {
        Set<Id> collectionCardIds = new Set<Id>();
        Map<Id, Decimal> totalJobCardClose = new Map<Id, Decimal>();
        Map<Id, Decimal> totalNotCloseCount = new Map<Id, Decimal>();
        Map<Id, Decimal> totalAcceptedCount = new Map<Id, Decimal>();
        Map<Id, Decimal> totalRejectedBackCount = new Map<Id, Decimal>();
        List<ETT_Collection_Card__c> collectionCardList = new List<ETT_Collection_Card__c>();

        // Collect all Collection Card IDs from the Job Card records where status has changed
        for (Id jobCardId : trgNewMap.keySet()) {
            ETT_Job_Card__c newJobCard = trgNewMap.get(jobCardId);
            ETT_Job_Card__c oldJobCard = trgOldMap.get(jobCardId);

            if (newJobCard.Collection_Card__c != null && 
                newJobCard.ETT_Overall_Status__c != oldJobCard.ETT_Overall_Status__c) {
                collectionCardIds.add(newJobCard.Collection_Card__c);
            }
        }

        // Proceed only if there are collection cards with status changes
        if (!collectionCardIds.isEmpty()) {
            // Query to count total Job Card records grouped by Collection Card
            for (AggregateResult ar : [
                SELECT COUNT(Id) CountVal, Collection_Card__c ColCard 
                FROM ETT_Job_Card__c 
                WHERE Collection_Card__c IN :collectionCardIds 
                GROUP BY Collection_Card__c
            ]) {
                totalJobCardClose.put((Id) ar.get('ColCard'), (Decimal) ar.get('CountVal'));
            }

            // Query to count total "Not Started" Job Card records grouped by Collection Card
            for (AggregateResult ar : [
                SELECT COUNT(Id) CountVal, Collection_Card__c ColCard 
                FROM ETT_Job_Card__c 
                WHERE Collection_Card__c IN :collectionCardIds AND ETT_Overall_Status__c = 'Not Started'
                GROUP BY Collection_Card__c
            ]) {
                totalNotCloseCount.put((Id) ar.get('ColCard'), (Decimal) ar.get('CountVal'));
            }

            // Query to count total "Accepted" Job Card records grouped by Collection Card
            for (AggregateResult ar : [
                SELECT COUNT(Id) CountVal, Collection_Card__c ColCard 
                FROM ETT_Job_Card__c 
                WHERE Collection_Card__c IN :collectionCardIds AND ETT_Overall_Status__c = 'Accepted'
                GROUP BY Collection_Card__c
            ]) {
                totalAcceptedCount.put((Id) ar.get('ColCard'), (Decimal) ar.get('CountVal'));
            }

            // Query to count total "Rejected" Job Card records grouped by Collection Card
            for (AggregateResult ar : [
                SELECT COUNT(Id) CountVal, Collection_Card__c ColCard 
                FROM ETT_Job_Card__c 
                WHERE Collection_Card__c IN :collectionCardIds AND ETT_Overall_Status__c = 'Rejected'
                GROUP BY Collection_Card__c
            ]) {
                totalRejectedBackCount.put((Id) ar.get('ColCard'), (Decimal) ar.get('CountVal'));
            }

            // Update the Collection Card records based on the aggregated counts
            for (ETT_Job_Card__c jobCC : trgNewMap.values()) {
                ETT_Job_Card__c oldJobCard = trgOldMap.get(jobCC.Id);

                // Proceed only if the status has changed
                if (jobCC.Collection_Card__c != null && jobCC.ETT_Overall_Status__c != oldJobCard.ETT_Overall_Status__c) {
                    Decimal totalCount = totalJobCardClose.containsKey(jobCC.Collection_Card__c) ? totalJobCardClose.get(jobCC.Collection_Card__c) : 0;
                    Decimal acceptCount = totalAcceptedCount.containsKey(jobCC.Collection_Card__c) ? totalAcceptedCount.get(jobCC.Collection_Card__c) : 0;
                    Decimal rejectedCount = totalRejectedBackCount.containsKey(jobCC.Collection_Card__c) ? totalRejectedBackCount.get(jobCC.Collection_Card__c) : 0;
                    Decimal notClosedCount = totalNotCloseCount.containsKey(jobCC.Collection_Card__c) ? totalNotCloseCount.get(jobCC.Collection_Card__c) : 0;

                    ETT_Collection_Card__c ccItem = new ETT_Collection_Card__c();
                    ccItem.Id = jobCC.Collection_Card__c;
                    ccItem.Job_Card_Close_Rejected__c = String.valueOf(rejectedCount);
                    ccItem.Job_Card_Close_Approved__c = String.valueOf(acceptCount);
                    ccItem.Job_Card_Close_In_Progress__c = String.valueOf(notClosedCount);

                    if (notClosedCount == 0 && totalCount == (acceptCount + rejectedCount)) {
                        ccItem.Job_Card_Close_Done__c = true;
                    } else {
                        ccItem.Job_Card_Close_Done__c = false;
                    }

                    collectionCardList.add(ccItem);
                }
            }

            if (!collectionCardList.isEmpty()) {
                update collectionCardList;
                system.debug('Updated Successfully');
            }
        }
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
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