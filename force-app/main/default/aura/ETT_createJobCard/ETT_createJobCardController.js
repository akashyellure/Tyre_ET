({
	doInit : function(component, event, helper) {
		helper.getLoginUserInfo(component, event, helper);
	},
    submitHandler : function(component, event, helper) {
        
        let actionVal = component.get("v.actionVal");
       
        var action = component.get('c.createJobCard');
      
        action.setParams({
            recordId : component.get("v.recordId"),
            actionVal:actionVal
           
        });
        component.set("v.showSpinner",true);
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
               let data = response.getReturnValue();
                component.set("v.showSpinner",false);
                helper.showErrorToast({
                    "title": "success",
                    "type": "success",
                    "message":"Your request has been submitted successfully."
                });
                
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        component.set("v.showSpinner",false);
                        helper.showErrorToast({
                            "title": "Error",
                            "type": "error",
                            "message":errors[0].message
                        });
                        
                    }
                } else {
                    console.log("Unknown error");
                    component.set("v.showSpinner",false);
                }
            }
          }); 
        
        $A.enqueueAction(action);
    }
})