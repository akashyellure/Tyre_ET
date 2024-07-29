({
    showErrorToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    fetchPickListVal: function(component, fieldName, elementId) {
        
        var action = component.get("c.getselectOptions");
        
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log(result);
                var opts = [];
                if(fieldName=='ETT_Tyre_Life__c'){
                    for(var key in result){
                        opts.push({label: key, value: result[key]});
                    }
                }else{
                    for(var key in result){
                        opts.push({key: key, value: result[key]});
                    }
                }
                var el = 'v.'+elementId;
                component.set(el, opts);
                //alert(el)
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    getSubmittedRecords: function(component, fieldName, elementId) {
        
        var action = component.get("c.getSubmittedRecords");
        
        action.setParams({
            "strLeadId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log('state: '+state);
            
            
            if (response.getState() == "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log(result);
                
                var addRowInList = component.get("v.stagingQuotationRequest");
                
                console.log('****'+JSON.stringify(result['lstStagingQuotations']));
                
                var opts = [];
                for(var key in result['lstStagingQuotations']){
                    
                    var quotationObj = new Object();
                    
                    quotationObj.stgQuotId = result['lstStagingQuotations'][key]['Id'];                    
                    quotationObj.LeadName = result['lstStagingQuotations'][key]['ETT_Lead__r']['LastName'];
                    quotationObj.isApproved = result['lstStagingQuotations'][key]['ETT_IS_Approved__c'];
                    quotationObj.TyreSize = result['lstStagingQuotations'][key]['ETT_Tyre_Size_Master__r']['Name'];
                    quotationObj.PurchasePrice = result['lstStagingQuotations'][key]['ETT_Purchase_Price__c'];
                    quotationObj.ETT_Reasons_For_Price_Reduction__c = result['lstStagingQuotations'][key]['ETT_Reasons_For_Price_Reduction__c'];
                    quotationObj.approvalStage = result['lstStagingQuotations'][key]['ETT_Approve_Stage__c'];
                    quotationObj.minRange = result['lstStagingQuotations'][key]['ETT_Min_Range__c'];
                    quotationObj.maxRange =  result['lstStagingQuotations'][key]['ETT_Max_Range__c'];  
                    quotationObj.ETT_Tyre_Process__c =  result['lstStagingQuotations'][key]['ETT_Tyre_Process__c'];  
                    quotationObj.ETT_Tyre_Life__c =  result['lstStagingQuotations'][key]['ETT_Tyre_Life__c'];  
                    quotationObj.ETT_Tyre_Condition__c =  result['lstStagingQuotations'][key]['ETT_Tyre_Condition__c'];  
                    quotationObj.leadResubmitReason =  result['lstStagingQuotations'][key]['ETT_Resubmission_Reason__c'];  
                    quotationObj.fmComment = '';
                    
                    addRowInList.push(quotationObj);
                    //alert(JSON.stringify(addRowInList));
                    
                }
                console.log('addRowInList: '+JSON.stringify(addRowInList));
                component.set("v.stagingQuotationRequest", addRowInList);
                
                //alert(JSON.stringify(component.get("v.stagingQuotationRequest")));                  
                
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        
        $A.enqueueAction(action);
    }
    
})