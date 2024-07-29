/*
Created By  :G.Krishnareddy
Create Date :15/05/2020
Description :Pricing Information data
*/
public class ETT_PricingInformationTriggerHandler {
    
    public static boolean isRecursive = true; 
    
    //This is creating the Updated  Price History new records whenever the price changes happening 
    public static void pricingInformationHandleUpdate(map<Id,ETT_Pricing_Information__c> mapOfNewPricingInformations,map<Id,ETT_Pricing_Information__c> mapOfOldPricingInformations){
        list<Sobject> lstNewObjects = new list<Sobject>();
        
        //Preparing the Event Logs and Pricining Information History Preparation
        for(ETT_Pricing_Information__c objNewPricingInformation :[Select Id,ETT_Price__r.ETT_Party_Name__r.Party_Type__c,
                                                                  ETT_Buying_Approval_Status__c,ETT_Repair_Price_Approval_Status__c,
                                                                  ETT_Retread_H_Price_Approval_Status__c,
                                                                  ETT_Retread_Price_P_Approval_Status__c,ETT_Scrap_Price_Approval_Status__c,
                                                                  ETT_Selling_Price_H_Approval_Status__c,ETT_Selling_Price_P_Approval_Status__c,
                                                                  ETT_Buying_Price__c,ETT_Buying_Price_Comments__c,
                                                                  ETT_Repair_Price__c,ETT_Repair_Price_Comments__c,
                                                                  ETT_Retread_Price_H__c,ETT_Retread_Price_H_Comments__c,
                                                                  ETT_Retread_Price_P__c,ETT_Retread_Price_P_Comments__c,
                                                                  ETT_Scrap_Price__c,ETT_Scrap_Price_Comments__C,
                                                                  ETT_Selling_Price_H__c,ETT_Selling_Price_H_Comments__c,
                                                                  ETT_Selling_Price_P__c,ETT_Selling_Price_P_Comments__c,
                                                                  ETT_Purchase_Agreed_Price__c,
                                                                  ETT_Old_Buying_Price__c,ETT_New_Buying_Price__c,
                                                                  ETT_Old_Repair_Price__c,ETT_New_Repair_Price__c,
                                                                  ETT_Old_Retread_Price_H__c,ETT_New_Retread_Price_H__c,
                                                                  ETT_Old_Retread_Price_P__c,ETT_New_Retread_Price_P__c,
                                                                  ETT_New_Scrap_Price__c,ETT_Old_Scrap_Price__c,
                                                                  ETT_New_Selling_Price_H__c,ETT_Old_Selling_Price_H__c,
                                                                  ETT_New_Selling_Price_P__c,ETT_Old_Selling_Price_P__c
                                                                  FROM ETT_Pricing_Information__c where Id in :mapOfNewPricingInformations.keyset()]){ 
                                                                      
        System.debug(objNewPricingInformation);
        System.debug(mapOfOldPricingInformations);
                                                                      
                                                                      if(objNewPricingInformation.ETT_Buying_Price__c!=null && objNewPricingInformation.ETT_Buying_Price__c!=mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Buying_Price__c 
                                                                         && objNewPricingInformation.ETT_Buying_Approval_Status__c=='Approved'){ 
                                                                             objNewPricingInformation.ETT_Old_Buying_Price__c = mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Buying_Price__c;
                                                                             PricingHistoryWrapper objPriningHistoryWraper = PricingHistoryWrapper.objPricingHistoryObj('ETT_Old_Buying_Price__c',mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Buying_Price__c,
                                                                                                                                                                        'ETT_New_Buying_Price__c',objNewPricingInformation.ETT_Buying_Price__c,'ETT_Buying_Changed_Date__c',DateTime.now(),
                                                                                                                                                                        'ETT_Pricing_Information__c',objNewPricingInformation.Id,'ETT_Buying_Comments__c',objNewPricingInformation.ETT_Buying_Price_Comments__c,objNewPricingInformation.ETT_Price__r.ETT_Party_Name__r.Party_Type__c,
                                                                                                                                                                        'ETT_Is_Buying_Price__c',true);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objEventLog);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objPricingHistory);
                                                                         }
                                                                      else if(objNewPricingInformation.ETT_Buying_Approval_Status__c=='Rejected'
                                                                              && mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Buying_Approval_Status__c!=objNewPricingInformation.ETT_Buying_Approval_Status__c){
                                                                                  priceResetHandleUpdates(objNewPricingInformation, 'ETT_New_Buying_Price__c', 'ETT_Old_Buying_Price__c', objNewPricingInformation.ETT_Old_Buying_Price__c, objNewPricingInformation.ETT_Buying_Price_Comments__c,'ETT_Buying_Approval_Status__c');
                                                                              }
                                                                      
                                                                      
                                                                      
