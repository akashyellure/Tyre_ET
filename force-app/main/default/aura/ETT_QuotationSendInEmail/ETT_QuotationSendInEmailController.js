({  
    doInit : function(component, event, helper) {
       
        
    },
    onForceLoad : function(component, event, helper) {
        
        let accid = component.get("v.record.ETT_Account__c");
        component.set("v.AccId",accid);
        component.set("v.QuoteName",component.get("v.record.Name"));
        component.set("v.emailVal",component.get("v.record.Email__c"));
    },
    
    sendEmail :   function(component, event, helper) {
        
        
        let email  = component.get("v.emailVal");
        
        var emailField = component.find("email");
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        if(email){  
            
            if(email.match(regExpEmailformat)){
                 
                emailField.set("v.errors", [{message: null}]);
                 $A.util.removeClass(emailField, 'slds-has-error');
               
                helper.sendEmailToCustomerHelper(component, event, helper);
                
            }else{
                $A.util.addClass(emailField, 'slds-has-error');
                emailField.set("v.errors", [{message: "Please Enter a Valid Email Address"}]);               
            }  
            
            
            
            
        }else {
            $A.util.addClass(emailField, 'slds-has-error');
            emailField.set("v.errors", [{message: "Please Enter a Valid Email Address"}]);
            
        }  
    },
    
})