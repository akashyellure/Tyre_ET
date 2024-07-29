@isTest 
private class ETT_LeadFormWrapper_Test {

    static testMethod void leadWrapper() {
        
        ETT_LeadFormWrapper objLeadWrapper = new ETT_LeadFormWrapper();
        
        ETT_LeadFormWrapper.ContactInformation objContactInfo = new ETT_LeadFormWrapper.ContactInformation();
        objContactInfo.conCount = 1 ;
        objContactInfo.conDesignation = 'Developer';
        objContactInfo.conEmail = 'testDeveloper@test.com';
        objContactInfo.conMobile = '+971 5643536632';
        objContactInfo.conName = 'Suhas';
        
         ETT_LeadFormWrapper.LPOWrapper objLPOWrapperInfo = new ETT_LeadFormWrapper.LPOWrapper();
        objLPOWrapperInfo.lpoCount = 1 ;
        objLPOWrapperInfo.lpoName = 'Developer';
        objLPOWrapperInfo.lpoDesignation = 'testDeveloper@test.com';
        objLPOWrapperInfo.lpoSignature = '+971 5643536632';
        objLPOWrapperInfo.lpoSignInPersonName = 'Suhas';
        
        ETT_LeadFormWrapper.TradeReferenceWrapper objTradeRefInfo = new ETT_LeadFormWrapper.TradeReferenceWrapper();
        objTradeRefInfo.tradeCount = 1 ;
        objTradeRefInfo.tradeSupplierName = 'Developer';
        objTradeRefInfo.tradeLengthOfRelationShip = 'testDeveloper@test.com';
        objTradeRefInfo.tradeCreditLimit = 2.3;
        objTradeRefInfo.tradePaymentTerms = 'Suhas';
        
        ETT_LeadFormWrapper.BankReferenceWrapper objBankRefInfo = new ETT_LeadFormWrapper.BankReferenceWrapper();
        objBankRefInfo.bankCount = 1 ;
        objBankRefInfo.bankRefName = 'Developer';
        objBankRefInfo.bankRefAddress = 'testDeveloper@test.com';
        objBankRefInfo.bankRefAcctNum = '+971 5643536632';
        objBankRefInfo.bankRefStartsWith = 'Suhas';
        
        ETT_LeadFormWrapper.CustomerVehicleWrapper objCustomerVehiclInfo = new ETT_LeadFormWrapper.CustomerVehicleWrapper();
        objCustomerVehiclInfo.vehicleCount = 1 ;
        objCustomerVehiclInfo.vehicleType = 'Developer';
        objCustomerVehiclInfo.vehicleConfiguration = 'testDeveloper@test.com';
        objCustomerVehiclInfo.axilConfiguration = '+971 5643536632';
        objCustomerVehiclInfo.application = 'Suhas';
        objCustomerVehiclInfo.kmsCoveredYearly = 2.3;
        objCustomerVehiclInfo.tyresInFleet = 2.3;
        objCustomerVehiclInfo.vehiclesInFleet = 2.3;
        
        ETT_LeadFormWrapper.PurchaseInformationWrapper objPurchaseInfo = new ETT_LeadFormWrapper.PurchaseInformationWrapper();
        objPurchaseInfo.purchaseCount = 1 ;
        objPurchaseInfo.tyreSize = 'testDeveloper@test.com';
        objPurchaseInfo.strtype = '+971 5643536632';
        objPurchaseInfo.brand = 'Suhas';
        objPurchaseInfo.yearlyQty = 2.3;
        objPurchaseInfo.price = 2.3;
        objPurchaseInfo.authorisedPerson = 'authorisedPerson';
        objPurchaseInfo.creditLimit = 2.3;
        objPurchaseInfo.vehicleType = 'Suhas';
        objPurchaseInfo.paymentTerms = 'Suhas';
        
        ETT_LeadFormWrapper.AddedServiceWrapper objAddedServiInfo = new ETT_LeadFormWrapper.AddedServiceWrapper();
        objAddedServiInfo.addedServiceCount = 1 ;
        objAddedServiInfo.services = 'Developer';
        objAddedServiInfo.isOwn = true;
        objAddedServiInfo.isOutSource = true;
        objAddedServiInfo.detailsOfSupplier = 'Suhas';
    }
    
}