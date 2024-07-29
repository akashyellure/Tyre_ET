({
    searchField : function(component, event, helper) {
        
        var currentText = event.getSource().get("v.value");
        var resultBox = component.find('resultBox');
        component.set("v.LoadingText", true);
        if(currentText.length > 0) {
            $A.util.addClass(resultBox, 'slds-is-open');
        }
        else {
            $A.util.removeClass(resultBox, 'slds-is-open');
        }
        var action = component.get("c.getResults");
        action.setParams({
            "ObjectName" : component.get("v.objectName"),
            "fieldName" : component.get("v.fieldName"),
            "value" : currentText
        });
        
        action.setCallback(this, function(response){
            var STATE = response.getState();
            if(STATE === "SUCCESS") {
                component.set("v.searchRecords", response.getReturnValue());
                if(component.get("v.searchRecords").length == 0) {
                    component.set("v.selectRecordName",currentText);
                    console.log('000000');
                }
            }else if (state === "ERROR") {
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
        //component.set("v.selectRecordName", currentText);
           var rowNo = component.get("v.rowNo");
            component.set("v.selectedIndex", rowNo);
        component.set("v.selectRecordName", event.currentTarget.dataset.name);
          component.set("v.selectRecordName1", event.currentTarget.dataset.name);
        component.set("v.selectRecordId", currentText);
        component.set("v.selectRecordId1", currentText);
      //  component.set("v.selectRecordId1", currentText);
        component.find('userinput').set("v.readonly", false);
       
        var updateEvent = component.getEvent("updateLookupIdEvent");
        updateEvent.setParams({
            "index" : rowNo, "objectName" : objectName, "dynamicId" : currentText, "name" : event.currentTarget.dataset.name
        });
        updateEvent.fire();
    }, 
    
    
    resetData : function(component, event, helper) {
        component.set("v.selectRecordName", "");
        component.set("v.selectRecordId", "");
        component.set("v.selectRecordId1", "");
        component.set("v.selectRecordName1", "");
        component.find('userinput').set("v.readonly", false);
    }
})