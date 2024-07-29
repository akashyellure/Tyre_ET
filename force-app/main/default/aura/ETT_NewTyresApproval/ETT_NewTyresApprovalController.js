({
    doInit : function(component, event, helper) {
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        
        if(custLabelsFM.includes(userId)){
            component.set('v.isUserFM',true);
        }
        
        if(custLabelsHOO.includes(userId)){
            component.set('v.isUserHOO',true);
        }
        
        var action = component.get('c.getNewTyreDetails'); 
        action.setParams({
            "recordId":component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                console.log('Res: '+result);
                console.log(JSON.stringify(result));
                
                var arrayMapKeys = [];
                for(var key in result){
                    
                    console.log(key+' : '+result[key].length);
                    if(result[key].length>0){
                        component.set('v.isDataAvailable',true);
                    }else{
                        component.set('v.noPendingItemforApproval',true);
                    }
                    
                    if(key=='ETT_Tyre_Size_Master__c'){
                        component.set('v.lstTyreSize',result[key]);
                    }else if(key=='ETT_Country_Master__c'){
                        component.set('v.lstCountry',result[key]);
                        //  component.set('v.isDataAvailable',true);
                    }else if(key=='ETT_Pattern_Master__c'){
                        component.set('v.lstPattern',result[key]);
                        //   component.set('v.isDataAvailable',true);
                    }else if(key=='ETT_Brand_Master__c'){
                        component.set('v.lstBrand',result[key]);
                        //   component.set('v.isDataAvailable',true);
                    }else if(key=='ETT_Tyre_Master__c'){
                        component.set('v.lstTyreMaster',result[key]);
                        //   component.set('v.isDataAvailable',true);
                    }
                }
                console.log('isDataAvailable: '+component.get('v.isDataAvailable'));
                component.set('v.recordsForApproval',arrayMapKeys);
            }
            
        });
        $A.enqueueAction(action);
        
        var actionWOLI = component.get('c.getMissingPurchaseInformationWOLI'); 
        actionWOLI.setParams({
            "recordId":component.get("v.recordId")
        });
        actionWOLI.setCallback(this, function(a){
            
            var state = a.getState(); 
            console.log(state);
            
            if(state == 'SUCCESS') {
                
                var result = a.getReturnValue();
                console.log('res:'+result);
                component.set('v.lstStgQuotations',result);

                if(result==null){
                    component.set("v.isEmpty",true);
                }
                /*var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
                */
            }else{
                console.log('error');
            }
            
        });
        $A.enqueueAction(actionWOLI);
        
        
    },
    
    Approve : function(component, event, helper) {
        
        var lstTyreMaster = component.get('v.lstTyreMaster');
        var newTyreMasterArr = [];
        if(lstTyreMaster!=null && lstTyreMaster.length>0){
            for(var i=0;i<lstTyreMaster.length;i++){
                
                if('ETT_Status__c' in lstTyreMaster[i]){
                    
                    /*console.log(JSON.stringify(lstTyreMaster[i]));
                    console.log(lstTyreMaster[i].ETT_Status__c);
                    console.log(lstTyreMaster[i].ETT_Price__c);
                    if('ETT_Price__c' in lstTyreMaster[i]){
                        
                    }else{
                        helper.showErrorToast({
                            "title": "Required",
                            "type": "error",
                            "message": "Please enter price"
                        });
                        return false;
                    }*/

                    newTyreMasterArr.push(lstTyreMaster[i]);
                }
            }
        }

        console.log(JSON.stringify(newTyreMasterArr));
        
        var action = component.get('c.approveNewTyres'); 
        var mapNameForStagingObjects = {
            "lstTyreMasterJson":JSON.stringify(newTyreMasterArr)
        };
        action.setParams({
            "mapofStageJsonList":mapNameForStagingObjects
        });
        action.setCallback(this, function(a){
            
            var state = a.getState(); 
            console.log(state);
            
            if(state == 'SUCCESS') {
                
                var result = a.getReturnValue();
                component.set('v.noPendingItemforApproval',true);
                /*var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();*/
                
            }else{
                console.log('error');
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    handleSectionToggle : function(component, event, helper){
        
    },
    
    priceApproval : function(component, event, helper){
        
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        
        
        var lstStgQuotations = component.get("v.lstStgQuotations");
        console.log(JSON.stringify(lstStgQuotations));
    
        if(lstStgQuotations!=null && lstStgQuotations.length>0){
            for(var i=0;i<lstStgQuotations.length;i++){
                
                console.log(lstStgQuotations[i].ETT_Approve_Stage__c);
                
                if(custLabelsFM.includes(userId)){
                    if(lstStgQuotations[i].ETT_Approve_Stage__c!='Qualified'){
                        helper.showErrorToast({
                            "title": "Required",
                            "type": "error",
                            "message": "Please select an action"
                        });
                        return false;
                    }
                }
                if(!('ETT_Purchase_Price__c' in lstStgQuotations[i])){
                    helper.showErrorToast({
                        "title": "Required",
                        "type": "error",
                        "message": "Please enter purchase price"
                    });
                    return false;
                }
                
                if(isNaN(lstStgQuotations[i].ETT_Purchase_Price__c)){
                    helper.showErrorToast({
                        "title": "Required",
                        "type": "error",
                        "message": "Please enter valid purchase price"
                    });
                    return false;
                }
            }
        }
        
        
      var action = component.get('c.createStagingQuotation'); 
        action.setParams({
            "recordId":component.get("v.recordId"),
            "lstStgQuotations":lstStgQuotations
        });
        action.setCallback(this, function(a){
            
            var state = a.getState(); 
            console.log(state);
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                console.log(JSON.stringify(result));
                
                var result = a.getReturnValue();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
                
            }else{
                console.log('error');
            }
            
        });
        $A.enqueueAction(action);
        
    
    },
    
    
})