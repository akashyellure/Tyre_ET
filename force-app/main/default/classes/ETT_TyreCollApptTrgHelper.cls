/**Author:Janardhan
 * Desc: If appointment approved creating Collection cards
 * CreatedDate: 22/11/2021
 * TestClass:ETT_TyreCollApptTrgHelperTest
 * 
 * */
public class ETT_TyreCollApptTrgHelper {
    
    
    public static void createCollCard(Map<id,Tyre_Collection_Appointment__c> newMap,Map<id,Tyre_Collection_Appointment__c> oldMap)  {
        
        list<ETT_Collection_Card__c> newCollCardList = new  list<ETT_Collection_Card__c>();
        map<id,string> oppIdVsRecTypeName = new map<id,string>();
        set<id> oppIdSet = new set<id>();
        
        for(Tyre_Collection_Appointment__c tc : newMap.values()){
            oppIdSet.add(tc.Opportunity__c);
        }
        for(Opportunity opp : [select id,recordType.Name from Opportunity where Id=:oppIdSet]){
            oppIdVsRecTypeName.put(opp.id,opp.RecordType.Name);
        }
        Set<Id> ccExistsTyreAppointment = new Set<Id>();
        for(Tyre_Collection_Appointment__c objTCA : [SELECT Id, (SELECT Id FROM Collection_Cards__r) FROM Tyre_Collection_Appointment__c WHERE Id IN: newMap.keySet()]){
            if(objTCA.Collection_Cards__r.size() > 0){
                ccExistsTyreAppointment.add(objTCA.Id);
            }
        }
        
        for(Tyre_Collection_Appointment__c tc : newMap.values()){
            
            if(tc.Status__c == 'Approved' && tc.Appointment_Type__c =='Collection' && tc.Status__c != oldMap.get(tc.Id).Status__c && !ccExistsTyreAppointment.contains(tc.Id)){
                
                ETT_Collection_Card__c objCollCard = new ETT_Collection_Card__c();
                objCollCard.ETT_Opportunity__c = tc.Opportunity__c;
                objCollCard.Collection_Appointment__c = tc.id;
                objCollCard.ETT_Collection_Status__c = 'Scheduled';
                objCollCard.ETT_Location__c = tc.Location__c;
                //objCollCard.ETT_Inspector__c = tc.id;
                if(oppIdVsRecTypeName.get(tc.Opportunity__c) == 'Tyre Supplier'){
                    objCollCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId();
                    objCollCard.ETT_Accounts__c = tc.Account__c;
                }else if(oppIdVsRecTypeName.get(tc.Opportunity__c) == 'Tyre Refurbishing Services'){
                    objCollCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
                    objCollCard.ETT_Accounts__c = tc.Account__c;
                }else if(tc.RecordTypeId == Schema.SObjectType.Tyre_Collection_Appointment__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId()){
                    objCollCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId();
                    objCollCard.ETT_Store_Name__c = tc.SubInventory__c;
                }else if(tc.RecordTypeId == Schema.SObjectType.Tyre_Collection_Appointment__c.getRecordTypeInfosByName().get('Tyre - Internal Private').getRecordTypeId()){
                    objCollCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal Private').getRecordTypeId();
                    objCollCard.ETT_Store_Name__c = tc.SubInventory__c;
                }
                newCollCardList.add(objCollCard);
            }            
            
        }        
        
        if(newCollCardList.size()>0 && newCollCardList != null){
            insert newCollCardList;
        }
    }
}