({
    doInit : function(component, event, helper) {
        
        var objWorkOrder  = component.get("v.objWorkOrder"); 
        var objAssignedResource  = component.get("v.objAssignedResource"); 
        var action1 = component.get("c.objContactDetails");
        action1.setParams({
            "oppId": component.get("v.recordId")
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.objContact",response.getReturnValue());
            }else if(state === "ERROR"){
                var errors = action1.getError();
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
        
        $A.enqueueAction(action1);
        
        /*objWorkOrder.push({
            'sobjectType': 'WorkOrder',
            'AccountId':'',
            'ContactId':'',
            'ETT_Opportunity__c':'',
            'ETT_Number_Of_Tyres__c':'',
            'WorkTypeId':'',
            'ETT_Process__c':''
        }); */
        
        /* objAssignedResource.push({
            'sobjectType': 'AssignedResource',
            'ServiceAppointmentId':'',
            'ServiceResourceId':'',
            'ServiceCrewId':'',
            'ETT_Vehicle_Detail__c':'',
            'EstimatedTravelTime':'',
            'ActualTravelTime':''
        }); */
        
        
        //component.set("v.objWorkOrder",objWorkOrder);
        //component.set("v.objAssignedResource",objAssignedResource);
        var action = component.get("c.objContactDetails");
        
        action.setParams({
            "oppId": component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log(state);
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.objContact",response.getReturnValue());
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
        
        $A.enqueueAction(action);
        
        helper.fetchPickListVal(component, "ETT_Process__c", "processMap");
        helper.fetchPickListVal(component, "ETT_Tyre_Type__c", "tyreTypeMap");
        
    },
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    onCheck: function(component, event, helper) {
        console.log('called');
        var checkCmp = component.find("skip").get("v.value");
        console.log(checkCmp);
        component.set('v.showServiceApt',checkCmp);
    },
    submit: function(component, event, helper) {
        
        var objAccount = component.get("v.objAccount");
        objAccount.Id = component.get("v.opportunityCardRecord").Account.Id;
        objAccount.Party_Type__c = component.get("v.opportunityCardRecord").Account.Party_Type__c;
        objAccount.ETT_Payment_Type__c = component.get("v.opportunityCardRecord").Account.ETT_Payment_Type__c;
        component.set("v.objAccount",objAccount);

        var isSkip = component.get('v.showServiceApt');
        
        var objServiceApt = component.get("v.objServiceAppointment");
        objServiceApt.AccountId = component.get("v.opportunityCardRecord").Account.Id;
        objServiceApt.ParentRecordId = component.get("v.opportunityCardRecord").Account.Id;
        objServiceApt.ETT_Opportunity__c = component.get("v.opportunityCardRecord").Id;
        objServiceApt.ContactId =  component.get("v.objContact").Id;       
        objServiceApt.Status = 'None';        
                
        var objWorkOrder = component.get("v.objWorkOrder");
        objWorkOrder.AccountId = component.get("v.opportunityCardRecord").Account.Id;
        objWorkOrder.ETT_Opportunity__c = component.get("v.recordId");
        objWorkOrder.ContactId = component.get("v.objContact").Id; 
        //console.log(component.get("v.recordId"));
        component.set("v.objWorkOrder",objWorkOrder);
        
        console.log(JSON.stringify(component.get("v.objAccount")));
        console.log(JSON.stringify(component.get("v.objWorkOrder")));
        console.log(JSON.stringify(objServiceApt));        
        console.log(JSON.stringify(component.get("v.objAssignedResource")));
        console.log('isSkip: '+isSkip);
   
        
        var action = component.get("c.workOrderProcess");
        action.setParams({
            "objAcct": component.get("v.objAccount"),
            "objWorkOrder": component.get("v.objWorkOrder"),
            "objServiceAppt": objServiceApt,
            "objAssignedResource": component.get("v.objAssignedResource"),
            "isSkipAppointment": component.get('v.showServiceApt')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log(state);
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
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
                component.set("v.showServiceApt",false);
                component.set("v.errorServiceApt",true);
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
        
        $A.enqueueAction(action);
        
    }
})