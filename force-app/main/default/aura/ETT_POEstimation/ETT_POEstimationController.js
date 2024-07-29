({
    doInit : function(component, event, helper) {
        
        helper.getInspectionCCDetailsHelper(component, event, helper);
        helper.getUserLoginInfoHelper(component, event, helper);
        
    },
    
    onForceCCLoad :function(component, event, helper) {
        
        let data = component.get("v.CCRecord");
        if(data.PO_Created__c){
            
        }
        
    },
    approveProcess : function(component, event, helper) {
        
        let updatedInsCC = component.get("v.inspectionCCList");
        let hasError = false;
        
        updatedInsCC.forEach(function(item){
            
            if(item.Tyre_Inventory__r.Item_Code__c == null){
                
                hasError = true;
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Error",
                    "title":"Validation",
                    "message":"Item Code should not be blank",
                    "mode":"dismissible"
                });
                toastReference.fire();
                return false;
            }else if(item.ETT_Status__c == 'Accept' && (item.Purchase_Price__c==0 || item.Purchase_Price__c=='')){
                hasError = true;
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Error",
                    "title":"Validation",
                    "message":"Purchase should not be blank/zero for accepted tyre",
                    "mode":"dismissible"
                });
                toastReference.fire();
                return false;
            }
            
        });
        
        if(!hasError) {
            //filter and group by only accept tyres
            var helper = {};
            var filterInfo = updatedInsCC.reduce(function(r, o) {
                o.TempQuantity__c = 1;
                if(o.ETT_Status__c =='Accept'){
                    var key = o.Tyre_Inventory__r.Item_Code__c;
                    
                    if(!helper[key]) {
                        
                        helper[key] = Object.assign({}, o); // create a copy of o
                        r.push(helper[key]);
                    } else {
                        helper[key].TempQuantity__c =helper[key].TempQuantity__c+1 ;
                        
                    }
                }
                
                return r;
            }, []);
            
            //console.log(updatedInsCC)
            //console.log(JSON.stringify(filterInfo))
            
            var action = component.get('c.createPOAndLines');
            
            component.set("v.showSpinner",true);
            action.setParams({
                recordId : component.get("v.recordId"),
                updateInsCC:updatedInsCC,
                itemCodeGroup:filterInfo
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") { 
                    
                    let dataVal = response.getReturnValue();
                    
                    component.set("v.showSpinner",false);
                    
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"success",
                        "title":"success",
                        "message":"Your request has been submitted and PO is created",
                        "mode":"dismissible"
                    });
                    toastReference.fire();
                    
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            component.set("v.showSpinner",false);
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"Error",
                                "title":"error",
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
    }
  
})