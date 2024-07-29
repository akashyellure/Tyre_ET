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
                console.log(JSON.stringify(result));
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
    showErrorToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    getTyreInventoryFrmServerHelper: function(component, event, helper){ 
        console.log('getTyreInventoryFrmServerHelper');
        var action = component.get('c.getTyreInventoryDetials');
        component.set("v.showSpinner",true);
        action.setParams({
            recordId : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                component.set("v.TyreInventoryFrmServer",data); 
                
                if(data.length > 0){
                      component.set("v.showToggleCheckCmp",false);
                }
             
                 component.set("v.showSpinner",false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                         component.set("v.showSpinner",false);
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
    },
    getStagTyreFrmServerHelper : function(component, event, helper){ 
        console.log('getStagTyreFrmServerHelper');
        var action = component.get('c.getStagTyreDetials');
         component.set("v.showSpinner",true);
        action.setParams({
            recordId : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                component.set("v.stgCollTyreDetailsFrmServer",data); 
              
                if(data.length > 0 ){
                    component.set("v.showToggleCheckCmp",false);
                }
                 component.set("v.showSpinner",false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                         component.set("v.showSpinner",false);
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
    }, 
    getUserLoginInfoHelper: function(component, event, helper){ 
        console.log('getUserLoginInfoHelper');
        var action = component.get('c.getUserInfo');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                component.set("v.userInfo",data);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
    }, 
    
    getTyreMasterDetailsHelper :function(component, event, helper){ 
       console.log('getTyreMasterDetailsHelper');
        var action = component.get('c.getTyreMasterDetails');
        
        action.setParams({
            recordId : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
               
                 component.set("v.lstTyreMaster",data);
               
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
    },
    getPriceConfirmationDetailsHelper :function(component, event, helper){ 
       console.log('getPriceConfirmationDetailsHelper');
        var action = component.get('c.getPricingConfirmDetails');
        
        action.setParams({
            recordId : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
               
                 component.set("v.lstPriceConfir",data);
               
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
      },
      getMoveOrderDetails :function(component, event, helper){ 
       
        	var action = component.get('c.getMoveOrderDetails');
			console.log('Last call init');        
        	action.setParams({
            	recordId : component.get("v.recordId")
        	});
        	action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                     let data = response.getReturnValue();
                     component.set("v.isMOConfirmed",data);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            }); 
        
        	$A.enqueueAction(action);  
      }
})