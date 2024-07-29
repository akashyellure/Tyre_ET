/*
    * Author:Sandip
    * CreatedDate:20/10/2022
    * Test Class - ETT_MoveOrderClassTest
    */        
    public without sharing class ETT_MoveOrderClass {
            @AuraEnabled
                public static void updateCollectionCard(string recordId,String fieldName){
                    
                    ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                    cc.Id = recordId;
                    
                    if(fieldName == 'Move_Order_Status__c'){
                        cc.Move_Order_Status__c = 'Confirmed';
                        
                    }
                    
                    try { 
                       
                          update cc;                   
                        
                    }catch(Exception e) {
                        System.debug('Exception ---> '+e.getStackTraceString());
                          
                    }
                }
            }