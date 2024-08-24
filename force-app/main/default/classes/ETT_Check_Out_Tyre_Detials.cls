public class ETT_Check_Out_Tyre_Detials {
    
    public Id recordId {get;set;}
    public Date Today { get { return Date.today(); }}
    public Account accountInfo {get;set;}
    public ETT_Collection_Card__c collectionCard  {get;set;}
    public List<Map<String, Object>> tyreInventoryGrouped{get;set;}
    public List<ETT_Tyre_Inventory__c> tyreInventoryDetails {get;set;}
    public Integer totalTyreCount {get;set;}
    
    public ETT_Check_Out_Tyre_Detials(ApexPages.StandardController controller){
        recordId = controller.getRecord().Id; 
        
        // Fetch collection card details along with associated Account
        collectionCard = [
            SELECT 
            Id, 
            Name, 
            ETT_SubInventory_Code__c,
            ETT_Check_In__c,
            ETT_Check_Out__c,
            ETT_Collection_Date__c,
            ETT_Accounts__c ,
            ETT_Store_Name__r.Name,
            ETT_Store_Name__r.ETT_Operating_Unit_Name__c,
            ETT_Store_Name__r.ETT_Operating_Unit_Id__c,
            ETT_Store_Name__r.Party_Type1__c,
            MO_EBS_Ref_No__c,
            CreatedDate,
            Collection_Appointment__r.Location__c
            FROM ETT_Collection_Card__c 
            WHERE Id = :recordId
        ];
        
        // Fetch account information using the Account ID from the collection card
        if (collectionCard.ETT_Accounts__c != null) {
            try {
                accountInfo = [
                    SELECT Id, Name
                    FROM Account 
                    WHERE Id = :collectionCard.ETT_Accounts__c LIMIT 1
                ]; 
            } catch (Exception e) {
                system.debug('No Account found for the given Account ID: ' + e.getMessage());
            }
        }
        
        // Initialize the grouped list
        tyreInventoryGrouped = new List<Map<String, Object>>();
        Map<String, Map<String, Integer>> sizeJobMap = new Map<String, Map<String, Integer>>();
        
        // Fetch and group the tyre inventory by size and job type
        List<AggregateResult> groupedResults = [
            SELECT 
            ETT_Tyre_Size_Master__r.Name tyreSize, 
            Job_Type__c,
            COUNT(Id) tyreCount
            FROM 
            ETT_Tyre_Inventory__c 
            WHERE 
            ETT_Collection_Card__c = :collectionCard.Id
            GROUP BY 
            ETT_Tyre_Size_Master__r.Name, 
            Job_Type__c
        ];
        
        // Process grouped results
        for (AggregateResult ar : groupedResults) {
            String tyreSize = (String)ar.get('tyreSize');
            String jobType = (String)ar.get('Job_Type__c');
            Integer count = (Integer)ar.get('tyreCount');
            
            if (!sizeJobMap.containsKey(tyreSize)) {
                sizeJobMap.put(tyreSize, new Map<String, Integer>{ 'Repair' => 0, 'Retread' => 0 });
            }
            sizeJobMap.get(tyreSize).put(jobType, count);
        }
        
        // Prepare the grouped data in a way that's easy to render in a Visualforce page
        Integer grandTotal = 0;
        for (String size : sizeJobMap.keySet()) {
            Integer repairCount = sizeJobMap.get(size).get('Repair');
            Integer retreadCount = sizeJobMap.get(size).get('Retread');
            Integer totalCount = repairCount + retreadCount;
            grandTotal += totalCount;
            
            Map<String, Object> row = new Map<String, Object>();
            row.put('tyreSize', size);
            row.put('Repair', repairCount);
            row.put('Retread', retreadCount);
            row.put('Total', totalCount);
            tyreInventoryGrouped.add(row);
        }
        
        totalTyreCount = grandTotal;
        
        // Fetch detailed tyre inventory records
        tyreInventoryDetails = [
            SELECT Id, ETT_Collection_Card__c, ETT_Tyre_Master__r.Name, 
            ETT_Brand__r.Name, ETT_Pattern__r.Name, ETT_Country__r.Name,ETT_Brand__r.ETT_Brand_Code__c, 
            ETT_Tyre_Size_Master__r.Name, Job_Type__c, Tyre_Type__c,Serial_Number__c
            FROM ETT_Tyre_Inventory__c 
            WHERE ETT_Collection_Card__c = :collectionCard.Id
        ];
    }
    
    @AuraEnabled
    public static void sendEmail(String recipientEmail, String ccEmails, Id recordId) {
    
        try {
            // Debugging statements
            System.debug('Recipient email: ' + recipientEmail);
            System.debug('CC email: ' + ccEmails);
            System.debug('Record ID: ' + recordId);
    
            // Fetch Org-Wide Email Address
            OrgWideEmailAddress[] owea = [
                SELECT Id, Address 
                FROM OrgWideEmailAddress 
                WHERE DisplayName = :System.Label.CICO_OrgWideEmail 
                LIMIT 1
            ];
    
            // Ensure Org-Wide Email Address is found
            if (owea.isEmpty()) {
                throw new AuraHandledException('Org-Wide Email Address not found.');
            }
    
            // Generate the PDF from the Visualforce page
            PageReference pdfPage = Page.ETT_Check_out_Tyre_Pdf;
            pdfPage.getParameters().put('id', recordId);
            Blob pdfBlob = pdfPage.getContentAsPDF();
            System.debug('Generated PDF: ' + pdfBlob);
    
            // Prepare the email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { recipientEmail });
    
            // Set CC addresses if provided
            if (ccEmails != null && ccEmails != '') {
                email.setCcAddresses(ccEmails.split(','));
            }
    
            // Set Org-Wide Email Address
            email.setOrgWideEmailAddressId(owea[0].Id);
    
            // Set email subject and HTML body
            email.setSubject('Tyre Collection Details');
            email.setHtmlBody('<p>Dear Customer,</p>' + 
                              '<p>The details of the tyres collected are attached.</p>' + 
                              '<p>Please review the attachment for complete information.</p>'+
                              '<br>'+
                              '<p>Thank you,</p>' 
                              );
    
            // Create PDF attachment
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('TyreCollection.pdf');
            attachment.setBody(pdfBlob);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
    
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    
        } catch (Exception e) {
            // Handle exceptions
            System.debug('Error sending email: ' + e.getMessage());
            throw new AuraHandledException('Failed to send email. Please try again later.');
        }
    }
    
}