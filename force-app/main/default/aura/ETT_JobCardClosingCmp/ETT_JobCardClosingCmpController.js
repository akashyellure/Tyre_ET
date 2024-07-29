({
    doInit : function(component, event, helper) {
        helper.getRelatedJobCards(component, event, helper);
    },
    handleClose : function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire(); 
	},
	submit : function(component, event, helper) {
        helper.updateToolsAndMaterialUsage(component, event, helper);
	},
})