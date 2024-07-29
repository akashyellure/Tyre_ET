@istest 
public class ETT_Collection_Card_Pdf_Controller_Test {
    @istest public static void insertdata()
    {
        Account accoun = new Account();
      //  accoun.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account').getRecordTypeId();
        accoun.Name = 'test corp';
        accoun.phone= '01123123';
        accoun.billingcity='London';
        accoun.billingpostalcode='SW1635HJ';
        accoun.billingcountry='United Kingdom';
        accoun.billingstreet='address 1';
        insert accoun;
        
        list<ETT_Collection_Card__c> lstcc = new list<ETT_Collection_Card__c>();
        ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
        cc.ETT_Accounts__c	= accoun.id;
        lstcc.add(cc);
        insert lstcc;
        
        
        ApexPages.StandardController controlr=new ApexPages.StandardController(cc);
        ApexPages.currentPage().getParameters().put('id',cc.id);
        ETT_Collection_Card_Pdf_Controller ettcc = new ETT_Collection_Card_Pdf_Controller(controlr);
        
    }
    
}