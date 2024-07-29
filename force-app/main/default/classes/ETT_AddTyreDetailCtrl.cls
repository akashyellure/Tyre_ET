/*Author: Janardhan
* Desc:Created this add tyres in Opportunity level, it is cloned and edit from exisiting ETT_LeadFormController
* created Date:17/11/2021
* Test Class: ETT_AddTyreDetailCtrlTest
* 
* */
public class ETT_AddTyreDetailCtrl {
    
    
    @AuraEnabled
    public static Map<String, String> getselectOptions(sObject objObject, string fld) {
        
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
            options.put(a.getValue(), a.getLabel());
        }
        
        allOpts.sort();
        System.debug(options);
        return options;
    }
    
    @auraEnabled
    public static void createStagingQuotation(Id recordId,list<ETT_Staging_Quotation_Request__c> staginQuoteList,list<ETT_Tyre_Master__c> tyreNewList){
        
        Savepoint sp = Database.setSavepoint();
       Opportunity opp = [select id,recordType.Name from Opportunity where Id=:recordId];
       
        if(opp.recordType.Name == 'Tyre Refurbishing Services'){
            opp.StageName = 'Sales Decision Pending';
        }else{
            opp.StageName = 'HOO Decision Pending';
        }
        
        try{
            if(staginQuoteList!= null && staginQuoteList.size()>0){
                insert staginQuoteList;
            }
               //Send For Approval process                
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Receptionist request');
                req1.setObjectId(recordId);
                // Submit the approval request for the Opportunity
                update opp;
                Approval.ProcessResult result = Approval.process(req1);
			    system.debug('--Enter Approval2--'+result);
                
            
            if(tyreNewList!= null && tyreNewList.size()>0){                
                
                for(ETT_Tyre_Master__c newTyre : tyreNewList){
                    newTyre.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Draft').getRecordTypeId();
                }
                insert tyreNewList;
            }
        }catch(Exception e) {
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());    
        }
    }
    
    
}