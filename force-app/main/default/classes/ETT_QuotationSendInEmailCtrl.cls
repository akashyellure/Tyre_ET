public class ETT_QuotationSendInEmailCtrl {
       
    @AuraEnabled
    public static void sendEmailToCustomer(string emails,string AccId,string QuoteId,string EmailTempDevName,string QuoteName,string CCEmails){
        
       list<string> toEmails = new list<string>(emails.split(';'));
      
        list<string> ccEmailList;
        if(CCEmails != null)
        ccEmailList= new list<string>(CCEmails.split(';'));        
        //system.debug(QuoteName+'--'+emails+'-acc-'+AccId+'--qu-'+QuoteId+'--temp--'+EmailTempDevName);
        
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
        EmailTemplate template = [SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName =:EmailTempDevName];
        try {
            PageReference pdf = page.ETT_QuotationPrintPage;
            pdf.getParameters().put('Id',QuoteId);
            pdf.getParameters().put('AccId',AccId);
            pdf.setRedirect(true); 
            
            Blob pdfContent;
            Messaging.SingleEmailMessage message =  Messaging.renderStoredEmailTemplate(template.Id,null,QuoteId);
            Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
            
            pdfContent = (Test.isRunningTest()) ? Blob.valueOf('Test') : pdf.getContent();
            string fileName= 'Quotation_'+QuoteName+'.pdf';
            att.setFileName(fileName);
            att.setBody(pdfContent);                
            
            message.toAddresses = toEmails;
            if(CCEmails != null)
            message.ccaddresses = ccEmailList;
            if ( owea != null && owea.size() > 0 ) {
                message.setOrgWideEmailAddressId(owea.get(0).Id);
            }
           
          
            message.setSaveAsActivity(false);
            //message.setWhatId(QuoteId);
            message.setTargetObjectId(userinfo.getUserId());
            message.setTreatTargetObjectAsRecipient(false);
            message.setFileAttachments(new Messaging.EmailFileAttachment[] {att});
            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new list<Messaging.SingleEmailMessage>{message});
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
                
            } else {
                System.debug('The email failed to send: '
                             + results[0].errors[0].message);
                
            }
            
        }catch (VisualforceException e) {
            System.debug('exc '+e);
            throw new AuraHandledException(e.getMessage());
            
        }
        
    }
}