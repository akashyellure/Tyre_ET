({
    getUserInfo : function(component, event, helper) {
        
        var action = component.get('c.getUserDetails');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                component.set("v.userInfo", response.getReturnValue());
                
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
    getWorkScheduleDetails : function(component, event, helper) {
        
        var action = component.get('c.getWorkscheduleInfo');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
                component.set("v.workScheduleInfo",data);
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
    getJobCardsDetails : function(component, event, helper) {
        
        var action = component.get('c.getJobCardsInfo');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
                component.set("v.jobCardList", data);
                component.set("v.noOfJobcards",data.length);
                var start=component.get('v.start');
                var corousalSize=component.get('v.corousalSize');
                
                if(data.length > corousalSize){
                    
                    component.set("v.CarousalJobcardList",data.slice(start,start+corousalSize));
                }else{
                    
                    component.set("v.CarousalJobcardList",data);
                }
                
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
    showErrorToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    closeCancelPopupHelper : function(component, event, helper) {
        
        component.set("v.showCLModel",false);
        //set all items to default value
        component.set("v.bufferSetting",true);
        component.set("v.sideBufferCond",true);
        component.set("v.buffingPwdReplc",false);
        component.set("v.shwBuffSetReas",false);
        component.set("v.shwSideBuffReas",false);
        component.set("v.shwBagReplcReas",false);
        component.set("v.li8Cond",true);
        component.set("v.floorCond",true);
        component.set("v.buffBlade",true);
        component.set("v.dustCollStatus",true);
        component.set("v.sucFilteCond",true);
        component.set("v.sucLineCond",true);
        component.set("v.sucPipeCond",true);
        
        //Skiving Values
        component.set("v.rapsStatus",true);
        component.set("v.cutngStoneStatus",true);
        component.set("v.counWhelStatus",true);
        component.set("v.cementWheStatus",true);
        component.set("v.rubberHogs",true);
        component.set("v.burrStatus",true);
        component.set("v.routerCarbide",true);
        component.set("v.balShapeCarbide",true);
        component.set("v.aluOxide",true);
        component.set("v.otherTools",true);
        //Repair Values
        component.set("v.motoInsSpe",true);
        component.set("v.repairPlug",true);
        //Filling Values
        component.set("v.fillMachineTemp",true);
        //Thread Prep values
        component.set("v.cuttMachineCond",true);
        component.set("v.cuttMachineReason","");
        component.set("v.shwCuttMachReas",false);
        //Rimming&Enveloping values
        component.set("v.envLiftCond",true);
        component.set("v.envSpMachCond",true);
        component.set("v.tyreRimmCond",true);
         component.set("v.CuringEnvpCnd",true);
         component.set("v.RimPlateCnd",true);
         component.set("v.CuringTubeSta",true);
        //Curing Values
        component.set("v.chamDoorCond",true);
        component.set("v.HydPump",true);
        component.set("v.DoorSafeLock",true);
        component.set("v.x13InfPressure",true);
        component.set("v.ValveNumber","1P1");
        component.set("v.shwValvNumber",false);
        component.set("v.VacMachine",true);
        component.set("v.VacPresValv",true);
        component.set("v.x13PreCable",true);
        component.set("v.DigScreen",true);
        component.set("v.ConPanBoard",true);
        component.set("v.ChamMotor",true);
        component.set("v.GauVacPressure",true);
        component.set("v.showRemarks",false);
        component.set("v.curingRemarks","");
        //Final Inspection Values
        component.set("v.tyreSpred",true);
        component.set("v.spreadLi8",true);
        component.set("v.tyreLift",true);
        
    },
     getWorkStationChecklistInfo : function(component, event, helper) {
        
        var action = component.get('c.getWorkStatCheckListDetails');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                try{
                
                if(data.length >0){
                    
                    component.set("v.HasCheckList",true);
                }else{
                    component.set("v.HasCheckList",false);
                }
                }catch(e){
                    console.log(e.message)
                }
                //console.log(data)           
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
})