/**
* Author:Janardhan
* CreatedDate: 16/12/2021
* Desc:
*testClass:ETT_createJobCardTest
* */
public class ETT_createJobCard {
    
    @auraEnabled
    public static user getUserDetails(){
        return [select id,name,Profile.Name from user where Id=:userinfo.getUserId()];
    }
    @auraEnabled
public static void createJobCard(String recordId, String actionVal) {
    Savepoint sp = Database.setSavepoint();
    List<ETT_Job_Card__c> listOfJobCards = new List<ETT_Job_Card__c>();
    Set<Id> tyreInventoryIds = new Set<Id>();

    try {
        ETT_Collection_Card__c cc = [SELECT ETT_Inspection_Done__c  FROM ETT_Collection_Card__c WHERE Id = :recordId LIMIT 1];

        if (!cc.ETT_Inspection_Done__c) {
            throw new AuraHandledException('Please do all inspections first.');
        }

        if (actionVal == 'Job Card Created') {
            List<ETT_Inspection_Card__c> lstInspectionCards = [
                SELECT Id, ETT_Account__c, ETT_Account__r.Name, RecordType.Name, Tyre_Inventory__c, ETT_Collection_Card__r.ETT_Priority__c, 
                       ETT_Collection_Card__c, ETT_Status__c, (SELECT Id FROM Job_Cards__r),(SELECT Id, Job_Type__c,SubInventory__c FROM Tyre_Inventory__r)
                FROM ETT_Inspection_Card__c 
                WHERE ETT_Status__c = 'Accept' 
                  AND ETT_Collection_Card__c = :recordId
            ];

            for (ETT_Inspection_Card__c objIC : lstInspectionCards) {
                if (objIC.Job_Cards__r.isEmpty()) {
                    ETT_Job_Card__c objJobCard = new ETT_Job_Card__c(
                        ETT_Inspection_Card__c = objIC.Id,
                        ETT_Job_Stages_to_Perform_Ordered__c = 'Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping;Curing;Removal of RIM Tube Flap;Final Inspection;Painting;Quality Control',
                        Tyre_Inventory__c = objIC.Tyre_Inventory__c,
                        ETT_Stages__c = 'Buffing',
                        ETT_No_of_Buffing_revisions__c = 1,
                        ETT_Priority__c = objIC.ETT_Collection_Card__r.ETT_Priority__c,
                        Collection_Card__c = recordId,
                        Customer__c = objIC.ETT_Account__c,
                       
                        SubInventory__c=objIC.Tyre_Inventory__r.SubInventory__c

                    );

                    tyreInventoryIds.add(objIC.Tyre_Inventory__c);
                    listOfJobCards.add(objJobCard);
                }
            }

            if (!listOfJobCards.isEmpty()) {
                insert listOfJobCards;

                List<ETT_Tyre_Inventory__c> tyreList = [
                    SELECT Id, ETT_Inventory_Status__c 
                    FROM ETT_Tyre_Inventory__c 
                    WHERE Id IN :tyreInventoryIds
                ];

                for (ETT_Tyre_Inventory__c tyre : tyreList) {
                    tyre.ETT_Inventory_Status__c = 'Job Card Created';
                }
                update tyreList;

                cc.ETT_Job_Card_Done__c = true;
                cc.ETT_Collection_Status__c = 'Job Card Created';
            } else {
                throw new AuraHandledException('Please do all inspection cards first.');
            }
        } else if (actionVal == 'Check and Report') {
            cc.ETT_Collection_Status__c = actionVal;
        }

        update cc;
    } catch (Exception e) {
        System.debug('---ca' + e.getCause());
        System.debug('----Line' + e.getLineNumber());
        System.debug('---Trac-' + e.getStackTraceString());
        System.debug('---Type-' + e.getTypeName());
        System.debug('---err-' + e.getMessage());
        Database.rollback(sp);
        throw new AuraHandledException(e.getMessage());
    }
}

   
}