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
    recordCount : function(obj){
        var size = 0, key;
        for (key in obj) {
            console.log(obj[key]);
            if (obj.hasOwnProperty(key)) size++;
        }
        return size;
    },
    fetchPickListVal: function(component, fieldName, elementId) {
        
        var action = component.get("c.getselectOptions");
        
        if(fieldName=='ETT_Vehicle_Type__c' || fieldName=='ETT_VehicleApplication__c'){
            action.setParams({
                "objObject": component.get("v.objCustomerVehicleList"),
                "fld": fieldName
            });
        }else if(fieldName=='ETT_Payment_Terms__c' || fieldName=='ETT_PurchaseInfo_Type__c'){
            action.setParams({
                "objObject": component.get("v.objStgPurchaseInformation"),
                "fld": fieldName
            });
        }else if(fieldName=='ETT_Services__c' || fieldName=='ETT_Status__c'){
            action.setParams({
                "objObject": component.get("v.objAddedServices"),
                "fld": fieldName
            });
        }
        
        
        
        var opts = [];
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (response.getState() == "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log(result);
                
                var opts = [];
                for(var key in result){
                    opts.push({key: key, value: result[key]});
                }
                var el = 'v.'+elementId;
                component.set(el, opts);
                
            }else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            
        });
        $A.enqueueAction(action);
    },
})