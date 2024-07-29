({
	initAction : function(component, event, helper) {
        
        helper.getJobDetails(component, event, helper,null);
        helper.getStationTools(component, event, helper);
        helper.getDatafromParent(component, event, helper);
        helper.getStageRecordtypeId(component, event, helper);
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
                    line.relatedJobWrapper.validJobCardList[0].ETT_Building_Work_Schedule__c=component.get("v.workSheduleInfo.Id");
                    line.relatedJobWrapper.validJobCardList[0].ETT_Building_technician__c= $A.get("$SObjectType.CurrentUser.Id");
                    if(line.workTracker.ETT_Start_time__c==null){
                        line.workTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
                    }
                    line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
                    
                    //Initialize the next line item for creating this on load on next step to trigger the timer
                    var Nextlineitem=component.get("v.Nextlineitem");
                    Nextlineitem.Id=null;
                    Nextlineitem.ETT_Activity_Performed__c='Reviewing Job History';
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
			 component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Light Conditions';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
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
			 component.set("v.step_error","Please ensure final condition to be good condition to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Reviewing Job History';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
	},
    goToStep5: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
        
        if(step_error==null || step_error==""){
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Building Rim Status Check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    goToStep6 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var startCheckbox = component.get("v.startCheckbox");
        
       if(line.jobLineItem.ETT_Verified_Building_Rim_Change__c!=true){

        }
       else
       {
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Expandable Building Rim pressure check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
             
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
	},
    goToStep7 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
         if(line.jobLineItem.ETT_Initial_Activity_State__c =='No' && line.jobLineItem.ETT_Final_Activity_State__c !='Yes'){
			 component.set("v.step_error","Please ensure final pressure condition met 25-30 psi to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.jobLineItem.ETT_Final_Activity_State__c='Good';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='The Spacer/Rad Adjustment';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
             
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
        }
	},
    startPressueAdjustmentWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    goToStep8 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        // if(line.jobLineItem.ETT_Verified_Building_Rim_Change__c!=true){
			// component.set("v.step_error","Please ensure that Rim has been made to match with Tyre Size.");
      //  }
       // else
        //{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Stitching adjustment check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
       // }
	},
    startStitchingAdjustmentWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    goToStep9 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Matched' && line.jobLineItem.ETT_Final_Activity_State__c !='Matched'){
			 component.set("v.step_error","Please ensure Stitching adjustment done to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Stitching wheel condition';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
	},
    startStitchingWheelWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    goToStep10 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
			 component.set("v.step_error","Please ensure final Stitching wheel condition to be good to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Stitching pressure check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
	},
    startStitchingPressureWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    goToStep11 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='No' && line.jobLineItem.ETT_Final_Activity_State__c !='Yes'){
			 component.set("v.step_error","Please ensure final Stitching pressure condition met 2.5 bar to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Check Onside down filling';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
	},
    goToStep12 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Skiving spot filling check';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
    },
    goToStep13 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Tread centering sensor condition check';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
    },
    startSensorWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    goToStep14 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Good' && line.jobLineItem.ETT_Final_Activity_State__c !='Good'){
			 component.set("v.step_error","Please ensure Thread centering sensor condition is good to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Tread width with Cushion gum match';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
	},
    startCushionGumWorks: function(component, event, helper){
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
        }
    },
    goToStep15 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        if(line.jobLineItem.ETT_Initial_Activity_State__c =='Not Matched' && line.jobLineItem.ETT_Final_Activity_State__c !='Matched'){
			 component.set("v.step_error","Please ensure final tread width matched with cushion gum to proceed.");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Shoulder Strip check';
            Nextlineitem.ETT_Type__c='Pre-Requisite Work';
            Nextlineitem.ETT_Status__c='Not Started';
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
        }
	},
    goToStep16 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Nail hole check';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    notifySupervisorNailHoleMissing: function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        line.jobLineItem.ETT_Status__c='In-Progress'; 
        line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=true;
        helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    goToStep17 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Check Tread width, Pattern';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    goToStep18 : function(component, event, helper) {
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        
        line.jobLineItem.ETT_Status__c='Completed';
        line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
        line.jobLineItem.Desired_Tread_Pattern__c=line.relatedJobWrapper.ThreadPrepDetails[0].Desired_Tread_Pattern__c;
        line.jobLineItem.ETT_Physical_Width__c=line.relatedJobWrapper.ThreadPrepDetails[0].ETT_Physical_Width__c;
        //Initialize the next line item for creating this on load on next step to trigger the timer
        var Nextlineitem=component.get("v.Nextlineitem");
        Nextlineitem.Id=null;
        Nextlineitem.ETT_Activity_Performed__c='Removal of plastic sheet check';
        Nextlineitem.ETT_Type__c='Pre-Requisite Work';
        Nextlineitem.ETT_Status__c='Not Started';
        
        var nextWorkTracker=component.get("v.nextWorkTracker");
        nextWorkTracker.Id=null;
        nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next work activity
    },
    goToStep19: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
        
        if(line.jobLineItem.ETT_Verified_Removal_of_plastic_cover__c!=true || line.jobLineItem.ETT_Align_thread_rubber_laser_light__c!=true){
			 component.set("v.step_error","Please ensure all actvities are completed to move on");
        }
        else{
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            //Initialize the next line item for creating this on load on next step to trigger the timer
            var Nextlineitem=component.get("v.Nextlineitem");
            Nextlineitem.Id=null;
            Nextlineitem.ETT_Activity_Performed__c='Stitching check';
            Nextlineitem.ETT_Type__c='Actual Work';
            Nextlineitem.ETT_Status__c='Not Started';
            Nextlineitem.ETT_Is_2_piece_thread__c=false;
            Nextlineitem.NotifyDone19=true;
            
            var nextWorkTracker=component.get("v.nextWorkTracker");
            nextWorkTracker.Id=null;
            nextWorkTracker.ETT_Start_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');   
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
    },
    startThreadStrichWorks: function(component, event, helper) {   
    	var line=component.get("v.current_line");
        var isNotify19True = component.get("v.NotifyDone19");
        
        if(JSON.stringify(line.jobLineItem.Sequence__c)=='19'&&!isNotify19True)
        {
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Please Send Notification."
                });
                toastEvent.fire(); 
        }
        line.jobLineItem.ETT_Status__c='In-Progress';
        
        var allowDML = component.get('v.allowDML');
        if(allowDML){
            helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update,next line item, next ine work activity 
            helper.getHOONotification(component, event, helper);
        }
    },
    goToStep20 : function(component, event, helper) {        
        var line=component.get("v.current_line");
        component.set("v.step_error","");
        console.log(line.jobLineItem.ETT_Is_2_piece_thread__c);
          console.log(line.jobLineItem.ETT_Initial_Activity_State__c);
            console.log(line.jobLineItem.ETT_Final_Activity_State__c);
        if(line.jobLineItem.ETT_Is_2_piece_thread__c==false && line.jobLineItem.ETT_Initial_Activity_State__c =='Yes' && line.jobLineItem.ETT_Final_Activity_State__c !='Yes'){
			 component.set("v.step_error","Please ensure final check on Thread Stapler joint present over thread.");
        }
        else{
            if(line.jobLineItem.ETT_Is_2_piece_thread__c!=true){
                line.jobLineItem.ETT_Initial_Activity_State__c ='';
                line.jobLineItem.ETT_Final_Activity_State__c ='';
            }
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
           
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
        
    },
    goToStep21 : function(component, event, helper) {        
        var line=component.get("v.current_line");
        component.set("v.step_error","");
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
        
        helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
    },
    handleComplaintMasterEvent : function(component, event, helper) {        
        var flag =event.getParam("flag");// getting the value of event attribute
        
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
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,false,Nextlineitem,nextWorkTracker); //parameter usage: line item, gotoNext step, activity update, job card update 
        }
        else{
            component.set("v.step_error","Something went wrong..");
        }
    },
    goToStep22: function(component,event,helper){
        component.set("v.step_error","");
        var line=component.get("v.current_line");
        var step_error=component.get("v.step_error");
        var selectedNextStation=component.get("v.selectedNextStation");
        
        if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c) || line.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c==""){ 
            component.set("v.step_error","Status is mandatory to end.");
        }
        else if(line.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Accepted' && ($A.util.isUndefinedOrNull(selectedNextStation) || selectedNextStation=="")){ 
            component.set("v.step_error","Next stage should be selected when accepting.");
        }
        else{
            if(line.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Initial Rejection'){
                component.set("v.selectedNextStation","");
            }
            line.jobLineItem.ETT_Status__c='Completed';
            line.workTracker.ETT_End_time__c=$A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');
            
            if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Building_Technician_Reject_Remarks__c)){
                line.relatedJobWrapper.validJobCardList[0].ETT_Building_Technician_Reject_Remarks__c='';
            }
            if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)){
                line.jobLineItem.ETT_Remarks__c='';
            }   
            line.relatedJobWrapper.validJobCardList[0].ETT_Building_Technician_Reject_Remarks__c='Version:'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Building_Technician_Reject_Remarks__c;//append the technician remarks
            
            helper.updateJobCardLineItem(component, event, helper,line,true,true,true,null,null); //parameter usage: line item, gotoNext step, activity update, job card update 
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
            lineItemForHoldWrapper.jobLineItem.ETT_Revision_Number__c=line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c;
            
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
        component.set("v.displayDefectSectionCutOff",false);
    },
    openUsageTracker: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
     	component.set("v.usageSection",true);
        component.set("v.confirmHoldVar",false); 
        component.set("v.openToolsReqSection",false);
        component.set("v.displayDefectSectionCutOff",false);
    },
    openToolsReqSectionOperation: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.openToolsReqSection",true);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
        component.set("v.displayDefectSectionCutOff",false);
    },
    backFromToolReqPage: function(component,event,helper){
        component.set("v.step_error","");
        helper.getStationTools(component, event, helper);
        component.set("v.openToolsReqSection",false);
        component.set("v.usageSection",false);
        component.set("v.confirmHoldVar",false);
        component.set("v.displayDefectSectionCutOff",false);
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
        component.set("v.selectedNextStation","");//reset the variable when user clicks back button
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
            if($A.util.isUndefinedOrNull(line.relatedJobWrapper.validJobCardList[0].ETT_Building_Technician_Reject_Remarks__c)){
                line.relatedJobWrapper.validJobCardList[0].ETT_Building_Technician_Reject_Remarks__c='';
            }
            if($A.util.isUndefinedOrNull(line.jobLineItem.ETT_Remarks__c)){
                line.jobLineItem.ETT_Remarks__c='';
            }   
            line.relatedJobWrapper.validJobCardList[0].ETT_Building_Technician_Reject_Remarks__c='Version(Defect found):'+line.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c+' :'+line.jobLineItem.ETT_Remarks__c+'\n'+line.relatedJobWrapper.validJobCardList[0].ETT_Building_Technician_Reject_Remarks__c;//append the technician remarks
            helper.reportDefectsAndUpdateStations(component,event,helper);
        }
    },
    handleCheckAllBox: function(component, event, helper) {
        component.set('v.isJobDisabled',!event.target.checked);
    },
    notifySupervisor: function(component, event, helper) {
     	var action = component.get("c.SupervisorNotification3");
        var line=component.get("v.current_line");
        line.jobLineItem.ETT_Notification_Sent_to_Supervisor__c=true;
        helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null);
       /* var seq = JSON.stringify(line.jobLineItem.Sequence__c);
    	var titl="";
        var msg = "";
        if(seq=='19')
        {
            component.set("v.NotifyDone19",true);
        }
        if(seq == '19'){
            titl ='Thread Stitching Check ';
            msg ='Final Check on Thread Stapler joint present over thread - '+line.jobLineItem.ETT_Final_Activity_State__c;
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