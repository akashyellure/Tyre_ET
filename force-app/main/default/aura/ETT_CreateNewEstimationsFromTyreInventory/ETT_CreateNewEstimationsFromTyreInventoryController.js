({
    doInit : function(component, event, helper) {
        //$A.get('e.force:refreshView').fire();
        //$A.get("e.force:closeQuickAction").fire();
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
                component.set("v.isDisabled",true);
                var action = component.get('c.getTyreEstimations');
                action.setParams({
                    estimationId  : component.get("v.recordId")
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (state === "SUCCESS") {  
                        let data = response.getReturnValue();
                        // console.log(data)
                        if(data && data.Account__c != null){
                            component.set("v.EstimstionsType","Customer");
                            component.set("v.customerId",data.Account__c); 
                            component.set("v.customerName",data.Account__r.Name); 
                        }else{
                            component.set("v.EstimstionsType","Internal");
                            component.set("v.subInventoryId",data.SubInventory__c);
                            component.set("v.subInventoryName",data.SubInventory__r.Name);  
                        }
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
            }     
        }
    },
    
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
        debugger;
        
        let serialNo = component.get("v.searchVal")?component.get("v.searchVal"):null;
        let tyreSizeVal = component.get("v.tyreSizeVal");
        let brandVal = component.get("v.brandVal")?component.get("v.brandVal").toLowerCase():null;
        let patternVal = component.get("v.patternVal");
        let TyreType = component.get("v.TyreType"); 
        let threadPattern = component.get("v.ThreadPattern");            
        let countryVal = component.get("v.countryVal")?component.get("v.countryVal").toLowerCase():null;
        let customer = component.get("v.customerId"); 
        let subInventoryId = component.get("v.subInventoryId");
        
        if(serialNo || tyreSizeVal || brandVal ||patternVal || countryVal || TyreType || threadPattern || subInventoryIdval){ 
            var action = component.get('c.getTyreDetails');
            action.setParams({
                serialVal : serialNo,
                tyreSizeVal : tyreSizeVal,
                brandVal : brandVal, 
                patternVal : patternVal, 
                tyreType : TyreType, 
                countryVal : countryVal, 
                customerVal : customer,
                threadPattern:threadPattern,
                subInventoryIdval:subInventoryId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                    console.log(data)
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
            //component.set("v.isSearched",true);
        }else{
            helper.showErrorToast({
                "title": "Warning",
                "type": "warning",
                "message":"Please select one of the filter."
            });
        }
        //console.log("serialNo records is:"+JSON.stringify(serialNo));
        //console.log("tyreSizeVal records is:"+JSON.stringify(tyreSizeVal));
        //console.log("brandVal records is:"+JSON.stringify(brandVal));
        //console.log("patternVal records is:"+JSON.stringify(patternVal));
        //console.log("TyreType records is:"+JSON.stringify(TyreType));
        //console.log("countryVal records is:"+JSON.stringify(countryVal));
        //console.log("customer records is:"+JSON.stringify(customer));
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
    
    // If checkboxHeader is true then all records's checkbox true
    
    // If record's checkbox is false then checkboxHeader will false
    selectOneTyre: function(component, event , helper){
        var childCheckbox = event.getSource().get("v.value");
        if(childCheckbox==false)
        {
            component.set("v.isSelectAll",false);
            
        }
        console.log("childCheckbox records is:"+JSON.stringify(childCheckbox));
    },
    createEstimationHandler : function(component, event, helper){
        var getId= component.get("v.filterData");
        var getCheckAllId = [];
        getCheckAllId =component.find("checkTyre");
        var selectedData = [];
        if(getCheckAllId != undefined){
            for (var i = 0; i < getCheckAllId.length; i++){
                if(getCheckAllId[i].get("v.value") == true )
                {
                    //console.log("value of selected id is "+getId[i].Id);
                    selectedData.push(getId[i]);
                }
            }
        }
        //console.log("getCheckAllId records is:"+JSON.stringify(getCheckAllId));
        //console.log("getId records is:"+JSON.stringify(getId));
        //console.log("getcheckId records is:"+JSON.stringify(getCheckAllId));
        //console.log("selected records is:"+JSON.stringify(selectedData));
        
        //let selectedData = component.get("v.selectedTyres");
        let customerId = component.get("v.customerId");
        let subInventoryId = component.get("v.subInventoryId");
        let tyreEstimationId = component.get("v.recordId");
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
                customerId    : customerId,
                subInventoryId : subInventoryId,
                tyreEstimationId : tyreEstimationId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS"){  
                    component.set("v.showSpinner",false);
                    let data = response.getReturnValue();
                    console.log(data);
                    if(tyreEstimationId != '' && tyreEstimationId != null && tyreEstimationId != undefined){
                        helper.showErrorToast({
                            "title": "success",
                            "type": "success",
                            "message":"Estimation lines have been added successfully."
                        });
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": tyreEstimationId
                        });
                        navEvt.fire();
                        $A.get('e.force:refreshView').fire();
                    }else{
                        var action = component.get('c.filterHandler');
        				$A.enqueueAction(action);
                        
                        var dynamicMessage = 'Estimations have been created successfully {1},{2}!';
                        
                        var finalList = [];
                        for(var i=0; i<data.length; i++) {
                            finalList.push({
                                url: '/'+data[i].Tyre_Estimation__r.Id,
                                label: data[i].Tyre_Estimation__r.Name
                            });
                        }
                        
                        var dynamicMessage = dynamicMessage;
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": "pester",
                            "type": "success",
                            "duration": "20000",
                            "message": "Test Error Message",
                            "messageTemplate": 'Estimations have been created successfully {0},{1}',
                            "messageTemplateData": finalList
                        });
                        toastEvent.fire();
                        
        				//helper.showErrorToast({
                        //    "title": "success",
                        //    "type": "success",
                        //    "message":"Estimation is created successfully."
                        //});
                    }
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showErrorToast({
                                "title": "Error",
                                "type": "Error",
                                "message":"You cannot create Estimation for selected tyres."
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
                "message":"Search and select tyres to create Estimation."
            });
        }
    },
    handleCancel : function (component, event, helper) {
        let tyreEstimationId = component.get("v.recordId");
      
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": tyreEstimationId,
            "slideDevName": "related"
        });
        navEvt.fire();
    }
})