/*
   Created By  :G.Krishnareddy
   Create Date :2/3/2020
   Description :
*/
trigger ETT_LeadQuotationReqTrigger on Lead (Before insert,After Update) {
    
    List<ETT_ORG_Setting__mdt> ettOrgSettingLst = [SELECT MasterLabel,DeveloperName FROM ETT_ORG_Setting__mdt where MasterLabel=:UserInfo.getProfileId()];


    if(ettOrgSettingLst!=null && ettOrgSettingLst.size()>0){
        for(Lead objLead: Trigger.new)
        {

            if(trigger.isBefore && trigger.isInsert){
 
                Id LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre Cash Individual').getRecordTypeId();
                Id RebuServiceRecType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ETT_Tyre_Refurbishing_Services').getRecordTypeId();
                Id SuppRecType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Tyre_Supplier').getRecordTypeId();
                
                if(objLead.RecordTypeId == LeadRecordTypeId){
                  
                    objLead.Company = '';
                }
                if(objLead.RecordTypeId == RebuServiceRecType ||objLead.RecordTypeId == SuppRecType ){
                    
                    if(objLead.FirstName != null)
                    objLead.FirstName = objLead.FirstName.toUppercase();
                    if(objLead.MiddleName != null)
                    objLead.MiddleName = objLead.MiddleName.toUppercase();
                    objLead.LastName = objLead.LastName.toUppercase();
                    if(objLead.Company != null)
                    objLead.Company = objLead.Company.toUppercase();
                }
            }
        }
    }

    if(ettOrgSettingLst!=null && ettOrgSettingLst.size()>0 && ETT_LeadTriggerHandler.isRecursive){
            if(trigger.isUpdate)
            ETT_LeadTriggerHandler.quotationApprovalSubmit(trigger.oldmap,trigger.newmap);
            
    }
}