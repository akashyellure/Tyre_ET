({
    initAction : function(component, event, helper) {        
        helper.getJobDetails(component, event, helper,null);
        helper.getStationTools(component, event, helper);
        helper.getDatafromParent(component, event, helper);
        helper.getStageRecordtypeId(component, event, helper);
        helper.getDesiredLengthAndWidth(component, event, helper);
    },
    closeModal : function(component, event, helper) {
        var cmpEvent = component.getEvent("refreshJobCardList"); 
        cmpEvent.fire(); 
        component.set("v.showJobModelView",false);
    },
  
   notifyBellSupervisandhOO: function(component, event, helper){
    
        var action = component.get("c.SupervisorNotification");
        action.setParams({
            'targetId': component.get('v.current_line.jobLineItem.Id'),
            'reason': component.get('v.current_line.jobLineItem.ETT_Enter_Reason1__c'),
            'strResponse': component.get('v.current_line.jobLineItem.ReturnReject__c')
        });
      
        action.setCallback(this, function(response) {     
            console.log()
            if (response.getState() == "SUCCESS") {
             
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "type" : "success",
                    "message": "Notification sent"
                });
                toastEvent.fire(); 
            }
            else{
               
                var errors = response.getError();
                console.log(errors)
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
    /*startFloorCleaning: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },*/
    
    startFloorCleaning: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Crown_condition__c=  line.jobLineItem.ETT_Initial_Activity_State__c == 'Yes' ? true :false;
        /* if(line.jobLineItem.Sequence__c==5&& !line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c&&(line.jobLineItem.ETT_Initial_Activity_State__c=="No"))
        {
           var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please provide Actual Tyre Size and Click On 'Notify Supervisor and HOO'."
                });
                toastEvent.fire();
            return false;
        }
        else if(line.jobLineItem.Sequence__c==6&& !line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c&&(line.jobLineItem.ETT_Initial_Activity_State__c=="No"))
        {
           var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please provide Actual Tyre Pattern and Click On 'Notify Supervisor and HOO'."
                });
                toastEvent.fire();
            return false;
        }
        else if(line.jobLineItem.Sequence__c==7&& !line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c&&(line.jobLineItem.ETT_Initial_Activity_State__c=="No"))
        {
           var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please provide Actual Tyre Length & Width and Click On 'Notify Supervisor and HOO'."
                });
                toastEvent.fire();
            return false;
        }*/
         		
        line.jobLineItem.ETT_Status__c='In-Progress';
        line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=true;
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
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
    startPowderReplacementWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
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
    startRaspHubCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
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
    startTyreStoneCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    startScanSurfaceCheck: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,true,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
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
    showHoldDialog: function(component,event,helper){
        component.set("v.step_error","");
        component.set("v.confirmHoldVar",true);
        component.set("v.usageSection",false);
        component.set("v.openToolsReqSection",false);
    },
     notifySupervisor: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");   
        line.jobLineItem.ETT_Status__c='In-Progress'; 
        line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=true;
        
        helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    notifySupervisandhOO: function(component, event, helper) {
        var OldtyreSizeName = component.get("v.TyreSizeFromIc");
        var OldtyreSizeId = component.get("v.TyreSizeFromIcId");
        var NewTyreSizeName = component.get("v.ActualTyreSize");
        var jcId = component.get("v.recordId");
        var NewTyreSizeId = null;
        var OldtyrePatternName = component.get("v.TyrePatternFromIc");
        var OldtyrePatternId = component.get("v.TyrePatternFromIcId");
        var NewTyrePatternName = component.get("v.ActualTyrePattern");
       var NewTyrePatternId = null;
         
        
        if(NewTyreSizeName)
        {
             var action = component.get("c.updateNewTyreSize");
        action.setParams({
            'JCId': component.get("v.recordId"),
            'OldtyreSizeId': OldtyreSizeId,
            'NewTyreSizeName': NewTyreSizeName,
            
        });
        
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
                NewTyreSizeId =  response.getReturnValue();
            
                component.set("v.step_error","");
                var line=component.get("v.current_line");   
                line.jobLineItem.ETT_Status__c='In-Progress'; 
                if(NewTyreSizeId!=null)
                {
                    line.jobLineItem.ETT_Old_Tyre_Size_Name__c=OldtyreSizeName; 
                    line.jobLineItem.ETT_Actual_tyre_Size_Name__c=NewTyreSizeName;
                }
                 
                line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=true;
                helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
            	  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "type" : "success",
                    "message": "Notification sent"
                });
                toastEvent.fire(); 
            }
            else
            {
                 var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to Update Tyre Details and Send Notification."
                });
                toastEvent.fire(); 
            }
           
        });
        $A.enqueueAction(action); 
          }
        
          else
          {
              //  var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please enter new Tyre Size to Send notification."
                });
                toastEvent.fire(); 
          }

        
            },
    notifySupervisandhOO1: function(component, event, helper) {
        var jcId = component.get("v.recordId");
        var OldtyrePatternName = component.get("v.TyrePatternFromIc");
        var OldtyrePatternId = component.get("v.TyrePatternFromIcId");
        var NewTyrePatternName = component.get("v.ActualTyrePattern");
        var NewTyrePatternId = null;
		        
        if(NewTyrePatternName)
        {
             
            var action = component.get("c.updateNewTyrePattern");
            action.setParams({
                'JCId': component.get("v.recordId"),
                'OldtyrePatternId': OldtyrePatternId,
                'NewTyrePatternName': NewTyrePatternName,
                
            });
            
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
              
                NewTyrePatternId = response.getReturnValue();
                //alert(response.getReturnValue());
                component.set("v.step_error","");
                var line=component.get("v.current_line");
               // alert(line);
                line.jobLineItem.ETT_Status__c='In-Progress'; 
                if(NewTyrePatternId!=null)
                {
                    line.jobLineItem.ETT_Old_Tyre_Pattern__c=OldtyrePatternName; 
                    line.jobLineItem.ETT_Actual_Tyre_Pattern__c=NewTyrePatternName;
                }
                 
                line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=true;
                helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "type" : "success",
                    "message": "Notification sent"
                });
                toastEvent.fire(); 
            }
            else
            {
              
                 //var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to Update Tyre Pattern and Send Notification."
                });
                toastEvent.fire(); 
            }
           
        });
        $A.enqueueAction(action); 
          }
           else
          {
               // var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please enter new Tyre Patttern to Send notification."
                });
                toastEvent.fire(); 
          }
        
            },
 notifySupervisandhOO2: function(component, event, helper) {
     var DesiredLength = component.get("v.DesiredLength");
     var DesiredWidth = component.get("v.DesiredWidth");
     var ActualTreadLength  = component.get("v.ActualThreadLength");
     var ActualThreadWidth = component.get("v.ActualThreadWidth");
    
     if(!ActualTreadLength){
         var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please enter new Tyre Length to Send notification."
                });
                toastEvent.fire(); 
         return false;
          }
      else if(!ActualThreadWidth){
          
          var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please enter new Tyre Width to Send notification."
                });
                toastEvent.fire(); 
          return false;
          }
     component.set("v.step_error","");
     var line=component.get("v.current_line");
     //line.jobLineItem.ETT_Actual_Tread_Width__c=ActualThreadWidth;
     //line.jobLineItem.ETT_Actual_Tread_Length__c=ActualTreadLength;
     line.jobLineItem.ETT_Desired_Length__c=DesiredLength;
     line.jobLineItem.ETT_Desired_Width__c=DesiredWidth;
     line.jobLineItem.ETT_Status__c='In-Progress'; 
     line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=true;
     helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    
         var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "type" : "success",
                    "message": "Notification sent"
                });
                toastEvent.fire(); 
            
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
                    line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Work_Schedule__c=component.get("v.workSheduleInfo.Id");
                    line.relatedJobWrapper.validJobCardList[0].ETT_Final_inspection_technician__c= $A.get("$SObjectType.CurrentUser.Id");
                    if(line.workTracker.ETT_Start_time__c==null){
                        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                    }
                    line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
                    
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Tyre Size';
                    Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                    Nextlineitem.ETT_Status__c='Not Started';
                    
                    var nextWorkTracker=component.get("v.nextWorkTracker");
                    nextWorkTracker.Id=null;
                    nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');                    
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
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Spreader Light Conditions';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker);
        
    },
    goToStep4 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Tyre Lift';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        
    },
   goToStep5 : function(component, event, helper) {
         
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var stepError=component.get("v.step_error");
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Tyre Size';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
    },
    goToStep6 : function(component, event, helper) {
        var action = component.get("c.getDesiredlengthSize");
            action.setParams({ "JCId" : component.get("v.recordId") }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
          
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(result);
               
                    if(result!=''&&result!=null){
                   component.set("v.DesiredLength",result.ETT_Desired_Length__c);
                        //component.set("v.TyreBrandFromIc",result.ETT_Inspection_Card__r.ETT_Brand__r.Name);
                        component.set("v.DesiredWidth",result.ETT_Desired_Width__c);
 }
                    
            }}  );     
         $A.enqueueAction(action);
 
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        if( !line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c&&(line.jobLineItem.ETT_Initial_Activity_State__c=="No"))
        {
           var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please provide Actual size and Click On 'Notify Supervisor and HOO'."
                });
                toastEvent.fire();
            return false;
        }
        var newToolReq=component.get("v.newToolRequests");
        
        var stepError=component.get("v.step_error");
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Tyre Pattern';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
    },
    goToStep7 : function(component, event, helper) {
               component.set("v.step_error","");
        var line=component.get("v.current_line");
                if( !line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c&&(line.jobLineItem.ETT_Initial_Activity_State__c=="No"))
        {
           var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please provide Actual Pattern and Click On 'Notify Supervisor and HOO'."
                });
                toastEvent.fire();
            return false;
        }
        var newToolReq=component.get("v.newToolRequests");
        var stepError=component.get("v.step_error");
        
        if($A.util.isUndefinedOrNull(stepError) || stepError==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            //Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Precure Tread Size';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    goToStep8 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
                if( !line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c&&(line.jobLineItem.ETT_Initial_Activity_State__c=="No"))
        {
           var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please provide Actual Length & Width and Click On 'Notify Supervisor and HOO'."
                });
                toastEvent.fire();
            return false;
        }
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
            component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Crown Condition';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
    },
    goToStep9: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            Nextlineitem.ETT_Initial_Activity_State__c='Yes';
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Side Wall';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        component.set("v.seq_8_initialState",line.jobLineItem.ETT_Initial_Activity_State__c);
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
    },
    goToStep10 : function(component, event, helper) {
        component.set("v.step_error","");
     
        var line=component.get("v.current_line");
        component.set('v.isSideWallOk', line.jobLineItem.ETT_Initial_Activity_State__c);
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.ETT_Initial_Activity_State__c = line.jobLineItem.ETT_Initial_Activity_State__c;
        
        var isSideWallOk = component.get("v.isSideWallOk");
       
        if(isSideWallOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;  
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Any Poor Repair';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';  
            component.set("v.Nxt_sequence",6.1);
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is thread area ok';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            component.set("v.Nxt_sequence",7);
        }
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update,next line, next activity
        
    },
    goToStep11 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");    
     
        /*component.set("v.isThreadAreaOk", line.jobLineItem.ETT_Initial_Activity_State__c);
      
         line.jobLineItem.ETT_Status__c='Completed';          
            line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Tyre Interior OK';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   */
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var isSideWallOk = component.get("v.isSideWallOk");
        if(isSideWallOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Any Curing Mark';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';  
            component.set("v.Nxt_sequence",6.2);
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Tyre Interior OK';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        }
		
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
       
    },
    submitForReturnReject : function(component, event, helper) {
        let nxtStn = component.get("v.selectedNextStation");
        let actVal = component.get("v.actionValue");
       
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(!line.jobLineItem.ETT_Remarks__c){
            
            component.set("v.step_error","Please enter remarks");            
        }else if(actVal == 'Return'){
            if(nxtStn){
              line.relatedJobWrapper.validJobCardList[0].Quality_control_Tech__c='Version:'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Quality_Control_Revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].Quality_control_Tech__c?line.relatedJobWrapper.validJobCardList[0].Quality_control_Tech__c:'';//append the technician remarks

              helper.reportDefectsAndUpdateStations(component,event,helper);
            }else{
               component.set("v.step_error","Please Choose Station to return"); 
            }

        }else{
            
            line.jobLineItem.ETT_Status__c='Completed';
            line.relatedJobWrapper.validJobCardList[0].ETT_Quality_Check_Status__c='Initial Rejection';
            
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                       
            line.relatedJobWrapper.validJobCardList[0].Quality_control_Tech__c='Version:'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Quality_Control_Revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].Quality_control_Tech__c?line.relatedJobWrapper.validJobCardList[0].Quality_control_Tech__c:'';//append the technician remarks
            
          helper.updateJobCardLineItem(component, event, helper,line,true,true,true,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
           component.set("v.closeAndRefresh",true);
        } 
        
        if(component.get("v.closeAndRefresh")){
            var cmpEvent = component.getEvent("refreshJobCardList"); 
            cmpEvent.fire(); 
            component.set("v.showJobModelView",false);
        }
     
    },
    goToStep12 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        /* component.set("v.isTyreInteriorOk",line.jobLineItem.ETT_Initial_Activity_State__c);
                       
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Tyre Bead Area ok';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';*/
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        var isSideWallOk = component.get("v.isSideWallOk");
        if(isSideWallOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Wicking Pad Mark Visible';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';      
            component.set("v.Nxt_sequence",6.3);
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Tyre Bead Area OK';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        }
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep13 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        //component.set("v.isBeadAreaOk",line.jobLineItem.ETT_Initial_Activity_State__c);
                       
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            /*var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check ET sticker is clearly displayed on the sidewall';//Final Inspection Check correct labelling location';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';*/
        
        var isSideWallOk = component.get("v.isSideWallOk");
        if(isSideWallOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Shoulde Strip Overflow Mark';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';   
            component.set("v.Nxt_sequence",6.4);
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Correct Labelling Location';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        }
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');               
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep14 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        component.set("v.isETStickerOk",line.jobLineItem.ETT_Initial_Activity_State__c);

        
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            /*var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check ET sticker is clearly displayed on the sidewall';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';*/
        
        var isSideWallOk = component.get("v.isSideWallOk");
        if(isSideWallOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Buff off any excessive sidewall repair rubber flash';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';   
             component.set("v.Nxt_sequence",6.5);
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check ET sticker is clearly displayed on the sidewall';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        }
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep15 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            /*var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Stage Check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';*/
        
        line.relatedJobWrapper.validJobCardList[0].ETT_Quality_Check_Status ='Accepted';
        
        var isSideWallOk = component.get("v.isSideWallOk");
        if(isSideWallOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is there any other default';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';  
            component.set("v.Nxt_sequence",6.6);
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Painting Check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';  
            
        }
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep16 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            component.set('v.isThreadAreaOk',line.jobLineItem.ETT_Initial_Activity_State__c);
            component.set("v.Nxt_sequence",7);
            var isThreadAreaOk = component.get("v.isThreadAreaOk");
            //alert(isThreadAreaOk)
            if(isThreadAreaOk=='No'){
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is thread area ok';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started'; 
               
            }else{
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Tyre Interior OK';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started'; 
                component.set("v.Nxt_sequence",8);
            }
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');              
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep17 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            component.set("v.isThreadAreaOk",line.jobLineItem.ETT_Initial_Activity_State__c);
            var isThreadAreaOk = component.get("v.isThreadAreaOk");
            if(isThreadAreaOk=='No'){
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any open/defective splice';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';   
                component.set("v.Nxt_sequence",7.1);
            }else{
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Bubbles,Blister/Crack';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';
                component.set("v.Nxt_sequence",8);            
            }
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
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
                line.jobLineItem.ETT_Status__c='Completed';
                line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                
                //Initialize the next line item for creating this on load on next step to trigger the timer
                /*var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Side Crown buffing';
                Nextlineitem.ETT_Type__c='Actual Work';
                Nextlineitem.ETT_Status__c='Not Started';*/
                
                var isThreadAreaOk = component.get("v.isThreadAreaOk");
                if(isThreadAreaOk=='No'){
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Tread centering or snaking';
                    Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                    Nextlineitem.ETT_Status__c='Not Started';    
                     component.set("v.Nxt_sequence",7.2);
                }else{
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Any Loose/Incorrect Repair Unit';
                    Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                    Nextlineitem.ETT_Status__c='Not Started';            
                }
                
                var nextWorkTracker=component.get("v.nextWorkTracker");
                nextWorkTracker.Id=null;
                nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
                
                helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
            }
    },
    goToStep19 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        /*var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Complaints'; //'Buffing - Tyre Cut Check';
        Nextlineitem.ETT_Type__c='Actual Work';
        Nextlineitem.ETT_Status__c='Not Started';*/
        
        var isThreadAreaOk = component.get("v.isThreadAreaOk");
        if(isThreadAreaOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Liner bulge/Separation';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';    
             component.set("v.Nxt_sequence",7.3);
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any missed nail hole repair';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        }
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
        
        var tyreMaster = component.get("v.tyreMaster"); 
        if(tyreMaster.Id !=null){
            helper.updateTyreDetails(component,event,helper);
            line.relatedJobWrapper.validJobCardList[0].ETT_Tyre_Master__c=tyreMaster.Id;
        }
        helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
    },
    goToStep20: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
        
        if(step_error==null || step_error==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            /*var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Stage Check';
            Nextlineitem.ETT_Type__c='Actual Work';
            Nextlineitem.ETT_Status__c='Not Started';*/
            
            var isThreadAreaOk = component.get("v.isThreadAreaOk");
            if(isThreadAreaOk=='No'){
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any poor rubber flow at tread shoulder edges';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';  
                 component.set("v.Nxt_sequence",7.4);
            }else{
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Inner Line Bulge';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';            
            }
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ'); 
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep21: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
       //var selectedNextStation=component.get("v.selectedNextStation");
        
        if(step_error==null || step_error==""){
                    /*if(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection'){
                        component.set("v.selectedNextStation","");
                        
                    }*/
                    line.jobLineItem.ETT_Status__c='Completed';
                    line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                    /*if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c)){
                        line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c='';
                    }
                    if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)){
                        line.jobLineItem.ETT_Remarks__c='';
                    }   
                    line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c='Version:'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Technician_Rejection_Remarks__c;//append the technician remarks
                   var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Stage Check';
            Nextlineitem.ETT_Type__c='Actual Work';
            Nextlineitem.ETT_Status__c='Not Started';*/
            
            var isThreadAreaOk = component.get("v.isThreadAreaOk");
            if(isThreadAreaOk=='No'){
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is there any other default';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';  
                component.set("v.Nxt_sequence",7.5);
            }else{
                //Initialize the next line item for creating this on load on next step to trigger the timer
                var Nextlineitem=component.get("v.Nextlineitem");
                Nextlineitem.Id=null;
                Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any ply Separation for Bias Tyre';
                Nextlineitem.ETT_Type__c='Pre-Requisite Work';
                Nextlineitem.ETT_Status__c='Not Started';            
            }
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ'); 
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        
           // helper.updateJobCardLineItem(component, event, helper,line,true,true,true,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
                
        }
    },
    goToStep22 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Tyre Bead Area ok';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep22_BA : function(component, event, helper) { //Created by Janardhan
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
        
        if(step_error==null || step_error==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
            
             var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Tyre Bead Area OK';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started'; 
              component.set("v.Nxt_sequence",9);
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ'); 
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        
        }
    },
    goToStep22_TyreInt : function(component, event, helper) {//Created By Janardhan
         component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //var isTyreInteriorOk = component.get("v.isTyreInteriorOk");
      
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Tyre Interior OK';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';  
            component.set("v.Nxt_sequence",8);
      
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep23_Bubb : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        component.set("v.Nxt_sequence",8.1);  
      
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Bubbles,Blister/Crack';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
			component.set("v.Nxt_sequence",8.1);            
        
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep23 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check correct labelling location';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep13_LabelLoc : function(component, event, helper) {
        
         component.set("v.step_error","");
        var line=component.get("v.current_line");
        
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                 
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check Correct Labelling Location';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
            component.set("v.Nxt_sequence",10);
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');               
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep14_TransSticker : function(component, event, helper) {
        
          component.set("v.step_error","");
        var line=component.get("v.current_line");
       component.set("v.isETStickerOk",line.jobLineItem.ETT_Initial_Activity_State__c);        
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
       
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check ET sticker is clearly displayed on the sidewall';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
            component.set("v.Nxt_sequence",11);
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep15_PaintCheck :function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
           
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
           line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c ='Accepted';
        
                  //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Stage Check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';  
         	component.set("v.Nxt_sequence",12);
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep15_FinalStage :function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
           line.relatedJobWrapper.validJobCardList[0].ETT_Quality_Check_Status ='Accepted';
        
                  //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Stage Check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';  
          component.set("v.Nxt_sequence",13);
         
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep22_PoorRepair: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='Completed';
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
        line.jobLineItem.ETT_Initial_Activity_State__c = line.jobLineItem.ETT_Initial_Activity_State__c;
        component.set("v.isBeadAreaOk",line.jobLineItem.ETT_Initial_Activity_State__c);
       
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;           
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Any Poor Repair';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
          component.set("v.Nxt_sequence",9.1);
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update,next line, next activity
        
    },
    goToStep24_BeadWire : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
       
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Bead Wire Visible default';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
         component.set("v.Nxt_sequence",9.2); 
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep24 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        /*var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Bead Wire Visible default';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';*/
        
        var isTyreInteriorOk = component.get("v.isTyreInteriorOk");
        if(isTyreInteriorOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is Any Loose/Incorrect Repair Unit';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';  
            component.set("v.Nxt_sequence",8.2);    
            
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Bead Wire Visible default';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        }
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep25_BeadOverHeat : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
           //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any overheated bead area default';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started'; 
           component.set("v.Nxt_sequence",9.3);   
      
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep25 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        /*var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any overheated bead area default';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';*/
        
        var isTyreInteriorOk = component.get("v.isTyreInteriorOk");
        if(isTyreInteriorOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any missed nail hole repair';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            component.set("v.Nxt_sequence",8.3);    
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any overheated bead area default';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        }
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep26_TearMount2:function(component, event, helper) {
        
         component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
              
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Tearing Mount/Dismount Damage';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
           component.set("v.Nxt_sequence",9.4);
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep26 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        /*var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Tearing Mount/Dismount Damage';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';*/
        
        var isTyreInteriorOk = component.get("v.isTyreInteriorOk");
        if(isTyreInteriorOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Inner Line Bulge';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';   
            component.set("v.Nxt_sequence",8.4);
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Tearing Mount/Dismount Damage';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        }
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep26_IsAnyDef2 :function(component, event, helper) {
         component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
        
       
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is there any other default';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
            component.set("v.Nxt_sequence",9.5);
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
      
    },
    goToStep27 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        /*var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any any other default';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';*/
        
        var isTyreInteriorOk = component.get("v.isTyreInteriorOk");
        if(isTyreInteriorOk=='No'){
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any ply Separation for Bias Tyre';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';    
             component.set("v.Nxt_sequence",8.5);
        }else{
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any any other default';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        }
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep28_INLiner : function(component, event, helper) { //Created by Janardhan
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
       
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Inner Line Cracking';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
        component.set("v.Nxt_sequence",8.6);
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
        
    },
    goToStep28_PulledCords : function(component, event, helper) { //Created by Janardhan
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
       
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Pulled/Loose Cords';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
          component.set("v.Nxt_sequence",8.7);
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
        
    },
    goToStep26_TearMount:function(component, event, helper) {
        
         component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
              
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any Tearing Mount/Dismount Damage';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
           component.set("v.Nxt_sequence",8.8);
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep26_IsAnyDef :function(component, event, helper) {
         component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');
        
       
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is there any other default';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';            
            component.set("v.Nxt_sequence",8.9);
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
      
    },
    goToStep28 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Is any poor repair';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep29 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Check ET sticker is clearly displayed on the sidewall';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep30 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line"); 
        var seq_8_finalState=component.get("v.seq_8_finalState"); 
        
        line.jobLineItem.ETT_Status__c='Completed';          
        line.jobLineItem.ETT_Linked_Job_Card_Line_Item__c=component.get("v.seq_8_lineId");
        line.jobLineItem.ETT_End_parent_line_item__c=true;
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Final Inspection Status';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        
    },
    goToStep31: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
        var selectedNextStation=component.get("v.selectedNextStation");
        
        if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c) || line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c==""){ 
            component.set("v.step_error","Status is mandatory to end.");
        }
        else if(line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted' && ($A.util.isUndefinedOrNull(selectedNextStation) || selectedNextStation=="")){ 
            component.set("v.step_error","Next stage should be selected when accepting.");
        }else{
            if(line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Initial Rejection'){
                component.set("v.selectedNextStation","");
                
                    if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)){
                        component.set("v.step_error","Please enter rejection comments.");
                        return;
                    }
            }
            component.set("v.selectedNextStation","");
            component.set("v.Nxt_sequence",13);
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Technician_Remarks__c)){
                line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Technician_Remarks__c='';
            }else{
            	line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Technician_Remarks__c='Version:'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Technician_Remarks__c;//append the technician remarks
            }
            line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c? (line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1) : 1;
            if(line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted'){
                //added below line bcz it is not updating from apex cls
                line.relatedJobWrapper.validJobCardList[0].ETT_Overall_Status__c='Accepted';
            }
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
   	
    onSideWallChange : function(component,event,helper){
         var line=component.get("v.current_line");
         component.set('v.isSideWallOk', line.jobLineItem.ETT_Initial_Activity_State__c);
    },
    openDefectSection :function(component,event,helper){
       
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
            if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Technician_Remarks__c)){
                line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Technician_Remarks__c='';
            }
            if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)){
                line.jobLineItem.ETT_Remarks__c='';
            }   
            line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Technician_Remarks__c='Version(Defect found):'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Technician_Remarks__c;//append the technician remarks
            helper.reportDefectsAndUpdateStations(component,event,helper);
        }
    },
})