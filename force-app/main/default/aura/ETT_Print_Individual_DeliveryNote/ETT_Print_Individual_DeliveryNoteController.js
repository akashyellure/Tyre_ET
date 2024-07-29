({
    doInit : function(component, event, helper) {
        
        var today = new Date();
        component.set('v.objDeliveryNote.ETT_Date__c', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        console.log(component.get("v.recordId"));
        var action = component.get('c.getJobCardIntoListForPrint'); 
        action.setParams({
            "accountId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if(state === 'SUCCESS'){
                var objDeliveryLineItem = component.get("v.objDeliveryLineItem");
                var lstDeliveryLineItem = component.get("v.lstDeliveryLineItem");
                var result = response.getReturnValue();
                
                console.log(result);
                
                var opts = [];
                var collectionCardList = [];
                var collectionCardListChecks = [];
                var ccNames = '';
                var collectionKeys = [];//added - Ananya
                for(var i in result){
                    var quotationObj = new Object();
                    var deliveryLineItem = new Object();
                    
                    for(var key in result[i]){
                        
                        quotationObj.isChecked = false;
            
                    if(key=='ETT_Tyre_Size__r'){
                            quotationObj.ETT_Tyre_Size__r = result[i][key]['Name'];
                        }else if(key=='ETT_Brand__r'){
                            quotationObj.ETT_Brand__r =  result[i][key]['Name'];
                        }else if(key=='ETT_Pattern__r'){
                            quotationObj.ETT_Original_Pattern__c =  result[i][key]['Name'];
                        }else if(key=='ETT_Tyre_Serial_Number__c'){
                            quotationObj.ETT_Tyre_Serial_Number__c =  result[i][key];
                        }else if(key=='ETT_Thread_Pattern__c'){
                            quotationObj.ETT_Thread_Pattern__c =  result[i][key];
                        }else if(key=='ETT_Status__c'){
                            quotationObj.ETT_Status__c =  result[i][key];
                        }else if(key=='ETT_Collection_Card__r'){
                            ccNames = ccNames+', '+result[i][key]['Name'];
                            quotationObj.ETT_Collection_Card__c = result[i][key]['Name'];
                            if(!collectionKeys.includes(result[i][key]['Name']))// added by ananya
                            {
                                collectionCardList.push({key: result[i][key]['Name'], value: result[i][key]['Name']});
                                collectionKeys.push(result[i][key]['Name']);
                            }
                            deliveryLineItem.ETT_Collection_Card__c = result[i][key]['Id'];
                            deliveryLineItem.ETT_Service_Appointment__c = result[i][key]['ETT_Service_Appointment__c'];
                            deliveryLineItem.ETT_Delivery_Note__c = result[i][key]['ETT_Delivery_Note__c'];
                           }
                            //else if(key=='ETT_Delivery_Note__c'){
                            //deliveryLineItem.ETT_Delivery_Note__c =  result[i][key];
                        //} 
                        else if(key=='ETT_Tyre_Size__c'){
                            deliveryLineItem.ETT_Tyre_Size__c =  result[i][key];
                        }else if(key=='ETT_Brand__c'){
                            deliveryLineItem.ETT_Brand_Master__c =  result[i][key];
                        }else if(key=='ETT_Pattern__c'){
                            deliveryLineItem.ETT_Pattern_Master__c =  result[i][key];
                            //deliveryLineItem.ETT_Tread_Pattern_Master__c =  result[i][key];
                            deliveryLineItem.ETT_Job_Type__c = 'Retread';
                        }else if(key=='Id'){
                            quotationObj.InspectionCardId = result[i][key];
                            deliveryLineItem.ETT_Inspection_Card__c = result[i][key];
                        }else if(key=='Job_Cards__r'){
                            quotationObj.ETT_Status__c = 'Rejected';
                            quotationObj.FailedReason = result[i][key][0]['ETT_Failed_Reason__c'];
                        }
                        
                        
                    }
                    
                    objDeliveryLineItem = component.get("v.objDeliveryLineItem");
                    objDeliveryLineItem.push(quotationObj);
                    component.set("v.objDeliveryLineItem",objDeliveryLineItem);
                    
                    lstDeliveryLineItem = component.get("v.lstDeliveryLineItem");
                    lstDeliveryLineItem.push(deliveryLineItem);
                    component.set("v.lstDeliveryLineItem",lstDeliveryLineItem); 
                    console.log('lstDeliveryLineItem'+lstDeliveryLineItem);
                }
                component.set("v.collectionCardList",collectionCardList);
                component.set('v.objDeliveryNote.ETT_Collection_Cards__c',ccNames);
            }else if(state === "ERROR"){
                component.set('v.isDLIPrepared',true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        
                        /*helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:errors[0].message
                        });*/
                        
                    }
                }
            }else if (state === "INCOMPLETE") {
                
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
        
        var actionUser = component.get("c.fetchUser");
        actionUser.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(actionUser);
    },
    printPage : function(cmp,event){
         setTimeout(function(){
            window.print();
        }, 2000);
        /*try{
            
            
            var navService = cmp.find("navService");
            var pageReference = {
                
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__PDFContainer"    
                },
                "state": {
                    "c__pdfContainer": cmp 
                }
            };
            cmp.set("v.pageReference", pageReference);
            var defaultUrl = "#";
            navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                cmp.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                cmp.set("v.url", defaultUrl);
            }));
            console.log('done');
            navService.navigate(pageReference);
        }
        catch(error)
        {
            console.log(error.message);
        }*/
    },
    handleSelectAllEstimation : function(component, event, helper){
        
        var isSelectAll = component.get("v.isSelectAll");
        if(isSelectAll){
            var objDeliveryLineItem = component.get("v.objDeliveryLineItem");
            for(var i=0; i<objDeliveryLineItem.length; i++){
                objDeliveryLineItem[i].isChecked = true;
            }
        }else{
            var objDeliveryLineItem = component.get("v.objDeliveryLineItem");
            for(var i=0; i<objDeliveryLineItem.length; i++){
                objDeliveryLineItem[i].isChecked = false;
            }
        }
        component.set("v.objDeliveryLineItem",objDeliveryLineItem);
    },
    
    Submit : function(component, event, helper) {
        
        var objDeliveryNote = component.get("v.objDeliveryNote");
        if(objDeliveryNote.ETT_Phone__c!='' && objDeliveryNote.ETT_Phone__c!=null){
            if(isNaN(objDeliveryNote.ETT_Phone__c)){
                helper.showErrorToast({
                    title: "Required:",
                    type: "error",
                    message:
                    "Please enter only digits into Telephone"
                });
                return false;
            }
            if(objDeliveryNote.ETT_Phone__c.length != 10){
                helper.showErrorToast({
                    title: "Required:",
                    type: "error",
                    message:
                    "Please enter 10 digits Telephone"
                });
                return false;
            }
        }
        var BillingStreet = component.get("v.DeliveryNoteRecord").BillingStreet;
        objDeliveryNote.ETT_Account__c = component.get("v.recordId");
        objDeliveryNote.ETT_Casing__c = 'Customer Casing';
        objDeliveryNote.ETT_Address__c = BillingStreet;
        objDeliveryNote.ETT_Is_Delivery_Appointment_Booked__c = false;
        
        
        var objDeliveryLineItem = component.get("v.objDeliveryLineItem");
        var lstDeliveryLineItem = component.get("v.lstDeliveryLineItem");
        
        for(var i=0;i<objDeliveryLineItem.length;i++){
            for(var j=0;j<lstDeliveryLineItem.length;j++){
                if(objDeliveryLineItem[i].InspectionCardId == lstDeliveryLineItem[j].ETT_Inspection_Card__c && objDeliveryLineItem[i].isChecked==true){
                    var deliveryLineItem = new Object();
                    deliveryLineItem.ETT_Inspection_Card__c = lstDeliveryLineItem[j].ETT_Inspection_Card__c;
                    deliveryLineItem.ETT_Tyre_Size__c = lstDeliveryLineItem[j].ETT_Tyre_Size__c;
                    deliveryLineItem.ETT_Brand_Master__c = lstDeliveryLineItem[j].ETT_Brand_Master__c;
                    deliveryLineItem.ETT_Pattern_Master__c = lstDeliveryLineItem[j].ETT_Pattern_Master__c;
                    deliveryLineItem.ETT_Job_Type__c = lstDeliveryLineItem[j].ETT_Job_Type__c;
                    deliveryLineItem.ETT_Collection_Card__c = lstDeliveryLineItem[j].ETT_Collection_Card__c;
                    objDeliveryNote.ETT_Collection_Card__c = lstDeliveryLineItem[j].ETT_Collection_Card__c;
                    objDeliveryNote.ETT_Service_Appointment__c = lstDeliveryLineItem[j].ETT_Service_Appointment__c;
                    var lstDeliveryLineItemArr = component.get('v.lstDeliveryLineItemArr');
                    lstDeliveryLineItemArr.push(deliveryLineItem);
                    component.set('v.lstDeliveryLineItemArr',lstDeliveryLineItemArr);
                }
            }   
        }
        
        var lstDeliveryLineItemArr = component.get('v.lstDeliveryLineItemArr');
        
        var action = component.get('c.submitDeliveryNote'); 
        var mapOfObjects = {
            deliveryNoteJson: JSON.stringify(objDeliveryNote),
            deliveryLineItemJson: JSON.stringify(lstDeliveryLineItemArr)
        };
        action.setParams({
            mapOfObjects: mapOfObjects
        });
        
        console.log(mapOfObjects);
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if(state == 'SUCCESS'){
                console.log(response.getReturnValue());
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
            }else if(state === "INCOMPLETE") {
                
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