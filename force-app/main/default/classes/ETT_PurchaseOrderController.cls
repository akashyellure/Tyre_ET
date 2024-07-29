/*
  Created Date:08-29-2020
  Created by:G.Krishnareddy
  Description:Purchase Order confimration details by hoo and Recepnist
*/
public class ETT_PurchaseOrderController {
    
    //Approval accepcted by HOO and FM
    @auraenabled
    public static string purchaseOrderApprovalLineItems(list<ETT_Purchase_Order_Line_Item__c> lstPurchaseOrderLineItems){
        if(lstPurchaseOrderLineItems!=null && lstPurchaseOrderLineItems.size()>0){
            try{
                update lstPurchaseOrderLineItems;
                if(userinfo.getUserId()==system.label.ETT_InspectionCriteria_HOO || Test.isRunningTest()){
                    ETT_ProcessApprovelRequest.submitForApproval(new ETT_Purchase_Order__c(Id=lstPurchaseOrderLineItems[0].ETT_Purchase_Order__c));
                }
                if(userinfo.getUserId()==system.label.ETT_InspectionCriteria_FM || Test.isRunningTest()){
                integer i=0;
                if(lstPurchaseOrderLineItems!=null && lstPurchaseOrderLineItems.size()>0){
                    if(UserInfo.getUserId()==System.Label.ETT_InspectionCriteria_FM || Test.isRunningTest()){ 
                        for(ETT_Purchase_Order_Line_Item__c objPurchaseOrderLineItem :lstPurchaseOrderLineItems){
                             
                                if(objPurchaseOrderLineItem.ETT_Accepted_by_FM__c){
                                  i++;   
                                }  
                          }
                        
                        if(i==lstPurchaseOrderLineItems.size()){
                            ETT_ProcessApprovelRequest.approveRecord(new ETT_Purchase_Order__c(Id=lstPurchaseOrderLineItems[0].ETT_Purchase_Order__c));
                            lstPurchaseOrderLineItems = [select Id,ETT_Purchase_Order__r.ETT_Collection_Card__c
                                                         from ETT_Purchase_Order_Line_Item__c where Id in :lstPurchaseOrderLineItems]; 
                            
                            list<ETT_Inspection_Card__c> lstTyreInspectionCards = [select Id,ETT_Account__r.Party_Type__c, ETT_Account__c,ETT_Brand__c,ETT_Account__r.Phone,
                                                                                   ETT_Account__r.BillingStreet,ETT_Status__c,ETT_Collection_Card__r.ETT_Vehicle_Detail__r.Name,
                                                                                   ETT_Tyre_Size__c, ETT_Tyre_Serial_Number__c, ETT_Pattern__c, ETT_Collection_Card__c
                                                                                   from ETT_Inspection_Card__c
                                                                                  where ETT_Collection_Card__c=:lstPurchaseOrderLineItems[0].ETT_Purchase_Order__r.ETT_Collection_Card__c];
                            list<ETT_Delivery_Note__c> lstDeliveryNotes = new list<ETT_Delivery_Note__c>();
                            if(lstTyreInspectionCards!=null && lstTyreInspectionCards.size()>0){
                                for(ETT_Inspection_Card__c objInspectionCard :lstTyreInspectionCards){
                                    if(objInspectionCard.ETT_Status__c=='Send Back'){
                                        Contact objContact = [select Id from contact where AccountId=:objInspectionCard.ETT_Account__c];
                                        ServiceAppointment objDeliveryAppointment = new ServiceAppointment();
                                        //objDeliveryAppointment.AccountId = objInspectionCard.ETT_Account__c;
                                        objDeliveryAppointment.ContactId = objContact.Id;
                                        
                                        ETT_Delivery_Note__c objDeliveryNote   = new ETT_Delivery_Note__c();
                                        objDeliveryNote.ETT_Account__c         = objInspectionCard.ETT_Account__c;
                                        objDeliveryNote.ETT_Address__c         = objInspectionCard.ETT_Account__r.BillingStreet;
                                        objDeliveryNote.ETT_Brand_Name__c      = objInspectionCard.ETT_Brand__c;
                                         if(objDeliveryNote.ETT_Account__r.Party_Type__c == 'Supplier'){
                                                 objDeliveryNote.ETT_Casing__c  = 'Supplier Casing';
                                             }
                                             else if(objDeliveryNote.ETT_Account__r.Party_Type__c == 'Customer'){
                                                 objDeliveryNote.ETT_Casing__c  = 'Customer Casing';
                                             }
                                        //objDeliveryNote.ETT_Casing__c          = 'Supplier Casing';
                                        objDeliveryNote.ETT_Collection_Card__c = objInspectionCard.ETT_Collection_Card__c;
                                        objDeliveryNote.ETT_Pattern_Size__c    = objInspectionCard.ETT_Pattern__c;
                                        objDeliveryNote.ETT_Phone__c           = objInspectionCard.ETT_Account__r.Phone;
                                        objDeliveryNote.ETT_Reference__c       = '';
                                        objDeliveryNote.ETT_Serial_Number__c   = objInspectionCard.ETT_Tyre_Serial_Number__c;
                                        objDeliveryNote.ETT_Tyre_Size__c       = objInspectionCard.ETT_Tyre_Size__c;
                                        objDeliveryNote.ETT_Vehicle_Number__c  = objInspectionCard.ETT_Collection_Card__r.ETT_Vehicle_Detail__r.Name;
                                        lstDeliveryNotes.add(objDeliveryNote);
                                    }
                                }
                            }
                            
                            if(lstDeliveryNotes!=null && lstDeliveryNotes.size()>0){
                                try{
                                    insert lstDeliveryNotes;
                                }Catch(Exception ex){
                                    system.debug('****Exception Cause *****'+ex.getMessage());
                                }
                            }
                        }
                     
                    }
                }
              }
            }Catch(Exception ex){
                system.debug('****Exception Causue ****'+ex.getMessage());
                throw new AuraHandledException(ex.getMessage()); 
            }
          
        }
        return ''; 
    }
    
    //This is for Drafted the Purchase Order list should need to send to Submit for Approval for HOO,FM
    @AuraEnabled
    public static list<ETT_Purchase_Order_Line_Item__c> lstPurchaseLineItems(string strPurchaseOrderId){
        
        return [select Id,ETT_Delivery_Date__c,ETT_Description__c,ETT_Item__c,ETT_Line_Amount__c,ETT_Quantity__c,ETT_Total_Amount__c,ETT_Type__c,
                ETT_Unit_Price__c,ETT_UOM__c,ETT_Vat_Amount__c,ETT_Vat_Percentage__c from ETT_Purchase_Order_Line_Item__c where ETT_Purchase_Order__c =:strPurchaseOrderId and RecordType.Name='Tyre - Cash Supplier Purchase Order Line Item Draft'];
        
    }

}