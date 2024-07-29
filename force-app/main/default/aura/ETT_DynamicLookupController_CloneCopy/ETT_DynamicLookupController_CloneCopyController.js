({
    searchField : function(component, event, helper) {
        
        console.log(component.get("v.brandName"));
        console.log(component.get("v.countryName"));
        console.log(component.get("v.patternName"));
        console.log(component.get("v.tyreSizeName"));
        
        var currentText = event.getSource().get("v.value");
        var resultBox = component.find('resultBox');
        
        console.log('currentText: '+currentText);
        
        component.set("v.LoadingText", true);
        
        if(currentText.length > 0) {
            $A.util.addClass(resultBox, 'slds-is-open');
        }else {
            $A.util.removeClass(resultBox, 'slds-is-open');
        }
        
        var action = component.get("c.getFilteredResults");
        
        action.setParams({
            "ObjectName" : component.get("v.objectName"),
            "fieldName" : component.get("v.fieldName"),
            "value" : currentText,
            "brandName" : component.get("v.brandName"),
            "countryName" : component.get("v.countryName"),
            "patternName" : component.get("v.patternName"),
            "tyreSizeName" : component.get("v.tyreSizeName")
        });
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            
            console.log(state);
            
            if(state === "SUCCESS") {
                
                var custs = [];
                var conts = response.getReturnValue();

                for ( var key in conts ) {
                    custs.push({value:conts[key], key:key});
                }
                console.log(custs);
                component.set("v.searchRecords", custs);
                
                if(component.get("v.searchRecords").length == 0) {
                    console.log('000000');
                }
                
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
    
    setSelectedRecord : function(component, event, helper) { 
        var currentText = event.currentTarget.id;
        var resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');
        var objectName = component.get("v.objectName");
        console.log(objectName);
        console.log(currentText);
        //component.set("v.selectRecordName", currentText);
        component.set("v.selectRecordName", event.currentTarget.dataset.name);
        component.set("v.selectRecordId", currentText);
        component.find('userinput').set("v.readonly", false);
        var rowNo = component.get("v.rowNo");
        console.log(rowNo);
        var updateEvent = component.getEvent("updateLookupIdEvent");
        updateEvent.setParams({
            "index" : rowNo, "objectName" : objectName, "dynamicId" : currentText, "name" : event.currentTarget.dataset.name
        });
        updateEvent.fire();
    }, 
    
    resetData : function(component, event, helper) {
        component.set("v.selectRecordName", "");
        component.set("v.selectRecordId", "");
        component.find('userinput').set("v.readonly", false);
    }
})