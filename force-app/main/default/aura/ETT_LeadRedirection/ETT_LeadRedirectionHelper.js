({
    getRecordTypes : function(component,event,helper){
        var action = component.get("c.GetAvailableRecordTypeLead");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var recordTypes = response.getReturnValue();
                console.log('recordTypes -> ' + JSON.stringify(recordTypes));
                for(var key in recordTypes){

                    console.log('key: '+key); 
                    console.log(recordTypes[key]); 
                    
                    returning.push({Id:key,Name:recordTypes[key].Name,Description:recordTypes[key].Description});
                }
                console.log('returning -> ' + JSON.stringify(returning));
                component.set("v.availableRecordTypes",returning);
                component.set("v.retrievedTypes",true);
            }
            else{
                alert("Temporary Error: There is a problem getting the Record Types.");// Temporary, Will be changed to ToastError.
            }
        });
        $A.enqueueAction(action); 
    }   
})