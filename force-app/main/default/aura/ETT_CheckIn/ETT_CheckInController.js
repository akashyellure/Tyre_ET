({
    doInit : function(component, event, helper) {
        
        var action = component.get('c.updateRejectedTyreCheckIn'); 
        
        action.setParams({
            "strCollectionCard":component.get("v.recordId")
        });
        
        action.setCallback(this, function(a){
            
            var state = a.getState(); 
            console.log(state);
            
            if(state == 'SUCCESS') {
                
                var result = a.getReturnValue();
                console.log('Res: '+JSON.stringify(result));
                
               /* var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
                */
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);        
        
    }
})