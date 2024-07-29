({
    /*doInit : function(component, event, helper) {
        
        var pageRef = component.get("v.pageReference");
        console.log(JSON.stringify(pageRef));
        var state = pageRef.state; // state holds any query params
        console.log('state = '+JSON.stringify(state));
        if(state != null ){
            var baseContext = state.inContextOfRef;
            if(baseContext != '' && baseContext != null){
                console.log('baseContext = '+baseContext);
                if (baseContext != null && baseContext.startsWith("1\.")) {
                    baseContext = baseContext.substring(2);
                    console.log('baseContext = '+baseContext);
                }
                var addressableContext = JSON.parse(window.atob(baseContext)); 
                console.log('addressableContext = '+JSON.stringify(addressableContext));
                component.set("v.recordId", addressableContext.attributes.recordId);
                
            }   
            
        } // alert(component.get("v.recordId")); 
            
        },*/
    
    selectAllTyres :function(component, event, helper) {
        let checkCmp = component.find("selectAllId");
        let data = component.get("v.filterData");
        data.forEach(function(item){
            if(checkCmp.get("v.value")){
                item.isChecked = true;
            }else{
                item.isChecked = false;  
            }
        });
        component.set("v.filterData",data);
    },
    
    filterHandler : function(component, event, helper) {
        
        let serialNo = component.get("v.searchVal")?component.get("v.searchVal"):null;
        let tyreSizeVal = component.get("v.tyreSizeVal");
        let brandVal = component.get("v.brandVal")?component.get("v.brandVal").toLowerCase():null;
        let patternVal = component.get("v.patternVal");
        let TyreType = component.get("v.TyreType");            
        let countryVal = component.get("v.countryVal")?component.get("v.countryVal").toLowerCase():null;
        let customer = component.get("v.customerId");
        let subInventory = component.get("v.subInventoryId");
        let tyreEstimationId = component.get("v.tyreEstimationId");
        
        if(serialNo || tyreSizeVal || brandVal ||patternVal || countryVal || TyreType || tyreEstimationId){ 
            var action = component.get('c.getTyreDetails');
            action.setParams({
                serialVal  : serialNo,
                tyreSizeVal: tyreSizeVal,
                brandVal   : brandVal, 
                patternVal : patternVal, 
                tyreType   : TyreType, 
                countryVal : countryVal, 
                customerId : customer,
                subInventoryId : subInventory,
                tyreEstimationId : tyreEstimationId
            });
            
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                     console.log(data);
                    data.forEach(function(item){
                        item.isChecked = false;
                    });
                    
                    if(data.length <= 0){
                        component.set("v.isSearched",true);   
                    }
                    component.set("v.filterData",data);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            helper.showErrorToast({
                                "title": "Error",
                                "type": "Error",
                                "message":errors[0].message
                            });
                            
                        }
                    } else {
                        console.log("Unknown error");
                        
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action); 
            
            
        }else{
            helper.showErrorToast({
                "title": "Warning",
                "type": "warning",
                "message":"Please select one of the filter."
            });
            
        }      
        
       /* console.log("serialNo records is:"+JSON.stringify(serialNo));
        console.log("tyreSizeVal records is:"+JSON.stringify(tyreSizeVal));
        console.log("brandVal records is:"+JSON.stringify(brandVal));
        console.log("patternVal records is:"+JSON.stringify(patternVal));
        console.log("TyreType records is:"+JSON.stringify(TyreType));
        console.log("countryVal records is:"+JSON.stringify(countryVal));
        */
    },
    
    /* AddSelectedLines : function(component, event, helper) {
        try{
            
            let data = component.get("v.filterData");
            
            if(data){
                
                let tempData = [];
                let mainData = component.get("v.tyreDetails");
                //console.log(data.length)
                data.forEach(function(item){
                    
                    if(item.isChecked){
                        tempData.push(item);
                        
                    }
                });
                
                if(tempData.length > 0){
                    let selectedData = component.get("v.selectedTyres");
                    
                    let newSelcVval = selectedData.concat(tempData);
                    
                    component.set("v.selectedTyres",newSelcVval);
                    //Remove selected records from Filter Data      
                    data = data.filter(ar => !tempData.find(rm => (rm.Serial_Number__c==ar.Serial_Number__c) ));
                    component.set("v.filterData",data);
                    //Remove selected records from main Data 
                    mainData = mainData.filter(ar => !tempData.find(rm => (rm.Serial_Number__c==ar.Serial_Number__c) ));
                    component.set("v.tyreDetails",mainData);     
                    //console.log(component.get("v.selectedTyres"));
                }else{
                    helper.showErrorToast({
                        "title": "Warning",
                        "type": "warning",
                        "message":"Select at least one tyre."
                    });
                }
            }else{
                helper.showErrorToast({
                    "title": "Warning",
                    "type": "warning",
                    "message":"Enter Tyre serial no/size to get data"
                });
                
            }
        }catch(e){
            console.log(e.message)
        }
    }, */
    
    /* onRemovePill : function(component, event, helper) {
        
        let selPill = event.getSource().get("v.name");
        selPill.isChecked = false;
        let selectedData = component.get("v.selectedTyres");
        
        const removeIndex = selectedData.findIndex( item => item.Serial_Number__c == selPill.Serial_Number__c);
        selectedData.splice(removeIndex, 1 );
        component.set("v.selectedTyres",selectedData);
        
        //Remove selected records from main Data        
        let mainData = component.get("v.tyreDetails");
        mainData.push(selPill);
        component.set("v.tyreDetails",mainData);
        
    }, */
    
    // If record's checkbox is false then checkboxHeader will false
    selectOneTyre: function(component, event , helper)
    {
        var childCheckbox = event.getSource().get("v.value");
        if(childCheckbox==false)
        {
            component.set("v.isSelectAll",false);
        }
    },
    
    createDeliveryNote : function(component, event, helper) {
        var getId= component.get("v.filterData");
        var getCheckAllId = [];
        getCheckAllId =component.find("checkTyre");
        var selectedData = [];
        if(getCheckAllId != undefined){
            for (var i = 0; i < getCheckAllId.length; i++){
                if(getCheckAllId[i].get("v.value") == true )
                {
                    console.log("value of selected id is "+getId[i].Id);
                    selectedData.push(getId[i]);
                }
            }
        }
        console.log("selected records is:"+JSON.stringify(selectedData));
        
        //let selectedData = component.get("v.selectedTyres");
        let customerId = component.get("v.customerId");
        let subInventoryId = component.get("v.subInventoryId");
        let deliveryNoteId = component.get("v.recordId");
        let tyreEstimationId = component.get("v.tyreEstimationId");
        
        //let partyType = component.get("v.partyType");  
        
        /*if(!customerId){   //&& partyType=='Customer'
            helper.showErrorToast({
                "title": "Warning",
                "type": "warning",
                "message":"Please select customer."
            });
           
        }else */ if(selectedData.length>0){ 
            
            //selectedData.forEach(item => delete item.isChecked);
            
            var action = component.get('c.createEstimations');
            component.set("v.showSpinner",true);
            action.setParams({
                selectedTyres : selectedData,
                customerId : customerId,
                subInventoryId : subInventoryId,
                deliveryNoteId : deliveryNoteId,
                tyreEstimationId:tyreEstimationId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    component.set("v.showSpinner",false);
                    let data = response.getReturnValue();
                    console.log(data);
                    var action = component.get('c.filterHandler');
        			$A.enqueueAction(action);
                    
                    var dynamicMessage = 'Delivery Notes have been created successfully {1},{2}!';
                    
                    var finalList = [];
                    for(var i=0; i<data.length; i++) {
                        finalList.push({
                            url: '/'+data[i].ETT_Delivery_Note__r.Id,
                            label: data[i].ETT_Delivery_Note__r.Name
                        });
                       
                    }
                    
                    var dynamicMessage = dynamicMessage;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": "pester",
                        "type": "success",
                        "duration": "20000",
                        "message": "Test Error Message",
                        "messageTemplate": 'Delivery Notes have been created successfully {0},{1}',
                        "messageTemplateData": finalList
                    });
                    // $A.get('e.force:refreshView').fire();
                    toastEvent.fire();
                   // helper.showErrorToast({
                   //     "title": "success",
                   //     "type": "success",
                   //     "message":"Delivery Notes have been created successfully."
                   // });
                    /*if(deliveryNoteId !== '' && deliveryNoteId !== null && deliveryNoteId !== undefined){
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": deliveryNoteId
                        });
                        
                        navEvt.fire();
                    }*/
                  // $A.get('e.force:refreshView').fire(); 
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showErrorToast({
                                "title": "Error",
                                "type": "Error",
                                "message":"You cannot create Delivery Notes for selected tyres."
                            });
                            
                            console.log("Error message: "+JSON.stringify(errors[0]));
                            component.set("v.showSpinner",false);
                        }
                    } else {
                        console.log("Unknown error");
                        component.set("v.showSpinner",false);
                    }
                }
            }); 
            
            $A.enqueueAction(action);  
            
        }else{
            helper.showErrorToast({
                "title": "Warning",
                "type": "warning",
                "message":"Search and select tyres to create Delivery Notes."
            });
        }
        
    }
    /*handleCancel : function (component, event, helper) {
        let deliveryNoteId = component.get("v.recordId");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": deliveryNoteId,
            "slideDevName": "related"
        });
        navEvt.fire();
    }*/
})