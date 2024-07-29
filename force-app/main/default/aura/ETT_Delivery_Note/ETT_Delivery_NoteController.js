({
	doInit : function(component, event, helper) {
      
        var getPhoneaction = component.get('c.getPhoneFromAccount'); 
        getPhoneaction.setParams({
            "accountId" : component.get("v.recordId")
        });
        getPhoneaction.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if(state === 'SUCCESS'){
                 var result = response.getReturnValue();
                if(result!=''){
                    var phoneCmp = component.find("deliveryNotePhone");
                    result = result.replace(" ","");
                  	phoneCmp.set("v.value",result);
                }
                
            }});
        $A.enqueueAction(getPhoneaction);
        
        var today = new Date();
        component.set('v.objDeliveryNote.ETT_Date__c', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        
        var action = component.get('c.getJobCardIntoList'); 
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
                console.log('Data'+objDeliveryLineItem);
                console.log('kklasd'+JSON.stringify(result));
                
                var opts = [];
                var collectionCardList = [];
                var collectionCardListChecks = [];
                var ccNames = '';
              	var collectionKeys = []; //added - Ananya
                for(var i in result){
                    var quotationObj = new Object();
                    var deliveryLineItem = new Object();
                    
                    for(var key in result[i]){
						quotationObj.isChecked = false;
                        
                        if(key=='ETT_Tyre_Size__r'){
                           
                            quotationObj.ETT_Tyre_Size__r = result[i][key]['Name'];
                        }
                        if(key=='ETT_Account__r'){
                            deliveryLineItem.Party_Type__c = result[i][key]['Party_Type__c'] + ' Casing';
                        }
                        else if(key=='ETT_Brand__r.Name'){
                              alert(result[i][key]['Name']);
                            quotationObj.ETT_Brand__r.Name =  result[i][key]['Name'];
                        }else if(key=='ETT_Pattern__r'){
                            quotationObj.ETT_Original_Pattern__c =  result[i][key]['Name'];
                        }else if(key=='ETT_Tyre_Serial_Number__c'){
                            quotationObj.ETT_Tyre_Serial_Number__c =  result[i][key];
                        }else if(key=='ETT_Thread_Pattern__c'){
                            quotationObj.ETT_Thread_Pattern__c =  result[i][key];
                        }else if(key=='ETT_Status__c'){
                            quotationObj.ETT_Status__c =  result[i][key];
                            // line no 67 to 69 is added by goldy singh
                            if(result[i][key]=='Send Back'){
								deliveryLineItem.ETT_Job_Type__c = 'Send Back';
                            }

                        }else if(key=='ETT_Collection_Card__r'){
                            ccNames = ccNames+', '+result[i][key]['Name'];
                            quotationObj.ETT_Collection_Card__c = result[i][key]['Name'];
                            if(!collectionKeys.includes(result[i][key]['Name'])) // added by ananya
                            {
                                collectionCardList.push({key: result[i][key]['Name'], value: result[i][key]['Name']});
                                collectionKeys.push(result[i][key]['Name']);
                            }
                        	deliveryLineItem.ETT_Collection_Card__c = result[i][key]['Id'];
                          //  var link = '/' + result[i][key]['Id'];
                            //quotationObj.ETT_CollectionCardLink = link;
                            //alert(result[i][key]['Id']);
                            deliveryLineItem.ETT_Service_Appointment__c = result[i][key]['ETT_Service_Appointment__c'];
                            deliveryLineItem.ETT_Phone__c = result[i][key]['ETT_Phone__c'];
                            deliveryLineItem.ETT_Vehicle_Detail__c = result[i][key]['ETT_Vehicle_Detail__c'];
                        }else if(key=='ETT_Tyre_Size__c'){
                            deliveryLineItem.ETT_Tyre_Size__c =  result[i][key];
                        }else if(key=='ETT_Brand__c'){
                            deliveryLineItem.ETT_Brand_Master__c =  result[i][key];
                        }else if(key=='ETT_Pattern__c'){
                            deliveryLineItem.ETT_Pattern_Master__c =  result[i][key];
                            //deliveryLineItem.ETT_Tread_Pattern_Master__c =  result[i][key];
                           // deliveryLineItem.ETT_Job_Type__c = 'Retread'; Commented by Goldy Singh
                        }else if(key=='Id'){
                            quotationObj.InspectionCardId = result[i][key];
                            deliveryLineItem.ETT_Inspection_Card__c = result[i][key];
                            var link = '/' + result[i][key];
                            quotationObj.InspectionCardIdLink = link;
                          //alert(deliveryLineItem.InspectionCardIdLink);
                            
                        }
                            else if(key=='Name'){
                            quotationObj.InspectionCardName = result[i][key];
                           // deliveryLineItem.Inspection_Card_Name__c = result[i][key];
                             //alert(result[i][key]);
                        }
                                else if(key=='Job_Cards__r'){
                            quotationObj.ETT_Status__c = 'Rejected';
                            quotationObj.FailedReason = result[i][key][0]['ETT_Failed_Reason__c'];
                            deliveryLineItem.ETT_Job_Card__c = result[i][key][0]['ETT_Job_Card__c']; 
                        }
                        
                        
                    }
                   
                    objDeliveryLineItem = component.get("v.objDeliveryLineItem");
                    objDeliveryLineItem.push(quotationObj);
                    component.set("v.objDeliveryLineItem",objDeliveryLineItem);
                   // alert(deliveryLineItem.Inspection_Card_Name__c);
                    lstDeliveryLineItem = component.get("v.lstDeliveryLineItem");
                    lstDeliveryLineItem.push(deliveryLineItem);
                    component.set("v.lstDeliveryLineItem",lstDeliveryLineItem);                    
                }
                console.log(collectionCardList);
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
             var Phone = objDeliveryNote.ETT_Phone__c;
       // var phonRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d+$/;
        //    var phonRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d+$/;
             var phonRegex=   /^(?:\+971|00971|0)?(\s)?(?:50|51|52|54|55|56|2|3|4|6|7|9)\d{7}$/;
         if(Phone!=null&&Phone!=""){
            if(!Phone.toString().match(phonRegex))
            {
                helper.showErrorToast({
                    title: "Required:",
                    type: "error",
                    message:
                    "Please enter valid Telephone Number"
                });
                return false;
            }
         }
           /* if(isNaN(objDeliveryNote.ETT_Phone__c)){
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
            }*/
        }
        var BillingStreet = component.get("v.DeliveryNoteRecord").BillingStreet;
         // var accphone = component.get("v.DeliveryNoteRecord").Phone;
           //alert(accphone);
        objDeliveryNote.ETT_Account__c = component.get("v.recordId");
        //objDeliveryNote.ETT_Casing__c = 'Customer Casing';
        
        
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
					deliveryLineItem.ETT_Tyre_Serial_Number__c = objDeliveryLineItem[i].ETT_Tyre_Serial_Number__c;
                   // deliveryLineItem.ETT_Tread_Pattern__c = lstDeliveryLineItem[j].ETT_Pattern_Master__c;
                   // alert(deliveryLineItem.ETT_Tread_Pattern__c);
                    objDeliveryNote.ETT_Collection_Card__c = lstDeliveryLineItem[j].ETT_Collection_Card__c;
                    objDeliveryNote.ETT_Service_Appointment__c = lstDeliveryLineItem[j].ETT_Service_Appointment__c;
                    objDeliveryNote.ETT_Job_Card__c	 = lstDeliveryLineItem[j].ETT_Job_Card__c;
                    objDeliveryNote.ETT_Phone__c = lstDeliveryLineItem[j].ETT_Phone__c;
                    objDeliveryNote.ETT_Vehicle_Numbers__c  = lstDeliveryLineItem[j].ETT_Vehicle_Detail__c;
                    objDeliveryNote.ETT_Casing__c  = lstDeliveryLineItem[j].Party_Type__c;
                    //below line is added by goldy singh
                    objDeliveryNote.Tyre_Inspection_Card__c = lstDeliveryLineItem[j].ETT_Inspection_Card__c;
                    var lstDeliveryLineItemArr = component.get('v.lstDeliveryLineItemArr');
                    lstDeliveryLineItemArr.push(deliveryLineItem);
                    component.set('v.lstDeliveryLineItemArr',lstDeliveryLineItemArr);
                }
            }   
        }
        
        var lstDeliveryLineItemArr = component.get('v.lstDeliveryLineItemArr');

        console.log(JSON.stringify(objDeliveryNote));        
        console.log(JSON.stringify(lstDeliveryLineItemArr));
       // return false;
        
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