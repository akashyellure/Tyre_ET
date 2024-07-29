({
    doInit : function(component, event, helper) {
        
        var lstTyreRejectionLineItem = component.get("v.lstTyreRejectionLineItem");
        lstTyreRejectionLineItem.push({'sobjectType': 'ETT_Tyre_Rejection_Report__c',
                                       'ETT_Brand__c':'',
                                       'ETT_Country__c':'',
                                       'ETT_Pattern__c':'',
                                       'ETT_Tyre_Size__c':''});
        component.set("v.lstTyreRejectionLineItem",lstTyreRejectionLineItem);
        
        
        /* var objCLI = component.get("v.objCLI");
        console.log(JSON.stringify(objCLI));
        
        var lstTyreRejectionWrapper = component.get("v.lstTyreRejectionWrapper");
        lstTyreRejectionWrapper.push({'objTyreRejectionSubLineItems':objCLI,
                                      'lstFileWrapperDetails':[]});
        component.set("v.lstTyreRejectionWrapper",lstTyreRejectionWrapper);
        console.log(JSON.stringify(component.get("v.lstTyreRejectionWrapper")));
        */
        
        
        var action = component.get('c.getRejectedTyres'); 
        action.setParams({
            "CCId":component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            
            var state = a.getState(); 
            console.log(state);
            
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                
                console.log(JSON.stringify(result));
                if(result.length>0){
                    
                    for(var key in result[0]){
                        if(key=='ETT_Check_out__c'){
                            component.set("v.isCheckoutDone",true);
                        }
                        //console.log('key: '+key+' '+'val: '+result[0][key]);
                    }
                    
                    
                    component.set("v.lstTyreRejectionLineItem",result);
                    component.set("v.update",true);
                }
                console.log('Res: '+JSON.stringify(result));
        
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);        
		
        
        var actionUser = component.get("c.fetchUser");
        actionUser.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log(JSON.stringify(storeResponse));
                for(var key in storeResponse['Profile']){

                    if(storeResponse['Profile']['Name']=='ETT_Receptionist'){
                        component.set('v.isUserReceptionist',true);
                    }
                }

            }
        });
        $A.enqueueAction(actionUser);
    console.log(JSON.stringify(component.get('v.isUserReceptionist')));
        
    },
    
    handleComponentEvent : function(component, event, helper){
        var name = event.getParam("name");
        var index = event.getParam("index");
        var dynamicId = event.getParam("dynamicId");
        var objectName = event.getParam("objectName");
        
        
        if (objectName == "ETT_Tyre_Size_Master__c") {
            component.set("v.TyreSizeName", name);
            component.set("v.TyreSizeId", dynamicId);
            
        } else if (objectName == "ETT_Brand_Master__c") {
            
            component.set("v.BrandName", name);
            component.set("v.BrandId", dynamicId);
            
        } else if (objectName == "ETT_Pattern_Master__c") {
            
            component.set("v.PatternName", name);
            component.set("v.PatternId", dynamicId);
            
        } else if (objectName == "ETT_Country_Master__c") {
            
            component.set("v.CountryName", name);
            component.set("v.CountryId", dynamicId);
            
        }
    },
    
    addNewRowCollectionLineItem : function(component, event, helper){
        var addRowInList = component.get("v.lstTyreRejectionLineItem");
        var contactObj = new Object();
        contactObj.ETT_Brand__c='';
        contactObj.ETT_Country__c='';
        contactObj.ETT_Pattern__c='';
        contactObj.ETT_Tyre_Size__c='';
        contactObj.ETT_Rejection_Reason__c='';
//        contactObj.sobjectType='ETT_Tyre_Rejection_Report__c';
//        'sobjectType': 'ETT_Tyre_Rejection_Report__c'
        addRowInList.push(contactObj);
        component.set("v.lstTyreRejectionLineItem",addRowInList);
        
        component.set("v.TyreSizeName",'');
        component.set("v.BrandName",'');
        component.set("v.PatternName",'');
        component.set("v.CountryName",'');
        
    },
    removeRowCollectionLineItem : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.lstTyreRejectionLineItem");
        console.log('****whichOne****'+whichOne);
        AllRowsList.splice(whichOne, 1);
        component.set("v.lstTyreRejectionLineItem", AllRowsList);
    },
    
    handleFilesChange: function (component, event, helper) {
        
        //var Filelist = [];
        //Filelist = component.get("v.fileName");
        var files = component.get("v.fileToBeUploaded");
        var fileUploadWrapper = [];
        var contentWrapperArr = [];
        var fileSourceType = event.getSource().get("v.id");
        var areaName = event.getSource().get("v.name");
        console.log('fileSourceType: '+fileSourceType);
        var Filelist='';
        if(files && files.length > 0) {
            if (files[0].length > 1) {
                for (var i = 0; i < files[0].length; i++){
                    var file = files[0][i];
                    var fileName = file.name;
                    if(i != (files[0].length-1)){
                        Filelist+=fileName+',';
                    }else{
                    	Filelist+=fileName;
                    }
                }
            }else if (files[0].length == 1) {
                var file = files[0][0];
                var fileName = file.name;
                Filelist=fileName;
            }
            
            for(var i=0; i < files[0].length; i++){
                var file = files[0][i];
                var reader = new FileReader();
                reader.name = file.name;
                reader.type = file.type;
                
                console.log(file.name);
                console.log(file.type);
                
                reader.onloadend = function(e) {
                    
                    var base64Img = e.target.result;
                    var base64result = base64Img.split(',')[1];
                    
                    fileUploadWrapper.push({
                        'strFileName':e.target.name,
                        'strFileType':e.target.type,
                        'fileSourceType':fileSourceType,
                        'fileContent':base64result,//e.target.result,
                        'strRejectionName':'',
                        'parentId':''
                    });
                    contentWrapperArr.push({
                        'strFileName':e.target.name,
                        'strFileType':e.target.type,
                        'fileSourceType':fileSourceType,
                        'fileContent':base64result,//e.target.result,
                        'strRejectionName':'',
                        'parentId':''
                    });
                }
                
                function handleEvent(event) {
                    if(contentWrapperArr.length == i){
                        
                        var tyre = component.get("v.lstTyreRejectionLineItem");
                        
                        var lstTyreRejectionWrapper = component.get("v.lstTyreRejectionWrapper");
                        lstTyreRejectionWrapper.push({
                            'TyreSize':tyre[fileSourceType].ETT_Tyre_Size__c,
                            'Brand':tyre[fileSourceType].ETT_Brand__c,
                            'Pattern':tyre[fileSourceType].ETT_Pattern__c,
                            'Country':tyre[fileSourceType].ETT_Country__c,
                            'Quantity':tyre[fileSourceType].ETT_Quantity__c,
                            'RejectionReason':tyre[fileSourceType].ETT_Rejection_Reason__c,
                            'CCName':component.get("v.CollectionCardRecord").Name,
                            'Account':component.get("v.CollectionCardRecord").ETT_Accounts__c,
                            'Driver':component.get("v.CollectionCardRecord").Driver_Name__c,
                            'ServiceAppointment':component.get("v.CollectionCardRecord").Collection_Appointment__r.Name,
                            'RecordKey':tyre[fileSourceType].ETT_Tyre_Size__c+'#'+tyre[fileSourceType].ETT_Brand__c+'#'+tyre[fileSourceType].ETT_Pattern__c+'#'+tyre[fileSourceType].ETT_Country__c+'#',    
                            'lstFileWrapperDetails':contentWrapperArr});
                        
                        component.set("v.lstTyreRejectionWrapper",lstTyreRejectionWrapper);
                    }
                }
                
                reader.readAsDataURL(file);
                reader.addEventListener('loadend', handleEvent);
                
            }
        }
        console.log("Filelist "+Filelist);
        var divId = "div-"+fileSourceType;//.toString();
        console.log("JSON.stringify "+JSON.stringify(component.find('"'+divId+'"')));
        console.log("JSON.stringify "+JSON.stringify(component.find(divId)));
        console.log("JSON.stringify element Id "+document.getElementById(divId));
        var divComp = document.getElementById(divId);//[0].set("v.body",Filelist);
        //divComp[0].getElements()[0].innerHTML = Filelist;
        divComp.innerHTML = Filelist;
        //component.set("v.fileName", Filelist);
        
        //document.getElementById('0').innerHTML =Filelist;
    },
    
    update: function (component, event, helper){
        
        var tyreRejectionLineItem  = component.get("v.lstTyreRejectionLineItem"); 
        
        for(var i=0;i<tyreRejectionLineItem.length;i++){
            
            console.log('i: '+i);
            
            console.log(component.get("v.CollectionCardRecord").Name);
            console.log(component.get("v.CollectionCardRecord").ETT_Accounts__c);
            console.log(component.get("v.CollectionCardRecord").Driver_Name__c);
            console.log(component.get("v.CollectionCardRecord").Collection_Appointment__r.Name);            
            tyreRejectionLineItem[i].sobjectType = 'ETT_Tyre_Rejection_Report__c';
            tyreRejectionLineItem[i].ETT_Collection_Card__c = component.get("v.CollectionCardRecord").Name;
            tyreRejectionLineItem[i].ETT_Account__c = component.get("v.CollectionCardRecord").ETT_Accounts__c;
            tyreRejectionLineItem[i].ETT_Driver_Name__c = component.get("v.CollectionCardRecord").Driver_Name__c;
            tyreRejectionLineItem[i].ETT_Service_Appointment__c = component.get("v.CollectionCardRecord").Collection_Appointment__r.Name;
            
            delete tyreRejectionLineItem[i]['ETT_Brand__r'];
            delete tyreRejectionLineItem[i]['ETT_Country__r'];
            delete tyreRejectionLineItem[i]['ETT_Pattern__r'];
            delete tyreRejectionLineItem[i]['ETT_Tyre_Size__r'];
        }
        console.log(JSON.stringify(tyreRejectionLineItem));
        
     //   return false;
        
        var action = component.get('c.updateRejectedTyres');    
        
        var mapNameForStagingObjects = {
            "stgTyreRejectionJson":JSON.stringify(tyreRejectionLineItem)
        };
        
        action.setParams({
            "mapofStageJsonList":mapNameForStagingObjects
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
        
    },
    checkout: function (component, event, helper){
        
        var action = component.get('c.checkoutRejectedTyres');    
        
        action.setParams({
            "strCollectionCard":component.get("v.recordId")
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
        
        
    },
    submit: function (component, event, helper){
        
        var tyreRejectionLineItem  = component.get("v.lstTyreRejectionLineItem"); 
        var lstTyreRejectionWrapper = component.get("v.lstTyreRejectionWrapper");
        var isUpdate = component.get("v.update");

        if(tyreRejectionLineItem!=null && tyreRejectionLineItem.length>0){
            for(var i=0;i<tyreRejectionLineItem.length;i++){
                
                if(tyreRejectionLineItem[i].ETT_Tyre_Size__c==''){
                    helper.showErrorToast({
                        "title": "Required",
                        "type": "error",
                        "message": "Please select Tyre Size"
                    });
                    
                    return false;
                }
                if(tyreRejectionLineItem[i].ETT_Brand__c==''){
                    helper.showErrorToast({
                        "title": "Required",
                        "type": "error",
                        "message": "Please select Brand"
                    });
                    
                    return false;
                }
                if(tyreRejectionLineItem[i].ETT_Pattern__c==''){
                    helper.showErrorToast({
                        "title": "Required",
                        "type": "error",
                        "message": "Please select Pattern"
                    });
                    
                    return false;
                }
                if(tyreRejectionLineItem[i].ETT_Country__c==''){
                    helper.showErrorToast({
                        "title": "Required",
                        "type": "error",
                        "message": "Please select Country"
                    });
                    
                    return false;
                }
                if(!("ETT_Rejection_Reason__c" in tyreRejectionLineItem[i] )) {
                    helper.showErrorToast({
                        "title": "Required",
                        "type": "error",
                        "message": "Please enter Rejection Reason"
                    });
                    
                    return false;
                }                
            }
        }
        
        if(lstTyreRejectionWrapper.length==0){
            var tyre = component.get("v.lstTyreRejectionLineItem");
            if(tyre!=null && tyre.length>0){
                for(var i=0;i<tyre.length;i++){
                    var contentWrapperArr = [];
                    var lstTyreRejectionWrapper = component.get("v.lstTyreRejectionWrapper");
                    lstTyreRejectionWrapper.push({
                        'TyreSize':tyre[i].ETT_Tyre_Size__c,
                        'Brand':tyre[i].ETT_Brand__c,
                        'Pattern':tyre[i].ETT_Pattern__c,
                        'Country':tyre[i].ETT_Country__c,
                        'Quantity':tyre[i].ETT_Quantity__c,
                        'RejectionReason':tyre[i].ETT_Rejection_Reason__c,
                        'CCName':component.get("v.CollectionCardRecord").Name,
                        'Account':component.get("v.CollectionCardRecord").ETT_Accounts__c,
                        'Driver':component.get("v.CollectionCardRecord").Driver_Name__c,
                        'ServiceAppointment':component.get("v.CollectionCardRecord").Collection_Appointment__r.Name,
                        'RecordKey':tyre[i].ETT_Tyre_Size__c+'#'+tyre[i].ETT_Brand__c+'#'+tyre[i].ETT_Pattern__c+'#'+tyre[i].ETT_Country__c+'#',    
                        'lstFileWrapperDetails':contentWrapperArr});
                }
            }
            component.set("v.lstTyreRejectionWrapper",lstTyreRejectionWrapper);
        }
        
        console.log(JSON.stringify(tyreRejectionLineItem));
        console.log(JSON.stringify(lstTyreRejectionWrapper));
        

        //return false;
        
        var action = component.get('c.saveRejectedTyres');    
        
        var mapNameForStagingObjects = {
            "stgTyreRejectionJson":JSON.stringify(component.get("v.lstTyreRejectionWrapper"))
        };
        
        action.setParams({
            "mapofStageJsonList":mapNameForStagingObjects
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

})