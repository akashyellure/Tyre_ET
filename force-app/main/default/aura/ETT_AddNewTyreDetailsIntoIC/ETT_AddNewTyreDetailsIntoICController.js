({
    doInit : function(component, event, helper) {
        
    },
    clickCreate: function(component, event, helper) {
        
        var childComp = component.find('childComp');
        childComp.callChild(component.get("v.recordId"),'send','InspectionCard');
        
       	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/' + component.get("v.recordId")
        });
        urlEvent.fire();
        
    }
})