public class ETT_opportunity_RecordType_Controller {
    
    /*
    @AuraEnabled
    public static string findRecordTypes(string objName){
        string returnString='';
        string queryString='Select id, name from RecordType where sobjectType =: objName AND IsActive=true';
        List<sobject> recordList= Database.query(queryString);
        List<RecordTypeWrapper> wrapperList=new List<RecordTypeWrapper>();
        for(sobject sb : recordList)  {
            String recordtypeName = string.valueof(sb.get('name'));
            if(recordtypeName.contains('Tyre'))
            {
                RecordTypeWrapper rw=new RecordTypeWrapper();
                rw.recordTypeLabel=string.valueof(sb.get('name'));
                rw.recordTypeId=string.valueof(sb.get('id'));
                wrapperList.add(rw);
            }
            
        } 
        returnString= JSON.serialize(wrapperList);
        system.debug('*****'+returnString);
        return returnString;
    }
    public class RecordTypeWrapper{
        public string recordTypeLabel{get;set;}
        public string recordTypeId{get;set;}
    }
    */
    
    @AuraEnabled
    public static Map<String,String> GetAvailableRecordTypeAccount()
    {
        Map<String,String> recordTypeMap = new Map<String,String>();
        Schema.DescribeSObjectResult R = Opportunity.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        
        for(RecordType rec : [SELECT Id,  Name, DeveloperName, Description FROM RecordType WHERE SobjectType = 'Opportunity' and (Name like '%Supplier%' or Name like '%Service%' or Name like '%Individual%')]) {
            recordTypeMap.put(rec.Name, rec.Id);
            system.debug('recordtype' + recordtypemap);
        }
        return recordTypeMap;
    }   
    
}