({
	getStagQuotationRequests : function(component, event, helper) {
		
        var action = component.get('c.getAllStagQuotReq');
      
        action.setParams({
            recordId : component.get("v.recordId")           
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
              
                component.set("v.stgQuoteReq",data);
                //if we keep same data "tempData" list, it is affecting by change in "stgQuoteReq",so created new object
                try{
                    let data2 = component.get("v.tempData");
                    data.forEach(function(item){
                        let cc = new Object();
                        cc.sobjectType='ETT_Staging_Quotation_Request__c';
                        cc.ETT_Repair_Price__c =item.ETT_Repair_Price__c;
                        cc.Selling_Procure_Price__c=item.Selling_Procure_Price__c;
                        cc.Selling_Hot_Price__c=item.Selling_Hot_Price__c;
                        cc.ETT_Retread_Procure_Price__c=item.ETT_Retread_Procure_Price__c;
                        cc.ETT_Retread_Hot_Price__c=item.ETT_Retread_Hot_Price__c;
                        data2.push(cc);
                    });
                    component.set("v.tempData",data2);
                }catch(e){
                    console.log(e.message)
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
    fetchPickListVal: function(component, fieldName, elementId) {
        
        var action = component.get("c.getselectOptions");
       
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log(result);
                var opts = [];
               
                    for(var key in result){
                        opts.push({label: key, value: result[key]});
                    }
               
                var el = 'v.'+elementId;
                component.set(el, opts);
                                
            }
        });
        $A.enqueueAction(action);
    },
    getUserDetailHelper :  function(component, event, helper) {
		
        var action = component.get('c.getLoggedUserInfo');
      
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
                if(data.Profile.Name == 'ETT_Head of Operations' ||data.Profile.Name =='System Administrator'){
                   component.set('v.isUserHOO',true);
                }
                if(data.Profile.Name == 'ETT_Factory Manager' ){ //||data.Profile.Name =='System Administrator'
                    component.set('v.isUserFM',true);
                }
                if(data.Profile.Name == 'ETT_Sales Team' ){ 
                    component.set('v.isUserSales',true);
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
    
    getTyreMasterHelper : function(component, event, helper) {
        
        var action = component.get('c.getTyreMasterDetails');
        
        action.setParams({
            recordId : component.get("v.recordId")           
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
                component.set("v.lstTyreMasterDetails",data);
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
    }
})