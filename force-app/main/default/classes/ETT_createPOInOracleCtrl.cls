/**
 * Author:Janardhan
 * CreatedDate:07/12/21
 * TestClass:ETT_createPOInOracleCtrlTest
 * */
public class ETT_createPOInOracleCtrl {
    
    @auraEnabled
    public static map<string,string> createPOInOracle(string recordId){
        
        
        Map<String, String> responseValues = new  Map<String, String>();
        ETT_PO_SyncPORecp.SyncCreatePOReceiptsServiceBPEL_pt req = new ETT_PO_SyncPORecp.SyncCreatePOReceiptsServiceBPEL_pt();
        ETT_PO_Output.OutputParameters_element response = new ETT_PO_Output.OutputParameters_element();
        ETT_PO_PORecp.Data_Header_type data = new ETT_PO_PORecp.Data_Header_type();
        list<ETT_PO_PORecp.Data_Lines_type> datalinesList = new List<ETT_PO_PORecp.Data_Lines_type>();
       
        ETT_PO_PORecp.MessageXml msg = new ETT_PO_PORecp.MessageXml();
        
        ETT_Purchase_Order__c Po = [select id,Name,CreatedDate,ETT_Account__r.Name,ETT_Account__c,ETT_Account__r.AccountNumber,ETT_Collection_Card__r.Name,ETT_CC_Remark__c from ETT_Purchase_Order__c where id=:recordId];
        string buyer = '';
        list<ETT_Purchase_Order_Line_Item__c> polines = [select id,Name,ETT_Item__c,ETT_Quantity__c,ETT_Unit_Price__c,(select id,Serial_Number__c from Tyre_Inventory__r where ETT_Inventory_Status__c='Inspected - Approved' ) from ETT_Purchase_Order_Line_Item__c where ETT_Purchase_Order__c=:recordId];
        user u = [select id,FederationIdentifier from user where id=:userInfo.getUserId()];
        
        if(u != null){
           
            if(u.FederationIdentifier != null){
              
                buyer = u.FederationIdentifier.split('@')[0] ;
            }
            
        }
         system.debug('-Buyer-'+buyer);
       
        CreatePOInOracleField__mdt CreatePo = [Select Inventory_Org_Code__c,Locator__c,Serial_Cont_Flag__c,Subinventory__c from CreatePOInOracleField__mdt where DeveloperName = 'CreatePoInOracleField'];
        data.TransactionDate = system.now().date();
        data.InventoryOrganizationCode= CreatePo.Inventory_Org_Code__c; //426;//hard coded
        data.SupplierNumber=Po.ETT_Account__r.AccountNumber;
        data.Buyer=  buyer;
        data.DocumentNumber=Po.ETT_Collection_Card__r.Name;
        data.Comments=Po.ETT_Account__r.Name;//+' '+Po.ETT_CC_Remark__c;
         
        integer i=1;
        for(ETT_Purchase_Order_Line_Item__c pol : polines){
            ETT_PO_PORecp.Data_Lines_type datalines = new ETT_PO_PORecp.Data_Lines_type();
            datalines.LineNo=i;
            datalines.ItemCode=pol.ETT_Item__c;
            datalines.QTY=pol.ETT_Quantity__c;
            datalines.UnitPrice= string.valueOf(pol.ETT_Unit_Price__c);
            datalines.SubInventory= CreatePo.Subinventory__c; //'AUH-TF-MS';//hard coded
            datalines.Locator= CreatePo.Locator__c; //'AUH-TF-MS.Used Tyres.0';//hard coded
            datalines.SerialControlFlag= CreatePo.Serial_Cont_Flag__c; //'Y';//hard coded
            
            List<ETT_PO_PORecp.SerialNumber_lines_element> serlineList = new list<ETT_PO_PORecp.SerialNumber_lines_element> ();
           
            for(ETT_Tyre_Inventory__c ti : pol.Tyre_Inventory__r){
                 ETT_PO_PORecp.SerialNumber_lines_element serline = new ETT_PO_PORecp.SerialNumber_lines_element ();
                 serline.SerialNumber = ti.Serial_Number__c;
                 serlineList.add(serline);
            }
            datalines.SerialNumber_lines = serlineList;
               
            datalinesList.add(datalines);
            i++;
        }
        
        msg.Data_Header = data;
        msg.Data_Lines_type = datalinesList;        
        
        try{
            response = req.process(msg);
        }catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETT_createPOInOracleCtrl', 'showData', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
            throw new AuraHandledException(ex.getMessage()); 
        }
        if(response != null){
            
            responseValues.put('PV_OUT_STATUS',response.PV_OUT_STATUS);
            responseValues.put('PV_OUT_ERRORMESSAGE',response.PV_OUT_ERRORMESSAGE);
            responseValues.put('PV_OUT_EBS_REF_NO',response.PV_OUT_EBS_REF_NO);
            if(response.PV_OUT_STATUS == 'Y'){
                ETT_Purchase_Order__c poUpdate = new ETT_Purchase_Order__c();
                poUpdate.Id = recordId;
                poUpdate.Oracle_PO_Number__c=response.PV_OUT_EBS_REF_NO;
                update poUpdate;
            }
            system.debug('-status-'+response.PV_OUT_STATUS);
            system.debug('-err-'+response.PV_OUT_ERRORMESSAGE);
        }
        
        system.debug(response);
        return  responseValues;
    }
   

}