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
                "objObject": component.get("v.FleetInspectionObj"),
                "fld": fieldName
            });
             
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
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
 fetchPickListValFromFleetChild: function(component, fieldName, elementId) {
  //      alert('jhd');
        var action = component.get("c.getselectOptions");
        
      //  alert(component.get("v.FleetInspectionLineItemObj"));
            action.setParams({
                "objObject": component.get("v.FleetInspectionLineItemObj"),
                "fld": fieldName
            });
             
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log(result);
               // alert(result);
                var opts = [];
                for(var key in result){
                   //   alert(result[key]);
                    opts.push({label: key, value: result[key]});
                }
                console.log('value of opts'+JSON.stringify(opts));
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