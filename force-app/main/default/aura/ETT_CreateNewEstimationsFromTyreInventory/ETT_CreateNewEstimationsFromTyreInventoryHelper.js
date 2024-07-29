({
    
   
	/* getTyreDetailsHelper : function(component, event, helper) {
		
         var action = component.get('c.getTyreDetails');
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                  // console.log(data)
                   data.forEach(function(item){
                       item.isChecked = false;
                   });
                       
                   
                  component.set("v.tyreDetails",data);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            helper.showErrorToast({
                                "title": "Error",
                                "type": "Error",
                                "message":errors[0].message
                            });
                            
                        }
                    } else {
                        console.log("Unknown error");
                       
                    }
                }
            }); 
            
            $A.enqueueAction(action); 
	}, */
    showErrorToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
})