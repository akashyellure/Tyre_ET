@isTest
public class ETT_QuotationSendInEmailCtrlTest {
    
    public static testmethod void sendemailtest(){
          Account accoun = new Account();
        accoun.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        accoun.Name = 'test corp';
        accoun.phone= '01123123';
        accoun.billingcity='London';
        accoun.billingpostalcode='SW1635HJ';
        accoun.billingcountry='United Kingdom';
        accoun.billingstreet='address 1';
        insert accoun;
        list<contact> clst= new list<contact>();
        contact con =new contact();
        //con.Id=accoun.Id;
        con.Title='testdata';
        con.Email='test@gmail.com';
        con.LastName='test2';
        clst.add(con);
        insert clst;
        
        list<contact> clst1= new list<contact>();
        contact con1 =new contact();
        // con1.Id=accoun.Id;
        con1.Title='testdatas';
        con1.Email='testas@gmail.com';
        con1.LastName='test3';
        clst1.add(con1);
        insert clst1;
        
        //ETT_Collection_Card__c lstcc = new <ETT_Collection_Card__c>();
        ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
        cc.ETT_Accounts__c	= accoun.id;
        cc.ETT_Collection_Date__c=system.today();
        
        insert cc;
        
        ETT_Inspection_Card__c ins= new ETT_Inspection_Card__c();
        ins.ETT_Account__c=accoun.Id;
        ins.ETT_Collection_Card__c=cc.Id;
        ins.ETT_Status__c='Accept';
        insert ins;
        
        ETT_Quotation__c qut=new ETT_Quotation__c();
        qut.ETT_Account__c=accoun.id;
        qut.ETT_Tyre_Inspection_Card__c=ins.id;
        qut.ETT_Head_Of_Operation_Acceptance__c='Accepted';
        
        insert qut;
        
        ETT_QuotationSendInEmailCtrl.sendEmailToCustomer('janardhan.m@test.com', accoun.Id, qut.Id, 'ETT_SendQuotationPdfTemplate', 'QuoteName','janardhan1.m@test.com');
    }

}