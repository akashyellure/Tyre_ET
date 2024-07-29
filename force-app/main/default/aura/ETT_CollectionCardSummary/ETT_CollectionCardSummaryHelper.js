({
	getTyreInventoryInfo : function(component, event, helper){
		
       var action = component.get('c.getTyreInventoryDetails');
      
        action.setParams({
            recordId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
               let data = response.getReturnValue();
              //console.log(data)
               var helper = {};
                var result = data.reduce(function(r, o) {
                    o.Total = 1;
                    var key = o.ETT_Tyre_Size_Master__r.Name;
                    
                    if(!helper[key]) {
                        helper[key] = Object.assign({}, o); // create a copy of o
                        r.push(helper[key]);
                    } else {
                        helper[key].Total += o.Total;
                        
                    }
                    
                    return r;
                }, []);
                
               component.set("v.lstTyreDetails",result);
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