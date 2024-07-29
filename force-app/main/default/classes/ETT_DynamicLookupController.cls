/*
Created Date:04-29-2020
Created By :G.Krishnareddy
Description:This is Dynamic Looku Controller Class
*/
public with sharing class ETT_DynamicLookupController {
    
    
    @AuraEnabled
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        for(sObject so : Database.Query('Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'')) {
            String fieldvalue = (String)so.get(fieldName);
            sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
        }
        
        return sObjectResultList;
    }
    
    
    
    @AuraEnabled
    public static Map<String,String> getFilteredResults(String ObjectName, String fieldName, String value, String brandName, String countryName, String patternName, String tyreSizeName) {        
        
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        Map<String,String> lookupMap = new Map<String,String>();
            
        System.debug('ObjectName: '+ObjectName);
        System.debug('brandName: '+brandName);
        System.debug('countryName: '+countryName);
        System.debug('patternName: '+patternName);
        System.debug('tyreSizeName: '+tyreSizeName);
        System.debug('fieldName: '+fieldName);
        System.debug('value: '+value);
        
        String queryStr;
        
        if(brandName==null){
            brandName='';
        }
        if(countryName==null){
            countryName='';
        }
        if(patternName==null){
            patternName='';
        }
        if(tyreSizeName==null){
            tyreSizeName='';
        }        
        if(ObjectName == 'ETT_Tyre_Size_Master__c'){
            //queryStr =  'SELECT Id, ETT_Tyre_Size__r.ETT_Tyre_Size__c From ETT_Tyre_Master__c where ETT_Tyre_Size__r.ETT_Status__c=true and ETT_Tyre_Size__r.ETT_Tyre_Size__c LIKE \'%' + value + '%\' ';
            //queryStr = queryStr+' and ETT_Brand_Name__r.Name LIKE \'%'+ brandName +'%\' and ETT_Original_Pattern__r.Name LIKE  \'%'+ patternName +'%\' and ETT_Country_Name__r.Name LIKE \'%'+ countryName +'%\'';
            queryStr =  'SELECT Id, ETT_Tyre_Size__r.Name From ETT_Tyre_Master__c where ETT_Tyre_Size__r.ETT_Status__c=true and ETT_Tyre_Size__r.Name LIKE \'%' + value + '%\' ';
            queryStr = queryStr+' and ETT_Brand_Name__r.Name LIKE \'%'+ brandName +'%\' and ETT_Original_Pattern__r.Name LIKE  \'%'+ patternName +'%\' and ETT_Country_Name__r.Name LIKE \'%'+ countryName +'%\'';
        }
        if(ObjectName == 'ETT_Country_Master__c'){
            queryStr =  'SELECT Id, ETT_Country_Name__r.Name  From ETT_Tyre_Master__c where ETT_Country_Name__r.ETT_Status__c=true and ETT_Country_Name__r.Name LIKE \'%' + value + '%\'';
            queryStr = queryStr+' and ETT_Brand_Name__r.Name LIKE \'%'+ brandName +'%\' and ETT_Original_Pattern__r.Name LIKE  \'%'+ patternName +'%\' and ETT_Tyre_Size__r.Name LIKE \'%'+ tyreSizeName +'%\'';
        }
        if(ObjectName == 'ETT_Brand_Master__c'){
            queryStr =  'SELECT Id, ETT_Brand_Name__r.Name From ETT_Tyre_Master__c where ETT_Brand_Name__r.ETT_Status__c=true and  ETT_Brand_Name__r.Name LIKE \'%'+ value +'%\'';
            queryStr = queryStr+' and ETT_Original_Pattern__r.Name LIKE  \'%'+ patternName +'%\' and ETT_Country_Name__r.Name LIKE \'%'+ countryName +'%\' and ETT_Tyre_Size__r.Name LIKE \'%'+ tyreSizeName +'%\'';
        }
        if(ObjectName == 'ETT_Pattern_Master__c'){
            queryStr =  'SELECT Id, ETT_Original_Pattern__r.Name From ETT_Tyre_Master__c where ETT_Original_Pattern__r.ETT_Status__c=true and  ETT_Original_Pattern__r.Name LIKE \'%'+ value +'%\' ';
            queryStr = queryStr+' and ETT_Brand_Name__r.Name LIKE \'%'+ brandName +'%\' and ETT_Country_Name__r.Name LIKE \'%'+ countryName +'%\' and ETT_Tyre_Size__r.Name LIKE \'%'+ tyreSizeName +'%\'';
        }
        
        System.debug('queryStr '+queryStr);
        
        for(ETT_Tyre_Master__c objTyreMstr : Database.query(queryStr)){
            
            if(fieldName == 'ETT_Tyre_Size__c'){

                //sObjectResultList.add(new SObjectResult(objTyreMstr.ETT_Tyre_Size__r.ETT_Tyre_Size__c, objTyreMstr.ETT_Tyre_Size__c));                
                //lookupMap.put(objTyreMstr.ETT_Tyre_Size__r.ETT_Tyre_Size__c, objTyreMstr.ETT_Tyre_Size__c);

                //sObjectResultList.add(new SObjectResult(objTyreMstr.ETT_Tyre_Size__r.Name, objTyreMstr.ETT_Tyre_Size__r.Name));                
                lookupMap.put(objTyreMstr.ETT_Tyre_Size__r.Name, objTyreMstr.ETT_Tyre_Size__c);
                
            }else if(fieldName == 'ETT_Country_Name__c'){
                //sObjectResultList.add(new SObjectResult(objTyreMstr.ETT_Country_Name__r.Name, objTyreMstr.ETT_Country_Name__c));                
                lookupMap.put(objTyreMstr.ETT_Country_Name__r.Name, objTyreMstr.ETT_Country_Name__c);
            }else if(fieldName == 'ETT_Brand_Name__c'){
                //sObjectResultList.add(new SObjectResult(objTyreMstr.ETT_Brand_Name__r.Name, objTyreMstr.ETT_Brand_Name__c));                
                lookupMap.put(objTyreMstr.ETT_Brand_Name__r.Name, objTyreMstr.ETT_Brand_Name__c); 
            }else if(fieldName == 'ETT_Original_Pattern__c'){
                //sObjectResultList.add(new SObjectResult(objTyreMstr.ETT_Original_Pattern__r.Name, objTyreMstr.ETT_Original_Pattern__c));                
                lookupMap.put(objTyreMstr.ETT_Original_Pattern__r.Name, objTyreMstr.ETT_Original_Pattern__c);
            }
            
        }
        
        System.debug('Map: ');
        System.debug(lookupMap);
        
        //System.debug('List: ');
        //System.debug(sObjectResultList);
        
        return lookupMap;
        //return sObjectResultList;
    }
    
    
    
    public class SObJectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }
    
    
}