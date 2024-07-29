({
    doInit: function (component, event, helper){
        
        var action = component.get('c.updateCollectionCard');
        
        action.setParams({
            recordId : component.get("v.recordId"),
            fieldName : 'Move_Order_Status__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();            
           
                
                helper.showErrorToast({
                    "title": "success",
                    "type": "success",
                    "message":"Move Order Status is Updated to Confirmed."
                });
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showErrorToast({
                            "title": "error",
                            "type": "error",
                            "message":errors[0].message
                        });
                      
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
        
    },
    
})