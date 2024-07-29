({
    getDeliveryNotes : function(component,event) {
        
        component.set('v.columns', [
            {label: 'ID', fieldName: 'deliveryNumber', type: 'text'},
            {label: 'Account Name', fieldName: 'accountName', type: 'text'},
            {label: 'Job Card', fieldName: 'jobCardNumber', type: 'text'},
            {label: 'Service Appointment', fieldName: 'serviceAppointmentNumber', type: 'text'},
            {label: 'Collection Card', fieldName: 'collectionNumber', type: 'text '},
            {label: 'Print', type: 'button-icon', typeAttributes:{name: 'print_note', variant:'bare', alternativeText:'Print Delivery Note', iconClass:'dark', title:'Print', iconName: 'utility:print'}}
        ]);
        var action = component.get("c.fetchDeliveryNotes");
        action.setParams({
            accountId : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
               console.log(response.getReturnValue());
               component.set('v.data',response.getReturnValue()); 
            }
        });
        $A.enqueueAction(action);
	},
    printNote: function (component, event, row) {
        try{
            console.log('print called');
            console.log(row.accountId);
            console.log(row.collectionId);
            var accountId = row.accountId;
            var collectionId = row.collectionId;
            var deliveryId = row.deliveryId;
            var casingType = row.casingType;
            var navService = component.find("navService");
          /*  var pageReference = {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ET_Print"    
                },    
                "state": {
                    "c__accountId": accountId  ,
                    "c__collectionCardId": collectionId,
                    "c__deliveryId" : deliveryId,
                    "c__casingType" : casingType
                }
            };
            component.set("v.pageReference", pageReference);
            var defaultUrl = "#";
            navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
            
            event.preventDefault();
            navService.navigate(pageReference);*/
          //  alert("Hi");
           // alert(deliveryId);
             var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
           // "url":"/apex/ETT_DeliveryNote_Print_PDF_From_Account?DeliveryNoteID="+deliveryId
           "url":"/apex/ETT_DeliveryNote_Print_PDF?Id="+deliveryId
        });
        urlEvent.fire();
        }
        catch(error){
            console.log(error.message);
        }
    }
})