({
	doInit : function(component, event, helper) {
        var actSave = component.get("c.lstPurchaseLineItems");
        
        actSave.setParams({
            collectionCardId:component.get("v.recordId")
        });
        
        actSave.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('***response details ****'+response.getReturnValue());
                console.log('***response details ****'+JSON.stringify(response.getReturnValue()));
                component.set("v.estimationDetails",response.getReturnValue());
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        
                        helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:errors[0].message
                        });
                        
                    }
                }
            }else if (status === "INCOMPLETE") {
                
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:'No response from server or client is offline.'
                });
                
                console.log('No response from server or client is offline.');
            }else {
                console.log("Failed with state: " + state);
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:state
                });
            }
        });
        $A.enqueueAction(actSave);
    },
    
    acceptPurchaseOrders: function(component,event,helper){
        var purchaseOrderLineItemsHandle = component.get("c.purchaseOrderApprovalLineItems");
        purchaseOrderLineItemsHandle.setParams({
            lstEstimationQuotations:component.get("v.purchaseOrderLineItems")
        });
        purchaseOrderLineItemsHandle.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('***response details ****'+response.getReturnValue());
                console.log('***response details ****'+JSON.stringify(response.getReturnValue()));
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + response.getReturnValue()
                });
                urlEvent.fire();
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        
                        helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:errors[0].message
                        });
                        
                    }
                }
            }else if (status === "INCOMPLETE") {
                
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:'No response from server or client is offline.'
                });
                
                console.log('No response from server or client is offline.');
            }else {
                console.log("Failed with state: " + state);
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:state
                });
            }
        });
        $A.enqueueAction(purchaseOrderLineItemsHandle);
    }, 
     //Select all Estimations
    handleSelectAllPurchaseOrderLineItem: function(component, event, helper) {
    var purchaseOrderLineItems = component.get("v.purchaseOrderLineItems");
        var isHOO = component.get("v.isUserHOO");
        var isFM = component.get("v.isUserFM"); 
        
            for(var i=0; i<purchaseOrderLineItems.length; i++){
                if(isHOO){
                purchaseOrderLineItems[i].ETT_Accepted_by_HOO__c = component.get("v.isSelectAll");    
                }if(isFM){
                purchaseOrderLineItems[i].ETT_Accepted_by_FM__c = component.get("v.isSelectAll");    
                }
                
            }
            component.set("v.purchaseOrderLineItems",purchaseOrderLineItems);
    }
})