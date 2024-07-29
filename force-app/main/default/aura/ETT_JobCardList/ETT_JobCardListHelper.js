({
	getJobList : function(component, event, helper) {
		var action = component.get("c.getValidJobCards");
        var opts = [];
        action.setCallback(this, function(response) {
            console.log(response.getState());
            if (response.getState() == "SUCCESS") {
                var jobList = response.getReturnValue();
                console.log(JSON.stringify(jobList));
                component.set("v.validJobCardWrapper",jobList);
            }else if (response.getState() === "ERROR") {
                let errors = response.getError();
                console.log(JSON.stringify(errors));
            }else {
                // Handle other reponse states
            }
        });
        $A.enqueueAction(action);
	}
})