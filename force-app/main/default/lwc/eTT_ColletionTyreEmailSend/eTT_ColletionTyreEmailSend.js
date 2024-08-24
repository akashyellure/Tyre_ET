import { LightningElement, api } from 'lwc';
import sendEmail from '@salesforce/apex/ETT_Check_Out_Tyre_Detials.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ETT_ColletionTyreEmailSend extends LightningElement {

    @api recordId;
    recipientEmail = '';
    ccEmails = '';

    handleRecipientEmailChange(event) {
        this.recipientEmail = event.target.value;
       
    }
    handleCcEmailsChange(event) {

        this.ccEmails = event.target.value;
      
    }
    validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    handleSendEmail() {
        
        if (!this.validateEmail(this.recipientEmail)) {
           
            this.showToast('Error', 'Please enter a valid recipient email.','error');
            return;
        }

        if (this.ccEmails) {
            const ccEmailsArray = this.ccEmails.split(',');
            for (let email of ccEmailsArray) {
                if (!this.validateEmail(email.trim())) {
                    this.showToast('Error', 'Please enter valid CC emails.','error');
                  
                    return;
                }
            }
        }

        sendEmail({ recipientEmail: this.recipientEmail, ccEmails: this.ccEmails, recordId: this.recordId })
        
            .then(() => {
                
                // Handle success  
                this.showToast('Success', 'Email sent successfully', 'success');
                console.log('Email sent successfully');
            })
            .catch(error => {
                // Handle error
                this.showToast('Error', 'Error sending email: ' + error.body.message, 'error');
                console.error('Error sending email', error);
            });
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

}