@isTest
public class ETT_PricingInformationTriggerHandlerTest {
    @isTest
    public static void testCase1(){
        
        List<Account> lstAccount = ETT_TestFactory.createAccounts('testAcc', 'Tyre Supplier');
        insert lstAccount;
        
        Account acc = new Account();
        acc.Id = lstAccount[0].Id;
        acc.Party_Type__c = 'Supplier';
        update acc;
        
        ETT_Price_Master__c objPriceMaster = new ETT_Price_Master__c();
        objPriceMaster.ETT_Party_Name__c = acc.Id;
        insert objPriceMaster;
        
        Map<id,ETT_Pricing_Information__c> mapOfOldPricingInformations = new Map<id,ETT_Pricing_Information__c>();
        Map<id,ETT_Pricing_Information__c> mapOfNewPricingInformations = new Map<id,ETT_Pricing_Information__c>();
        
        
        ETT_Pricing_Information__c objPI = new ETT_Pricing_Information__c();
        objPI.ETT_Price__c = objPriceMaster.Id;
        objPI.ETT_Buying_Price__c = 350;
        objPI.ETT_Buying_Approval_Status__c = 'New';
        objPI.ETT_Buying_Price_Comments__c = 'old comment';
        
        objPI.ETT_Repair_Price__c = 100;
        objPI.ETT_Repair_Price_Approval_Status__c = 'New';
        
        objPI.ETT_Retread_Price_H__c = 100;
        objPI.ETT_Retread_H_Price_Approval_Status__c = 'New';
        
        objPI.ETT_Retread_Price_P__c = 100;
        objPI.ETT_Retread_Price_P_Approval_Status__c = 'New';
        
        /*objPI.ETT_Scrap_Price__c = 100;
        objPI.ETT_Scrap_Price_Approval_Status__c = 'New';
        
        objPI.ETT_Selling_Price_H__c = 100;
        objPI.ETT_Selling_Price_H_Approval_Status__c = 'New';
        
        objPI.ETT_Selling_Price_P__c = 100;
        objPI.ETT_Selling_Price_P_Approval_Status__c = 'New';*/
        
        insert objPI;   
        
         ETT_Pricing_Information__c objPI1 = new ETT_Pricing_Information__c();
        objPI1.ETT_Price__c = objPriceMaster.Id;
        objPI1.ETT_Buying_Price__c = 350;
        objPI1.ETT_Buying_Approval_Status__c = 'New';
        objPI1.ETT_Buying_Price_Comments__c = 'old comment';
        
        objPI1.ETT_Repair_Price__c = 100;
        objPI1.ETT_Repair_Price_Approval_Status__c = 'New';
        
        objPI1.ETT_Retread_Price_H__c = 100;
        objPI1.ETT_Retread_H_Price_Approval_Status__c = 'New';
        
        objPI1.ETT_Retread_Price_P__c = 100;
        objPI1.ETT_Retread_Price_P_Approval_Status__c = 'New';
        
        /*objPI1.ETT_Scrap_Price__c = 100;
        objPI1.ETT_Scrap_Price_Approval_Status__c = 'New';
        
        objPI1.ETT_Selling_Price_H__c = 100;
        objPI1.ETT_Selling_Price_H_Approval_Status__c = 'New';
        
        objPI1.ETT_Selling_Price_P__c = 100;
        objPI1.ETT_Selling_Price_P_Approval_Status__c = 'New';*/
        
        insert objPI1;  
        
        mapOfOldPricingInformations.put(objPI.Id,objPI);
         mapOfOldPricingInformations.put(objPI1.Id,objPI1);
        Test.startTest();
        
        ETT_Pricing_Information__c objPINew = new ETT_Pricing_Information__c();
        objPINew.Id = objPI.Id;
        objPINew.ETT_Buying_Price__c = 550;
        objPINew.ETT_Buying_Approval_Status__c = 'Approved';
        objPINew.ETT_Buying_Price_Comments__c = 'ETT_Buying_Price_Comments__c';

        objPINew.ETT_Repair_Price__c = 200;
        objPINew.ETT_Repair_Price_Approval_Status__c = 'Approved';
        
        objPINew.ETT_Retread_Price_H__c = 200;
        objPINew.ETT_Retread_H_Price_Approval_Status__c = 'Approved';
        
        objPINew.ETT_Retread_Price_P__c = 200;
        objPINew.ETT_Retread_Price_P_Approval_Status__c = 'Approved';
        
        objPINew.ETT_Scrap_Price__c = 200;
        objPINew.ETT_Scrap_Price_Approval_Status__c = 'Approved';
        
        objPINew.ETT_Selling_Price_H__c = 200;
        objPINew.ETT_Selling_Price_H_Approval_Status__c = 'Approved';
        
        objPINew.ETT_Selling_Price_P__c = 200;
        objPINew.ETT_Selling_Price_P_Approval_Status__c = 'Approved';        
        
        update objPINew;
        
        ETT_Pricing_Information__c objPINew1 = new ETT_Pricing_Information__c();
        objPINew1.Id = objPI1.Id;
        objPINew1.ETT_Buying_Price__c = 550;
        objPINew1.ETT_Buying_Approval_Status__c = 'Rejected';
        objPINew1.ETT_Buying_Price_Comments__c = 'ETT_Buying_Price_Comments__c';

        objPINew1.ETT_Repair_Price__c = 200;
        objPINew1.ETT_Repair_Price_Approval_Status__c = 'Rejected';
        objPINew1.ETT_Repair_Price_Comments__c = 'ETT_Buying_Price_Comments__c';
        
        objPINew1.ETT_Retread_Price_H__c = 200;
        objPINew1.ETT_Retread_H_Price_Approval_Status__c = 'Rejected';
        
        objPINew1.ETT_Retread_Price_P__c = 200;
        objPINew1.ETT_Retread_Price_P_Approval_Status__c = 'Rejected';
        
        objPINew1.ETT_Scrap_Price__c = 200;
        objPINew1.ETT_Scrap_Price_Approval_Status__c = 'Rejected';
        
        objPINew1.ETT_Selling_Price_H__c = 200;
        objPINew1.ETT_Selling_Price_H_Approval_Status__c = 'Rejected';
        
        objPINew1.ETT_Selling_Price_P__c = 200;
        objPINew1.ETT_Selling_Price_P_Approval_Status__c = 'Rejected';  
        objPINew1.ETT_Selling_Price_H_Comments__c = 'ETT_Buying_Price_Comments__c';   
        objPINew1.ETT_Retread_Price_P_Comments__c = 'ETT_Buying_Price_Comments__c';  
        objPINew1.ETT_Retread_Price_H_Comments__c = 'ETT_Buying_Price_Comments__c';
        objPINew1.ETT_Scrap_Price_Comments__C = 'ETT_Buying_Price_Comments__c';  
         objPINew1.ETT_Selling_Price_P_Comments__c = 'ETT_Buying_Price_Comments__c';  
        
        update objPINew1;
        
        mapOfNewPricingInformations.put(objPINew.Id,objPINew);
        mapOfNewPricingInformations.put(objPINew1.Id,objPINew1);
        System.debug('mapOfOldPricingInformations: '+mapOfOldPricingInformations);
        System.debug('mapOfNewPricingInformations: '+mapOfNewPricingInformations);
        
        ETT_PricingInformationTriggerHandler.pricingInformationHandleUpdate(mapOfNewPricingInformations, mapOfOldPricingInformations);
		ETT_PricingInformationTriggerHandler.priceResetHandleUpdates(objPINew, 'ETT_Buying_Price__c', 'ETT_Buying_Price__c', 3.2, 'ETT_Buying_Price_Comments__c', 'ETT_Repair_Price_Approval_Status__c');

        /*        
        ETT_Pricing_Information__c objPINewBuyRej = new ETT_Pricing_Information__c();
        objPINewBuyRej.Id = objPI.Id;
        objPINewBuyRej.ETT_Buying_Price__c = 650;
        objPINewBuyRej.ETT_Buying_Approval_Status__c = 'Rejected';
        
        objPINewBuyRej.ETT_Repair_Price__c = 250;
        objPINewBuyRej.ETT_Repair_Price_Approval_Status__c = 'Rejected';
        
        
        objPINewBuyRej.ETT_Retread_Price_H__c = 250;
        objPINewBuyRej.ETT_Retread_H_Price_Approval_Status__c = 'Rejected';
        
        objPINewBuyRej.ETT_Retread_Price_P__c = 250;
        objPINewBuyRej.ETT_Retread_Price_P_Approval_Status__c = 'Rejected';
        
        objPINewBuyRej.ETT_Scrap_Price__c = 250;
        objPINewBuyRej.ETT_Scrap_Price_Approval_Status__c = 'Rejected';
        
        objPINewBuyRej.ETT_Selling_Price_H__c = 250;
        objPINewBuyRej.ETT_Selling_Price_H_Approval_Status__c = 'Rejected';
        
        objPINewBuyRej.ETT_Selling_Price_P__c = 250;
        objPINewBuyRej.ETT_Selling_Price_P_Approval_Status__c = 'Rejected';        
        
        update objPINewBuyRej;
        mapOfNewPricingInformations.put(objPINewBuyRej.Id,objPINewBuyRej);

        System.debug('mapOfOldPricingInformations: '+mapOfOldPricingInformations);
        System.debug('mapOfNewPricingInformations: '+mapOfNewPricingInformations);
        
        ETT_PricingInformationTriggerHandler.pricingInformationHandleUpdate(mapOfNewPricingInformations, mapOfOldPricingInformations);
        
        */
        
        ETT_PricingInformationTriggerHandler.PricingHistoryWrapper objWrapper = new ETT_PricingInformationTriggerHandler.PricingHistoryWrapper();
       // objWrapper.objEventLog = '';
       // objWrapper.objPricingHistory = '';
        
        
        Test.stopTest();        
        
        
       
        
    }
}