/**
 * Author:Janardhan
 * Desc:
 * Created Date:5/12/2021
 * 
 * 
 **/
public class ETT_POEstimationCtrl {
    
    @auraEnabled
    public static list<ETT_Inspection_Card__c> getTyreInspectionCCDetails(string recordId){
        
        return [select id,Name,Tyre_Inventory__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Brand__r.Name,Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.ETT_Country__r.Name,
                Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.Item_Code__c,Purchase_Price__c,Tyre_Inventory__r.Purchase_Price__c,TempQuantity__c,ETT_Status__c from ETT_Inspection_Card__c where ETT_Collection_Card__c=:recordId];
    }
    
    @auraEnabled
    public static void createPOAndLines(string recordId,list<ETT_Inspection_Card__c> updateInsCC,list<ETT_Inspection_Card__c> itemCodeGroup){
        
        list<ETT_Purchase_Order_Line_Item__c> polinesList = new list<ETT_Purchase_Order_Line_Item__c>();
        map<string,id> itemCodeVsPolId = new map<string,id>();
        Savepoint sp = Database.setSavepoint();
        
        try{
            ETT_Collection_Card__c cc = [select id,PO_Created__c,ETT_Accounts__c,ETT_Accounts__r.BillingStreet,ETT_Accounts__r.Fax,ETT_Accounts__r.ETT_Email__c from ETT_Collection_Card__c where id=:recordId];
            cc.PO_Created__c = true;
            update cc;
            
            if(updateInsCC.size()>0 && updateInsCC != null){
                
                update updateInsCC;
            }
            if(itemCodeGroup.size()>0 && itemCodeGroup != null){
                ETT_Purchase_Order__c po = new ETT_Purchase_Order__c();
                po.ETT_Account__c = cc.ETT_Accounts__c;
                po.ETT_Collection_Card__c = recordId;
                po.ETT_Address__c = cc.ETT_Accounts__r.BillingStreet;
                po.ETT_Type__c = 'Standard Purchase Order';
                po.ETT_Status__c = 'New';
                po.ETT_Payment_Terms__c = 'Immediate';
                po.ETT_Fax__c = cc.ETT_Accounts__r.Fax;
                po.ETT_Email__c = cc.ETT_Accounts__r.ETT_Email__c;
                
                insert po;
                
                for(ETT_Inspection_Card__c item : itemCodeGroup){
                    
                    ETT_Purchase_Order_Line_Item__c pol = new ETT_Purchase_Order_Line_Item__c();
                    pol.ETT_Purchase_Order__c = po.Id;
                    pol.ETT_Quantity__c = item.TempQuantity__c;
                    pol.ETT_UOM__c = 'Numbers';
                    pol.ETT_Unit_Price__c = item.Purchase_Price__c;
                    pol.ETT_Item__c = item.Tyre_Inventory__r.Item_Code__c; 
                    polinesList.add(pol);
                    
                }
                insert polinesList;
                
                
                for(ETT_Purchase_Order_Line_Item__c pol :[select id,ETT_Item__c from ETT_Purchase_Order_Line_Item__c where ETT_Purchase_Order__r.ETT_Collection_Card__c=:recordId]){
                    
                    itemCodeVsPolId.put(pol.ETT_Item__c,pol.id);
                }
                list<ETT_Tyre_Inventory__c> updatedTyreInvList = new list<ETT_Tyre_Inventory__c>();
                for(ETT_Tyre_Inventory__c tyre : [select id,Item_Code__c from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:recordId]){
                    
                    if(itemCodeVsPolId.containskey(tyre.Item_Code__c)){
                        tyre.PO_Line__c = itemCodeVsPolId.get(tyre.Item_Code__c);
                        updatedTyreInvList.add(tyre);
                    }
                }
                update updatedTyreInvList;
                
            }
            
            
            
            
        }catch(Exception e) {
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());   
            
        }
    }
       @AuraEnabled
    public static user getUserInfo(){
        return [Select id,Name,profile.Name from user where Id=:userinfo.getUserId()];
    }
    
}