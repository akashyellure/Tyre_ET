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
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log(result);
                var opts = [];
                if(fieldName=='ETT_Tyre_Life__c'){
                    for(var key in result){
                        opts.push({label: key, value: result[key]});
                    }
                }else{
                    for(var key in result){
                        opts.push({key: key, value: result[key]});
                    }
                }
                var el = 'v.'+elementId;
                component.set(el, opts);
                
                
            }
        });
        $A.enqueueAction(action);
    },
})