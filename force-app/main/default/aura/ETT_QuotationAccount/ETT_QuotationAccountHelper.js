({
	showErrorToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
     getPriceDetails : function(component, event, helper) {
       
            var action = component.get('c.getPricingInfoFromAccId');
            action.setParams({
                AccId:component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    
                    let data = response.getReturnValue();
                    console.log(response.getReturnValue());
                    var tyreSizeVsPrice = new Map();
                    try{
                    data.forEach(function(item){
                       
                        tyreSizeVsPrice.set(item.ETT_Tyre_Size__r['Name'],item.ETT_Purchase_Price__c);
                        
                    });
                     component.set("v.tyreSizeVsPrice",tyreSizeVsPrice);
                     //console.log(tyreSizeVsPrice);
                    }catch(err){
                        
                        console.log('--err-'+err.message)
                    }
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