public class ETT_FleetInspectionController {
    @AuraEnabled
    public static Account getAccountInfo(Id accountId){
        Account acc = [Select id, Name,Party_Type__c from Account Where Id=:accountId];
        return acc;
    }
    
     @AuraEnabled
    public static String getVehicleNumber(String internalNo){
       String VehicleNumber = '';
        List<ETT_Vehicle_Details__c> VehicleDetaillist  = [Select id ,Name from ETT_Vehicle_Details__c Where ETT_Internal_Number__c =:internalNo] ;
        if(VehicleDetaillist.Size()>0){
            VehicleNumber = VehicleDetaillist[0].Name;
 }
       return VehicleNumber;
    }

     @AuraEnabled
    public static Map<String, String> getselectOptions(sObject objObject, string fld) {
        
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
            options.put(a.getValue(), a.getLabel());
        }
        
        allOpts.sort();
        System.debug(options);
        return options;
    }
    
     @AuraEnabled
    public static string saveDMLForFleetInspection(map<string,string> mapofStageJsonList){
        system.debug('*****mapofStageJsonList*******'+mapofStageJsonList);
        Account objAccount;
        ETT_Fleet_Inspection__c FleetInspection;
        list<ETT_FleetInspectionWrapper> lstFleetInspectionWrapper;
        list<ETT_Staging_Test_Tyre__c> lstStgTestTyres;
        list<ContentVersion> lstContentVesions = new list<ContentVersion>();
        list<ContentDocumentLink> lstContentDocumentLinks = new list<ContentDocumentLink>();
        map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
        if(mapofStageJsonList.containskey('stgAccountJson')){
            objAccount = (Account) JSON.deserialize(mapofStageJsonList.get('stgAccountJson'),Type.forname('Account'));
        }
       
        if(mapofStageJsonList.containsKey('stgFleetInspectionJson')){
            
            FleetInspection = (ETT_Fleet_Inspection__c)JSON.deserialize(mapofStageJsonList.get('stgFleetInspectionJson'),Type.forname('ETT_Fleet_Inspection__c'));
          System.debug('FleetInspection'+FleetInspection);
        }
       
        
        if(mapofStageJsonList.containsKey('stgFleetInspectionLineItemJson')){
            lstFleetInspectionWrapper = (list<ETT_FleetInspectionWrapper>)JSON.deserialize(mapofStageJsonList.get('stgFleetInspectionLineItemJson'),Type.forname('list<ETT_FleetInspectionWrapper>')); 
            System.debug('listoflineitem'+lstFleetInspectionWrapper);
        }
        
        if(objAccount!=null){
         
            list<Sobject> lstSobjectInformation = new list<Sobject>();
            list<Sobject> lstUpdateSobjectInformation = new list<Sobject>();
            
            if(objAccount.Id!=null){
              //Staging Fleet Inspection
              if(FleetInspection.id==null){
                  FleetInspection.ETT_Account__c = objAccount.Id;
                    insert FleetInspection;
                  
                  //Staging Fleet Inspection
                if(lstFleetInspectionWrapper!=null && lstFleetInspectionWrapper.size()>0){
                  //  List<>
               
                    for(ETT_FleetInspectionWrapper objStgFleetInspectionWrapper : lstFleetInspectionWrapper){
                      
                        if(objStgFleetInspectionWrapper.objFleetInspection!=null){
                             
                            objStgFleetInspectionWrapper.objFleetInspection.Fleet_Inspection__c = FleetInspection.id;
                            objStgFleetInspectionWrapper.objFleetInspection.FileSourceTemp__c = objStgFleetInspectionWrapper.fileSourceType;
                            lstSobjectInformation.add((Sobject)objStgFleetInspectionWrapper.objFleetInspection);
                           
                        }
                    }
                }
                  
                }
                Map<String,Id> inspectionLineItemMap = new Map<String,Id>();
           
                if(lstSobjectInformation!=null && lstSobjectInformation.size()>0){
                    System.debug('after document insertion10');
                     upsert lstSobjectInformation; 
                    List<Fleet_Inspection_Line_Item__c> inspectionLineItemsList = [Select id,ETT_Tread_Depth_Original__c,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Pattern__c,FileSourceTemp__c from Fleet_Inspection_Line_Item__c where ID IN:lstSobjectInformation];
                        List<ETT_Tyre_Master__c> tyreDetails = [SELECT id,Name,ETT_Original_Depth__c,ETT_Tyre_Size__c,ETT_Brand_Name__c,ETT_Original_Pattern__c FROM ETT_Tyre_Master__c];
        			 List<ETT_Tyre_Master__c> updatetyreDetails = new  List<ETT_Tyre_Master__c>();
                    for(Fleet_Inspection_Line_Item__c insLItem:inspectionLineItemsList)
                    {
                        inspectionLineItemMap.put(insLItem.FileSourceTemp__c, insLItem.id);
                            if(insLItem.ETT_Tyre_Size__c!=null&&insLItem.ETT_Brand__c!=null&&insLItem.ETT_Pattern__c!=null)
                        {
                            for(ETT_Tyre_Master__c tyremaster :tyreDetails )
                            {
                                
                                if(tyremaster.ETT_Tyre_Size__c==insLItem.ETT_Tyre_Size__c &&
                                   tyremaster.ETT_Brand_Name__c==insLItem.ETT_Brand__c  && 
                                   tyremaster.ETT_Original_Pattern__c==insLItem.ETT_Pattern__c &&
                                   insLItem.ETT_Tread_Depth_Original__c!=null&&
                                   (tyremaster.ETT_Original_Depth__c==null||tyremaster.ETT_Original_Depth__c==''))
                                {
                                    ETT_Tyre_Master__c updatetyremaster = tyremaster;
                                   updatetyremaster.ETT_Original_Depth__c =  insLItem.ETT_Tread_Depth_Original__c;
                                    
                                    updatetyreDetails.add(updatetyremaster);
                                    break;
                                }
                                
                            } 
                        }
                    
                    }
                       System.debug('lstSobjectInformationertion'+lstSobjectInformation);
                      if(updatetyreDetails.size()>0)
                    {
                        update updatetyreDetails;
                    }

                }

                map<string,string> mapofFleNamewithFleetInspectionIds = new map<string,string>();
                if(lstFleetInspectionWrapper!=null && lstFleetInspectionWrapper.size()>0){
                    System.debug('inside if files');
                   for(ETT_FleetInspectionWrapper objStgFleetInspectionWrapper : lstFleetInspectionWrapper){
                       System.debug('inside for files');
                       if(objStgFleetInspectionWrapper.lstFileLoadWrapper!=null)
                       {
                         for(ETT_FileUploadWrapper  objFileUploadWrapper :objStgFleetInspectionWrapper.lstFileLoadWrapper){
                            ContentVersion objContentVersion = new ContentVersion();
                            objContentVersion.ContentLocation = 'S';
                            objContentVersion.VersionData = EncodingUtil.base64Decode(objFileUploadWrapper.strBase64Data);
                            objContentVersion.Title = objFileUploadWrapper.strFileName;
                           // objContentVersion.PathOnClient = objFileUploadWrapper.strFileType;
                             String tempNameStr = objFileUploadWrapper.strFileName;
                             List<String> filenamesbreak = tempNameStr.split('\\.');
                             DateTime dt = DateTime.now();
                             String suffix = dt.format('hh_mm_ss') + '_'+dt.millisecond();
                             String imagenamewithsuffix = filenamesbreak[0] +'_'+suffix+'.'+filenamesbreak[1];
                             objContentVersion.Title = imagenamewithsuffix;
                             //objContentVersion.PathOnClient = objFileUploadWrapper.strFileType;
                             objContentVersion.PathOnClient = imagenamewithsuffix;
            
                            //objContentVersion.PathOnClient = objFileUploadWrapper.strFileName;
                            lstContentVesions.add(objContentVersion);
                           Id inspectionLineItemId = inspectionLineItemMap.get(objStgFleetInspectionWrapper.fileSourceType);
                           System.debug('get id by filesource='+inspectionLineItemId);
                            System.debug('get id by name='+objFileUploadWrapper.strFileName);
                             System.debug('get id by id='+objStgFleetInspectionWrapper.objFleetInspection.Id);
                            mapofFleNamewithFleetInspectionIds.put(imagenamewithsuffix,objStgFleetInspectionWrapper.objFleetInspection.Id);
                       //     mapofFleNamewithFleetInspectionIds.put(objFileUploadWrapper.strFileName,inspectionLineItemId);
                        }  
                       }
                       
                      }
                   } 
                
        
                if(lstContentVesions!=null && lstContentVesions.size()>0){
                   // insert lstContentVesions;
                     try{
                    insert lstContentVesions;
                         System.debug('inserted sucessfully');
                }Catch(Exception ex){
                    system.debug('****Exception Cause'+ex.getMessage());
                }
                   System.debug('after document insertion');
                    
                    for(ContentVersion objContentVersion :[Select Id,ContentDocumentId,Title from ContentVersion where Id in :lstContentVesions]){
                      mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
                    }
                        System.debug('after document insertion2');
                    for(ContentVersion objContentVersion :lstContentVesions){
                            System.debug('after document insertion3');
                        ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                             System.debug('after document insertion4.Title='+objContentVersion.Title);
                        System.debug('get id from Map='+mapofFleNamewithFleetInspectionIds.get(objContentVersion.Title));
                        objContentDocumentLink.LinkedEntityId = mapofFleNamewithFleetInspectionIds.containsKey(objContentVersion.Title)?mapofFleNamewithFleetInspectionIds.get(objContentVersion.Title):null;
                      //        objContentDocumentLink.LinkedEntityId = inspectionLineItemMap.containsKey(objContentVersion.Title)?mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Title):null;
                            System.debug('after document insertion5');
                        objContentDocumentLink.ShareType = 'V';
                             System.debug('after document insertion6');
                        //objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.containsKey(objContentVersion.Id)?mapofFleNamewithFleetInspectionIds.get(objContentVersion.Id):null;
                             objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.containsKey(objContentVersion.Id)?mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id):null;
                           System.debug('after document insertion7');
                        lstContentDocumentLinks.add(objContentDocumentLink);
                       
                    }
                      
                    if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
                          
                        insert lstContentDocumentLinks;
                          
                    }
                  }
                  if(objAccount!=null && objAccount.Id!=null){
                    return objAccount.Id;
                }
              
             }
        }
        return '';
    }
    //Added By Goldy Singh
     @AuraEnabled
    public static String getPressure(String tyreSize,String VehicleType)
    {
     String pressure = '';
        
        List<ETT_Tyre_Pressure_Information__mdt> entList = [SELECT DeveloperName, Label,Tyre_Pressure__c FROM ETT_Tyre_Pressure_Information__mdt ];
        
        for(ETT_Tyre_Pressure_Information__mdt meta:entList)
        {
            String label = meta.Label;
             if(label.contains(VehicleType)&&label.contains(tyreSize))   
            {
                pressure = meta.Tyre_Pressure__c;
            }
        }
        return pressure;
    }
     //Added By Goldy Singh
     @AuraEnabled
    public static String getOriginalDepth(String tyreSize,String tyreBrand, String tyrePattern)
    {
        String OriginalDepth = '';
        List<ETT_Tyre_Master__c> tyreDetails = [SELECT id,Name,ETT_Original_Depth__c FROM ETT_Tyre_Master__c where ETT_Tyre_Size__c=:tyreSize and ETT_Brand_Name__c=:tyreBrand and ETT_Original_Pattern__c=:tyrePattern ];
        System.debug('tyreDetails='+tyreDetails);
        if(tyreDetails.Size()>0)
        {
            OriginalDepth =  tyreDetails[0].ETT_Original_Depth__c;
        }
        
        return OriginalDepth;
    }
}