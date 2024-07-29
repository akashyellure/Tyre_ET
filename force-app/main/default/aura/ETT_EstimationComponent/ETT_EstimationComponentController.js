({
    doInit : function(component, event, helper) {
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        var currentUser =  $A.get("$SObjectType.CurrentUser.Id");
       // alert(currentUser)
        if(custLabelsFM==currentUser){
            component.set("v.isUserFM",custLabelsFM);
        }
        if(custLabelsHOO==currentUser){
            component.set("v.isUserHOO",custLabelsHOO);
        }
        
        if(custLabelsFM==currentUser || custLabelsHOO==currentUser){
            var actSave = component.get("c.lstEstimationsInfo");
            
            actSave.setParams({
                collectionCardId:component.get("v.recordId") 
            });
            
            actSave.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    //console.log('***response details ****'+response.getReturnValue());
                    //console.log(JSON.stringify(response.getReturnValue()));
                    component.set("v.estimationDetails",response.getReturnValue());
                    //component.set("v.estimationDetailsList",response.getReturnValue());                
                    
                    var result = response.getReturnValue();
                    /*
                var custs = [];
                var conts = response.getReturnValue();
                for(var key in conts){
                    custs.push({value:conts[key], key:key});
                    for(var k in conts[key]){
                        if(conts[key][k]['ETT_Accept_Quotation__c']==true){
                           // component.set('v.readonly',true);
                        }
                    }
                }
                component.set("v.estimationDetailsList", custs);
                */
                var custs = [];
                var mapArr=[];
                var custKey;
                var i = 0;
                //TU-{!estimation.ETT_Tyre_Size__r.Name}-{!estimation.ETT_Brand__r.ETT_Brand_Code__c}
                for(var key in result){
                    
                    custKey = 'TU-'+result[key]['ETT_Tyre_Size__r']['Name']+result[key]['ETT_Brand__r']['ETT_Brand_Code__c'];
                    console.log(custKey);
                    
                    console.log(JSON.stringify(mapArr));
                    if(!(mapArr.includes(custKey))){
                        var count = 1;
                        mapArr[i] = custKey;    
                        custs.push({key:custKey,value:count});                        
                        console.log(JSON.stringify(custs));
                        i++;
                    }else{
                        
                        for(var k in custs){
                            if(custs[k].key==custKey){
                                var cnt = custs[k].value;
                                cnt++;
                                custs[k].value = cnt;
                                console.log('match found');
                            }
                        }
                        
                    }
                    
                    
                    
                    //console.log(result[key]['ETT_Tyre_Size__r']['Name']);
                    //console.log(result[key]['ETT_Brand__r']['ETT_Brand_Code__c']);
                    
                    if(result[key]['ETT_Accept_Quotation__c']==true){
                        component.set('v.readonly',true);
                    }
                }
                component.set('v.estimationDetailsList',custs);
                //console.log(JSON.stringify(mapArr));
                console.log(JSON.stringify(custs));
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        
                        helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:errors[0].message
                        });
                        
                    }
                }
            }else if (state === "INCOMPLETE") {
                
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:'No response from server or client is offline.'
                });                
                console.log('No response from server or client is offline.');
            }else {
                console.log("Failed with state: " + state);
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:state
                });
            }
        });
            $A.enqueueAction(actSave);
        }
    },
    
    handleSelectAllEstimation: function(component, event, helper) {
        var estimationDetails = component.get("v.estimationDetails");
        var isHOO = component.get("v.isUserHOO");
        var isFM = component.get("v.isUserFM");
        
        var checkEstimation = component.find("checkEstimation");
        for(var i=0; i<estimationDetails.length; i++){
            if(isHOO){
                estimationDetails[i].ETT_Requesting_HOO_For_Accpetence__c = component.get("v.isSelectAll");    
            }if(isFM){
                estimationDetails[i].ETT_Accept_Quotation__c = component.get("v.isSelectAll");    
            }
            
        }
        component.set("v.estimationDetails",estimationDetails);
        
        /*
        var estimationDetailsList = component.get("v.estimationDetailsList");        

        if(estimationDetailsList!=null && estimationDetailsList.length>0){
            for(var i=0;i<estimationDetailsList.length;i++){
                for(var j=0;j<estimationDetailsList[i]['value'].length;j++){
                    estimationDetailsList[i]['value'][j]['ETT_Requesting_HOO_For_Accpetence__c']=component.get("v.isSelectAll"); 
                    //estimationDetails.push(estimationDetailsList[i]['value'][j]);
                }
                    
            }
        }
        component.set("v.estimationDetailsList",estimationDetailsList);
        */
    },
    
    acceptQuotations: function(component,event,helper){
        var estimationDetails = component.get("v.estimationDetails");
       /* var estimationDetailsList = component.get("v.estimationDetailsList");   
        if(estimationDetailsList!=null && estimationDetailsList.length>0){
            for(var i=0;i<estimationDetailsList.length;i++){
                for(var j=0;j<estimationDetailsList[i]['value'].length;j++){
                    estimationDetailsList[i]['value'][j]['sobjectType']='ETT_Estimate_Quotation__c';
                    estimationDetails.push(estimationDetailsList[i]['value'][j]);
                    //console.log(JSON.stringify(estimationDetailsList[i]['value'][j]));    
                }
                    
            }
        }*/
        console.log(JSON.stringify(estimationDetails));
        
        if(estimationDetails!=null && estimationDetails.length>0){
            for(var i=0;i<estimationDetails.length;i++){
                estimationDetails[i].ETT_Accept_Quotation__c = true;
            }
            component.set("v.estimationDetails",estimationDetails);
        }

        var estimationHandle = component.get("c.estimationConfirmation");
        estimationHandle.setParams({
            lstEstimationQuotations:component.get("v.estimationDetails")
        });
        estimationHandle.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('***response details ****'+response.getReturnValue());
                console.log('***response details ****'+JSON.stringify(response.getReturnValue()));
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + response.getReturnValue()
                });
                urlEvent.fire();
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        
                        helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:errors[0].message
                        });
                        
                    }
                }
            }else if (status === "INCOMPLETE") {
                
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:'No response from server or client is offline.'
                });
                
                console.log('No response from server or client is offline.');
            }else {
                console.log("Failed with state: " + state);
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:state
                });
            }
        });
        $A.enqueueAction(estimationHandle);
    }, 
    
    validatePrice: function(component, event, helper){
        
    }
})