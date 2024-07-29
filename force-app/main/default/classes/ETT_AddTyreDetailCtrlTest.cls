@isTest
public class ETT_AddTyreDetailCtrlTest {
    
    public static testmethod void addTyre(){
        
       List<Lead> leadList =  ETT_TestFactory.createLeads();
        insert leadList;
       List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Organization');
        insert accountsList;
       Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
      ETT_AddTyreDetailCtrl.getselectOptions(leadList[0], 'Status');        
        
      ETT_AddTyreDetailCtrl.createStagingQuotation(opp.Id,new list<ETT_Staging_Quotation_Request__c>{new ETT_Staging_Quotation_Request__c()},new list<ETT_Tyre_Master__c>{new ETT_Tyre_Master__c()});
    }

}