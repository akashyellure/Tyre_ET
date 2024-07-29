@isTest
public class ETT_ConstantCls_Test {
    static TestMethod void ConstantCls_UnitTest1(){
        Test.startTest();
        System.assertEquals(ETT_ConstantCls.strApproveStatus,'Approved');
        System.assertEquals(ETT_ConstantCls.strFMProfile,'ETT_Factory Manager');
        System.assertEquals(ETT_ConstantCls.quoteApproveField,'ETT_IS_Approved__c');
        System.assertEquals(ETT_ConstantCls.quoteApproved,true);
        System.assertEquals(ETT_ConstantCls.strLeadConverionObjectField, 'ETT_Account__c');
        System.assertEquals(ETT_ConstantCls.strSucces, 'Success');
        //System.assertEquals(ETT_ConstantCls.strFailure, 'Object fields that affected this error:');
        System.assertEquals(ETT_ConstantCls.strLeadNotqulifiedStatus, 'This Lead is not a Qualified Lead');
        System.assertEquals(ETT_ConstantCls.strClassNameMethod, 'Class Name :ETT_LeadConvertProcessController'+' Method Name :leadConvertProcess');
        System.assertEquals(ETT_ConstantCls.strLeadStatus,'Working');
        System.assertEquals(ETT_ConstantCls.conExternalConRecordTypeId,'');
        System.assertEquals(ETT_ConstantCls.conInternalConRecordTypeId,'');
        System.assertEquals(ETT_ConstantCls.strLeadObject,'Lead');
        //    System.assertEquals(ETT_ConstantCls.strPurchaseInfoObject,'ETT_staging_purchase_information_c');
        System.assertEquals(ETT_ConstantCls.strAddedServicesObject,'ETT_Staging_Added_Service__c');
        System.assertEquals(ETT_ConstantCls.strStagingContactObject,'ETT_Staging_Contacts__c');
        
        test.stopTest();
        
        
    }
}