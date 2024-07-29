({
    doInit : function(component, event, helper) {
        //   alert(component.get("v.recordId"));
        var systemdate = new Date();
        var defaultValue = $A.localizationService.formatDate(systemdate, "YYYY-MM-DDT00:00" );
        // alert(defaultValue);
        var today = $A.localizationService.formatDate(systemdate, "YYYY-MM-DD");
        //    alert(today);
        component.set("v.todaysDate",today);
        component.set("v.FleetInspectionObj.ETT_Date__c",today);
        // var leadLocation = component.get("v.stgFleetInspectRecordLocation.ETT_Location__c");
        // var name = component.get("v.stgFleetInspectRecord.Name");
        //  alert(name);
        //   component.set("v.FleetInspectionObj.ETT_Location__c",leadLocation);
     //  Component.set("v.FleetInspectionObj.ETT_Vehicle_Number__c",UP3393);
        
        helper.fetchPickListVal(component, "ETT_Party_Type__c", "PartyType");
        helper.fetchPickListVal(component, "ETT_Vehicle_Configuration__c", "VehicleConfiguration");
        helper.fetchPickListValFromFleetChild(component, "Tyre_Status__c", "TyreStatusPicklst");
        helper.fetchPickListValFromFleetChild(component, "ETT_Action__c", "FleetAction");
        helper.fetchPickListValFromFleetChild(component, "ETT_Condition__c", "FleetCondition");
         helper.fetchPickListValFromFleetChild(component, "ETT_Bad_Reason_Complaint__c", "FleetBadReason");
      
        var FleetInspectionLineItemList  = component.get("v.FleetInspectionLineItemList");          
      //    alert(FleetInspectionLineItemList.length);
       FleetInspectionLineItemList.push({
            'sobjectType': 'Fleet_Inspection_Line_Item__c',
            'ETT_Brand__c': '',
            'ETT_Tyre_Size__c': '',
            'Tyre_Status__c': '',
           'ETT_Tyre_Size_Name__c': '',
           'ETT_Tyre_Brand_Name__c': '',
           'ETT_Tyre_Pattern_Name__c': '',
            'Retread_Tread_Design__c': '',
            'Remarks__c':'',
            'Retreader__c':'',
            'ETT_Pattern__c':'',
            'Serial_Number__c':'',
            'ETT_Pattern__c':'',
            'Tread_Depth__c':'',
            'Tyre_Position__c':'' 
            
        });
       
        component.set("v.FleetInspectionLineItemList",FleetInspectionLineItemList);
         var action = component.get("c.getLeadInfo");
        action.setParams({ "leadId" : component.get("v.recordId") }); 
       
        action.setCallback(this, function(response) {
            var state = response.getState();
             
            if (state === "SUCCESS") {
              
                var res = response.getReturnValue();
              
               
                component.set('v.newLead',res);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                var errors = response.getError();
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
        var action = component.get("c.getCustomerProfile");
        action.setParams({ id : component.get("v.recordId") });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var objLead = component.get('v.newLead');
                objLead.Id = res.Id;
                objLead.Company = res.Company;
                objLead.Street = res.Street;
                objLead.Phone = res.Phone;
                objLead.LastName = res.LastName; 
                objLead.ETT_P_O_Box__c = res.ETT_P_O_Box__c;
                objLead.ETT_Location__c = res.ETT_Location__c;
                objLead.Fax = res.Fax;
                objLead.Email = res.Email;
                objLead.ETT_VAT_TRN__c = res.ETT_VAT_TRN__c;
                objLead.ETT_Nature_of_Business__c = res.ETT_Nature_of_Business__c;
                objLead.ETT_Legal_Status__c = res.ETT_Legal_Status__c;
                objLead.ETT_Name_of_Owners_Sponsors_1__c = res.ETT_Name_of_Owners_Sponsors_1__c;                
                objLead.ETT_Name_of_Owners_Sponsors_2__c = res.ETT_Name_of_Owners_Sponsors_2__c;
                objLead.ETT_Owners_Sponers_Phone_2__c = res.ETT_Owners_Sponers_Phone_2__c;
                objLead.ETT_Trade_License_Number__c = res.ETT_Trade_License_Number__c;
                objLead.ETT_Trade_Licenses_Expiry_Date__c = res.ETT_Trade_Licenses_Expiry_Date__c;                
                objLead.ETT_Chamber_of_Commerce_Certification_No__c = res.ETT_Chamber_of_Commerce_Certification_No__c;
                objLead.ETT_Chamber_of_Comm_Cert_Expiry_Date__c = res.ETT_Chamber_of_Comm_Cert_Expiry_Date__c;
                objLead.ETT_Name_of_Chief_Executive_Officer__c = res.ETT_Name_of_Chief_Executive_Officer__c;
                component.set('v.newLead',objLead);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                var errors = response.getError();
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
        //console.log('FleetBadReason-------->'+component.get('v.FleetBadReason'));
        
    },
    convertCase:function(component, event, helper){
  var val = event.getSource().get("v.value");
        if(val!=null)
        {
          val = val.toUpperCase();
        var selectCmp = event.getSource();
        selectCmp.set("v.value",val) ;  
        }
        },
     handleGenreChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
         
        //Update the Selected Values 
      // alert(selectedValues);
       
        component.set("v.selectedGenreList", selectedValues);
    },
     getSelectedGenre : function(component, event, helper){
        //Get selected Genre List on button click 
        var selectedValues = component.get("v.selectedGenreList");
        console.log('Selectd Genre-' + selectedValues);
    },

    onChange: function (component, event, helper) {

        component.set("v.FleetInspectionLineItemList",'');   
        component.set("v.itemSelectedTyreSizeID",'');   
        component.set("v.itemSelectedTyreBrandID",'');   
        component.set("v.itemSelectedTyrePatternID",'');   
        component.set('v.isVehicalLoaded',true);        
        var vehType = component.find('vehType').get('v.value');
        component.set('v.FleetInspectionObj.ETT_Type__c',vehType);
        
        if(vehType=='Bus'){
            component.set('v.isBus',true);
            component.set('v.isTruck',false); 
            component.set('v.isTrailor',false);   
            component.set('v.NumberOfTyres',6);               
        }else if(vehType=='Mini Bus'){
            component.set('v.isBus',true);
            component.set('v.isTruck',false); 
            component.set('v.isTrailor',false);   
            component.set('v.NumberOfTyres',6);                           
        }
        else if(vehType=='Truck'){
            component.set('v.isBus',false);
            component.set('v.isTruck',true); 
            component.set('v.isTrailor',false);   
            component.set('v.NumberOfTyres',10);                           
        }else if(vehType=='LCV'){
            component.set('v.isBus',false);
            component.set('v.isTruck',true); 
            component.set('v.isTrailor',false);   
            component.set('v.NumberOfTyres',10);                           
        }
            else if(vehType=='Trailor'){
            component.set('v.isBus',false);
            component.set('v.isTruck',false); 
            component.set('v.isTrailor',true);   
            component.set('v.NumberOfTyres',12);                           
        }
        else if(vehType=='Unit'){
            component.set('v.isBus',false);
            component.set('v.isTruck',false); 
            component.set('v.isTrailor',true);   
            component.set('v.NumberOfTyres',12);                           
        }
        
    },
    showCaseDeleteModal: function(component, event, helper) {
        var idx = event.target.id;
       // alert(idx);                       //here is your ID
    },
    ConditionChange:function(component, event, helper) {
        
        var condition = component.find("stgCondition").get("v.value");
     //   alert(condition);
        if(condition=='Bad')
        {
            component.set("v.isConditionBad",true);
        }
        else if(condition=='Good')
        {
            component.set("v.isConditionBad",false);
            
        }
        
    },
    AddNewRow : function(component, event, helper){
        
        var vehType = component.find('vehType').get('v.value');
        var addRowInList = component.get("v.FleetInspectionLineItemList");
        component.set("v.itemSelectedTyreSizeName","");
        component.set("v.itemSelectedTyreSizeID",'');   
        component.set("v.itemSelectedTyreBrandID",'');   
        component.set("v.itemSelectedTyrePatternID",''); 
        var tyreSizeId = null;
         var tyreSizeName = null;
         var tyrePatternId = null;
         var tyrePatternName = null;
         var tyreBrandId = null;
         var tyreBrandName = null;
        

       var isTyrePostionPresent = false;
        if(addRowInList!=null && addRowInList.length>0){
           var count = 0;
            for(var i=0;i<addRowInList.length;i++ ){
                
                if(addRowInList[i].Tyre_Position__c==event.getSource().get("v.name")){
                    isTyrePostionPresent = true;
                    }
                if(addRowInList[i].Tyre_Position__c!=null&&addRowInList[i].Tyre_Position__c!=''){
                   count= count + 1;
                    if(count==1)
                    {
                    	if(addRowInList[i].ETT_Tyre_Size__c)
                        {
                              tyreSizeId = addRowInList[i].ETT_Tyre_Size__c;
         
                        }
                        if(addRowInList[i].ETT_Tyre_Size_Name__c)
                        {
							 tyreSizeName = addRowInList[i].ETT_Tyre_Size_Name__c;
                                   
                        }
                         if(addRowInList[i].ETT_Brand__c)
                        {
                           
                           tyreBrandId = addRowInList[i].ETT_Brand__c;
         
                        }
                         if(addRowInList[i].ETT_Tyre_Brand_Name__c)
                        {
                            
                          tyreBrandName = addRowInList[i].ETT_Tyre_Brand_Name__c; 
        
                        }
                         if(addRowInList[i].ETT_Pattern__c)
                        {

        	 				tyrePatternId = addRowInList[i].ETT_Pattern__c;
                        }
                         if(addRowInList[i].ETT_Tyre_Pattern_Name__c)
                        {
                            tyrePatternName = addRowInList[i].ETT_Tyre_Pattern_Name__c;
                        }
                    }
                }
            }
        }
        if(!isTyrePostionPresent){
            var contactObj = new Object();
            
            if((tyreSizeId!=null||tyreSizeName!=null)&&(tyrePatternId!=null||tyrePatternName!=null)&&(tyreBrandId!=null||tyreBrandName!=null))
            {
              contactObj={'sobjectType':'Fleet_Inspection_Line_Item__c',
               				'Tyre_Status__c':'New',
               				'ETT_Condition__c':'Good',
               				'Tyre_Position__c': event.getSource().get("v.name"),
                			'ETT_Tyre_Size__c':tyreSizeId,
                            'ETT_Tyre_Size_Name__c':tyreSizeName,
      					    'ETT_Pattern__c':tyrePatternId,
                            'ETT_Tyre_Pattern_Name__c':tyrePatternName,
        					'ETT_Brand__c':tyreBrandId,
                            'ETT_Tyre_Brand_Name__c':tyreBrandName}; 	  
            }
            else
            {
          		  contactObj={'sobjectType':'Fleet_Inspection_Line_Item__c','Tyre_Status__c':'New','ETT_Condition__c':'Good','Tyre_Position__c': event.getSource().get("v.name")};      
            }
          
       //	     alert(contactObj.ETT_Tyre_Size__c);
            addRowInList.push(contactObj);
            component.set("v.FleetInspectionLineItemList",addRowInList);
        }
        
        
        
    },
    removeRow : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.FleetInspectionLineItemList");
        AllRowsList.splice(whichOne, 1);
        component.set("v.FleetInspectionLineItemList", AllRowsList);
        component.set("v.itemSelectedTyreSizeName","");
        component.set("v.itemSelectedTyreSizeID",'');   
        component.set("v.itemSelectedTyreBrandID",'');   
        component.set("v.itemSelectedTyrePatternID",'');  
    },
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    onFileUploaded : function(component, event, helper){
        
        var fileSourceType = event.getSource().get("v.name");       
        var fileUploadWrapper = component.get("v.fileUploadWrapper");
        var files = component.get("v.fileToBeUploaded");
        var contentWrapperArr = [];
        if(files && files.length > 0) {
            for(var i=0; i < files[0].length; i++){
                var file = files[0][i];
                var reader = new FileReader();
                reader.name = file.name;
                reader.type = file.type;
               
                reader.onloadend = function(e) {
                     var base64val = e.target.result;
                var base64Result = base64val.split(",")[1];
//                    alert(e.target.name);
  //                  alert(e.target.type);
                    fileUploadWrapper.push({
                        'strFileName':e.target.name,
                        'strBase64Data':base64Result,
                        'strFileType':e.target.type,
                        'fileSourceType':fileSourceType
                    });
                    contentWrapperArr.push({
                        'strFileName':e.target.name,
                        'strBase64Data':base64Result,
                        'strFileType':e.target.type,
                        'fileSourceType':fileSourceType
                    });
                }
                function handleEvent(event) {
                    if(contentWrapperArr.length == i){
                        var fleetWrapperObj = component.get("v.fleetInspectionWrapper");
                        fleetWrapperObj.push({'objFleetInspection':'',
                                              'lstFileLoadWrapper':contentWrapperArr,
                                              'fileSourceType':fileSourceType});
                        component.set("v.fleetInspectionWrapper",fleetWrapperObj);
                        component.set("v.fileUploadWrapper",fileUploadWrapper);
                        console.log(JSON.stringify(component.get("v.fleetInspectionWrapper")));
                    }
                }
                reader.readAsDataURL(file);
                reader.addEventListener('loadend', handleEvent);   
            }
        }
        
    },
    removeFile: function (component, event, helper) {
        var index = event.target.dataset.index;
    //    alert(index);
        var toremovefile = event.currentTarget.dataset.filename;
        var removefileToBeUploaded= component.get("v.fileUploadWrapper");
        removefileToBeUploaded.splice(index, 1);
        component.set("v.fileUploadWrapper", removefileToBeUploaded);
    },
    clickCreate : function(component, event, helper){
       // alert("isidew click create");
       
      
        var indexNo = event.getParam("index");
        var sobjectId = event.getParam("dynamicId");
        var NumberOfTyres = component.get('v.NumberOfTyres');
        var FleetInspectionObj  = component.get("v.FleetInspectionObj");
        var fleetInspectionWrapper = component.get("v.fleetInspectionWrapper");
        var FleetInspectionLineItemList  = component.get("v.FleetInspectionLineItemList"); 
       // alert(FleetInspectionLineItemList.length);
        FleetInspectionLineItemList.shift();
        FleetInspectionLineItemList.unshift({'sobjectType': 'Fleet_Inspection_Line_Item__c',
                                             'ETT_Brand__c': '',
                                             'ETT_Tyre_Size__c': '',
                                             'Tyre_Status__c': '',
                                             'Retread_Tread_Design__c': '',
                                             'Remarks__c':'',
                                             'Retreader__c':'',
                                             'ETT_Pattern__c':'',
                                             'Serial_Number__c':'',
                                             'ETT_Pattern__c':'',
                                             'Tread_Depth__c':'',
                                             'Tyre_Position__c':''
                                            });
 component.set("v.FleetInspectionLineItemList",FleetInspectionLineItemList);
        var FleetInspectionLineItemList  = component.get("v.FleetInspectionLineItemList");
             
        if(FleetInspectionObj.ETT_Vehicle_Number__c==null|| FleetInspectionObj.ETT_Vehicle_Number__c=='' ||
          // FleetInspectionObj.ETT_Internal_Number__c==null||FleetInspectionObj.ETT_Internal_Number__c==''||
           FleetInspectionObj.ETT_Vehicle_Configuration__c==null||FleetInspectionObj.ETT_Vehicle_Configuration__c==''||
            FleetInspectionObj.ETT_Type__c==null||FleetInspectionObj.ETT_Type__c==''||
           FleetInspectionObj.ETT_Minimum_Pull_Point__c==null||FleetInspectionObj.ETT_Minimum_Pull_Point__c==''||
            FleetInspectionObj.ETT_No_of_Vehicles__c==null||FleetInspectionObj.ETT_No_of_Vehicles__c==''
          // FleetInspectionObj.ETT_Odo_Meter__c==null || FleetInspectionObj.ETT_Odo_Meter__c==''
          ){
            
            helper.showErrorToast({
                "title": "Required:",
                "type": "error",
                "message": "Vehicle No, Vehicle Config,Location,Minimum Pull Point, Party Type, Type,No.Of Vehicles Fields are required"
            });
            return false; 
        }
        else{
            FleetInspectionObj.Name = component.get("v.newLead.Company");
            
            FleetInspectionObj.ETT_Location__c = component.get("v.newLead.ETT_Location__c");
            FleetInspectionObj.ETT_Lead__c = component.get("v.recordId");
           	FleetInspectionObj.ETT_Party_Type__c =  component.get("v.newLead.ETT_Party_Type__c");
            //alert(FleetInspectionObj.ETT_Party_Type__c);
        }
        
        
        var fleetInspectionWrapperList = component.get("v.fleetInspectionWrapper");
         var fleetInspectionWrapperListTemp = component.get("v.fleetInspectionWrapper");
       var totalnoOfTyres = component.get("v.NumberOfTyres");
        var totalInspectionLineItem = 0;
        for(var k = 0; k < FleetInspectionLineItemList.length; k++)
        {
            if(FleetInspectionLineItemList[k].Tyre_Position__c)
            {
              //  alert(FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c);
              //  alert(FleetInspectionLineItemList[k].ETT_Tyre_Size_Name__c);
               totalInspectionLineItem = totalInspectionLineItem + 1;
                if((FleetInspectionLineItemList[k].Tyre_Status__c=="Hot"||FleetInspectionLineItemList[k].Tyre_Status__c=="Precured")&&(FleetInspectionLineItemList[k].Retreader__c==""||FleetInspectionLineItemList[k].Retreader__c==null)){
                    
                    helper.showErrorToast({
                        "title": "Required:",
                        "type": "error",
                        "message": "Retread Fields are required on "+FleetInspectionLineItemList[k].Tyre_Position__c 
                    });
                    return false; 
                }
                
                if(!FleetInspectionLineItemList[k].ETT_Tyre_Size__c&&!FleetInspectionLineItemList[k].ETT_Tyre_Size_Name__c){
                    
                    helper.showErrorToast({
                        "title": "Required:",
                        "type": "error",
                        "message": "Tyre Size Fields are required on "+FleetInspectionLineItemList[k].Tyre_Position__c 
                    });
                    return false; 
                }
               if(!FleetInspectionLineItemList[k].ETT_Brand__c&&!FleetInspectionLineItemList[k].ETT_Tyre_Brand_Name__c){
                    
                    helper.showErrorToast({
                        "title": "Required:",
                        "type": "error",
                        "message": "Casing Brand Fields are required on "+FleetInspectionLineItemList[k].Tyre_Position__c 
                    });
                    return false; 
                }
                if(!FleetInspectionLineItemList[k].ETT_Pattern__c&&!FleetInspectionLineItemList[k].ETT_Tyre_Pattern_Name__c){
                    
                    helper.showErrorToast({
                        "title": "Required:",
                        "type": "error",
                        "message": "Original Tread Design Fields are required on "+FleetInspectionLineItemList[k].Tyre_Position__c 
                    });
                    return false; 
                }
               //alert(FleetInspectionLineItemList[k].Retread_Tread_Design__c);
                if(!FleetInspectionLineItemList[k].Retread_Tread_Design__c){
                    
                    helper.showErrorToast({
                        "title": "Required:",
                        "type": "error",
                        "message": "Retread tread design Fields are required on "+FleetInspectionLineItemList[k].Tyre_Position__c 
                    });
                    return false; 
                }
                if(((FleetInspectionLineItemList[k].ETT_Tread_Depth_Actual__c)<=(FleetInspectionObj.ETT_Minimum_Pull_Point__c))&&(!FleetInspectionLineItemList[k].ETT_Action__c)){
                    
                    helper.showErrorToast({
                        "title": "Required:",
                        "type": "error",
                        "message": "Action Fields are required on "+FleetInspectionLineItemList[k].Tyre_Position__c 
                    });
                    return false; 
                }
                if(!FleetInspectionLineItemList[k].ETT_Tread_Depth_Original__c){
                    
                    helper.showErrorToast({
                        "title": "Required:",
                        "type": "error",
                        "message": " Original Tread Depth Fields are required on "+FleetInspectionLineItemList[k].Tyre_Position__c
                    });
                    return false; 
                }
                 if(!FleetInspectionLineItemList[k].ETT_Tread_Depth_Actual__c){
                    
                    helper.showErrorToast({
                        "title": "Required:",
                        "type": "error",
                        "message": " Actual Tread Depth Fields are required on "+FleetInspectionLineItemList[k].Tyre_Position__c
                    });
                    return false; 
                }
                
                
       //         alert(FleetInspectionLineItemList[k].ETT_Proper_Pressure__c)    ;
              /*  if(FleetInspectionLineItemList[k].ETT_Proper_Pressure__c){
                    var regex = /[0-9]+(.[0-9])?([0-9]+)?/;
                   //   alert("inside regex")    ;
                    var pressure = FleetInspectionLineItemList[k].ETT_Proper_Pressure__c;
                    if(!pressure.toString().match(regex)){
                       //   alert(" regex not matched")    ;
                        helper.showErrorToast({
                            "title": "Required:",
                            "type": "error",
                            "message": "Please Enter Numeric Value for Standard Pressure"
                        });
                        return false; 
                    }
                }*/
                if(FleetInspectionLineItemList[k].ETT_Actual_Pressure__c){
                    var regex = /[0-9]+(.[0-9])?([0-9]+)?/;
                    var pressure = FleetInspectionLineItemList[k].ETT_Actual_Pressure__c;
                    if(!pressure.toString().match(regex)){
                        
                        helper.showErrorToast({
                            "title": "Required:",
                            "type": "error",
                            "message": "Please Enter Numeric Value for Actual Pressure"
                        });
                        return false; 
                    }
                }
                /*if(FleetInspectionLineItemList[k].ETT_Tread_Depth_Original__c){
                    var regex = /[0-9]+(.[0-9])?([0-9]+)?/;
                    var depth = FleetInspectionLineItemList[k].ETT_Tread_Depth_Original__c;
                    if(!depth.toString().match(regex)){
                        
                        helper.showErrorToast({
                            "title": "Required:",
                            "type": "error",
                            "message": "Please Enter Numeric Value for Thread Depth Original"
                        });
                        return false; 
                    }
                }*/
                if(FleetInspectionLineItemList[k].ETT_Tread_Depth_Actual__c){
                    var regex = /[0-9]+(.[0-9])?([0-9]+)?/;
                    var depth = FleetInspectionLineItemList[k].ETT_Tread_Depth_Actual__c;
                    if(!depth.toString().match(regex)){
                        
                        helper.showErrorToast({
                            "title": "Required:",
                            "type": "error",
                            "message": "Please Enter Numeric Value for Thread Depth Actual"
                        });
                        return false; 
                    }
                }
        var selecteditems =String(FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c);
             if(!FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c)
             { 
                 FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c='';
                 //  alert(FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c); 
             }
             if(selecteditems!=''&&selecteditems.includes(','))
             { 
                 
                 FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c = selecteditems.replace(",",";");
                 //alert(FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c);
             }
             if(selecteditems!=''&&!selecteditems.includes(';'))
             { 
                 
                 FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c = FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c +';';
                 //alert(FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c);
             } 
             
             // alert(FleetInspectionLineItemList[k].ETT_Bad_Reason_Complaint__c);
             //alert('done');
             
             if(FleetInspectionLineItemList[k].Tyre_Position__c&& FleetInspectionLineItemList[k].ETT_Condition__c== "Poor")
             {
                  //alert(FleetInspectionLineItemList[k].Tyre_Position__c);
           //   alert(FleetInspectionLineItemList[k].ETT_Condition__c);
             
                // alert("inside if");
                 
                 var imagePresent = false;
                 for(var i = 0; i < fleetInspectionWrapperListTemp.length; i++)
             		{
                 
                 //  alert(fleetInspectionWrapperListTemp[i].fileSourceType); 
                 if(fleetInspectionWrapperListTemp[i].fileSourceType == FleetInspectionLineItemList[k].Tyre_Position__c){
                   
                     if(fleetInspectionWrapperListTemp[i].lstFileLoadWrapper)
                     {
                             imagePresent = true;
                   //  alert("condition match image present"); 
                     }
                    
                 }  
             }
                 if(!imagePresent)
                     {
                        helper.showErrorToast({
                            "title": "Required:",
                            "type": "error",
                            "message": "Please upload image for "+ FleetInspectionLineItemList[k].Tyre_Position__c
                        });
                        return false;      
                     }
             }
                
             var count = 0;
             //  alert(fleetInspectionWrapperListTemp.length);
             for(var i = 0; i < fleetInspectionWrapperListTemp.length; i++)
             {
                 
                 //  alert(fleetInspectionWrapperListTemp[i].fileSourceType); 
                 if(fleetInspectionWrapperListTemp[i].fileSourceType == FleetInspectionLineItemList[k].Tyre_Position__c){
                     fleetInspectionWrapperListTemp[i].objFleetInspection = FleetInspectionLineItemList[k];
                     count = count + 1;
                     //  alert("inside wrapper check");
                 }  
             }
             
             if(count==0)
             { //alert("check count");
                 fleetInspectionWrapperList.push({'objFleetInspection':FleetInspectionLineItemList[k],
                                                  'fileSourceType':FleetInspectionLineItemList[k].Tyre_Position__c});
                 
             }
             
         }
            
        }
        
        if(totalnoOfTyres!=totalInspectionLineItem)
        {
             helper.showErrorToast({
                "title": "Required:",
                "type": "error",
                "message": "Please provide details for all tyres."
            });
            return false;  
        }
        component.set("v.fleetInspectionWrapper",fleetInspectionWrapperList);
        
        var fleetInspectionWrapperJSON = JSON.stringify(component.get("v.fleetInspectionWrapper"));
        console.log(fleetInspectionWrapperJSON);
        
        var newLead = component.get("v.newLead");
        newLead.Id = component.get("v.recordId");
        var stgLeadJson = JSON.stringify(newLead);
        console.log(stgLeadJson);
        var newFleetInspection = component.get("v.FleetInspectionObj");
        var stgFleetInspectionJson = JSON.stringify(newFleetInspection);
        
        var actSave = component.get("c.saveDMLForFleetInspection");
        var mapNameForStagingObjects = {"stgLeadJson":stgLeadJson,
                                        "stgFleetInspectionJson":stgFleetInspectionJson,
                                        "stgFleetInspectionLineItemJson":fleetInspectionWrapperJSON};
        
        
        
        
       //  alert('before param');
        actSave.setParams({
            "mapofStageJsonList":mapNameForStagingObjects
        });            
       component.set('v.isSpinner',true);
            //alert("calling response");
        actSave.setCallback(this, function(a){
       //     alert("inside response");
          //  alert('insertion');
            var state = a.getState();
            console.log('state: '+state);
            //alert("state:"+state);
               component.set('v.isSpinner',false);
            if(state == 'SUCCESS') {
                // alert('insie success');
                console.log('SUCCESS: '+a.getReturnValue());
                
                helper.showErrorToast({
                    "title": "Success: ",
                    "type": "success",
                    "message": a.getReturnValue()
                });
                
                $A.get("e.force:closeQuickAction").fire(); 
                
            }else if (state === "INCOMPLETE") {
                // do something
                //alert("Incomplete");
                console.log(state);
            }else if (state === "ERROR") {
                var errors = a.getError();
                //alert("ERROR="+errors[0].message);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                        helper.showErrorToast({
                            "title": "Required: Contact",
                            "type": "error",
                            "message": errors[0].message
                        });
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                    helper.showErrorToast({
                        "title": "Required: Contact",
                        "type": "error",
                        "message": "Unknown error"
                    });
                }
            }
        });
        $A.enqueueAction(actSave);
        
        
    },
    GetVehicleNumber:function(component, event, helper){
        //  var idVar = component.get("v.inputId");
        var internalNo = component.get("v.FleetInspectionObj.ETT_Internal_Number__c");
        
        //alert(VehicleNo);
        if(!$A.util.isEmpty(internalNo))
        {
            var upperInternalNo = internalNo.toUpperCase();
        component.set("v.FleetInspectionObj.ETT_Internal_Number__c",upperInternalNo);
            
            var action = component.get("c.getVehicleNumber");
            action.setParams({ internalNo : upperInternalNo }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
              //  alert(state);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(result);
                   // alert(result);
                    if(result!=''&&result!=null){
                        //alert('setting value');
                        result = result.toUpperCase();
                        component.set("v.FleetInspectionObj.ETT_Vehicle_Number__c",result);
                    //    alert(component.get("v.FleetInspectionObj.ETT_Vehicle_Number__c"))
                    }
                    
            }}  );     
         $A.enqueueAction(action);
        // $A.enqueueAction(component.get('c.convertCase'));
        }
       
        
       
        
        
    },
    
    itemsChange:function(component, event, helper){
      
        var index = component.get("v.indexofTyre");
       // alert(index);
        var tyreName = component.get("v.itemSelectedTyreSizeName");
        var vehType = component.find('vehType').get('v.value');
       if(!tyreName)
        {
         return false;
        }
        if(!vehType)
        {
            return false;
        }
       var action = component.get("c.getPressure");
            action.setParams({ tyreSize : tyreName,
                              VehicleType : vehType
                             }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
              //  alert(state);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(result);
                 //   alert(result);
                    if(result!=''&&result!=null){
                   //    alert(result)
                        var templst =component.get("v.FleetInspectionLineItemList");
                        
                        templst[index].ETT_Proper_Pressure__c=result;
                        
                        component.set("v.FleetInspectionLineItemList",templst);
                    }
                    
            }}  );     
         $A.enqueueAction(action);
       
      
    },
     itemsChange2:function(component, event, helper){
      
        var index = component.get("v.indexofTyre");
      
      var tyreSizeID = component.get("v.itemSelectedTyreSizeID");
         var tyreBrandID =  component.get("v.itemSelectedTyreBrandID");
    var tyrePatternID =  component.get("v.itemSelectedTyrePatternID");
         
         
       if(!tyreSizeID||!tyreBrandID||!tyrePatternID)
        {
            
            return false;
        }
        
       // var hard = 1;
         var action = component.get("c.getOriginalDepth");
            action.setParams({ tyreSize : tyreSizeID,
                              tyreBrand :tyreBrandID,
                              tyrePattern : tyrePatternID
                             }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
             // alert(state);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(result);
                    //alert(result);
                    if(result!=''&&result!=null){
                    //alert(result)
                         var templst =component.get("v.FleetInspectionLineItemList");
                        templst[index].ETT_Tread_Depth_Original__c=result;
                        
                        component.set("v.FleetInspectionLineItemList",templst);
                    }
                    
            }}  );     
         $A.enqueueAction(action);
      
    }
})