/*Author:Janardhan
 * Desc: To avoid multiple data entry in standard lead conversion process for customer for diff recordtypes
 * Created Date: 17/11/2021
 * test Class:ETT_LeadConversionActionCtrlTest
 * 
 * */
public class ETT_LeadConversionActionCtrl {
    
    @auraEnabled
    public static string convertLeadCustom(Id leadId){
        
       lead le = [select id,status,recordType.Name,Website,Phone,ETT_Trade_Licenses_Expiry_Date__c,ETT_Payment_Type__c,Email,ETT_Emirates_Id__c,ETT_VAT_TRN__c,ETT_Trade_License_Number__c from Lead where Id=:leadId];
        
       Id accRT_Org = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
       Id conRT_B2B = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('B2B Contact').getRecordTypeId();
        
       Database.LeadConvert lc = new Database.LeadConvert();
       lc.setLeadId(leadId);
       lc.setConvertedStatus('Qualified');
        
        
        try { 
            //convertLead
            Database.LeadConvertResult Lcr = Database.convertLead(lc);
            
            Account accUpdate = new Account();
            Contact conUpdate = new Contact();
            Opportunity oppUpdate = new Opportunity();
            
          
              
            accUpdate.OwnerId = UserInfo.getUserId();
            accUpdate.Id =Lcr.getAccountId();
            if( le.RecordType.Name == 'Tyre Supplier'){
                accUpdate.Party_Type__c = 'Supplier';
                if(le.ETT_Payment_Type__c == 'Cash')
                    accUpdate.AccountNumber =label.Tyre_Supplier_Sundry_Code;
            }else if(le.RecordType.Name == 'Tyre - Refurbishing Services'){
                accUpdate.Party_Type__c = 'Customer';
                if(le.ETT_Payment_Type__c == 'Cash')
                    accUpdate.AccountNumber = label.Tyre_Cusotmer_Sundry_Code;
            }
            
                accUpdate.ETT_Payment_Type__c = le.ETT_Payment_Type__c;
                if(le.ETT_Payment_Type__c == 'Cash'){
                  accUpdate.ETT_Payment_Term__c='Cash';  
                }
                accUpdate.ETT_VAT_TRN_No__c = String.valueOf(le.ETT_VAT_TRN__c);
                accUpdate.ET_Emirates_Id__c = le.ETT_Emirates_Id__c;
                accUpdate.RecordTypeId = accRT_Org;
                accUpdate.ETSALES_Trade_License_Number__c=le.ETT_Trade_License_Number__c;
                accUpdate.ETT_Email__c = le.Email;
                accUpdate.ETSALES_Trade_License_Expiry_Date__c = le.ETT_Trade_Licenses_Expiry_Date__c;
                accUpdate.Phone = le.Phone;
                accUpdate.ETT_Party_Code__c = Lcr.accountid;
                accUpdate.Website = le.Website;
                
                conUpdate.Id = Lcr.getContactId();
                conUpdate.AccountId = Lcr.getAccountId();
                conUpdate.RecordTypeId = getRecordTypeIdbyName('Contact','B2B Contact');
                
                oppUpdate.StageName = 'Qualification';
                oppUpdate.Id = Lcr.getOpportunityId();
               // oppUpdate.RecordTypeId = getRecordTypeIdbyName('Opportunity','Tyre Supplier'); 
               // Handled Opp record type in lead level with Formula field refer--Process builder-ETSALES Update Opportunity Record Type
                
               List<sObject> sobjectUpdatedList = new List<sObject>();
                sobjectUpdatedList.add((sObject)oppUpdate);
                sobjectUpdatedList.add((sObject)conUpdate);
                sobjectUpdatedList.add((sObject)accUpdate);
                if(sobjectUpdatedList!=null && sobjectUpdatedList.size()>0){
                        update sobjectUpdatedList;
               }  
                
        
             return Lcr.getAccountId();
         
        }catch(Exception e) {
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
          
            throw new AuraHandledException( e.getMessage());   
         
        }
      
        
    }
    
     
    public static Id getRecordTypeIdbyName(String objectName,String strRecordTypeName){ 
        if(objectName!='' && strRecordTypeName!='' && Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId()!=null)
            return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId();
        else
            return '';
    }

}