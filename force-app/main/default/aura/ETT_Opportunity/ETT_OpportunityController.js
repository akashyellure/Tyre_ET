({
    doInit : function(component,event,helper){
        helper.getRecordTypes(component,event,helper);        
    },
    optionSelected : function(component,event,helper){
        component.set("v.loading",true);
        var recordName = event.target.getAttribute("value");
        var recordTypes = component.get("v.availableRecordTypes");
        
        console.log(JSON.stringify(recordName));
        console.log(JSON.stringify(recordTypes));
        
        for(var i=0;i<recordTypes.length;i++){
            if(recordName==recordTypes[i].value){   
                component.set("v.recordTypeId",recordTypes[i].key);
                
                console.log(recordTypes[i].key);
                
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Opportunity",
                    "recordTypeId":recordName,
                    "defaultFieldValues":{
                        "StageName":"Qualification",
                        "AccountId" : component.get("v.recordId")
                    }
                    
                });
                createRecordEvent.fire();
                
                
                
                break;
            }
        }
    }
})