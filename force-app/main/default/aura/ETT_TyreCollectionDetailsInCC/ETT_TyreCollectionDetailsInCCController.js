({
    doInit : function(component, event, helper) {
        
     
        let tyreInventoryList  = component.get("v.lstTyreInventory"); 
        
        var tyre = new Object();
        tyre.sobjectType = 'ETT_Tyre_Inventory__c';
        tyre.ETT_Tyre_Size_Master__c = '';
        tyre.ETT_Brand__c='';
        tyre.ETT_Pattern__c='';
        tyre.ETT_Country__c='';
        tyre.ETT_Tyre_Life__c='1';
        tyre.ETT_Inventory_Status__c='Draft';
        tyre.Serial_Number__c='';
        tyre.Job_Type__c='Retread';
        tyre.Process_Type__c='Precure';
        tyre.ETT_Collection_Card__c = component.get("v.recordId");
        tyre.Claim_Process__c='Normal';
        tyre.Remarks__c='';
     
        
        tyreInventoryList.push(tyre);
        component.set("v.lstTyreInventory",tyreInventoryList);
        
        let tempTyreDetails = component.get("v.stgNewCollTyreInfo");
        
        var tyreInfo = new Object();
        tyreInfo.sobjectType = 'ETT_StagingNewTyreCollection__c';
        tyreInfo.Size_Name__c=null;
        tyreInfo.Brand_Name__c=null;
        tyreInfo.Pattern_Name__c=null;
        tyreInfo.Country_Name__c=null;
        tyreInfo.Job_Type__c='Retread';
        tyreInfo.Process_Type__c='Precure';
        tyreInfo.ETT_Inventory_Status__c='Draft';
        tyreInfo.Collection_Card__c=component.get("v.recordId");
        tempTyreDetails.push(tyreInfo);
        component.set("v.stgNewCollTyreInfo",tempTyreDetails);
        
        helper.fetchPickListVal(component, "ETT_Tyre_Life__c", "TyreLifeMap");
        helper.fetchPickListVal(component, "Job_Type__c", "JobTypeMap");
        helper.fetchPickListVal(component, "Claim_Process__c", "ClaimProcessMap");
        helper.fetchPickListVal(component, "Process_Type__c", "ProcessTypeMap");
        helper.fetchPickListVal(component, "ETT_Inventory_Status__c", "InventoryStatus");
        helper.getTyreInventoryFrmServerHelper(component, event, helper);
        helper.getStagTyreFrmServerHelper(component, event, helper);
        helper.getUserLoginInfoHelper(component, event, helper);
        helper.getTyreMasterDetailsHelper(component, event, helper);
        helper.getPriceConfirmationDetailsHelper(component, event, helper);
        helper.getMoveOrderDetails(component, event, helper);
    },
    
    onForceCCLoad :function(component, event, helper) {
        
        let data = component.get("v.CCRecord");
        if(data.ETT_Check_In__c != null){
            
            component.set("v.showToggleCheckCmp",true);
            component.set("v.showMainCmp",true);
        }
        if(data.Approval_Status__c == 'Approved'){
            component.set("v.CCApproved",true);
            component.set("v.readMode",true);
            
        }
        if(data.ETT_Check_Out__c !=null){
            //Hide update/upsert/CheckOut
            
        }
        
    },
    
    closeModel : function(component, event, helper) {
        //added custom close to refresh page after close
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
        
    },
    addNewRow : function(component, event, helper){
        
        let tyreInventoryList  = component.get("v.lstTyreInventory");         
        var tyre = new Object();
        tyre.sobjectType = 'ETT_Tyre_Inventory__c';
        tyre.ETT_Tyre_Size_Master__c = '';
        tyre.ETT_Brand__c='';
        tyre.ETT_Pattern__c='';
        tyre.ETT_Country__c='';
        tyre.ETT_Tyre_Life__c='1';
        tyre.ETT_Inventory_Status__c='Draft';
        tyre.Serial_Number__c='';
        tyre.Job_Type__c='Retread';
        tyre.Process_Type__c='Precure';
        tyre.Claim_Process__c='Normal';
        tyre.ETT_Collection_Card__c = component.get("v.recordId");
        tyre.Remarks__c='';
        tyreInventoryList.push(tyre);
        component.set("v.lstTyreInventory",tyreInventoryList);
        component.set("v.TyreSizeName",'');
        component.set("v.BrandName",'');
        component.set("v.PatternName",'');
        component.set("v.CountryName",'');
    },
    
    removeRow :  function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.lstTyreInventory");
        console.log('****whichOne****'+whichOne);
        AllRowsList.splice(whichOne, 1);
        component.set("v.lstTyreInventory", AllRowsList);
    },
    
    copyThisLine :function(component,event,helper){
        
        var selectedSection = event.currentTarget;
        var index = selectedSection.dataset.index;
        var AllRowsList = component.get("v.lstTyreInventory");
        
        var tyre = new Object();
        tyre.sobjectType = 'ETT_Tyre_Inventory__c';
        tyre.ETT_Tyre_Size_Master__c = AllRowsList[index].ETT_Tyre_Size_Master__c;
        tyre.Temp_Size_Name__c=AllRowsList[index].Temp_Size_Name__c;
        tyre.Temp_Brand_Name__c=AllRowsList[index].Temp_Brand_Name__c;
        tyre.Temp_Pattern_Name__c=AllRowsList[index].Temp_Pattern_Name__c;
        tyre.Temp_Country_Name__c=AllRowsList[index].Temp_Country_Name__c;
        tyre.ETT_Brand__c=AllRowsList[index].ETT_Brand__c;
        tyre.ETT_Inventory_Status__c=AllRowsList[index].ETT_Inventory_Status__c;
        tyre.ETT_Pattern__c=AllRowsList[index].ETT_Pattern__c;
        tyre.ETT_Country__c=AllRowsList[index].ETT_Country__c;
        tyre.ETT_Tyre_Life__c=AllRowsList[index].ETT_Tyre_Life__c;
        tyre.Serial_Number__c=AllRowsList[index].Serial_Number__c;
        tyre.Job_Type__c=AllRowsList[index].Job_Type__c;
        tyre.Claim_Process__c=AllRowsList[index].Claim_Process__c;
        tyre.Process_Type__c=AllRowsList[index].Process_Type__c;
        tyre.ETT_Collection_Card__c = component.get("v.recordId");
        tyre.Remarks__c=AllRowsList[index].Remarks__c;
        AllRowsList.push(tyre);
        component.set("v.lstTyreInventory",AllRowsList);     
        
    },
    convertCase:function(component, event, helper){     
        var val = event.getSource().get("v.value");
        if(val!=null){
            val = val.toUpperCase();
            var selectCmp = event.getSource();
            selectCmp.set("v.value",val) ;
        }
    },
    
    
    startCollection : function(component, event, helper){ 
        
        var action = component.get('c.updateCollectionCard');
        
        action.setParams({
            recordId : component.get("v.recordId"),
            fieldName : 'ETT_Check_In__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                component.set("v.showMainCmp",true);
                component.set("v.showToggleCheckCmp",true);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);  
        
    },
    stopCollection : function(component, event, helper){ 
        
        var action = component.get('c.updateCollectionCard');
        component.set("v.showSpinner",true);
        action.setParams({
            recordId : component.get("v.recordId"),
            fieldName : 'ETT_Check_Out__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
                component.set("v.showSpinner",false);
                
                helper.showErrorToast({
                    "title": "success",
                    "type": "success",
                    "message":"Your request has been submitted successfully."
                });
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showErrorToast({
                            "title": "error",
                            "type": "error",
                            "message":errors[0].message
                        });
                        component.set("v.showSpinner",false);
                    }
                } else {
                    console.log("Unknown error");
                    component.set("v.showSpinner",false);
                }
            }
        }); 
        
        $A.enqueueAction(action);  
        
    },
    handleSave : function(component, event, helper){
        debugger;
        let data = component.get("v.lstTyreInventory");
        let newStagTyreData = component.get("v.stgNewCollTyreInfo");
        
        let hasErrorNewTyre = false;
        let hasStagTyre = false;
        console.log(data);
        
        if(data){
            
            data.forEach(function(item){
                
                if(item.ETT_Tyre_Size_Master__c == '' && item.ETT_Brand__c == '' && item.ETT_Country__c==''){
                   hasErrorNewTyre = true;
                }
                
            });
            
        }
        if(newStagTyreData){
            newStagTyreData.forEach(function(item){
                
                if(item.Size_Name__c == null && item.Brand_Name__c==null && item.Country_Name__c==null){
                    hasStagTyre = true;
                    
                }
            });
            
        }
        
        if(hasStagTyre && hasErrorNewTyre){
            
            helper.showErrorToast({
                "title": "Required",
                "type": "error",
                "message": "Tyre or New Tyres are required to proceed"
            });
            return false;
            
        }
        
        if(!hasErrorNewTyre){
            data.forEach(function(item){
                
                if(item.ETT_Tyre_Size_Master__c == '' || item.ETT_Tyre_Size_Master__c == null ||
                   item.ETT_Brand__c == '' || item.ETT_Brand__c == null ||
                   item.ETT_Pattern__c == '' || item.ETT_Pattern__c == null ||
                   item.ETT_Country__c == '' || item.ETT_Country__c == null || 
                   item.Serial_Number__c == '' || item.Serial_Number__c == null
                  ){
                    
                    hasErrorNewTyre = true;
                    helper.showErrorToast({
                        "title": "Required",
                        "type": "error",
                        "message": "Tyre Size,Brand, Pattern, Country of Origin, Tyre Serial Number Fields are required"  
                    });
                    return false;
                    
                }
            });
            //Check Duplicate data
            var uniqueArray = [];
            data.forEach(function(item){ 
                
                var combin  =  item.ETT_Brand__c+'#'+item.Serial_Number__c+'#'+item.ETT_Tyre_Life__c;
                
                if(uniqueArray.indexOf(combin) > -1) {
                    
                    hasErrorNewTyre = true;
                    helper.showErrorToast({
                        "title": "Error: Tyre Collection",
                        "type": "error",
                        "message": "Tyre Serial Number with Tyre Life should be unique for every record"
                    });
                    return false;
                }else{
                    uniqueArray.push(combin);
                }
                
            });
        }
        
        //New Tyre Validation process -- Start
        
        if(!hasStagTyre){
            
            newStagTyreData.forEach(function(item){
                if(item.Size_Name__c == ''|| item.Size_Name__c == null ||
                   item.Brand_Name__c == ''|| item.Brand_Name__c == null ||
                   item.Pattern_Name__c == ''|| item.Pattern_Name__c == null ||
                   item.Country_Name__c == ''|| item.Country_Name__c == null ||
                   item.Tyre_Serial_No__c == ''|| item.Tyre_Serial_No__c == null
                  ){
                    hasStagTyre = true;
                    helper.showErrorToast({
                        "title": "Required: New Tyre Details",
                        "type": "error",
                        "message": "Tyre Size, Brand, Pattern, Country of Origin, Tyre Serial Number Fields are required"
                    });
                    return false;
                }
                
            });
            
            var uniqueStagArray = [];
            newStagTyreData.forEach(function(item){ 
                
                var ckey  =  item.Size_Name__c+'#'+item.Tyre_Serial_No__c;
                
                if(uniqueStagArray.indexOf(ckey) > -1) {
                    
                    hasStagTyre = true;
                    helper.showErrorToast({
                        "title": "Error:New Tyre Collection",
                        "type": "error",
                        "message": "Tyre Serial Number should be unique for every record"
                    });
                    return false;
                }else{
                    uniqueStagArray.push(ckey);
                }
                
            });
        }
        
        
        //New Tyre Validation process -- End
        
        if(!hasErrorNewTyre || !hasStagTyre){
            
            let newTyreCollFinal = [];
            let newStagTyreFinal = [];
            let nullArray = [];
            
            data.forEach(function(item){//to remove null record that intitated in doinit
                
                if(item.ETT_Tyre_Size_Master__c){
                    newTyreCollFinal.push(item);
                }
            });
            newStagTyreData.forEach(function(item){
                if(item.Size_Name__c){
                    newStagTyreFinal.push(item);
                }
                
            });
            
            //console.log(newTyreColl);
            //console.log(newStagTyre)
           
            var action = component.get('c.insertNewStagNewTyreInven');
            component.set("v.showSpinner",true);
            action.setParams({
                newTyreInvent : newTyreCollFinal,
                stagTyre:newStagTyreFinal,
                updateStagTyre:nullArray,
                updateTyreInventory:nullArray,
                recordId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    component.set("v.showSpinner",false);
                    let data = response.getReturnValue();
                    helper.showErrorToast({
                        "title": "success",
                        "type": "success",
                        "message":"Your request has been submitted successfully."
                    });
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        component.set("v.showSpinner",false);
                        if (errors[0] && errors[0].message) {
                          
                            console.log("Error message: " + errors[0].message);
                            helper.showErrorToast({
                                "title": "Error:In backend",
                                "type": "error",
                                "message": errors[0].message
                            });
                        }
                    } else {
                        component.set("v.showSpinner",false);
                        console.log("Unknown error");
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action);
            
        }
        
    },
    upserthandler : function(component, event, helper){
        debugger;
        let data = component.get("v.lstTyreInventory");
        let newStagTyreData = component.get("v.stgNewCollTyreInfo");
        let toggleSwitch = component.get("v.showToggleCheckCmp");
        
        let hasErrorNewTyre = false;
        let hasStagTyre = false;
        
        
        if(data && toggleSwitch){
            
            data.forEach(function(item){
                
                if(item.ETT_Tyre_Size_Master__c == '' && item.ETT_Brand__c == '' && item.ETT_Country__c==''){
                    hasErrorNewTyre = true;
                }
                
            });
            
        }
        if(newStagTyreData && toggleSwitch){
            newStagTyreData.forEach(function(item){
                
                if(item.Size_Name__c == null && item.Brand_Name__c==null && item.Country_Name__c==null){
                    hasStagTyre = true;
                    
                }
            });
            
        }
        
        if(hasStagTyre && hasErrorNewTyre){
            
            helper.showErrorToast({
                "title": "Required",
                "type": "error",
                "message": "Tyre or New Tyres are required to proceed"
            });
            return false;
            
        }
        
        if(!hasErrorNewTyre && toggleSwitch){
            data.forEach(function(item){
                
                if(item.ETT_Tyre_Size_Master__c == '' || item.ETT_Tyre_Size_Master__c == null ||
                   item.ETT_Brand__c == '' || item.ETT_Brand__c == null ||
                   item.ETT_Pattern__c == '' || item.ETT_Pattern__c == null ||
                   item.ETT_Country__c == '' || item.ETT_Country__c == null ||
                   item.Serial_Number__c == '' || item.Serial_Number__c == null
                  ){
                    
                    hasErrorNewTyre = true;
                    helper.showErrorToast({
                        "title": "Required",
                        "type": "error",
                        "message": "Tyre Size, Brand, Pattern, Country of Origin, Tyre Serial Number Fields are required"
                    });
                    return false;
                    
                }
            });
            //Check Duplicate data
            var uniqueArray = [];
            data.forEach(function(item){ 
                
                var combin  =  item.ETT_Brand__c+'#'+item.Serial_Number__c;
                
                if(uniqueArray.indexOf(combin) > -1) {
                    
                    hasErrorNewTyre = true;
                    helper.showErrorToast({
                        "title": "Error: Tyre Collection",
                        "type": "error",
                        "message": "Tyre Serial Number should be unique for every record"
                    });
                    return false;
                }else{
                    uniqueArray.push(combin);
                }
                
            });
        }
        
        //New Tyre Validation process -- Start
        
        if(!hasStagTyre && toggleSwitch){
            
            newStagTyreData.forEach(function(item){
                if(item.Size_Name__c == ''|| item.Size_Name__c == null ||
                   item.Brand_Name__c == ''|| item.Brand_Name__c == null ||
                   item.Pattern_Name__c == ''|| item.Pattern_Name__c == null ||
                   item.Country_Name__c == ''|| item.Country_Name__c == null ||
                   item.Tyre_Serial_No__c == ''|| item.Tyre_Serial_No__c == null
                  ){
                    hasStagTyre = true;
                    helper.showErrorToast({
                        "title": "Required: New Tyre Details",
                        "type": "error",
                        "message": "Tyre Size, Brand, Pattern, Country of Origin, Tyre Serial Number Fields are required"
                    });
                    return false;
                }
                
            });
            
            var uniqueStagArray = [];
            newStagTyreData.forEach(function(item){ 
                
                var ckey  =  item.Size_Name__c+'#'+item.Tyre_Serial_No__c;
                
                if(uniqueStagArray.indexOf(ckey) > -1) {
                    
                    hasStagTyre = true;
                    helper.showErrorToast({
                        "title": "Error:New Tyre Collection",
                        "type": "error",
                        "message": "Tyre Serial Number should be unique for every record"
                    });
                    return false;
                }else{
                    uniqueStagArray.push(ckey);
                }
                
            });
        }
        
        
        //New Tyre Validation process -- End
        
        if(!hasErrorNewTyre || !hasStagTyre){
            
            let updateStagTyre = component.get("v.stgCollTyreDetailsFrmServer");
            let updateTyreInventory = component.get("v.TyreInventoryFrmServer");
            
            
            let newTyreCollFinal = [];
            let newStagTyreFinal = [];
            
            
            data.forEach(function(item){//to remove null record that intitated in doinit
                
                if(item.ETT_Tyre_Size_Master__c){
                    newTyreCollFinal.push(item);
                }
            });
            newStagTyreData.forEach(function(item){
                if(item.Size_Name__c){
                    newStagTyreFinal.push(item);
                }
                
            });
            //console.log(newTyreCollFinal)
            //console.log(newStagTyreFinal)
            
            //console.log(newTyreColl);
            //console.log(newStagTyre)
            var action = component.get('c.insertNewStagNewTyreInven');
            component.set("v.showSpinner",true);
            action.setParams({
                newTyreInvent : newTyreCollFinal,
                stagTyre:newStagTyreFinal,
                updateStagTyre:updateStagTyre,
                updateTyreInventory:updateTyreInventory,
                recordId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    component.set("v.showSpinner",false);
                    let data = response.getReturnValue();
                    helper.showErrorToast({
                        "title": "success",
                        "type": "success",
                        "message":"Your request has been submitted successfully."
                    });
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            component.set("v.showSpinner",false);
                            console.log("Error message: " + errors[0].message);
                            helper.showErrorToast({
                                "title": "Error:In backend",
                                "type": "error",
                                "message": errors[0].message
                            });
                        }
                    } else {
                        component.set("v.showSpinner",false);
                        console.log("Unknown error");
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action);
            
        }
        
    },
    
    addNewRowsIntoTyreMaster : function(component, event, helper){
        
        var addRowInList = component.get("v.stgNewCollTyreInfo");
        var tyreInfo = new Object();
        tyreInfo.sobjectType = 'ETT_StagingNewTyreCollection__c';
        tyreInfo.Size_Name__c=null;
        tyreInfo.Brand_Name__c=null;
        tyreInfo.Pattern_Name__c=null;
        tyreInfo.Country_Name__c=null;
        tyreInfo.Job_Type__c='Retread';
        tyreInfo.Process_Type__c='Precure';
        tyreInfo.Collection_Card__c=component.get("v.recordId");
        addRowInList.push(tyreInfo);
        component.set("v.stgNewCollTyreInfo",addRowInList);
        
    },
    removeRowsIntoTyreMaster : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stgNewCollTyreInfo");
        
        AllRowsList.splice(whichOne, 1);
        component.set("v.stgNewCollTyreInfo", AllRowsList);
    },
    copyThisLineNewTyre : function(component, event, helper){
        
        var selectedSection = event.currentTarget;
        var index = selectedSection.dataset.index;
        var AllRowsList = component.get("v.stgNewCollTyreInfo");
        
        var tyre = new Object();
        tyre.sobjectType = 'ETT_StagingNewTyreCollection__c';
        tyre.Size_Name__c=AllRowsList[index].Size_Name__c;
        tyre.Brand_Name__c=AllRowsList[index].Brand_Name__c;
        tyre.Pattern_Name__c=AllRowsList[index].Pattern_Name__c;
        tyre.Country_Name__c=AllRowsList[index].Country_Name__c;
        tyre.Collection_Card__c=component.get("v.recordId");
        tyre.Process_Type__c = AllRowsList[index].Process_Type__c;
        tyre.Job_Type__c=AllRowsList[index].Job_Type__c;
        tyre.Tyre_Serial_No__c=AllRowsList[index].Tyre_Serial_No__c;
        AllRowsList.push(tyre);
        component.set("v.stgNewCollTyreInfo",AllRowsList); 
    },
    
    deleteRowFrmServer : function(component, event, helper){
        var selectedSection = event.currentTarget;
        var index = selectedSection.dataset.filename;
        
        var action = component.get('c.deleteRecord');
        
        action.setParams({
            recordId : index
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                helper.getTyreInventoryFrmServerHelper(component, event, helper);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);       
    },
    deleteNewTyreFrmServer : function(component, event, helper){
        var selectedSection = event.currentTarget;
        var index = selectedSection.dataset.filename;
        
        var action = component.get('c.deleteRecord');
        
        action.setParams({
            recordId : index
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                helper.getStagTyreFrmServerHelper(component, event, helper);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);       
    },
    
    selectChange : function(component, event, helper){
        
        var checkCmp = component.find("checkboxToggle").get("v.checked");
        component.set("v.showToggleCheckCmp",checkCmp);
    },
    ApproveProcess : function(component, event, helper){
        
        var action = component.get('c.approvalProcess');
        component.set("v.showSpinner",true);
        action.setParams({
            recordId : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
                component.set("v.showSpinner",false);
                
                helper.showErrorToast({
                    "title": "success",
                    "type": "success",
                    "message":"Your request has been submitted successfully."
                });
                
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        component.set("v.showSpinner",false);
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);       
        
    },
    ApproveTyreMaster : function(component, event, helper){
        
        var tyres = component.get('v.lstTyreMaster');
        var approvedTyres = [];
        
        tyres.forEach(function(item){
            if(item.ETT_Status__c){
                approvedTyres.push(item);
            }
        }); 
        
        if(approvedTyres.length >0){
            var action = component.get('c.updateTyreMasterDetails');
            
            action.setParams({
                tyreList : approvedTyres,
                recordId : component.get("v.recordId")
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                    helper.getTyreMasterDetailsHelper(component, event, helper);
                    helper.getPriceConfirmationDetailsHelper(component, event, helper);
                     $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            
                        }
                    } else {
                        console.log("Unknown error");
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action);
        }else{
            helper.showErrorToast({
                "title": "Error",
                "type": "Error",
                "message":"Please select Tyre Master"
            });
        }
        
        
    },
    ApproveFM_HOO : function(component, event, helper){
        
         var price = component.get('v.lstPriceConfir');
         let hasError = false;
         let data = component.get("v.CCRecord");
        
        price.forEach(function(item){
            
             if($A.util.isEmpty(item.ETT_Repair_Price__c) && $A.util.isEmpty(item.ETT_Selling_Price_P__c) && $A.util.isEmpty(item.ETT_Selling_Price_H__c) && $A.util.isEmpty(item.ETT_Retread_Price_P__c) && $A.util.isEmpty(item.ETT_Retread_Price_H__c) && data.RecordType.Name =='Tyre - Refurbishing Services'){ 
                hasError = true;
                helper.showErrorToast({
                    title: "Required:",
                    type: "error",
                    message: "Repair/Selling/Retread price is required."
                });
                return false;
            }else if(item.ETT_Purchase_Price__c == null || item.ETT_Purchase_Price__c == 0 && (data.RecordType.Name == 'Tyre Supplier') ){
                hasError = true;
                helper.showErrorToast({
                    "title": "Error",
                    "type": "Error",
                    "message":"Please Enter Purchase price"
                });
            }
            
            
        });
        
        if(!hasError){
            var action = component.get('c.updatePricingConfirmDetails');
             component.set("v.showSpinner",true);
            action.setParams({
                priceList : price,
                recordId : component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                     component.set("v.showSpinner",false);
                    let data = response.getReturnValue();
                    
                    helper.showErrorToast({
                        "title": "Success",
                        "type": "Success",
                        "message":"Your request has been submitted successfully"
                    });
                    
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                             component.set("v.showSpinner",false);
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
        
        
    },
      handleComponentEvent : function(component, event, helper){
        var name = event.getParam("name");
        var index = event.getParam("index");
        var dynamicId = event.getParam("dynamicId");
        var objectName = event.getParam("objectName");
        
        
        if (objectName == "ETT_Tyre_Size_Master__c") {
            
           
            component.set("v.TyreSizeName", name);
          
            
        } else if (objectName == "ETT_Brand_Master__c") {
            
           
            
            component.set("v.BrandName", name);
          
            
        } else if (objectName == "ETT_Pattern_Master__c") {
            
            
            component.set("v.PatternName", name);
          
            
        } else if (objectName == "ETT_Country_Master__c") {
            
          
            component.set("v.CountryName", name);
           
            
        }
    },
})