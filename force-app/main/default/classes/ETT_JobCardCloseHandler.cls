public class ETT_JobCardCloseHandler {

    public static void updateJobCardCloseDone(Map<Id, ETT_Job_Card_Close__c> newJobCards, Map<Id, ETT_Job_Card_Close__c> oldJobCards) {
        Set<Id> collectionCardIds = new Set<Id>();
system.debug('@@@@@@@@@@@@@@@@@@@@@@@');
        // Collect all Collection Card IDs related to the inserted or updated Job Card Closes
        for (ETT_Job_Card_Close__c jobCardClose : newJobCards.values()) {
            if (jobCardClose.Collection_Card__c != null) {
                collectionCardIds.add(jobCardClose.Collection_Card__c);
            }
        }

        // Query to get all related Job Card Closes and their statuses for each Collection Card
        List<ETT_Job_Card_Close__c> relatedJobCardCloses = [
            SELECT Id, Collection_Card__c, Status__c 
            FROM ETT_Job_Card_Close__c 
            WHERE Collection_Card__c IN :collectionCardIds
        ];

        // Initialize the map to track Collection Card statuses
        Map<Id, Boolean> collectionCardStatusMap = new Map<Id, Boolean>();
        Map<Id, Integer> collectionCardJobCardCountMap = new Map<Id, Integer>();

        for (ETT_Job_Card_Close__c jobCardClose : relatedJobCardCloses) {
            if (!collectionCardStatusMap.containsKey(jobCardClose.Collection_Card__c)) {
                collectionCardStatusMap.put(jobCardClose.Collection_Card__c, true);
                collectionCardJobCardCountMap.put(jobCardClose.Collection_Card__c, 0);
            }
            collectionCardJobCardCountMap.put(jobCardClose.Collection_Card__c, collectionCardJobCardCountMap.get(jobCardClose.Collection_Card__c) + 1);
            
            if (jobCardClose.Status__c != 'Approved') {
                collectionCardStatusMap.put(jobCardClose.Collection_Card__c, false);
            }
        }

        // Query to get all Collection Cards and their Job Cards
        Map<Id, Integer> collectionCardTotalJobCardsMap = new Map<Id, Integer>();
        List<AggregateResult> totalJobCards = [
            SELECT Collection_Card__c collectionCardId, COUNT(Id) jobCount 
            FROM ETT_Job_Card_Close__c 
            WHERE Collection_Card__c IN :collectionCardIds 
            GROUP BY Collection_Card__c
        ];
        for (AggregateResult ar : totalJobCards) {
            collectionCardTotalJobCardsMap.put((Id) ar.get('collectionCardId'), (Integer) ar.get('jobCount'));
        }

        // Prepare the list of Collection Cards to update
        List<ETT_Collection_Card__c> collectionCardsToUpdate = new List<ETT_Collection_Card__c>();

        for (Id collectionCardId : collectionCardStatusMap.keySet()) {
            if (collectionCardStatusMap.get(collectionCardId) &&
                collectionCardJobCardCountMap.get(collectionCardId) == collectionCardTotalJobCardsMap.get(collectionCardId)) {
                ETT_Collection_Card__c collectionCard = new ETT_Collection_Card__c(Id = collectionCardId, Job_Card_Close_Done__c = true);
                collectionCardsToUpdate.add(collectionCard);
            }
        }

        if (!collectionCardsToUpdate.isEmpty()) {
            update collectionCardsToUpdate;
        }


    }
}