({
    doInit : function(component, event, helper) {
        
        helper.fetchPickListVal(component, "ETT_Priority__c", "priorityMap");

        var action = component.get("c.getInspetionCardDetails");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state: '+state);
            if (state === "SUCCESS") {
            	console.log('response.getReturnValue(): '+JSON.stringify(response.getReturnValue()));                
                component.set("v.lstInspectionCard", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    Save : function(component, event, helper) {
    
        var lstInspectionCard = component.get("v.lstInspectionCard");
        console.log(JSON.stringify(lstInspectionCard));

         var action = component.get("c.updateInspectionCardPriority");
        
        action.setParams({
            "lstInspectionCard":lstInspectionCard
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state: '+state);
            if (state === "SUCCESS") {
            	console.log('response.getReturnValue(): '+response.getReturnValue());                
                //component.set("v.lstInspectionCard", response.getReturnValue());
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + component.get("v.recordId")
                });
                urlEvent.fire();
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    
    }
    
})