@isTest
public class ETT_customJobCardClsSubmitCtrlTest {
    
    public static testmethod void sendreq(){
        
        ETT_Job_Card__c jb = new ETT_Job_Card__c();
        jb.Job_Card_Status__c ='In Progress';
        insert jb;
        
        ETT_Job_Card_Close__c jc = new ETT_Job_Card_Close__c();
        jc.Status__c = 'New';
        jc.Job_Card__c=jb.Id;
        
        insert jc;
        ETT_customJobCardClsSubmitCtrl.getAllCloseLines(jc.Id);
        ETT_customJobCardClsSubmitCtrl.submitToApprovalPrcs('Test',jc.Id);
        
    }
}