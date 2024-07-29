({
    showErrorToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
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
                /*    {
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
                        console.log('***toolUsageListOptions[k].toolUsage: '+toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c+'-'+toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c+'-'+toolUsageListOptions[k].toolUsage.ETT_Track_Depreciable_Item_Usage_at_JC__c);
                        if($A.util.isUndefinedOrNull(toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c) || toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c<=0){
                            itemsToRemove.push(k);
                            console.log('***inside removal');
                        }
                        else if($A.util.isUndefinedOrNull(toolUsageListOptions[k].toolUsage.ETT_Track_Depreciable_Item_Usage_at_JC__c) || toolUsageListOptions[k].toolUsage.ETT_Track_Depreciable_Item_Usage_at_JC__c!=true){
                            itemsToRemove.push(k);
                            console.log('***inside removal');
                        }
                    }
                }
                console.log('****itemsToRemove: '+itemsToRemove);
                if(itemsToRemove.length >0){
                    toolUsageListOptions.splice(itemsToRemove[0],itemsToRemove.length);
                    console.log('****toolUsageListOptions: '+toolUsageListOptions.length);
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
        
        var availableStations = [];
        var availableStationsList = component.get("v.availableStations");
        availableStations.push({"label":"---Select Work Station---","value":""});
        for(var key in availableStationsList){
            availableStations.push({'label': availableStationsList[key], 'value': availableStationsList[key]});
        }
        component.set("v.availableStations",availableStations);
        
        var goodNotGoodValues = [];
        goodNotGoodValues.push({key: 'Good', value: 'Good'});
        goodNotGoodValues.push({key: 'Not Good', value: 'Not Good'});
        component.set("v.goodNotGoodValues",goodNotGoodValues);
        
        
        var chamberOneTwoValues = [];
        chamberOneTwoValues.push({key: 'Chamber 1', value: 'Chamber 1'});
        chamberOneTwoValues.push({key: 'Chamber 2', value: 'Chamber 2'});        
        component.set("v.chamberOneTwoValues",chamberOneTwoValues);
        
        var rimSureLockValues = [];
        rimSureLockValues.push({key: 'Rim', value: 'Rim'});
        rimSureLockValues.push({key: 'Sure Lock', value: 'Sure Lock'});        
        component.set("v.rimSureLockValues",rimSureLockValues);
        
        var beamValues = [];
        beamValues.push({key: 'Beam A', value: 'Beam A'});
        beamValues.push({key: 'Beam B', value: 'Beam B'});
        component.set("v.beamValues",beamValues);
        
        var lubeValues = [];
        lubeValues.push({key: 'Soap Solution', value: 'Soap Solution'});
        lubeValues.push({key: 'Envelop Lube', value: 'Envelop Lube'});
        lubeValues.push({key: 'Others', value: 'Others'});        
        component.set("v.lubeValues",lubeValues);        
        
      /*  var pressureValues = [];
        pressureValues.push({key: 'P1', value: 'P1'});
        pressureValues.push({key: 'P2', value: 'P2'});
        pressureValues.push({key: 'P3', value: 'P3'});
        pressureValues.push({key: 'P4', value: 'P4'});
        pressureValues.push({key: 'P5', value: 'P5'});
        pressureValues.push({key: 'P6', value: 'P6'});
        pressureValues.push({key: 'P7', value: 'P7'});
        pressureValues.push({key: 'P8', value: 'P8'});
        pressureValues.push({key: 'P9', value: 'P9'});
        pressureValues.push({key: 'P10', value: 'P10'});
        pressureValues.push({key: 'P11', value: 'P11'});
        pressureValues.push({key: 'P12', value: 'P12'});
        pressureValues.push({key: 'P13', value: 'P13'});
        
        component.set("v.pressureValues",pressureValues);*/
        
         var pressureValues = [];
        pressureValues.push({key: '1P1', value: '1P1'});
        pressureValues.push({key: '1P2', value: '1P2'});
        pressureValues.push({key: '2P1', value: '2P1'});
        pressureValues.push({key: '2P2', value: '2P2'});
        pressureValues.push({key: '3P1', value: '3P1'});
        pressureValues.push({key: '3P2', value: '3P2'});
        pressureValues.push({key: '4P1', value: '4P1'});
        pressureValues.push({key: '4P2', value: '4P2'});
        pressureValues.push({key: '5P1', value: '5P1'});
        pressureValues.push({key: '5P2', value: '5P2'});
        pressureValues.push({key: '6P1', value: '6P1'});
        pressureValues.push({key: '6P2', value: '6P2'});
        pressureValues.push({key: '7P1', value: '7P1'});
        pressureValues.push({key: '7P2', value: '7P2'});
		pressureValues.push({key: '8P1', value: '8P1'});
        pressureValues.push({key: '8P2', value: '8P2'});
        pressureValues.push({key: '9P1', value: '9P1'});
        pressureValues.push({key: '9P2', value: '9P2'});
        pressureValues.push({key: '10P1', value: '10P1'});
        pressureValues.push({key: '10P2', value: '10P2'});
	 	pressureValues.push({key: '11P1', value: '11P1'});
        pressureValues.push({key: '11P2', value: '11P2'});
        pressureValues.push({key: '12P1', value: '12P1'});
        pressureValues.push({key: '12P2', value: '12P2'});
        pressureValues.push({key: '13P1', value: '13P1'});
        pressureValues.push({key: '13P2', value: '13P2'});

        component.set("v.pressureValues",pressureValues);
        
        var vaccumeValues = [];
        vaccumeValues.push({key: '1V1', value: '1V1'});
        vaccumeValues.push({key: '1V2', value: '1V2'});
        vaccumeValues.push({key: '2V1', value: '2V1'});
        vaccumeValues.push({key: '2V2', value: '2V2'});
        vaccumeValues.push({key: '3V1', value: '3V1'});
        vaccumeValues.push({key: '3V2', value: '3V2'});
        vaccumeValues.push({key: '4V1', value: '4V1'});
        vaccumeValues.push({key: '4V2', value: '4V2'});
        vaccumeValues.push({key: '5V1', value: '5V1'});
        vaccumeValues.push({key: '5V2', value: '5V2'});
        vaccumeValues.push({key: '6V1', value: '6V1'});
        vaccumeValues.push({key: '6V2', value: '6V2'});
        vaccumeValues.push({key: '7V1', value: '7V1'});
        vaccumeValues.push({key: '7V2', value: '7V2'});
		vaccumeValues.push({key: '8V1', value: '8V1'});
        vaccumeValues.push({key: '8V2', value: '8V2'});
        vaccumeValues.push({key: '9V1', value: '9V1'});
        vaccumeValues.push({key: '9V2', value: '9V2'});
        vaccumeValues.push({key: '10V1', value: '10V1'});
        vaccumeValues.push({key: '10V2', value: '10V2'});
	 	vaccumeValues.push({key: '11V1', value: '11V1'});
        vaccumeValues.push({key: '11V2', value: '11V2'});
        vaccumeValues.push({key: '12V1', value: '12V1'});
        vaccumeValues.push({key: '12V2', value: '12V2'});
        vaccumeValues.push({key: '13V1', value: '13V1'});
        vaccumeValues.push({key: '13V2', value: '13V2'});

        component.set("v.vaccumeValues",vaccumeValues);        
       
        var defectYesNoValues = [];
        defectYesNoValues.push({key: 'No', value: 'No'});
        defectYesNoValues.push({key: 'Yes', value: 'Yes'});        
        component.set("v.defectYesNoValues",defectYesNoValues);
        
        
        var reasonValues = [];
        // reasonValues.push({key: 'Tread Separation', value: 'Tread Separation'});
        //reasonValues.push({key: 'Improper Tread Stitching', value: 'Improper Tread Stitching'});
        reasonValues.push({key: 'Tube leak', value: 'Tube leak'});
        reasonValues.push({key: 'Envelope leak', value: 'Envelope leak'});
        reasonValues.push({key: 'Envelope Coupler leak', value: 'Envelope Coupler leak'});
        reasonValues.push({key: 'Rimming plate mismatch', value: 'Rimming plate mismatch'});
        reasonValues.push({key: 'Sure Lock Leak', value: 'Sure Lock Leak'});
        reasonValues.push({key: 'Others', value: 'Others'});
        
        component.set("v.reasonValues",reasonValues);
        
        
        var RustNotRemoveValues = [];
        RustNotRemoveValues.push({key: 'Yes', value: 'Yes'});
        RustNotRemoveValues.push({key: 'No', value: 'No'});
        component.set("v.RustNotRemoveValues",RustNotRemoveValues);
        
        
        var SkivedConditionValues = [];
        SkivedConditionValues.push({key: 'No', value: 'No'});
        SkivedConditionValues.push({key: 'Yes', value: 'Yes'});        
        component.set("v.SkivedConditionValues",SkivedConditionValues);
        
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
        
        var isRimOrSureLock = [];
        isRimOrSureLock.push({key: 'Rim', value: 'Rim'});  
        isRimOrSureLock.push({key: 'Sure Lock', value: 'Sure Lock'});        
        component.set("v.isRimOrSureLock",isRimOrSureLock);
        
        
        
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
        
        var buffingSettingsReasonValues = [];
        var buffingSettings = component.get("v.buffingSettingsReasonValues");
        for(var key in buffingSettings){
            buffingSettingsReasonValues.push({key: key, value: buffingSettings[key]});
        }
        component.set("v.buffingSettingsReasonValues",buffingSettingsReasonValues);
        
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
    
    getJobDetails : function(component, event, helper,Nextlineitem,nextWorkTracker) {
        var action = component.get("c.getValidJobCardLineDetail");
        action.setParams({
            'recordId': component.get("v.recordId"),
            'stageValue': 'Rimming & Enveloping',
            'current_sequence': component.get("v.current_sequence"),
            'readOnlyView': !component.get('v.allowDML'),
            'Nextlineitem' : Nextlineitem,
            'nextWorkTracker' : nextWorkTracker
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                var respWrapper = response.getReturnValue();
                console.log('getValidJobCardLineDetail: '+JSON.stringify(respWrapper));
                component.set("v.current_sequence",respWrapper.jobLineItem.Sequence__c);
                
                if(respWrapper.jobLineItem.Sequence__c == 11){
                    respWrapper.jobLineItem.Envelope_Vacuum__c= '2.5';
                    respWrapper.jobLineItem.Envelope_Pressure__c= '2.5';
                }
                component.set("v.current_line",respWrapper);
                component.set("v.Nextlineitem",respWrapper.nextJobLineItem);
                component.set("v.nextWorkTracker",respWrapper.nextWorkTracker);
                component.set("v.lineItemForHold",respWrapper.holdLineItem);
                component.set("v.selectedNextStation",respWrapper.relatedJobWrapper.nextStageValue);
                
                //Janardhan Added
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
                
                //End
                
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
                
                
                /*******************************************/
                
                               
                
                //String recordId,String stageValue,Integer current_sequence
                var act = component.get("c.getJobCardLineInfoCommon");
                act.setParams({
                    'recordId': component.get("v.recordId"),
                    'ActivityPerformed': 'Enveloping Build Tyre Condition',
                    'sequence':2 //component.get("v.current_sequence")
                });
               
                act.setCallback(this, function(response) {
                    if (response.getState() == "SUCCESS") { 
                        var respWrapper = response.getReturnValue();
                       
                        component.set('v.isRimOrSureLock',respWrapper.Rim_Sure_Lock_Values__c);
                        component.set('v.RimOrSureLock',respWrapper.Rim_Sure_Lock_Values__c);

                    }else{
                        console.log(response.getError());
                    }
                });
                
                ///if(component.get("v.current_sequence")==11 || component.get("v.current_sequence")==15){
                $A.enqueueAction(act);
                //}
                
                
                /*******************************************/
                
                
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
    
    getStationTools: function(component, event, helper) {
        var action = component.get("c.getStationToolsWithWrapper");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.stationWrapperTools",response.getReturnValue());
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
            helper.getBaseData(component, event, helper);//call this helper at last so that other variables will be updated.
        });
        $A.enqueueAction(action);
    },
    
    updateJobCardLineItem: function(component, event, helper,line,moveNextstepOnCompletion,trackActivity,updateJobCard,Nextlineitem,nextWorkTracker){
        var action = component.get("c.updateJobCardLine");
         console.log('line--->'+JSON.stringify(line));
         console.log('trackActivity--->'+trackActivity);
         console.log('updateJobCard--->'+updateJobCard);
        console.log('selectedNextStation--->'+component.get("v.selectedNextStation"));
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
                
                console.log('current_line: '+current_line);
                console.log('current_sequence: '+current_sequence);
                
               /* if(current_sequence ==8){
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
                    this.getJobDetails(component, event, helper,Nextlineitem,nextWorkTracker);
                }*/
                if(moveNextstepOnCompletion==true){   
                    var seq_17_initialState=component.get("v.seq_17_initialState");
                    var rimsurelockvlaue = component.get("v.RimOrSureLock");
                    if(current_sequence ==16 && seq_17_initialState =='Yes'){
                        component.set("v.current_sequence",(current_sequence+2));
                    }
                   /* else if(current_sequence ==18 && rimsurelockvlaue =='Rim')
                    {
                          component.set("v.current_sequence",(current_sequence+2));
                    }*/
                    else{
                        component.set("v.current_sequence",(current_sequence+1));
                    } 
                   // component.set("v.current_sequence",(current_sequence+1));
                    this.getJobDetails(component, event, helper,Nextlineitem,nextWorkTracker);
                }
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
                console.log(JSON.stringify(errors));
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
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
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
    
    getStageRecordtypeId: function(component, event, helper){
        var action = component.get("c.getObjectRecordTypeIdByNme");
        action.setParams({
            'ObjectName': 'ETT_Job_Card_Line_Item__c',
            'recordTypeDeveloperName': 'Rimming & Enveloping'
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
    getRimSureLockValues: function(component, event, helper){
         
         var action = component.get("c.getRimSureLockValues");
        action.setParams({
            JCId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.RimOrSureLock",respVal);
                //alert(respVal);
                  //alert(component.set("v.RimOrSureLock",respVal));
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to fetch RimOrSureLock values."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
})