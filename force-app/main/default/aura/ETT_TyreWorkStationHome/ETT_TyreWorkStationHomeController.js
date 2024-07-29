({
    doInit : function(component, event, helper) {
        
        let device = $A.get("$Browser.formFactor");
        
        component.set('v.device',device);
        helper.getWorkStationChecklistInfo(component, event, helper);
        helper.getUserInfo(component, event, helper);
        helper.getWorkScheduleDetails(component, event, helper);
        helper.getJobCardsDetails(component, event, helper);
    },
    refreshData : function(component, event, helper) {
         helper.getJobCardsDetails(component, event, helper);
    },
    onMenuClickHandler : function(component, event, helper) {
        var cmpTarget = component.find('dropDown');
        $A.util.toggleClass(cmpTarget, 'slds-show');
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },
    handleLogout : function(component, event, helper) {
        //$A.get("e.force:logout").fire();
        
        window.location.replace("/TWS/secur/logout.jsp?retUrl=/TWS/s/login");
    },
    reloadPage : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    openChecklist : function(component, event, helper) {
        
        component.set("v.showCLModel",true);
        let currentTime  = $A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
        component.set("v.startDateTime",currentTime);
    },
    handleCancelPopup : function(component, event, helper) {
        
        helper.closeCancelPopupHelper(component, event, helper);
        
    },
    
    handleChecklist : function(component, event, helper) {
        
        let hasError = false;
        //Buffing Stage Validation - start
        
        let buffSettReason = component.get("v.buffSettReason");
        if(!component.get("v.bufferSetting") && buffSettReason == ''){
            hasError = true;
            component.find("BufferSettingsReason").showHelpMessageIfInvalid();
        }
        
        if(!component.get("v.sideBufferCond") && component.get("v.sideBuffReason") == ''){
            hasError = true;
            component.find("SidebufferReason").showHelpMessageIfInvalid();
        }
        if(component.get("v.buffingPwdReplc") && component.get("v.bagReplcReasn") == ''){
            hasError = true;
            component.find("bagReplacementReason").showHelpMessageIfInvalid();
        }
        
        
     
        if(!component.get("v.startDustColl")){
            hasError = true;
            component.find("startDustColl").showHelpMessageIfInvalid();
        }
         if(!component.get("v.switchOnPwr")){
            hasError = true;
            component.find("switchOnPwr").showHelpMessageIfInvalid();
        }
        
        
        //Buffing Stage Validation - End
        //Thread Prep validation - Start
        if(!component.get("v.cuttMachineCond") && component.get("v.cuttMachineReason") == ''){
            hasError = true;
            component.find("cuttMachineReason").showHelpMessageIfInvalid();
        }
        //Thread Prep validation - End
        //Curing validation - Start
        let digScr = component.get("v.DigScreen");
        let ctrlPb = component.get("v.ConPanBoard");
        let chamMtr = component.get("v.ChamMotor");
        let GauVacPre = component.get("v.GauVacPressure");
        if((!digScr || !ctrlPb || !chamMtr || !GauVacPre) && !component.get("v.curingRemarks") ){
           
            hasError = true;
            component.find("curingRemar").showHelpMessageIfInvalid();
           
        }
      
        /*if(!component.get("v.x13InfPressure") && component.get("v.ValveNumber") == ''){
            
            hasError = true;
            component.find("ValveNumber").showHelpMessageIfInvalid();
        }*/
        //Curing validation - End
        
        
        
        if(!hasError){
            
           let stage = component.get("v.workScheduleInfo.ETT_Work_Station__r.ETT_Station_Type__c");
            
            var clObj = new Object();
            clObj.sobjectType = 'ETT_Work_Station_Checklist__c';
            clObj.Work_Station__c=component.get("v.workScheduleInfo.ETT_Work_Station__c");
            clObj.Work_Schedule__c = component.get("v.workScheduleInfo.Id");
            clObj.Start_Time__c= component.get("v.startDateTime");
            clObj.End_Time__c=  $A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDThh:mm:ss.SSSZ');  
            clObj.Light_Condition__c = component.get("v.li8Cond")?'Good':'Not Good';
            clObj.Floor_Condition__c = component.get("v.floorCond")?'Good':'Not Good';
            
            if(stage == 'Buffing'){
                clObj.Buffer_Settings__c = component.get("v.bufferSetting")?'Correct':'Not Correct';
                clObj.Buffer_Setting_Reason__c= component.get("v.buffSettReason")?component.get("v.buffSettReason"):'';
                clObj.Buffing_Blade__c = component.get("v.buffBlade")?'Good':'Not Good';
                clObj.Side_Buffer_Condition__c = component.get("v.sideBufferCond")?'Good':'Not Good';
                clObj.Side_Buffer_Reason__c = component.get("v.sideBuffReason")?component.get("v.sideBuffReason"):'';
                clObj.Buffing_Powder_Bag_Replacement__c = component.get("v.buffingPwdReplc")?'Yes':'No';
                clObj.Bag_Replacement_Reason__c = component.get("v.bagReplcReasn")?component.get("v.bagReplcReasn"):'';
                clObj.Dust_Collector_Suction_Status__c =component.get("v.dustCollStatus")?'Good':'Not Good';
                clObj.Suction_Filter_Condition__c =component.get("v.sucFilteCond")?'Good':'Not Good';
                clObj.Suction_Line_Condition__c =component.get("v.sucLineCond")?'Good':'Not Good';
                clObj.Suction_Pipeline_Condition__c =component.get("v.sucPipeCond")?'Good':'Not Good';
                clObj.Started_Dust_Collection__c =component.get("v.startDustColl")?'Yes':'No';
                clObj.Switched_On_Power__c =component.get("v.switchOnPwr")?'Yes':'No';
            }
            /** Skiving data - start **/
            if(stage == 'Skiving'){
                clObj.Raps_Status__c = component.get("v.rapsStatus")?'Good':'Not Good';
                clObj.Cutting_Stone_Status__c=  component.get("v.cutngStoneStatus")?'Good':'Not Good';
                clObj.Counter_Wheel_Status__c=  component.get("v.counWhelStatus")?'Good':'Not Good';
                clObj.Cement_Wheel_Status__c=  component.get("v.cementWheStatus")?'Good':'Not Good';
                clObj.Rubber_Hogs_Status__c=  component.get("v.rubberHogs")?'Good':'Not Good';
                clObj.Burr_Status__c=  component.get("v.burrStatus")?'Good':'Not Good';
                clObj.Router_Carbide_Status__c=  component.get("v.routerCarbide")?'Good':'Not Good';
                clObj.Ball_Shaped_Carbide_Status__c=  component.get("v.balShapeCarbide")?'Good':'Not Good';
                clObj.Aluminum_Oxide_Stone_Status__c=  component.get("v.aluOxide")?'Good':'Not Good';
                clObj.Other_Tools_Status__c=  component.get("v.otherTools")?'Good':'Not Good';
            }
            /** Skiving data - End **/
            
            /** Repair data - start **/
            if(stage == 'Repair'){
                clObj.Motorized_Inspection_Spreader__c=  component.get("v.motoInsSpe")?'Good':'Not Good';
                clObj.Repair_Plug_Uniseal__c=  component.get("v.repairPlug")?'Good':'Not Good';
            }
            /** Repair data - End **/
            
            
            /** Filling data - start **/
            if(stage == 'Filling'){
                clObj.Filling_Machine_Temp__c=  component.get("v.fillMachineTemp")?'Correct':'Not Correct';
            }
            /** Filling data - End **/
            
            /** Thread Prep data - start **/
            if(stage == 'Thread Preparation'){
                clObj.Cutting_Machine_Condition__c=  component.get("v.cuttMachineCond")?'Good':'Not Good';
                clObj.Cutting_Machine_Reason__c= component.get("v.cuttMachineReason")?component.get("v.cuttMachineReason"):'';
            }
            /** Thread Prep - End **/
            
            /** Rimming & Enveloping data - start **/
            if(stage == 'Rimming & Enveloping'){
                clObj.Envelop_Lift_Condition__c=  component.get("v.envLiftCond")?'Good':'Not Good';
                clObj.Envelop_Spreader_Machine_Condition__c= component.get("v.envSpMachCond")?'Good':'Not Good';
                clObj.Tyre_Rimming_Machine__c = component.get("v.tyreRimmCond")?'Good':'Not Good';
                clObj.Curing_Envelop_Condition__c = component.get("v.CuringEnvpCnd")?'Good':'Not Good';
                clObj.Rim_Plate_Condition__c = component.get("v.RimPlateCnd")?'Good':'Not Good';
                clObj.Curing_Tube_Status__c = component.get("v.CuringTubeSta")?'Good':'Not Good';
            }
            /**  Rimming & Enveloping - End **/
            
            /** Curing data - start **/
            if(stage == 'Curing'){
                clObj.Chamber_Door_Condition__c=  component.get("v.chamDoorCond")?'Good':'Not Good';
                clObj.Hydraulic_Pump_Condition__c= component.get("v.HydPump")?'Good':'Not Good';
                clObj.Door_Safety_Lock_Condition__c = component.get("v.DoorSafeLock")?'Good':'Not Good';
                clObj.x13_Inflation_Pressure__c = component.get("v.x13InfPressure")?'Good':'Not Good';
                clObj.Vacuum_Machine_Condition__c = component.get("v.VacMachine")?'Good':'Not Good';
                clObj.X13_Pressure_Cable_Condition__c = component.get("v.x13PreCable")?'Good':'Not Good'; 
                clObj.X13_Vacuum_Pressure_Valve_Condition__c = component.get("v.VacPresValv")?'Good':'Not Good';
                clObj.Valve_Number__c = component.get("v.ValveNumber")?component.get("v.ValveNumber"):'1P1';
                clObj.Digital_Screen_Condition__c = component.get("v.DigScreen")?'Good':'Not Good';
                clObj.Control_Panel_Board_Condition__c = component.get("v.ConPanBoard")?'Good':'Not Good';
                clObj.Chamber_Motor_Condition__c = component.get("v.ChamMotor")?'Good':'Not Good';
                clObj.Gaugs_Vacuum_Pressure_Condition__c = component.get("v.GauVacPressure")?'Good':'Not Good';
                clObj.Curing_Remarks__c = component.get("v.curingRemarks")?component.get("v.curingRemarks"):'';
            }
            /**Curing  - End **/
            
            /** Final Inspection - Start **/ 
            if(stage == 'Final Inspection' || stage == 'Quality Control'){
                clObj.Tyre_Spreader_Condition__c = component.get("v.tyreSpred")?'Good':'Not Good';
                clObj.Spreader_Light_Condition__c = component.get("v.spreadLi8")?'Good':'Not Good';
                clObj.Tyre_Lift_Condition__c = component.get("v.tyreLift")?'Good':'Not Good';
            }
            /** Final Inspection - End **/
            
        }
        console.log(clObj)
        
        
        if(!hasError){ 
            
          // alert('success')
            var action = component.get('c.createWorkStationCheckList');
            
            action.setParams({
                wscl : clObj
                
            });
            component.set("v.showSpinner",true);
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                    component.set("v.showSpinner",false);
                     helper.getWorkStationChecklistInfo(component, event, helper);
                    helper.showErrorToast({
                        "title": "success",
                        "type": "success",
                        "message":"Your check list created successfully."
                    });
                    helper.closeCancelPopupHelper(component, event, helper);
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            helper.showErrorToast({
                                "title": "Error",
                                "type": "Error",
                                "message":errors[0].message
                            });
                            component.set("v.showSpinner",false);
                        }
                    } else {
                        console.log("Unknown error");
                        component.set("v.showSpinner",false);
                    }
                }
            }); 
            
            $A.enqueueAction(action);        
            
        }
        
    },
    
    getPreviousList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start-=corousalSize;
        var jcList=component.get('v.jobCardList'); 
        component.set('v.CarousalJobcardList',jcList.slice(start,start+corousalSize)); 
        component.set('v.start',start);
        
    },
    getNextList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start+=corousalSize;
        var jcList=component.get('v.jobCardList'); 
        component.set('v.CarousalJobcardList',jcList.slice(start,start+corousalSize)); 
        component.set('v.start',start); 
    },
    
    filterHandler : function(component, event, helper) {
        
        let kw = component.get("v.searchKeyWord").toLowerCase();
        var start=component.get('v.start');
        var corousalSize=component.get('v.corousalSize');
        let stage = component.get("v.workScheduleInfo.ETT_Work_Station__r.ETT_Station_Type__c");
        
        if(kw.length > 2){
            
            let data = component.get("v.jobCardList");
            
            let fileredData =  data.filter(function(item) {
                if(stage=='Thread Preparation'){
                     return (item.Tyre_Inventory__r.Serial_Number__c.toLowerCase().indexOf(kw) !== -1)||
                    (item.ETT_Main_Job_Card__r.Name.toLowerCase().indexOf(kw) !== -1);
                }else{
                return (item.Tyre_Inventory__r.Serial_Number__c.toLowerCase().indexOf(kw) !== -1)||
                    (item.Name.toLowerCase().indexOf(kw) !== -1);
                }
            });
            //console.log(fileredData)
            
            if(fileredData.length > corousalSize){
                
                component.set("v.CarousalJobcardList",fileredData.slice(start,start+corousalSize));
            }else{
                
                component.set("v.CarousalJobcardList",fileredData);
            }
            
        }else{
            let data = component.get("v.jobCardList");
            if(data.length > corousalSize){
                
                component.set("v.CarousalJobcardList",data.slice(start,start+corousalSize));
            }else{
                
                component.set("v.CarousalJobcardList",data);
            }
        }
        
    },
    jobCardProcess : function(component, event, helper) {
        
        let stage = component.get("v.workScheduleInfo.ETT_Work_Station__r.ETT_Station_Type__c");
        let jobId = event.getSource().get("v.name");
        component.set("v.selectedJobCardId",jobId);
        let hasCheckList = component.get("v.HasCheckList");
        //alert('HASCHECKLIST' +hasCheckList);
        if(hasCheckList){        
            if(stage=='Buffing'){
                component.set("v.showJobView_Buffing",true);
            }else if(stage=='Skiving'){
                component.set("v.showJobView_Skiving",true);
            }else if(stage =='Repair'){
                component.set("v.showJobView_Repair",true);
            }else if(stage=='Cementing'){
                component.set("v.showJobView_Cementing",true);
            }else if(stage=='Filling'){
                component.set("v.showJobView_Filling",true);
            } else if(stage=='Thread Preparation'){
                component.set("v.showJobView_ThreadPreparation",true);
            }else if(stage =='Building'){
                component.set("v.showJobView_Building",true);
            } else if(stage =='Rimming & Enveloping'){
                component.set("v.showJobView_RimmingEnveloping",true);
            } else if(stage=='Curing'){
                component.set("v.showJobView_Curing",true);
            } else if(stage=='Final Inspection'){
                component.set("v.showJobView_FinalInspection",true);
            }  else if(stage=='Removal of RIM Tube Flap'){
                component.set("v.showJobView_RemovalOfRIMTubeFlap",true);
            } else if(stage=='Painting'){
                component.set("v.showJobView_Painting",true);
            }else if(stage=='Quality Control'){
                component.set("v.showJobView_QualityControl",true);
            }
        
        }else{
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":"Please verify checklist before proceed.",
                "mode":"dismissible"
            });
            toastReference.fire();
            
        }
        
    },
    
    bufferSettingChange : function(component, event, helper) {
        
        let bufferSettingVal = component.get("v.bufferSetting");
        if(!bufferSettingVal){
            component.set("v.shwBuffSetReas",true);
        }else{
            component.set("v.shwBuffSetReas",false);
            component.set("v.buffSettReason","");
        }
    },
    
    sideBufferChange : function(component, event, helper) {
        
        let val = component.get("v.sideBufferCond");
        if(!val){
            component.set("v.shwSideBuffReas",true);
        }else{
            component.set("v.shwSideBuffReas",false);
            component.set("v.sideBuffReason","");
            
        }
    },
    buffingPowderChange : function(component, event, helper) {
        
        let val = component.get("v.buffingPwdReplc");
        if(val){
            component.set("v.shwBagReplcReas",true);
        }else{
            component.set("v.shwBagReplcReas",false);
            component.set("v.bagReplcReasn","");
            
        }
    },
    dustCollChange : function(component, event, helper) {
        
        let val = component.get("v.dustCollStatus");
        if(!val){
            $A.util.removeClass(component.find("dustColl"), "slds-hide");
        }else{
            $A.util.addClass(component.find("dustColl"), "slds-hide");
            
        }
    },
    cuttMachChange :function(component, event, helper) {
        
        let val = component.get("v.cuttMachineCond");
        if(!val){
            component.set("v.shwCuttMachReas",true);
        }else{
            component.set("v.shwCuttMachReas",false);
            component.set("v.cuttMachineReason","");
            
        }
    },
    InflPressureChange :function(component, event, helper) {
        
        let val = component.get("v.x13InfPressure");
        if(!val){
            component.set("v.shwValvNumber",true);
        }else{
            component.set("v.shwValvNumber",false);
            component.set("v.ValveNumber","1P1");
            
        }
    },
    showRemarksMethod : function(component, event, helper) {
        
        let digScr = component.get("v.DigScreen");
        let ctrlPb = component.get("v.ConPanBoard");
         let chamMtr = component.get("v.ChamMotor");
         let GauVacPre = component.get("v.GauVacPressure");
        
        if(!digScr || !ctrlPb || !chamMtr || !GauVacPre){
            component.set("v.showRemarks",true);
        }else if(digScr && ctrlPb &&chamMtr &&GauVacPre){
           component.set("v.showRemarks",false);
           component.set("v.curingRemarks","");
        }
        
    }  
})