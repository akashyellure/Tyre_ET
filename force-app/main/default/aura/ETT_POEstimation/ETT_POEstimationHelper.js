({
   	getInspectionCCDetailsHelper : function(component, event, helper) {
        
         var action = component.get('c.getTyreInspectionCCDetails');
             component.set("v.showSpinner",true);
            action.setParams({               
                recordId : component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                     component.set("v.showSpinner",false);
                    let data = response.getReturnValue();
                    console.log('PO DATA '+ JSON.stringify(data));
                    
                    data.forEach(function(item){
                        if(item.ETT_Status__c == 'Send Back'){
                            item.Purchase_Price__c = 0;

                        }else{
                            item.Purchase_Price__c = item.Tyre_Inventory__r.Purchase_Price__c;

                        }
                       });
                   
                    
                    component.set("v.inspectionCCList",data);
                   
                    var helper = {};
                    var result = data.reduce(function(r, o) {
                        o.TempQuantity__c = 1;
                        var key = o.Tyre_Inventory__r.Item_Code__c;
                        
                        if(!helper[key]) {
                            
                            helper[key] = Object.assign({}, o); // create a copy of o
                            r.push(helper[key]);
                        } else {
                            helper[key].TempQuantity__c =helper[key].TempQuantity__c+1 ;
                            
                        }
                        
                        return r;
                    }, []);
                    
                    component.set("v.itemgroupInfo",result);
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                             component.set("v.showSpinner",false);
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
		
	},
          getUserLoginInfoHelper: function(component, event, helper){ 
        console.log('getUserLoginInfoHelper');
        var action = component.get('c.getUserInfo');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                component.set("v.userInfo",data);
                 console.log('getUserLoginInfoHelper',data);
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
})