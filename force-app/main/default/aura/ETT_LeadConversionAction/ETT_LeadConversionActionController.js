({
    doInit : function(component, event, helper) {
        
    },
    handleConvert : function(component, event, helper) {
        
        let leadStatus  = component.get("v.leadRecord.Status");
        
        if(leadStatus == 'Qualified'){
            
            component.set("v.showSpinner",true);
            
            var action = component.get('c.convertLeadCustom');
            
            action.setParams({
                leadId : component.get("v.recordId")
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                     component.set("v.showSpinner",false);
                    
                    let data = response.getReturnValue()
                    
                    helper.showToast('Success','Success','Lead is converted successfully');
                    //nav to Account
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": data
                        
                    });
                    navEvt.fire();
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            component.set("v.showSpinner",false);
                            helper.showToast('Error','Error',errors[0].message);
                        }
                    } else {
                        component.set("v.showSpinner",false);
                        console.log("Unknown error");
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action); 
        }else{
             helper.showToast('Error','Error','Lead is not Qualified');
        }
    }
})