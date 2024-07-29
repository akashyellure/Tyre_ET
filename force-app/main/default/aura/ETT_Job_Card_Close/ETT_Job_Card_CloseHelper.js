({
	getJobTypeHelper : function(component, event, helper)  {
        
        
      var action = component.get('c.getJobTypeValue');
      
        action.setParams({
              insCardId:component.get("v.jobCardInfo").ETT_Inspection_Card__c.toString()
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
              
                 let data = response.getReturnValue();
                component.set("v.jobType",data);
               
                //console.log(data)
                
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
    
    getPicklistValueHelper :function(component, event, helper) {
        
      var action = component.get('c.getselectOptions');
      
        action.setParams({
              objObject:'ETT_Job_Card_Close_Lines__c',
              fld:'Job_Type__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
              
                 let data = response.getReturnValue();
                var items = [];
                data.forEach(function(val){
                     var item = {
                        "label":val,
                        "value": val.toString()
                    };
                    items.push(item);
                });
               
                component.set("v.options",items);
                 
                
                //console.log(data)
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
    
    getAllUsedItemsHelper :function(component, event, helper) {
        
      var action = component.get('c.getAllUsedItems');
      
        action.setParams({
              JobCardId:component.get("v.jobCardId").toString()
             
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
              
                 let data = response.getReturnValue();
                component.set("v.allItemsList",data);
                console.log(data)
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
    
    showToastMsg :function(Type,Title,Msg) {
        
        var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":Type,
                "title":Title,
                "message":Msg,
                "mode":"dismissible"
            });
            toastReference.fire();
    },
    createJCcloseLinesUnderJCHelper : function(component, event, helper) {
        
        var params = event.getParams();        
        let jobCardCloseId = params.response.id;
        
       var action = component.get('c.createJCcloseLinesUnderJC');
      
        action.setParams({
            JCcloseLines : component.get("v.newJobCardCloseLines"),
            JCCloseId : jobCardCloseId.toString()
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": jobCardCloseId
                });
                navEvt.fire();
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
     getEnvelopeDetails :function(component, event, helper) {
        
      var action = component.get('c.getEnvelopeInfo');
      
        action.setParams({
              jobCardId:component.get("v.jobCardId").toString()
             
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
              
                 let data = response.getReturnValue();
                component.set("v.envInfo",data);
                //console.log(data)
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
     getCuringDetails :function(component, event, helper) {
        
      var action = component.get('c.getCuringInfo');
      
        action.setParams({
              jobCardId:component.get("v.jobCardId").toString()
             
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
              
                 let data = response.getReturnValue();
                component.set("v.curingInfo",data);
                //console.log(data)
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
    getBuffingDetails :function(component, event, helper) {
        
      var action = component.get('c.getBuffingInfo');
      
        action.setParams({
              jobCardId:component.get("v.jobCardId").toString()
             
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
              
                 let data = response.getReturnValue();
                component.set("v.buffingInfo",data);
                //console.log(data)
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