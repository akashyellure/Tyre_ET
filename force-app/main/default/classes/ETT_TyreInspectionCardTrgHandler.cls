/**
 * Created By: Janardhan Muddana
 * Created Date:25/02/2022
 * Description :
 * Test Class: ETT_TyreInspectionCardTrgHandlerTest
 * */
public class ETT_TyreInspectionCardTrgHandler {
    
    public static void InspectionConfirmationUpdate(Map<Id,ETT_Inspection_Card__c> trgNewMap,Map<Id,ETT_Inspection_Card__c> trgOldMap){
     
      set<id> CCIdSet = new set<id>();
      Map<Id,Decimal> CCIDVsTotalInsCards = new Map<Id,Decimal>();
      Map<Id,Decimal> CCIDVsNotInspCount = new Map<Id,Decimal>();
      Map<Id,Decimal> CCIDVsAcceptedCount = new Map<Id,Decimal>();
      Map<Id,Decimal> CCIDVsSendBackCount = new Map<Id,Decimal>();
      list<ETT_Collection_Card__c> cclist = new list<ETT_Collection_Card__c>();
        
        for(ETT_Inspection_Card__c ic : trgNewMap.values()){
            CCIdSet.add(ic.ETT_Collection_Card__c);
        }
      
        for(AggregateResult ar : [select count(id) CountVal,ETT_Collection_Card__c ColCard from ETT_Inspection_Card__c where ETT_Collection_Card__c =:CCIdSet group by ETT_Collection_Card__c]){
            CCIDVsTotalInsCards.put((Id)ar.get('ColCard'),(Decimal)ar.get('CountVal'));
         }
        for(AggregateResult ar : [select count(id) CountVal,ETT_Collection_Card__c ColCard from ETT_Inspection_Card__c where ETT_Collection_Card__c =:CCIdSet AND ETT_Status__c='Not Inspected' group by ETT_Collection_Card__c]){
            CCIDVsNotInspCount.put((Id)ar.get('ColCard'),(Decimal)ar.get('CountVal'));
         }
        for(AggregateResult ar : [select count(id) CountVal,ETT_Collection_Card__c ColCard from ETT_Inspection_Card__c where ETT_Collection_Card__c =:CCIdSet AND ETT_Status__c='Accept' group by ETT_Collection_Card__c]){
            CCIDVsAcceptedCount.put((Id)ar.get('ColCard'),(Decimal)ar.get('CountVal'));
         }
        for(AggregateResult ar : [select count(id) CountVal,ETT_Collection_Card__c ColCard from ETT_Inspection_Card__c where ETT_Collection_Card__c =:CCIdSet AND ETT_Status__c='Send Back' group by ETT_Collection_Card__c]){
            CCIDVsSendBackCount.put((Id)ar.get('ColCard'),(Decimal)ar.get('CountVal'));
         }
        
        for(ETT_Inspection_Card__c ic : trgNewMap.values()){
            
            if((ic.ETT_Status__c == 'Accept' || ic.ETT_Status__c == 'Send Back') && trgOldMap.get(ic.Id).ETT_Status__c=='Pending'){
                
                decimal notInspectedCount = CCIDVsNotInspCount.containskey(ic.ETT_Collection_Card__c)?CCIDVsNotInspCount.get(ic.ETT_Collection_Card__c):0;
                decimal totalCount = CCIDVsTotalInsCards.containskey(ic.ETT_Collection_Card__c)?CCIDVsTotalInsCards.get(ic.ETT_Collection_Card__c):0;
                decimal acceptCount = CCIDVsAcceptedCount.containskey(ic.ETT_Collection_Card__c)?CCIDVsAcceptedCount.get(ic.ETT_Collection_Card__c):0;
                decimal sendBackCount = CCIDVsSendBackCount.containskey(ic.ETT_Collection_Card__c)?CCIDVsSendBackCount.get(ic.ETT_Collection_Card__c):0;
                
                if(notInspectedCount == 0 && totalCount == (acceptCount+sendBackCount)){
                    
                    ETT_Collection_Card__c ccItem = new ETT_Collection_Card__c();
                    ccItem.Id =  ic.ETT_Collection_Card__c;
                    ccItem.ETT_Inspection_Done__c = true;
                    cclist.add(ccItem);
                }    

            }
        }
        
        update cclist;
        
        
    }

}