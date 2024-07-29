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

        var opts = [];
        var action = component.get("c.getselectOptions");
        action.setParams({
            "fld": fieldName
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
                console.log('inside success');
                var result = response.getReturnValue();
                console.log(result);
                var opts = [];
                for(var key in result){
                    opts.push({key: key, value: result[key]});
                }
                var el = 'v.'+elementId;
                component.set(el, opts);
            }else{
                console.log("Failed with state: " + state);
                console.log('errror');
            }
        });
        $A.enqueueAction(action);
    },
})