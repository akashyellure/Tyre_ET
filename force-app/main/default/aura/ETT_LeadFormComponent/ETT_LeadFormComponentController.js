({
    doInit : function(component, event, helper) {
        
        var newLead = component.get("v.newLead"); 
        var stgContactList  = component.get("v.stagingContactList");          
        var stgCustomerVehicleList  = component.get("v.stagingCustomerVehicleList");
        var stagingQuotationRequest   = component.get("v.stagingQuotationRequest");
        var stagingPurchaseInformation   = component.get("v.stagingPurchaseInformation");
        
        helper.fetchPickListVal(component, "ETT_Payment_Type__c", "PaymentType");
        helper.fetchPickListVal(component, "ETT_Party_Type__c", "PartyType");
        helper.fetchPickListVal(component, "ETT_Vehicle_Type__c", "vehicleType");
        helper.fetchPickListVal(component, "ETT_VehicleApplication__c", "applicationMap");                                 
        helper.fetchPickListVal(component, "ETT_Tyre_Life__c", "tyreLife");
        helper.fetchPickListVal(component, "ETT_Tyre_Condition__c", "retreadProcess");
        helper.fetchPickListVal(component, "ETT_Tyre_Process__c", "tyreProcess");
        
        stgContactList.push({
            'sobjectType': 'ETT_Staging_Contacts__c',
            'ETT_First_Name__c': '',
            'Name': '',
            'ETT_Phone__c': '',
            'ETT_Email__c':'',
            'ETT_Designation__c':''
        });
        
        stgCustomerVehicleList.push({
            'sobjectType': 'ETT_Staging_Customer_Vehicle_Details__c',
            'Name': '',
            'ETT_Vehicle_Configuration__c':'',
            'ETT_Axil_Configuration__c':'',
            'ETT_Vehicle_In_Fleet__c':0,
            'ETT_Tyres_In_Fleet__c':0,
            'ETT_KMS_Covered_Yearly__c':0
            
        });
        
        stagingQuotationRequest.push({
            'sobjectType': 'ETT_Staging_Quotation_Request__c',
            'ETT_Quantity__c':1,
            'ETT_Retreading_charge__c':0,
            'ETT_Stock_Retreading_Charge__c':0,
            'ETT_Tyre_Size__c':'',
            'ETT_Tyre_Size_Master__c':'',
            'ETT_Tyre_Life__c':'New',
            'ETT_Tyre_Process__c':'Retread',
            'ETT_Tyre_Condition__c':'Precure'
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
        
        component.set("v.stagingContactList", stgContactList);
        component.set("v.stagingCustomerVehicleList", stgCustomerVehicleList);
        component.set("v.stagingQuotationRequest", stagingQuotationRequest); 
        component.set("v.stagingPurchaseInformation", stagingPurchaseInformation); 
        
        
        var action = component.get("c.getCustomerProfile");
        action.setParams({ id : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set('v.newLead',response.getReturnValue());
                
                if(response.getReturnValue().hasOwnProperty("Staging_Contacts__r") ){
                    component.set('v.stagingContactList',response.getReturnValue().Staging_Contacts__r);
                }
                
                if(response.getReturnValue().hasOwnProperty("Staging_Customer_Vehicle_Details__r") ){
                    component.set('v.stagingCustomerVehicleList',response.getReturnValue().Staging_Customer_Vehicle_Details__r);
                }
                
                /*if(response.getReturnValue().hasOwnProperty("Staging_Purchase_Informations__r") ){
                    component.set('v.stagingPurchaseInformation',response.getReturnValue().Staging_Purchase_Informations__r);
                }*/
                
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
        //$A.enqueueAction(action); //check with krishna and uncomment this line
        console.log('check with krishna and uncomment this line');
    },
    convertCase: function(component, event, helper){
        var val = event.getSource().get("v.value");
        if(val!=null){
            val = val.toUpperCase();
            var selectCmp = event.getSource();
            selectCmp.set("v.value",val) ;  
        }
    },


    handleNewTyreEvent: function(component, event, helper){
        var lstWOLI = event.getParam("lstWOLI");
        component.set("v.lstWOLI",lstWOLI);
    },
    handlePaymentType : function(component,event,helper){
        let paymentType = component.get("v.newLead.ETT_Payment_Type__c");
        if(paymentType == 'Credit') component.set("v.isTRNRequired",true);
        else component.set("v.isTRNRequired",false);
    },
    validateMobileNumber : function(component,event,helper){
        
        var conList = component.get("v.stagingContactList");
        var indexvar = event.getSource().get("v.name");
        var Phone = conList[indexvar].ETT_Phone__c;

       /* if(conList[indexvar].ETT_Phone__c.length != 10){
            component.set("v.isMobileError",true);
            document.getElementById("conPhoneErr").innerHTML = "Error: Please enter valid mobile number";
            return false;
        }else{
            component.set("v.isMobileError",false);
            document.getElementById("conPhoneErr").innerHTML = "";
        } */
        
        var phonRegex = /^(?:\+971 |00971 |0 )?(?:50|51|52|54|55|56|2|3|4|6|7|9)\d{7}$/;
        var prefix = '+971 ';
        if(Phone.indexOf(prefix) !== 0 ){
            Phone = '+971 '+Phone;

            if(!Phone.toString().match(phonRegex)){
                component.set("v.isMobileError",true);
                document.getElementById("conPhoneErr").innerHTML = "Error: Please enter valid phone number";
                return false;
            }else{
                component.set("v.isMobileError",false);
                document.getElementById("conPhoneErr").innerHTML = "";
            }
            
            
            conList[indexvar].ETT_Phone__c = Phone;
             component.set("v.stagingContactList",conList);
            //component.find("stgConPhone").set("v.value", Phone);
           // alert(component.find("stgConPhone").get("v.value"))
            
           // component.set("v.newLead.Phone",Phone);
        }
        
        /*
        if(!component.find("stgConPhone").get("v.value").toString().match(phonRegex)){
            component.set("v.isMobileError",true);
            document.getElementById("conPhoneErr").innerHTML = "Error: Please enter valid phone number";
            return false;
        }else{
            component.set("v.isMobileError",false);
            document.getElementById("conPhoneErr").innerHTML = "";
        }*/

    },
    validateMobileNumber1 : function(component,event,helper){
        debugger;
        var conList = component.get("v.stagingContactList");
        var indexvar = event.getSource().get("v.name");
        
        for(var i in conList){
            var phonRegex = /^(?:\+971 |00971 |0 )?(?:50|51|52|55|56|54|2|3|4|6|7|9)\d{7}$/;
            var prefix = '+971 ';
            var Phone = conList[indexvar].ETT_Phone__c;
            if(Phone.indexOf(prefix) !== 0){
                Phone = '+971 '+Phone;
                conList[indexvar].ETT_Phone__c =Phone;
                if(!Phone.toString().match(phonRegex)){
                    component.set("v.isMobileError",true);
                    document.getElementById("conPhoneErr").innerHTML = "Error: Please enter valid phone number";
                    return false;
                }else{
                    component.set("v.stagingContactList",conList);
                    component.set("v.isMobileError",false);
                    document.getElementById("conPhoneErr").innerHTML = "";
                }
            }else{
                if(!Phone.toString().match(phonRegex)){
                    component.set("v.isMobileError",true);
                    document.getElementById("conPhoneErr").innerHTML = "Error: Please enter valid phone number";
                    return false;
                }else{
                    component.set("v.stagingContactList",conList);
                    component.set("v.isMobileError",false);
                    document.getElementById("conPhoneErr").innerHTML = "";
                }  
            }
        }
    },
    validateCompanyName : function(component,event,helper){
        var newLead = component.get("v.newLead");
        var Company = newLead.Company;
        var Reg = /^[0-9]+$/i;
        
        if(Company!='' && Company.toString().match(Reg)){
            component.set("v.isCompanyError",true);
            document.getElementById("companyErr").innerHTML = "Error: Please enter valid Company Name";
        }else{
            component.set("v.isCompanyError",false);
            document.getElementById("companyErr").innerHTML = "";
        }
    },
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
    validatePhone: function(component, event, helper){
        /*
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
        }*/
        var newLead = component.get("v.newLead");
        var Phone = newLead.Phone;
        var phonRegex = /^(?:\+971 |00971 |0 )?(?:50|51|52|55|54|56|2|3|4|6|7|9)\d{7}$/;
        var prefix = '+971 ';
        if(Phone.indexOf(prefix) !== 0 ){
            Phone = '+971 '+Phone;
            component.set("v.newLead.Phone",Phone);
        }
        
        
        if(!Phone.toString().match(phonRegex)){
            component.set("v.isPhoneError",true);
            document.getElementById("phoneErr").innerHTML = "Error: Please enter valid phone number";
            return false;
        }else{
            component.set("v.isPhoneError",false);
            document.getElementById("phoneErr").innerHTML = "";
        }
        
    },
    validateFax: function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var Fax = newLead.Fax;
        var faxRegex = /^(?:\+971 |00971 |0 )?(?:50|51|52|55|54|56|2|3|4|6|7|9)\d{7}$/;
        var prefix = '+';
        if(Fax.indexOf(prefix) !== 0 ){
            Fax = '+971 '+Fax;
            component.set("v.newLead.Fax",Fax);
        }
        
        if(!Fax.toString().match(faxRegex)){
            component.set("v.isError",true);
            document.getElementById("faxErr").innerHTML = "Error: Please Enter Valid Fax Number";
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("faxErr").innerHTML = "";
        }
        
    },
    validateWebsite: function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var website = newLead.Website;   
        var webRegex = /^((https?|ftp|smtp):\/\/)?(www.)?[a-zA-Z0-9]+\.[a-zA-Z]+(\/[a-zA-Z0-9#]+\/?)*$/;
        
        if(!website.toString().match(webRegex)){
            component.set("v.isWebsiteError",true);
            document.getElementById("websiteErr").innerHTML = "Error: Please enter valid Website";
            return false;
        }else{
            component.set("v.isWebsiteError",false);
            document.getElementById("websiteErr").innerHTML = "";
        }
        
    },
    validateTRN: function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var TRN = newLead.ETT_VAT_TRN__c;
        var trnRegex = /^[0-9]+$/i;
        
        if(!TRN.toString().match(trnRegex)){
            component.set("v.isTRNError",true);
            document.getElementById("trnErr").innerHTML = "Error: Please enter only numbers in TRN Number";
            return false;
        }else{
            component.set("v.isTRNError",false);
            document.getElementById("trnErr").innerHTML = "";
        }
        
        if(TRN.length != 15){
            component.set("v.isError",true);
            document.getElementById("trnErr").innerHTML = "Error: TRN Number must be 15 digits";                                                
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("trnErr").innerHTML = "";
        }
    },
    validateFirstName:function(component,event,helper){
        
        var newLead = component.get("v.newLead");
        var FirstName = newLead.FirstName;
        var fnameReg = /^[a-z]+$/i;
        
        if(FirstName!='' && !FirstName.toString().match(fnameReg)){
            //component.set("v.isError",true);
            document.getElementById("fnameErr").innerHTML = "Error: Please enter valid FirstName";
        }else{
            //component.set("v.isError",false);
            document.getElementById("fnameErr").innerHTML = "";
        }
    },
    validateLastName : function(component,event,helper){
        var newLead = component.get("v.newLead");
        var LastName = newLead.LastName;
        var fnameReg = /^[a-z]+$/i;
        
        if(!LastName.toString().match(fnameReg)){
            component.set("v.isLNameError",true);
            document.getElementById("lnameErr").innerHTML = "Error: Please enter valid LastName";
        }else{
            component.set("v.isLNameError",false);
            document.getElementById("lnameErr").innerHTML = "";
        }
    },  
    
    AddNewRow : function(component, event, helper){
        
        var addRowInList = component.get("v.stagingContactList");
        var size = addRowInList.length;
        var contact = addRowInList[size-1];
        var LNameReg = /^[a-z]+$/i;
        var phonRegex = /^(?:\+971 |00971 |0 )?(?:50|51|52|55|54|56|2|3|4|6|7|9)\d{7}$/;
        var emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        /*
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
        */
        if(contact.Name==''){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter Last Name"
            });
            return false;
        }
        if(!contact.Name.toString().match(LNameReg)){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter valid Last Name"
            });
            return false;
        }
        /*
        if(!contact.ETT_Designation__c.toString().match(LNameReg)){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter valid Designation"
            });
            return false;
        }
        */
        if(!contact.ETT_Phone__c.toString().match(phonRegex)){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter valid Phone Number"
            });
            return false;
        }
        /*
        if(!contact.ETT_Email__c.toString().match(emailReg)){
            helper.showErrorToast({
                "title": "Required: Staging Contact Details",
                "type": "error",
                "message": "Please enter valid Email"
            });
            return false;
        }
        */
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
        var size = addRowInList.length;
        var vehicle = addRowInList[size-1];
        
        if(vehicle.ETT_Vehicle_Type__c == ''){
            helper.showErrorToast({
                "title": "Required: Staging Vehicle Details",
                "type": "error",
                "message": "Please select Vehicle Type"
            });
            return false;            
        }
        
        if(isNaN(vehicle.ETT_Vehicle_In_Fleet__c)){
            helper.showErrorToast({
                "title": "Required: Staging Vehicle Details",
                "type": "error",
                "message": "Please enter only numbers into Vehicles In Fleet"
            });
            return false;
        }
        if(vehicle.ETT_Vehicle_In_Fleet__c == 0){
            helper.showErrorToast({
                "title": "Required: Staging Vehicle Details",
                "type": "error",
                "message": "Please enter valid number into Vehicles In Fleet"
            });
            return false;
        }   
        
        if(isNaN(vehicle.ETT_Tyres_In_Fleet__c)){
            helper.showErrorToast({
                "title": "Required: Staging Vehicle Details",
                "type": "error",
                "message": "Please enter only numbers into Tyres In Fleet"
            });
            return false;
        }
        if(vehicle.ETT_Tyres_In_Fleet__c==0){
            helper.showErrorToast({
                "title": "Required: Staging Vehicle Details",
                "type": "error",
                "message": "Please enter valid number into Tyres In Fleet"
            });
            return false;
        }
        
        if(isNaN(vehicle.ETT_KMS_Covered_Yearly__c)){
            helper.showErrorToast({
                "title": "Required: Staging Vehicle Details",
                "type": "error",
                "message": "Please enter only numbers into KMS Covered yearly"
            });
            return false;        }   
        if(vehicle.ETT_KMS_Covered_Yearly__c == 0){
            helper.showErrorToast({
                "title": "Required: Staging Vehicle Details",
                "type": "error",
                "message": "Please enter valid number into KMS Covered yearly"
            });
            return false;        }   
        
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
        var size = addRowInList.length;
        var quotation = addRowInList[size-1];
        console.log(JSON.stringify(quotation));
        
        if(quotation.ETT_Tyre_Size_Master__c=='' || quotation.ETT_Tyre_Size_Master__c==null){
            helper.showErrorToast({
                "title": "Required: Quotation Request",
                "type": "error",
                "message": "Please enter Tyre Size"
            });
            return false;  
        }
        /*
        if(isNaN(quotation.ETT_Retreading_charge__c)){
            helper.showErrorToast({
                "title": "Required: Quotation Request",
                "type": "error",
                "message": "Please enter only numbers into Retreading Charge"
            });
            return false;  
        }
        if(quotation.ETT_Retreading_charge__c == 0){
            helper.showErrorToast({
                "title": "Required: Quotation Request",
                "type": "error",
                "message": "Please enter valid Retreading Charge"
            });
            return false;  
        }
        if(isNaN(quotation.ETT_Stock_Retreading_Charge__c)){
            helper.showErrorToast({
                "title": "Required: Quotation Request",
                "type": "error",
                "message": "Please enter only numbers into Stock Retreading Charge"
            });
            return false;  
        }  
        if(quotation.ETT_Stock_Retreading_Charge__c == 0){
            helper.showErrorToast({
                "title": "Required: Quotation Request",
                "type": "error",
                "message": "Please enter valid Stock Retreading Charge"
            });
            return false;  
        }
        */
        
        var contactObj = new Object({'ETT_Quantity__c':1});
        addRowInList.push(contactObj);
        component.set("v.stagingQuotationRequest",addRowInList);
    },
    removeRowQuotationRequest : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingQuotationRequest");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingQuotationRequest", AllRowsList);
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
    
    /*onCheck : function(component, event, helper){
        var isOwn = component.get("v.isOwn");
        if(isOwn==false)
            component.set("v.isOwn", true);
        else{
            component.set("v.isOwn", false);
        }
    },*/
    
    clickCreate : function(component, event, helper){
        
        component.set('v.isdisabled',false);
       // debugger;
        var indexNo = event.getParam("index");
        var sobjectId = event.getParam("dynamicId");
        var stgLeadObj = component.get("v.newLead");
        var serviceRecordTypeId = $A.get("{!$Label.c.ETT_LeadRecordTypeService}");
        var stgcontactList  = component.get("v.stagingContactList");    
        var stgCustomerVehicleDetails = component.get("v.stagingCustomerVehicleList");
        var stagingQuotationRequest   = component.get("v.stagingQuotationRequest");
        var stagingPurchaseInformation  = component.get("v.stagingPurchaseInformation");
        let paymentType = component.get("v.newLead.ETT_Payment_Type__c");
        stgLeadObj.RecordTypeId = serviceRecordTypeId;        
        
        
        var isError = component.get("v.isError");
        var isCompanyError = component.get("v.isCompanyError");
        var isAddressError = component.get("v.isAddressError");
        var isPhoneError = component.get("v.isPhoneError");
        var isWebsiteError = component.get("v.isWebsiteError");
        var isTRNError = component.get("v.isTRNError");
        var isLNameError = component.get("v.isLNameError");
        
        if(isError==true || isCompanyError==true || isAddressError==true ||
           isPhoneError==true || isWebsiteError==true|| isTRNError==true|| isLNameError==true){
            
            helper.showErrorToast({
                "title": "Required: Lead Form",
                "type": "error",
                "message": "Please fix all errors to proceed further"
            });
            return false;
        }
        
        if(stgLeadObj.Company==''||stgLeadObj.Company==null ||
           stgLeadObj.Street==''||stgLeadObj.Street==null ||
           stgLeadObj.Email==''||stgLeadObj.Email==null ||           
           stgLeadObj.Phone==''||stgLeadObj.Phone==null ||
           (paymentType =='Credit' && (stgLeadObj.ETT_VAT_TRN__c==''||stgLeadObj.ETT_VAT_TRN__c==null)) ||
           stgLeadObj.LastName==''||stgLeadObj.LastName==null ){
            helper.showErrorToast({
                "title": "Required: Lead Form",
                "type": "error",
                "message": "Company Name, Address, Email, Phone, TRN Number, Last Name Fields are required"
            });
            return false;
        }
        
        
        
        console.log(JSON.stringify(stgcontactList));
        if(stgcontactList!=null && stgcontactList.length>0){
            for(var i=0;i<stgcontactList.length;i++){
                
                if((stgcontactList[i].Name!=null&&stgcontactList[i].Name!='')||
                   (stgcontactList[i].ETT_Designation__c!=null&&stgcontactList[i].ETT_Designation__c!='')||
                   (stgcontactList[i].ETT_Phone__c!=null&&stgcontactList[i].ETT_Phone__c!='')||
                   (stgcontactList[i].ETT_Email__c!=null&&stgcontactList[i].ETT_Email__c!='')                   
                  ){
                    
                    if(stgcontactList[i].Name==''||stgcontactList[i].Name==null ||
                       stgcontactList[i].ETT_Phone__c==''||stgcontactList[i].ETT_Phone__c==null
                      ){
                        helper.showErrorToast({
                            "title": "Required: Staging Contact Details",
                            "type": "error",
                            "message": "Last Name, Mobile Fields are required"
                        });
                        return false;
                    }
                    
                  /*  if(isNaN((stgcontactList[i].ETT_Phone__c))){
                        helper.showErrorToast({
                            "title": "Required: Staging Contact Details",
                            "type": "error",
                            "message": "Please enter valid Mobile Number"
                        });
                        return false;
                    } */
                }
            }
        }
        
        console.log(JSON.stringify(stgCustomerVehicleDetails));        
        if(stgCustomerVehicleDetails!=null && stgCustomerVehicleDetails.length>0){
            for(var i=0;i<stgCustomerVehicleDetails.length;i++){
                
                if(stgCustomerVehicleDetails[i].ETT_Vehicle_Type__c!='' ||
                   stgCustomerVehicleDetails[i].ETT_Vehicle_Configuration__c!=''||
                   stgCustomerVehicleDetails[i].ETT_Axil_Configuration__c!=''||
                   stgCustomerVehicleDetails[i].ETT_Application__c!='' ||
                   stgCustomerVehicleDetails[i].ETT_Vehicle_In_Fleet__c!=0 ||
                   stgCustomerVehicleDetails[i].ETT_Tyres_In_Fleet__c!=0 ||                   
                   stgCustomerVehicleDetails[i].ETT_KMS_Covered_Yearly__c!= 0 
                  ){
                    if(stgCustomerVehicleDetails[i].ETT_Axil_Configuration__c==''||stgCustomerVehicleDetails[i].ETT_Axil_Configuration__c==null ||
                       stgCustomerVehicleDetails[i].ETT_Application__c==null ||stgCustomerVehicleDetails[i].ETT_Application__c==0 ||
                       stgCustomerVehicleDetails[i].ETT_KMS_Covered_Yearly__c==null ||stgCustomerVehicleDetails[i].ETT_KMS_Covered_Yearly__c==0 ){
                        
                        helper.showErrorToast({
                            "title": "Required: Staging Vehicle Details",
                            "type": "error",
                            "message": "Axle Configuration, Application, KMS Covered yearly Fields are required"
                        });
                        return false;
                        
                    }
                    
                    if(isNaN(stgCustomerVehicleDetails[i].ETT_Vehicle_In_Fleet__c)){
                        
                        helper.showErrorToast({
                            "title": "Required: Staging Vehicle Details",
                            "type": "error",
                            "message": "Only digits are allowed in Vehicles In Fleet"
                        });
                        return false;                        
                    }
                    if(isNaN(stgCustomerVehicleDetails[i].ETT_Tyres_In_Fleet__c)){
                        
                        helper.showErrorToast({
                            "title": "Required: Staging Vehicle Details",
                            "type": "error",
                            "message": "Only digits are allowed in Tyres In Fleet"
                        });
                        return false;                        
                    }
                    if(isNaN(stgCustomerVehicleDetails[i].ETT_KMS_Covered_Yearly__c)){
                        
                        helper.showErrorToast({
                            "title": "Required: Staging Vehicle Details",
                            "type": "error",
                            "message": "Only digits are allowed in KMS Covered yearly"
                        });
                        return false;                        
                    }
                    
                }
            }
        }  
        
        
        console.log('stagingQuotationRequest '+JSON.stringify(stagingQuotationRequest));        
        if(stagingQuotationRequest!=null && stagingQuotationRequest.length>0){
            for(var i=0;i<stagingQuotationRequest.length;i++){
               // alert(stagingQuotationRequest[i].ETT_Tyre_Size_Master__c)
                if(stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == ''){
                    
                    /*if(isNaN(stagingQuotationRequest[i].ETT_Retreading_charge__c)){
                        helper.showErrorToast({
                            "title": "Required: Quotation Request",
                            "type": "error",
                            "message": "Only numbers are allowed in Retreading Charge"
                        });
                        return false;
                    }
                    if(isNaN(stagingQuotationRequest[i].ETT_Stock_Retreading_Charge__c)){
                        helper.showErrorToast({
                            "title": "Required: Quotation Request",
                            "type": "error",
                            "message": "Only numbers are allowed in Stock Retreading Charge"
                        });
                        return false;
                    }
                    */
                    if(stagingQuotationRequest[i].ETT_Tyre_Size_Master__c=='' ||
                       stagingQuotationRequest[i].ETT_Tyre_Size_Master__c==null){
                        
                        helper.showErrorToast({
                            "title": "Required: Quotation Request",
                            "type": "error",
                            "message": "Tyre Size is required field"
                        });
                        return false;
                        if(isStagingQuotationEmpty){
                            var childComp = component.find('childComp');
                            childComp.callChild('0000','validate','Lead'); 
                            
                        }
                    }
                    
                    if(i<stagingQuotationRequest.length-1){
                        if(stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == stagingQuotationRequest[i+1].ETT_Tyre_Size_Master__c){
                            helper.showErrorToast({
                                "title": "Required: Quotation Request",
                                "type": "error",
                                "message": "Tyre Size Could not be duplicate"
                            });
                            return false;
                        }
                    }
                }
                
                 if(stagingQuotationRequest[i].ETT_Purchase_Price__c=='' ||
                       stagingQuotationRequest[i].ETT_Purchase_Price__c==null){
                        
                        helper.showErrorToast({
                            "title": "Required: Quotation Request",
                            "type": "error",
                            "message": "Price is required in Quotation Request"
                        });
                        return false;
                        
                    }
            }
        }
        
        /*
        console.log(JSON.stringify(stagingPurchaseInformation));        
        if(stagingPurchaseInformation!=null && stagingPurchaseInformation.length>0){
            for(var i=0;i<stagingPurchaseInformation.length;i++){
                
                if((stagingPurchaseInformation[i].ETT_Tyre_Size_Master__c!=null&&stagingPurchaseInformation[i].ETT_Tyre_Size_Master__c!='')||
                   (stagingPurchaseInformation[i].ETT_Type__c!=null&&stagingPurchaseInformation[i].ETT_Type__c!='')||
                   (stagingPurchaseInformation[i].ETT_Brand_Master__c!=null&&stagingPurchaseInformation[i].ETT_Brand_Master__c!='')||
                   (stagingPurchaseInformation[i].ETT_Yearly_Qty__c!=null&&stagingPurchaseInformation[i].ETT_Yearly_Qty__c!='')||
                   (stagingPurchaseInformation[i].ETT_Price__c!=null&&stagingPurchaseInformation[i].ETT_Price__c!='')||
                   (stagingPurchaseInformation[i].ETT_Payment_Terms__c!=null&&stagingPurchaseInformation[i].ETT_Payment_Terms__c!='')
                  ){
                    
                    if(stagingPurchaseInformation[i].ETT_Tyre_Size_Master__c=='' || stagingPurchaseInformation[i].ETT_Tyre_Size_Master__c==null||
                       stagingPurchaseInformation[i].ETT_Type__c=='' || stagingPurchaseInformation[i].ETT_Type__c==null||
                       stagingPurchaseInformation[i].ETT_Brand_Master__c=='' || stagingPurchaseInformation[i].ETT_Brand_Master__c==null||
                       stagingPurchaseInformation[i].ETT_Yearly_Qty__c=='' || stagingPurchaseInformation[i].ETT_Yearly_Qty__c==null){
                        helper.showErrorToast({
                            "title": "Required: Quotation Request",
                            "type": "error",
                            "message": "Tyre Size, Type, Brand, Yearly Qty In Fleet Fields are required"
                        });
                        return false;
                    }
                //}
            }
        }*/	
        
        
        
        var actSave = component.get("c.saveDML");
        debugger;
        var strLeadJson = JSON.stringify(stgLeadObj);
        var stgconJson  = JSON.stringify(stgcontactList);
        var strVehicleJson  = JSON.stringify(stgCustomerVehicleDetails);
        var strQuotationRequestJson  = JSON.stringify(stagingQuotationRequest);
        var strPurchaseInformationJson  = JSON.stringify(stagingPurchaseInformation);        
        
        var mapNameForStagingObjects = {"stgLeadJson":strLeadJson,
                                        "stgContactJson":stgconJson,
                                        "stgVehicleJson":strVehicleJson,
                                        "stgQuoteJson":strQuotationRequestJson,
                                        /*"stgPurchaseJson":strPurchaseInformationJson*/};
        
        actSave.setParams({
            "mapofStageJsonList":mapNameForStagingObjects
        });
        
        actSave.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log(state);
            
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var childComp = component.find('childComp');
                childComp.callChild(res,'send','Lead');
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + response.getReturnValue()
                });
                urlEvent.fire();
            } else if(state === "ERROR"){
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
            }else if (state === "INCOMPLETE") {
                
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
        
        
    },
    
    handleServicePrices : function(component, event, helper) {
        
        var lstStgQuotation = component.get("v.stagingQuotationRequest");
        var indexvar = event.getSource().get("v.name");
        console.log('indexvar: '+indexvar);
       // alert("HI");
        //alert( lstStgQuotation[indexvar].ETT_Tyre_Life__c);
       // alert(lstStgQuotation[indexvar].ETT_Tyre_Process__c);
        var tyreLife = lstStgQuotation[indexvar].ETT_Tyre_Life__c;
        var tyreCondition = lstStgQuotation[indexvar].ETT_Tyre_Condition__c;
        
        console.log(JSON.stringify(lstStgQuotation[indexvar]));
        
        if(tyreLife!=null && tyreCondition!=null){
            
            if(tyreLife.includes("New") && tyreCondition.includes("Hot")){
                component.set("v.isNewHot",true);
            }else{
                component.set("v.isNewHot",false);
            }
            
            if(tyreLife.includes("New") && tyreCondition.includes("Procure")){
                component.set("v.isNewProcure",true);
            }else{
                component.set("v.isNewProcure",false);
            }
            
            if(tyreLife.includes("Retread") && tyreCondition.includes("Hot")){
                component.set("v.isRetreadHot",true);
            }else{
                component.set("v.isRetreadHot",false);
            }
            
            if(tyreLife.includes("Retread") && tyreCondition.includes("Procure")){
                component.set("v.isRetreadProcure",true);
            }else{
                component.set("v.isRetreadProcure",false);
            }
            
            if(tyreLife.includes("Repair")){
                component.set("v.isRepair",true);
            }else{
                component.set("v.isRepair",false);            
            }
        }else{
            console.log('Pls select options first');
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message: "Please select values from Tyre Life && Tyre Condition"
            });
            return false;    
        }
        
        
    },
    
    setPrice : function(component, event, helper){
        var lstStgQuotation = component.get("v.stagingQuotationRequest");
        var indexvar = event.getSource().get("v.name");
        console.log('indexvar: '+indexvar);
        
        var price = lstStgQuotation[indexvar].ETT_Purchase_Price__c;  //component.get("v.price");
        console.log(price);
        
        var tyreLife = lstStgQuotation[indexvar].ETT_Tyre_Life__c;
        var tyreCondition = lstStgQuotation[indexvar].ETT_Tyre_Condition__c;
        
        if(tyreLife!=null && tyreCondition!=null){
            
            if(tyreLife.includes("New") && tyreCondition.includes("Hot")){
                lstStgQuotation[indexvar].ETT_New_Hot_Price__c = price
            }
            
            if(tyreLife.includes("New") && tyreCondition.includes("Procure")){
                lstStgQuotation[indexvar].ETT_New_Procure_Price__c = price 
            }
            
            if(tyreLife.includes("Retread") && tyreCondition.includes("Hot")){
                lstStgQuotation[indexvar].ETT_Retread_Hot_Price__c = price 
            }
            
            if(tyreLife.includes("Retread") && tyreCondition.includes("Procure")){
                lstStgQuotation[indexvar].ETT_Retread_Procure_Price__c = price
            }
            
            if(tyreLife.includes("Repair")){
                lstStgQuotation[indexvar].ETT_Repair_Price__c = price
            }
            
            component.set("v.stagingQuotationRequest",lstStgQuotation);
            
        }else{
            console.log('Pls select options first');
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message: "Please select values from Tyre Life && Tyre Condition"
            });
            return false;    
        }
        
        console.log(JSON.stringify(component.get("v.stagingQuotationRequest")));
        
    }
    
})