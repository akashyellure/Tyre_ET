({
	initAction : function(component, event, helper) {
        helper.getBaseData(component, event, helper);
        helper.getJobDetails(component, event, helper);
        //helper.getInitialization(component, event, helper);//Not used as of now
	},
    closeModal : function(component, event, helper) {
        var cmpEvent = component.getEvent("refreshJobCardList"); 
        cmpEvent.fire(); 
		component.set("v.showJobModelView",false);
	},
    onCheck: function(component, event, helper) {
        let targetElement  = event.target;
        let index = event.target.value;
        var options = component.get('v.options');
        if(index != 'WearRequiredPPT'){
            options[index].value = event.target.checked;
        }else{
             component.set('v.WearRequiredPPT', event.target.checked);
        }
    },
    goToStep2 : function(component, event, helper) {
        component.set('v.step_error',"");
        
        var options = component.get('v.options');
		let flag = true;
        for(let ind in options){
            if(options[ind].value == false){
                flag = false;
                break;
            }
        }
        var WearRequiredPPT = component.get('v.WearRequiredPPT');
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            if (flag && WearRequiredPPT) {
                var line=component.get("v.current_line");
                line.jobLineItem.ETT_Activity_Performed__c='Workstation & Skillsset Check';
                line.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
                line.jobLineItem.ETT_Status__c='Completed';
                line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
                helper.updateJobCardLineItem(component, event, helper,line,true,false,false);      
            }
            else{
                component.set('v.step_error',"Please complete the options to proceed.");
            }
        }
        else{
            var current_sequence=component.get("v.current_sequence");
            component.set("v.current_sequence",current_sequence+1);
            helper.getJobDetails(component, event, helper);
        }     
	},
    /*onToolsCheck: function(component, event, helper) {//Not used
        let targetElement  = event.target;
        let index = event.target.value;
        var options = component.get('v.toolsListOptions');
        options[index].value = event.target.checked;
    }*/
    goToStep3 : function(component, event, helper) {
        component.set('v.step_error',"");
        
		var toolConfirmation = component.get('v.toolsCheckFinal');
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            if(toolConfirmation!=true){
                component.set('v.step_error',"Ensure you have all tools/consumables listed above. Reach out to Supervisor for assistance.");
            }
            else{
                var line=component.get("v.current_line");
                line.jobLineItem.ETT_Activity_Performed__c='Tools Availability Check';
                line.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
                line.jobLineItem.ETT_Status__c='Completed';
                line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
                var workStationSchedule=component.get("v.workStationSchedule");
                line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Station_Work_Schedule__c=workStationSchedule.Id;
                if(line.workTracker.ETT_Start_time__c==null){
                    line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                }
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');                    
                helper.updateJobCardLineItem(component, event, helper,line,true,true,true);
            }
        }
        else{
            var current_sequence=component.get("v.current_sequence");
            component.set("v.current_sequence",current_sequence+1);
            helper.getJobDetails(component, event, helper);
        }
	},
    startFloorCleaning: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Floor Conditions';
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
        
        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep4 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
			 component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Floor Conditions';
       	    line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
            line.jobLineItem.ETT_Status__c='Completed';
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    startLightWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
        
        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep5 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
			 component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Light Conditions';
            line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
            line.jobLineItem.ETT_Status__c='Completed';
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    createToolRequest: function(component, event, helper) {
        component.set("v.step_error","");        
        var buttonName = event.getSource().get("v.name");
        var line=component.get("v.current_line");
        
        if(buttonName=='iniToolReq'){
            line.jobLineItem.ETT_Activity_Performed__c='Tools Availability Check';
            line.jobLineItem.ETT_Status__c='In-Progress';
            line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
            
            var selecteToolsToReplace=[];            
            var toolsList=component.get("v.toolsListOptions");
            for(var b in toolsList){
                if(toolsList[b].isSelected){
                    if(toolsList[b].remarks==null || toolsList[b].remarks==""){
                        component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
                        break;
                    }
                    else{
                        selecteToolsToReplace.push({key: toolsList[b].value, value: toolsList[b].remarks});
                    }
                }
            }
            var stepError=component.get("v.step_error");
            if(selecteToolsToReplace.length<=0 || (!$A.util.isUndefinedOrNull(stepError) && stepError!="")){
                component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
            }
            else{
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                helper.createNewToolRequestInitial(component, event, helper,selecteToolsToReplace,line);  
            }
        }
        else if(buttonName=='bladeReq'){
            line.jobLineItem.ETT_Activity_Performed__c='Buffing Blade Conditions';
            line.jobLineItem.ETT_Status__c='In-Progress';
            line.jobLineItem.ETT_Type__c='Actual Work';
            
            var selecteToolsToReplace=[];            
            var bladList=component.get("v.bladeTools");
            for(var b in bladList){
                if(bladList[b].isSelected){
                    if(bladList[b].remarks==null || bladList[b].remarks==""){
                        component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
                        break;
                    }
                    else{
                        selecteToolsToReplace.push({key: bladList[b].value, value: bladList[b].remarks});
                    }
                }
            }
            var stepError=component.get("v.step_error");
            if(selecteToolsToReplace.length<=0 || (!$A.util.isUndefinedOrNull(stepError) && stepError!="")){
                component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
            }
            else{
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                helper.createNewToolRequestInitial(component, event, helper,selecteToolsToReplace,line);  
            }
        }
        else if(buttonName=='sideBufferReq'){
            line.jobLineItem.ETT_Activity_Performed__c='Buffing Sidebuffer Conditions';
            line.jobLineItem.ETT_Status__c='In-Progress';
            line.jobLineItem.ETT_Type__c='Actual Work';
            
            var selecteToolsToReplace=[];            
            var sideBufferTools=component.get("v.sideBufferTools");
            for(var b in sideBufferTools){
                if(sideBufferTools[b].isSelected){
                    if(sideBufferTools[b].remarks==null || sideBufferTools[b].remarks==""){
                        component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
                        break;
                    }
                    else{
                        selecteToolsToReplace.push({key: sideBufferTools[b].value, value: sideBufferTools[b].remarks});
                    }
                }
            }
            var stepError=component.get("v.step_error");
            if(selecteToolsToReplace.length<=0 || (!$A.util.isUndefinedOrNull(stepError) && stepError!="")){
                component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
            }
            else{
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                helper.createNewToolRequestInitial(component, event, helper,selecteToolsToReplace,line);  
            }
        }
        else if(buttonName=='suctionPipelineReq'){
            line.jobLineItem.ETT_Activity_Performed__c='Buffing Dust Collector - Suction pipeline capacity check';
            line.jobLineItem.ETT_Status__c='In-Progress';
            line.jobLineItem.ETT_Type__c='Actual Work';
            
            var selecteToolsToReplace=[];            
            var suctionPipelineTools=component.get("v.suctionPipelineTools");
            for(var b in suctionPipelineTools){
                if(suctionPipelineTools[b].isSelected){
                    if(suctionPipelineTools[b].remarks==null || suctionPipelineTools[b].remarks==""){
                        component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
                        break;
                    }
                    else{
                        selecteToolsToReplace.push({key: suctionPipelineTools[b].value, value: suctionPipelineTools[b].remarks});
                    }
                }
            }
            var stepError=component.get("v.step_error");
            if(selecteToolsToReplace.length<=0 || (!$A.util.isUndefinedOrNull(stepError) && stepError!="")){
                component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
            }
            else{
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                helper.createNewToolRequestInitial(component, event, helper,selecteToolsToReplace,line);  
            }
        }
        else if(buttonName=='suctionFilterReq'){
            line.jobLineItem.ETT_Activity_Performed__c='Buffing Dust Collector - Suction filter value check';
            line.jobLineItem.ETT_Status__c='In-Progress';
            line.jobLineItem.ETT_Type__c='Actual Work';
            
            var selecteToolsToReplace=[];            
            var suctionFilterTools=component.get("v.suctionFilterTools");
            for(var b in suctionFilterTools){
                if(suctionFilterTools[b].isSelected){
                    if(suctionFilterTools[b].remarks==null || suctionFilterTools[b].remarks==""){
                        component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
                        break;
                    }
                    else{
                        selecteToolsToReplace.push({key: suctionFilterTools[b].value, value: suctionFilterTools[b].remarks});
                    }
                }
            }
            var stepError=component.get("v.step_error");
            if(selecteToolsToReplace.length<=0 || (!$A.util.isUndefinedOrNull(stepError) && stepError!="")){
                component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
            }
            else{
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                helper.createNewToolRequestInitial(component, event, helper,selecteToolsToReplace,line);  
            }
        }
    },
    refreshSection: function(component, event, helper) {
        helper.refreshRequestStatus(component, event, helper);
    },
    goToStep6 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var newToolReq=component.get("v.newToolRequests");
            
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good'){
            if(line.jobLineItem.ETT_Final_Activity_State__c!='Good'){
				component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
            }
            else if(!line.jobLineItem.ETT_Tool_Material_Request_Raised__c){
                component.set("v.step_error","Please initiate new request and get approved.");
            }
            for(var i in newToolReq){
                if(newToolReq[i].ETT_Status__c!='Available' && newToolReq[i].ETT_Status__c!='Rejected'){
                    component.set("v.step_error","Please ensure new request is approved/rejected and tool is available to proceed.");
                    break;
                }
            }
        }
        var stepError=component.get("v.step_error");
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Activity_Performed__c='Buffing Blade Conditions';
            line.jobLineItem.ETT_Type__c='Actual Work';
            line.jobLineItem.ETT_Status__c='Completed';
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    goToStep7 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var newToolReq=component.get("v.newToolRequests");
            
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good'){
            if(line.jobLineItem.ETT_Final_Activity_State__c!='Good'){
				component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
            }
            else if(!line.jobLineItem.ETT_Tool_Material_Request_Raised__c){
                component.set("v.step_error","Please initiate new request and get approved.");
            }
            for(var i in newToolReq){
                if(newToolReq[i].ETT_Status__c!='Available' && newToolReq[i].ETT_Status__c!='Rejected'){
                    component.set("v.step_error","Please ensure new request is approved/rejected and tool is available to proceed.");
                    break;
                }
            }
        }
        var stepError=component.get("v.step_error");
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Activity_Performed__c='Buffing Sidebuffer Conditions';
            line.jobLineItem.ETT_Type__c='Actual Work';
            line.jobLineItem.ETT_Status__c='Completed';
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    startPowderReplacementWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Buffing powder  replacement check';
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Type__c='Actual Work';
        
        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep8 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
			 component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Buffing powder  replacement check';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';
            
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    goToStep9: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Buffing Dust Collector Check';
        if(line.jobLineItem.ETT_Initial_Activity_State__c=='Not Good'){
            line.jobLineItem.ETT_Status__c='In-Progress';
            line.jobLineItem.ETT_Has_dependency__c=true;
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        }        
        line.jobLineItem.ETT_Type__c='Actual Work';
        component.set("v.seq_8_initialState",line.jobLineItem.ETT_Initial_Activity_State__c);
        
        if(line.workTracker.ETT_Start_time__c==null){
            line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        }
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update
    },
    startSuctionLineWork: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Buffing Dust Collector - Suction line check';
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Type__c='Actual Work';
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep10 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
			 component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Buffing Dust Collector - Suction line check';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';
            line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
            
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    goToStep11 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");        
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Low' && line.jobLineItem.ETT_Final_Activity_State__c !='High'){
			 component.set("v.step_error","Please ensure final condition to be high to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Buffing Dust Collector - Suction pipeline capacity check';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';            
            line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
            
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    goToStep12 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Low' && line.jobLineItem.ETT_Final_Activity_State__c !='High'){
			 component.set("v.step_error","Please ensure final condition to be high to proceed.");
        }
        else if(seq_8_finalState !='Good'){
            component.set("v.step_error","Please ensure final dust collector status to be good to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Buffing Dust Collector - Suction filter value check';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';            
            line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
            line.jobLineItem.ETT_End_parent_line_item__c=true;
            
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    startInflationCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Buffing - Inflation pressure check';
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Type__c='Actual Work';
        
        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep13 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
			 component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Buffing - Inflation pressure check';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';
            
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    startRaspHubCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Buffing- Rasphub Tyre contact position check';
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Type__c='Actual Work';
        
        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep14 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='No' && line.jobLineItem.ETT_Final_Activity_State__c !='Yes'){
			 component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Buffing- Rasphub Tyre contact position check';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';
            
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    startTyreStoneCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Buffing- Tyre stone check';
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Type__c='Actual Work';
        
        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep15 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
			 component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Buffing- Tyre stone check';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';
            
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    goToStep16 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Started_Dust_Collection__c!=true || line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_On_Power_Switch__c!=true){
			 component.set("v.step_error","Please ensure options selected to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Power Swicth Operation';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';
            helper.updateJobCardLineItem(component, event, helper,line,true,false,true); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    goToStep17 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var startBuffingCheckbox = component.get("v.startBuffingCheckbox");
        
        if(startBuffingCheckbox!=true){
			 component.set("v.step_error","Please ensure options selected to proceed.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Buffing - Terms Read';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    startScanSurfaceCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Buffing - Scan Surface';
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Type__c='Actual Work';
        
        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep18 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Matched' && line.jobLineItem.ETT_Final_Activity_State__c !='Matched'){
			 component.set("v.step_error","Please ensure final condition to be matached to proceed.");
        }
        else if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Matched' && line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_precured_tread_line__c==null){
            component.set("v.step_error","Please ensure precured tread selected.");
        }
        else{
            line.jobLineItem.ETT_Activity_Performed__c='Buffing - Scan Surface';
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Type__c='Actual Work';
            
            if(line.workTracker.ETT_Start_time__c==null){
                line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            }
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},
    goToStep19 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Side Crown buffing';
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Type__c='Actual Work';
        helper.updateJobCardLineItem(component, event, helper,line,true,false,true); //parameter usage: line item, gotoNext step, activity update, job card update 
        var tyreMaster = component.get("v.tyreMaster"); 
        if(tyreMaster.Id !=null){
            helper.updateTyreDetails(component,event,helper);
        }
	},
    handleGenreChange: function(component,event,helper){
        //Get the Selected values   
        var selectedCutsNTCList =  component.get("v.selectedCutsNTCList");
        var selectedValues = event.getParam("value");
        console.log(selectedValues);
        
        var selectedCutsNTCList1 = [];        
        var isAdded=false;
        
        for(let index in selectedValues){
            isAdded=false;
            selectedCutsNTCList.find( function( ele ) { 
                if(ele.label === selectedValues[index]){
                    let wrp={
                        label:selectedValues[index],
                        selectedValue: ele.selectedValue
                    };
                    isAdded=true;
                    selectedCutsNTCList1.push(wrp);
                }
            } );
            for(let index2 in selectedCutsNTCList1){
                if(selectedValues[index] == selectedCutsNTCList1[index2]){
                    isAdded=true;
                }
            }
            if(isAdded==false){
                let wrp={
                        label:selectedValues[index],
                        selectedValue: 1
                    	};
                selectedCutsNTCList1.push(wrp);
            }            
        }
        console.log('@@@@  ', selectedCutsNTCList1)
        //Update the Selected Values  
        component.set("v.selectedCutsNTCList", selectedCutsNTCList1);
    },
    handleOnIncrement: function(component, event, helper){
        var index = parseInt(event.getSource().get("v.value"));
        var selectedCutsNTCList = component.get("v.selectedCutsNTCList");
        //console.log('@@@@  ',  selectedCutsNTCList[index])
        selectedCutsNTCList[index].selectedValue++;
        component.set("v.selectedCutsNTCList", selectedCutsNTCList);  
    },
    handleOnDecrement: function(component, event, helper){
        var index = parseInt(event.getSource().get("v.value"));
        var selectedCutsNTCList = component.get("v.selectedCutsNTCList");
        //console.log('@@@@  ',  selectedCutsNTCList[index])
        selectedCutsNTCList[index].selectedValue--;
        component.set("v.selectedCutsNTCList", selectedCutsNTCList);
    },
    goToStep20: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Activity_Performed__c='Buffing - Tyre Cut Check';
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Type__c='Actual Work';
        
        var selectedCutsNTCList = component.get("v.selectedCutsNTCList"); 
        var tyreCrownInspection = component.get("v.tyreCrownInspection"); 
        var cut_1=false;
        var cut_2=false;
        var cut_3=false;
        var cut_4=false;
        var cut_5=false;
        
        if(selectedCutsNTCList.length >0){            
            for(let index in selectedCutsNTCList){
                if(selectedCutsNTCList[index].label =='Cuts (0 to 10mm)'){
                    tyreCrownInspection.ETT_Number_of_cuts_0_10_mm__c=selectedCutsNTCList[index].selectedValue;
                    cut_1=true;
                }
                else if(selectedCutsNTCList[index].label =='Cuts (11 to 25mm)'){
                    tyreCrownInspection.ETT_Number_of_cuts_11_to_25_mm__c=selectedCutsNTCList[index].selectedValue;
                    cut_2=true;
                }
                else if(selectedCutsNTCList[index].label =='Cuts (26 to 38mm)'){
                    tyreCrownInspection.ETT_Number_of_cuts_26_to_38_mm__c=selectedCutsNTCList[index].selectedValue;
                    cut_3=true;
                }
                else if(selectedCutsNTCList[index].label =='Cuts (39 to 50mm)'){
                    tyreCrownInspection.ETT_Number_of_cuts_39_to_50_mm__c=selectedCutsNTCList[index].selectedValue;
                    cut_4=true;
                }
                else if(selectedCutsNTCList[index].label =='Cuts (51mm and above)'){
                    tyreCrownInspection.ETT_Number_of_cuts_51_mm_and_above__c=selectedCutsNTCList[index].selectedValue;
                    cut_5=true;
                }
            }        
        }
        
        if(!cut_1){
            tyreCrownInspection.ETT_Number_of_cuts_0_10_mm__c=0;
        }
        if(!cut_2){
            tyreCrownInspection.ETT_Number_of_cuts_11_to_25_mm__c=0;
        }
        if(!cut_3){
            tyreCrownInspection.ETT_Number_of_cuts_26_to_38_mm__c=0;
        }
        if(!cut_4){
            tyreCrownInspection.ETT_Number_of_cuts_39_to_50_mm__c=0;
        }
        if(!cut_5){
            tyreCrownInspection.ETT_Number_of_cuts_51_mm_and_above__c=0;
        }
        if(tyreCrownInspection.Id !=null){
            helper.updateTyreInspectionDetails(component,event,helper);             
        }
        
        if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c) || line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c==""){ 
            component.set("v.step_error","Status is mandatory to end.");
        }
        else{
           helper.updateJobCardLineItem(component, event, helper,line,true,false,true); //parameter usage: line item, gotoNext step, activity update, job card update 
           var action = component.get("c.closeModal");
           $A.enqueueAction(action);
        }
    },
    showHoldDialog: function(component,event,helper){
    	component.set("v.confirmHoldVar",true);
    },
    continueActivities: function(component,event,helper){
    	component.set("v.confirmHoldVar",false);
    },
    confirmOnHold: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var lineItemForHoldWrapper=component.get("v.lineItemForHold");
        
        if(lineItemForHoldWrapper.workTracker.ETT_Reason_for_hold__c==null || lineItemForHoldWrapper.workTracker.ETT_Reason_for_hold__c==""){
            component.set("v.step_error","Reason for hold is mandatory.");
        }
        else if(line.jobLineItem.Id !=null && line.workTracker.ETT_Start_time__c!=null){//ensure that there is a line item work started in order to end the activity.
            //populate end time so that user can keep the activity onhold temporarly.
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
            
            //lineItemForHoldWrapper.jobLineItem.Id=null;
            lineItemForHoldWrapper.jobLineItem.ETT_Activity_Performed__c='OnHold';
            lineItemForHoldWrapper.jobLineItem.ETT_Job_Card__c=line.relatedJobWrapper.validJobCardList[0].Id;
            lineItemForHoldWrapper.jobLineItem.ETT_Status__c='In-Progress';
       		lineItemForHoldWrapper.jobLineItem.ETT_Type__c='Pause';  
            lineItemForHoldWrapper.jobLineItem.Sequence__c=0;  
            lineItemForHoldWrapper.jobLineItem.ETT_Revision_Number__c=line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            lineItemForHoldWrapper.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            lineItemForHoldWrapper.workTracker.ETT_End_time__c=null;            
            helper.updateJobCardLineItemForHold(component, event, helper,lineItemForHoldWrapper); //parameter usage: line item for hold 
        }
        else{
            component.set("v.step_error","No activity has been started to put it onhold.");
        }
    },
    resumeActivity: function(component,event,helper){
        component.set("v.step_error","");
        var isHold=component.get("v.isOnHold");
        var line=component.get("v.current_line");
        var lineItemForHoldWrapper=component.get("v.lineItemForHold"); 
        
        if(isHold==true && line.jobLineItem.Id !=null && lineItemForHoldWrapper.jobLineItem.Id!=null){
            //nullify id of activity table & end time so that system will upsert it as new entry on work activity table to resume activity tracking.
            line.workTracker.Id=null;
            line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            line.workTracker.ETT_End_time__c=null;
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
                    	           
            lineItemForHoldWrapper.ETT_Activity_Performed__c='OnHold';
            lineItemForHoldWrapper.jobLineItem.ETT_Job_Card__c=line.relatedJobWrapper.validJobCardList[0].Id;
            lineItemForHoldWrapper.jobLineItem.ETT_Status__c='Completed';
       		lineItemForHoldWrapper.jobLineItem.ETT_Type__c='Pause'; 
            lineItemForHoldWrapper.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ'); 
            helper.updateJobCardLineItemForHold(component, event, helper,lineItemForHoldWrapper); //parameter usage: line item for hold 
        }
        else{
            component.set("v.step_error","No activity has been kept onhold in order to resume.");
        }
    }
})