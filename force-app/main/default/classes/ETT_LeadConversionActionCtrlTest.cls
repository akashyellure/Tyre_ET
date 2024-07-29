/*Author:Janardhan
 * Desc: To avoid multiple data entry in standard lead conversion process for customer for diff recordtypes
 * Created Date: 17/11/2021
 * Class Name:ETT_LeadConversionActionCtrl
 * 
 * */
@isTest
public class ETT_LeadConversionActionCtrlTest {
    
    public static testmethod void convertLead(){
        
        Lead le = new Lead();
        le.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId();
        le.LastName ='test';
        le.Company='Testhjsliee';
        le.MobilePhone ='558656023';
        le.LeadSource ='Website';
        le.ETT_VAT_TRN__c ='343434222222345';
        le.ETT_Trade_License_Number__c = '343434222222345';
        
        insert le;
        
        ETT_LeadConversionActionCtrl.convertLeadCustom(le.id);
        
    }

}