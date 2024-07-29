({
    doInit : function(component, event, helper) {
        
        var collectionLineItemList  = component.get("v.lstCollectionLineItem"); 
        collectionLineItemList.push({
            'sobjectType': 'WorkOrderLineItem',
            'ETT_Tyre_Size__c':'',
            'ETT_Tyre_Size_Name__c':'',
            'ETT_Brand__c':'',
            'ETT_Brand_Name__c':'',
            'ETT_Pattern__c':'',
            'ETT_Pattern_Name__c':'',
            'ETT_Country_of_Origin__c':'',
            'ETT_Country_of_Origin_Name__c':'',
            'ETT_Price__c':'',
            'ETT_Load_Index__c':'',
            'ETT_S_Index__c':'',
            'ETT_PR__c':'',
            'ETT_Tyre_Serial_Number__c':'',
            'ETT_Job_Type__c':'',
            'ETT_Remarks__c':'',
            'ETT_Quantity__c': 1,
            'ETT_Tyre_Life__c':'1',
            'ETT_New_Tyre_Size__c':'',
            'ETT_New_Brand__c':'',
            'ETT_New_Country__c':'',
            'ETT_New_Pattern__c':'',
            'ETT_Tyre_Size_NewText__c':'',
            'ETT_Brand_NewText__c':'',
            'ETT_Pattern_NewText__c':'',
            'ETT_Country_NewText__c':''
        }); 
        component.set("v.lstCollectionLineItemNewTyres",collectionLineItemList);
        
    },
    /* 
    getRecordTypeName : function(component, event, helper){
        alert("inside here");
        var showvlaueresult = event.getParam("leadRecordTypeName");
        alert(showvlaueresult);
    },
*/    
    convertCase: function(component, event, helper){
        var val = event.getSource().get("v.value");
        if(val!=null)
        {
            val = val.toUpperCase();
            var selectCmp = event.getSource();
            selectCmp.set("v.value",val) ;  
        }
        
    },
    
    
    addNewRowsIntoTyreMaster : function(component, event, helper){
        var addRowInList = component.get("v.lstCollectionLineItemNewTyres");
        var contactObj = new Object();
        contactObj.ETT_Tyre_Size_NewText__c = '';
        contactObj.ETT_Brand_NewText__c = '';
        contactObj.ETT_Pattern_NewText__c = '';        
        contactObj.ETT_Country_NewText__c = '';
        addRowInList.push(contactObj);
        component.set("v.lstCollectionLineItemNewTyres",addRowInList);
    },
    removeRowsIntoTyreMaster : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.lstCollectionLineItemNewTyres");
        console.log('****whichOne****'+whichOne);
        AllRowsList.splice(whichOne, 1);
        component.set("v.lstCollectionLineItemNewTyres", AllRowsList);
    },
    callChildMethod : function(component, event, helper) {
        //debugger;
        var params = event.getParam("arguments");
        var leadId = params[0];
        var source = params[2];
        var isEmpty = false;
        var isPriceEmpty = false;
        var lstCollectionLineItemNewTyres = component.get("v.lstCollectionLineItemNewTyres");
        
        console.log('sr '+JSON.stringify(component.get("v.lstCollectionLineItemNewTyres")));
        console.log(JSON.stringify(params));
        
        if(params[1]=='validate'){
            debugger;
            if(lstCollectionLineItemNewTyres!=null && lstCollectionLineItemNewTyres.length>0){
                for(var i=0;i<lstCollectionLineItemNewTyres.length;i++){
                    
                    if(lstCollectionLineItemNewTyres[i].ETT_Tyre_Size_NewText__c=='' &&
                       lstCollectionLineItemNewTyres[i].ETT_Brand_NewText__c=='' &&
                       lstCollectionLineItemNewTyres[i].ETT_Country_NewText__c==''){
                        isEmpty = true;
                        helper.showErrorToast({
                            title: "Required: ",
                            type: "error",
                            message:
                            "Please Enter Tyre Details."
                        });
                        return false;
                    }
                    
                    if(lstCollectionLineItemNewTyres[i].ETT_Tyre_Size_NewText__c=='' ||
                       lstCollectionLineItemNewTyres[i].ETT_Brand_NewText__c=='' ||
                       lstCollectionLineItemNewTyres[i].ETT_Country_NewText__c==''){
                        isEmpty = true;
                        helper.showErrorToast({
                            title: "Required: ",
                            type: "error",
                            message:
                            "Please Enter Tyre Size, Brand and Country."
                        });
                        return false;
                    }
                    
                }
            }
        }
        
        
        //if(params[1]=='validateSupplier' && leadId =='0000'){
        /*
        if(lstCollectionLineItemNewTyres!=null && lstCollectionLineItemNewTyres.length>0){
            for(var i=0;i<lstCollectionLineItemNewTyres.length;i++){
                if(lstCollectionLineItemNewTyres[i].ETT_Tyre_Size_NewText__c=='' &&
                   lstCollectionLineItemNewTyres[i].ETT_Brand_NewText__c=='' &&
                   lstCollectionLineItemNewTyres[i].ETT_Pattern_NewText__c=='' &&
                   lstCollectionLineItemNewTyres[i].ETT_Price__c=='' &&
                   lstCollectionLineItemNewTyres[i].ETT_Country_NewText__c==''){
                    isEmpty = true;
                }
                if(lstCollectionLineItemNewTyres[i].ETT_Tyre_Size_NewText__c!=''||
                   lstCollectionLineItemNewTyres[i].ETT_Brand_NewText__c!=''||
                   lstCollectionLineItemNewTyres[i].ETT_Pattern_NewText__c!=''||
                   lstCollectionLineItemNewTyres[i].ETT_Country_NewText__c!=''){
                    if(lstCollectionLineItemNewTyres[i].ETT_Price__c=='')
                    {
                        isPriceEmpty = true;
                    }
                }
            }
        }
       
        if(isPriceEmpty)
        {
            var updateEvent = component.getEvent("updateNewTyreEvent");
            updateEvent.setParams({
                "ErrorAddNewTyreDetail" :  true           });
            updateEvent.fire();
            alert('ErrorAddNewTyreDetail updated');
            alert(updateEvent.getParam('ErrorAddNewTyreDetail'));
             helper.showErrorToast({
                    title: "Required: ",
                    type: "error",
                    message:
                    "Please Enter 'Price' for Add New Tyre Details."
                });
                return false;
            } */
        
        if(params[1]=='send'){
            //update data into event
            
            var sendNewTyreData = false;
            
            if(lstCollectionLineItemNewTyres!=null && lstCollectionLineItemNewTyres.length>0){
                for(var i=0;i<lstCollectionLineItemNewTyres.length;i++){
                   // alert(lstCollectionLineItemNewTyres[i].ETT_Tyre_Size_NewText__c);
                   // alert(lstCollectionLineItemNewTyres[i].ETT_Brand_NewText__c);
                    //alert(lstCollectionLineItemNewTyres[i].ETT_Country_NewText__c);
                    if(lstCollectionLineItemNewTyres[i].ETT_Tyre_Size_NewText__c!='' ||
                       lstCollectionLineItemNewTyres[i].ETT_Brand_NewText__c!='' ||
                       lstCollectionLineItemNewTyres[i].ETT_Country_NewText__c!=''){
                        sendNewTyreData = true;
                    }
                    
                    
                }
            }
            
            if(sendNewTyreData==true)
            {
                var updateEvent = component.getEvent("updateNewTyreEvent");
                updateEvent.setParams({
                    "lstWOLI" : lstCollectionLineItemNewTyres
                });
                updateEvent.fire();
                
                var action = component.get('c.addNewTyreMasterDetails');         
                action.setParams({
                    "lstCollectionLineItemNewTyres":JSON.stringify(component.get("v.lstCollectionLineItemNewTyres")),
                    "leadId":leadId,
                    "source":source
                });  
                
                action.setCallback(this, function(a){
                    var state = a.getState(); 
                    console.log(state);
                    if(state == 'SUCCESS') {
                        console.log('Res: '+a.getReturnValue());
                        
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
                
                
                if(!isEmpty){
                    $A.enqueueAction(action);
                }
            }
            
        }
        
        
    }
})