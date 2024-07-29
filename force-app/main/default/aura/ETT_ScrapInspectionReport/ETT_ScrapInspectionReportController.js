({
    doInit : function(component, event, helper) {
        
        helper.fetchPickListVal(component, "ETT_Tyre_Status__c", "tyreStatusMap");
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.todaysDate',today);
        
        var stagingScrapInspectionList  = component.get("v.stagingScrapInspectionList");          
        
        stagingScrapInspectionList.push({
            'sobjectType': 'ETT_Staging_Scrap_Inspection__c',
            'ETT_Tyre_Size__c': null,
            'ETT_Date__c':today,
            'ETT_Casing_Brand_lookup__c': '',
            'ETT_Original_Tread_Design_lookup__c': '',
            'ETT_Tyre_Serial_Number__c':'',
            'ETT_Tyre_Status__c':'',
            'ETT_Retreaded_Tread_Design_lookup__c':'',
            'ETT_RIB_R_Transaction_T__c':'',
            'ETT_RTD__c':'',     
            'ETT_Pressure__c':'',
            'ETT_Condition_No__c':''
        });
        
        component.set("v.stagingScrapInspectionList", stagingScrapInspectionList);
        
        
    },
    AddNewRow : function(component, event, helper){
        var addRowInList = component.get("v.stagingScrapInspectionList");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingScrapInspectionList",addRowInList);
    },
    removeRow : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingScrapInspectionList");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingScrapInspectionList", AllRowsList);
    },
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    clickCreate : function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var stagingScrapInspectionList  = component.get("v.stagingScrapInspectionList");
        newLead.Id = component.get("v.recordId");        
        
        if(stagingScrapInspectionList!=null && stagingScrapInspectionList.length>0){
            for(var i=0;i<stagingScrapInspectionList.length;i++){
                
                stagingScrapInspectionList[i].ETT_Lead__c = component.get("v.recordId");
                stagingScrapInspectionList[i].ETT_Date__c = component.get("v.todaysDate");                
                
                if(stagingScrapInspectionList[i].ETT_Tyre_Size__c==null || stagingScrapInspectionList[i].ETT_Tyre_Size__c=='' ||
                   stagingScrapInspectionList[i].ETT_Casing_Brand_lookup__c==null || stagingScrapInspectionList[i].ETT_Casing_Brand_lookup__c=='' ||
                   stagingScrapInspectionList[i].ETT_Date__c==null || stagingScrapInspectionList[i].ETT_Date__c=='' ||
                   stagingScrapInspectionList[i].ETT_Tyre_Status__c==null || stagingScrapInspectionList[i].ETT_Tyre_Status__c=='' ||
                   stagingScrapInspectionList[i].ETT_Condition_No__c==null || stagingScrapInspectionList[i].ETT_Condition_No__c=='' ||
                  stagingScrapInspectionList[i].ETT_Action__c==null || stagingScrapInspectionList[i].ETT_Action__c==''){
               
                    helper.showErrorToast({
                            "title": "Required",
                            "type": "error",
                            "message": "Date, Tyre Size, Casing Brand, Tyre Status, Condition, Action Fields are required"
                        });
                        return false;
                        
                }
            }
        }
        
        
        
        var stagingScrapInspectionJSON = JSON.stringify(stagingScrapInspectionList);
        var stgLeadJson = JSON.stringify(newLead);
        
        console.log(stgLeadJson);
        console.log(stagingScrapInspectionJSON);
        
        
        var actSave = component.get("c.saveDML");
        var mapNameForStagingObjects = {"stgLeadJson":stgLeadJson,
                                        "stgScrabInspectionJson":stagingScrapInspectionJSON};
                                        
        actSave.setParams({
            "mapofStageJsonList":mapNameForStagingObjects
        });            
        
        actSave.setCallback(this, function(a){
            
            var state = a.getState();
            console.log('state: '+state);
            
            if(state == 'SUCCESS') {
                
                console.log('SUCCESS: '+a.getReturnValue());
                
                helper.showErrorToast({
                    "title": "Success: ",
                    "type": "success",
                    "message": a.getReturnValue()
                });
                
                $A.get("e.force:closeQuickAction").fire(); 
                
            }else if (state === "INCOMPLETE") {
                // do something
                console.log(state);
            }else if (state === "ERROR") {
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                        helper.showErrorToast({
                            "title": "Required: Contact",
                            "type": "error",
                            "message": errors[0].message
                        });
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                    helper.showErrorToast({
                        "title": "Required: Contact",
                        "type": "error",
                        "message": "Unknown error"
                    });
                }
            }
        });
        $A.enqueueAction(actSave);
        
    }
})