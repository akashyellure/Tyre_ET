trigger ETT_workStationCheckListTrg on ETT_Work_Station_Checklist__c (after insert) {
    
    ETT_workStationCheckListHelper.notifyUsers(trigger.NewMap);

}