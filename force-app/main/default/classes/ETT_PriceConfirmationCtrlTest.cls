@isTest
public class ETT_PriceConfirmationCtrlTest {
    
    private static testmethod void priceTest(){
        
         List<Account> accountsList = ETT_TestFactory.createAccounts('TJ89ntName34434', 'Organization');
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName3434', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        ETT_Price_Master__c pm2 = new ETT_Price_Master__c();
        pm2.ETT_Party_Name__c = accountsList[0].Id;
        insert pm2;
        
          ETT_Tyre_Size_Master__c tsm = new ETT_Tyre_Size_Master__c();
        tsm.Name ='Size1JKIk';
        insert tsm;
        
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c=pm2.Id;
        epi.ETT_Tyre_Size__c=tsm.Id;
        epi.ETT_Approval_Status__c ='Approved';
        insert epi;
        
        ETT_Tyre_Master__c em = new ETT_Tyre_Master__c();
        em.RecordTypes__c ='Approve';
        em.ETT_Status__c = true;
        insert em;
        
        ETT_Staging_Quotation_Request__c stq = new ETT_Staging_Quotation_Request__c();
        stq.Approver_Status__c= 'Approved';
        insert stq;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Receptionist request');
                req1.setObjectId(opp.Id);
                              
        Approval.ProcessResult result = Approval.process(req1);
        
        ETT_PriceConfirmationCtrl.getAllStagQuotReq(opp.Id);
        ETT_PriceConfirmationCtrl.getLoggedUserInfo();
        ETT_PriceConfirmationCtrl.getselectOptions(opp, 'StageName');
        ETT_PriceConfirmationCtrl.getTyreMasterDetails(opp.Id);
        string priceChangeval ='[{"tyreSize":"12R22.5","NewRepairPrice":12,"OldRepairPrice":12,"NewSelProPrice":"13","OldSelProPrice":12,"NewSelHotPrice":12,"OldSelHotPrice":12,"NewRetProPrice":0,"OldRetProPrice":0,"NewRetHotPrice":0,"OldRetHotPrice":0,"reason":""}]';
        ETT_PriceConfirmationCtrl.updateStgQuotCreatePriceMas(opp.Id,new list<ETT_Staging_Quotation_Request__c>{stq},priceChangeval);
        ETT_PriceConfirmationCtrl.handleNewTyreDetails(opp.Id, new list<ETT_Tyre_Master__c>{em});
    }

}