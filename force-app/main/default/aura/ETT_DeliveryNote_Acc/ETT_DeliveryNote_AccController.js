({
    doInit : function(component, event, helper) {
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.tempDate",today);
        
        helper.getInsCardDetails(component, event, helper);
        helper.getContactDetails(component, event, helper);
    },
    
    filterQuotation : function(component, event, helper){
        
         helper.getInsCardDetails(component, event, helper);
    },
    
    handleSelectAll : function(component, event, helper){
        
        var isSelectAll = component.get("v.isSelectAll");
        var data = component.get("v.insCardList");
        
        if(isSelectAll){
            data.forEach(function(item){item.isChecked = true});
            
        }else{
            data.forEach(function(item){item.isChecked = false});
        }
        component.set("v.insCardList",data);
    },
    
    processSubmitReq :  function(component, event, helper){
       
        try{ 
          
            var data = component.get("v.insCardList");
            console.table(data);
            let dnLineList = [];
            let collCardSet = new Set();
            data.forEach(function(item){
                if(item.isChecked){
                    var dnLine = new Object();
                    dnLine.sobjectType = 'ETT_Delivery_Line_Item__c';
                    dnLine.ETT_Inspection_Card__c = item.objIC.Id;
                    dnLine.Tyre_Inventory__c = item.objIC.Tyre_Inventory__c;
                    dnLine.ETT_Collection_Card__c = item.objIC.ETT_Collection_Card__c;
                    dnLine.Thred_Pattern__c= item.desiredTreadPattern; 
                    dnLine.ETT_Tyre_size_Integration__c= item.objIC.Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name;
                   //dnline.AR_INVOICE_Status__c=item.objIC.ETT_Status__c;
                    dnLine.ETT_Price__c= item.unitPrice;
                    // Set ETT_Job_Type__c based on conditions
                    if (item.objIC.Tyre_Inventory__r.Job_Type__c === 'Retread' && item.objIC.Tyre_Inventory__r.Tyre_Type__c === 'Refurbished') {
                        dnLine.ETT_Job_Type__c = item.objIC.Tyre_Inventory__r.Job_Type__c;
                    } else if (!item.objIC.Tyre_Inventory__r.Job_Type__c === 'Retread' && item.objIC.Tyre_Inventory__r.Tyre_Type__c==='Send Back') {
                        dnLine.ETT_Job_Type__c = item.objIC.Tyre_Inventory__r.Tyre_Type__c;
                    }else if (!item.objIC.Tyre_Inventory__r.Job_Type__c === 'Retread' && item.objIC.Tyre_Inventory__r.Tyre_Type__c==='Scrapped') {
                        dnLine.ETT_Job_Type__c = item.objIC.Tyre_Inventory__r.Tyre_Type__c;
                    }
                    
                    dnLineList.push(dnLine);
                   
                    collCardSet.add(item.objIC.ETT_Collection_Card__r.Name);
                }
              
                console.log('Dn list ',dnLineList);
            });
            
            
            
            var dnHeader = new Object();
            dnHeader.sobjectType = 'ETT_Delivery_Note__c';
            dnHeader.ETT_Account__c = component.get("v.recordId");
            dnHeader.Contact_Person__c = component.get("v.tempName");
            dnHeader.ETT_Address__c = component.get("v.address");
            dnHeader.ETT_Collection_Cards__c = [...collCardSet].join(',');
            dnHeader.ETT_Date__c = component.get("v.tempDate");
            dnHeader.ETT_Phone__c = component.get("v.tempMobNum");
            dnHeader.ETT_Reference__c = component.get("v.reference");
            dnHeader.ETT_Remark__c = component.get("v.remarks");
            
            // console.log(dnLineList)
            //console.log(dnHeaderVal)
            if(dnLineList.length > 0){
                component.set("v.showSpinner",true);
              var action = component.get('c.createDeliveryNote');
                
                action.setParams({
                    dn : dnHeader,
                    dnlines:dnLineList
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (state === "SUCCESS") {  
                        let data = response.getReturnValue();
                        component.set("v.showSpinner",false);
                        helper.showErrorToast({
                            "title": "success",
                            "type": "success",
                            "message":"Your request has been submitted successfully."
                        });
                        
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": data
                            
                        });
                        navEvt.fire();
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                                component.set("v.showSpinner",false);
                                helper.showErrorToast({
                                    "title": "unable to create DN",
                                    "type": "error",
                                    "message":errors[0].message
                                });
                            }
                        } else {
                            console.log("Unknown error");
                            component.set("v.showSpinner",false);
                            
                        }
                    }
                }); 
                
                $A.enqueueAction(action); 
            }else{
                helper.showErrorToast({
                    "title": "Error",
                    "type": "error",
                    "message":"select atleast one record"
                });
            }
        }catch(e){
            console.log(e.message)
        }
    }
})