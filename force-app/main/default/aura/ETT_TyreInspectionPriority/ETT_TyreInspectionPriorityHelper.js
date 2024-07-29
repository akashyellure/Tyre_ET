({
    fetchPickListVal: function(component, fieldName, elementId) {
        
        var action = component.get("c.getselectOptions");
        action.setParams({
            "fld": fieldName
        });
        
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                var opts = [];
                for(var key in result){
                    opts.push({key: key, value: result[key]});
                }
                var el = 'v.'+elementId;
                component.set(el, opts);
            }else{
                console.log("Failed with state: ");
                console.log('errror');
            }
        });
        $A.enqueueAction(action);
    },
})