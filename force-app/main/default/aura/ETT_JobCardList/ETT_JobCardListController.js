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
        component.set("v.showJobView_FinalInspection",false);         
        component.set("v.showJobView_RemovalOfRIMTubeFlap",false);                 
        component.set("v.showJobView_Painting",false);                 
        component.set("v.showJobView_QualityControl",false);                         
        
        
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
                var showJobView_FinalInspection=component.get("v.showJobView_FinalInspection");                                
                var showJobView_RemovalOfRIMTubeFlap=component.get("v.showJobView_RemovalOfRIMTubeFlap");
                var showJobView_Painting=component.get("v.showJobView_Painting");
                var showJobView_QualityControl=component.get("v.showJobView_QualityControl");
                
                
                if(!showJobView_Buffing && !showJobView_Skiving && !showJobView_Repair && !showJobView_Cementing && !showJobView_ThreadPreparation && !showJobView_Filling && !showJobView_Building && !showJobView_RimmingEnveloping && !showJobView_Curing && !showJobView_RemovalOfRIMTubeFlap && !showJobView_Painting && !showJobView_QualityControl){
                    helper.getJobList(component, event, helper);
                }
            }),  20000 //50000
        );
	},
    openJobDetail: function(component, event, helper){
        component.set("v.showJobView_Buffing",false);
        component.set("v.showJobView_Skiving",false);
        component.set("v.showJobView_Repair",false);
        component.set("v.showJobView_Cementing",false);
        component.set("v.showJobView_ThreadPreparation",false);
        component.set("v.showJobView_Filling",false);
        component.set("v.showJobView_Building",false);
        component.set("v.showJobView_RimmingEnveloping",false);        
        component.set("v.showJobView_Curing",false);        
        component.set("v.showJobView_FinalInspection",false);        
        component.set("v.showJobView_RemovalOfRIMTubeFlap",false);                
        component.set("v.showJobView_Painting",false);                
        component.set("v.showJobView_QualityControl",false);                       
        
        
        var jobId = event.getSource().get("v.name");
        component.set("v.selectedJobCardId",jobId);
        var jobWrapper=component.get("v.validJobCardWrapper");
        for(let i in jobWrapper.validJobCardList){
            var jobDet=jobWrapper.validJobCardList[i];
            if(jobId==jobDet.Id){
                if(jobDet.ETT_Stages__c=='Buffing'){
                    component.set("v.showJobView_Buffing",true);
                }
                else if(jobDet.ETT_Stages__c=='Skiving'){
                    component.set("v.showJobView_Skiving",true);
                }
                else if(jobDet.ETT_Stages__c=='Repair'){
                    component.set("v.showJobView_Repair",true);
                }
                else if(jobDet.ETT_Stages__c=='Cementing'){
                    component.set("v.showJobView_Cementing",true);
                }
                else if(jobDet.ETT_Stages__c=='Filling'){
                    component.set("v.showJobView_Filling",true);
                }
                else if(jobDet.ETT_Stages__c=='Thread Preparation'){
                    component.set("v.showJobView_ThreadPreparation",true);
                }
                else if(jobDet.ETT_Stages__c=='Building'){
                    component.set("v.showJobView_Building",true);
                }
                else if(jobDet.ETT_Stages__c=='Rimming & Enveloping'){
                    component.set("v.showJobView_RimmingEnveloping",true);
                }
                else if(jobDet.ETT_Stages__c=='Curing'){
                    component.set("v.showJobView_Curing",true);
                }
                else if(jobDet.ETT_Stages__c=='Final Inspection'){
                    component.set("v.showJobView_FinalInspection",true);
                }
                else if(jobDet.ETT_Stages__c=='Removal of RIM Tube Flap'){
                    component.set("v.showJobView_RemovalOfRIMTubeFlap",true);
                }
                else if(jobDet.ETT_Stages__c=='Painting'){
                    component.set("v.showJobView_Painting",true);
                }
                else if(jobDet.ETT_Stages__c=='Quality Control'){
                    component.set("v.showJobView_QualityControl",true);
                }
            }
        }
        
    }
})