({ 
    getBaseData: function(component, event, helper) {
        var skillSetGroup = [];
        var reqSkillSets=component.get("v.skillSets");
        if(!$A.util.isUndefinedOrNull(reqSkillSets)){
            for(var i in reqSkillSets){
                var skillDet={};
                skillDet.label=reqSkillSets[i].Name;
                skillDet.value=reqSkillSets[i].Name;
                skillSetGroup.push(skillDet);
                /*if($A.util.isUndefinedOrNull(reqSkillSets[i].Skilled_Workers__r)){
                    component.set("v.skillsNotMatched",true);
                }*/
            }
        }
        var mainGroup = [
            {
            'label' : 'Skill Sets Required',
            'value': '',
            'subitem': skillSetGroup
        	}
        ];       
        component.set('v.options', mainGroup);        
        
        var toolsSetGroup = [];
        var reqtoolSets=component.get("v.stationTools");
        var bladeTools=[];
        var sideBufferTools=[];
        var suctionPipelineTools=[];
        var suctionFilterTools=[];
        
        if(!$A.util.isUndefinedOrNull(reqtoolSets)){
            for(var i in reqtoolSets){
                var toolDet={};
                toolDet.label=reqtoolSets[i].ETT_Tools_Master__r.Name+' (Item Code: '+reqtoolSets[i].ETT_Tools_Master__r.ETT_Unique_Code__c+', No:'+reqtoolSets[i].ETT_Tools_Master__r.ETT_Serial_No__c+', '+reqtoolSets[i].ETT_Tools_Master__r.ETT_Status__c+')';
                toolDet.value=reqtoolSets[i].Id;
                toolDet.isSelected=false;
                toolDet.remarks='';//used to capture comments from user to create new request.
                toolsSetGroup.push(toolDet);
                if(reqtoolSets[i].ETT_Tools_Master__r.ETT_Tool_type__c=='Blade'){
                    bladeTools.push(toolDet);
                }
                if(reqtoolSets[i].ETT_Tools_Master__r.ETT_Tool_type__c=='Side Buffer'){
                    sideBufferTools.push(toolDet);
                }
                if(reqtoolSets[i].ETT_Tools_Master__r.ETT_Tool_type__c=='Suction Pipeline'){
                    suctionPipelineTools.push(toolDet);
                } 
                if(reqtoolSets[i].ETT_Tools_Master__r.ETT_Tool_type__c=='Suction Filter'){
                    suctionFilterTools.push(toolDet);
                } 
                
                if(reqtoolSets[i].ETT_Tools_Master__r.ETT_Status__c!='Available'){
                    component.set("v.step_error","Some of the tools are not in available status to proceed further. Reach out to Supervisor for assistance.");
                }
            }
        }
        var toolmainGroup = [
            {
            'label' : 'Tools Required',
            'value': '',
            'subitem': toolsSetGroup
        	}
        ];       
        component.set('v.toolsListOptions', toolsSetGroup); //toolmainGroup
        component.set("v.bladeTools",bladeTools);
        component.set("v.sideBufferTools",sideBufferTools);
        component.set("v.suctionPipelineTools",suctionPipelineTools);
        component.set("v.suctionFilterTools",suctionFilterTools);
        
        var goodNotGoodValues = [];
        goodNotGoodValues.push({key: 'Good', value: 'Good'});
        goodNotGoodValues.push({key: 'Not Good', value: 'Not Good'});
        component.set("v.goodNotGoodValues",goodNotGoodValues);
        
        var NotGoodAndGoodValues = [];
        NotGoodAndGoodValues.push({key: 'Not Good', value: 'Not Good'});
        NotGoodAndGoodValues.push({key: 'Good', value: 'Good'});        
        component.set("v.NotGoodAndGoodValues",NotGoodAndGoodValues);
        
        var highLowValues = [];
        highLowValues.push({key: 'High', value: 'High'});
        highLowValues.push({key: 'Low', value: 'Low'});
        component.set("v.highLowValues",highLowValues);
        
        var lowHighValues = [];
        lowHighValues.push({key: 'Low', value: 'Low'});
        lowHighValues.push({key: 'High', value: 'High'});  
        component.set("v.lowHighValues",lowHighValues);        
        
        var yesNoValues = [];
        yesNoValues.push({key: 'Yes', value: 'Yes'});
        yesNoValues.push({key: 'No', value: 'No'});  
        component.set("v.yesNoValues",yesNoValues);
        
        var noYesValues = [];
        noYesValues.push({key: 'No', value: 'No'});  
        noYesValues.push({key: 'Yes', value: 'Yes'});        
        component.set("v.noYesValues",noYesValues);
        
        var matchedNotValues = [];
        matchedNotValues.push({key: 'Matched', value: 'Matched'});
        matchedNotValues.push({key: 'Not Matched', value: 'Not Matched'});  
        component.set("v.matchedNotValues",matchedNotValues);
        
        var notMatchedValues = [];
        notMatchedValues.push({key: 'Not Matched', value: 'Not Matched'});  
        notMatchedValues.push({key: 'Matched', value: 'Matched'});    
        component.set("v.notMatchedValues",notMatchedValues);
        
        var dustCollectorReasonValues = [];
        var dustCollectorReason = component.get("v.dustCollectorReasonValues");
        for(var key in dustCollectorReason){
            dustCollectorReasonValues.push({key: key, value: dustCollectorReason[key]});
        }
        component.set("v.dustCollectorReasonValues",dustCollectorReasonValues);
        
        var precuredTreadLineValues = [];
        var precuredTreadLine = component.get("v.precuredTreadLineValues");
        for(var key in precuredTreadLine){
            precuredTreadLineValues.push({key: key, value: precuredTreadLine[key]});
        }
        component.set("v.precuredTreadLineValues",precuredTreadLineValues);   
        
        var statusValues = [];
        statusValues.push({key: '', value: '---Select---'});
        statusValues.push({key: 'Accepted', value: 'Accepted'});
        statusValues.push({key: 'Initial Rejection', value: 'Initial Rejection'});
        component.set("v.statusValues",statusValues);
        
        var holdReasonValues = [];
        var holdReasons = component.get("v.holdReasonValues");
        holdReasonValues.push({key: '', value: '---Select---'});
        for(var key in holdReasons){
            holdReasonValues.push({key: key, value: holdReasons[key]});
        }
        component.set("v.holdReasonValues",holdReasonValues);
	},
    
    getJobDetails : function(component, event, helper) {
        var action = component.get("c.getValidJobCardLineDetail");
        action.setParams({
            'recordId': component.get("v.recordId"),
            'stageValue': 'Buffing',
            'current_sequence': component.get("v.current_sequence"),
            'readOnlyView': !component.get('v.allowDML')
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                var respWrapper = response.getReturnValue();
                component.set("v.current_sequence",respWrapper.jobLineItem.Sequence__c);
                component.set("v.current_line",respWrapper);
                
                component.set("v.lineItemForHold",respWrapper.holdLineItem);
                if(respWrapper.holdLineItem.jobLineItem.Id!=null){
                    component.set("v.isOnHold",true);
                }
                component.set("v.step_error","");
                component.set("v.tyreMaster",respWrapper.relatedJobWrapper.tyreMaster);
                component.set("v.treadMasterList",respWrapper.relatedJobWrapper.treadMasterList);
                component.set("v.tyreCrownInspection",respWrapper.relatedJobWrapper.tyreRejectionItemCrown);
                
                var treadMasterListValues=[];
                var treadList=respWrapper.relatedJobWrapper.treadMasterList;
                for(var i in treadList){
                	treadMasterListValues.push({key: treadList[i].Id, value: treadList[i].ETT_Tools_Master__r.ETT_Tread_Width__c});  
                }
                component.set("v.treadMasterListValues",treadMasterListValues);
                var tyreCuts=component.get("v.tyreCrownInspection");
                
                var CutsNTC = [];
                var SelectedCutsNTC = [];
                var SelectedCutsNTCList = [];                
                var cutData_1=
                            {
                                class: "optionClass",
                                label: "Cuts (0 to 10mm)",
                                value: "Cuts (0 to 10mm)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_0_10_mm__c>0){
                    cutData_1.selectedValue=tyreCuts.ETT_Number_of_cuts_0_10_mm__c;
                    SelectedCutsNTC.push('Cuts (0 to 10mm)');
                    SelectedCutsNTCList.push(cutData_1);
                }
                CutsNTC.push(cutData_1);
                
                var cutData_2=
                            {
                                class: "optionClass",
                                label: "Cuts (11 to 25mm)",
                                value: "Cuts (11 to 25mm)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_11_to_25_mm__c>0){
                    cutData_2.selectedValue=tyreCuts.ETT_Number_of_cuts_11_to_25_mm__c;
                    SelectedCutsNTC.push('Cuts (11 to 25mm)');
                    SelectedCutsNTCList.push(cutData_2);
                }
                CutsNTC.push(cutData_2);
                
                var cutData_3=
                            {
                                class: "optionClass",
                                label: "Cuts (26 to 38mm)",
                                value: "Cuts (26 to 38mm)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_26_to_38_mm__c>0){
                    cutData_3.selectedValue=tyreCuts.ETT_Number_of_cuts_26_to_38_mm__c;
                    SelectedCutsNTC.push('Cuts (26 to 38mm)');
                    SelectedCutsNTCList.push(cutData_3);
                }
                CutsNTC.push(cutData_3);
                
                var cutData_4=
                            {
                                class: "optionClass",
                                label: "Cuts (39 to 50mm)",
                                value: "Cuts (39 to 50mm)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_39_to_50_mm__c>0){
                    cutData_4.selectedValue=tyreCuts.ETT_Number_of_cuts_39_to_50_mm__c;
                    SelectedCutsNTC.push('Cuts (39 to 50mm)');
                    SelectedCutsNTCList.push(cutData_4);
                }
                CutsNTC.push(cutData_4);
                
                var cutData_5=
                            {
                                class: "optionClass",
                                label: "Cuts (51mm and above)",
                                value: "Cuts (51mm and above)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_51_mm_and_above__c>0){
                    cutData_5.selectedValue=tyreCuts.ETT_Number_of_cuts_51_mm_and_above__c;
                    SelectedCutsNTC.push('Cuts (51mm and above)');
                    SelectedCutsNTCList.push(cutData_5);
                }
                CutsNTC.push(cutData_5);
                
                component.set("v.selectedCutsNTC",SelectedCutsNTC);
                component.set("v.selectedCutsNTCList",SelectedCutsNTCList);
                component.set("v.tyreCutList", CutsNTC);
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action);
	},
    
    updateJobCardLineItem: function(component, event, helper,line,moveNextstepOnCompletion,trackActivity,updateJobCard){
        var action = component.get("c.updateJobCardLine");
        action.setParams({
            'jobCardlineWrapper': line,
            'trackActivity': trackActivity,
            'updateJobCard': updateJobCard
        });
        action.setCallback(this, function(response) {
            
            if (response.getState() == "SUCCESS") {
                component.set("v.current_line",response.getReturnValue());
                var current_line=component.get("v.current_line");                
                var current_sequence=component.get("v.current_sequence");
                if(current_sequence ==8){
                    component.set("v.seq_8_lineId",current_line.jobLineItem.Id);
                } 
                if(moveNextstepOnCompletion==true){                    
                    var seq_8_initialState=component.get("v.seq_8_initialState");
                    if(current_sequence ==8 && seq_8_initialState =='Good'){
                        component.set("v.current_sequence",(current_sequence+4));
                    }
                    else{
                        component.set("v.current_sequence",(current_sequence+1));
                    }                	
                    this.getJobDetails(component, event, helper);
                }                
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    createNewToolRequest: function(component, event, helper,selectedToolsToReplace,ReqComment,line){        
        var action = component.get("c.createToolRequestMethod");
        action.setParams({
            lineItem: line,
            toolAllocationString: JSON.stringify(selectedToolsToReplace),
            remarks: ReqComment
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.newToolRequests",response.getReturnValue());
                //confirmed that request has been placed
                line.jobLineItem.ETT_Tool_Material_Request_Raised__c=true;
                helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : "success",
                    "message": "Your request has been submitted for further approval.You can refresh or wait for the request to get approved."
                });
                toastEvent.fire(); 
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    createNewToolRequestInitial: function(component, event, helper,selectedToolsToReplace,line){        
        var action = component.get("c.createToolRequestMethodOverall");
        action.setParams({
            lineItem: line,
            toolAllocationList: selectedToolsToReplace
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.newToolRequests",response.getReturnValue());
                //confirmed that request has been placed
                line.jobLineItem.ETT_Tool_Material_Request_Raised__c=true;
                helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : "success",
                    "message": "Your request has been submitted for further approval.You can refresh or wait for the request to get approved."
                });
                toastEvent.fire(); 
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    refreshRequestStatus: function(component, event, helper){
        var newToolReq=JSON.stringify(component.get("v.newToolRequests"));
        var action = component.get("c.refreshRequestStatusMethod");
        action.setParams({
            newToolReq: newToolReq
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.newToolRequests",response.getReturnValue());
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    updateTyreDetails: function(component, event, helper){
        var action = component.get("c.updateTyreMasterDetails");
        action.setParams({
            tyreMaster: component.get("v.tyreMaster")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.tyreMaster",response.getReturnValue());
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    updateTyreInspectionDetails: function(component, event, helper){
        var action = component.get("c.updateTyreInspectionDetailsToServer");
        action.setParams({
            tyreCrownInspection: component.get("v.tyreCrownInspection")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.tyreCrownInspection",response.getReturnValue());                
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    updateJobCardLineItemForHold: function(component, event, helper,lineItemForHold,workActivityHold){
        var action = component.get("c.updateJobCardLine");
        action.setParams({
            'jobCardlineWrapper': lineItemForHold,
            'trackActivity': true,
            'updateJobCard': false
        });
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
                component.set("v.lineItemForHold",response.getReturnValue());
                var lineItemForHold=component.get("v.lineItemForHold");
                if(lineItemForHold.workTracker.ETT_End_time__c!=null){
                    component.set("v.isOnHold",false);
                    lineItemForHold.jobLineItem.Id=null;
                    lineItemForHold.workTracker.Id=null;
                }
                else{
                    component.set("v.isOnHold",true);
                }   
                component.set("v.confirmHoldVar",false);
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    getInitialization : function(component, event, helper) {//Not used as of now
        var action = component.get("c.initializeHoldLineItem");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                component.set("v.lineItemForHold",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})