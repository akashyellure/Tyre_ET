({
    helperMethod : function() {
        
    },
    showErrorToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
     fetchPickListVal: function(component, fieldName, elementId) {
        
         
        var action = component.get("c.getselectOptions");
        
        action.setParams({
            "objObject": component.get("v.objStagingScrapInspection"),
            "fld": fieldName
        });
        
        console.log(fieldName);
         
        var opts = [];
        action.setCallback(this, function(response) {
            
            var state = response.getState();

            if (response.getState() == "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log(result);
                
                var opts = [];
                for(var key in result){
                    opts.push({key: key, value: result[key]});
                }
                var el = 'v.'+elementId;
                component.set(el, opts);
                
            }else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
    },
})