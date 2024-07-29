({
    linktoCase : function(component, event, helper) {
        var action = component.get("c.updateCase");
        action.setParams({
            caseId : component.get("v.recordId"),
            TyreSerialNumber : component.get("v.selItem.text"),
            collectionCard : component.get("v.selItem.collectionCard"),
            inspectionCard : component.get("v.selItem.inspectionCard"),
            jobCard : component.get("v.selItem.jobCard"),
         //   serviceAppointmentId : component.get("v.selItem.serviceAppointmentId"),
            accountId : component.get("v.selItem.AccountId"),
            tyreinspectioncard:component.get("v.selItem.tyreinspectioncard"),
            collectioncardlookup:component.get("v.selItem.collectioncardlookup"),
            jobcardlookup:component.get("v.selItem.jobcardlookup"),
            delivarynotenum:component.get("v.selItem.delivarynotenum"),
            conatctname:component.get("v.selItem.conatctname")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Tyre details are linked to case record successfully.",
                    type: 'success'              
                });
                toastEvent.fire();
                var closeQuickAction = $A.get("e.force:closeQuickAction");
                closeQuickAction.fire();
                var refreshView = $A.get("e.force:refreshView");
                refreshView.fire();
            }
            else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.")
                // Show offline error
            }
                else if (state === "ERROR") {
                   var errors = response.getError();                       
                          

                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error!",
                    message: errors[0].message,
                    type: 'error'              
                });
                toastEvent.fire();
                }
	 
            
        });
        $A.enqueueAction(action);   
    }
})