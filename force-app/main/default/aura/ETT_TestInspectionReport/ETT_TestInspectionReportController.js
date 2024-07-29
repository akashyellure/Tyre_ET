({
    doInit : function(component, event, helper) {
        
        helper.fetchPickListVal(component, "ETT_Application_Picklist__c", "applicationMap");
        helper.fetchPickListVal(component, "ETT_Retread_Process_Picklist__c", "retreadProcessMap");
        helper.fetchPickListVal(component, "ETT_RadialNylon__c", "RadialNylonMap");
    
        var stagingContactList = component.get("v.stagingContactList");          

        stagingContactList.push({
            'sobjectType': 'ETT_Staging_Contacts__c',
            'Name': '',
            'Email': '',
            'ETT_Designation__c': '',
            'MobilePhone':''
        });

        component.set("v.stagingContactList", stagingContactList);
        var stagingTestTyreList  = component.get("v.stagingTestTyreList");          
        
        stagingTestTyreList.push({
            'sobjectType': 'ETT_Staging_Test_Tyre__c',
            'ETT_Vehicle_Number__c':'',
            'ETT_Address__c':'',
            'ETT_Location__c':'',
            'ETT_Model__c':'',
            'ETT_Application__c':'',
            'ETT_Load_Capacity__c':'',
            'ETT_Make__c':'',
            'ETT_Tyre_Size__c':'',
            'ETT_Radial__c':'',
            'ETT_Test_No__c':'',            
            'ETT_Brand__c':'',
            'ETT_Nylon__c':'',            
            'ETT_Retread_Process__c':'',
            'ETT_Pattern__c':'',            
            'ETT_Load_Index__c':'',
            'ETT_Hot__c':'',            
            'ETT_Cold__c':'',
            'ETT_Fit_KMS__c':'',            
            'ETT_Date__c':'',
            'ETT_Rem_KMS__c':'',                        
            'ETT_Inspection_Date__c': '',
            'ETT_Axil_Configuration__c':'',
            'ETT_Rubber_Hardness__c':'',
            'ETT_Rec_PSI__c':'',
            'ETT_Tread_Width__c':'',
            'ETT_Tread_Depth__c':'',
            'ETT_Inspection_Date__c':'',
            'ETT_Tyre_Serial_Number__c':'',
            'ETT_Remaining_Tread_Depth_Position__c':'',
            'ETT_Remaining_Tread_Depth_1__c':'',
            'ETT_Remaining_Tread_Depth_2__c':'',
            'ETT_Remaining_Tread_Depth_3__c':'',
            'ETT_Remaining_Tread_Depth_4__c':'',
            'ETT_Remaining_Tread_Depth_Avg__c':'',
            'ETT_Remaining_Tread_Depth_1__c':'',
            'ETT_Original_Tread_Depth__c':'',
            'ETT_KMS_Reading__c':'',
            'ETT_KMS_Covered__c':'',
            'ETT_Wear_In_MM__c':'',
            'ETT_Expected_KMS__c':'',
            'ETT_Remarks__c':'',
            'ETT_Ply_Rating__c':''
        });
        
        component.set("v.stagingTestTyreList", stagingTestTyreList);
        
    },
    doSomething: function (component, event, helper) {},
    onChange: function (component, event, helper) {
        component.set('v.isVehicalLoaded',true);  
        var vehType = component.find('vehType').get('v.value');
        
        if(vehType=='Bus'){
            component.set('v.isBus',true);
            component.set('v.isTruck',false); 
            component.set('v.isTrailor',false);   
            component.set('v.NumberOfTyres',6);               
        }else if(vehType=='Truck'){
            component.set('v.isBus',false);
            component.set('v.isTruck',true); 
            component.set('v.isTrailor',false);   
            component.set('v.NumberOfTyres',10);                           
        }else if(vehType=='Trailor'){
            component.set('v.isBus',false);
            component.set('v.isTruck',false); 
            component.set('v.isTrailor',true);   
            component.set('v.NumberOfTyres',12);                           
        }
        
    },
    AddNewRow : function(component, event, helper){
        
        var stagingTestTyreObj  = component.get("v.stagingTestTyreObj"); 
        
        var addRowInList = component.get("v.stagingTestTyreList");
        console.log(addRowInList.length);
        
        if(addRowInList.length == 1){
            addRowInList[0].ETT_Tyre_Size__c = stagingTestTyreObj.ETT_Tyre_Size__c;
            addRowInList[0].ETT_Brand__c = stagingTestTyreObj.ETT_Brand__c;
            addRowInList[0].ETT_Pattern__c = stagingTestTyreObj.ETT_Pattern__c;            
        }   
        
        var testTyreObj = new Object({'ETT_Tyre_Size__c':stagingTestTyreObj.ETT_Tyre_Size__c,
                                      'ETT_Brand__c':stagingTestTyreObj.ETT_Brand__c,
                                      'ETT_Pattern__c':stagingTestTyreObj.ETT_Pattern__c});
        addRowInList.push(testTyreObj);
        component.set("v.stagingTestTyreList",addRowInList);
        
    },
    removeRow : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingTestTyreList");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingTestTyreList", AllRowsList);
    },
    AddNewRowContact : function(component, event, helper){
        var addRowInList = component.get("v.stagingContactList");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingContactList",addRowInList);
    },
    removeRowContact : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingContactList");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingContactList", AllRowsList);
    },
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    calculateAvg : function(component, event, helper){
        var index = event.getSource().get('v.name');
        var testTyreRowInList = component.get("v.stagingTestTyreList");
        
        if(testTyreRowInList[index].ETT_Remaining_Tread_Depth_1__c != '' &&
           testTyreRowInList[index].ETT_Remaining_Tread_Depth_2__c != '' &&
           testTyreRowInList[index].ETT_Remaining_Tread_Depth_3__c != '' &&
           testTyreRowInList[index].ETT_Remaining_Tread_Depth_4__c != ''){
            
           
            var treadDepth1 = Number(testTyreRowInList[index].ETT_Remaining_Tread_Depth_1__c);
            var treadDepth2 = Number(testTyreRowInList[index].ETT_Remaining_Tread_Depth_2__c);
            var treadDepth3 = Number(testTyreRowInList[index].ETT_Remaining_Tread_Depth_3__c);
            var treadDepth4 = Number(testTyreRowInList[index].ETT_Remaining_Tread_Depth_4__c);
            var sumOfTreadDepth = (treadDepth1+treadDepth2+treadDepth3+treadDepth4);
            testTyreRowInList[index].ETT_Remaining_Tread_Depth_Avg__c = sumOfTreadDepth/4;
            
            component.set("v.stagingTestTyreList",testTyreRowInList);
        }
       
    },
    clickCreate : function(component, event, helper){
        
        var recordId = component.get("v.recordId");
        var stagingTestTyreObj  = component.get("v.stagingTestTyreObj");        
        var stagingTestTyreList  = component.get("v.stagingTestTyreList");
        var stagingContactList = component.get("v.stagingContactList");          
        
        if(stagingTestTyreObj.ETT_Vehicle_Number__c=='' || 
           stagingTestTyreObj.ETT_Address__c=='' || 
           stagingTestTyreObj.ETT_Location__c=='' || 
           stagingTestTyreObj.ETT_Application_Picklist__c=='' || 
           stagingTestTyreObj.ETT_Load_Capacity__c=='' || 
           stagingTestTyreObj.ETT_Make__c==''){
            
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:'Customer Name, Contact Person, Vehcile No, Address, Location , Application, Load Capacity and Make fields are mandatory.'
            });
            
            return false;
            
        }
        
        
        
        if(stagingTestTyreObj.ETT_Test_No__c=='' ||
           stagingTestTyreObj.ETT_Brand__c=='' ||
           stagingTestTyreObj.ETT_Brand__c==null ||           
           stagingTestTyreObj.ETT_Pattern__c=='' ||
           stagingTestTyreObj.ETT_Pattern__c==null ||           
           stagingTestTyreObj.ETT_Tyre_Size__c=='' ||
           stagingTestTyreObj.ETT_Tyre_Size__c==null ||
           stagingTestTyreObj.ETT_Tread_Depth__c=='' ||
           stagingTestTyreObj.ETT_Retread_Process_Picklist__c==''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:'Tyre Size, Test No, Brand, Pattern, Retread Process, Tread Dept fields are mandatory.'
            });
            
            return false;
            
        }
            
        if(stagingTestTyreList.length > 0){
            console.log('inside if');            
            for(var i=0;i<stagingTestTyreList.length;i++){

                if(stagingTestTyreList[i].ETT_Inspection_Date__c == '' ||
                   stagingTestTyreList[i].ETT_Tyre_Serial_Number__c == '' ||
                   stagingTestTyreList[i].ETT_Tyre_Serial_Number__c == null ||
                   stagingTestTyreList[i].ETT_Remaining_Tread_Depth_Position__c == '' ||
                   stagingTestTyreList[i].ETT_Remaining_Tread_Depth_1__c == '' ||
                   stagingTestTyreList[i].ETT_Remaining_Tread_Depth_2__c == '' ||
                   stagingTestTyreList[i].ETT_Remaining_Tread_Depth_3__c == '' ||
                   stagingTestTyreList[i].ETT_Remaining_Tread_Depth_4__c == '' ||
                   stagingTestTyreList[i].ETT_Remaining_Tread_Depth_Avg__c == '' ||
                   stagingTestTyreList[i].ETT_Original_Tread_Depth_lookup__c == '' ||
                   stagingTestTyreList[i].ETT_Original_Tread_Depth_lookup__c == null ||                   
                   stagingTestTyreList[i].ETT_KMS_Reading__c == '' ||
                   stagingTestTyreList[i].ETT_Wear_In_MM__c == '' ||
                   stagingTestTyreList[i].ETT_Expected_KMS__c == ''){
                    
                    helper.showErrorToast({
                        title: "Error: ",
                        type: "error",
                        message:'Insp.Date, Tyre Sl.No, Position, Remaining Tread Depth, Avg, Original Tread Dept, Kms Reading, wear in mm, Expected Kms fields are mandatory.'
                    });
                    
                    return false;
                }
                
                stagingTestTyreList[i].ETT_Tyre_Size__c = stagingTestTyreObj.ETT_Tyre_Size__c;
                stagingTestTyreList[i].ETT_Brand__c = stagingTestTyreObj.ETT_Brand__c;
                stagingTestTyreList[i].ETT_Pattern__c = stagingTestTyreObj.ETT_Pattern__c;            
                stagingTestTyreList[i].ETT_Date__c = stagingTestTyreObj.ETT_Date__c;            
                
                //First Table Values
                stagingTestTyreList[i].Name = component.get("v.stgTestTyreRecord").Name;
                stagingTestTyreList[i].ETT_Contact_Person__c = component.get("v.stgTestTyreRecord").Name;                
                stagingTestTyreList[i].ETT_Inspector_Name__c = component.get("v.stgTestTyreRecord").ETT_Inspector_Name__c;                
                
                
                stagingTestTyreList[i].ETT_Vehicle_Number__c = stagingTestTyreObj.ETT_Vehicle_Number__c;
                stagingTestTyreList[i].ETT_Address__c = stagingTestTyreObj.ETT_Address__c;
                stagingTestTyreList[i].ETT_Location__c = stagingTestTyreObj.ETT_Location__c;
                stagingTestTyreList[i].ETT_Model__c = stagingTestTyreObj.ETT_Model__c;
                stagingTestTyreList[i].ETT_Application__c = stagingTestTyreObj.ETT_Application__c;
                stagingTestTyreList[i].ETT_Load_Capacity__c = stagingTestTyreObj.ETT_Load_Capacity__c;                
                stagingTestTyreList[i].ETT_Make__c = stagingTestTyreObj.ETT_Make__c;                                
                
                //Second Table Values
                stagingTestTyreList[i].ETT_Test_No__c = stagingTestTyreObj.ETT_Test_No__c;
                stagingTestTyreList[i].ETT_Retread_Process_Picklist__c = stagingTestTyreObj.ETT_Retread_Process_Picklist__c;
                stagingTestTyreList[i].ETT_Load_Index__c = stagingTestTyreObj.ETT_Load_Index__c;
                stagingTestTyreList[i].ETT_Fit_KMS__c = stagingTestTyreObj.ETT_Fit_KMS__c;
                stagingTestTyreList[i].ETT_Date__c = stagingTestTyreObj.ETT_Date__c;
                stagingTestTyreList[i].ETT_Tread_Depth__c = stagingTestTyreObj.ETT_Tread_Depth__c;
                stagingTestTyreList[i].ETT_Ply_Rating__c = stagingTestTyreObj.ETT_Ply_Rating__c;
                stagingTestTyreList[i].ETT_Rem_KMS__c = stagingTestTyreObj.ETT_Rem_KMS__c;
                stagingTestTyreList[i].ETT_Tread_Width__c = stagingTestTyreObj.ETT_Tread_Width__c;
                stagingTestTyreList[i].ETT_Rec_PSI__c = stagingTestTyreObj.ETT_Rec_PSI__c;
                stagingTestTyreList[i].ETT_Rubber_Hardness__c = stagingTestTyreObj.ETT_Rubber_Hardness__c;
                stagingTestTyreList[i].ETT_Axil_Configuration__c = stagingTestTyreObj.ETT_Axil_Configuration__c;                
                
            }
        }
        
                if(stagingContactList!=null && stagingContactList.length>0){
            for(var i=0;i<stagingContactList.length;i++){
                
                if((stagingContactList[i].Name!=''&&stagingContactList[i].Name!=null)||
                   (stagingContactList[i].Email!=''&&stagingContactList[i].Email!=null)||
                   (stagingContactList[i].ETT_Designation__c!=''&&stagingContactList[i].ETT_Designation__c!=null)||
                   (stagingContactList[i].MobilePhone!=''&&stagingContactList[i].MobilePhone!=null)){
                    
                    if(stagingContactList[i].Name=='' || stagingContactList[i].Name==null ||
                       stagingContactList[i].Email=='' || stagingContactList[i].Email==null ||
                       stagingContactList[i].MobilePhone=='' || stagingContactList[i].MobilePhone==null){
                        helper.showErrorToast({
                            "title": "Required: Contact",
                            "type": "error",
                            "message": "Name, Email, Mobile Fields are required"
                        });
                        return false;
                    }
                    
                    //validation start
                    
                    var nameReg = /^[a-zA-Z ]*$/;
                    var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
                    var phonRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$/;
                    
                    if(!stagingContactList[i].Name.toString().match(nameReg)){
                        helper.showErrorToast({
                            "title": "Required: Contact",
                            "type": "error",
                            "message": "Please enter valid Name"
                        });
                        return false;
                    }     
                    
                    if(!stagingContactList[i].Email.match(regExpEmailformat)){
                        helper.showErrorToast({
                            "title": "Required: Contact",
                            "type": "error",
                            "message": "Please enter valid Email Address"
                        });
                        return false;
                    }
                    
                    if(!stagingContactList[i].MobilePhone.toString().match(phonRegex)){
                        helper.showErrorToast({
                            "title": "Required: Contact",
                            "type": "error",
                            "message": "Please enter valid Mobile"
                        });
                        return false;
                    }
                    
                    //validation end                    
                }
            }
        }
     
        
        var newLead = component.get("v.newLead");
        newLead.Id = component.get("v.recordId");
        newLead.LastName = component.get("v.stgTestTyreRecord").LastName;
        var stgLeadJson = JSON.stringify(newLead);
                var stgContactJson  = JSON.stringify(stagingContactList);
        
        var actSave = component.get("c.saveDML");
        var mapNameForStagingObjects = {
            stgLeadJson: stgLeadJson,
            stgTestTyreJson: JSON.stringify(stagingTestTyreList),
            stgContactJson:stgContactJson
        };
        
        console.log(mapNameForStagingObjects);
        
        actSave.setParams({
            mapofStageJsonList: mapNameForStagingObjects
        });
        
        actSave.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state: '+state);
            if (state === "SUCCESS") {
                console.log('***Before ****'+response.getReturnValue());
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + response.getReturnValue()
                });
                urlEvent.fire();
                console.log(response.getReturnValue());
                
            }else if(state === "ERROR"){
                var errors = actSave.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        
                        helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:errors[0].message
                        });
                        
                    }
                }
            }else if (status === "INCOMPLETE") {
                
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:'No response from server or client is offline.'
                });
                
                console.log('No response from server or client is offline.');
            }else {
                console.log("Failed with state: " + state);
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:state
                });
            }
        });
        $A.enqueueAction(actSave);
        
        
        
    }
    
    
})