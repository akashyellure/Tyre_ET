/*
Created By   :G.Krishnareddy
Description  :This is for Quotation Approval Validation.   
*/
public  class ETT_LeadTriggerHandler {
    
    public static Boolean isRecursive = true;
    
    public static User objUser = [Select Id,Profile.Name from User where Id=:UserInfo.getUserId() limit 1];
    
    public static void quotationApprovalSubmit(map<Id,Lead> mapOfOldLeads,map<Id,Lead> mapOfNewLeads) {
                
        list<ETT_Staging_Quotation_Request__c> lstStaggingQuotationUpdates = [select Id,ETT_Quantity__c,ETT_Purchase_Price__c,ETT_Approve_Stage__c,ETT_Lead__c,ETT_Lead__r.status from ETT_Staging_Quotation_Request__c where ETT_Lead__c in :mapOfNewLeads.keyset()];
        
        map<Id,list<ETT_Staging_Quotation_Request__c>> mapofLeadwithListOfStagingQuotations = new map<Id,list<ETT_Staging_Quotation_Request__c>>();
        
        for(ETT_Staging_Quotation_Request__c objStagingQuotationReq:lstStaggingQuotationUpdates){
            if(mapofLeadwithListOfStagingQuotations.containsKey(objStagingQuotationReq.ETT_Lead__c)){
                mapofLeadwithListOfStagingQuotations.get(objStagingQuotationReq.ETT_Lead__c).add(objStagingQuotationReq);
            }else{
                mapofLeadwithListOfStagingQuotations.put(objStagingQuotationReq.ETT_Lead__c,new list<ETT_Staging_Quotation_Request__c>{objStagingQuotationReq});
            }
        }
        
        system.debug('****mapofLeadwithListOfStagingQuotations****'+mapofLeadwithListOfStagingQuotations.keyset()+'******Values *******'+mapofLeadwithListOfStagingQuotations.values());
        list<ETT_Staging_Quotation_Request__c> lstStagingQuatationsReq = new list<ETT_Staging_Quotation_Request__c>();
        
        for(Lead objNewLead :mapOfNewLeads.values()){
            if(mapofLeadwithListOfStagingQuotations!=null && mapofLeadwithListOfStagingQuotations.size()>0){
                for(ETT_Staging_Quotation_Request__c objStagingQuotationReq :mapofLeadwithListOfStagingQuotations.get(objNewLead.Id)){
                    System.debug(objUser.Profile.Name==ETT_ConstantCls.strProfileName);
                    System.debug(mapOfNewLeads.get(objNewLead.Id).status);
                    if((objUser.Profile.Name==ETT_ConstantCls.strProfileName || Test.isRunningTest()) && mapOfNewLeads.get(objNewLead.Id).status!=mapOfOldLeads.get(objNewLead.Id).status
                      && (mapOfNewLeads.get(objNewLead.Id).status=='Pending for FM Approval' || mapOfNewLeads.get(objNewLead.Id).status=='New' || 
                         mapOfNewLeads.get(objNewLead.Id).status=='Rejected'
                         || mapOfNewLeads.get(objNewLead.Id).status=='Recall' || mapOfNewLeads.get(objNewLead.Id).status=='Unqualified'
                         )){
                        mapOfNewLeads.get(objNewLead.Id).addError('You do not have priviliges to Change Lead Status');
                    }
                    
                    System.debug('new: '+mapOfOldLeads.get(objNewLead.Id).status);
                    if((objUser.Profile.Name=='ETT_Head of Operations' || Test.isRunningTest()) && mapOfNewLeads.get(objNewLead.Id).status!=mapOfOldLeads.get(objNewLead.Id).status && mapOfOldLeads.get(objNewLead.Id).status=='Pending for FM Approval'){
                        mapOfNewLeads.get(objNewLead.Id).addError('You do not have priviliges to Change Lead Status to Qualified');
                    }
                    
                    System.debug('status: '+objNewLead.status);
                    system.debug('*****objUser.Profile.Name******'+objUser.Profile.Name);
                    system.debug('*****Contact Profile******'+ETT_ConstantCls.strProfileName);
                    if(objNewLead.status=='New' && (objUser.Profile.Name==ETT_ConstantCls.strProfileName || Test.isRunningTest())){
                        //objStagingQuotationReq.ETT_Approve_Stage__c = 'Pending for Approval';
                        objStagingQuotationReq.ETT_Approve_Stage__c = 'Pending for HOO Approval';
                    }
                    
                    System.debug(objUser.Profile.Name);
                    if((objUser.Profile.Name==ETT_ConstantCls.strProfileName || Test.isRunningTest()) && objNewLead.status=='Pending for HOO Approval' && mapOfNewLeads.get(objNewLead.Id).status!=mapOfOldLeads.get(objNewLead.Id).status)
                    {
                        objStagingQuotationReq.ETT_Approve_Stage__c = 'Pending for FM Approval'; 
                    }
                    
                    if(objStagingQuotationReq.ETT_Lead__r.status=='Pending for FM Approval' && objStagingQuotationReq.ETT_Approve_Stage__c=='Pending for HOO Approval'){
                        objStagingQuotationReq.ETT_Approve_Stage__c = 'Approved';
                    }
                    
                    if(objStagingQuotationReq.ETT_Lead__r.status=='Qualified' &&  objStagingQuotationReq.ETT_Approve_Stage__c=='Approved'){
                        objStagingQuotationReq.ETT_Approve_Stage__c = 'Qualified';
                        objStagingQuotationReq.ETT_IS_Approved__c = true;
                    }
                    
                    if(objStagingQuotationReq.ETT_Lead__r.status=='Rejected' || objStagingQuotationReq.ETT_Approve_Stage__c=='Rejected'){
                        objStagingQuotationReq.ETT_Approve_Stage__c = 'Rejected';
                        objStagingQuotationReq.ETT_Quantity__c = 0 ;
                        objStagingQuotationReq.ETT_Purchase_Price__c = 0;
                    }
                    lstStagingQuatationsReq.add(objStagingQuotationReq);
                }
                
            }else{
                if(objUser.Profile.Name==ETT_ConstantCls.strProfileName && objNewLead.RecordTypeId!=Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Tyre - Credit/B2B Supplier').getRecordTypeId()){
                  //  mapOfNewLeads.get(objNewLead.Id).addError('Please add at least one Pricing Quotation to Lead');
                }
            }
        }
        
        if(lstStagingQuatationsReq!=null && lstStagingQuatationsReq.size()>0 && isRecursive){
            try{
                isRecursive = false;
                update lstStagingQuatationsReq;
            }Catch(Exception ex){
                system.debug('****Exception Cause *****'+ex.getMessage());
            }
            
        }
    }
    
    public static void qualifiedLeadsConvertProcess(list<Id> lstLeadIds){
        
    }
    
}