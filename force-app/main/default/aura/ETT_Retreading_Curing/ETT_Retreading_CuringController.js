({
    initAction : function(component, event, helper) {  
       //  alert('availableStations----------->'+JSON.stringify(component.get('v.availableStations')));
        helper.getJobDetails(component, event, helper,null);
        helper.getStationTools(component, event, helper);
        helper.getDatafromParent(component, event, helper);
        helper.getStageRecordtypeId(component, event, helper);
		helper.getJobList(component, event, helper);
       
          
      
    },
    
    changeReason: function(component, event, helper) { 
         var line=component.get("v.current_line");
		if(line.jobLineItem.ETT_Enter_Reason1__c != ""){
            	component.set("v.step_error","");   	
        }
    },
    filterRequests: function(component, event, helper) { 
		var rec = component.get("v.selectedValues");
        //alert(JSON.stringify(rec));
    },
    closeModal : function(component, event, helper) {
        var cmpEvent = component.getEvent("refreshJobCardList"); 
        cmpEvent.fire(); 
        component.set("v.showJobModelView",false);
    },
    handleComplaintMasterEvent : function(component, event, helper) {        
        var flag =event.getParam("flag");// getting the value of event attribute
        console.log('name:::'+JSON.stringify(flag));
        
        var line=component.get("v.current_line");
        component.set("v.step_error","");
        
        if(flag){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Stage Check';
            Nextlineitem.ETT_Type__c='Actual Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ'); 
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
        else{
            component.set("v.step_error","Something went wrong..");
        }
    },
    onPreRequisiteCheck: function(component, event, helper) {
        let targetElement  = event.target;
        let index = event.target.value;
        var options = component.get('v.options');
        if(index != 'WearRequiredPPT'){
            options[index].value = event.target.checked;
        }else{
            component.set('v.WearRequiredPPT', event.target.checked);
        }
    },
    startLightWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    startFloorCleaning: function(component, event, helper){
        var line=component.get("v.current_line");
       	var line=component.get("v.current_line"); 
        var seq = JSON.stringify(line.jobLineItem.Sequence__c);
        if(seq== '9'){
            if(line.jobLineItem.ETT_Enter_Reason1__c == null && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
        }
        else if(seq== '10'){
            if(line.jobLineItem.ETT_Enter_Reason1__c == null && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
         } 
       
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    openToolsReqSectionOperation: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.openToolsReqSection",true);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
    },
    createToolRequest: function(component, event, helper) {
        component.set("v.step_error","");        
        var buttonName = event.getSource().get("v.name");
        var line=component.get("v.current_line");
        
        if(buttonName=='toolReq'){
            line.jobLineItem.ETT_Status__c='In-Progress';
            
            var selecteToolsToReplace=[];            
            var toolsList=component.get("v.toolsListOptions");
            for(var b in toolsList){
                if(toolsList[b].isSelected){
                    if(toolsList[b].remarks==null || toolsList[b].remarks==""){
                        component.set("v.step_error","Choose tool(s) & remarks to create new request(s).");
                        break;
                    }
                    else if(toolsList[b].requestedStockUnits==null || toolsList[b].requestedStockUnits==0 || toolsList[b].requestedStockUnits==""){
                        component.set("v.step_error","Choose reqesting stock unit value");
                        break;
                    }
                        else if(toolsList[b].toolAllocationDet.ETT_Tools_Master__r.ETT_Unit_type__c=='Individual product' && toolsList[b].requestedStockUnits >1){
                            component.set("v.step_error","Choose reqesting stock unit value to max 1 if the unit type is individual product tool/material.");
                            break;
                        }
                            else{
                                selecteToolsToReplace.push(toolsList[b]);
                            }
                }
            }
            
            
            var stepError=component.get("v.step_error");
            if((stepError==null || stepError=="") && selecteToolsToReplace.length<=0){
                component.set("v.step_error","Choose tool(s) create new request(s).");
            }
            else if(stepError==null || stepError==""){
                helper.createNewToolRequestInitial(component, event, helper,selecteToolsToReplace,line);  
            }
        }
    },
    showHoldDialog: function(component,event,helper){
        component.set("v.step_error","");
        component.set("v.confirmHoldVar",true);
        component.set("v.usageSection",false);
        component.set("v.openToolsReqSection",false);
    },
    openUsageTracker: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.usageSection",true);
        component.set("v.confirmHoldVar",false); 
        component.set("v.openToolsReqSection",false);
    },
    openDefectSection: function(component,event,helper){
        component.set("v.step_error","");
        component.set("v.displayDefectSectionCutOff",true);
        component.set("v.openToolsReqSection",false);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
    },
    backFromDefects: function(component,event,helper){
        component.set("v.step_error","");
        component.set("v.displayDefectSectionCutOff",false);
        component.set("v.openToolsReqSection",false);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
    },
    reportDefectsAndEnd: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var selectedDefects=component.get("v.selectedDefects");
        var selectedNextStation=component.get("v.selectedNextStation");
        if($A.util.isUndefinedOrNull(selectedNextStation) || selectedNextStation==null || selectedNextStation=="" || selectedDefects.length==0){
            component.set("v.step_error","Please select both options to proceed.");
        }
        else{
            if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Technici_Rejection_Remarks__c)){
                line.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Technici_Rejection_Remarks__c='';
            }
            line.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Technici_Rejection_Remarks__c='Version(Defect found):'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Technici_Rejection_Remarks__c;//append the technician remarks
            helper.reportDefectsAndUpdateStations(component,event,helper);
        }
    },
    getStageRecordtypeId: function(component, event, helper){
        var action = component.get("c.getObjectRecordTypeIdByNme");
        action.setParams({
            'ObjectName': 'ETT_Job_Card_Line_Item__c',
            'recordTypeDeveloperName': 'Cementing'
        });
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
                component.set("v.recordTypeIdOfStageName",response.getReturnValue());
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
    confirmOnHold: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var current_sequence=component.get("v.current_sequence");
        var lineItemForHoldWrapper=component.get("v.lineItemForHold");
        
        if(lineItemForHoldWrapper.jobLineItem.ETT_Pause_Reason__c==null || lineItemForHoldWrapper.jobLineItem.ETT_Pause_Reason__c==""){
            component.set("v.step_error","Reason for hold is mandatory.");
        }
        else if(line.jobLineItem.Id !=null && (line.workTracker.ETT_Start_time__c!=null || current_sequence==1)){//ensure that there is a line item work started in order to end the activity.
            //populate end time so that user can keep the activity onhold temporarly.
            if(line.workTracker.ETT_Start_time__c!=null){
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
            }
            else{
                helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
            }
            //lineItemForHoldWrapper.jobLineItem.Id=null;
            lineItemForHoldWrapper.jobLineItem.ETT_Activity_Performed__c='OnHold';
            lineItemForHoldWrapper.jobLineItem.ETT_Job_Card__c=line.relatedJobWrapper.validJobCardList[0].Id;
            lineItemForHoldWrapper.jobLineItem.ETT_Status__c='In-Progress';
            lineItemForHoldWrapper.jobLineItem.ETT_Type__c='Pause'; 
            lineItemForHoldWrapper.jobLineItem.Sequence__c=0; 
            lineItemForHoldWrapper.jobLineItem.RecordTypeId=component.get("v.recordTypeIdOfStageName");
            lineItemForHoldWrapper.jobLineItem.ETT_Revision_Number__c=line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            lineItemForHoldWrapper.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            lineItemForHoldWrapper.workTracker.ETT_End_time__c=null;
            helper.updateJobCardLineItemForHold(component, event, helper,lineItemForHoldWrapper); //parameter usage: line item for hold 
        }
            else{
                component.set("v.step_error","No activity has been started to put it onhold.");
            }
    },
    continueActivities: function(component,event,helper){
        component.set("v.step_error","");
        component.set("v.confirmHoldVar",false);
        component.set("v.usageSection",false);
        component.set("v.openToolsReqSection",false);
    },
    checkForCuttings: function(component,event,helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    backFromUsage: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
        component.set("v.openToolsReqSection",false);
    },
    backFromToolReqPage: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.openToolsReqSection",false);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
    },
    saveUsage: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var toolUsageListOptions=component.get("v.toolUsageListOptions");
        
        for(let i in toolUsageListOptions){
            let tool=toolUsageListOptions[i];
            if(tool.toolAllocationDet.ETT_Tools_Master__r.ETT_Usage_type__c=='Consumable' && !$A.util.isUndefinedOrNull(tool.toolUsage.ETT_Usage_Value__c)){
                if(isNaN(parseInt(tool.toolUsage.ETT_Usage_Value__c)) && tool.toolUsage.ETT_Usage_Value__c!=""){
                    component.set("v.step_error","Invalid number entered.");
                    break;   
                }
                else if(tool.toolUsage.ETT_Usage_Value__c>0 && ($A.util.isUndefinedOrNull(tool.toolAllocationDet.ETT_Available_Stocks__c) || tool.toolAllocationDet.ETT_Available_Stocks__c=="" || tool.toolAllocationDet.ETT_Available_Stocks__c<=0 || tool.toolAllocationDet.ETT_Available_Stocks__c==null)){
                    component.set("v.step_error","Usage cannot exceed the stock value.");
                    break;   
                }
                    else if(tool.toolAllocationDet!=null && tool.toolAllocationDet.ETT_Available_Stocks__c>0 && tool.toolUsage.ETT_Usage_Value__c>tool.toolAllocationDet.ETT_Available_Stocks__c){
                        component.set("v.step_error","Usage cannot exceed the stock value.");
                        break;   
                    }                             
            }
            else if(tool.toolAllocationDet.ETT_Tools_Master__r.ETT_Usage_type__c=='Consumable' && tool.toolAllocationDet.ETT_Tools_Master__r.ETT_Unit_type__c=='Quantity based' && !$A.util.isUndefinedOrNull(tool.toolUsage.ETT_Usage_Value__c) && tool.toolUsage.ETT_Usage_Value__c>0){
                if(parseInt(tool.toolUsage.ETT_Usage_Value__c) < tool.toolUsage.ETT_Usage_Value__c){
                    component.set("v.step_error","Whole number required for quantity based tool/material.");
                    break;
                }
                else if(tool.toolUsage.ETT_Usage_Value__c>0 && ($A.util.isUndefinedOrNull(tool.toolAllocationDet.ETT_Available_Stocks__c) || tool.toolAllocationDet.ETT_Available_Stocks__c=="" || tool.toolAllocationDet.ETT_Available_Stocks__c<=0 || tool.toolAllocationDet.ETT_Available_Stocks__c==null)){
                    component.set("v.step_error","Usage cannot exceed the stock value.");
                    break;   
                }
                    else if(tool.toolAllocationDet!=null && tool.toolAllocationDet.ETT_Available_Stocks__c>0 && tool.toolUsage.ETT_Usage_Value__c>tool.toolAllocationDet.ETT_Available_Stocks__c){
                        component.set("v.step_error","Usage cannot exceed the stock value.");
                        break;   
                    }
            }
        }
        
        var step_error=component.get("v.step_error");
        if(step_error==null || step_error==""){
            helper.updateToolMaterialUsage(component, event, helper,toolUsageListOptions,line);
        }    	  
    },
    handleFilesChange: function(component,event,helper){
        component.set("v.step_error","");
        var files = component.get("v.fileToBeUploaded");
        var fileSourceType = event.getSource().get("v.id");
        var fileName = event.getSource().get("v.name");
        var toolsListOptions=component.get("v.toolsListOptions");
        var fileUploadWrapper = [];
        
        if(files && files.length > 0) {
            for(var i=0; i < files[0].length; i++){
                var file = files[0][i];
                var reader = new FileReader();
                reader.name = file.name;
                reader.type = file.type;
                
                reader.onloadend = function(e) {  
                    var fileName = file.name;
                    /*fileName= fileName.replace(/[^a-zA-Z0-9 ]/g, "");
                    fileName=fileName.replace(/ /g,"_");*/
                    
                    var strFileName = e.target.name;
                    var ext = strFileName.split('.').pop();
                    
                    for(var j in toolsListOptions){
                        if(fileSourceType == j){
                            console.log('Current line: '+j);
                            var base64Img = e.target.result;
                            var base64result = base64Img.split(',')[1];
                            toolsListOptions[j].lstFileWrapperDetails.push({
                                'strFileName':fileName,//+'.'+ext
                                'strFileType':e.target.type,
                                'fileSourceType':fileSourceType,
                                'fileContent':base64result,
                                'parentId':''
                            });
                        }
                    }
                }
                
                function handleEvent(event) {
                    component.set("v.toolsListOptions",toolsListOptions);
                }
                reader.readAsDataURL(file);
                reader.addEventListener('loadend', handleEvent);
            }
        }        
    },
    refreshSection: function(component, event, helper) {
        var newToolReq=JSON.stringify(component.get("v.newToolRequests"));
        if(newToolReq && newToolReq.length >0){
            helper.refreshRequestStatus(component, event, helper);
        }
        else{
            helper.getStationTools(component, event, helper);
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
    },

    
    goToStep2 : function(component, event, helper) {
        
        var jobCardIds = component.get("v.jobCardIdsToProcess");
                //alert('JobCard Sandip' +jobCardIds);

        console.log(JSON.stringify(jobCardIds));
        
                    var line=component.get("v.current_line");
                    line.jobLineItem.ETT_Activity_Performed__c='Curing Chamber Door Condition';
                    line.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
                    line.jobLineItem.ETT_Status__c='Completed';
                    line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
                    line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                    line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
                    
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Enter Curing round number and choose starting time and end time';
                    Nextlineitem.ETT_Type__c='Actual Work';
                    Nextlineitem.ETT_Status__c='Not Started';
                    
                    var nextWorkTracker=component.get("v.nextWorkTracker");
                    nextWorkTracker.Id=null;
                    nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');                    
                    
                    
                    //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker);//current line, line update is needed/not,work actviity tracker/not,job update needed/not,next line to create, next work activity
                    helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
                    
                
    },
    
    goToStep3 : function(component, event, helper) {
       
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        console.log(JSON.stringify(jobCardIds));
       
                    var line=component.get("v.current_line");
                    line.jobLineItem.ETT_Activity_Performed__c='Curing Hydraulic Pump Condition';
                    line.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
                    line.jobLineItem.ETT_Status__c='Completed';
                    line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
                    line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                    line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
                    
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Curing Door Safety Lock';
                    Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                    Nextlineitem.ETT_Status__c='Not Started';
                    
                    var nextWorkTracker=component.get("v.nextWorkTracker");
                    nextWorkTracker.Id=null;
                    nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');                    
                   // helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker);//current line, line update is needed/not,work actviity tracker/not,job update needed/not,next line to create, next work activity
                    helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
             	
    },
    
    goToStep4 : function(component, event, helper) {
        
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        console.log(JSON.stringify(jobCardIds));
                    var line=component.get("v.current_line");
                    line.jobLineItem.ETT_Activity_Performed__c='Curing Door Safety Lock';
                    line.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
                    line.jobLineItem.ETT_Status__c='Completed';
                    line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
                    
                   // var workStationSchedule=component.get("v.workStationSchedule");
                    line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Work_Schedule__c=component.get("v.workSheduleInfo.Id");
                    if(line.workTracker.ETT_Start_time__c==null){
                        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                    }
                    line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
                    
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Door safety lock is ok';
                    Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                    Nextlineitem.ETT_Status__c='Not Started';
                    
                    var nextWorkTracker=component.get("v.nextWorkTracker");
                    nextWorkTracker.Id=null;
                    nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');                    
                    
                    
                    //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker);//current line, line update is needed/not,work actviity tracker/not,job update needed/not,next line to create, next work activity
                    helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
                    
             
        
    },
    
    goToStep5 : function(component, event, helper) {
        
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        console.log(JSON.stringify(jobCardIds));
        component.set('v.step_error',"");
        var step_error=component.get('v.step_error');         
                    var line=component.get("v.current_line");
                    line.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
                    line.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
                    line.jobLineItem.ETT_Status__c='Completed';
                    line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
                    
                    //var workStationSchedule=component.get("v.workStationSchedule");
                    line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Work_Schedule__c= component.get("v.workSheduleInfo.Id");
                    if(line.workTracker.ETT_Start_time__c==null){
                        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                    }
                    line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
                    
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Curing Check 13 Inflation Pressure Valve and 13 Pressure Cable Condition';
                    Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                    Nextlineitem.ETT_Status__c='Not Started';
                    
                    var nextWorkTracker=component.get("v.nextWorkTracker");
                    nextWorkTracker.Id=null;
                    nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');                    
                    
                    
                   // helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker);//current line, line update is needed/not,work actviity tracker/not,job update needed/not,next line to create, next work activity
                    helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
                    
        
    },
    goToStep6 : function(component, event, helper) {
        
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        console.log(JSON.stringify(jobCardIds));
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var rec = component.get("v.selectedValues");
        if(rec.length <= 0 && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
           var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
              "title": "Error!",
              "type" : "error",
              "message": "Please select job cards"
           });
           toastEvent.fire(); 
            return;
        }
        for(var i=0; i<rec.length; i++){
            for(var j=i+1;j<rec.length;j++){
                if(rec[i].pvalve == rec[j].pvalve || rec[i].vvalve == rec[j].vvalve){
				    var toastEvent = $A.get("e.force:showToast");
           			toastEvent.setParams({
              			"title": "Error!",
		                "type" : "error",
              			"message": "Please select unique valve numbers for each job card"
           			});
               		toastEvent.fire(); 
           			return;               
                }
            }
        } 
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
       
                    line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Work_Schedule__c=component.get("v.workSheduleInfo.Id");
                    if(line.workTracker.ETT_Start_time__c==null){
                        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                    }
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Curing Vacuum Machine Condition';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        var rec = component.get("v.selectedValues");
        var jcList = [];       
        for(var i=0;i<rec.length;i++){
            var  obj = {sobjectType:'ETT_Job_Card__c',Id:rec[i].value,Pressure_Valve_Number__c:rec[i].pvalve,Voccum_Valve_Number__c:rec[i].vvalve}
            jcList.push(obj);
        }
        helper.updateValveNumbers(component,event,helper,jcList);
     //   component.set("v.selectedValues",null);
       // component.set("v.jobCardList","");
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);//current line, line update is needed/not,work actviity tracker/not,job update needed/not,next line to create, next work activity
    },
    goToStep7 : function(component, event, helper) {
        //helper.getJobList(component, event, helper);
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        var stepError=component.get("v.step_error");
     
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Curing 13 Vacuum Pressure valve Condition and 13 Pressure Cable Condition';
            Nextlineitem.ETT_Type__c='Actual Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            //helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
            helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
        }
    },
    goToStep8 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
     
        var rec = component.get("v.selectedValues");
        if(rec.length <= 0 && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
           var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
              "title": "Error!",
              "type" : "error",
              "message": "Please select job cards"
           });
                toastEvent.fire(); 
            return;
        }
        for(var i=0; i<rec.length; i++){
            for(var j=i+1;j<rec.length;j++){
                if(rec[i].pvalve == rec[j].pvalve || rec[i].vvalve == rec[j].vvalve){
				    var toastEvent = $A.get("e.force:showToast");
           			toastEvent.setParams({
              			"title": "Error!",
		                "type" : "error",
              			"message": "Please select unique valve numbers for each job card"
           			});
               		toastEvent.fire(); 
           			return;               
                }
            }
        }
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Curing Digital Screen Condition';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        var rec = component.get("v.selectedValues");
        var jcList = [];       
        for(var i=0;i<rec.length;i++){
            var  obj = {sobjectType:'ETT_Job_Card__c',Id:rec[i].value,Cable_Pressure_Valve_Number__c:rec[i].pvalve,Cable_Voccume_Valve_Number__c:rec[i].vvalve}
            jcList.push(obj);
        }
        helper.updateValveNumbers(component,event,helper,jcList);
       //  component.set("v.selectedValues",null);
       // component.set("v.jobCardList","");
       // helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
    },
    goToStep9 : function(component, event, helper) {
        
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
       
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        //console.log('line.jobLineItem.Defect__c'+line.jobLineItem.Defect__c);
        if(!line.jobLineItem.ETT_Enter_Reason1__c && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            component.set("v.step_error","Please enter defects");
            return;
        }
        
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Curing Control Panel Board Condition';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
        
    },
    goToStep10 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        //console.log('line.jobLineItem.Defect__c'+line.jobLineItem.Defect__c);
        if(line.jobLineItem.ETT_Enter_Reason1__c == null && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            component.set("v.step_error","Please enter Reason");
            return;
        }
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Curing Chamber Motor Condition';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds); 
    },
    goToStep11 : function(component, event, helper) {
        //helper.getJobList(component, event, helper);
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
         if(line.jobLineItem.ETT_Enter_Reason1__c == null && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            component.set("v.step_error","Please enter Reason");
            return;
        }
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Curing The Gaugs of Pressure And Vacuum';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
        
    },
    goToStep12 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
       	if(!line.jobLineItem.ETT_Enter_Reason1__c && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            component.set("v.step_error","Please enter defects");
            return;
        }
        
        var rec = component.get("v.selectedValues");
        if(rec.length <= 0 && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
           var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
              "title": "Error!",
              "type" : "error",
              "message": "Please select job cards"
           });
                toastEvent.fire(); 
            return;
        }
        for(var i=0; i<rec.length; i++){
            for(var j=i+1;j<rec.length;j++){
                if(rec[i].pvalve == rec[j].pvalve || rec[i].vvalve == rec[j].vvalve){
				    var toastEvent = $A.get("e.force:showToast");
           			toastEvent.setParams({
              			"title": "Error!",
		                "type" : "error",
              			"message": "Please select unique valve numbers for each job card"
           			});
               		toastEvent.fire(); 
           			return;               
                }
            }
        }
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Curing Remove all vacuum and pressure connections from the catridge';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        var rec = component.get("v.selectedValues");
        var jcList = [];       
        for(var i=0;i<rec.length;i++){
            var  obj = {sobjectType:'ETT_Job_Card__c',Id:rec[i].value,Guage_Pressure_Valve_Number__c:rec[i].pvalve,Guage_Voccume_Valve_Number__c :rec[i].vvalve}
            jcList.push(obj);
        }
        helper.updateValveNumbers(component,event,helper,jcList);
        // component.set("v.selectedValues",null);
       // component.set("v.jobCardList","");
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
        
    },
    goToStep13 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Curing Connect the vacuum and pressure pipes to the loaded catridge inside the chamber ';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
    },
    goToStep14 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Check safety lock on';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);

    },
    goToStep15 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
         if (!line.jobLineItem.ETT_Curing_Round_Number__c || !line.jobLineItem.ETT_Curing_Start_Time__c || !line.jobLineItem.ETT_Curing_End_Time__c){
                 /*   helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please Enter Curing Round Number, Curing Start Time and Curing End Time."
                    });
                   // return false;*/
                }  
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Enter Curing round number and choose starting time and end time';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);

    },
    goToStep16 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        if (line.jobLineItem.ETT_Initial_Activity_State__c=='Yes' && (!line.jobLineItem.ETT_Curing_Round_Number__c || !line.jobLineItem.ETT_Curing_Start_Time__c || !line.jobLineItem.ETT_Curing_End_Time__c)){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please Enter Curing Round Number, Curing Start Time and Curing End Time."
                    });
                    return false;
                }  
         if (line.jobLineItem.ETT_Curing_Start_Time__c > line.jobLineItem.ETT_Curing_End_Time__c){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please enter Curing End Time date greter than Curing Start Time Date"
                    });
                    return false;
                }  
        
         if (line.jobLineItem.ETT_Enter_Reason1__c == "" && line.jobLineItem.ETT_Initial_Activity_State__c == "Yes"){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please enter defect reason"
                    });
                    return false;
        } 
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Temperature__c='115';
        Nextlineitem.ETT_Activity_Performed__c='Change in the default Temperature';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);

    },
      myChangeAcc:function(component, event, helper) {
        var line=component.get("v.current_line");
          var dpsctime = component.find("dpctime").get("v.value");
        setTimeout(function()
                       {
                           
                line.jobLineItem.DPC_time__c=true;
                             console.log('line '+line.jobLineItem.DPC_time__c);
                                 }, 3000);
            
    },
  
    goToStep17 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
         if ( !line.jobLineItem.Ett_DPC_time__c || !line.jobLineItem.ETT_Temperature__c){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please Enter Temperature and DPC time "
                    });
                    return false;
                }         
        
        if (!line.jobLineItem.ETT_Enter_Reason1__c && line.jobLineItem.ETT_Initial_Activity_State__c == 'Yes'){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please enter defect reason"
                    });
                    return false;
        } 
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='check lekage';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);

    },
    goToStep18 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        if (!line.jobLineItem.ETT_Enter_Reason1__c  && line.jobLineItem.ETT_Initial_Activity_State__c == "Yes"){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please enter defect reason"
                    });
                    return false;
        } 
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Confirm The Temperture';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);

    },
    goToStep19 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='curing started';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);

    },
    goToStep20 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        if (!line.jobLineItem.Curing_Reasons__c  && line.jobLineItem.ETT_Initial_Activity_State__c == "Yes"){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please enter defect reason"
                    });
                    return false;
        } 
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='check chamber motor condition in 45 mintues';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
         helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);

    },
    goToStep21 : function(component, event, helper) {
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
         if (!line.jobLineItem.ETT_Enter_Reason1__c  && line.jobLineItem.ETT_Initial_Activity_State__c == "No"){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please enter defect reason"
                    });
                    return false;
        } 
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='chamber door is opened?';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);

    },    
    goToStep22: function(component,event,helper){
        try{
        component.set("v.step_error","");
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Stage Check';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        //helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
           helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker,jobCardIds);
        }catch(e){
            console.log(e.message)
        }
    },
    goToStep23: function(component,event,helper){
        try{
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var jobCardIds = component.get("v.jobCardIdsToProcess");
        var step_error=component.get("v.step_error");
        var selectedNextStation=component.get("v.selectedNextStation");
        
       /* if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c) || line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c==""){ 
            component.set("v.step_error","Status is mandatory to end.");
        }*/
       if(line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Accepted' && ($A.util.isUndefinedOrNull(selectedNextStation) || selectedNextStation=="")){ 
            component.set("v.step_error","Next stage should be selected when accepting.");
          
        } 
        else{
                if(line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Initial Rejection'){
                    component.set("v.selectedNextStation","");
                }
                line.jobLineItem.ETT_Status__c='Completed';
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                
                if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Technician_Rejection_Remarks__c)){
                    line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Technician_Rejection_Remarks__c='';
                }
                line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Technician_Rejection_Remarks__c='Version:'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Curing_Technician_Rejection_Remarks__c;//append the technician remarks
                
                //helper.updateJobCardLineItem(component, event, helper,line,true,true,true,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
                 helper.updateMultipleJobCardLineItem(component, event, helper,line,true,true,true,null,null,jobCardIds);

            }
        }catch(e){
            console.log(e.message)
        }
    },
    
    
    handleComponentEvent : function(component, event, helper) {
       
        var jobCardIds = event.getParam("jobCardIds");
        console.log('***********'+JSON.stringify(jobCardIds));
        component.set("v.jobCardIdsToProcess", jobCardIds);
    },
     notifySupervisandhOO: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");   
       // line.jobLineItem.ETT_Status__c='In-Progress'; 
        line.jobLineItem.ETT_Activity_Performed__c='Confirm The Temperture';
        line.jobLineItem.ETT_Notify_HOO__c=true;
        helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    notifySupervisor: function(component, event, helper) {
    	var rec = component.get("v.selectedValues");
        var jcList = []; 
        var line=component.get("v.current_line"); 
        var seq = JSON.stringify(line.jobLineItem.Sequence__c);
        var title = '';
    	if(rec.length <= 0 ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": "Please select jobcard"
             });
             toastEvent.fire();
            return;
        }
        if(seq == '5'){
            title = 'Inflation of Pressure and Vacuum valve Information';
        	for(var i=0;i<rec.length;i++){
              var  obj = {sobjectType:'ETT_Job_Card__c',Id:rec[i].value,Name:rec[i].label,Pressure_Valve_Number__c:rec[i].pvalve,Voccum_Valve_Number__c:rec[i].vvalve}
              jcList.push(obj);
        	}	
        }
        else if(seq == '7'){
            title = '13 Vacuum and Pressure valve Information';
        	for(var i=0;i<rec.length;i++){
             	var  obj = {sobjectType:'ETT_Job_Card__c',Id:rec[i].value,Name:rec[i].label,Cable_Pressure_Valve_Number__c:rec[i].pvalve,Cable_Voccume_Valve_Number__c:rec[i].vvalve}
           	    jcList.push(obj);
        }}
        else if(seq == '11'){
            //alert(line.jobLineItem.ETT_Enter_Reason1__c);
            if(!line.jobLineItem.ETT_Enter_Reason1__c  && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            	component.set("v.step_error","Please enter defects");
            	return;
        		}
           // alert(line.jobLineItem.ETT_Enter_Reason1__c);
             title = 'The Gaugs of Pressure and Vacuum valve Information';
        	 for(var i=0;i<rec.length;i++){
               var  obj = {sobjectType:'ETT_Job_Card__c',Id:rec[i].value,Name:rec[i].label,Guage_Pressure_Valve_Number__c:rec[i].pvalve,Guage_Voccume_Valve_Number__c:rec[i].vvalve}
               jcList.push(obj);
        }
        }
        var action = component.get("c.SupervisorNotification2");
        action.setParams({
            'targetId' :  line.relatedJobWrapper.validJobCardList[0].Id,
            'jobcardValveinfo': JSON.stringify(jcList),
            'sequence' : seq,
            'titl' : title
            
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "type" : "success",
                    "message": "Notification sent successfully."
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
    SupervisorHooNotification3: function(component, event, helper) {
        
         component.set("v.step_error","");
        var line=component.get("v.current_line");   
        line.jobLineItem.ETT_Status__c='In-Progress'; 
        line.jobLineItem.ETT_Notify_HOO__c=true;
        helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "type" : "success",
            "message": "Notification sent successfully."
        });
        toastEvent.fire();
    	/*var line=component.get("v.current_line"); 
      	var action = component.get("c.SupervisorNotification3");
        var seq = JSON.stringify(line.jobLineItem.Sequence__c);
        var msg ='';
        var titl='';
        if(seq== '4'){
           titl ='Door Safety Lock is Ok',
            msg ='Door Safety Lock is Ok'+line.jobLineItem.ETT_Initial_Activity_State__c;
        }
        else if(seq== '8'){
            if(!line.jobLineItem.ETT_Enter_Reason1__c && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
            titl ='Check Digital Screen Condition is Ok',
            msg ='Check Digital Screen Condition is Ok '+line.jobLineItem.Defect__c;
        }
        else if(seq== '9'){
            if(line.jobLineItem.ETT_Enter_Reason1__c == null && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
            titl ='Check Control Panel Board Condition is Ok',
            msg ='Check Control Panel Board Condition is Ok - Reason - '+line.jobLineItem.ETT_Enter_Reason1__c;
        }
        else if(seq== '10'){
            if(line.jobLineItem.ETT_Enter_Reason1__c == null && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
            titl ='Check Control Panel Board Condition is Ok',
            msg ='Check Chamber Motor Condition is Ok - Reason - '+line.jobLineItem.ETT_Enter_Reason1__c;
        }
        else if(seq== '13'){
            if(!line.jobLineItem.ETT_Enter_Reason1__c && line.jobLineItem.ETT_Initial_Activity_State__c == 'No'){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
            titl ='Connect the vacuum and pressure pipes to the loaded catridge inside the chamber as per the job card',
            msg ='Connect the vacuum and pressure pipes to the loaded catridge inside the chamber as per the job card - Reason - '+line.jobLineItem.ETT_Enter_Reason1__c;
        }
         else if(seq== '15'){
            if(line.jobLineItem.ETT_Enter_Reason1__c == null){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
            titl ='If any Change in the default end Time ?',
            msg ='If any Change in the default end Time - Reason - '+line.jobLineItem.ETT_Enter_Reason1__c;
        }
         else if(seq== '16'){
            if(line.jobLineItem.ETT_Enter_Reason1__c == null){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
            titl ='Check Default Temperature',
            msg ='Check Default Temperature - Reason - '+line.jobLineItem.ETT_Enter_Reason1__c;
        }
        else if(seq== '17'){
            if(line.jobLineItem.ETT_Enter_Reason1__c == null){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
            titl ='Check Tube Pressure and Envelop Valve',
            msg ='Check Tube Pressure and Envelop Valve - Reason - '+line.jobLineItem.ETT_Enter_Reason1__c;
        }
         else if(seq== '19'){
          if(!line.jobLineItem.ETT_Enter_Reason1__c){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
            titl ='Is any technical error occure ?',
            msg ='Is any technical error occure -Reason -  '+line.jobLineItem.ETT_Enter_Reason1__c;
        }
         else if(seq== '20'){
          if(!line.jobLineItem.ETT_Enter_Reason1__c){
            	component.set("v.step_error","Please enter Reason");
            	return;
        	}
            titl ='Chamber Condition ',
            msg ='Chamber Condition  -Reason -  '+line.jobLineItem.ETT_Enter_Reason1__c;
        }
         else if(seq== '21'){          
            titl ='chamber door is opened?',
            msg ='chamber door is opened?-  '+line.jobLineItem.ETT_Initial_Activity_State__c;
        }
        
        action.setParams({
            'targetId' :  line.relatedJobWrapper.validJobCardList[0].Id,
            'titl' : titl,
            'message' : msg
            
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "type" : "success",
                    "message": "Notification sent successfully."
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
    */
    },
    
})