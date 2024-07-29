({
	getAllDeliveryNoteDetails : function (component,event, helper){
        
      component.set('v.columns', [
            {label: 'ID', fieldName: 'Name', type: 'text'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date',typeAttributes: {day: 'numeric',month: 'short',year: 'numeric',hour: '2-digit',minute: '2-digit',second: '2-digit',hour12: false }},
            {label: 'Created By', fieldName: 'createdBy', type: 'text'},
            {label: 'Print', type: 'button-icon', typeAttributes:{name: 'print_DN', variant:'bare', alternativeText:'Print DN', iconClass:'dark', title:'Print', iconName: 'utility:print'}}
        ]);
      
       var action = component.get('c.getAllDeliveryNotes');
      
        action.setParams({
            recordId : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                
               let records = response.getReturnValue();
                records.forEach(function(item){
                    
                    item.createdBy = item.CreatedBy.Name;
                    
                });                 
               
                component.set("v.data",records);  
                
                
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Err -getDeliveryNotes " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
          }); 
        
        $A.enqueueAction(action);  
        
    },
    
    printQuotation : function (component, event, helper) {
        var row = event.getParam('row');
      
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
           "url":"/apex/ETT_DeliveryNote_Print_PDF?Id="+row.Id
        });
        urlEvent.fire();
        
        
    }
		
	
})