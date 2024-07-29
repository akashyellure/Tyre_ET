({
    purchasePrice : function(component, event, helper) {
        //console.log('called purchase price');
        var indexvar = event.getSource().get("v.name");
        //console.log('indexvar: '+indexvar);
        var stagingQuotationRequest = component.get("v.stagingQuotationRequest");
        //console.log(JSON.stringify(stagingQuotationRequest));
        
        if(stagingQuotationRequest[indexvar].PurchasePrice < 0){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message: "Please enter valid Purchase Price"
            });
            return false;  
        }
        
        if(stagingQuotationRequest[indexvar].PurchasePrice < stagingQuotationRequest[indexvar].minRange &&
           stagingQuotationRequest[indexvar].ETT_Reasons_For_Price_Reduction__c==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message: "Please select the Reason of Price Reduction"
            });
            return false;  
        }
        
    },
    doInit : function(component, event, helper) {
        
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
       // alert(userId)
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        var custLabelsRecp = $A.get("$Label.c.ETT_InspectionCriteria_Receptionist");
        if(custLabelsFM.includes(userId)){
            component.set('v.isUserFM',true);
        }
        
        if(custLabelsHOO.includes(userId)){
            component.set('v.isUserHOO',true);
        }
        if(custLabelsRecp.includes(userId)){
            component.set('v.isUserRecp',true);
        }
        
        helper.fetchPickListVal(component, 'ETT_Approve_Stage__c', 'approvalStageMap');        
        helper.fetchPickListVal(component, 'ETT_Tyre_Life__c', 'tyreLifeMap');        
        helper.fetchPickListVal(component, 'ETT_Tyre_Condition__c', 'tyreConditionMap'); 
        helper.fetchPickListVal(component, 'ETT_Reasons_For_Price_Reduction__c', 'reasonForPriceReductionMap');         
        helper.getSubmittedRecords(component, event, helper);

		var lstTyreMasterDetails = component.get("v.lstTyreMasterDetails");        
        lstTyreMasterDetails.push({'sobjectType':'ETT_Tyre_Master__c'});
        component.set("v.lstTyreMasterDetails",lstTyreMasterDetails);
        var action = component.get("c.getTyreMasterDetails");
        
        action.setParams({"recId" : component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state: '+state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.lstTyreMasterDetails",response.getReturnValue());
                
                var result = response.getReturnValue();
                for(var key in result){
                    if(result[key]['RecordType']['Name']=='Draft'){
                        component.set("v.isDraft",true);
                    }
                }
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (state === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        
        $A.enqueueAction(action);
        
    }, 
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    onClick : function(component, event, helper) {
        
    },
    handleSectionToggle : function(component, event, helper) {
        
    },
    handleCompanyOnChange : function(component, event, helper) {
    },
    handleServicePrices : function(component, event, helper) {
        
        var lstStgQuotation = component.get("v.stagingQuotationRequest");
        var indexvar = event.getSource().get("v.name");
        var tyreLife = lstStgQuotation[indexvar].ETT_Tyre_Life__c;
        var tyreCondition = lstStgQuotation[indexvar].ETT_Tyre_Condition__c;
        
        console.log(JSON.stringify(lstStgQuotation[indexvar]));
        
        if(tyreLife!=null && tyreCondition!=null){
            
            if(tyreLife.includes("New") && tyreCondition.includes("Hot")){
                component.set("v.isNewHot",true);
            }else{
                component.set("v.isNewHot",false);
            }
            
            if(tyreLife.includes("New") && tyreCondition.includes("Procure")){
                component.set("v.isNewProcure",true);
            }else{
                component.set("v.isNewProcure",false);
            }
            
            if(tyreLife.includes("Retread") && tyreCondition.includes("Hot")){
                component.set("v.isRetreadHot",true);
            }else{
                component.set("v.isRetreadHot",false);
            }
            
            if(tyreLife.includes("Retread") && tyreCondition.includes("Procure")){
                component.set("v.isRetreadProcure",true);
            }else{
                component.set("v.isRetreadProcure",false);
            }
            
            if(tyreLife.includes("Repair")){
                component.set("v.isRepair",true);
            }else{
                component.set("v.isRepair",false);            
            }
        }else{
            console.log('Pls select options first');
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message: "Please select values from Tyre Life && Tyre Condition"
            });
            return false;    
        }

        
    },
    handleComponentEvent : function(component, event, helper) {
        
    },
    onCheck : function(component, event, helper) {

        var checkCmp = component.find("autoConvertLead").get("v.value");
        component.set("v.autoConvertLead",checkCmp); 
        console.log(checkCmp);
        
    },
    submit : function(component, event, helper) {
        debugger;
        var LeadRecord = component.get("v.LeadRecord");
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        var leadObj = new Object();
        leadObj.Id = LeadRecord.Id;
        leadObj.ETT_isSupplierConvert__c = component.get("v.autoConvertLead");
        leadObj.RecordTypeId = LeadRecord.RecordTypeId;
        component.set("v.leadObj",leadObj);
        
        var lstStagingQuotationRequest = component.get("v.stagingQuotationRequest");
        var addRowInList = [];
        
        console.log(JSON.stringify(lstStagingQuotationRequest));
        //return false;
        if (lstStagingQuotationRequest != null && lstStagingQuotationRequest.length > 0) {
            for (var i = 0; i < lstStagingQuotationRequest.length; i++) {
                
                var stgQuotationObj = new Object();
                stgQuotationObj.Id = lstStagingQuotationRequest[i].stgQuotId;

                if(LeadRecord.RecordType.Name == 'Tyre - Cash Supplier' ||
                  LeadRecord.RecordType.Name == 'Tyre - Credit/B2B Supplier' ||
                  LeadRecord.RecordType.Name == 'Tyre Cash Individual' ||
                  LeadRecord.RecordType.Name == 'Tyre - Refurbishing Services'){
                    
                    if(lstStagingQuotationRequest[i].approvalStage == 'Rejected' || lstStagingQuotationRequest[i].approvalStage == 'Resubmit' ){
                       
                        if(custLabelsFM.includes(userId) && lstStagingQuotationRequest[i].approvalStage == 'Rejected' && (!('fmComment' in lstStagingQuotationRequest[i]) || lstStagingQuotationRequest[i].fmComment=='')){                            
                            helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message: "Please mention rejection comment"
                            });
                            return false;
                        }else{
                            stgQuotationObj.ETT_FM_Rejection_Comment__c = lstStagingQuotationRequest[i].fmComment;
                            leadObj.ETT_FM_Rejection_Comments__c = lstStagingQuotationRequest[i].fmComment;
                        }
                        
                        if(custLabelsHOO.includes(userId) && lstStagingQuotationRequest[i].approvalStage == 'Rejected' && (!('hooComment' in lstStagingQuotationRequest[i]) || lstStagingQuotationRequest[i].hooComment=='')){
                            helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message: "Please mention rejection comment"
                            });
                            return false;
                        }else{
                            stgQuotationObj.ETT_HOO_Rejection_Comment__c = lstStagingQuotationRequest[i].hooComment;
                            leadObj.ETT_HOO_Rejection_Comments__c = lstStagingQuotationRequest[i].hooComment;
                        }
                         
                        if(lstStagingQuotationRequest[i].approvalStage == 'Resubmit' && (!('leadResubmitReason' in lstStagingQuotationRequest[i]) || lstStagingQuotationRequest[i].leadResubmitReason == '')){
                            helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message: "Please mention resubmission reason"
                            });
                            return false;
                        }else{
                            stgQuotationObj.ETT_Resubmission_Reason__c = lstStagingQuotationRequest[i].leadResubmitReason;
                        }
                    
                    }else if(lstStagingQuotationRequest[i].approvalStage != 'Rejected' && lstStagingQuotationRequest[i].approvalStage  != 'Resubmit' ){
                        
                        if(lstStagingQuotationRequest[i].PurchasePrice == '' || lstStagingQuotationRequest[i].PurchasePrice == 0){
                            helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message: "Please enter purchase price"
                            });
                            return false;    
                        } 
                        if(isNaN(lstStagingQuotationRequest[i].PurchasePrice) || lstStagingQuotationRequest[i].PurchasePrice < 0){
                            helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message: "Please enter valid purchase price"
                            });
                            return false;    
                        }
                        if(lstStagingQuotationRequest[i].PurchasePrice < lstStagingQuotationRequest[i].minRange && lstStagingQuotationRequest[i].ETT_Reasons_For_Price_Reduction__c==''){
                            helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message: "Please select the Reasons For Price Reduction"
                            });
                            return false;  
                        } else{
                            stgQuotationObj.ETT_Reasons_For_Price_Reduction__c   = lstStagingQuotationRequest[i].ETT_Reasons_For_Price_Reduction__c;
                        }
                        
                    }
                    
                }
                
                stgQuotationObj.ETT_Approve_Stage__c = lstStagingQuotationRequest[i].approvalStage;
                stgQuotationObj.ETT_IS_Approved__c = lstStagingQuotationRequest[i].isApproved;
                stgQuotationObj.ETT_Rejection_Comments__c = lstStagingQuotationRequest[i].fmComment;
                stgQuotationObj.ETT_Purchase_Price__c = lstStagingQuotationRequest[i].PurchasePrice;
                
                //stgQuotationObj.ETT_Min_Range__c = lstStagingQuotationRequest[i].ETT_Min_Range__c;
                //stgQuotationObj.ETT_Max_Range__c = lstStagingQuotationRequest[i].ETT_Max_Range__c;
                addRowInList.push(stgQuotationObj);
                component.set("v.stgQuoteReq",addRowInList);
                
            }
            
        }
        
        var stgQuote = component.get("v.stgQuoteReq");
        
        var strLeadJson = JSON.stringify(leadObj);
        var stgQuotationJson = JSON.stringify(stgQuote);
        

        var action = component.get("c.updateStgQuotation");
        var mapNameForStagingObjects = {
            stgLeadJson: strLeadJson,
            stgQuoteJson: stgQuotationJson
        };
        if(mapNameForStagingObjects!=null && mapNameForStagingObjects!=undefined){
            action.setParams({
                mapofStageJsonList: mapNameForStagingObjects
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                console.log('state: '+state);
                
                if (state === "SUCCESS") {
                    console.log('response-> '+response.getReturnValue());
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        url: "/" + response.getReturnValue()
                    });
                    urlEvent.fire();
                    
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
            
        }
        $A.enqueueAction(action);
        
        
    },
    Approve : function(component, event, helper){
        
        var lstTyreMasterDetails = component.get("v.lstTyreMasterDetails");
        console.log(JSON.stringify(lstTyreMasterDetails));
        
        
        var action = component.get("c.approveTyreMasterDetails");
        
        var mapNameForStagingObjects = {
            stgTyreMasterJson: JSON.stringify(component.get("v.lstTyreMasterDetails"))
        };
        
        action.setParams({
            mapofStageJsonList: mapNameForStagingObjects,
            leadId:component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log('state: '+state);
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.lstTyreMasterDetails",response.getReturnValue());
                
                var result = response.getReturnValue();
                for(var key in result){
                    if(result[key]['RecordType']['Name']=='Draft'){
                        component.set("v.isDraft",true);
                    }
                }
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + component.get("v.recordId")
                });
                urlEvent.fire();

                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (state === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        
        $A.enqueueAction(action);
        
        
    }
})