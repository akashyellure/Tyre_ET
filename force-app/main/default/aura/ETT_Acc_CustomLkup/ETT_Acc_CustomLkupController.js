({
	 searchField : function(component, event, helper) {
        
        var currentText = event.getSource().get("v.value");
        var resultBox = component.find('resultBox');
         console.log(currentText);             
        if(currentText.length > 0) {
            $A.util.addClass(resultBox, 'slds-is-open');
        }else {
            $A.util.removeClass(resultBox, 'slds-is-open');
        }
        
        var action = component.get("c.getAcctFilterList");
        
        action.setParams({
                       
            searchWord : currentText
           
        });
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            
            console.log(state);
            
            if(state === "SUCCESS") {
                
                var custs = [];
                var conts = response.getReturnValue();
                 console.log(conts);
               
				component.set("v.listOfSearchRecords", response.getReturnValue());	
              
                
            }else if (state === "ERROR") {
                
                console.log(response.getError());
                
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
            component.set("v.LoadingText", false);
        });
        
        $A.enqueueAction(action);
    },
    
    setSelectedRecord : function(component, event, helper){      
        
        var id = event.currentTarget.id;
         var resultBox = component.find('resultBox');
         $A.util.removeClass(resultBox, 'slds-is-open');
        component.set("v.selectRecordName", event.currentTarget.dataset.name);
        component.set("v.selectRecordId", id);
        
        component.find('userinput').set("v.readonly", false);
    },
    resetData : function(component, event, helper) {
        component.set("v.selectRecordName", "");
        component.set("v.selectRecordId", "");
        component.find('userinput').set("v.readonly", false);
    }
})