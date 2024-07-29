({
    doInit : function(component, event, helper) {
        
        helper.getTyreDetialsHelper(component, event, helper);
        
    },
    selectAllDetials :function(component, event, helper) {
        
        let checkCmp = component.find("selectAllId");
        let data = component.get("v.filterData");
        data.forEach(function(item){
            if(checkCmp.get("v.value")){
                item.isChecked = true;
            }else{
                item.isChecked = false;  
            }
        });
        component.set("v.filterData",data);                  
       
    },
    
    filterHandler : function(component, event, helper) {
        try{
        let serialNo = component.get("v.searchVal")?component.get("v.searchVal"):null;
        let tyreSizeVal = component.get("v.tyreSizeVal");
        let brandVal = component.get("v.brandVal")?component.get("v.brandVal").toLowerCase():null;
        let patternVal = component.get("v.patternVal");
        let partyType = component.get("v.partyType");            
        let countryVal = component.get("v.countryVal")?component.get("v.countryVal").toLowerCase():null;
        console.log('serialNo=='+JSON.stringify(serialNo));
        console.log('tyreSizeVal=='+JSON.stringify(tyreSizeVal));
        console.log('brandVal=='+JSON.stringify(brandVal));
           console.log('patternVal=='+JSON.stringify(patternVal));
            console.log('partyType=='+JSON.stringify(partyType));
            console.log('countryVal=='+JSON.stringify(countryVal));
        if(serialNo || tyreSizeVal || brandVal ||patternVal || countryVal || partyType){
            let data = component.get("v.tyreDetails");
            console.log('data=='+JSON.stringify(data));
            let fileredData =  data.filter(function(item) {
                console.log('item.ETT_Brand__r.Name=='+JSON.stringify(item.ETT_Brand__r.Name));
                
                if(serialNo && tyreSizeVal && brandVal && patternVal && countryVal && partyType && item.Party_Type__c){ //  
                    return (item.ETT_Tyre_Size_Master__r.Name.indexOf(tyreSizeVal) !== -1)&&(item.Serial_Number__c.indexOf(serialNo) !== -1)&&(item.ETT_Brand__r.Name.toLowerCase().indexOf(brandVal) !== -1)&& (item.Party_Type__c.indexOf(partyType) !== -1)  && (item.ETT_Pattern__r.Name.indexOf(patternVal) !== -1)&&(item.ETT_Country__r.Name.toLowerCase().indexOf(countryVal) !== -1) ;
                }else if(serialNo && tyreSizeVal && brandVal && patternVal && countryVal){  
                    return (item.ETT_Tyre_Size_Master__r.Name.indexOf(tyreSizeVal) !== -1)&&(item.Serial_Number__c.indexOf(serialNo) !== -1)&&(item.ETT_Brand__r.Name.toLowerCase().indexOf(brandVal) !== -1) && (item.ETT_Pattern__r.Name.indexOf(patternVal) !== -1) && (item.ETT_Country__r.Name.toLowerCase().indexOf(countryVal) !== -1) ;
                }else if(tyreSizeVal && brandVal && patternVal){  
                    return (item.ETT_Tyre_Size_Master__r.Name.indexOf(tyreSizeVal) !== -1)&&(item.ETT_Brand__r.Name.toLowerCase().indexOf(brandVal) !== -1) && (item.ETT_Pattern__r.Name.indexOf(patternVal) !== -1) ;
                }else if(tyreSizeVal && brandVal){  
                    return (item.ETT_Tyre_Size_Master__r.Name.indexOf(tyreSizeVal) !== -1)&&(item.ETT_Brand__r.Name.toLowerCase().indexOf(brandVal) !== -1);
                }else if(tyreSizeVal && patternVal){  
                    return (item.ETT_Tyre_Size_Master__r.Name.indexOf(tyreSizeVal) !== -1)&&(item.ETT_Pattern__r.Name.indexOf(patternVal) !== -1);
                }else if(tyreSizeVal && countryVal){  
                    return (item.ETT_Tyre_Size_Master__r.Name.indexOf(tyreSizeVal) !== -1)&&(item.ETT_Country__r.Name.toLowerCase().indexOf(countryVal) !== -1);
                }else if(partyType && item.Party_Type__c && tyreSizeVal){
                   return (item.Party_Type__c.indexOf(partyType) !== -1)&&(item.ETT_Tyre_Size_Master__r.Name.indexOf(tyreSizeVal) !== -1);
                    
                }else if(partyType && item.Party_Type__c && brandVal){
                   return (item.Party_Type__c.indexOf(partyType) !== -1)&&(item.ETT_Brand__r.Name.toLowerCase().indexOf(brandVal) !== -1);
                    
                }else if(partyType && item.Party_Type__c && patternVal){
                   return (item.Party_Type__c.indexOf(partyType) !== -1)&&(item.ETT_Pattern__r.Name.indexOf(patternVal) !== -1);
                    
                }else if(partyType && item.Party_Type__c && countryVal){
                   return (item.Party_Type__c.indexOf(partyType) !== -1)&&(item.ETT_Country__r.Name.toLowerCase().indexOf(countryVal) !== -1);
                    
                }else if(tyreSizeVal){
                    
                    return (item.ETT_Tyre_Size_Master__r.Name.indexOf(tyreSizeVal) !== -1);
                }else if(brandVal){
                    
                    return (item.ETT_Brand__r.Name.toLowerCase().indexOf(brandVal) !== -1);
                }else if(patternVal){
                    
                    return (item.ETT_Pattern__r.Name.indexOf(patternVal) !== -1);
                }else if(countryVal){
                    
                    return (item.ETT_Country__r.Name.toLowerCase().indexOf(countryVal) !== -1);
                }else if(serialNo){
                    
                    return (item.Serial_Number__c.indexOf(serialNo) !== -1);
                }else if(partyType && item.Party_Type__c){
                    
                    return (item.Party_Type__c.indexOf(partyType) !== -1);
                }else{
                    return false;
                }
                
                
            });
            
            component.set("v.filterData",fileredData);
        }else{
            component.set("v.filterData","");
        }
        }catch(e){
            console.log(e.message)
            console.log("Line number:", e.lineNumber);
        }
    },
    
    AddSelectedLines : function(component, event, helper) {
        try{
            
            let data = component.get("v.filterData");
            
            if(data){
                
                let tempData = [];
                let mainData = component.get("v.tyreDetails");
                //console.log(data.length)
                data.forEach(function(item){
                    
                    if(item.isChecked){
                        tempData.push(item);
                        
                    }
                });
                
                if(tempData.length > 0){
                    let selectedData = component.get("v.selectedTyres");
                    
                    let newSelcVval = selectedData.concat(tempData);
                    
                    component.set("v.selectedTyres",newSelcVval);
                    //Remove selected records from Filter Data      
                    data = data.filter(ar => !tempData.find(rm => (rm.Serial_Number__c==ar.Serial_Number__c) ));
                    component.set("v.filterData",data);
                    //Remove selected records from main Data 
                    mainData = mainData.filter(ar => !tempData.find(rm => (rm.Serial_Number__c==ar.Serial_Number__c) ));
                    component.set("v.tyreDetails",mainData);     
                    //console.log(component.get("v.selectedTyres"));
                }else{
                    helper.showErrorToast({
                        "title": "Warning",
                        "type": "warning",
                        "message":"Select at least one tyre."
                    });
                }
            }else{
                helper.showErrorToast({
                    "title": "Warning",
                    "type": "warning",
                    "message":"Enter Tyre serial no/size to get data"
                });
                
            }
        }catch(e){
            console.log(e.message)
        }
    },
    
    onRemovePill : function(component, event, helper) {
        
        let selPill = event.getSource().get("v.name");
        selPill.isChecked = false;
        let selectedData = component.get("v.selectedTyres");
        
        const removeIndex = selectedData.findIndex( item => item.Serial_Number__c == selPill.Serial_Number__c);
        selectedData.splice(removeIndex, 1 );
        component.set("v.selectedTyres",selectedData);
        
        //Remove selected records from main Data        
        let mainData = component.get("v.tyreDetails");
        mainData.push(selPill);
        component.set("v.tyreDetails",mainData);
        
    },
    createJobCardsHandler : function(component, event, helper) {
        
        let selectedData = component.get("v.selectedTyres");
        
        let customerId = component.get("v.customerId");
        let partyType = component.get("v.partyType");  
        
        if(!customerId && partyType=='Customer'){
            helper.showErrorToast({
                "title": "Warning",
                "type": "warning",
                "message":"Please select customer."
            });
           
        }else if(selectedData.length>0){ 
           
           selectedData.forEach(item => delete item.isChecked);
            
            var action = component.get('c.createJobCards');
            component.set("v.showSpinner",true);
            action.setParams({
                selectedTyres : selectedData,
                customerId : customerId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    component.set("v.showSpinner",false);
                    let data = response.getReturnValue();
                    console.log(data)
                    
                    helper.showErrorToast({
                        "title": "success",
                        "type": "success",
                        "message":"Job cards have been created successfully."
                    });
                    $A.get('e.force:refreshView').fire();
                }else if (state === "ERROR") {
                    
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showErrorToast({
                                "title": "Error",
                                "type": "Error",
                                "message":"You cannot create job card for selected tyres."
                            });
                          
                            console.log("Error message: "+JSON.stringify(errors[0]));
                            component.set("v.showSpinner",false);
                        }
                    } else {
                        console.log("Unknown error");
                        component.set("v.showSpinner",false);
                    }
                }
            }); 
            
            $A.enqueueAction(action);  
            
        }else{
            helper.showErrorToast({
                "title": "Warning",
                "type": "warning",
                "message":"Add tyres to create job cards."
            });
        }
        
    }
})