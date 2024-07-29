({
	getInspectionCardHistory : function(component, event, helper) {
		var action = component.get("c.getJobCardStageHistoryInfo");
       
        action.setParams({
            jobCardId: component.get("v.jobCardId"),
            inspectionCardId: component.get("v.inspectionCardId"),
            currentStageName: component.get("v.currentStageName"),
            currentRevisionNumber: component.get("v.currentRevisionNumber")
        });
       
           
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
               
                component.set("v.history",response.getReturnValue());
                console.log(JSON.stringify(response.getReturnValue()))
                
            }else if(response.getState() == "ERROR"){
                var errors = response.getError();   
                console.log(JSON.stringify(errors[0].message));
                
            }else{
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
    getJobCardHistory : function(component, event, helper) {
        
        var action = component.get('c.getJobCardDetails');
        action.setParams({
            jobCardId: component.get("v.jobCardId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                component.set("v.jobCardDetials",data);
                
                let stagelist = data.ETT_Job_Stages_to_Perform_Ordered__c.split(';');
                stagelist.forEach(function(item,index){
                    if(item == data.ETT_Stages__c){
                        component.set("v.sequenceNumber",index);
                        console.log('---Stageindex--'+index+'--'+data.ETT_Stages__c)
                    }                    
                });
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