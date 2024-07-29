({
    showToast : function (Type,Title,Msg){
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type":Type,
            "title":Title,
            "message":Msg,
            "mode":"dismissible"
        });
        toastReference.fire();
        
    },
    sendEmailToCustomerHelper : function(component, event, helper){
        
     
            let accId =   component.get("v.AccId");
            let email = component.get("v.emailVal");
            let quotationId = component.get("v.recordId");
            let quoteName = component.get("v.QuoteName");
            let tempName = component.get("v.EmailTempDevName");
            console.log(accId +'--'+email+'--'+quotationId+'--'+quoteName+'--'+tempName)
            component.set("v.disableBtn",true);
            
            var action = component.get('c.sendEmailToCustomer');
            action.setParams({ 
                emails:email,
                AccId:accId,
                QuoteId:quotationId,
                EmailTempDevName:tempName,
                QuoteName:quoteName,
                CCEmails:component.get("v.CCVal")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                   helper.showToast('Success','Success','Email has been sent successfully.');
                    
                    $A.get("e.force:closeQuickAction").fire(); //close quick action
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"Error",
                                "title":"Error",
                                "message":errors[0].message,
                                "mode":"dismissible"
                            });
                            toastReference.fire(); 
                        }
                    } else {
                        console.log("Unknown error");
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action);  
            
       
    }
    
})