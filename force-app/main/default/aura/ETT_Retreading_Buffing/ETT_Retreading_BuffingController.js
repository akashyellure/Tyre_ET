({
    initAction : function(component, event, helper) {       
        
        helper.getJobDetails(component, event, helper,null);
        helper.getStationTools(component, event, helper);
        helper.getDatafromParent(component, event, helper);
        helper.getStageRecordtypeId(component, event, helper);
        var lWidth = window.innerWidth ;//Get the window's width
        //The setInterval() method calls a function or 
        //evaluates an expression at specified intervals (in milliseconds).
        window.setInterval($A.getCallback(function() { 
            helper.shiftDiv(component, event,lWidth);
        } ), 20);
    },
    closeModal : function(component, event, helper) {
        var cmpEvent = component.getEvent("refreshJobCardList"); 
        cmpEvent.fire(); 
        component.set("v.showJobModelView",false);
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
    goToStep2 : function(component, event, helper) {
        try{
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
                        line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Station_Work_Schedule__c=component.get("v.workSheduleInfo.Id");
                        line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician__c= $A.get("$SObjectType.CurrentUser.Id");
                        if(line.workTracker.ETT_Start_time__c==null){
                            line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                        }
                        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');//$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');  
                        
                        //Initialize the next line item for creating this on load on next step to trigger the timer
                        var Nextlineitem=component.get("v.Nextlineitem");
                        Nextlineitem.Id=null;
                        Nextlineitem.ETT_Activity_Performed__c='Buffing - Inflation pressure check';
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
        }catch(e){
            console.log(e.message)
        }
    },
    startFloorCleaning: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    goToStep3 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final Buffer settings to be good condition to proceed Next.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
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
    startLightWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    goToStep4 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final Buffer settings to be good condition to proceed next.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Buffer Settings Check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
    },
    startBufferSettings: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
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
    refreshSection: function(component, event, helper) {
        var newToolReq=JSON.stringify(component.get("v.newToolRequests"));
        if(newToolReq && newToolReq.length >0){
            helper.refreshRequestStatus(component, event, helper);
        }
        else{
            helper.getStationTools(component, event, helper);
        }
    },
    goToStep5 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Correct'){
            if(line.jobLineItem.ETT_Final_Activity_State__c!='Correct'){
                component.set("v.step_error","Please ensure final Status to be good condition to proceed next.");
            }
        }
        var stepError=component.get("v.step_error");
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Buffing Blade Conditions';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
    },
    goToStep6 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var newToolReq=component.get("v.newToolRequests");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good'){
            if(line.jobLineItem.ETT_Final_Activity_State__c!='Good'){
                component.set("v.step_error","Please ensure final Buffer settings to be good condition to proceed next.");
            }
            else if(!line.jobLineItem.ETT_Tool_Material_Request_Raised__c){
                component.set("v.step_error","Please initiate new request and get approved.");
            }
            for(var i in newToolReq){
                if(newToolReq[i].toolAllocation.Allocation_Status__c!='Approved' && newToolReq[i].toolAllocation.Allocation_Status__c!='Rejected'){
                    component.set("v.step_error","Please ensure new request is approved/rejected and tool is available to proceed.");
                    break;
                }
            }
        }
        var stepError=component.get("v.step_error");
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Buffing Sidebuffer Conditions';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
    },
    goToStep7 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var newToolReq=component.get("v.newToolRequests");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good'){
            if(line.jobLineItem.ETT_Final_Activity_State__c!='Good'){
                component.set("v.step_error","Please ensure final buffer settings to be good condition to proceed next.");
            }
            else if(!line.jobLineItem.ETT_Tool_Material_Request_Raised__c){
                component.set("v.step_error","Please initiate new request and get approved.");
            }
            for(var i in newToolReq){
                if(newToolReq[i].toolAllocation.Allocation_Status__c!='Approved' && newToolReq[i].toolAllocation.Allocation_Status__c!='Rejected'){
                    component.set("v.step_error","Please ensure new request is approved/rejected and tool is available to proceed.");
                    break;
                }
            }
        }
        var stepError=component.get("v.step_error");
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Buffing powder replacement check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    startPowderReplacementWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    goToStep8 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Yes' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final status  to be good condition to proceed next.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Buffing Dust Collector Check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    goToStep9: function(component, event, helper) {
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var currentStatus =null;
        if(line.ETT_Status__c=="In-Progress")
        {
            currentStatus = component.find("finalActivityState").get("v.value");
            
        }
        
        
        if(currentStatus == 'Not Good'){
            component.set("v.step_error","Please ensure final status  to be good condition to proceed next.");
            return false;
        }else {
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;        
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            
            if(line.jobLineItem.ETT_Initial_Activity_State__c=='Not Good'){
                line.jobLineItem.ETT_Status__c='In-Progress';
                line.jobLineItem.ETT_Has_dependency__c=true;
                
                Nextlineitem.ETT_Activity_Performed__c='Buffing Dust Collector - Suction line check';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';
                nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            }else{
                line.jobLineItem.ETT_Status__c='Completed';
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                
                Nextlineitem.ETT_Activity_Performed__c='Buffing - Inflation pressure check';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';
                nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            }        
            component.set("v.seq_8_initialState",line.jobLineItem.ETT_Initial_Activity_State__c);
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
            
        }
        
    },
    startSuctionLineWork: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line, next activity
        }
    },
    goToStep10 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final status  to be good condition to proceed next.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Buffing Dust Collector - Suction pipeline capacity check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update,next line, next activity
        }
    },
    goToStep11 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");        
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Low' && line.jobLineItem.ETT_Final_Activity_State__c !='High'){
            component.set("v.step_error","Final dust collector status to be good to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';          
            line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Buffing Dust Collector - Suction filter value check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    goToStep12 : function(component, event, helper) {
        alert('step12')
        try{
            component.set("v.step_error","");
            var line=component.get("v.current_line"); 
            var seq_8_finalState=  'Good';// component.get("v.seq_8_finalState"); 
            
            if(line.jobLineItem.ETT_Initial_Activity_State__c =='Low' && line.jobLineItem.ETT_Final_Activity_State__c !='High'){
                component.set("v.step_error","Please ensure final condition to be high to proceed.");
            }
            else if(seq_8_finalState !='Good'){
                component.set("v.step_error","Please ensure final dust collector suction filter status to be good to proceed.");
            }
                else{
                    line.jobLineItem.ETT_Status__c='Completed';          
                    line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
                    line.jobLineItem.ETT_End_parent_line_item__c=true;
                    line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                    
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Buffing - Inflation pressure check';
                    Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                    Nextlineitem.ETT_Status__c='Not Started';
                    
                    var nextWorkTracker=component.get("v.nextWorkTracker");
                    nextWorkTracker.Id=null;
                    nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
                    
                    helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                }
        }catch(e){
            console.log(e.message)
        }
    },
    startInflationCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    goToStep13 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='No' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final Status to be good condition to proceed next.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Buffing- Rasphub Tyre contact position check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');               
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    startRaspHubCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    goToStep14 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='No' && line.jobLineItem.ETT_Final_Activity_State__c !='Yes'){
            component.set("v.step_error","Please ensure final status  to be good condition to proceed next.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Buffing- Tyre stone check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');  
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    startTyreStoneCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    goToStep15 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Yes' && line.jobLineItem.ETT_Final_Activity_State__c =='Yes'){
            component.set("v.step_error","Please ensure final status  to be good condition to proceed next.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Power Swicth Operation';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');  
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    goToStep16 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        /*if(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Started_Dust_Collection__c!=true || line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_On_Power_Switch__c!=true){
            component.set("v.step_error","Please ensure options selected to proceed.");
        }
        else{*/
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            //Nextlineitem.ETT_Activity_Performed__c='Terms Read';
            Nextlineitem.ETT_Activity_Performed__c='Complaints';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');              
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        //}
    },
    /* goToStep17 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        //var startCheckbox = component.get("v.startCheckbox");
        
        /*if(startCheckbox!=true){
			 component.set("v.step_error","Please ensure options selected to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            //Nextlineitem.ETT_Activity_Performed__c='Buffing - Scan Surface';
            Nextlineitem.ETT_Activity_Performed__c='Terms Read';
            Nextlineitem.ETT_Type__c='Actual Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
             
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        //}
	},
    */
    startScanSurfaceCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep17: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        //var step_error=component.get("v.step_error");
        //if(step_error==null || step_error==""){
        
        var startCheckbox = component.get("v.startCheckbox");
        
        /*if(startCheckbox!=true){
          //  component.set("v.step_error","Please ensure options selected to proceed.");
        }
        else{*/
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        //Nextlineitem.ETT_Activity_Performed__c='Side Crown buffing';
        Nextlineitem.ETT_Activity_Performed__c='Buffing - Scan Surface';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ'); 
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        //  }
    },
    /*goToStep18 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Matched' && line.jobLineItem.ETT_Final_Activity_State__c !='Matched'){
			 component.set("v.step_error","Please ensure final  condition to be matached to proceed.");
        }
        else if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Matched' && line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_precured_tread_line__c==null){
            component.set("v.step_error","Please ensure precured tread selected.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Side Crown buffing';
            Nextlineitem.ETT_Type__c='Actual Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
	},*/
    goToStep18 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Side Crown buffing'; //'Buffing - Tyre Cut Check';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');  
        
        var tyreMaster = component.get("v.tyreMaster"); 
        if(tyreMaster.Id !=null){
            helper.updateTyreDetails(component,event,helper);
            line.relatedJobWrapper.validJobCardList[0].ETT_Tyre_Master__c=tyreMaster.Id;
        }
        helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
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
      
        var line=component.get("v.current_line");
        line.relatedJobWrapper.validJobCardList[0].Buffing_Cuts_Count__c=line.relatedJobWrapper.validJobCardList[0].Buffing_Cuts_Count__c?line.relatedJobWrapper.validJobCardList[0].Buffing_Cuts_Count__c+1:1;
        component.set("v.current_line",line);
    },
    handleOnDecrement: function(component, event, helper){
        var line=component.get("v.current_line");
        if(line.relatedJobWrapper.validJobCardList[0].Buffing_Cuts_Count__c !=0){
            line.relatedJobWrapper.validJobCardList[0].Buffing_Cuts_Count__c = line.relatedJobWrapper.validJobCardList[0].Buffing_Cuts_Count__c-1;
            component.set("v.current_line",line);
        }
    },
    /*goToStep20: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
        
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
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Complaints';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');  
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
    },*/
    goToStep19: function(component,event,helper){
        
        let treadPatt = component.get("v.selectedLookUpRecord");
       var line=component.get("v.current_line");
       let revNum = line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c;
        
        if(treadPatt.Id || revNum > 1){
            component.set("v.step_error","");
           
            var step_error=component.get("v.step_error");
            
            if(step_error==null || step_error==""){
                line.jobLineItem.ETT_Status__c='Completed';
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                if(revNum == 1){
                line.jobLineItem.Desired_Tread_Pattern__c = component.get('v.selectedLookUpRecord.Name');
                line.jobLineItem.Factory_Stock_Units__c = component.get('v.toolsStockAndFactory')[0];
                line.jobLineItem.Main_Stock_Units__c = component.get('v.toolsStockAndFactory')[1];
                
                }
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
            
        }else{
            component.set("v.step_error","Desired Tread Pattern is required."); 
        }
        
        
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
    goToStep20: function(component,event,helper){
        
        
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
        var selectedNextStation=component.get("v.selectedNextStation");
        var technicainRemark = component.get("v.current_line.jobLineItem.ETT_Remarks__c");
        var buffingStatus = component.get('v.current_line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c'); 
        
        if(step_error==null || step_error==""){
            if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c) || line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c==""){ 
                component.set("v.step_error","Status is mandatory to end.");
            }
            else if(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Accepted' && ($A.util.isUndefinedOrNull(selectedNextStation) || selectedNextStation=="")){ 
                component.set("v.step_error","Next stage should be selected when accepting.");
            } 
                else if(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection' &&$A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)){ 
                    component.set("v.step_error","Please enter rejection comments.");
                } 
                    else{
                        if(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection'){
                            component.set("v.selectedNextStation","");
                            if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)){
                                component.set("v.step_error","Please enter rejection comments.");
                                return;
                            }  
                        }
                        line.jobLineItem.ETT_Status__c='Completed';
                        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                        if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c)){
                            line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c='';
                        }
                        if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)){
                            line.jobLineItem.ETT_Remarks__c='';
                        }else{
                            line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c =line.jobLineItem.ETT_Remarks__c;
 
                        }   
                        if(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Accepted') line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Description__c='Version:'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+' :'+line.jobLineItem.ETT_Remarks__c;//+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c;//append the technician remarks
                        else line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c='Version:'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+' :'+line.jobLineItem.ETT_Remarks__c; //+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c;//append the technician remarks
                        line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician__c = $A.get( "$SObjectType.CurrentUser.Id" );
                        helper.updateJobCardLineItem(component, event, helper,line,true,true,true,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
                    }
        }
        
       /* var cmpEvent = component.getEvent("refreshJobCardList"); 
        cmpEvent.fire(); 
        component.set("v.showJobModelView",false);   */     
    },
    showHoldDialog: function(component,event,helper){
        component.set("v.step_error","");
        component.set("v.confirmHoldVar",true);
        component.set("v.usageSection",false);
        component.set("v.openToolsReqSection",false);
    },
    continueActivities: function(component,event,helper){
        component.set("v.step_error","");
        component.set("v.confirmHoldVar",false);
        component.set("v.usageSection",false);
        component.set("v.openToolsReqSection",false);
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
            lineItemForHoldWrapper.jobLineItem.ETT_Revision_Number__c=line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c;
            
            //lineItemForHoldWrapper.workTracker.Id=null;
            lineItemForHoldWrapper.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
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
    backFromUsage: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
        component.set("v.openToolsReqSection",false);
    },
    openUsageTracker: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.usageSection",true);
        component.set("v.confirmHoldVar",false); 
        component.set("v.openToolsReqSection",false);
    },
    openToolsReqSectionOperation: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.openToolsReqSection",true);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
    },
    backFromToolReqPage: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.openToolsReqSection",false);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
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
    
    handleCheckAllBox: function(component, event, helper) {
        component.set('v.isJobDisabled',!event.target.checked);
    }
    
})