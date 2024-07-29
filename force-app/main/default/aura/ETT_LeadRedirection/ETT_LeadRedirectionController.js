({
    doInit: function(component, event, helper) {
        
        var ettyre = $A.get("{!$Label.c.ET_Tyre}");
        var ETT_Cash_Tyre_Supplier = $A.get("{!$Label.c.ETT_Cash_Tyre_Supplier}");
        var ETT_Tyre_Cash_Individual = $A.get("{!$Label.c.ETT_Tyre_Cash_Individual}");
        var ETT_Tyre_Refurbishing_Services = $A.get("{!$Label.c.ETT_Tyre_Refurbishing_Services}");
        var ETT_Refurbished_Tyre_Sales = $A.get("{!$Label.c.ETT_Refurbished_Tyre_Sales}");
        var ETT_Credit_B2B_Tyre_Supplier = $A.get("{!$Label.c.ETT_Credit_B2B_Tyre_Supplier}");
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        
        console.log('recordTypeId: '+recordTypeId);
        //alert('Test');

        /*
        if(ETT_Cash_Tyre_Supplier==recordTypeId){
            
            
            //Redirect to Lead Supplier Form
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:ETT_LeadSupplierForm",
                componentAttributes: {    
                    selectedRecordId : recordTypeId
                },
                isredirect : true
            });
            evt.fire();
            
       // window.location.reload();            
        }else if(ETT_Tyre_Cash_Individual==recordTypeId){
            
            //Redirect to Lead Supplier Form
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:ETT_LeadIndividualForm",
                componentAttributes: {    
                    selectedRecordId : recordTypeId
                },
                isredirect : true
            });
            evt.fire();
        }else if(ETT_Tyre_Refurbishing_Services==recordTypeId){

            //Redirect to Lead Service Form
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:ETT_LeadFormComponent",
                componentAttributes: {    
                    selectedRecordId : recordTypeId
                },
                isredirect : true
            });
            evt.fire();
            
        }else if(ETT_Credit_B2B_Tyre_Supplier==recordTypeId){
            
            //Redirect to Community Portal 
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                //componentDef : "c:ETT_SiteRegistrationForm",
                componentDef : "c:ETT_Lead_Credit_B2B_Tyre_Supplier",
                componentAttributes: {    
                    selectedRecordId : recordTypeId
                },
                isredirect : true
            });
            evt.fire();
            
        }else{
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "Lead",
                "recordTypeId": recordTypeId,
                "panelOnDestroyCallback": function(event) {
                   // "isredirect": true
                }
            });
            createRecordEvent.fire();
        }
        */
        
    },
})