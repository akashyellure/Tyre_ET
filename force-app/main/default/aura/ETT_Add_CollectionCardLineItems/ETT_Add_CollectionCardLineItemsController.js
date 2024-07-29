({
    doInit : function(component, event, helper) {
        
        var currentUserEmail =  $A.get("$SObjectType.CurrentUser.Id");
        var custLabels = $A.get("$Label.c.ETT_Collection_Card_Access_Users");
        if(custLabels.includes(currentUserEmail)){
            component.set('v.isPriceAccess',true);
        }
        var collectionLineItemList  = component.get("v.lstCollectionLineItem"); 
        collectionLineItemList.push({
            'sobjectType': 'WorkOrderLineItem',
            'ETT_Tyre_Size__c':null,
            'ETT_Tyre_Size_Name__c':'',
            'ETT_Brand__c':'',
            'ETT_Brand_Name__c':'',
            'ETT_Pattern__c':'',
            'ETT_Pattern_Name__c':'',
            'ETT_Country_of_Origin__c':'',
            'ETT_Country_of_Origin_Name__c':'',
            'ETT_Load_Index__c':'',
            'ETT_S_Index__c':'',
            'ETT_PR__c':'',
            'ETT_Tyre_Serial_Number__c':'',
            'ETT_Job_Type__c':'Retread',
            'ETT_Remarks__c':'',
            'ETT_Quantity__c': 0,
            'ETT_Tyre_Life__c':'1',
            'ETT_New_Tyre_Size__c':'',
            'ETT_New_Brand__c':'',
            'ETT_New_Country__c':'',
            'ETT_New_Pattern__c':''
        }); 
        component.set("v.noOfTyresCollection", 1);
        component.set("v.lstCollectionLineItem",collectionLineItemList);
        console.log('lstCollectionLineItem length: ');
        console.log(collectionLineItemList);
        var lstCollectionLineItemUpdate  = component.get("v.lstCollectionLineItemUpdate"); 
        lstCollectionLineItemUpdate.push({
            'sobjectType': 'WorkOrderLineItem',
            'ETT_Tyre_Size__c':null,
            'ETT_Brand__c':'',
            'ETT_Pattern__c':'',
            'ETT_Country_of_Origin__c':''
            
        }); 
        component.set("v.lstCollectionLineItemUpdate",lstCollectionLineItemUpdate);
        
        var lstCollectionLineItemNewTyresUpdate  = component.get("v.lstCollectionLineItemNewTyresUpdate");         
        lstCollectionLineItemNewTyresUpdate.push({
            'sobjectType': 'WorkOrderLineItem',
            'ETT_Tyre_Size_NewText__c':'',
            'ETT_Brand_NewText__c':'',
            'ETT_Pattern_NewText__c':'',
            'ETT_Country_NewText__c':''
        }); 
        component.set("v.lstCollectionLineItemNewTyresUpdate",lstCollectionLineItemNewTyresUpdate);
        component.set("v.lstCollectionLineItemNewTyres",lstCollectionLineItemNewTyresUpdate);
        
        console.log('lstCollectionLineItemUpdate' + JSON.stringify( component.get("v.lstCollectionLineItemUpdate")));
        console.log(JSON.stringify( component.get("v.lstCollectionLineItemNewTyresUpdate")));
        
        var action = component.get('c.lstCollectionCardLineItems'); 
        action.setParams({
            "strCollectionCard":component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            
            var state = a.getState(); 
            var isReceptionistAcceptancePending = false;
            console.log(state);
            
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                
                console.log(JSON.stringify(result));
                
                var arrayMapKeys = [];
                var lstCLI_Internal = component.get("v.lstCollectionLineItem_Internal");
                
                for(var k in result){
                    
                    console.log('key: '+k);
                    console.log('result: '+result[k]);
                    
                    if(k.includes("MissingPricingInformation")){
                        component.set('v.isPricingInformationMissing',true);
                    }
                    
                    for(var key in result[k]){
                       
                       // lstCLI_Internal.push(result[k][key]);
                        //arrayMapKeys.push({key: key, value: result[k][key]});
                        
                        
                        if(k.includes(result[k][key]['LineItemNumber'])){
                            result[k][key]['ETT_Is_Pricing_Information_Missing__c'] = true;
                            console.log(result[k][key]['LineItemNumber']+' missing PI');
                        }
                        if(result[k][key]['ETT_Accepted_By_Receptionist__c']==false){
                            isReceptionistAcceptancePending = true;
                        }
                        //console.log(result[key]['ETT_Collection_Card__r']['ETT_Check_Out__c']);
                        
                        if('ETT_Check_Out__c' in result[k][key]['ETT_Collection_Card__r']){
                            console.log('checkout');
                            component.set('v.lockRecord',true);
                        }
                        
                        for(var resKey in result[k][key]){
                            if(result[k][key]['ETT_Brand__r']['ETT_Status__c']==false){
                                component.set('v.NewMasterRecords',true);
                            }
                            //console.log(result[key]['ETT_Brand__r']['ETT_Status__c']);
                        }
                        
                        if(isReceptionistAcceptancePending==true){
                            component.set("v.isReceptionistAccepted",false);
                        }else{
                            component.set("v.isReceptionistAccepted",true);
                        }
                        
                        lstCLI_Internal.push(result[k][key]);
                        arrayMapKeys.push({key: key, value: result[k][key]});
                    }
                }

                
                component.set("v.lstCollectionLineItem_Internal",lstCLI_Internal);
                

                        
                var collectionLineItemList  = component.get("v.lstCollectionLineItem"); 
                if(arrayMapKeys.length>0){
                    component.set("v.isMapEmpty", true);            
                    component.set("v.isStart", true);    
                }
                component.set("v.oldRelatedWorkOrderLineItemsMap", arrayMapKeys);
                
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
        
        helper.fetchPickListVal(component, "ETT_Tyre_Life__c", "TyreLifeMap");
        helper.fetchPickListVal(component, "ETT_Job_Type__c", "JobTypeMap");        
        helper.fetchPickListVal(component, "ETT_Claim_Process__c", "ClaimProcessMap");        
        
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        var custLabelsReceptionist = $A.get("$Label.c.ETT_InspectionCriteria_Receptionist");
        var custLabelsSales = $A.get("$Label.c.ETT_InspectionCriteria_Sales");
        
        if(custLabelsReceptionist.includes(userId)){
            component.set('v.isUserReceptionist',true);
        }
        
        if(custLabelsSales.includes(userId)){
            component.set('v.isUserSalesPerson',true);
        }
        
        if(custLabelsFM.includes(userId)){
            component.set('v.isUserFM',true);
        }
        
        if(custLabelsHOO.includes(userId)){
            component.set('v.isUserHOO',true);
        }
        console.log('NewMasterRecords: '+component.get('v.NewMasterRecords'));
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    handleCompanyOnChange : function(component, event, helper){},
    
    addNewRowCollectionLineItem : function(component, event, helper){
        var addRowInList = component.get("v.lstCollectionLineItem");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.lstCollectionLineItem",addRowInList);
        
        component.set("v.TyreSizeName",'');
        component.set("v.BrandName",'');
        component.set("v.PatternName",'');
        component.set("v.CountryName",'');
        
    },
    removeRowCollectionLineItem : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.lstCollectionLineItem");
        console.log('****whichOne****'+whichOne);
        AllRowsList.splice(whichOne, 1);
        component.set("v.lstCollectionLineItem", AllRowsList);
    },
    
    addNewRowCollectionLineItemUpdate: function(component, event, helper){
        var addRowInList = component.get("v.lstCollectionLineItemUpdate");
        var contactObj = new Object();
        contactObj.ETT_Tyre_Size__c='';
        contactObj.ETT_Brand__c='';
        contactObj.ETT_Pattern__c='';
        contactObj.ETT_Country_of_Origin__c='';
        contactObj.ETT_Job_Type__c='Retread';
        
        addRowInList.push(contactObj);
        component.set("v.lstCollectionLineItemUpdate",addRowInList);
        
        component.set("v.TyreSizeName",'');
        component.set("v.BrandName",'');
        component.set("v.PatternName",'');
        component.set("v.CountryName",'');
        
    },
    
    addNewRowsUpdate: function(component, event, helper){
        var addRowInList = component.get("v.lstCollectionLineItemNewTyresUpdate");
        var contactObj = new Object();
        contactObj.ETT_Tyre_Size__c='';
        contactObj.ETT_Brand__c='';
        contactObj.ETT_Pattern__c='';
        contactObj.ETT_Country_of_Origin__c='';
        contactObj.ETT_Job_Type__c='Retread';
        addRowInList.push(contactObj);
        component.set("v.lstCollectionLineItemNewTyresUpdate",addRowInList);
    },
    removeNewRowsUpdate : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.lstCollectionLineItemNewTyresUpdate");
        console.log('****whichOne****'+whichOne);
        AllRowsList.splice(whichOne, 1);
        component.set("v.lstCollectionLineItemNewTyresUpdate", AllRowsList);
    },
    
    removeNewRowCollectionLineItemUpdate : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.lstCollectionLineItemUpdate");
        console.log('****whichOne****'+whichOne);
        AllRowsList.splice(whichOne, 1);
        component.set("v.lstCollectionLineItemUpdate", AllRowsList);
    },
    
    addNewRowsIntoTyreMaster : function(component, event, helper){
        var addRowInList = component.get("v.lstCollectionLineItemNewTyres");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.lstCollectionLineItemNewTyres",addRowInList);
        
        /*component.set("v.TyreSizeName",'');
        component.set("v.BrandName",'');
        component.set("v.PatternName",'');
        component.set("v.CountryName",'');*/
        
    },
    removeRowsIntoTyreMaster : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.lstCollectionLineItemNewTyres");
        console.log('****whichOne****'+whichOne);
        AllRowsList.splice(whichOne, 1);
        component.set("v.lstCollectionLineItemNewTyres", AllRowsList);
    },
    
    
    addNewRowCollectionLineItemInternal : function(component, event, helper){
        var addRowInList = component.get("v.lstCollectionLineItem_Internal");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.lstCollectionLineItem_Internal",addRowInList);
    },
    removeRowCollectionLineItemInternal : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.lstCollectionLineItem_Internal");
        console.log('****whichOne****'+whichOne);
        AllRowsList.splice(whichOne, 1);
        component.set("v.lstCollectionLineItem_Internal", AllRowsList);
    },
    
    handleComponentEvent : function(component, event, helper){
        var name = event.getParam("name");
        var index = event.getParam("index");
        var dynamicId = event.getParam("dynamicId");
        var objectName = event.getParam("objectName");
        
        
        if (objectName == "ETT_Tyre_Size_Master__c") {
            
            if (name == "New") {
                component.set("v.indexStgQuotation",index);          
                component.set("v.showTyreSize", true);
            }
            component.set("v.TyreSizeName", name);
            component.set("v.TyreSizeId", dynamicId);
            
        } else if (objectName == "ETT_Brand_Master__c") {
            
            if (name == "New") {
                component.set("v.indexStgQuotation",index);                    
                component.set("v.showBrand", true);
            }
            
            component.set("v.BrandName", name);
            component.set("v.BrandId", dynamicId);
            
        } else if (objectName == "ETT_Pattern_Master__c") {
            
            if (name == "New") {
                component.set("v.indexStgQuotation",index);                    
                component.set("v.showPattern", true);
            }
            
            component.set("v.PatternName", name);
            component.set("v.PatternId", dynamicId);
            
        } else if (objectName == "ETT_Country_Master__c") {
            
            if (name == "New") {
                component.set("v.indexStgQuotation",index);                    
                component.set("v.showCountry", true);
            }
            
            component.set("v.CountryName", name);
            component.set("v.CountryId", dynamicId);
            
        }
    },
    upperCase: function(component, event, helper){
        console.log(event.target.value);
    },
    prePopulateValues : function(component, event, helper){
        debugger;
        console.log('*************** uncomment below code to prepopulate values ***************');
        
        var indexvar = event.getSource().get("v.label");
        var indexVal = Number(indexvar);
        console.log('indexVal: '+indexVal);
        
        var isMapEmpty= component.get("v.isMapEmpty");
        console.log('isMapEmpty: '+isMapEmpty);
        if(isMapEmpty==false){
            var collectionLineItemList = component.get("v.lstCollectionLineItem");  
            console.log('start');
            console.log(JSON.stringify(collectionLineItemList));
        }else{
           // var collectionLineItemList = component.get("v.lstCollectionLineItemUpdate");  
             var collectionLineItemList = component.get("v.lstCollectionLineItem_Internal");  
            
            console.log('update');
            console.log(JSON.stringify(collectionLineItemList));
        }
        
      
        var collectionIndexObj = collectionLineItemList[indexVal];
        console.log(JSON.stringify(collectionIndexObj));
        var accId = component.get("v.CollectionCardRecord").ETT_Account_Id__c;
        var res;
      if(component.get("v.CollectionCardRecord").ETT_Service_Appointment__c)  var partyType = component.get("v.CollectionCardRecord").ETT_Service_Appointment__r.Account.Party_Type__c;
        var process = component.get("v.CollectionCardRecord").ETT_Work_Order__r.ETT_Process__c;
        var strJobType = collectionIndexObj.ETT_Job_Type__c;
    
        
        component.set('v.partyType',partyType);
        if(partyType == 'Supplier'){
            collectionIndexObj.ETT_Job_Type__c = 'Retread';
        }
        
        if(isMapEmpty==true){
            if(collectionIndexObj.ETT_Tyre_Size__c==''){
                helper.showErrorToast({
                    "title": "Required",
                    "type": "error",
                    "message": "Please select Tyre Size"
                });
                return false;
            }
            if(collectionIndexObj.ETT_Brand__c==''){
                helper.showErrorToast({
                    "title": "Required",
                    "type": "error",
                    "message": "Please select Brand"
                });
                return false;
            }
            if(collectionIndexObj.ETT_Pattern__c==''){
                helper.showErrorToast({
                    "title": "Required",
                    "type": "error",
                    "message": "Please select Pattern"
                });
                return false;
            }
            if(collectionIndexObj.ETT_Country_of_Origin__c==''){
                helper.showErrorToast({
                    "title": "Required",
                    "type": "error",
                    "message": "Please select a Country"
                });
                return false;
            }
            if(collectionIndexObj.ETT_Job_Type__c==''){
                helper.showErrorToast({
                    "title": "Required",
                    "type": "error",
                    "message": "Please select Job Type"
                });
                return false;
            }
        }
        
        console.log('accId: '+accId);
        console.log('ETT_Tyre_Size__c: '+collectionIndexObj.ETT_Tyre_Size__c);
        console.log('ETT_Pattern__c: '+collectionIndexObj.ETT_Pattern__c);
        console.log('ETT_Brand__c: '+collectionIndexObj.ETT_Brand__c);
        console.log('ETT_Country_of_Origin__c: '+collectionIndexObj.ETT_Country_of_Origin__c);
        console.log('ETT_Job_Type__c: '+strJobType+' : '+collectionIndexObj.ETT_Job_Type__c);
        console.log('process: '+process);
        console.log('partyType: '+partyType);
        
        //return false;
        
        console.log('collectionLineItemList '+collectionLineItemList);
        if(collectionLineItemList!=null && collectionLineItemList!=''){
            if(indexVal!=null){        
                var action = component.get('c.priceInfoData'); 
                console.log('called method');
                action.setParams({
                    "strAcctId":accId,
                    "strTyreSizeId" : collectionIndexObj.ETT_Tyre_Size__c,
                    "patternSizeId" : collectionIndexObj.ETT_Pattern__c,
                    "brandId" : collectionIndexObj.ETT_Brand__c,
                    "strCountryId" : collectionIndexObj.ETT_Country_of_Origin__c,
                    "partyType": partyType,
                    /*"strJobType":strJobType,
                    "process":process*/
                });                
                action.setCallback(this, function(a){
                    var state = a.getState(); 
                    console.log(state);
                    if(state == 'SUCCESS') {
                        res = a.getReturnValue();
                        console.log(res);
                        
                        collectionLineItemList[indexVal].ETT_Load_Index__c = res['objTyreSizeMaster'].ETT_Load_Index__c;
                        collectionLineItemList[indexVal].ETT_S_Index__c = res['objTyreSizeMaster'].ETT_Speed_Index__c;
                        collectionLineItemList[indexVal].ETT_Ply_Rate__c = res['objTyreSizeMaster'].ETT_Ply_Rate__c;
                        //collectionLineItemList[indexVal].ETT_Price__c = res['objTyreSizeMaster'].ETT_Purchase_Price__c;
                        
                        console.log('ETT_Load_Index__c'+collectionLineItemList[indexVal].ETT_Load_Index__c);
                        console.log('ETT_S_Index__c'+collectionLineItemList[indexVal].ETT_S_Index__c);
                        console.log('ETT_Ply_Rate__c'+ collectionLineItemList[indexVal].ETT_Ply_Rate__c);
                        /*if(strJobType=='Repair'){
                            if(partyType =='Customer' || partyType=='Internal Private Project'){
                                collectionLineItemList[indexVal].ETT_Price__c = res['objPricingInfo'].ETT_Repair_Price__c;
                            }
                        }else if(strJobType=='Retread'){
                            if(partyType =='Customer' || partyType =='Internal Private Project' || partyType =='Internal Private Project'){
                                
                                //collectionLineItemList[indexVal].ETT_Price__c = res['objPricingInfo'].ETT_Retread_Price_P__c;
                                collectionLineItemList[indexVal].ETT_Hot_Price__c = res['objPricingInfo'].ETT_Retread_Price_H__c;
                                collectionLineItemList[indexVal].ETT_Procure_Price__c = res['objPricingInfo'].ETT_Retread_Price_P__c;
                                // collectionLineItemList[indexVal].ETT_Price__c = res['objPricingInfo'].ETT_Retread_Price_H__c;
                                
                            }else if(partyType =='Supplier'){
                                collectionLineItemList[indexVal].ETT_Price__c = res['objPricingInfo'].ETT_Purchase_Agreed_Price__c;
                            }
                        }*/
                        
                        console.log(JSON.stringify(collectionLineItemList));
                        component.set("v.lstCollectionLineItem", collectionLineItemList);
                        
                    }else if (state === "INCOMPLETE") {
                        // do something
                    }else if (state === "ERROR") {
                        var errors = a.getError();
                        console.log(JSON.stringify(errors));
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                if(errors[0].message=='Duplicate Records'){
                                    helper.showErrorToast({
                                        "title": "Required",
                                        "type": "error",
                                        "message": "Duplicate records found. Please use alternate combination of Collection Card Line Items"
                                    });
                                    return false;
                                }
                                console.log("Error message: " +errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                });
                $A.enqueueAction(action);
                
            }
        }
        
        
        
        
    },
    
    
    onComplteCombineRowCollectionLineItemUpdate :function(component,event,helper){
        
        var indexvar = event.getSource().get("v.label");
        
        console.log('indexvar: '+indexvar);
        
        var indexVal = Number(indexvar);
        var collectionLineItemList = component.get("v.lstCollectionLineItemUpdate");
        var collectionIndexObj = collectionLineItemList[indexVal];
        var res, ETT_Load_Index, ETT_Speed_Index, ETT_Ply_Rate,ETT_Price;
        var nm = component.get("v.CollectionCardRecord").Name;
        var accId = component.get("v.CollectionCardRecord").ETT_Account_Id__c;
        
        if(collectionLineItemList!=null && collectionLineItemList!=''){
            if(indexVal!=null){
                
                for(var i=1;i<=collectionIndexObj.ETT_Quantity__c;i++){
                    
                    collectionLineItemList.push({
                        'sobjectType': 'WorkOrderLineItem',
                        'ETT_Tyre_Size__c':collectionIndexObj.ETT_Tyre_Size__c,
                        'ETT_Tyre_Size_Name__c':collectionIndexObj.ETT_Tyre_Size_Name__c,
                        'ETT_Brand__c':collectionIndexObj.ETT_Brand__c,
                        'ETT_Brand_Name__c':collectionIndexObj.ETT_Brand_Name__c,
                        'ETT_Pattern__c':collectionIndexObj.ETT_Pattern__c,
                        'ETT_Pattern_Name__c':collectionIndexObj.ETT_Pattern_Name__c,
                        'ETT_Country_of_Origin__c':collectionIndexObj.ETT_Country_of_Origin__c,
                        'ETT_Country_of_Origin_Name__c':collectionIndexObj.ETT_Country_of_Origin_Name__c,
                        'ETT_Load_Index__c':ETT_Load_Index,
                        'ETT_S_Index__c':ETT_Speed_Index,
                        'ETT_PR__c':ETT_Ply_Rate,
                        'ETT_Price__c':ETT_Price,
                        'ETT_Quantity__c':0,
                        'ETT_Tyre_Serial_Number__c':'',
                        'ETT_Job_Type__c':'',
                        'ETT_Remarks__c':'',
                        'ETT_New_Tyre_Size__c':'',
                        'ETT_New_Brand__c':'',
                        'ETT_New_Country__c':'',
                        'ETT_New_Pattern__c':''
                        
                    }); 
                    
                    component.set("v.lstCollectionLineItemUpdate", collectionLineItemList);
                }                                    
            }
            
        }
        
        
    },
    
    onComplteCombineRowCollectionLineItem :function(component,event,helper){
        
        var indexvar = event.getSource().get("v.label");
        
        console.log('indexvar: '+indexvar);
        
        var indexVal = Number(indexvar);
        var collectionLineItemList = component.get("v.lstCollectionLineItem");
        var collectionIndexObj = collectionLineItemList[indexVal];
        var res, ETT_Load_Index, ETT_Speed_Index, ETT_Ply_Rate,ETT_Price;
        var nm = component.get("v.CollectionCardRecord").Name;
        var accId = component.get("v.CollectionCardRecord").ETT_Account_Id__c;
        
        if(collectionLineItemList!=null && collectionLineItemList!=''){
            if(indexVal!=null){
                
                for(var i=1;i<=collectionIndexObj.ETT_Quantity__c;i++){
                    
                    collectionLineItemList.push({
                        'sobjectType': 'WorkOrderLineItem',
                        'ETT_Tyre_Size__c':collectionIndexObj.ETT_Tyre_Size__c,
                        'ETT_Tyre_Size_Name__c':collectionIndexObj.ETT_Tyre_Size_Name__c,
                        'ETT_Brand__c':collectionIndexObj.ETT_Brand__c,
                        'ETT_Brand_Name__c':collectionIndexObj.ETT_Brand_Name__c,
                        'ETT_Pattern__c':collectionIndexObj.ETT_Pattern__c,
                        'ETT_Pattern_Name__c':collectionIndexObj.ETT_Pattern_Name__c,
                        'ETT_Country_of_Origin__c':collectionIndexObj.ETT_Country_of_Origin__c,
                        'ETT_Country_of_Origin_Name__c':collectionIndexObj.ETT_Country_of_Origin_Name__c,
                        'ETT_Load_Index__c':ETT_Load_Index,
                        'ETT_S_Index__c':ETT_Speed_Index,
                        'ETT_PR__c':ETT_Ply_Rate,
                        'ETT_Price__c':ETT_Price,
                        'ETT_Quantity__c':0,
                        'ETT_Tyre_Serial_Number__c':'',
                        'ETT_Job_Type__c':'',
                        'ETT_Remarks__c':'',
                        'ETT_New_Tyre_Size__c':'',
                        'ETT_New_Brand__c':'',
                        'ETT_New_Country__c':'',
                        'ETT_New_Pattern__c':''
                        
                    }); 
                    
                    component.set("v.lstCollectionLineItem", collectionLineItemList);
                }                                    
            }
            
        }
        
        
    },
    
    duplicateNewTyreDetails :function(component,event,helper){
        
        var indexvar = event.getSource().get("v.label");
        
        console.log('indexvar: '+indexvar);
       // alert(indexvar);	
        var indexVal = Number(indexvar);
        var collectionLineItemList = component.get("v.lstCollectionLineItemNewTyres");
        var collectionIndexObj = collectionLineItemList[indexVal];
        var res, ETT_Load_Index, ETT_Speed_Index, ETT_Ply_Rate,ETT_Price;
        var nm = component.get("v.CollectionCardRecord").Name;
        var accId = component.get("v.CollectionCardRecord").ETT_Account_Id__c;
        
        if(collectionLineItemList!=null && collectionLineItemList!=''){
            if(indexVal!=null){
                
                for(var i=1;i<=collectionIndexObj.ETT_Quantity__c;i++){
                    
                    collectionLineItemList.push({
                        'sobjectType': 'WorkOrderLineItem',
                        'ETT_Tyre_Size__c':collectionIndexObj.ETT_Tyre_Size__c,
                        'ETT_Tyre_Size_Name__c':collectionIndexObj.ETT_Tyre_Size_Name__c,
                        'ETT_Brand__c':collectionIndexObj.ETT_Brand__c,
                        'ETT_Brand_Name__c':collectionIndexObj.ETT_Brand_Name__c,
                        'ETT_Pattern__c':collectionIndexObj.ETT_Pattern__c,
                        'ETT_Pattern_Name__c':collectionIndexObj.ETT_Pattern_Name__c,
                        'ETT_Country_of_Origin__c':collectionIndexObj.ETT_Country_of_Origin__c,
                        'ETT_Country_of_Origin_Name__c':collectionIndexObj.ETT_Country_of_Origin_Name__c,
                        'ETT_Load_Index__c':ETT_Load_Index,
                        'ETT_S_Index__c':ETT_Speed_Index,
                        'ETT_PR__c':ETT_Ply_Rate,
                        'ETT_Price__c':ETT_Price,
                        'ETT_Quantity__c':0,
                        'ETT_Tyre_Size_NewText__c':collectionIndexObj.ETT_Tyre_Size_NewText__c,
                        'ETT_Brand_NewText__c':collectionIndexObj.ETT_Brand_NewText__c,
                        'ETT_Pattern_NewText__c':collectionIndexObj.ETT_Pattern_NewText__c,
                        'ETT_Country_NewText__c':collectionIndexObj.ETT_Country_NewText__c
                        
                    }); 
                    
                    component.set("v.lstCollectionLineItemNewTyres", collectionLineItemList);
                }                                    
            }
            
        }
        
        
    },
    
    duplicateNewTyreUpdate :function(component,event,helper){
        
        var indexvar = event.getSource().get("v.label");
        var indexVal = Number(indexvar);
        var collectionLineItemList = component.get("v.lstCollectionLineItemNewTyresUpdate");
        var collectionIndexObj = collectionLineItemList[indexVal];
        var res, ETT_Load_Index, ETT_Speed_Index, ETT_Ply_Rate,ETT_Price;
        var nm = component.get("v.CollectionCardRecord").Name;
        var accId = component.get("v.CollectionCardRecord").ETT_Account_Id__c;
        
        if(collectionLineItemList!=null && collectionLineItemList!=''){
            if(indexVal!=null){
                
                for(var i=1;i<=collectionIndexObj.ETT_Quantity__c;i++){
                    
                    collectionLineItemList.push({
                        'sobjectType': 'WorkOrderLineItem',
                        'ETT_Tyre_Size__c':collectionIndexObj.ETT_Tyre_Size__c,
                        'ETT_Tyre_Size_Name__c':collectionIndexObj.ETT_Tyre_Size_Name__c,
                        'ETT_Brand__c':collectionIndexObj.ETT_Brand__c,
                        'ETT_Brand_Name__c':collectionIndexObj.ETT_Brand_Name__c,
                        'ETT_Pattern__c':collectionIndexObj.ETT_Pattern__c,
                        'ETT_Pattern_Name__c':collectionIndexObj.ETT_Pattern_Name__c,
                        'ETT_Country_of_Origin__c':collectionIndexObj.ETT_Country_of_Origin__c,
                        'ETT_Country_of_Origin_Name__c':collectionIndexObj.ETT_Country_of_Origin_Name__c,
                        'ETT_Load_Index__c':ETT_Load_Index,
                        'ETT_S_Index__c':ETT_Speed_Index,
                        'ETT_PR__c':ETT_Ply_Rate,
                        'ETT_Price__c':ETT_Price,
                        'ETT_Quantity__c':0,
                        'ETT_Tyre_Size_NewText__c':collectionIndexObj.ETT_Tyre_Size_NewText__c,
                        'ETT_Brand_NewText__c':collectionIndexObj.ETT_Brand_NewText__c,
                        'ETT_Pattern_NewText__c':collectionIndexObj.ETT_Pattern_NewText__c,
                        'ETT_Country_NewText__c':collectionIndexObj.ETT_Country_NewText__c
                        
                    }); 
                    
                    component.set("v.lstCollectionLineItemNewTyresUpdate", collectionLineItemList);
                }                                    
            }
            
        }
        
        
    },
    
    onComplteRowCollectionLineItem :function(component, event, helper){
        var collectionTyreNo =  component.get("v.noOfTyresCollection");
        var collectionLineItemList = component.get("v.lstCollectionLineItem"); 
        //collectionLineItemList = [];
        if((collectionTyreNo!=null && collectionTyreNo!='') || collectionTyreNo!=0){
            for(var i=1;i<=collectionTyreNo;i++){
                collectionLineItemList.push({
                    'sobjectType': 'WorkOrderLineItem',
                    'ETT_Tyre_Size__c':'',
                    'ETT_Brand__c':'',
                    'ETT_Pattern__c':'',
                    'ETT_Country_of_Origin__c':'',
                    'ETT_Load_Index__c':'',
                    'ETT_S_Index__c':'',
                    'ETT_PR__c':'',
                    'ETT_Tyre_Serial_Number__c':'',
                    'ETT_Job_Type__c':'',
                    'ETT_Remarks__c':''
                }); 
            }
            
            component.set("v.lstCollectionLineItem", collectionLineItemList);
        }
    },
    
    Start : function(component, event, helper){
        console.log('start'+component.get("v.recordId"));
        var action = component.get('c.updateCheckIn'); 
        
        action.setParams({
            "strCollectionCard":component.get("v.recordId")
        });
        
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            if(state == 'SUCCESS') {
                console.log(a.getReturnValue());
                var res = a.getReturnValue();
                
                component.set("v.isMapEmpty",false);
                component.set("v.isStart",true);
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = a.getError();
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    Stop : function(component, event, helper){
        
        var action = component.get('c.updateCheckOut'); 
        
        action.setParams({
            "strCollectionCard":component.get("v.recordId")
        });
        
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                console.log(a.getReturnValue());
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    
    Save : function(component, event, helper){
        debugger;
        var workOrderId = component.get("v.CollectionCardRecord").ETT_Work_Order__c; 
        var accId = component.get("v.CollectionCardRecord").ETT_Account_Id__c;
        var lstCollectionLineItem = component.get("v.lstCollectionLineItem");
        var lstCollectionLineItemNewTyres = component.get("v.lstCollectionLineItemNewTyres");
        
        var collectionCardRecordType = component.get("v.CollectionCardRecord").RecordType.Name;
        var workOrderLineItemRecordType;
        
        if(collectionCardRecordType=='Tyre - Credit/B2B Supplier'){
            workOrderLineItemRecordType = $A.get("$Label.c.ETT_Tyre_B2B_Supplier_WOLI");
        }else if(collectionCardRecordType=='Tyre - Cash Supplier'){
            workOrderLineItemRecordType = $A.get("$Label.c.Tyre_Cash_Supplier_WOLI");
        }else if(collectionCardRecordType=='Tyre - Refurbishing Services'){
            workOrderLineItemRecordType = $A.get("$Label.c.ETT_Tyre_Refurbishing_Services_WOLI");
        }
        
        var isEmpty = false;
        if(lstCollectionLineItem!=null && lstCollectionLineItem.length>0){
            
            for(var i=0;i<lstCollectionLineItem.length;i++){
                
                if(lstCollectionLineItem[i].ETT_Tyre_Size__c!=null ||
                   lstCollectionLineItem[i].ETT_Brand__c!='' ||
                   lstCollectionLineItem[i].ETT_Pattern__c!='' ||
                   lstCollectionLineItem[i].ETT_Country_of_Origin__c!='' ){
                    
                    console.log('call 1');
                    
                    if(lstCollectionLineItem[i].ETT_Tyre_Size__c=='' || lstCollectionLineItem[i].ETT_Tyre_Size__c==null ||
                       lstCollectionLineItem[i].ETT_Brand__c=='' || lstCollectionLineItem[i].ETT_Brand__c==null ||
                       lstCollectionLineItem[i].ETT_Pattern__c=='' || lstCollectionLineItem[i].ETT_Pattern__c==null ||
                       lstCollectionLineItem[i].ETT_Country_of_Origin__c=='' || lstCollectionLineItem[i].ETT_Country_of_Origin__c==null ||
                       lstCollectionLineItem[i].ETT_Tyre_Serial_Number__c=='' || lstCollectionLineItem[i].ETT_Tyre_Serial_Number__c==null){
                        console.log('call 2');                    
                        helper.showErrorToast({
                            "title": "Required",
                            "type": "error",
                            "message": "Tyre Size, Brand, Pattern, Country of Origin, Tyre Serial Number Fields are required"
                        });
                        return false;
                        
                    }else{
                        isEmpty = true;
                        lstCollectionLineItem[i].WorkOrderId = workOrderId;
                        lstCollectionLineItem[i].ETT_Job_Type__c = 'Retread';
                        lstCollectionLineItem[i].ETT_Collection_Card__c = component.get("v.recordId");
                        lstCollectionLineItem[i].ETT_Account__c = accId;
                        lstCollectionLineItem[i].RecordTypeId = workOrderLineItemRecordType;
                    }
                }
            }
        }
        console.log('call 3');
        
        
        
        if(lstCollectionLineItemNewTyres!=null && lstCollectionLineItemNewTyres.length>0){
            
            for(var i=0;i<lstCollectionLineItemNewTyres.length;i++){
                
                if('ETT_Tyre_Size_NewText__c' in lstCollectionLineItemNewTyres[i] ||
                   'ETT_Brand_NewText__c' in lstCollectionLineItemNewTyres[i] ||
                   'ETT_Pattern_NewText__c' in lstCollectionLineItemNewTyres[i] ||
                   'ETT_Country_NewText__c' in lstCollectionLineItemNewTyres[i] ){
                    
                    if(lstCollectionLineItemNewTyres[i].ETT_Tyre_Size_NewText__c!='' ||
                       lstCollectionLineItemNewTyres[i].ETT_Brand_NewText__c!='' ||
                       lstCollectionLineItemNewTyres[i].ETT_Pattern_NewText__c!='' ||
                       lstCollectionLineItemNewTyres[i].ETT_Country_NewText__c!='' ){
                        
                        if((lstCollectionLineItemNewTyres[i].ETT_Tyre_Size_NewText__c=='' ||
                            lstCollectionLineItemNewTyres[i].ETT_Tyre_Size_NewText__c==null)||
                           (lstCollectionLineItemNewTyres[i].ETT_Brand_NewText__c=='' ||
                            lstCollectionLineItemNewTyres[i].ETT_Brand_NewText__c==null)||
                           (lstCollectionLineItemNewTyres[i].ETT_Pattern_NewText__c=='' ||
                            lstCollectionLineItemNewTyres[i].ETT_Pattern_NewText__c==null)||
                           (lstCollectionLineItemNewTyres[i].ETT_Country_NewText__c=='' ||
                            lstCollectionLineItemNewTyres[i].ETT_Country_NewText__c==null)||
                           (lstCollectionLineItemNewTyres[i].ETT_Tyre_Serial_Number__c=='' ||
                            lstCollectionLineItemNewTyres[i].ETT_Tyre_Serial_Number__c==null)){
                            
                            console.log('call 5');
                            helper.showErrorToast({
                                "title": "Required",
                                "type": "error",
                                "message": "Tyre Size, Brand, Pattern, Country of Origin, Tyre Serial Number Fields are required"
                            });
                            return false;
                        }else{
                            isEmpty = true;
                            lstCollectionLineItemNewTyres[i].WorkOrderId = workOrderId;
                            lstCollectionLineItemNewTyres[i].ETT_Job_Type__c = 'Retread';
                            lstCollectionLineItemNewTyres[i].ETT_Collection_Card__c = component.get("v.recordId");
                            lstCollectionLineItemNewTyres[i].ETT_Account__c = accId;
                            lstCollectionLineItemNewTyres[i].RecordTypeId = workOrderLineItemRecordType;
                            
                        }
                    }
                }
            }
        }
        if(!isEmpty){
            helper.showErrorToast({
                "title": "Required",
                "type": "error",
                "message": "Please enter tyre details"
            });
            return false;
        }
        
        var strlstCollectionLineItemJson = JSON.stringify(lstCollectionLineItem);
        console.log(strlstCollectionLineItemJson);
        console.log(JSON.stringify(component.get("v.lstCollectionLineItemNewTyres")));
        
        //Check duplicates Start
        var uniqueArray = [];
        if(lstCollectionLineItem!=null && lstCollectionLineItem.length>0){
            for(var i=0;i<lstCollectionLineItem.length;i++){
                
                /*var combin  =  lstCollectionLineItem[i].ETT_Tyre_Size__c+'#'+
                    lstCollectionLineItem[i].ETT_Brand__c+'#'+
                    lstCollectionLineItem[i].ETT_Pattern__c+'#'+
                    lstCollectionLineItem[i].ETT_Country_of_Origin__c+'#'+
                    lstCollectionLineItem[i].ETT_Tyre_Serial_Number__c;
                */
                var combin  =  lstCollectionLineItem[i].ETT_Brand__c+'#'+
                    lstCollectionLineItem[i].ETT_Tyre_Serial_Number__c;
                
                if(uniqueArray.indexOf(combin) > -1) {
                    helper.showErrorToast({
                        "title": "Error: Collection Card Line Items",
                        "type": "error",
                        "message": "Tyre Serial Number should be unique for every record"
                    });
                    return false;
                }else{
                    uniqueArray.push(combin);
                }
            }
        }
        
        var uniqueNewTyreArray = [];
        if(lstCollectionLineItemNewTyres!=null && lstCollectionLineItemNewTyres.length>0){
            for(var i=0;i<lstCollectionLineItemNewTyres.length;i++){
                
                /*var combin  =  lstCollectionLineItem[i].ETT_Tyre_Size__c+'#'+
                    lstCollectionLineItem[i].ETT_Brand__c+'#'+
                    lstCollectionLineItem[i].ETT_Pattern__c+'#'+
                    lstCollectionLineItem[i].ETT_Country_of_Origin__c+'#'+
                    lstCollectionLineItem[i].ETT_Tyre_Serial_Number__c;
                */
                var combin  =  lstCollectionLineItemNewTyres[i].ETT_Brand__c+'#'+
                    lstCollectionLineItemNewTyres[i].ETT_Tyre_Serial_Number__c;
                
                if(uniqueNewTyreArray.indexOf(combin) > -1) {
                    helper.showErrorToast({
                        "title": "Error: Collection Card Line Items",
                        "type": "error",
                        "message": "Tyre Serial Number should be unique for every record"
                    });
                    return false;
                }else{
                    uniqueNewTyreArray.push(combin);
                }
            }
        }
        
        
        console.log(strlstCollectionLineItemJson);
        console.log(component.get("v.recordId"));
        console.log(component.get("v.lstCollectionLineItemNewTyres"));
        
        
        if(isEmpty){
            //Check duplicates Stop
            var action = component.get('c.collectionLineItemsProcess');         
            action.setParams({
                "lstWorkOrderLineItems":strlstCollectionLineItemJson,
                "strCollectionCard":component.get("v.recordId"),
                "lstCollectionLineItemNewTyres":JSON.stringify(component.get("v.lstCollectionLineItemNewTyres"))
            });        
            action.setCallback(this, function(a){
                var state = a.getState(); 
                console.log(state);
                if(state == 'SUCCESS') {
                    console.log(a.getReturnValue());
                    component.set("v.isMapEmpty",true);
                    component.set("v.isStop",true);
                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/' + component.get("v.recordId")
                    });
                    urlEvent.fire();
                    
                    
                }else if (state === "INCOMPLETE") {
                    // do something
                }else if (state === "ERROR") {
                    var errors = a.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            
                            helper.showErrorToast({
                                "title": "Error:",
                                "type": "error",
                                "message": errors[0].message
                            });
                            return false;
                            
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
                
            });        
            $A.enqueueAction(action);
        }
    },
    
    Update : function(component, event, helper){
        
        console.log(JSON.stringify(component.get("v.lstCollectionLineItemUpdate")));
        console.log(JSON.stringify(component.get("v.lstCollectionLineItemNewTyresUpdate")));
        console.log(JSON.stringify(component.get("v.lstCollectionLineItem_Internal")));
        //    return false;
        var addNewRecords = false;
        var collectionLineItem = component.get("v.lstCollectionLineItem_Internal");
        for(var i=0;i<collectionLineItem.length;i++){
            collectionLineItem[i].ETT_Tyre_Size__c = collectionLineItem[i].ETT_Tyre_Size__c;
            collectionLineItem[i].ETT_Brand__c = collectionLineItem[i].ETT_Brand__c;
            collectionLineItem[i].ETT_Pattern__c = collectionLineItem[i].ETT_Pattern__c;
            collectionLineItem[i].ETT_Country_of_Origin__c = collectionLineItem[i].ETT_Country_of_Origin__c;
            
        }
        component.set("v.lstCollectionLineItem_Internal",collectionLineItem);
        
        //CALL Action to update CLI	
        var action = component.get("c.updateInternalCLI");
        action.setParams({
            "objCollectionCard":component.get("v.lstCollectionLineItem_Internal")
        }); 
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
               if(!addNewRecords){
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/' + component.get("v.recordId")
                    });
                    urlEvent.fire();
                }
                
                
            }else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!! "+state);
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.log(errors);
            }else {
                console.log("Failed with state: " + state);
            }
            
        });
        $A.enqueueAction(action);
        
        var workOrderId = component.get("v.CollectionCardRecord").ETT_Work_Order__c; 
        var accId = component.get("v.CollectionCardRecord").ETT_Account_Id__c;
        var lstCollectionLineItem = component.get("v.lstCollectionLineItem");
        var lstCollectionLineItemNewTyres = component.get("v.lstCollectionLineItemNewTyres");
        var collectionCardRecordType = component.get("v.CollectionCardRecord").RecordType.Name;
        var workOrderLineItemRecordType;
        
        if(collectionCardRecordType=='Tyre - Credit/B2B Supplier'){
            workOrderLineItemRecordType = $A.get("$Label.c.ETT_Tyre_B2B_Supplier_WOLI");
        }else if(collectionCardRecordType=='Tyre - Cash Supplier'){
            workOrderLineItemRecordType = $A.get("$Label.c.Tyre_Cash_Supplier_WOLI");
        }else if(collectionCardRecordType=='Tyre - Refurbishing Services'){
            workOrderLineItemRecordType = $A.get("$Label.c.ETT_Tyre_Refurbishing_Services_WOLI");
        }
        
        
        
        var lstCollectionLineItemUpdate = component.get("v.lstCollectionLineItemUpdate");
        if(lstCollectionLineItemUpdate!=null && lstCollectionLineItemUpdate.length>0){
            for(var i=0;i<lstCollectionLineItemUpdate.length;i++){
                lstCollectionLineItemUpdate[i].WorkOrderId = workOrderId;
                lstCollectionLineItemUpdate[i].ETT_Job_Type__c = 'Retread';
                lstCollectionLineItemUpdate[i].ETT_Collection_Card__c = component.get("v.recordId");
                lstCollectionLineItemUpdate[i].ETT_Account__c = accId;
                lstCollectionLineItemUpdate[i].RecordTypeId = workOrderLineItemRecordType;
                console.log(JSON.stringify(lstCollectionLineItemUpdate[i]));
                
                if((lstCollectionLineItemUpdate[i].ETT_Tyre_Size__c!= null &&
                    lstCollectionLineItemUpdate[i].ETT_Tyre_Size__c!= '' ) ||
                   lstCollectionLineItemUpdate[i].ETT_Brand__c!='' ||
                   lstCollectionLineItemUpdate[i].ETT_Pattern__c!='' ||
                   lstCollectionLineItemUpdate[i].ETT_Country_of_Origin__c!='' ){
                    console.log('call 1');
                    console.log(JSON.stringify(lstCollectionLineItemUpdate[i]));
                    if((lstCollectionLineItemUpdate[i].ETT_Tyre_Size__c=='' ||
                        lstCollectionLineItemUpdate[i].ETT_Tyre_Size__c==null)||
                       (lstCollectionLineItemUpdate[i].ETT_Brand__c=='' ||
                        lstCollectionLineItemUpdate[i].ETT_Brand__c==null)||
                       (lstCollectionLineItemUpdate[i].ETT_Pattern__c=='' ||
                        lstCollectionLineItemUpdate[i].ETT_Pattern__c==null)||
                       (lstCollectionLineItemUpdate[i].ETT_Country_of_Origin__c=='' ||
                        lstCollectionLineItemUpdate[i].ETT_Country_of_Origin__c==null)||
                      (lstCollectionLineItemUpdate[i].ETT_Tyre_Serial_Number__c=='' ||
                        lstCollectionLineItemUpdate[i].ETT_Tyre_Serial_Number__c==null)){
                        
                        helper.showErrorToast({
                            "title": "Required",
                            "type": "error",
                            "message": "Please enter tyre details"
                        });
                        return false;
                    }else{
                        addNewRecords = true;
                    }
                }
                
            }
        }
        component.set("v.lstCollectionLineItemUpdate",lstCollectionLineItemUpdate);
        
        var lstCollectionLineItemNewTyresUpdate = component.get("v.lstCollectionLineItemNewTyresUpdate");
        if(lstCollectionLineItemNewTyresUpdate!=null && lstCollectionLineItemNewTyresUpdate.length>0){
            for(var i=0;i<lstCollectionLineItemNewTyresUpdate.length;i++){
                lstCollectionLineItemNewTyresUpdate[i].WorkOrderId = workOrderId;
                lstCollectionLineItemNewTyresUpdate[i].ETT_Job_Type__c = 'Retread';
                lstCollectionLineItemNewTyresUpdate[i].ETT_Collection_Card__c = component.get("v.recordId");
                lstCollectionLineItemNewTyresUpdate[i].ETT_Account__c = accId;
                lstCollectionLineItemNewTyresUpdate[i].RecordTypeId = workOrderLineItemRecordType;
                if(lstCollectionLineItemNewTyresUpdate[i].ETT_Tyre_Size_NewText__c!='' ||
                   lstCollectionLineItemNewTyresUpdate[i].ETT_Brand_NewText__c!='' ||
                   lstCollectionLineItemNewTyresUpdate[i].ETT_Pattern_NewText__c!='' ||
                   lstCollectionLineItemNewTyresUpdate[i].ETT_Country_NewText__c!='' ){
                    
                    if((lstCollectionLineItemNewTyresUpdate[i].ETT_Tyre_Size_NewText__c=='' ||
                        lstCollectionLineItemNewTyresUpdate[i].ETT_Tyre_Size_NewText__c==null)&&
                       (lstCollectionLineItemNewTyresUpdate[i].ETT_Brand_NewText__c=='' ||
                        lstCollectionLineItemNewTyresUpdate[i].ETT_Brand_NewText__c==null)&&
                       (lstCollectionLineItemNewTyresUpdate[i].ETT_Pattern_NewText__c=='' ||
                        lstCollectionLineItemNewTyresUpdate[i].ETT_Pattern_NewText__c==null)&&
                       (lstCollectionLineItemNewTyresUpdate[i].ETT_Country_NewText__c=='' ||
                        lstCollectionLineItemNewTyresUpdate[i].ETT_Country_NewText__c==null)||
                      (lstCollectionLineItemNewTyresUpdate[i].ETT_Tyre_Serial_Number__c=='' ||
                        lstCollectionLineItemNewTyresUpdate[i].ETT_Tyre_Serial_Number__c==null)){
                        
                        helper.showErrorToast({
                            "title": "Required",
                            "type": "error",
                            "message": "Please enter tyre details"
                        });
                        return false;
                        
                        return false;
                    }else{
                        addNewRecords = true;
                    }
                }
                
                
            }
        }
        component.set("v.lstCollectionLineItemNewTyresUpdate",lstCollectionLineItemNewTyresUpdate);        
        
        console.log('addNewRecords: '+addNewRecords);
        
        if(addNewRecords){
            var action = component.get('c.collectionLineItemsProcess');         
            action.setParams({
                "lstWorkOrderLineItems":JSON.stringify(component.get("v.lstCollectionLineItemUpdate")),
                "strCollectionCard":component.get("v.recordId"),
                "lstCollectionLineItemNewTyres":JSON.stringify(component.get("v.lstCollectionLineItemNewTyresUpdate"))
            });        
            action.setCallback(this, function(a){
                var state = a.getState(); 
                console.log(state);
                if(state == 'SUCCESS') {
                    console.log(a.getReturnValue());
                    component.set("v.isMapEmpty",true);
                    component.set("v.isStop",true);
                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/' + component.get("v.recordId")
                    });
                    urlEvent.fire();
                    
                    
                }else if (state === "INCOMPLETE") {
                    // do something
                }else if (state === "ERROR") {
                    var errors = a.getError();
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
        }
        
    },
    
    Delete : function(component, event, helper){
        
        var r = confirm("Are you sure you want to delete selected Records?");
        if (r == true) {
            
            console.log('Delete**************');
            var lstCollectionLineItem = component.get("v.lstCollectionLineItem_Internal");
            var deleteIds = component.get("v.deleteIds");
            var delteItems = [];
            for(var i=0; i<lstCollectionLineItem.length; i++){
                if(lstCollectionLineItem[i].ETT_Accepted_By_Receptionist__c==true){
                    console.log(lstCollectionLineItem[i].Id);
                    delteItems[i]=lstCollectionLineItem[i].Id;
                }
            }
            
            console.log(delteItems);
            //component.set("v.deleteIds",deleteIds);
            
            //CALL Action to update CLI	
            var action = component.get("c.deleteWorkOrderLineItem");
            
            action.setParams({
                "delteItems":delteItems
            }); 
            
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    console.log(response.getReturnValue());
                    var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
                    
                }else if (state === "INCOMPLETE") {
                    console.log("Failed to connect Salesforce!! "+state);
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log(errors);
                }else {
                    console.log("Failed with state: " + state);
                }
                
            });
            
            $A.enqueueAction(action);
            
            
            
        }
    },
    
    handleSelectAllEstimation : function(component, event, helper){
        
        var lstCollectionLineItem = component.get("v.lstCollectionLineItem_Internal");
        for(var i=0; i<lstCollectionLineItem.length; i++){
            lstCollectionLineItem[i].ETT_Accepted_By_Receptionist__c = component.get("v.isSelectAll");
        }
        console.log(JSON.stringify(lstCollectionLineItem));
        component.set("v.lstCollectionLineItem_Internal",lstCollectionLineItem);
        
    },
    
    SalesTeamAcceptanceFunction : function(component, event, helper){
        
        var objCC = component.get("v.objCollectionCard");
        objCC.Id = component.get("v.recordId");
        component.set("v.objCollectionCard",objCC);
        
        console.log(JSON.stringify(component.get("v.objCollectionCard")));
        
        
        var action = component.get('c.strSalesTeamAccpectance');         
        action.setParams({
            "lstWorkOrderList":JSON.stringify(component.get("v.lstCollectionLineItem_Internal")),
            "objCollectionCard":component.get("v.objCollectionCard")
        });        
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            //alert(JSON.stringify(state));
            
            if(state == 'SUCCESS') {
                
                console.log(a.getReturnValue());
                //alert(JSON.stringify(a.getReturnValue()));
                
                component.set("v.isMapEmpty",true);
                component.set("v.isStop",true);
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = a.getError();
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
    
    requestForPricingInfo : function(component, event, helper){
        var lstCollectionLineItem_Internal = component.get("v.lstCollectionLineItem_Internal");
		console.log(JSON.stringify(lstCollectionLineItem_Internal));
        
        if(lstCollectionLineItem_Internal!=null && lstCollectionLineItem_Internal.length>0){
            for(var i=0;i<lstCollectionLineItem_Internal.length;i++){
                if(lstCollectionLineItem_Internal[i].ETT_Is_Pricing_Information_Missing__c==false){
                    //delete lstCollectionLineItem_Internal[i];
                    lstCollectionLineItem_Internal.splice(i,1);
                }
            }
            
            //console.log(JSON.stringify(lstCollectionLineItem_Internal));
            //return false;
            
            
            var action = component.get('c.requestStagingQuotation');         
            action.setParams({
                "lstWorkOrderLineItem":lstCollectionLineItem_Internal,
                "recordId":component.get("v.recordId")
            });        
            action.setCallback(this, function(a){
                var state = a.getState(); 
                console.log(state);
                if(state == 'SUCCESS') {
                    console.log(a.getReturnValue());
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/' + component.get("v.recordId")
                    });
                    urlEvent.fire();
                }else if (state === "INCOMPLETE") {
                    // do something
                }else if (state === "ERROR") {
                    var errors = a.getError();
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
        }
        console.log(JSON.stringify(lstCollectionLineItem_Internal));
    },
    
    ReceptionistAcceptanceFunction : function(component, event, helper){
        
        var objCC = component.get("v.objCollectionCard");
        objCC.Id = component.get("v.recordId");
        component.set("v.objCollectionCard",objCC);
        
        console.log(JSON.stringify(component.get("v.objCollectionCard")));
        
        
        var action = component.get('c.strRecetionistAccpectance');         
        action.setParams({
            "lstWorkOrderList":JSON.stringify(component.get("v.lstCollectionLineItem_Internal")),
            "objCollectionCard":component.get("v.objCollectionCard")
        });        
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            //alert(JSON.stringify(state));
            
            if(state == 'SUCCESS') {
                
                console.log(a.getReturnValue());
                //alert(JSON.stringify(a.getReturnValue()));
                
                component.set("v.isMapEmpty",true);
                component.set("v.isStop",true);
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = a.getError();
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
    HOOAcceptanceFunction : function(component, event, helper){
        
        var objCC = component.get("v.objCollectionCard");
        objCC.Id = component.get("v.recordId");
        component.set("v.objCollectionCard",objCC);
        
        var action = component.get('c.strHOOAccpectance');         
        action.setParams({
            "objCollectionCard":component.get("v.objCollectionCard")
        });        
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            if(state == 'SUCCESS') {
                console.log(a.getReturnValue());
                component.set("v.isMapEmpty",true);
                component.set("v.isStop",true);
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
                
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = a.getError();
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
    FMAcceptanceFunction : function(component, event, helper){
        
        var objCC = component.get("v.objCollectionCard");
        objCC.Id = component.get("v.recordId");
        component.set("v.objCollectionCard",objCC);
        
        
        var action = component.get('c.strFMAccpectance');         
        action.setParams({
            "objCollectionCard":component.get("v.objCollectionCard")
        });        
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            if(state == 'SUCCESS') {
                console.log(a.getReturnValue());
                component.set("v.isMapEmpty",true);
                component.set("v.isStop",true);
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = a.getError();
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
    
    convertSlnoToUppercase:function(component, event, helper){     
		var val = event.getSource().get("v.value");
        if(val!=null){
            val = val.toUpperCase();
            var selectCmp = event.getSource();
            selectCmp.set("v.value",val) ;
        }
    },
})