                                                                      if(objNewPricingInformation.ETT_Repair_Price__c!=null && objNewPricingInformation.ETT_Repair_Price__c!=mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Repair_Price__c
                                                                         && objNewPricingInformation.ETT_Repair_Price_Approval_Status__c=='Approved'){
                                                                             objNewPricingInformation.ETT_Old_Repair_Price__c = mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Repair_Price__c;
                                                                             PricingHistoryWrapper objPriningHistoryWraper = PricingHistoryWrapper.objPricingHistoryObj('ETT_Old_Repair_Price__c',mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Repair_Price__c,
                                                                                                                                                                        'ETT_New_Repair_Price__c',objNewPricingInformation.ETT_Repair_Price__c,'ETT_Repair_Changed_Date__c',DateTime.now(),
                                                                                                                                                                        'ETT_Pricing_Information__c',objNewPricingInformation.Id,'ETT_Repair_Price_Comments__c',objNewPricingInformation.ETT_Repair_Price_Comments__c,objNewPricingInformation.ETT_Price__r.ETT_Party_Name__r.Party_Type__c,
                                                                                                                                                                        'ETT_Is_Repair_Price__c',true);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objEventLog);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objPricingHistory);
                                                                         }
                                                                      else if(objNewPricingInformation.ETT_Repair_Price_Approval_Status__c=='Rejected'
                                                                              && mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Repair_Price_Approval_Status__c!=objNewPricingInformation.ETT_Repair_Price_Approval_Status__c){
                                                                                  priceResetHandleUpdates(objNewPricingInformation, 'ETT_New_Repair_Price__c', 'ETT_Old_Repair_Price__c', objNewPricingInformation.ETT_Old_Repair_Price__c, objNewPricingInformation.ETT_Repair_Price_Comments__c,'ETT_Repair_Price_Approval_Status__c');
                                                                              }
                                                                      
                                                                      
                                                                      if(objNewPricingInformation.ETT_Retread_Price_H__c!=null && objNewPricingInformation.ETT_Retread_Price_H__c!=mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Retread_Price_H__c
                                                                         && objNewPricingInformation.ETT_Retread_H_Price_Approval_Status__c=='Approved'
                                                                        ){
                                                                            objNewPricingInformation.ETT_OLD_Retread_Price_H__c =  mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Retread_Price_H__c; 
                                                                            PricingHistoryWrapper objPriningHistoryWraper = PricingHistoryWrapper.objPricingHistoryObj('ETT_Old_Retread_Price_H__c',mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Retread_Price_H__c,
                                                                                                                                                                       'ETT_New_Retread_Price_H__c',objNewPricingInformation.ETT_Retread_Price_H__c,'ETT_Retread_Price_H_Changed_Date__c',DateTime.now(),
                                                                                                                                                                       'ETT_Pricing_Information__c',objNewPricingInformation.Id,'ETT_Retread_Price_H_Comments__c',objNewPricingInformation.ETT_Retread_Price_H_Comments__c,objNewPricingInformation.ETT_Price__r.ETT_Party_Name__r.Party_Type__c,
                                                                                                                                                                       'Is_Retread_Price_H__c',true);
                                                                            objNewPricingInformation.ETT_Retread_Price_H__c = mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_OLD_Retread_Price_H__c;
                                                                            lstNewObjects.add(objPriningHistoryWraper.objEventLog);
                                                                            lstNewObjects.add(objPriningHistoryWraper.objPricingHistory);
                                                                        }
                                                                      else if(objNewPricingInformation.ETT_Retread_H_Price_Approval_Status__c=='Rejected'
                                                                              && mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Retread_H_Price_Approval_Status__c!=objNewPricingInformation.ETT_Retread_H_Price_Approval_Status__c){
                                                                                  priceResetHandleUpdates(objNewPricingInformation, 'ETT_New_Retread_Price_H__c', 'ETT_Old_Retread_Price_H__c', objNewPricingInformation.ETT_Old_Retread_Price_H__c, objNewPricingInformation.ETT_Retread_Price_H_Comments__c,'ETT_Retread_H_Price_Approval_Status__c');
                                                                              }
                                                                      
                                                                      
                                                                      
                                                                      if(objNewPricingInformation.ETT_Retread_Price_P__c!=null && objNewPricingInformation.ETT_Retread_Price_P__c!=mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Retread_Price_P__c
                                                                         && objNewPricingInformation.ETT_Retread_Price_P_Approval_Status__c=='Approved'){
                                                                             objNewPricingInformation.ETT_Old_Retread_Price_P__c = mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Retread_Price_P__c;
                                                                             PricingHistoryWrapper objPriningHistoryWraper = PricingHistoryWrapper.objPricingHistoryObj('ETT_Old_Retread_Price_P__c',mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Retread_Price_P__c,
                                                                                                                                                                        'ETT_New_Retread_Price_P__c',objNewPricingInformation.ETT_Retread_Price_P__c,'ETT_Retread_Price_P_Changed_Date__c',DateTime.now(),
                                                                                                                                                                        'ETT_Pricing_Information__c',objNewPricingInformation.Id,'ETT_Retread_Price_P_Comments__c',objNewPricingInformation.ETT_Retread_Price_P_Comments__c,objNewPricingInformation.ETT_Price__r.ETT_Party_Name__r.Party_Type__c
                                                                                                                                                                        ,'ETT_Is_Retread_Price_P__c',true);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objEventLog);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objPricingHistory); 
                                                                         }   
                                                                      
                                                                      else if(objNewPricingInformation.ETT_Retread_Price_P_Approval_Status__c=='Rejected'
                                                                              && mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Retread_Price_P_Approval_Status__c!=objNewPricingInformation.ETT_Retread_Price_P_Approval_Status__c){
                                                                                  priceResetHandleUpdates(objNewPricingInformation, 'ETT_New_Retread_Price_P__c', 'ETT_Old_Retread_Price_P__c', objNewPricingInformation.ETT_Old_Retread_Price_P__c, objNewPricingInformation.ETT_Retread_Price_P_Comments__c,'ETT_Retread_Price_P_Approval_Status__c');
                                                                              }                  
                                                                      
                                                                      
                                                                      
                                                                      if(objNewPricingInformation.ETT_Scrap_Price__c!=null && objNewPricingInformation.ETT_Scrap_Price__c!=mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Scrap_Price__c
                                                                         && objNewPricingInformation.ETT_Scrap_Price_Approval_Status__c=='Approved'){
                                                                             objNewPricingInformation.ETT_Old_Scrap_Price__c = mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Scrap_Price__c;
                                                                             PricingHistoryWrapper objPriningHistoryWraper = PricingHistoryWrapper.objPricingHistoryObj('ETT_Old_Scrap_Price__c',mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Scrap_Price__c,
                                                                                                                                                                        'ETT_New_Scrap_Price__c',objNewPricingInformation.ETT_Scrap_Price__c,'ETT_Scrap_Price_Changed_Date__c',DateTime.now(),
                                                                                                                                                                        'ETT_Pricing_Information__c',objNewPricingInformation.Id,'ETT_Scrap_Price_Comments__C',objNewPricingInformation.ETT_Scrap_Price_Comments__C,objNewPricingInformation.ETT_Price__r.ETT_Party_Name__r.Party_Type__c,
                                                                                                                                                                        'ETT_Is_Scrap_Price__c',true);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objEventLog);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objPricingHistory);
                                                                         } else if(objNewPricingInformation.ETT_Scrap_Price_Approval_Status__c=='Rejected'
                                                                                   && mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Scrap_Price_Approval_Status__c!=objNewPricingInformation.ETT_Scrap_Price_Approval_Status__c){
                                                                                       priceResetHandleUpdates(objNewPricingInformation, 'ETT_New_Scrap_Price__c', 'ETT_Old_Scrap_Price__c', objNewPricingInformation.ETT_Old_Scrap_Price__c, objNewPricingInformation.ETT_Scrap_Price_Comments__C,'ETT_Scrap_Price_Approval_Status__c');
                                                                                   }  
                                                                      
                                                                      
                                                                      if(objNewPricingInformation.ETT_Selling_Price_H__c!=null && objNewPricingInformation.ETT_Selling_Price_H__c!=mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Selling_Price_H__c
                                                                         && objNewPricingInformation.ETT_Selling_Price_H_Approval_Status__c=='Approved'){
                                                                             objNewPricingInformation.ETT_OLD_Selling_Price_H__c = mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Selling_Price_H__c;
                                                                             PricingHistoryWrapper objPriningHistoryWraper = PricingHistoryWrapper.objPricingHistoryObj('ETT_Old_Selling_Price_H__c',mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Selling_Price_H__c,
                                                                                                                                                                        'ETT_New_Selling_Price_H__c',objNewPricingInformation.ETT_Selling_Price_H__c,'ETT_Selling_Price_H_Changed_Date__c',DateTime.now(),
                                                                                                                                                                        'ETT_Pricing_Information__c',objNewPricingInformation.Id,'ETT_Selling_Price_H_Comments__c',objNewPricingInformation.ETT_Selling_Price_H_Comments__c,objNewPricingInformation.ETT_Price__r.ETT_Party_Name__r.Party_Type__c,
                                                                                                                                                                        'ETT_Is_Selling_Price_H__c',true);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objEventLog);
                                                                             lstNewObjects.add(objPriningHistoryWraper.objPricingHistory);
                                                                         }else if(objNewPricingInformation.ETT_Selling_Price_H_Approval_Status__c=='Rejected'
                                                                                  && mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Selling_Price_H_Approval_Status__c!=objNewPricingInformation.ETT_Selling_Price_H_Approval_Status__c){
                                                                                      priceResetHandleUpdates(objNewPricingInformation, 'ETT_New_Selling_Price_H__c', 'ETT_Old_Selling_Price_H__c', objNewPricingInformation.ETT_Old_Selling_Price_H__c, objNewPricingInformation.ETT_Selling_Price_H_Comments__c,'ETT_Selling_Price_H_Approval_Status__c');
                                                                                  }  
                                                                      
                                                                      
                                                                      if(objNewPricingInformation.ETT_Selling_Price_P__c!=null && objNewPricingInformation.ETT_Selling_Price_P__c!=mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Selling_Price_P__c
                                                                         && objNewPricingInformation.ETT_Selling_Price_P_Approval_Status__c=='Approved'){
                                                                             PricingHistoryWrapper objPriningHistoryWraper = PricingHistoryWrapper.objPricingHistoryObj('ETT_Old_Selling_Price_P__c',mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Selling_Price_P__c,
                                                                                                                                                                        'ETT_New_Selling_Price_P__c',objNewPricingInformation.ETT_Selling_Price_P__c,'ETT_Selling_Price_P_Changed_Date__c',DateTime.now(),
                                                                                                                                                                        'ETT_Pricing_Information__c',objNewPricingInformation.Id,'ETT_Selling_Price_P_Comments__c',objNewPricingInformation.ETT_Selling_Price_P_Comments__c,objNewPricingInformation.ETT_Price__r.ETT_Party_Name__r.Party_Type__c,
                                                                                                                                                                        'ETT_Is_Selling_Price_P__c',true);
                                                                             objNewPricingInformation.ETT_OLD_Selling_Price_P__c  = mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Selling_Price_P__c;  
                                                                             lstNewObjects.add(objPriningHistoryWraper.objEventLog); 
                                                                             lstNewObjects.add(objPriningHistoryWraper.objPricingHistory);                  
                                                                         }
                                                                      
                                                                      else if(objNewPricingInformation.ETT_Selling_Price_P_Approval_Status__c=='Rejected'
                                                                              && mapOfOldPricingInformations.get(objNewPricingInformation.Id).ETT_Selling_Price_P_Approval_Status__c!=objNewPricingInformation.ETT_Selling_Price_P_Approval_Status__c){
                                                                                  priceResetHandleUpdates(objNewPricingInformation, 'ETT_New_Selling_Price_P__c', 'ETT_Old_Selling_Price_P__c', objNewPricingInformation.ETT_Old_Selling_Price_P__c, objNewPricingInformation.ETT_Selling_Price_P_Comments__c,'ETT_Selling_Price_P_Approval_Status__c');
                                                                              }  
                                                                      
                                                                      
                                                                  }    
        
        //Inserting Event Log and Price Information History 
        if(!lstNewObjects.isEmpty() && !Test.isRunningTest()){
            ETT_PricingInformationTriggerHandler.isRecursive = false;
            insert lstNewObjects;
        } 
    }
    
    public static void priceResetHandleUpdates(ETT_Pricing_Information__c objnewObject,string strNewPriceField,string strOldField,Decimal oldPriceData,string strCommentField,string strStatusField){
        objnewObject.put(strNewPriceField,oldPriceData);
        objnewObject.put(strOldField,null);
        objnewObject.put(strStatusField,'New'); 
        objnewObject.put(strCommentField,'');
    }
    
    public static PricingHistoryWrapper objPricingHistoryObj(string strPriceOldApiName,Decimal oldPrice,string strPriceNewApiName,Decimal newPrice,string strChangedDateTimeField,DateTime changedDateTime,string strParentId,Id pricingInformationId,string strCommentsField,string strComments,string strRecordTypeName,
                                                             string strBooleanField,boolean isProcess){
                                                                 PricingHistoryWrapper objPricingInformationWrap = new PricingHistoryWrapper();
                                                                 
                                                                 ETT_Price_Information_History__c objPricingInformationHistory = new ETT_Price_Information_History__c();
                                                                 objPricingInformationHistory.put(strPriceOldApiName,oldPrice);
                                                                 objPricingInformationHistory.put(strPriceNewApiName,newPrice);
                                                                 objPricingInformationHistory.put(strCommentsField,strComments);
                                                                 objPricingInformationHistory.put(strChangedDateTimeField,changedDateTime);
                                                                 objPricingInformationHistory.put(strParentId,pricingInformationId);
                                                                 objPricingInformationHistory.put('RecordTypeId',Schema.SObjectType.ETT_Price_Information_History__c.getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId());
                                                                 
                                                                 ETT_Event_Log__c objEventLog = new ETT_Event_Log__c();
                                                                 objEventLog.ETT_Object_Name__c = 'ETT_Pricing_Information__c';
                                                                 objEventLog.ETT_Sobject_Id__c  = pricingInformationId;
                                                                 objEventLog.put(strBooleanField,isProcess);
                                                                 objPricingInformationWrap.objPricingHistory = objPricingInformationHistory;
                                                                 objPricingInformationWrap.objEventLog = objEventLog;
                                                                 
                                                                 return objPricingInformationWrap;
                                                             }
    
    public Class PricingHistoryWrapper{
        public ETT_Price_Information_History__c objPricingHistory;
        public ETT_Event_Log__c objEventLog;
    }
    
    
}