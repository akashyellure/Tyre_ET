({
    doInit : function(component, event, helper) {
        helper.getPicklistValueHelper(component, event, helper);
    },
    
    getJobCardDetails :function(component, event, helper) {
        
        
        var action = component.get('c.getJobCardRealtedDetails');
        
        action.setParams({
            jobCardId:component.get("v.jobCardId").toString()
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                component.set("v.jobCardInfo",response.getReturnValue());
                helper.getJobTypeHelper(component, event, helper);
                helper.getAllUsedItemsHelper(component, event, helper);
                helper.getEnvelopeDetails(component, event, helper);
                helper.getCuringDetails(component, event, helper);
               	helper.getBuffingDetails(component, event, helper);
                
                let data = response.getReturnValue();
                 if(data){
                   
                     if((data.ETT_Overall_Status__c =='Accepted' || data.ETT_Overall_Status__c =='Rejected') && data.ETT_Stages__c=='Quality Control'){
                         component.set("v.ProdtnStatus", "Produced");
                     }else{
                         component.set("v.ProdtnStatus",'In Progress');
                     }
                }
               // console.log(data)
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
    handleChangeProcess : function(component, event, helper) {
        
        var selectedOptionValue = event.getParam("value");
        
        //console.log(selectedOptionValue)
        component.set("v.selectedJobProcss",selectedOptionValue);
        if(selectedOptionValue){
            let reqData =component.get("v.allItemsList");
            var tempdata= [];
            
            tempdata = reqData.filter(function(item){
                return (item.ETT_Job_Stage__c.indexOf(selectedOptionValue) !== -1)
            });
            if(tempdata){
                component.set("v.filterItemsList",tempdata);
            }
        }
       //console.log(component.get("v.filterItemsList"))
                
    },
    handleAddItem : function(component, event, helper) {
        component.set("v.showModel",true);
       
    },
    closeModel : function(component, event, helper) {
        component.set("v.showModel",false);
         //Set all values to null
        component.set("v.issuedQty",null);
        component.set("v.toolMasterId",null);
        component.set("v.selectedJobProcss",'Buffing');//set to default value
    },
    saveJCCloseLine:function(component, event, helper) {
        
        let issuedQty = component.get("v.issuedQty");
        let toolMasterId = component.get("v.toolMasterId");
        let selectedJobProcss = component.get("v.selectedJobProcss");
        let jcclines = component.get("v.newJobCardCloseLines");
        let indUnitVal = component.get("v.tempIndiUnitVal");
        let cost = issuedQty*indUnitVal;
        //console.log(issuedQty+'='+toolMasterId+'='+selectedJobProcss)
        //console.log(jcclines)
        try{ 
        let JClines = new Object();
        JClines.sobjectType = 'ETT_Job_Card_Close_Lines__c';
        JClines.Item_Name__c = toolMasterId;
        JClines.Issued_Quantity__c = issuedQty;
        JClines.Job_Type__c=selectedJobProcss;
        JClines.Unit_Cost__c= indUnitVal;
        JClines.Cost__c=  ((cost !=null) ? cost : '0') ;
        JClines.UOM__c=  component.get("v.tempUOM");
        JClines.Available_Quantity__c=component.get("v.tempAvailQty");
        JClines.ETT_Unique_Code__c= component.get("v.tempItemCode");
        JClines.ETT_Item_Description__c= component.get("v.tempItemDesc");
        
        jcclines.push(JClines);
            
        component.set("v.newJobCardCloseLines",jcclines);
       //Set all values to null
        component.set("v.issuedQty",null);
        component.set("v.toolMasterId",null);
        component.set("v.selectedJobProcss",'Buffing');//set to default value
        component.set("v.showModel",false);
            
        }catch(e){
            console.log(e.message)
        }
    },
    
    toolmasterChange : function(component, event, helper) {
        let toolMasterId = component.get("v.toolMasterId");
        
        var action = component.get('c.getToolMasterInfo');
      
        action.setParams({
              toolMasId:toolMasterId.toString()
             
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
              
                 let data = response.getReturnValue();
               
                if(data){  
                    if(data.UOM__c){
                        component.set("v.tempUOM",data.UOM__c);
                    }else{
                        component.set("v.tempUOM",null);
                    }
                     
                    if(data.ETT_Main_Stock_Units__c){                      
                        component.set("v.tempAvailQty",data.ETT_Main_Stock_Units__c);
                    }else{
                        component.set("v.tempAvailQty",null);  
                    }
                    if(data.ETT_Unique_Code__c){
                        component.set("v.tempItemCode",data.ETT_Unique_Code__c);
                    }else{
                        component.set("v.tempItemCode",null);  
                    }
                    if(data.ETT_Item_Description__c){
                        component.set("v.tempItemDesc",data.ETT_Item_Description__c);
                    }else {
                        component.set("v.tempItemDesc",null);
                    }
                    if(data.ETT_Individual_Unit_Value__c){
                     component.set("v.tempIndiUnitVal",data.ETT_Individual_Unit_Value__c);
                    }else {
                        component.set("v.tempIndiUnitVal",null);
                    }
                    
                    
                }
               
            }else if (state === "ERROR") {
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
    removeLine : function(component, event, helper) {
        
        var index = event.currentTarget.dataset.index;
        var removeList = component.get("v.newJobCardCloseLines");
        removeList.splice(index, 1);
        
        component.set("v.newJobCardCloseLines",removeList);
    },
    handleSubmit : function(component, event, helper) {
        
        let jobCardId = component.get("v.jobCardId");
       
       if(jobCardId){
     
         component.find('JobCardCloseForm').submit();
            
       }else{
           helper.showToastMsg('Error','Error','Please select Job Card');
       }
    },
    HanldeJobCloseSuccess : function(component, event, helper) {
        
       let jcclines = component.get("v.newJobCardCloseLines"); //Get newly added items
       let  lines=  component.get("v.allItemsList");//Get Exisiting Items related to selected Job card
       
        lines.forEach(function(item){
            let cost = item.ETT_Usage_Value__c*item.ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Individual_Unit_Value__c;

            let JClines = new Object();
            JClines.sobjectType = 'ETT_Job_Card_Close_Lines__c';           
            JClines.Item_Name__c = item.ETT_Tools_Material_Allocation__r.ETT_Tools_Master__c;
            JClines.Issued_Quantity__c =item.ETT_Usage_Value__c;
            JClines.Job_Type__c=item.ETT_Job_Stage__c;
            JClines.Unit_Cost__c=  item.ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Individual_Unit_Value__c;
            JClines.Cost__c=  ((cost !=null) ? cost : '0') ;
            JClines.UOM__c= item.ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.UOM__c;
            JClines.Available_Quantity__c=item.ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Main_Stock_Units__c;
            JClines.ETT_Unique_Code__c= item.ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Unique_Code__c;
            JClines.ETT_Item_Description__c= item.ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Item_Description__c;
             
            jcclines.push(JClines); //add to newly added items list
            
       
        });
        component.set("v.newJobCardCloseLines",jcclines);
       // console.log(component.set("v.newJobCardCloseLines"))
       helper.createJCcloseLinesUnderJCHelper(component, event, helper);
    }
})