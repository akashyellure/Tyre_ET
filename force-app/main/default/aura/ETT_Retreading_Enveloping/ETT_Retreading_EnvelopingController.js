({
    handlecheckbox1: function(component, event, helper){
        let chkd = event.getSource().get("v.checked");
        if(chkd)
            alert("Are you sure Plate and lock on the rim");
    },
    sendEmail: function(component,event,helper ) {
        var action = component.get("c.sentEmailNotification");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let button = event.getSource();
                button.set('v.disabled',true);
                alert('sent email');
            } 
        });
        $A.enqueueAction(action);
    },
    initAction : function(component, event, helper) {        
        helper.getJobDetails(component, event, helper,null);
        helper.getStationTools(component, event, helper);
        helper.getDatafromParent(component, event, helper);
        helper.getStageRecordtypeId(component, event, helper);
        helper.getRimSureLockValues(component, event, helper);
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
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Stage Check';
            Nextlineitem.ETT_Type__c='Actual Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ'); 
            
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
     startJobEnvAppTyre: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    startFloorCleaning: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        // line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=False;
        
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
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
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
            lineItemForHoldWrapper.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
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
            line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            line.workTracker.ETT_End_time__c=null;
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false); //parameter usage: line item, gotoNext step, activity update, job card update 
            
            lineItemForHoldWrapper.ETT_Activity_Performed__c='OnHold';
            lineItemForHoldWrapper.jobLineItem.ETT_Job_Card__c=line.relatedJobWrapper.validJobCardList[0].Id;
            lineItemForHoldWrapper.jobLineItem.ETT_Status__c='Completed';
            lineItemForHoldWrapper.jobLineItem.ETT_Type__c='Pause'; 
            lineItemForHoldWrapper.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ'); 
            helper.updateJobCardLineItemForHold(component, event, helper,lineItemForHoldWrapper); //parameter usage: line item for hold 
        }
        else{
            component.set("v.step_error","No activity has been kept onhold in order to resume.");
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
        var toolsListOptions=component.get("v.toolsListOptions");
        for(var i in toolsListOptions){
            console.log(toolsListOptions[i].toolAllocationDet.Allocation_Status__c);
            if($A.util.isUndefinedOrNull(toolsListOptions[i].toolAllocationDet.Allocation_Status__c) || (toolsListOptions[i].toolAllocationDet.Allocation_Status__c!='Approved' && toolsListOptions[i].toolAllocationDet.Allocation_Status__c!='Almost Used' && toolsListOptions[i].toolAllocationDet.Allocation_Status__c !='Rejected')){
                component.set("v.step_error","Some of the requested tools/consumables are not approved/pending approval. Reach out to Supervisor for assistance.");
                break;
            }
        }
        
        var allowDML = component.get('v.allowDML');
        var step_error=component.get('v.step_error');         
        
        if(allowDML){
            if(step_error==null || step_error==''){
                if (flag && WearRequiredPPT) {
                    var line=component.get("v.current_line");
                    line.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
                    line.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
                    line.jobLineItem.ETT_Status__c='Completed';
                    line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
                    
                    //var workStationSchedule=component.get("v.workStationSchedule");
                    line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Schedule__c=component.get("v.workSheduleInfo.Id");
                    line.relatedJobWrapper.validJobCardList[0].Rimming_Enveloping_Technician__c= $A.get("$SObjectType.CurrentUser.Id");
                    if(line.workTracker.ETT_Start_time__c==null){
                        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                    }
                    line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');  
                    
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Enveloping Build Tyre Condition';
                    Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                    Nextlineitem.ETT_Status__c='Not Started';
                    
                    var nextWorkTracker=component.get("v.nextWorkTracker");
                    nextWorkTracker.Id=null;
                    nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');                    
                    helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker);//current line, line update is needed/not,work actviity tracker/not,job update needed/not,next line to create, next work activity
                }
                else{
                    component.set('v.step_error',"Please complete the options to proceed.");
                }
            }
        }
        else{
            var current_sequence=component.get("v.current_sequence");
            component.set("v.current_sequence",current_sequence+1);
            helper.getJobDetails(component, event, helper);
        } 
        
    },
    goToStep3 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Light Conditions';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },
    goToStep4 : function(component, event, helper) {
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good'){
            if(line.jobLineItem.ETT_Final_Activity_State__c!='Good'){
                component.set("v.step_error","Please ensure Final Light Condition to be good condition to proceed.");
            }
        }
        var stepError=component.get("v.step_error");
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping System Checks';
            Nextlineitem.ETT_Type__c='Actual Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
    },
    goToStep5 : function(component, event, helper) {
        component.set("v.RimOrSureLock","Rim");
        var LiftConditionCheckbox = component.get('v.LiftConditionCheckbox');
        var SpreaderMachineCheckbox = component.get('v.SpreaderMachineCheckbox');  
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
        line.jobLineItem.ETT_Envelop_Lift_Condition__c = LiftConditionCheckbox;
        line.jobLineItem.ETT_Envelop_Spreader_Machine__c = SpreaderMachineCheckbox;
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Enveloping Rim Type';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep6 : function(component, event, helper) {
        //alert("Hii inside 6");
        //alert(component.get("v.RimOrSureLock"));
        component.set("v.step_error","");
        //alert('goToStep6');
        var ETT_Envelop_TyreRimmingMachine__c = component.get("v.ETT_Envelop_TyreRimmingMachine__c");
        var ETT_Envelop_CuringEnvelope__c = component.get("v.ETT_Envelop_CuringEnvelope__c");
        var ETT_Envelop_CuringTube__c = component.get("v.ETT_Envelop_CuringTube__c");
        var ETT_Envelop_RimAndPlate__c = component.get("v.ETT_Envelop_RimAndPlate__c");
        var startCheckbox = component.get("v.startCheckbox");
        console.log('ETT_Envelop_TyreRimmingMachine__c '+ETT_Envelop_TyreRimmingMachine__c);
        console.log('ETT_Envelop_CuringEnvelope__c '+ETT_Envelop_CuringEnvelope__c);
        console.log('ETT_Envelop_CuringTube__c '+ETT_Envelop_CuringTube__c);
        console.log('ETT_Envelop_RimAndPlate__c '+ETT_Envelop_RimAndPlate__c);
        console.log('startCheckbox '+startCheckbox);
        var line=component.get("v.current_line");
        // alert(startCheckbox);
        //alert(ETT_Envelop_TyreRimmingMachine__c);
        console.log(JSON.stringify(line));
        console.log('ETT_Initial_Activity_State__c '+line.jobLineItem.ETT_Initial_Activity_State__c);
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else if(line.jobLineItem.ETT_Initial_Activity_State__c =='Rim'&&(ETT_Envelop_TyreRimmingMachine__c!=true||ETT_Envelop_CuringEnvelope__c!=true||ETT_Envelop_CuringTube__c!=true||ETT_Envelop_RimAndPlate__c!=true)){
            
            component.set("v.step_error","Please select all the check boxes.");  
        }else if(line.jobLineItem.ETT_Initial_Activity_State__c =='Sure Lock'&& startCheckbox!=true){
            component.set("v.step_error","Please select the check box.");
            
        }
            else{
                line.jobLineItem.ETT_Status__c='Completed';
                line.jobLineItem.ETT_Final_Activity_State__c='Good';
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                line.jobLineItem.ETT_Envelop_CuringEnvelope__c = ETT_Envelop_CuringEnvelope__c;
                line.jobLineItem.ETT_Envelop_CuringTube__c = ETT_Envelop_CuringTube__c;
                line.jobLineItem.ETT_Envelop_RimAndPlate__c = ETT_Envelop_RimAndPlate__c;
                line.jobLineItem.ETT_Envelop_TyreRimmingMachine__c = ETT_Envelop_TyreRimmingMachine__c;
                line.jobLineItem.ETT_Rim_Type__c = line.jobLineItem.ETT_Initial_Activity_State__c;
                line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_5_lineId");
                
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Enveloping Build Tyre Condition';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';
                
                var nextWorkTracker=component.get("v.nextWorkTracker");
                nextWorkTracker.Id=null;
                nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
                
                helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
            }
    },
    goToStep7 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Final_Activity_State__c='Good';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
        line.jobLineItem.ETT_NylonWickingPad__c = component.get('v.NylonWickingPad');
        line.jobLineItem.ETT_RubberWickingPad__c = component.get('v.RubberWickingPad');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Enveloping Wicking Pad Application';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        
    },
    goToStep8 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Lube Type';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },
    goToStep999 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            line.jobLineItem.ETT_LubeName__c=component.get("v.lubeName");
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Wicking Pad Application';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },
    goToStep9 : function(component, event, helper) {
       
        component.set("v.step_error","");
        var line=component.get("v.current_line");
       
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_LubeName__c) && line.jobLineItem.ETT_Initial_Activity_State__c == 'Others')
            component.set("v.step_error","Please enter name.");
        
            else{
                line.jobLineItem.ETT_Status__c='Completed';
                line.jobLineItem.ETT_Final_Activity_State__c='Good';
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                //line.jobLineItem.ETT_LubeName__c=component.get("v.lubeName");
                if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_LubeName__c)){
                    line.jobLineItem.ETT_LubeName__c='';
                }
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Enveloping Applied Tyre';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';
                
                var nextWorkTracker=component.get("v.nextWorkTracker");
                nextWorkTracker.Id=null;
                nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
                
                helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
           
           }
    },
    /* goToStep10 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        //console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            line.jobLineItem.ETT_Envelop_Serial_Number__c = component.get('v.Envelop_Serial_Number');
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Wicking Pad Application';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },*/
    goToStep10 : function(component, event, helper) {
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            line.jobLineItem.ETT_ApplyCuringTubeFlap__c = component.get('v.ApplyCuringTubeFlap');
            line.jobLineItem.ETT_ApplyDesiredRimPlate__c = component.get('v.ApplyDesiredRimPlate');
            line.jobLineItem.ETT_ApplyInflationPressure__c = component.get('v.ApplyInflationPressure');
            line.jobLineItem.ETT_ApplyPlateLock__c = component.get('v.ApplyPlateLock');
            // line.jobLineItem.ETT_Initial_Activity_State__c = component.get('v.ETT_Initial_Activity_State__c');
            line.jobLineItem.ETT_Rim_Type__c = component.get('v.RimOrSureLock');
            if(line.jobLineItem.ETT_Initial_Activity_State__c == "Yes")
            {
                if (!line.jobLineItem.ETT_Envelop_Serial_Number__c){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please enter serial number."
                    });
                    return false;
                }   
            }
            
            
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Inflation pressure check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },
    goToStep11 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            line.jobLineItem.ETT_ApplyDesiredRimPlate__c = component.get('v.ApplyDesiredRimPlate');
            if(line.jobLineItem.ETT_Initial_Activity_State__c =='No')
            {
                line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c = false;
            }
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Vaccum';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },
    goToStep12 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else if (line.jobLineItem.ETT_Initial_Activity_State__c == 'No' && line.jobLineItem.ETT_Enter_Final_Status__c =='No'){
            component.set("v.step_error","Please ensure final status to be yes to proceed.");
        }
            else{
                
                line.jobLineItem.ETT_Status__c='Completed';
                line.jobLineItem.ETT_Final_Activity_State__c='Good';
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                // if(line.jobLineItem.ETT_Initial_Activity_State__c =='No')
                //{
                //  line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c = false;
                //}
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Enveloping Pressure';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';
                
                var nextWorkTracker=component.get("v.nextWorkTracker");
                nextWorkTracker.Id=null;
                nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
                
                helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
            }
    },
    goToStep13 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Chamber';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },
    /* goToStep14 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            line.jobLineItem.Selected_RIM_Material_Master__c=component.get('v.selectedLookUpRecord.ETT_Unique_Code__c');
            if (!line.jobLineItem.Selected_RIM_Material_Master__c){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please Select Rim Material Master."
                    });
                    return false;
                }
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Wicking Pad Application';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    }, */
    goToStep14 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        //  alert(line.jobLineItem.ETT_Initial_Activity_State__c);
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        
        
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            line.jobLineItem.ETT_ApplyOnCatrige__c = component.get('v.ApplyOnCatrige');
            line.jobLineItem.ETT_ApplyOnMonorail__c	 = component.get('v.ApplyOnMonorail');
            // alert(line.jobLineItem.ETT_ApplyOnCatrige__c );
            //alert(line.jobLineItem.ETT_ApplyOnMonorail__c);
            if(line.jobLineItem.ETT_Initial_Activity_State__c == "Chamber 1")
            {
                if (!line.jobLineItem.ETT_ApplyOnCatrige__c){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please check checkbox."
                    });
                    return false;
                }   
            }
            else if(line.jobLineItem.ETT_Initial_Activity_State__c == "Chamber 2")
            {
                if(!line.jobLineItem.ETT_ApplyOnMonorail__c){
                    helper.showErrorToast({
                        "title": "Required: ",
                        "type": "error",
                        "message": "Please check checkbox."
                    });
                    return false;
                } 
            }
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Hang the tyre';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },
    goToStep15 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            //line.jobLineItem.ETT_Envelop_Pressure__c = line.jobLineItem.ETT_Final_Activity_State__c;
            //line.jobLineItem.ETT_Envelop_Vacuume__c = line.jobLineItem.ETT_Final_Activity_State__c;
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Vaccume gage';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            console.log('Activity state '+line.jobLineItem.ETT_Initial_Activity_State__c);
            component.set("v.sureLockVaccumSelected",line.jobLineItem.ETT_Initial_Activity_State__c);
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },
    goToStep16 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        } 
        else if (line.jobLineItem.ETT_Initial_Activity_State__c == 'No' && line.jobLineItem.ETT_Enter_Final_Status__c =='No'){
            component.set("v.step_error","Please ensure final status to be yes to proceed.");
        }
            else{
                line.jobLineItem.ETT_Status__c='Completed';
                line.jobLineItem.ETT_Final_Activity_State__c='Good';
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                if(line.jobLineItem.ETT_Initial_Activity_State__c == "Others")
                {
                    if (!line.jobLineItem.ETT_LubeName__c){
                        helper.showErrorToast({
                            "title": "Required: ",
                            "type": "error",
                            "message": "Please enter other reason."
                        });
                        return false;
                    }   
                }
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Enveloping Pressure and Vaccum gage';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';
                
                console.log('Activity state '+line.jobLineItem.Vacuum_Valve__c);
            	component.set("v.sureLockVaccumSelected",line.jobLineItem.Vacuum_Valve__c);
                
                var nextWorkTracker=component.get("v.nextWorkTracker");
                nextWorkTracker.Id=null;
                nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
                
                helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
            }
    },
    goToStep17 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Pressure/Vaccum';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            component.set("v.seq_17_initialState",line.jobLineItem.ETT_Initial_Activity_State__c);
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },   
    goToStep18 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Applied Tyre';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },  
    goToStep19 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var rimsurelockvalue=component.get("v.RimOrSureLock");
        if(rimsurelockvalue=='Rim'&&$A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)&&line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection')
        {
            component.set("v.step_error","Please enter remark.");
            return false;    
        }
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            line.jobLineItem.ETT_Has_dependency__c=false;
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Chamber 1';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            console.log('Activity state '+line.jobLineItem.Vacuum_Valve__c);
            component.set("v.sureLockVaccumSelected",line.jobLineItem.Vacuum_Valve__c);
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },
    goToStep20 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        console.log(JSON.stringify(line));
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final floor condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Enveloping Rimming and Envloping status';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        }
    },  
    goToStep21: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
        var selectedNextStation=component.get("v.selectedNextStation");
        
        if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) || line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c==""){ 
            component.set("v.step_error","Status is mandatory to end.");
        }
        else if(line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' && ($A.util.isUndefinedOrNull(selectedNextStation) || selectedNextStation=="")){ 
            component.set("v.step_error","Next stage should be selected when accepting.");
        } 
        
            else{
                if(line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection'){
                    component.set("v.selectedNextStation","");
                     if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c))
                    {
                        component.set("v.step_error","Please enter remark.");
                        return false;  
                    }
                }
                
                line.jobLineItem.ETT_Status__c='Completed';
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                
                if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Technician_Reject_Remark__c)){
                    line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Technician_Reject_Remark__c='';
                }
                line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Technician_Reject_Remark__c='Version:'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Technician_Reject_Remark__c;//append the technician remarks
                if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)){
                    line.jobLineItem.ETT_Remarks__c='';
                }
                
                helper.updateJobCardLineItem(component, event, helper,line,true,true,true,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
            }
    },
    SendRequest: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");   
        // line.jobLineItem.ETT_Status__c='In-Progress'; 
        line.jobLineItem.ETT_Has_dependency__c=true;
        helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    notifySupersandhO: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");   
        if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Enter_Reason1__c))
            component.set("v.step_error","Please enter reason.");
        
        line.jobLineItem.ETT_Status__c='In-Progress'; 
        line.jobLineItem.ETT_Notify_HOO__c=true;
        helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    notifySupervisandhOO: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");   
        // line.jobLineItem.ETT_Status__c='In-Progress';
         var reason = line.jobLineItem.ETT_Enter_Reason2__c;
        var reson = line.jobLineItem.ETT_Enter_Reason1__c;
         if(!reason&& reson == 'Others')
         {
            component.set('v.step_error',"Please enter Reason."); 
             return false;
         } 
        line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=true;
        helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    notifyhOO: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");   
        // line.jobLineItem.ETT_Status__c='In-Progress'; 
        //line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=false;
        line.jobLineItem.ETT_Notify_HOO__c=true;
        helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    changeRimSureLockValue : function(component, event, helper) {
        var line=component.get("v.current_line");  
        component.set("v.RimOrSureLock",line.jobLineItem.Rim_Sure_Lock_Values__c);
    },
})