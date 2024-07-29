({
    doInit : function(component, event, helper) {
        
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        
        if(custLabelsFM.includes(userId)){
            component.set('v.isUserFM',true);
        }
        if(custLabelsHOO.includes(userId)){
            component.set('v.isUserHOO',true);
        }
        
        var action = component.get('c.getNewTyreDetailsfromIC'); 
        action.setParams({
            "recordId":component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                console.log(JSON.stringify(result));
                if(result==null){
                    component.set('v.noPendingItem',true);
                }else{
                    component.set('v.lstTyreMaster',result);
                }

            }else{
                console.log('error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    Approve : function(component, event, helper) {

        var lstTyreMaster = component.get('v.lstTyreMaster');
        var newTyreMasterArr = [];
        if(lstTyreMaster!=null && lstTyreMaster.length>0){
            for(var i=0;i<lstTyreMaster.length;i++){
                
                if('ETT_Status__c' in lstTyreMaster[i]){
                    newTyreMasterArr.push(lstTyreMaster[i]);
                }
            }
        }

        console.log(JSON.stringify(newTyreMasterArr));
        
        var action = component.get('c.approveNewTyres'); 
        var mapNameForStagingObjects = {
            "lstTyreMasterJson":JSON.stringify(newTyreMasterArr)
        };
        action.setParams({
            "mapofStageJsonList":mapNameForStagingObjects
        });
        action.setCallback(this, function(a){
            
            var state = a.getState(); 
            console.log(state);
            
            if(state == 'SUCCESS') {
                
                var result = a.getReturnValue();
                component.set('v.noPendingItemforApproval',true);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
                
            }else{
                console.log('error');
            }
            
        });
        $A.enqueueAction(action);

    }
    
})