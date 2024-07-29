@isTest
public class ETT_InventoryUpsertAPITest {
    
    public static testmethod void addInventoryAPI(){
         Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
       List<Lead> leadList =  ETT_TestFactory.createLeads();
        insert leadList;
       List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Organization');
        insert accountsList;
        
        /*List<ETT_Tyre_Size_Master__c> TM = ETT_TestFactory.createTyreSizeMaster();
        insert TM;
        
        List<ETT_Brand_Master__c> BM = ETT_TestFactory.createBrandMasters();
        insert BM ;
        List<ETT_Pattern_Master__c> PM = ETT_TestFactory.createPatternMasters();
        insert PM;*/
        ETT_Tyre_Size_Master__c TM = New ETT_Tyre_Size_Master__c();
        TM.Name = 'Test Size';
        TM.ETT_Tyre_Size__c = '06-50-10';
            TM.ETT_Description__c = '06.50-10 SMALL TYRE';
            TM.ETT_Status__c = true;
   
        insert TM;
        
        ETT_Brand_Master__c BM = New ETT_Brand_Master__c();
        BM.Name = 'Test Brand';
        BM.ETT_Status__c = true;
        insert BM;
        
        ETT_Pattern_Master__c PM = new ETT_Pattern_Master__c();
            PM.Name = 'Test Pattern';
            PM.ETT_Pattern_Code__c = '1234';
        insert PM;
        
        ETT_Country_Master__c CM = ETT_TestFactory.createCountries('Test Country');
        insert CM;
        
        ETT_Tyre_Master__c TMT = New ETT_Tyre_Master__c();
        Id recordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Approved').getRecordTypeId();
        TMT.RecordTypeId = recordTypeId;
        TMT.ETT_Brand_Name__c = BM.id;
        TMT.ETT_Country_Name__c = CM.id;
        TMT.ETT_Tyre_Size__c = TM.id;
        TMT.ETT_Original_Pattern__c = PM.id;
        TMT.ETT_Vehicle_Type__c = 'Bus';
        insert TMT;
        //Id recordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get(Approved).getRecordTypeId();
        /*List<ETT_Tyre_Master__c> tyreMastersList = new List<ETT_Tyre_Master__c>();
        
            ETT_Tyre_Master__c tm = new ETT_Tyre_Master__c();
            tm.ETT_Tyre_Size__c = TM[0].id;
            tm.ETT_Brand_Name__c = BM[0].id;
            tm.ETT_Pattern__c = PM[0].id;
            tm.ETT_Vehicle_Type__c = 'Bus';
            tm.ETT_Country__c = CM.id;
            tyreMastersList.add(tm);*/
        
        ETT_Tools_Master__c tool = New ETT_Tools_Master__c();
        Id recordTypeId1 = Schema.SObjectType.ETT_Tools_Master__c.getRecordTypeInfosByName().get('Material - Cushion Gum').getRecordTypeId();
        tool.RecordTypeId = recordTypeId1;
        tool.Name = 'Test';
        tool.ETT_Status__c = 'Available';
        tool.ETT_Unique_Code__c = 'Test Item';
        insert tool;
        list<ETT_Tools_Master__c> toollist = New list<ETT_Tools_Master__c>();
        toollist.add(tool);
        
        ETT_Price_Master__c Price = New ETT_Price_Master__c();
        Price.ETT_Party_Type__c = 'Customer';
        insert Price;
        
        ETT_Pricing_Information__c Pi = New ETT_Pricing_Information__c();
        Pi.ETT_Price__c = Price.id;
        
        WorkOrder wo = New WorkOrder();
        wo.City = 'Test';
        insert wo;
        
        WorkOrderLineItem workorder = New WorkOrderLineItem();
        workorder.ETT_Tyre_Size__c = TM.id;
        workorder.ETT_Tyre_Serial_Number__c = '123';
        workorder.WorkOrderId = wo.id;
        insert workorder;
        
        ETT_Tyre_Inventory__c tyreinv = New ETT_Tyre_Inventory__c();
        //tyreinv.Name = 'Test';
        tyreinv.ETT_Tyre_Size_Master__c = TM.id;
        tyreinv.ETT_Work_Order_Line_Item__c = workorder.id;
        tyreinv.ETT_Brand__c = BM.id;
        tyreinv.ETT_Pattern__c = PM.id;
        tyreinv.ETT_Country__c = CM.id;
        //tyreinv.ETT_Price__c = 
        tyreinv.Pricing_Information__c = Pi.id;
        insert tyreinv;
        List<ETT_Tyre_Inventory__c> TyreinList = New List<ETT_Tyre_Inventory__c>();
        TyreinList.add(tyreinv);
        ETT_InventoryUpsertAPI.Inventorywrapper wrapper = new ETT_InventoryUpsertAPI.Inventorywrapper();
        ETT_InventoryUpsertAPI.InventoryList Inv = New ETT_InventoryUpsertAPI.InventoryList();
        Inv.Brand = 'Test Brand';
        Inv.Country = 'Test Country';
        Inv.ItemCode = 'Test Item';
        Inv.ItemMajorcategory = 'Tyre';
        Inv.Pattern = 'Test Pattern';
        Inv.Quantity = '2';
        Inv.SerialNumber = '123';
        Inv.TyreSize = 'Test Size';
        List<ETT_InventoryUpsertAPI.InventoryList> itemList = new List<ETT_InventoryUpsertAPI.InventoryList>();
        itemList.add(Inv);
        wrapper.item = itemList;
        String requestBody = JSON.serialize(wrapper);
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/CreateInventoryData';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        Test.startTest();
        ETT_InventoryUpsertAPI.updateServiceRequestResult result = ETT_InventoryUpsertAPI.CreateInventory();
        Test.stopTest();
        
        // Verify the response
        //System.assertEquals('Success', result.status);
        /*RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/CreateInventoryData';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(requestBody);

        // Set up the test response
        RestResponse response = new RestResponse();
        //Test.setMock(RestContext.response, response);

        // Call the API method
        Test.startTest();
        ETT_InventoryUpsertAPI.updateServiceRequestResult result = ETT_InventoryUpsertAPI.CreateInventory();
        ETT_InventoryUpsertAPI.returnWrapper('Test Error',toollist,TyreinList,1,'Test Status');
        Test.stopTest();
        //ETT_InventoryUpsertAPI.CreateInventory();
        //ETT_InventoryUpsertAPI.returnWrapper('Test Error',toollist,TyreinList,1,'Test Status');*/
        
        
        
         

}
     public static testmethod void addInventoryAPINew(){
         Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
       List<Lead> leadList =  ETT_TestFactory.createLeads();
        insert leadList;
       List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Organization');
        insert accountsList;
        
        /*List<ETT_Tyre_Size_Master__c> TM = ETT_TestFactory.createTyreSizeMaster();
        insert TM;
        
        List<ETT_Brand_Master__c> BM = ETT_TestFactory.createBrandMasters();
        insert BM ;
        List<ETT_Pattern_Master__c> PM = ETT_TestFactory.createPatternMasters();
        insert PM;*/
        ETT_Tyre_Size_Master__c TM = New ETT_Tyre_Size_Master__c();
        TM.Name = 'Test Size';
        TM.ETT_Tyre_Size__c = '06-50-10';
            TM.ETT_Description__c = '06.50-10 SMALL TYRE';
            TM.ETT_Status__c = true;
   
        insert TM;
        
        ETT_Brand_Master__c BM = New ETT_Brand_Master__c();
        BM.Name = 'Test Brand';
        BM.ETT_Status__c = true;
        insert BM;
        
        ETT_Pattern_Master__c PM = new ETT_Pattern_Master__c();
            PM.Name = 'Test Pattern';
            PM.ETT_Pattern_Code__c = '1234';
        insert PM;
        
        ETT_Country_Master__c CM = ETT_TestFactory.createCountries('Test Country');
        insert CM;
        
        ETT_Tyre_Master__c TMT = New ETT_Tyre_Master__c();
        Id recordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Approved').getRecordTypeId();
        TMT.RecordTypeId = recordTypeId;
        TMT.ETT_Brand_Name__c = BM.id;
        TMT.ETT_Country_Name__c = CM.id;
        TMT.ETT_Tyre_Size__c = TM.id;
        TMT.ETT_Original_Pattern__c = PM.id;
        TMT.ETT_Vehicle_Type__c = 'Bus';
        insert TMT;
        //Id recordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get(Approved).getRecordTypeId();
        /*List<ETT_Tyre_Master__c> tyreMastersList = new List<ETT_Tyre_Master__c>();
        
            ETT_Tyre_Master__c tm = new ETT_Tyre_Master__c();
            tm.ETT_Tyre_Size__c = TM[0].id;
            tm.ETT_Brand_Name__c = BM[0].id;
            tm.ETT_Pattern__c = PM[0].id;
            tm.ETT_Vehicle_Type__c = 'Bus';
            tm.ETT_Country__c = CM.id;
            tyreMastersList.add(tm);*/
        
        ETT_Tools_Master__c tool = New ETT_Tools_Master__c();
        Id recordTypeId1 = Schema.SObjectType.ETT_Tools_Master__c.getRecordTypeInfosByName().get('Material - Cushion Gum').getRecordTypeId();
        tool.RecordTypeId = recordTypeId1;
        tool.Name = 'Test';
        tool.ETT_Status__c = 'Available';
        tool.ETT_Unique_Code__c = 'Test Item';
        insert tool;
        list<ETT_Tools_Master__c> toollist = New list<ETT_Tools_Master__c>();
        toollist.add(tool);
        
        ETT_Price_Master__c Price = New ETT_Price_Master__c();
        Price.ETT_Party_Type__c = 'Customer';
        insert Price;
        
        ETT_Pricing_Information__c Pi = New ETT_Pricing_Information__c();
        Pi.ETT_Price__c = Price.id;
        
        WorkOrder wo = New WorkOrder();
        wo.City = 'Test';
        insert wo;
        
        WorkOrderLineItem workorder = New WorkOrderLineItem();
        workorder.ETT_Tyre_Size__c = TM.id;
        workorder.ETT_Tyre_Serial_Number__c = '123';
        workorder.WorkOrderId = wo.id;
        insert workorder;
        
        ETT_Tyre_Inventory__c tyreinv = New ETT_Tyre_Inventory__c();
        //tyreinv.Name = 'Test';
        tyreinv.ETT_Tyre_Size_Master__c = TM.id;
        tyreinv.ETT_Work_Order_Line_Item__c = workorder.id;
        tyreinv.ETT_Brand__c = BM.id;
        tyreinv.ETT_Pattern__c = PM.id;
        tyreinv.ETT_Country__c = CM.id;
        //tyreinv.ETT_Price__c = 
        tyreinv.Pricing_Information__c = Pi.id;
        insert tyreinv;
        List<ETT_Tyre_Inventory__c> TyreinList = New List<ETT_Tyre_Inventory__c>();
        TyreinList.add(tyreinv);
        ETT_InventoryUpsertAPI.Inventorywrapper wrapper = new ETT_InventoryUpsertAPI.Inventorywrapper();
        ETT_InventoryUpsertAPI.InventoryList Inv = New ETT_InventoryUpsertAPI.InventoryList();
        Inv.Brand = 'Test Brand';
        Inv.Country = 'Test Country';
        Inv.ItemCode = 'Test Item';
        Inv.ItemMajorcategory = 'Test Tyre';
        Inv.Pattern = 'Test Pattern';
        Inv.Quantity = '2';
        Inv.SerialNumber = '123';
        Inv.TyreSize = 'Test Size';
        List<ETT_InventoryUpsertAPI.InventoryList> itemList = new List<ETT_InventoryUpsertAPI.InventoryList>();
        itemList.add(Inv);
        wrapper.item = itemList;
        String requestBody = JSON.serialize(wrapper);
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/CreateInventoryData';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        Test.startTest();
        ETT_InventoryUpsertAPI.updateServiceRequestResult result = ETT_InventoryUpsertAPI.CreateInventory();
        Test.stopTest();
        
        // Verify the response
        //System.assertEquals('Success', result.status);
        /*RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/CreateInventoryData';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(requestBody);

        // Set up the test response
        RestResponse response = new RestResponse();
        //Test.setMock(RestContext.response, response);

        // Call the API method
        Test.startTest();
        ETT_InventoryUpsertAPI.updateServiceRequestResult result = ETT_InventoryUpsertAPI.CreateInventory();
        ETT_InventoryUpsertAPI.returnWrapper('Test Error',toollist,TyreinList,1,'Test Status');
        Test.stopTest();
        //ETT_InventoryUpsertAPI.CreateInventory();
        //ETT_InventoryUpsertAPI.returnWrapper('Test Error',toollist,TyreinList,1,'Test Status');*/
        
        
      
            

}
}