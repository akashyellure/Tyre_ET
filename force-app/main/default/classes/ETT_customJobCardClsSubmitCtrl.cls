/*Author: Janardhan
 *Created Date:15/11/2021
 *Desc: To add validation before submit approval process(custom)
 *TestClass: ETT_customJobCardClsSubmitCtrlTest
 * */
public class ETT_customJobCardClsSubmitCtrl {
    
    @AuraEnabled
    Public static list<ETT_Job_Card_Close_Lines__c> getAllCloseLines(string JobCardCloseId){
        
        return [Select id,Item_Name__c,Item_Name__r.ETT_Allocated_Units__c,Issued_Quantity__c from ETT_Job_Card_Close_Lines__c where Job_Card_Close__c=:JobCardCloseId];
    }
    
    @AuraEnabled
    public static void submitToApprovalPrcs(string comments,string recordId){
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
        req.setComments(comments);        
        req.setObjectId(recordId);
        
        try { 
            Approval.ProcessResult result = Approval.process(req); 
        }catch(Exception e) {
            
            throw new AuraHandledException(e.getMessage());    
        }
        
    }
    
}