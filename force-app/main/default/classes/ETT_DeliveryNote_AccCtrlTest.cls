@isTest
public class ETT_DeliveryNote_AccCtrlTest {
    
    private static testmethod void createDNForCustomer(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('Test92J35464', 'Organization');
        accountsList[0].Party_Type__c = 'Customer';
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = accountsList[0].Id;
        objCC.ETT_Opportunity__c = opp.Id;
        insert objCC;
        
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
        
        ETT_Price_Master__c pm = new ETT_Price_Master__c();
        pm.ETT_Party_Name__c = accountsList[0].Id;
        insert pm;
        
        ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = accountsList[0].Id;
        tin2.ETT_Collection_Card__c = objCC.Id;
        tin2.Serial_Number__c = '243254454';
        tin2.ETT_Inventory_Status__c='Draft';
        tin2.ETT_Brand__c = bra.Id;
        tin2.ETT_Country__c=coun.id;
        tin2.ETT_Pattern__c=pat.id;
        tin2.ETT_Tyre_Size_Master__c=tsm.Id;
        
        insert tin2;
        
        ETT_Inspection_Card__c ins = new ETT_Inspection_Card__c();
        ins.ETT_Collection_Card__c = objCC.Id;
        ins.ETT_Status__c ='Send Back';
        ins.Tyre_Inventory__c = tin2.id;
        insert ins;
        
        ETT_Quotation__c objEQ = new ETT_Quotation__c();
        insert objEQ;
        
        ETT_Quotation_Line_Item__c objQLI = new ETT_Quotation_Line_Item__c();
        objQLI.ETT_Quotation__c = objEQ.Id;
        objQLI.Collection_Card__c = objCC.Id;
        insert objQLI;
        
        
        ETT_DeliveryNote_AccCtrl.getInsCards(accountsList[0].Id, new List<Id>{objEQ.Id});
        ETT_DeliveryNote_AccCtrl.getConRelatedAcc(accountsList[0].Id);
        ETT_DeliveryNote_AccCtrl.createDeliveryNote(new ETT_Delivery_Note__c(), new list<ETT_Delivery_Line_Item__c>{new ETT_Delivery_Line_Item__c()});
    }
    
    private static testmethod void createDN(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('Test92J35464', 'Organization');
        //accountsList[0].Party_Type__c = 'Customer';
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = accountsList[0].Id;
        objCC.ETT_Opportunity__c = opp.Id;
        insert objCC;
        
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
        
        ETT_Price_Master__c pm = new ETT_Price_Master__c();
        pm.ETT_Party_Name__c = accountsList[0].Id;
        insert pm;
        
        ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = accountsList[0].Id;
        tin2.ETT_Collection_Card__c = objCC.Id;
        tin2.Serial_Number__c = '243254454';
        tin2.ETT_Inventory_Status__c='Draft';
        tin2.ETT_Brand__c = bra.Id;
        tin2.ETT_Country__c=coun.id;
        tin2.ETT_Pattern__c=pat.id;
        tin2.ETT_Tyre_Size_Master__c=tsm.Id;
        
        insert tin2;
        
        ETT_Inspection_Card__c ins = new ETT_Inspection_Card__c();
        ins.ETT_Collection_Card__c = objCC.Id;
        ins.ETT_Status__c ='Send Back';
        ins.Tyre_Inventory__c = tin2.id;
        insert ins;
        
        ETT_Quotation__c objEQ = new ETT_Quotation__c();
        insert objEQ;
        
        ETT_Quotation_Line_Item__c objQLI = new ETT_Quotation_Line_Item__c();
        objQLI.ETT_Quotation__c = objEQ.Id;
        objQLI.Collection_Card__c = objCC.Id;
        insert objQLI;
        
        
        ETT_DeliveryNote_AccCtrl.getInsCards(accountsList[0].Id, new List<Id>{objEQ.Id});
        ETT_DeliveryNote_AccCtrl.getConRelatedAcc(accountsList[0].Id);
        ETT_DeliveryNote_AccCtrl.createDeliveryNote(new ETT_Delivery_Note__c(), new list<ETT_Delivery_Line_Item__c>{new ETT_Delivery_Line_Item__c()});
    }

}