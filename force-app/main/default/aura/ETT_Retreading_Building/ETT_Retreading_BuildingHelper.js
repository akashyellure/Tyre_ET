({ 
    getBaseData: function(component, event, helper) {
        var isOnLoad=component.get("v.isOnLoad");
        var skillSetGroup = [];
        var reqSkillSets=component.get("v.skillSets");
        if(!$A.util.isUndefinedOrNull(reqSkillSets)){
            for(var i in reqSkillSets){
                var skillDet={};
                skillDet.label=reqSkillSets[i].Name;
                skillDet.value=reqSkillSets[i].Name;
                skillSetGroup.push(skillDet);
            }
        }
        
        var isUsagePresent=false;        
        var toolsListOptions = [];
        var toolUsageListOptions=component.get("v.toolUsageListOptions");//get current usage
        
        var reqtoolSets=component.get("v.stationWrapperTools");
        if(!$A.util.isUndefinedOrNull(reqtoolSets)){
            for(var i in reqtoolSets){                
                var toolDet={};
                var labelStr=reqtoolSets[i].stationTool.ETT_Tools_Master__r.Name;
                if(!$A.util.isUndefinedOrNull(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Unique_Code__c)){
                    labelStr+=' (Item Code: '+reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Unique_Code__c+') ';
                }
                if(!$A.util.isUndefinedOrNull(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Serial_No__c)){
                    labelStr+=' (Serial No: '+reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Serial_No__c+') ';
                }
                if(!$A.util.isUndefinedOrNull(reqtoolSets[i].stationTool.Allocation_Status__c)){
                    labelStr+=' (Status: '+reqtoolSets[i].stationTool.Allocation_Status__c+') ';
                }
                if(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Usage_type__c=='Consumable'){
                    labelStr+=' (Available Stocks : '+reqtoolSets[i].stationTool.ETT_Available_Stocks__c+' '+reqtoolSets[i].stationTool.ETT_Tools_Master__r.Unit_Text__c+') ';
                }
                if(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Main_Stock_Units__c){
                    labelStr+=' (Main Stock :'+reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Main_Stock_Units__c+')';
                }
                if(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Allocated_Units__c){
                    labelStr+=' (Factory Stock :'+reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Allocated_Units__c+')';
                }
                
                toolDet.label=labelStr;
                toolDet.value=reqtoolSets[i].stationTool.Id;
                toolDet.isSelected=false;
                toolDet.remarks='';//used to capture comments from user to create new request.
                toolDet.requestedStockUnits=reqtoolSets[i].stationTool.ETT_Allocated_Units_to_Station__c;//default value from current allocation
                toolDet.toolAllocationDet=reqtoolSets[i].stationTool;
                toolDet.toolUsage=reqtoolSets[i].usageRec;  
                toolDet.toolImageLink=reqtoolSets[i].toolImageLink;  
                toolDet.lstFileWrapperDetails=reqtoolSets[i].lstFileWrapperDetails; 
                toolsListOptions.push(toolDet);
                
                if(isOnLoad==true && (reqtoolSets[i].stationTool.Allocation_Status__c=='Approved' || reqtoolSets[i].stationTool.Allocation_Status__c=='Almost Used')){
                    toolUsageListOptions.push(toolDet);
                }
                else{
                    isUsagePresent=false;
                    for(let j in toolUsageListOptions){
                        if(toolUsageListOptions[j].toolAllocationDet.Id == reqtoolSets[i].stationTool.Id){
                            isUsagePresent=true;
                        }
                    }
                    if(!isUsagePresent && (reqtoolSets[i].stationTool.Allocation_Status__c=='Approved' || reqtoolSets[i].stationTool.Allocation_Status__c=='Almost Used')){
                        toolUsageListOptions.push(toolDet);
                    }
                }
                
                
                if(reqtoolSets[i].stationTool.Allocation_Status__c!='Approved' && reqtoolSets[i].stationTool.Allocation_Status__c!='Almost Used' && reqtoolSets[i].stationTool.Allocation_Status__c!='Rejected'){
                    component.set("v.step_error","Some of the requested tools/consumables are not approved/pending approval. Reach out to Supervisor for assistance.");
                }
            }
            
            var mainGroup = [
             /*   {
                    'label' : 'Requried Skill Sets',
                    'value': '',
                   'subitem': skillSetGroup
                },*/
                {
                    'label' : 'Tools/Consumables',
                    'value': '',
                    'subitem': toolsListOptions
                }
            ];       
            component.set('v.options', mainGroup);   
            
            var itemsToRemove=[];
            if(!isOnLoad){
                for(let k in toolUsageListOptions){
                    isUsagePresent=false;
                    for(let l in toolsListOptions){
                        if(toolUsageListOptions[k].toolAllocationDet.Id == toolsListOptions[l].toolAllocationDet.Id){
                            isUsagePresent=true;
                        }
                    }
                    if(!isUsagePresent && (toolUsageListOptions[k].toolUsage.Id==null || $A.util.isUndefinedOrNull(toolUsageListOptions[k].toolUsage.Id))){
                        if($A.util.isUndefinedOrNull(toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c) || toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c<=0){
                            itemsToRemove.push(k);
                        }
                        else if($A.util.isUndefinedOrNull(toolUsageListOptions[k].toolUsage.ETT_Track_Depreciable_Item_Usage_at_JC__c) || toolUsageListOptions[k].toolUsage.ETT_Track_Depreciable_Item_Usage_at_JC__c!=true){
                            itemsToRemove.push(k);
                        }
                    }
                }
                if(itemsToRemove.length >0){
                    toolUsageListOptions.splice(itemsToRemove[0],itemsToRemove.length);
                }
            }
        }
        var toolmainGroup = [
            {
                'label' : 'Tools Required',
                'value': '',
                'subitem': toolsListOptions
            }
        ];       
        component.set('v.toolsListOptions', toolsListOptions); //toolmainGroup
        component.set("v.toolUsageListOptions",toolUsageListOptions);//tool usage
        
        if(isOnLoad==true){
            component.set("v.isOnLoad",false);
        }
    },
    getDatafromParent:function(component,event,helper){
        var availableDefects = [];
        var availableDef = component.get("v.availableDefects");
        for(var key in availableDef){
            availableDefects.push({'label': availableDef[key], 'value': availableDef[key]});
        }
        component.set("v.availableDefects",availableDefects);
        /*
         * 
        var availableStations = [];
        var availableStationsList = component.get("v.availableStations");
        availableStations.push({"label":"---Select Work Station---","value":""});
        for(var key in availableStationsList){
            availableStations.push({'label': availableStationsList[key], 'value': availableStationsList[key]});
        }
        component.set("v.availableStations",availableStations);*/
        
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
        
        var statusValues = [];
        statusValues.push({key: '', value: '---Select---'});
        statusValues.push({key: 'Accepted', value: 'Accepted'});
        statusValues.push({key: 'Initial Rejection', value: 'Initial Rejection'});
        component.set("v.statusValues",statusValues);
        
       /* var holdReasonValues = [];
        var holdReasons = component.get("v.holdReasonValues");
        holdReasonValues.push({key: '', value: '---Select---'});
        for(var key in holdReasons){
            holdReasonValues.push({key: key, value: holdReasons[key]});
        }
        component.set("v.holdReasonValues",holdReasonValues);*/
    },
    getJobDetails : function(component, event, helper,Nextlineitem,nextWorkTracker) {
      
        var action = component.get("c.getValidJobCardLineDetail");
        action.setParams({
            'recordId': component.get("v.recordId"),
            'stageValue': 'Building',
            'current_sequence': component.get("v.current_sequence"),
            'readOnlyView': !component.get('v.allowDML'),
            'Nextlineitem' : Nextlineitem,
            'nextWorkTracker' : nextWorkTracker
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                var respWrapper = response.getReturnValue();
                component.set("v.current_sequence",respWrapper.jobLineItem.Sequence__c);
                component.set("v.current_line",respWrapper);
                component.set("v.Nextlineitem",respWrapper.nextJobLineItem);
                component.set("v.nextWorkTracker",respWrapper.nextWorkTracker);
                component.set("v.lineItemForHold",respWrapper.holdLineItem);
                component.set("v.selectedNextStation",respWrapper.relatedJobWrapper.nextStageValue);
              
                console.log(JSON.stringify(respWrapper));
                
                
                var availableStations = [];
                var availableStationsList = respWrapper.relatedJobWrapper.availableNextStationList;
                availableStations.push({"label":"---Select Work Station---","value":""});
                for(var key in availableStationsList){
                    availableStations.push({'label': availableStationsList[key], 'value': availableStationsList[key]});
                }
                component.set("v.availableStations",availableStations);
                
                               
                var availableDefects = [];
                var availableDef = respWrapper.relatedJobWrapper.availableDefectsForStation;
                
                for(var key in availableDef){
                    availableDefects.push({'label': availableDef[key], 'value': availableDef[key]});
                }
                component.set("v.availableDefects",availableDefects);
                
                var holdReasonValues = [];
                var holdReasons = respWrapper.relatedJobWrapper.holdReasons;
                holdReasonValues.push({key: '', value: '---Select---'});
                for(var key in holdReasons){
                    holdReasonValues.push({key: key, value: holdReasons[key]});
                }
                component.set("v.holdReasonValues",holdReasonValues);
                
                var previousJobCardOnCurrentStation=component.get("v.previousJobCardOnCurrentStation");
                if(previousJobCardOnCurrentStation==null){
                    helper.getPreviousJobCardOfStation(component, event, helper);
                }
                                        
                if(respWrapper.holdLineItem.jobLineItem.Id!=null){
                    component.set("v.isOnHold",true);
                }
                component.set("v.step_error","");
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    updateJobCardLineItem: function(component, event, helper,line,moveNextstepOnCompletion,trackActivity,updateJobCard,Nextlineitem,nextWorkTracker){
        var action = component.get("c.updateJobCardLine");
        action.setParams({
            'jobCardlineWrapper': line,
            'trackActivity': trackActivity,
            'updateJobCard': updateJobCard,
            'selectedNextStation': component.get("v.selectedNextStation")
        });
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
                component.set("v.current_line",response.getReturnValue());
                var current_line=component.get("v.current_line");                
                var current_sequence=component.get("v.current_sequence");
                if(moveNextstepOnCompletion==true){                    
                    component.set("v.current_sequence",(current_sequence+1));
                    this.getJobDetails(component, event, helper,Nextlineitem,nextWorkTracker);
                }      
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    getHOONotification:function(component, event, helper){
        debugger;
        var line=component.get("v.current_line");
        let jcId = line.jobLineItem.ETT_Job_Card__c;
        //alert (jcId);
        var action = component.get("c.HOONotification");
        action.setParams({
            targetId : jcId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
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
    getPreviousJobCardOfStation: function(component, event, helper){
        var workStationSchedule=component.get("v.workStationSchedule");
        var line=component.get("v.current_line");
        var action = component.get("c.getPreviousJobCardBuilding");
        action.setParams({
            'workSchedule': workStationSchedule.Id
        });
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
                var res=response.getReturnValue();
                component.set("v.previousJobCardOnCurrentStation",res);
                console.log('This is here line.relatedJobWrapper.validJobCardList[0].ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name-->'+JSON.stringify(line.relatedJobWrapper.validJobCardList[0].ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name));
                  console.log('This is here res.ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name-->'+JSON.stringify(res.ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name));
                  console.log('This is here-->'+JSON.stringify(res));
                if(res!=null && res.ETT_Tyre_Master__c!=null && res.ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name == line.relatedJobWrapper.validJobCardList[0].ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name){
                   // component.set("v.ChangeTyreRim",false)   
                }
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);	          
    },
    getStageRecordtypeId: function(component, event, helper){
        var action = component.get("c.getObjectRecordTypeIdByNme");
        action.setParams({
            'ObjectName': 'ETT_Job_Card_Line_Item__c',
            'recordTypeDeveloperName': 'Building'
        });
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
                component.set("v.recordTypeIdOfStageName",response.getReturnValue());
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);	          
    },
    createNewToolRequestInitial: function(component, event, helper,selectedToolsToReplace,line){        
        var action = component.get("c.createToolRequestMethodVersion2");
        action.setParams({
            lineItem: line,
            toolAllocationList: selectedToolsToReplace,
            workscheduleStationId:component.get("v.workSheduleInfo.ETT_Work_Station__c")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.newToolRequests",response.getReturnValue());
                console.log(response.getReturnValue());
                //confirmed that request has been placed
                var current_sequence=component.get("v.current_sequence");
                if(current_sequence==1){//first step where user may raise tool request, pre populate the fields for inserting line items.
                    line.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
                    line.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
                    line.jobLineItem.ETT_Status__c='In-Progress';
                    line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
                }
                line.jobLineItem.ETT_Tool_Material_Request_Raised__c=true;
                
                helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                
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
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
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
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
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
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
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
    },
    getStationTools: function(component, event, helper) {
        var action = component.get("c.getStationToolsWithWrapper");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                component.set("v.stationWrapperTools",response.getReturnValue());
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
                });
                toastEvent.fire();  
            }
            helper.getBaseData(component, event, helper);//call this helper at last so that other variables will be updated.
        });
        $A.enqueueAction(action);
    },
    updateToolMaterialUsage: function(component, event, helper,toolUsageListOptions,line) {
        var action = component.get("c.updateToolsUsageInDB");
        action.setParams({
            toolUsageListOptions: toolUsageListOptions, 
            jobLine: line
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                component.set("v.toolUsageListOptions",response.getReturnValue());
                var action = component.get("c.backFromUsage");
                $A.enqueueAction(action);
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
                });
                toastEvent.fire();  
            }
            helper.getBaseData(component, event, helper);//call this helper at last so that other variables will be updated.
        });
        $A.enqueueAction(action);
    },
    reportDefectsAndUpdateStations: function(component, event, helper){
        var action = component.get("c.reportDefectsAndUpdateStationsinDB");
        action.setParams({
            defects: component.get("v.selectedDefects"),
            nextStation: component.get("v.selectedNextStation"),
            jobLine: component.get("v.current_line")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                var actionClose = component.get("c.closeModal");
                $A.enqueueAction(actionClose);
            }
            else{
                var errors = response.getError();
                 console.log(errors)
                var toastEvent = $A.get("e.force:showToast");
                var errorStr;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                       
                        errorStr=errors[0].message;
                    }
                } else {
                    errorStr="Unknown Exception!";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": 'Unable to process your request: '+errorStr
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    }
})