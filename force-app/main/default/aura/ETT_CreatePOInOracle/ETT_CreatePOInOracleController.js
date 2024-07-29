({
	doInit : function(component, event, helper) {
		
	},
    
    createPO :  function(component, event, helper) {
        
         var action = component.get('c.createPOInOracle');
      
        action.setParams({
            recordId : component.get("v.recordId")           
        });
        component.set("v.showSpinner",true);
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
               let data =  response.getReturnValue();
                console.log('data=='+JSON.stringify(data));
                if(data.PV_OUT_STATUS == 'Y'){
                    
                    helper.showErrorToast({
                        "title": "Success",
                        "type": "success",
                        "message":"PO created succesffuly in oracle with ref no:"+data.PV_OUT_EBS_REF_NO,
                        "mode": 'sticky'
                    });
                    
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                }else{
                     component.set("v.showSpinner",false);
                    helper.showErrorToast({
                    "title": "Unable to Create PO",
                    "type": "Error",
                    "message":data.PV_OUT_ERRORMESSAGE,
                    "mode": 'sticky'
                });
                }
                
                
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        component.set("v.showSpinner",false);
                        
                        helper.showErrorToast({
                            "title": "Unable to Create PO",
                            "type": "Error",
                            "message":errors[0].message,
                            "mode": 'sticky'
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