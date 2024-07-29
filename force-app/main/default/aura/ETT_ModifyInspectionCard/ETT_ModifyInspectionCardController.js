({
    doInit : function(component, event, helper) {
        
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        var custLabelsReceptionist = $A.get("$Label.c.ETT_InspectionCriteria_Receptionist");
        var custLabelsSales = $A.get("$Label.c.ETT_InspectionCriteria_Sales");
        
        if(custLabelsHOO.includes(userId)){
            component.set('v.isUserHOO',true);
        }    
          
        
        if(custLabelsFM.includes(userId)){
            component.set('v.isUserFM',true);
            
            console.log('FM');
            var action = component.get('c.getStagingQuotation'); 
            action.setParams({
                "recordId":component.get("v.recordId")
            });
            action.setCallback(this, function(a){
                var state = a.getState(); 
                console.log(state);
                
                if(state == 'SUCCESS') {
                    var result = a.getReturnValue();
                    console.log(JSON.stringify(result));
                    if(result!=null){
                        component.set("v.lstStgQuotation",result);
                    }else{
                        console.log('Null');
                    }
                    console.log(JSON.stringify(result));
                }else if (state === "INCOMPLETE") {
                    // do something
                }else if (state === "ERROR") {
                    var error = a.getError();
                    if(error){
                        console.log("Errors"+error);
                        if(error[0] && error[0].message){
                            throw new Error("Error"+ error[0].message);
                        }
                    }else{
                        throw new Error("Unknown Error");
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            var action = component.get('c.getRelatedWOLI'); 
            action.setParams({
                "recordId":component.get("v.recordId")
            });
            action.setCallback(this, function(a){
                var state = a.getState(); 
                console.log(state);
                
                if(state == 'SUCCESS') {
                    var result = a.getReturnValue();
                    if(result!=null){
                        component.set("v.lstTyreInventory",result);
                    }else{
                        console.log('Null');
                    }
                    console.log(JSON.stringify(result));
                }else if (state === "INCOMPLETE") {
                    // do something
                }else if (state === "ERROR") {}
            });
            $A.enqueueAction(action); 
        }

    },
    
     handleComponentEvent: function(component, event, helper) {
        
        console.log('********');
        var name = event.getParam("name");
        var index = event.getParam("index");
        var dynamicId = event.getParam("dynamicId");
        var objectName = event.getParam("objectName");
        
        console.log('name: '+name);
        console.log('index: '+index);
        console.log('dynamicId: '+dynamicId);
        console.log('objectName: '+objectName);
        
        if (objectName == "ETT_Tyre_Size_Master__c") {
            
            component.set("v.TyreSizeName", name);
            component.set("v.TyreSizeId", dynamicId);
            
        } else if (objectName == "ETT_Brand_Master__c") {
            
            component.set("v.BrandName", name);
            component.set("v.BrandId", dynamicId);
            
        } else if (objectName == "ETT_Pattern_Master__c") {
            
            component.set("v.PatternName", name);
            component.set("v.PatternId", dynamicId);
            
        } else if (objectName == "ETT_Country_Master__c") {
            
            component.set("v.CountryName", name);
            component.set("v.CountryId", dynamicId);
            
        }
        
        console.log(component.get("v.CountryName"));
        console.log(component.get("v.PatternName"));
        console.log(component.get("v.BrandName"));
        console.log(component.get("v.TyreSizeName"));
    },
    //IC Team
    Update : function(component, event, helper){
        debugger;
        var lstTyreInventory = component.get("v.lstTyreInventory");
        console.log(JSON.stringify(lstTyreInventory));
        var rid = component.get("v.recordId");
        // alert(rid);	
         // alert('calling checkDuplicateInspection');
      var action1 = component.get('c.checkDuplicateInspection');
        action1.setParams({
            "lstTyreInventory":lstTyreInventory,
            TyreInspectionCardId:rid
        });
        
        action1.setCallback(this, function(resp){
            var state = resp.getState(); 
            console.log(state);
            if(state == 'SUCCESS') {
              //  alert('response '+ resp.getReturnValue());
                var duplicateCheck = resp.getReturnValue();
                if(duplicateCheck==false){
                     alert('calling updateRelatedWOLI');
                    var action = component.get('c.updateRelatedWOLI'); 
                    action.setParams({
                        "lstTyreInventory":lstTyreInventory,
                        TyreInspectionCardId:rid
                    });
                    action.setCallback(this, function(a){
                        var state = a.getState(); 
                        console.log(state);
                        
                        if(state == 'SUCCESS') {
                            var result = a.getReturnValue();
                            console.log(JSON.stringify(result));
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                "url": '/' + component.get("v.recordId")
                            });
                            urlEvent.fire();
                        }else if (state === "INCOMPLETE") {
                            // do something
                        }else if (state === "ERROR") {}
                    });
                    $A.enqueueAction(action);
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": "Duplicate Serial Number and Brand is present for another Inspection Card "
                    });
                    toastEvent.fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    return;
                }
                
            }
            else if (state === "INCOMPLETE") {}
                else if (state === "ERROR") {}
        });
        $A.enqueueAction(action1);
        
        
    },
    
    //HOO
    requestForApproval : function(component, event, helper){
        var action = component.get('c.createStagingQuotation'); 
        action.setParams({
            "recordId":component.get("v.recordId"),
            "Price":component.get("v.Price")
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                console.log(JSON.stringify(result));
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {}
        });
        $A.enqueueAction(action);
    },  
 	
    //FM
    priceApproval : function(component, event, helper){
        var action = component.get('c.FMPriceApproval'); 
        action.setParams({
            "recordId":component.get("v.recordId"),
            "lstStgQuotation":component.get("v.lstStgQuotation")
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                console.log(JSON.stringify(result));
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {}
        });
        $A.enqueueAction(action); 
    }
    
})