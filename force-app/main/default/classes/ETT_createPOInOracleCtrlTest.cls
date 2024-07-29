@isTest
public class ETT_createPOInOracleCtrlTest {
    
    private static testmethod void createPO(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName35464', 'Tyre Customer');
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = accountsList[0].Id;
        objCC.ETT_Opportunity__c = opp.Id;
        insert objCC;
        
        ETT_Purchase_Order__c po = new ETT_Purchase_Order__c();
        po.ETT_Account__c =  accountsList[0].Id;
        po.ETT_Collection_Card__c = objCC.Id;
        insert po;
        
        ETT_Purchase_Order_Line_Item__c pol = new ETT_Purchase_Order_Line_Item__c();
        
        pol.ETT_Purchase_Order__c = po.Id;
        pol.ETT_Quantity__c = 1;
        pol.ETT_Item__c = 'TU-2323-23';
        
        insert pol;
        
        ETT_Price_Master__c pm2 = new ETT_Price_Master__c();
        pm2.ETT_Party_Name__c = accountsList[0].Id;
        insert pm2;
        
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c=pm2.Id;
        epi.ETT_Approval_Status__c ='Approved';
        insert epi;
        
        
        
        ETT_Tyre_Size_Master__c tsm = new ETT_Tyre_Size_Master__c();
        tsm.Name ='Size1';
        insert tsm;
        
        ETT_Pattern_Master__c pat = new ETT_Pattern_Master__c();
        pat.Name ='Pat21';
        insert pat;
        
        ETT_Country_Master__c coun = new ETT_Country_Master__c();
        coun.Name ='Coun1';
        insert coun;
        
        ETT_Brand_Master__c bra = new ETT_Brand_Master__c();
        bra.Name ='Bran1';
        insert bra;
        
        ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = accountsList[0].Id;
        tin2.ETT_Collection_Card__c = objCC.Id;
        tin2.Serial_Number__c = '243254454';
        tin2.ETT_Inventory_Status__c='Draft';
        tin2.ETT_Brand__c = bra.Id;
        tin2.ETT_Country__c=coun.id;
        tin2.ETT_Pattern__c=pat.id;
        tin2.ETT_Tyre_Size_Master__c=tsm.Id;
        tin2.PO_Line__c =pol.Id;
        tin2.ETT_Inventory_Status__c = 'Inspected - Approved';
        
        insert tin2;
        
        
        
        new ETT_PO_PORecp.process_element();
        new ETT_PO_PORecp.OutputParameters_element();
        new ETT_PO_PORecp.MessageHeader();
        new ETT_PO_PORecp.SerialNumber_lines_element();
        
        
        test.startTest();
        
        Test.setMock(WebServiceMock.class, new ETT_SOAPMockTestClass());
        ETT_createPOInOracleCtrl.createPOInOracle(po.Id);
        
        test.stopTest();
    }
    
    
}