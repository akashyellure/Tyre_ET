({
    getRelatedJobCards : function(component, event, helper) {

        var action = component.get("c.getRelatedJobCards");

        action.setParams({
            recordId : component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            console.log(response.getState());
            if (response.getState() == "SUCCESS") {
                var jobList = response.getReturnValue();
                component.set('v.lstJobCard',jobList);
                console.log(JSON.stringify(jobList));
            }else if (response.getState() === "ERROR") {
                let errors = response.getError();
                console.log(JSON.stringify(errors));
            }else {
                // Handle other reponse states
            }
        });
        $A.enqueueAction(action);


    },
    
    updateToolsAndMaterialUsage: function(component, event, helper) {

        var action = component.get("c.updateToolsAndMaterialUsage");

        //   var lstJobCard =  component.get('v.lstJobCard');
        action.setParams({
            lstJobCard : JSON.stringify(component.get("v.lstJobCard"))
        });

        action.setCallback(this, function(response) {
            console.log(response.getState());
            if (response.getState() == "SUCCESS") {
                var jobList = response.getReturnValue();
                console.log(JSON.stringify(jobList));
            }else if (response.getState() === "ERROR") {
                let errors = response.getError();
                console.log(JSON.stringify(errors));
            }else {
                // Handle other reponse states
            }
        });
        $A.enqueueAction(action);


    },
    
})