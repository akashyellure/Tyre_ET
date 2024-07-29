/*
Created Date:12-01-2020
Created By:Shweta Shinde
Description :This is to set Priorities of Tyre Inspection Card.
*/
public class ETT_TyreInspectionCard {
    
    @auraenabled
    public static list<ETT_Inspection_Card__c> getInspetionCardDetails(){
        
        return [SELECT Id, Name, ETT_Collection_Card__r.Name, ETT_Tyre_Size__r.Name, ETT_Priority__c,
                ETT_Brand__r.Name,ETT_Pattern__r.Name,ETT_Country__r.Name,ETT_Status__c FROM ETT_Inspection_Card__c where ETT_Status__c='Not Inspected' order by Name asc];
        
    }
    
    @auraenabled
    public static void updateInspectionCardPriority(list<ETT_Inspection_Card__c> lstInspectionCard){
        
        if(lstInspectionCard!=null && lstInspectionCard.size()>0){
            try{
                update lstInspectionCard;
            }
            catch(Exception ex){
                System.debug('Exception: '+ex.getCause());
            }
        }        
    }
    
    @AuraEnabled
    public static Map<String, String> getselectOptions(string fld) {
        
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        
        Schema.sObjectType objType = ETT_Inspection_Card__c.getSObjectType();
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
    
    
}