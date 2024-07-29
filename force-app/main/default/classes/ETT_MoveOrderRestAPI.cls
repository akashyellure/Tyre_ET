public class ETT_MoveOrderRestAPI {
    public static void SendRequest(String ccId){
        System.debug('ccId >>> '+ccId);
        Map<Id,ETT_Collection_Card__c> ccIdVsCc = new Map<Id,ETT_Collection_Card__c>();
        //Map<Id,list<ETT_Tyre_Inventory__c>> ccIdVsTi = new Map<Id,list<ETT_Tyre_Inventory__c>>();
        Map<String,list<ETT_Tyre_Inventory__c>> icVsTi = new Map<String,list<ETT_Tyre_Inventory__c>>();
        for(ETT_Collection_Card__c cc : [SELECT Id,Name,CreatedDate,ETT_SubInventory_Code__c,Owner_ID__c,User_Employee_Number__c,ETT_Store_Name__r.ETT_Operating_Unit_Id__c, (SELECT Id,Name,Item_Code__c,Unit_Price__c FROM Tyre_Inventory__r) FROM ETT_Collection_Card__c WHERE Id =: ccId]){
            ccIdVsCc.put(cc.Id,cc);
            //ccIdVsTi.put(cc.Id,cc.Tyre_Inventory__r);
        }
        for(ETT_Tyre_Inventory__c ti : [SELECT Id,Name,Item_Code__c FROM ETT_Tyre_Inventory__c WHERE ETT_Collection_Card__c =: ccId]){
            if(!icVsTi.containsKey(ti.Item_Code__c))
                icVsTi.put(ti.Item_Code__c, new List<ETT_Tyre_Inventory__c>{ti});
            else if(icVsTi.containsKey(ti.Item_Code__c))
                icVsTi.get(ti.Item_Code__c).add(ti);
        }
        RequestResponseWrapper RequestResponseWrp = New RequestResponseWrapper();
        RequestWrapper requestWrp = New RequestWrapper();
        List<MoveOrderDtlWrapper> MoveOrderDtlWrpList = New List<MoveOrderDtlWrapper>();
        Integer loopCount = 0;
        if(icVsTi.Size() >= 0){
            for(String icode : icVsTi.keySet()){
                loopCount++;
                MoveOrderDtlWrapper MoveOrderDtlWrp = New MoveOrderDtlWrapper();
                MoveOrderDtlWrp.lineNo = String.valueOf(loopCount);
                System.debug(loopCount+' <<< loopCount');
                MoveOrderDtlWrp.itemCode = icode;
                if(icVsTi.containsKey(icode))
                    MoveOrderDtlWrp.quantity = String.ValueOf(icVsTi.get(icode).Size());
                MoveOrderDtlWrpList.add(MoveOrderDtlWrp);
            }
        }
        Move_Order_Field__mdt moveorder = [Select Organization_Code__c,Move_Order_Account__c,Description__c from Move_Order_Field__mdt where DeveloperName = 'CreateMoveOrderField'];
        List<MoveOrderHdrWrapper> MoveOrderHdrWrpList = New List<MoveOrderHdrWrapper>();
        MoveOrderHdrWrapper MoveOrderHdrWrp = New MoveOrderHdrWrapper();
        MoveOrderHdrWrp.organizationCode = moveorder.Organization_Code__c; 
        MoveOrderHdrWrp.description = moveorder.Description__c; 
        MoveOrderHdrWrp.moveOrderAccount = moveorder.Move_Order_Account__c; 
        if(ccIdVsCc.size() > 0 && ccIdVsCc.containsKey(ccId)){
            MoveOrderHdrWrp.organizationId = String.valueOf(ccIdVsCc.get(ccId).ETT_Store_Name__r.ETT_Operating_Unit_Id__c); //'345';
            MoveOrderHdrWrp.ownerId = ccIdVsCc.get(ccId).User_Employee_Number__c;
            MoveOrderHdrWrp.fromSubinventoryCode = ccIdVsCc.get(ccId).ETT_SubInventory_Code__c; //'DXB-RL-MW';
            MoveOrderHdrWrp.dateRequired = ccIdVsCc.get(ccId).CreatedDate.format('yyyy-MM-dd');//String.valueOf(ccIdVsCc.get(ccId).CreatedDate); //'2022-08-15';
            System.debug('CreatedDate >>> '+ccIdVsCc.get(ccId).CreatedDate.format('yyyy-MM-dd'));
        }
        MoveOrderHdrWrp.MoveOrderDtl = MoveOrderDtlWrpList;
        MoveOrderHdrWrpList.add(MoveOrderHdrWrp);
        InsertMoveOrderRequestWrapper InsertMoveOrderRequestWrp = New InsertMoveOrderRequestWrapper();
        InsertMoveOrderRequestWrp.MoveOrderHdr = MoveOrderHdrWrpList;
        requestWrp.InsertMoveOrderRequest = InsertMoveOrderRequestWrp;
        system.debug('requestWrp >>> '+requestWrp);
        HttpRequest request = new HttpRequest(); 
        HttpResponse response = new HttpResponse();
        Http http = new Http();  
        //request.setEndpoint('callout:ETT_MoveOrderCreateREST');
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('MoveOrder');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c);
            system.debug(connection.Dev_Endpoint__c);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c);
        }  
        //request.setEndpoint('https://etdevsoa.et.gov.ae/soa-infra/resources/EBS_Tyre_Integration/MoveOrder/MoveOrderCreateREST');
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('Authorization','Basic '+paramvalue);
        //request.setHeader('Content-Type','application/x-www-form-urlencoded');   
        //request.setHeader('Content-Type', 'application/json; ); 
        request.setHeader('Content-Type', 'application/json');      
        request.setBody(JSON.serialize(requestWrp));
        system.debug('order details >>> '+JSON.serialize(requestWrp)); 
        try{
            response = http.send(request);
            system.debug('getBody >>> '+response.getBody()); 
            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300 && response.getbody() != null) {
                RequestResponseWrp = (RequestResponseWrapper)JSON.deserialize(response.getBody(), RequestResponseWrapper.class);
                system.debug('RequestResponseWrp >>> '+RequestResponseWrp);
            }else{
                system.debug(response);
                //system.enqueueJob(new DebugLog(new DebugLog.LogError('ActiveDirectoryEmployeeBatch', 'ActiveDirectoryEmployee - callWebService', '', 'Active Directory Error : '+response.getStatusCode()+' : '+response.getBody(),null)));
            }
        }catch(Exception Ex){
            //system.enqueueJob(new DebugLog(new DebugLog.LogError('ActiveDirectoryEmployeeBatch', 'ActiveDirectoryEmployee - callWebService', '', 'Active Directory Error : '+Ex.getMessage(), Ex)));
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(Ex, 'TriggerHandler', 'createDNLinesInOracle', 'ETT_DeliveryNote', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
            //throw new AuraHandledException(ex.getMessage()); 
        }
        if(RequestResponseWrp != null){
            Integer maxSize = 255;
            ETT_Collection_Card__c cc = New ETT_Collection_Card__c();
            cc.Id = ccId;
            if(RequestResponseWrp.Status == 'S'){
                cc.MO_Request_Status__c = 'Success';
                cc.MO_Error_Msg__c = '';
                if(RequestResponseWrp.Reference.length() > maxSize )
                    cc.MO_EBS_Ref_No__c = RequestResponseWrp.Reference.substring(0, maxSize);
                else
                    cc.MO_EBS_Ref_No__c = RequestResponseWrp.Reference;
            }else if(RequestResponseWrp.Status == 'E'){
                cc.MO_Request_Status__c = 'Failed';
                cc.MO_EBS_Ref_No__c = '';
                if(RequestResponseWrp.Reference.length() > maxSize )
                    cc.MO_Error_Msg__c = RequestResponseWrp.Reference.substring(0, maxSize);
                else
                    cc.MO_Error_Msg__c = RequestResponseWrp.Reference;
            }
            Update cc; 
        }
    }
    public class RequestWrapper{
        public InsertMoveOrderRequestWrapper InsertMoveOrderRequest;
    }
    Public class InsertMoveOrderRequestWrapper{
        public List<MoveOrderHdrWrapper> MoveOrderHdr;
        Public InsertMoveOrderRequestWrapper(){
            MoveOrderHdr = New List<MoveOrderHdrWrapper>();
        }
    }
    Public class MoveOrderHdrWrapper{
        public String organizationCode;
        public String organizationId;
        public String ownerId;
        public String fromSubinventoryCode;
        public String description;
        public String moveOrderAccount;
        public String dateRequired;
        public List<MoveOrderDtlWrapper> MoveOrderDtl;
        public MoveOrderHdrWrapper(){
            MoveOrderDtl = New List<MoveOrderDtlWrapper>();
        }
    }
    Public class MoveOrderDtlWrapper{
        public String lineNo;
        public String itemCode;
        public String quantity;
    }
    public class RequestResponseWrapper{
        public String Status;  
        public String Reference;   
    }
}