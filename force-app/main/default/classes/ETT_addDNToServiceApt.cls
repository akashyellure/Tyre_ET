/**
 * Author:Janardhan
 * CreatedDate:13/12/2021
 * TestClass: ETT_addDNToServiceAptTest
 * */
public without sharing class  ETT_addDNToServiceApt {

    @auraEnabled
    public static list<ETT_Delivery_Note__c> getDNDetails(string recordId){
        
        Id accId = [select id,Account__c from Tyre_Collection_Appointment__c where id=:recordId].Account__c;
        
        return [select id,name,ETT_Date__c from ETT_Delivery_Note__c where ETT_Account__c=:accId AND Tyre_Service_Appointment__c=null AND DN_Status__c='Approved' ORDER BY NAME DESC];
    }
    
    @auraEnabled
    public static void updateDNDetails(list<ETT_Delivery_Note__c> dnList){
        
        if(dnList.size()>0 && dnList != null){
            
            try{
                 update dnList;
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());   
            }
           
        }
    }
        
}