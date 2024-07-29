({
	doInit : function(component, event, helper) {
        
         var action = component.get('c.getAllCloseLines');
      
       action.setParams({
           JobCardCloseId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
               let ToolMasIDVsFactorStck = new Map();
               let JobLineIDVsIssQty = new Map();
                
                data.forEach(function(item){
                    
                    ToolMasIDVsFactorStck.set(item.Item_Name__c,item.Item_Name__r.ETT_Allocated_Units__c);
                    
                    if(!JobLineIDVsIssQty.has(item.Id)){
                        JobLineIDVsIssQty.set(item.Item_Name__c,item.Issued_Quantity__c);
                    }else{
                        
                        JobLineIDVsIssQty.set(item.Item_Name__c,item.Issued_Quantity__c+JobLineIDVsIssQty.get(item.Item_Name__c));
                    }
                   // if(item.Issued_Quantity__c > item.Item_Name__r.ETT_Allocated_Units__c)
                    
                });
                
                JobLineIDVsIssQty.forEach((val,key)=>{
                    //console.log(val+'-'+key)
                    if(ToolMasIDVsFactorStck.get(key) < val){
                       
                       component.set("v.errFlag",true);
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
		
	},
    handleSubmit : function(component, event, helper) {
       
        if(component.get("v.errFlag")){
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Error",
                "title":"Error",
                "message":"Factor stock is not available for Job card close",
                "mode":"dismissible"
            });
            toastReference.fire();
        }else {
            
            helper.submitToApprovalPrcsHelper(component, event, helper);
        }
     }
})