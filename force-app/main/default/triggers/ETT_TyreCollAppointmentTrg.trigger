trigger ETT_TyreCollAppointmentTrg on Tyre_Collection_Appointment__c (after Update) {
    
    ETT_TyreCollApptTrgHelper.createCollCard(trigger.NewMap,trigger.oldMap);

}