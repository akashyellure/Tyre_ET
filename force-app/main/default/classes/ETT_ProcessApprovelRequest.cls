public class ETT_ProcessApprovelRequest {
/*  
    public static void submitForApproval(ETT_Collection_Card__c objCollectionCard){        
        // Create an approval request for  Collection Card        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
        req.setComments('Collection Team collectcted the Collection Details');        
        req.setObjectId(objCollectionCard.id);
        // Submit the approval request for the Collection Card         
        Approval.ProcessResult result = Approval.process(req);        
    }     
*/    
    public static void submitForApproval(ETT_Purchase_Order__c objPurchaseOrder){        
        // Create an approval request for  Collection Card        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
        req.setComments('This is for Purchase Order Confirmation request');        
        req.setObjectId(objPurchaseOrder.id);
        // Submit the approval request for the Collection Card         
        Approval.ProcessResult result = Approval.process(req);        
    }   
    /**
    *Get ProcessInstanceWorkItemId using SOQL
    **/
    public static Id getWorkItemId(Id targetObjectId){
        Id workItemId = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            workItemId  =  workItem.Id;
        }
        return workItemId;
    }
    
    //This is for Purchase Order Confirmation request

    /**
    * This method will Approve the opportunity
    **/
    public static void approveRecord(ETT_Purchase_Order__c objPurchaseOrder){
        system.debug('****Invoke ******');
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request using Purchase Order Details');
        req.setAction('Approve');        
        Id workItemId = getWorkItemId(objPurchaseOrder.id); 
        if(workItemId == null){
            //opp.addError('Error Occured in CollectionDetails');
        }
        else{
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
/*
    public static void approveRecord(ETT_Collection_Card__c objCollectionCard){
        system.debug('****Invoke ******');
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request using Collection Details');
        req.setAction('Approve');        
        Id workItemId = getWorkItemId(objCollectionCard.id); 
        if(workItemId == null){
            //opp.addError('Error Occured in CollectionDetails');
        }
        else{
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }*/

    /**
    * This method will Reject the opportunity
    **/
    /*public static void rejectRecord(ETT_Collection_Card__c objCollectionCard){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejected request using HOO/FM');
        req.setAction('Reject');
        Id workItemId = getWorkItemId(objCollectionCard.id);
        if(workItemId == null){
            //opp.addError('Error Occured in Collection Details');
        }
        else{
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
*/
}