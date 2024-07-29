({
	submitToApprovalPrcsHelper : function(component, event, helper) {
        
         var action = component.get('c.submitToApprovalPrcs');
      
        action.setParams({
            comments : component.get("v.comments"),
            recordId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
               let data =  response.getReturnValue();
                
                  var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Success",
                            "title":"Success",
                            "message":'Approval request has been submitted.',
                            "mode":"dismissible"
                        });
                        toastReference.fire();

                
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":errors[0].message,
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
          }); 
        
        $A.enqueueAction(action);  
		
	}
})