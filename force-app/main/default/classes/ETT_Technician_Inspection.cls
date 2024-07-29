public class ETT_Technician_Inspection {
    @AuraEnabled
    public static List < String > getselectOptions() {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = ETT_Inspection_Card__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values =
            fieldMap.get('ETT_Tyre_Life__c').getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    @AuraEnabled
    public static void savefile() {
        
    }
}