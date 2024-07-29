({
    doInit : function(component, event, helper) {
        
        helper.getStagQuotationRequests(component, event, helper);
        helper.getUserDetailHelper(component, event, helper);
        helper.getTyreMasterHelper(component, event, helper);
        helper.fetchPickListVal(component, 'Approver_Status__c', 'approvalStageMap'); 
        helper.fetchPickListVal(component, 'ETT_Reasons_For_Price_Reduction__c', 'reasonForPriceReductionMap');         
    },
    handleSubmit :  function(component, event, helper) {
        
        let stgQuot  = component.get("v.stgQuoteReq");
        let tempData  = component.get("v.tempData");
        let hasError = false;
        let priceChangeData = [];
           
        if(stgQuot[0].Opportunity__r.RecordType.Name=='Tyre Refurbishing Services'){
            stgQuot.forEach(function(item,index){
              
                if((item.ETT_Repair_Price__c && item.ETT_Repair_Price__c != tempData[index].ETT_Repair_Price__c)||(item.Selling_Procure_Price__c && item.Selling_Procure_Price__c != tempData[index].Selling_Procure_Price__c)||(item.Selling_Hot_Price__c && item.Selling_Hot_Price__c != tempData[index].Selling_Hot_Price__c)||(item.ETT_Retread_Procure_Price__c && item.ETT_Retread_Procure_Price__c != tempData[index].ETT_Retread_Procure_Price__c)||(item.ETT_Retread_Hot_Price__c && item.ETT_Retread_Hot_Price__c != tempData[index].ETT_Retread_Hot_Price__c)){
                    
                    let newData = new Object();
                    newData.tyreSize = item.ETT_Tyre_Size_Master__r.Name;
                    newData.NewRepairPrice = item.ETT_Repair_Price__c?item.ETT_Repair_Price__c:0;
                    newData.OldRepairPrice = tempData[index].ETT_Repair_Price__c?tempData[index].ETT_Repair_Price__c:0;
                    newData.NewSelProPrice = item.Selling_Procure_Price__c?item.Selling_Procure_Price__c:0;
                    newData.OldSelProPrice = tempData[index].Selling_Procure_Price__c?tempData[index].Selling_Procure_Price__c:0;
                    newData.NewSelHotPrice = item.Selling_Hot_Price__c?item.Selling_Hot_Price__c:0;
                    newData.OldSelHotPrice = tempData[index].Selling_Hot_Price__c?tempData[index].Selling_Hot_Price__c:0;
                    newData.NewRetProPrice = item.ETT_Retread_Procure_Price__c?item.ETT_Retread_Procure_Price__c:0;
                    newData.OldRetProPrice = tempData[index].ETT_Retread_Procure_Price__c?tempData[index].ETT_Retread_Procure_Price__c:0;
                    newData.NewRetHotPrice = item.ETT_Retread_Hot_Price__c?item.ETT_Retread_Hot_Price__c:0;
                    newData.OldRetHotPrice = tempData[index].ETT_Retread_Hot_Price__c?tempData[index].ETT_Retread_Hot_Price__c:0;
                    newData.reason= item.Price_Change_Reason__c?item.Price_Change_Reason__c:'';
                    priceChangeData.push(newData);
                    
                    if(!item.Price_Change_Reason__c && !component.get("v.isUserSales")) {
                        hasError = true;
                        helper.showErrorToast({
                            title: "Required:",
                            type: "error",
                            message: "Price change reason is required."
                        });
                        return false;
                    }
                }
                
            });
        }
      
        stgQuot.forEach(function(item){
           
            if($A.util.isEmpty(item.ETT_Repair_Price__c) && $A.util.isEmpty(item.Selling_Procure_Price__c) && $A.util.isEmpty(item.Selling_Hot_Price__c) && $A.util.isEmpty(item.ETT_Retread_Procure_Price__c) && $A.util.isEmpty(item.ETT_Retread_Hot_Price__c) && item.Opportunity__r.RecordType.Name=='Tyre Refurbishing Services'){ 
                hasError = true;
                helper.showErrorToast({
                    title: "Required:",
                    type: "error",
                    message: "Repair/Selling/Retread price is required."
                });
                return false;
            }else if((item.ETT_Purchase_Price__c == '' || item.ETT_Purchase_Price__c ==0)&& item.Opportunity__r.RecordType.Name=='Tyre Supplier'){
                hasError = true;
                helper.showErrorToast({
                    title: "Required:",
                    type: "error",
                    message: "Please enter valid purchase price"
                });
                return false;
            }else if(item.ETT_Purchase_Price__c < item.ETT_Min_Range__c && item.ETT_Reasons_For_Price_Reduction__c =='' && item.Opportunity__r.RecordType.Name=='Tyre Supplier'){
                hasError = true;
                helper.showErrorToast({
                    title: "Required:",
                    type: "error",
                    message: "Please select the Reasons For Price Reduction"
                });
                return false;  
                
            }else if(item.Approver_Status__c == 'Rejected' && (item.ETT_Rejection_Comments__c == null || item.ETT_Rejection_Comments__c=='')){
                hasError = true;
                helper.showErrorToast({
                    title: "Required:",
                    type: "error",
                    message: "Please enter rejection reasons"
                });
                return false;
            }            
            
        });  
        console.log(priceChangeData.toString())
        if(!hasError){
          var action = component.get('c.updateStgQuotCreatePriceMas');
            component.set("v.showSpinner",true);
            action.setParams({
                recordId : component.get("v.recordId"),
                stagQuotList:stgQuot,
                priceChangeData: JSON.stringify(priceChangeData) 
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    component.set("v.showSpinner",false);
                    let data = response.getReturnValue();
                    
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                    
                    helper.showErrorToast({
                        title: "Success:",
                        type: "Success",
                        message: "Request has been submitted successfully."
                    });
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            component.set("v.showSpinner",false);
                            console.log("Error message: " + errors[0].message);
                            helper.showErrorToast({
                                title: "Error:",
                                type: "error",
                                message: errors[0].message
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
    
    ApproveNewTyre : function(component, event, helper) {
        
        let tyreDetails = component.get("v.lstTyreMasterDetails");
        let count = 0;
        tyreDetails.forEach(function(item){
            
            if(item.ETT_Status__c)
                count =  count+1;
        });
        
        if(count > 0){
            var action = component.get('c.handleNewTyreDetails');
            
            action.setParams({
                recordId : component.get("v.recordId"),
                tyreMastInfo:tyreDetails
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                    let stgQuot  = component.get("v.stgQuoteReq");
                    helper.getTyreMasterHelper(component, event, helper);
                    
                    data.forEach(function(item){
                        stgQuot.push(item); 
                    });
                    component.set("v.stgQuoteReq",stgQuot);
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            helper.showErrorToast({
                                title: "Error:",
                                type: "error",
                                message: errors[0].message
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
                title: "Error:",
                type: "error",
                message: 'Select at least one tyre to Approve/Reject'
            });
            
        }
    },
    convertCase: function(component, event, helper){
        var val = event.getSource().get("v.value");
        if(val!=null)
        {
            val = val.toUpperCase();
            var selectCmp = event.getSource();
            selectCmp.set("v.value",val) ;  
        }
        
    },
})