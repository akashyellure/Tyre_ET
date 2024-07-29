({
	doInit : function(component, event, helper) {
        component.set("v.showJobView_Buffing",false);
        component.set("v.showJobView_Skiving",false);
        component.set("v.showJobView_Repair",false);
        component.set("v.showJobView_Cementing",false);
        component.set("v.showJobView_ThreadPreparation",false);
        component.set("v.showJobView_Filling",false);
        component.set("v.showJobView_Building",false);
        component.set("v.showJobView_RimmingEnveloping",false); 
        component.set("v.showJobView_Curing",false);         
        
        
        helper.getJobList(component, event, helper);
        //This helper method has been made to refresh every 10s after checking if no popu up appears - Enable when needed
        window.setInterval(
            $A.getCallback(function() {
                var showJobView_Buffing=component.get("v.showJobView_Buffing");
                var showJobView_Skiving=component.get("v.showJobView_Skiving");
                var showJobView_Repair=component.get("v.showJobView_Repair");
                var showJobView_Cementing=component.get("v.showJobView_Cementing");
                var showJobView_ThreadPreparation=component.get("v.showJobView_ThreadPreparation");
                var showJobView_Filling=component.get("v.showJobView_Filling");
                var showJobView_Building=component.get("v.showJobView_Building");
                var showJobView_RimmingEnveloping=component.get("v.showJobView_RimmingEnveloping");                
                var showJobView_Curing=component.get("v.showJobView_Curing");                                
                
                
                if(!showJobView_Buffing && !showJobView_Skiving && !showJobView_Repair && !showJobView_Cementing && !showJobView_ThreadPreparation && !showJobView_Filling && !showJobView_Building && !showJobView_RimmingEnveloping && !showJobView_Curing){
                    //helper.getJobList(component, event, helper);
                }
            }), 50000 //10000
        );
	},
    
    handleClick : function(component, event, helper) {
        var validJobCardList = component.get("v.validJobCardWrapper.validJobCardList");
        var ids = [];
        var j=0;
        //component.set("v.selectedIds",'');
        var selectedIds  = component.get("v.selectedIds");
        for(var i=0;i<validJobCardList.length;i++){
            if(validJobCardList[i].ETT_Is_Valid_For_Curing__c==true){
                selectedIds.push({'Id':validJobCardList[i].Id});
                ids[j] = validJobCardList[i].Id;
                j++;
            }
        }
        component.set("v.selectedIds",ids);
        //component.set("v.selectedIds",selectedIds);
        console.log(JSON.stringify(component.get("v.selectedIds")));
        
        var compEvent = component.getEvent("sampleComponentEvent");
        
        compEvent.setParams({
            "jobCardIds" : component.get("v.selectedIds") 
        });
        compEvent.fire();
        
    }
    
})