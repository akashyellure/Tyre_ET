({
    doInit : function(component, event, helper) {
        
        
        var supplierRecordType = $A.get("$Label.c.ETT_QuotationSupplier");
        var stagingQuotationRequest = component.get("v.stagingQuotationRequest");
        stagingQuotationRequest.push({
            sobjectType: "ETT_Staging_Quotation_Request__c",
            ETT_Quantity__c: 1,
            ETT_Purchase_Price__c: 0,
            ETT_Tyre_Size_Master__c: null,
            ETT_Brand__c: null,
            ETT_Country__c: null,
            ETT_Pattern__c: null,
            RecordTypeId: supplierRecordType,
            ETT_New_Tyre_Size__c: "",
            Opportunity__c:component.get("v.recordId"),
            ETT_New_Brand__c: "",
            ETT_New_Pattern__c: "",
            ETT_New_Country__c: ""
        });
        component.set("v.stagingQuotationRequest", stagingQuotationRequest);
        
        let tempTyreDetails = component.get("v.tempTyreMasterInfo");
        
        var tyreInfo = new Object();
        tyreInfo.sobjectType = 'ETT_Tyre_Master__c';
        tyreInfo.ETT_Tyre_Sizes__c=null;
        tyreInfo.ETT_Country__c=null;
        tyreInfo.ETT_Brand__c=null;
        tyreInfo.ETT_Pattern__c=null;
        tyreInfo.Opportunity__c=component.get("v.recordId");
        tempTyreDetails.push(tyreInfo);
        component.set("v.tempTyreMasterInfo",tempTyreDetails);
        
        helper.fetchPickListVal(component, "ETT_Tyre_Life__c", "tyreLife");
    },
    addNewRowQuotationRequest: function(component, event, helper) {
        
        component.set("v.TyreSizeName", '');
        component.set("v.BrandName", '');
        component.set("v.PatternName", '');
        component.set("v.CountryName", '');
        
        
        var addRowInList = component.get("v.stagingQuotationRequest");
        var quotationObj = new Object();
        
        quotationObj.ETT_Quantity__c = 1;
        quotationObj.Opportunity__c= component.get("v.recordId");
        var supplierRecordType = $A.get("$Label.c.ETT_QuotationSupplier");
        
        quotationObj.RecordTypeId = supplierRecordType;
        addRowInList.push(quotationObj);
        component.set("v.stagingQuotationRequest", addRowInList);
        component.set("v.TyreSizeName",'');
        component.set("v.BrandName",'');
        component.set("v.PatternName",'');
        component.set("v.CountryName",'');
    },
    removeRowQuotationRequest: function(component, event, helper) {
        var whichOne = event.target.getAttribute("id");
        var AllRowsList = component.get("v.stagingQuotationRequest");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingQuotationRequest", AllRowsList);
    },
    
    handleSubmit:function(component, event, helper) {
        debugger;
        try{
            var stagingQuotationRequest = component.get("v.stagingQuotationRequest");
            let tyreInfo = component.get("v.tempTyreMasterInfo");
            
            var NewTyreHasError = false;
            var QuotHasError = false;
            
            if(stagingQuotationRequest){
                
                for(var i=0;i<stagingQuotationRequest.length;i++){
                    if((stagingQuotationRequest[i].ETT_Tyre_Size_Master__c==null || 
                        stagingQuotationRequest[i].ETT_Tyre_Size_Master__c=='') /* &&
                       (stagingQuotationRequest[i].ETT_Brand__c==null ||
                        stagingQuotationRequest[i].ETT_Brand__c=='') &&
                       (stagingQuotationRequest[i].ETT_Country__c==null ||
                        stagingQuotationRequest[i].ETT_Country__c=='') &&
                       (stagingQuotationRequest[i].ETT_Pattern__c==null ||
                        stagingQuotationRequest[i].ETT_Pattern__c=='')*/){
                        QuotHasError = true;
                        
                        
                    }
                }
                
            }  
            
            if(tyreInfo){
                tyreInfo.forEach(function(item){
                    
                    if(item.ETT_Tyre_Sizes__c==null &&
                       item.ETT_Brand__c==null &&
                       item.ETT_Country__c==null){
                        NewTyreHasError = true;
                        
                    }
                });
                
            }
            if(QuotHasError && NewTyreHasError){
                
                helper.showErrorToast({
                    title: "Required: Supplier Price Agreement or New Tyre Details",
                    type: "error",
                    message:"Please enter Supplier Price Agreement/New Tyre Details"
                });   
            } 
            
            if(!QuotHasError){
                if (stagingQuotationRequest != null && stagingQuotationRequest.length > 0) {
                    for (var i = 0; i < stagingQuotationRequest.length; i++) {
                        
                        if(component.get("v.TyreSizeName") == 'New' && stagingQuotationRequest[i].ETT_New_Tyre_Size__c == ''){
                            QuotHasError = true;
                            helper.showErrorToast({
                                title: "Required",
                                type: "error",
                                message: "Please enter Tyre Size"
                            });
                            return false;
                        }
                       /* if(component.get("v.BrandName") == 'New' && stagingQuotationRequest[i].ETT_New_Brand__c == ''){
                            QuotHasError = true;
                            helper.showErrorToast({
                                title: "Required",
                                type: "error",
                                message: "Please enter Brand Name"
                            });
                            return false;
                        }
                        if(component.get("v.PatternName") == 'New' && stagingQuotationRequest[i].ETT_New_Pattern__c == ''){
                            QuotHasError = true;
                            helper.showErrorToast({
                                title: "Required",
                                type: "error",
                                message: "Please enter Pattern Name"
                            });
                            return false;
                        }
                        if(component.get("v.CountryName") == 'New' && stagingQuotationRequest[i].ETT_New_Country__c == ''){
                            QuotHasError = true;
                            helper.showErrorToast({
                                title: "Required",
                                type: "error",
                                message: "Please enter Country Name"
                            });
                            return false;
                        }   */              
                        
                        
                        if (stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == null &&
                            stagingQuotationRequest[i].ETT_Brand__c == null &&
                            stagingQuotationRequest[i].ETT_Country__c == null &&
                            stagingQuotationRequest[i].ETT_Pattern__c == null ) {
                            stagingQuotationRequest.splice(i, 1);
                        }
                        
                        if (stagingQuotationRequest[i].ETT_Tyre_Size_Master__c != null) {
                            if (stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == "" ||
                                stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == null ) {
                                QuotHasError = true;
                                helper.showErrorToast({
                                    title: "Required",
                                    type: "error",
                                    message: "Quantity,Tyre Size Fields are required"
                                });
                                return false;
                            }
                        }
                        
                        
                        if (stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == null ||
                            stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == ''  /*||
                            stagingQuotationRequest[i].ETT_Brand__c == null ||
                            stagingQuotationRequest[i].ETT_Brand__c == '' ||                    
                            stagingQuotationRequest[i].ETT_Country__c == null ||
                            stagingQuotationRequest[i].ETT_Country__c == '' ||
                            stagingQuotationRequest[i].ETT_Pattern__c == null ||
                            stagingQuotationRequest[i].ETT_Pattern__c == '' */){
                            QuotHasError = true;
                            helper.showErrorToast({
                                title: "Required:Supplier Price Agreement",
                                type: "error",
                                message: "Tyre Size are required fields" //, Brand, Pattern, Country
                            });
                            return false;
                        }
                    }
                }
            } 
            var stgQuotationJson = JSON.stringify(stagingQuotationRequest);
            
            
            //console.log(stgQuotationJson);
            
            //Check duplicates Start
            var uniqueArray = [];
            if (stagingQuotationRequest != null && stagingQuotationRequest.length > 0) {
                for (var i = 0; i < stagingQuotationRequest.length; i++) {
                    var combin =
                        stagingQuotationRequest[i].ETT_Tyre_Size_Master__c +
                        "#" +
                        stagingQuotationRequest[i].ETT_Country__c +
                        "#" +
                        stagingQuotationRequest[i].ETT_Brand__c +
                        "#" +
                        stagingQuotationRequest[i].ETT_Pattern__c +
                        "#";
                    
                    if(uniqueArray.indexOf(combin) > -1) {
                        QuotHasError = true;
                        helper.showErrorToast({
                            title: "Error: Supplier Price Agreement",
                            type: "error",
                            message:
                            "Tyre Size, Country, Brand, Pattern should be unique for every record"
                        });
                        return false;
                    } else {
                        uniqueArray.push(combin);
                    }
                }
            }
            //Check duplicates Stop 
            // --Add new Tyre logic start
            
            
            if(!NewTyreHasError){
                
                tyreInfo.forEach(function(item){
                    
                    if(!item.ETT_Tyre_Sizes__c && !item.ETT_Brand__c && !item.ETT_Country__c){
                        NewTyreHasError = true;
                        helper.showErrorToast({
                            title: "Required: ",
                            type: "error",
                            message:
                            "Please Enter Tyre Details."
                        });
                        
                    }
                    
                    if(item.ETT_Tyre_Sizes__c==null || item.ETT_Tyre_Sizes__c==''||
                       item.ETT_Brand__c==null ||item.ETT_Brand__c==''||
                       item.ETT_Country__c==null || item.ETT_Country__c==''){
                        NewTyreHasError = true;
                        helper.showErrorToast({
                            title: "Required:New Tyre Details ",
                            type: "error",
                            message:
                            "Please Enter Tyre Size, Brand and Country."
                        });
                        
                    }
                });
            }
            //Add new Tyre logic End
            
            if(!NewTyreHasError || !QuotHasError){
                
                component.set("v.showSpinner",true);
                let finalTyreInfo=[];
                let finalStagQuot=[];
                
                stagingQuotationRequest.forEach(function(item){
                    
                    if(item.ETT_Tyre_Size_Master__c != null){
                        
                        finalStagQuot.push(item);
                    }
                    
                });
                
                tyreInfo.forEach(function(item){ //to remove blank new tyre one 
                    
                    if(item.ETT_Tyre_Sizes__c != null){
                        finalTyreInfo.push(item);
                    }
                });                
                
                var action = component.get('c.createStagingQuotation');
               // console.log(finalStagQuot)
                //console.log(finalTyreInfo)
               action.setParams({
                    recordId:component.get("v.recordId"),
                    staginQuoteList : finalStagQuot,
                    tyreNewList:finalTyreInfo
                    
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (state === "SUCCESS") {  
                        let data = response.getReturnValue();
                        component.set("v.showSpinner",false);                
                        
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire();
                        
                        helper.showErrorToast({
                            title: "Success",
                            type: "success",
                            message:"Request has been submitted for Approval"
                            
                        });
                        
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                component.set("v.showSpinner",false);  
                                console.log("Error message: " + errors[0].message);
                                helper.showErrorToast({
                                    title: "Error:Unable to complete",
                                    type: "error",
                                    message:errors[0].message
                                    
                                });
                            }
                        } else {
                            component.set("v.showSpinner",false);  
                            console.log("Unknown error");
                            
                        }
                    }
                }); 
                
                $A.enqueueAction(action);
            }  
        }catch(e){
            
            console.log(e.message);
        }
        
    },
    
    addNewRowsIntoTyreMaster : function(component, event, helper){
        var addRowInList = component.get("v.tempTyreMasterInfo");
        var tyreInfo = new Object();
        tyreInfo.sobjectType = 'ETT_Tyre_Master__c';
        tyreInfo.ETT_Tyre_Sizes__c=null;
        tyreInfo.ETT_Country__c=null;
        tyreInfo.ETT_Brand__c=null;
        tyreInfo.ETT_Pattern__c=null;
        tyreInfo.Opportunity__c=component.get("v.recordId");
        addRowInList.push(tyreInfo);
        component.set("v.tempTyreMasterInfo",addRowInList);
    },
    removeRowsIntoTyreMaster : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.tempTyreMasterInfo");
        
        AllRowsList.splice(whichOne, 1);
        component.set("v.tempTyreMasterInfo", AllRowsList);
    },
    
    convertCase: function(component, event, helper){
        var val = event.getSource().get("v.value");
        if(val!=null)
        {
            val = val.toUpperCase();
            var selectCmp = event.getSource();
            selectCmp.set("v.value",val) ;  
        }
        
    },
    handleComponentEvent : function(component, event, helper){
        var name = event.getParam("name");
        var index = event.getParam("index");
        var dynamicId = event.getParam("dynamicId");
        var objectName = event.getParam("objectName");
        
        
        if (objectName == "ETT_Tyre_Size_Master__c") {
            
            
            component.set("v.TyreSizeName", name);
            
            
        } else if (objectName == "ETT_Brand_Master__c") {
            
            
            
            component.set("v.BrandName", name);
            
            
        } else if (objectName == "ETT_Pattern_Master__c") {
            
            
            component.set("v.PatternName", name);
            
            
        } else if (objectName == "ETT_Country_Master__c") {
            
            
            component.set("v.CountryName", name);
            
            
        }
    },
    
})