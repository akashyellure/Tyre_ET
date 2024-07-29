({
	doInit : function(component, event, helper) {
		helper.getDeliveryNotes(component,event);
	},
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'print_note':
                helper.printNote(component,event,row);
                break;
        }
    }
})