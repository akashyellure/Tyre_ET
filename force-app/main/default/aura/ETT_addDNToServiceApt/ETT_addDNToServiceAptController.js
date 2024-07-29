({
	doInit : function(component, event, helper) {
        
        helper.getDNDetailsHelper(component, event, helper);
		
	},
    
    addDNProcess : function(component, event, helper) {
        
         var data = component.get("v.dnList");
          let dnList = [];
      
         data.forEach(function(item){
             if(item.isChecked){
					var dn = new Object();
                    dn.sobjectType = 'ETT_Delivery_Note__c';
                    dn.Id = item.Id;
                    dn.Tyre_Service_Appointment__c =component.get("v.recordId");
                    dnList.push(dn);
             }
         });
       
        if(dnList.length > 0){
            component.set("v.showSpinner",true);
            var action = component.get('c.updateDNDetails');
            
            action.setParams({
                dnList : dnList            
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                component.set("v.showSpinner",false);
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
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
                    "title": "Error",
                    "type": "Error",
                    "message":"Select atleast one record."
                });
        }
        
    },
    
     handleSelectAll : function(component, event, helper){
        
        var isSelectAll = component.get("v.isSelectAll");
        var data = component.get("v.dnList");
        
        if(isSelectAll){
            data.forEach(function(item){item.isChecked = true});
            
        }else{
            data.forEach(function(item){item.isChecked = false});
        }
        component.set("v.dnList",data);
    },
})