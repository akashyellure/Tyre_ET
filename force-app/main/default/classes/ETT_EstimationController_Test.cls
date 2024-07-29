@isTest
public class ETT_EstimationController_Test {
    
    @isTest static void lstEstimationsInfoTest(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Organization');
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        List<ETT_Tyre_Size_Master__c> tyreMasterSizeList =  ETT_TestFactory.createTyreSizeMaster();
        insert tyreMasterSizeList;
        List<ETT_Brand_Master__c> brandMastersList = ETT_TestFactory.createBrandMasters();
        insert brandMastersList;
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(accountsList[0].Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
        List<ETT_Inspection_Card__c> inspectionsCardsList = ETT_TestFactory.createInspectionCards('Tyre - Internal',accountsList[0].Id,brandMastersList[0].Id,collectionCardsList[0].Id,tyreMasterSizeList[0].Id);
        inspectionsCardsList[0].ETT_Status__c ='Send Back';
        insert inspectionsCardsList;
        List<ETT_Estimate_Quotation__c>  estimateQuotationsList = ETT_TestFactory.createEstimateQuotations(collectionCardsList[0].Id,inspectionsCardsList[0].Id,tyreMasterSizeList[0].Id);
        estimateQuotationsList[0].ETT_Accept_Quotation__c = true;
        estimateQuotationsList[0].ETT_Status__c='Accepted';
        estimateQuotationsList[0].ETT_Brand__c= brandMastersList[0].id;
         estimateQuotationsList[0].ETT_Tyre_Size__c= tyreMasterSizeList[0].id;
        insert estimateQuotationsList;
        ETT_FileUploadWrapper wrp = new ETT_FileUploadWrapper();
        wrp.strFileName = 'Test';
        wrp.strBase64Data = 'Test';
        wrp.strFileType = 'Test';
        wrp.fileSourceType = 'Test';
        
        ET_Tyre_Wallet__c wall = new ET_Tyre_Wallet__c();
        wall.Account_Name__c=accountsList[0].Name;
        insert wall;
        
        
        ETT_EstimationController.lstEstimationsInfo(collectionCardsList[0].Id);
        ETT_EstimationController.estimationConfirmation(estimateQuotationsList);
        ETT_EstimationController.getTyreDetails(collectionCardsList[0].Id);
        ETT_EstimationController.getTyreDetailsAcc(accountsList[0].Id);
        ETT_EstimationController.getTrafficFine(accountsList[0].Id);
        ETT_EstimationController.createQuotations(new List<ETT_Quotation_Line_Item__c>{new ETT_Quotation_Line_Item__c()},accountsList[0].Id,'jana@test.com','Jana',332,new list<ET_Tyre_Wallet__c>{wall});
        ETT_EstimationController.getQuotationsForApproval();
        ETT_EstimationController.getQuotationLineItems(estimateQuotationsList[0].Id);
        ETT_EstimationController.sendMailMethodTest('test@test.com' ,'testSubject' ,'testbody',null,null,null);
        ETT_EstimationController.sendMailMethod('test@test.com' ,'testSubject' ,'testbody',null,null,null);
        List<ETT_Quotation__c> lstQuotation = [select Id from ETT_Quotation__c limit 1];
        //ETT_EstimationController.acceptRejectQuotation(lstQuotation[0].Id,'Accepted');
        ETT_EstimationController.getContactsFromAccountID(accountsList[0].Id);
        ETT_EstimationController.getPricingInfoFromAccId(accountsList[0].Id);
        //ETT_EstimationController.getPricingInfoFromCollCardId(collectionCardsList[0].Id);
        
        
        
    }
}