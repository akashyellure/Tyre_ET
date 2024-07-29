@isTest
public class ETT_POEstimationCtrlTest {
    
    private static testmethod void pocreation(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName35464', 'Tyre Customer');
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = accountsList[0].Id;
        objCC.ETT_Opportunity__c = opp.Id;
        insert objCC;
        
        ETT_Inspection_Card__c ins = new ETT_Inspection_Card__c();
        ins.ETT_Collection_Card__c = objCC.Id;
        ins.ETT_Account__c = accountsList[0].Id;
        ins.ETT_Status__c ='Accept';
        insert ins;
        
        ETT_POEstimationCtrl.getTyreInspectionCCDetails(objCC.Id);
        ETT_POEstimationCtrl.createPOAndLines(objCC.Id,new list<ETT_Inspection_Card__c>{ins},new list<ETT_Inspection_Card__c>{ins});
        
    }

}