({
    doInit : function(component, event, helper) {
        helper.fetchPickListVal(component, "ETT_Process_Type__c", "processTypeMap");
    },
    handleProcessOnChange : function(component, event, helper) {
        console.log(component.get('v.newLead.ETT_Process_Type__c'));
        var processType = component.get('v.newLead.ETT_Process_Type__c');
        //var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        
        var recordTypeId;
        
        if(processType == 'Tyre - Cash Supplier'){
            recordTypeId = $A.get("{!$Label.c.ETT_Cash_Tyre_Supplier}");      
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:ETT_LeadSupplierForm",
                componentAttributes: {    
                    selectedRecordId : recordTypeId
                }
            });
            evt.fire();
        }
        if(processType == 'Tyre Refurbishing Services'){
            recordTypeId = $A.get("{!$Label.c.ETT_Tyre_Refurbishing_Services}");
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:ETT_LeadFormComponent",
                componentAttributes: {    
                    selectedRecordId : recordTypeId
                }
            });
            evt.fire();
        }        
        if(processType == 'Tyre - Credit/B2B Supplier'){
            recordTypeId = $A.get("{!$Label.c.ETT_Credit_B2B_Tyre_Supplier}");  
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:ETT_Lead_Credit_B2B_Tyre_Supplier",
                componentAttributes: {    
                    selectedRecordId : recordTypeId
                }
            });
            evt.fire();
        }
        if(processType == 'Tyre Cash Individual'){
            recordTypeId = $A.get("{!$Label.c.ETT_Tyre_Cash_Individual}");  
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:ETT_LeadIndividualForm",
                componentAttributes: {    
                    selectedRecordId : recordTypeId
                }
            });
            evt.fire();
        }
        
        
        
        
        
        
    }
})