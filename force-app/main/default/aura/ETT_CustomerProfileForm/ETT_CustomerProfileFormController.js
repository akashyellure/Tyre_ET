({
    doInit : function(component, event, helper) {
        
        helper.fetchPickListVal(component, "ETT_Vehicle_Type__c", "vehicleType");
        helper.fetchPickListVal(component, "ETT_Payment_Terms__c", "paymentTerms");
        helper.fetchPickListVal(component, "ETT_Services__c", "services");        
        helper.fetchPickListVal(component, "ETT_Status__c", "statusMap");                
        helper.fetchPickListVal(component, "ETT_PurchaseInfo_Type__c", "typeMap");                        
        helper.fetchPickListVal(component, "ETT_VehicleApplication__c", "applicationMap");                                 
        
        
        var stgContactList = component.get("v.stagingContactList");          
        var stgCustomerVehicleList  = component.get("v.stagingCustomerVehicleList");
        var stagingQuotationRequest  = component.get("v.stagingQuotationRequest");
        var stagingPurchaseInformation  = component.get("v.stagingPurchaseInformation");
        var stagingAddedServices = component.get("v.stagingAddedServices");
        
        stgContactList.push({
            'sobjectType': 'ETT_Staging_Contacts__c',
            'ETT_First_Name__c': '',
            'Name': '',
            'ETT_Phone__c': '',
            'ETT_Email__c':'',
            'ETT_Designation__c':''
        });
        
        stagingAddedServices.push({
            'sobjectType': 'ETT_Staging_Added_Service__c',
            'ETT_Own__c': '',
            'ETT_Out_Source__c': '',
            'ETT_Supplier_Details__c': '',
            'ETT_Maintance__c':''
        });
        
        stgCustomerVehicleList.push({
            'sobjectType': 'ETT_Staging_Customer_Vehicle_Details__c',
            'Name': '',
            'ETT_Vehicle_In_Fleet__c':0,
            'ETT_Tyres_In_Fleet__c':0,
            'ETT_KMS_Covered_Yearly__c':0
            
        });
        
        stagingQuotationRequest.push({
            'sobjectType': 'ETT_Staging_Quotation_Request__c',
            'ETT_Quantity__c':0,
            'ETT_Retreading_charge__c':0,
            'ETT_Stock_Retreading_Charge__c':0,
            'ETT_Tyre_Size__c':''
        });
        
        stagingPurchaseInformation.push({
            'sobjectType': 'ETT_Staging_Purchase_Information__c',
            'ETT_Tyre_Size_Master__c':'',
            'ETT_Type__c':'',
            'ETT_Brand_Master__c':'',
            'ETT_Yearly_Qty__c':'',
            'ETT_Price__c':'',
            'ETT_Payment_Terms__c':''
        });
        
        // set the updated list to attribute (contactList) again
        component.set("v.stagingContactList", stgContactList);
        component.set("v.stagingAddedServices", stagingAddedServices);    
        component.set("v.stagingCustomerVehicleList", stgCustomerVehicleList);
        //component.set("v.customerPurchaseInfo", customerPurchaseInfoList);
        //component.set("v.addedServiceInfo", customerAddedServiceList); 
        component.set("v.stagingQuotationRequest", stagingQuotationRequest); 
        component.set("v.stagingPurchaseInformation", stagingPurchaseInformation);         
        
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
                objLead.PostalCode = res.PostalCode;                
                objLead.Email = res.Email;                
                objLead.Website = res.Website;                                
                objLead.Fax = res.Fax;                                
                
                component.set('v.newLead',objLead);
                
                //component.set('v.newLead',response.getReturnValue());
                
                if(response.getReturnValue().hasOwnProperty("Staging_Contacts__r") ){
                    component.set('v.stagingContactList',response.getReturnValue().Staging_Contacts__r);
                }

                if(response.getReturnValue().hasOwnProperty("Staging_Customer_Vehicle_Details__r") ){
                    component.set('v.stagingCustomerVehicleList',response.getReturnValue().Staging_Customer_Vehicle_Details__r);
                }

                if(response.getReturnValue().hasOwnProperty("Staging_Purchase_Informations__r") ){
                    component.set('v.stagingPurchaseInformation',response.getReturnValue().Staging_Purchase_Informations__r);
                }
                
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
        
        
        
    },
    handleCompanyOnChange : function(component, event, helper){},
    validateAddress : function(component,event,helper){
        
        var newLead = component.get("v.newLead");
        var address = newLead.Street; 
        var addressRegex = /^[0-9]+$/i;
        
        if(address.toString().match(addressRegex)){
            component.set("v.isAddressError",true);
            document.getElementById("addressErr").innerHTML = "Error: Please enter valid address";
            return false;
        }else{
            component.set("v.isAddressError",false);
            document.getElementById("addressErr").innerHTML = "";
        } 
        
    }, 
    validateMobile: function(component, event, helper){
        
        var conList = component.get("v.stagingContactList");
        var indexvar = event.getSource().get("v.name");

        if(conList[indexvar].ETT_Phone__c.length != 10){
            component.set("v.isMobileError",true);
            document.getElementById("conPhoneErr").innerHTML = "Error: Please enter valid mobile number";
            return false;
        }else{
            component.set("v.isMobileError",false);
            document.getElementById("conPhoneErr").innerHTML = "";
        }
    },
    validateContactFName: function(component, event, helper){
        
        var conList = component.get("v.stagingContactList");
        var indexvar = event.getSource().get("v.name");
        var FirstName = conList[indexvar].ETT_First_Name__c;
        var fnameReg = /^[a-z]+$/i;
        
        if(FirstName!='' && !FirstName.toString().match(fnameReg)){
            document.getElementById("conFNameErr").innerHTML = "Error: Please enter valid FirstName";
        }else{
            component.set("v.isError",false);
            document.getElementById("conFNameErr").innerHTML = "";
        }
        
        
    },
    validateContactLName: function(component, event, helper){
        
        var conList = component.get("v.stagingContactList");
        var indexvar = event.getSource().get("v.name");
        var FirstName = conList[indexvar].Name;
        var fnameReg = /^[a-z]+$/i;
        
        if(FirstName!='' && !FirstName.toString().match(fnameReg)){
            document.getElementById("conLnameErr").innerHTML = "Error: Please enter valid FirstName";
        }else{
            component.set("v.isError",false);
            document.getElementById("conLnameErr").innerHTML = "";
        }
    },
    validateDesignation: function(component, event, helper){
        
        var conList = component.get("v.stagingContactList");
        var indexvar = event.getSource().get("v.name");

        if(!isNaN(conList[indexvar].ETT_Designation__c)){
            document.getElementById("conDesErr").innerHTML = "Error: Please enter valid Designation";
            return false;
        }else{
            component.set("v.isMobileError",false);
            document.getElementById("conDesErr").innerHTML = "";
        }
    },    
    validatePhone: function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var Phone = newLead.Phone;
        var phonRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$/;
        
        if(!Phone.toString().match(phonRegex)){
            component.set("v.isPhoneError",true);
            document.getElementById("phoneErr").innerHTML = "Error: Please enter valid phone number";
            return false;
        }else{
            component.set("v.isPhoneError",false);
            document.getElementById("phoneErr").innerHTML = "";
        }
        
    },
    validateWebsite: function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var website = newLead.Website;   
        var webRegex = /^((https?|ftp|smtp):\/\/)?(www.)?[a-z0-9]+\.[a-z]+(\/[a-zA-Z0-9#]+\/?)*$/;
        
        if(!website.toString().match(webRegex)){
            component.set("v.isWebsiteError",true);
            document.getElementById("websiteErr").innerHTML = "Error: Please enter valid Website";
            return false;
        }else{
            component.set("v.isWebsiteError",false);
            document.getElementById("websiteErr").innerHTML = "";
        }
        
    },
    
    AddNewRow : function(component, event, helper){
        var addRowInList = component.get("v.stagingContactList");
        var size = addRowInList.length;
        var contact = addRowInList[size-1];
        var LNameReg = /^[a-z]+$/i;
        var phonRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$/;
        var emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        
        if(contact.ETT_First_Name__c != ''){
            if(!contact.ETT_First_Name__c.toString().match(LNameReg)){
                helper.showErrorToast({
                    "title": "Required: Staging Contact Details",
                    "type": "error",
                    "message": "Please enter valid First Name"
                });
                return false;
            }
        }
        
        if(contact.ETT_Last_Name__c==''){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter Last Name"
            });
            return false;
        }
        if(!contact.ETT_Last_Name__c.toString().match(LNameReg)){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter valid Last Name"
            });
            return false;
        }
        
        /*if(!contact.ETT_Designation__c.toString().match(LNameReg)){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter valid Designation"
            });
            return false;
        }*/
        
        if(!contact.ETT_Phone__c.toString().match(phonRegex)){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter valid Phone Number"
            });
            return false;
        }
        
        if(!contact.ETT_Email__c.toString().match(emailReg)){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter valid Email"
            });
            return false;
        }
        
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingContactList",addRowInList);
    },
    removeRow : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingContactList");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingContactList", AllRowsList);
    },
    
    addNewRowCustomerVehicle : function(component, event, helper){
        var addRowInList = component.get("v.stagingCustomerVehicleList");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingCustomerVehicleList",addRowInList);
    },
    removeRowCustomerVehicle : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingCustomerVehicleList");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingCustomerVehicleList", AllRowsList);
    },
    
    addNewRowQuotationRequest : function(component, event, helper){
        var addRowInList = component.get("v.stagingQuotationRequest");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingQuotationRequest",addRowInList);
    },
    addNewRowPurchaseInformation : function(component, event, helper){
        var addRowInList = component.get("v.stagingPurchaseInformation");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingPurchaseInformation",addRowInList);
    },
    removeRowPurchaseInformation : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingPurchaseInformation");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingPurchaseInformation", AllRowsList);
    },
    removeRowQuotationRequest : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingQuotationRequest");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingQuotationRequest", AllRowsList);
    },
    addNewRowAddedServices : function(component, event, helper){
        var addRowInList = component.get("v.stagingAddedServices");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingAddedServices",addRowInList);
    },
    removeRowAddedServices : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingAddedServices");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingAddedServices", AllRowsList);
    },
    /*onCheck : function(component, event, helper){
        var isOwn = component.get("v.isOwn");
        if(isOwn==false)
            component.set("v.isOwn", true);
        else{
            component.set("v.isOwn", false);
        }
    },*/
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    clickCreate : function(component, event, helper){
        
        var indexNo = event.getParam("index");
        var sobjectId = event.getParam("dynamicId");
        
        var stgLeadObj = component.get("v.newLead");
        var stgcontactList  = component.get("v.stagingContactList");    
        var stgCustomerVehicleDetails = component.get("v.stagingCustomerVehicleList");
        var stagingPurchaseInformation  = component.get("v.stagingPurchaseInformation");
        var stagingAddedServices  = component.get("v.stagingAddedServices");        
        
        var strLeadJson = JSON.stringify(stgLeadObj);
        var stgconJson  = JSON.stringify(stgcontactList);
        var strVehicleJson  = JSON.stringify(stgCustomerVehicleDetails);
        var strPurchaseInformationJson  = JSON.stringify(stagingPurchaseInformation);        
        var stagingAddedServicesJSON  = JSON.stringify(stagingAddedServices);                
        
        
        if(stgLeadObj.Company==''||stgLeadObj.Company==null ||
           stgLeadObj.Street==''||stgLeadObj.Street==null ||
           stgLeadObj.Phone==''||stgLeadObj.Phone==null){
            helper.showErrorToast({
                "title": "Required: Lead Form",
                "type": "error",
                "message": "Fleet Name, Address, Phone Fields are required"
            });
            return false;
        }
        
        
        if(stgcontactList!=null && stgcontactList.length>0){
            for(var i=0;i<stgcontactList.length;i++){
                
                if(stgcontactList[i].Name==''||stgcontactList[i].Name==null ||
                   stgcontactList[i].ETT_Phone__c==''||stgcontactList[i].ETT_Phone__c==null
                  ){
                    helper.showErrorToast({
                        "title": "Required: Contact",
                        "type": "error",
                        "message": "Last Name, Phone Fields are required"
                    });
                    return false;
                }
                
            }
        }
        
        if(stgCustomerVehicleDetails!=null && stgCustomerVehicleDetails.length>0){
            for(var i=0;i<stgCustomerVehicleDetails.length;i++){
                
                if(stgCustomerVehicleDetails[i].ETT_Axil_Configuration__c==''||stgCustomerVehicleDetails[i].ETT_Axil_Configuration__c==null ||
                   stgCustomerVehicleDetails[i].ETT_Application__c==''||stgCustomerVehicleDetails[i].ETT_Application__c==null ||
                   stgCustomerVehicleDetails[i].ETT_KMS_Covered_Yearly__c==null ||stgCustomerVehicleDetails[i].ETT_KMS_Covered_Yearly__c==0){
                    helper.showErrorToast({
                        "title": "Required: Vehicle Details",
                        "type": "error",
                        "message": "Axle Configuration, Application, KMS Covered Fields are required"
                    });
                    return false;
                }
            }
        }  
        
        if(stagingPurchaseInformation!=null && stagingPurchaseInformation.length>0){
            
            for(var i=0;i<stagingPurchaseInformation.length;i++){
                
                if(stagingPurchaseInformation[i].ETT_Tyre_Size_Master__c=='' || stagingPurchaseInformation[i].ETT_Tyre_Size_Master__c==null||
                   stagingPurchaseInformation[i].ETT_Brand_Master__c=='' || stagingPurchaseInformation[i].ETT_Brand_Master__c==null
                   ){
                    helper.showErrorToast({
                        "title": "Required: Purchase Information",
                        "type": "error",
                        "message": "Tyre Size, Brand Fields are required"
                    });
                    return false;
                }
            }
            
        }	
        
        if(stagingAddedServices!=null && stagingAddedServices.length>0){
            
            for(var i=0;i<stagingAddedServices.length;i++){
                
                if(stagingAddedServices[i].ETT_Services__c=='' || stagingAddedServices[i].ETT_Services__c==null||
                   stagingAddedServices[i].ETT_Status__c=='' || stagingAddedServices[i].ETT_Status__c==null||
                   stagingAddedServices[i].ETT_Supplier_Details__c=='' || stagingAddedServices[i].ETT_Supplier_Details__c==null){
                    
                    helper.showErrorToast({
                        "title": "Required: Added Services",
                        "type": "error",
                        "message": "Type of Service, Status, Supplier Details Fields are required"
                    });
                    return false;
                    
                }
            }
        }
        
    
        var actSave = component.get("c.saveDML");
       
        var mapNameForStagingObjects = {"stgLeadJson":strLeadJson,
                                        "stgContactJson":stgconJson,
                                        "stgVehicleJson":strVehicleJson,
                                        "stgPurchaseJson":strPurchaseInformationJson};
         
        actSave.setParams({
            "mapofStageJsonList":mapNameForStagingObjects
        });  
        
        actSave.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log(state);
            
            if (state === "SUCCESS") {
                
                console.log(response.getReturnValue());
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + response.getReturnValue()
                });
                urlEvent.fire();
                
                
            } else {
                console.log("Failed with state: " + state);
            }
            
        });
        
        $A.enqueueAction(actSave);
        
    }
    
    
    
    
})