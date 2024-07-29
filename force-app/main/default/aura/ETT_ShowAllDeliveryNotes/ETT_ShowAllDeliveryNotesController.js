({
	doInit : function(component, event, helper) {
        
        helper.getAllDeliveryNoteDetails(component, event, helper);
		
	},
    
    handleRowAction: function (component, event, helper) {
        
        var action = event.getParam('action');
      
        switch (action.name) {
            case 'print_DN':
                helper.printQuotation(component,event,helper);
                break;
        }
    }
})