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
    
    getLoginUserInfo : function(component, event, helper) {
       
        var action = component.get('c.getUserDetails');
      
         action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
               let data = response.getReturnValue();
               
                component.set("v.userInfo",data);           
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                
            }
          }); 
        
        $A.enqueueAction(action);
    }
    
})