({
    doInit : function(component, event, helper) {
        
        helper.fetchPickListVal(component, "ETT_Payment_Terms__c", "paymentTerms");
        helper.fetchPickListVal(component, "ETT_Legal_Status__c", "legalStatus");
        helper.fetchPickListVal(component, "ETT_Emirate__c", "Emirate");
        
        
        var stagingContactList = component.get("v.stagingContactList");          
        var stagingCustomerLPOList   =    component.get("v.stagingCustomerLPOList");
        var stagingTradeReferenceList  = component.get("v.stagingTradeReferenceList");
        var stagingBankReferenceList   = component.get("v.stagingBankReferenceList");

        stagingContactList.push({
            'sobjectType': 'ETT_Staging_Contacts__c',
            'Name': '',
            'Email': '',
            'ETT_Designation__c': '',
            'MobilePhone':''
        });
        
        stagingCustomerLPOList.push({
            'sobjectType': 'ETT_Staging_Customer_LPO__c',
            'Name': '',
            'ETT_Designation__c': '',
            'ETT_Signature__c': ''
        });
        
        stagingTradeReferenceList.push({
            'sobjectType': 'ETT_Staging_Trade_Reference__c',
            'ETT_Supplier_Name_Details__c': '',
            'ETT_Length_of_relationship__c': '',
            'ETT_Credit_Limit__c': '',
            'ETT_Payment_Terms__c':''
        });
        
        stagingBankReferenceList.push({
            'sobjectType': 'ETT_Staging_Bank_Reference__c',
            'Name': '',
            'ETT_Address__c': '',
            'ETT_Account_Number__c': '',
            'ETT_Starting_With__c':''
        });        
        
        component.set("v.stagingContactList", stagingContactList);
        component.set("v.stagingCustomerLPOList", stagingCustomerLPOList);
        component.set("v.stagingTradeReferenceList", stagingTradeReferenceList);
        component.set("v.stagingBankReferenceList", stagingBankReferenceList);        
        
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
            }else if (state === "ERROR") {
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
    handleCompanyOnChange : function(component,event,helper){
        
    },
    validateEmirate : function(component,event,helper){
        
        var newLead = component.get("v.newLead");
        var Emirates_Id = newLead.ETT_Emirate__c;        
        var regex = /^784-[0-9]{4}-[0-9]{7}-[0-9]{1}$/;
        
        if(Emirates_Id.toString().match(regex)){
            document.getElementById("EmirateErr").innerHTML = "";
        }else{
            document.getElementById("EmirateErr").innerHTML = "Error: Please enter valid Emirates Id";
        }
        
    },
    validateCompanyName : function(component,event,helper){
        var newLead = component.get("v.newLead");
        var Company = newLead.Company;
        var Reg = /^[0-9]+$/i;
        
        if(Company!='' && Company.toString().match(Reg)){
            document.getElementById("companyErr").innerHTML = "Error: Please enter valid Company Name";
        }else{
            document.getElementById("companyErr").innerHTML = "";
        }
    },
    validateTradExpiryDate : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        var tradeLicenseExpiryDate = newLead.ETT_Trade_Licenses_Expiry_Date__c;
        
        var date1 = new Date(todayFormattedDate);
        var date2 = new Date(tradeLicenseExpiryDate);
        
        const diffTime = Math.abs(date2 - date1);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
        
        if(component.get("v.newLead.ETT_Trade_Licenses_Expiry_Date__c") != '' && component.get("v.newLead.ETT_Trade_Licenses_Expiry_Date__c") < todayFormattedDate){
            document.getElementById("TradExpiryDateErr").innerHTML = "Error: Please select future date";
            return false;
        }else if(diffDays < 8){
            document.getElementById("TradExpiryDateErr").innerHTML = "Error: Validity will expire shortly"; 
            return false;
        }else{
            document.getElementById("TradExpiryDateErr").innerHTML = "";            
        }
        
        
    },
    validateLeadCommerceCertificationExpiryDate : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        var tradeLicenseExpiryDate = newLead.ETT_Chamber_of_Comm_Cert_Expiry_Date__c;
        
        var date1 = new Date(todayFormattedDate);
        var date2 = new Date(tradeLicenseExpiryDate);
        
        const diffTime = Math.abs(date2 - date1);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
        
        if(component.get("v.newLead.ETT_Chamber_of_Comm_Cert_Expiry_Date__c") != '' && component.get("v.newLead.ETT_Chamber_of_Comm_Cert_Expiry_Date__c") < todayFormattedDate){
            document.getElementById("leadCommerceCertificationExpiryDateErr").innerHTML = "Error: Please select future date";
            return false;
        }else if(diffDays < 8){
            document.getElementById("leadCommerceCertificationExpiryDateErr").innerHTML = "Error: Validity will expire shortly"; 
            return false;
        }else{
            document.getElementById("leadCommerceCertificationExpiryDateErr").innerHTML = "";            
        }
        
        
    },
    leadNameofChiefExecutive: function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var ChiefExecutiveOfficer = newLead.ETT_Name_of_Chief_Executive_Officer__c;
        var fnameReg = /^[a-zA-Z ]*$/;
        
        if(!ChiefExecutiveOfficer.toString().match(fnameReg)){
            document.getElementById("leadNameofChiefExecutiveErr").innerHTML = "Error: Please enter valid Name of Chief Executive Officer";
        }else{
            document.getElementById("leadNameofChiefExecutiveErr").innerHTML = "";
        }
    },
    validateleadChamberofCommerce : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var leadChamberofCommerce = newLead.ETT_Chamber_of_Commerce_Certification_No__c;
        var fnameReg = /^[0-9]+$/i;
        
        if(!leadChamberofCommerce.toString().match(fnameReg)){
            document.getElementById("leadChamberofCommerceErr").innerHTML = "Error: Please enter only Numbers";
        }else{
            document.getElementById("leadChamberofCommerceErr").innerHTML = "";
        }
    },
    validateTradeLicNumber : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var TradeNo = newLead.ETT_Trade_License_Number__c;
        var fnameReg = /^[0-9]+$/i;
        
        if(!TradeNo.toString().match(fnameReg)){
            document.getElementById("TradeLicNumberErr").innerHTML = "Error: Please enter only numbers in Trade License Number";
        }else{
            document.getElementById("TradeLicNumberErr").innerHTML = "";
        }
    },
    validateSponsorsPhone2 : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var Phone = newLead.ETT_Owners_Sponers_Phone_2__c;
        var phonRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$/;
        
        if(!Phone.toString().match(phonRegex)){
            document.getElementById("SponsorsPhone2Err").innerHTML = "Error: Please enter valid phone number";
            return false;
        }else{
            document.getElementById("SponsorsPhone2Err").innerHTML = "";
        }
    },
    validateSponsors2 : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var Sponsors_2 = newLead.ETT_Name_of_Owners_Sponsors_2__c;
        var fnameReg = /^[a-zA-Z ]*$/;
        
        if(!Sponsors_2.toString().match(fnameReg)){
            document.getElementById("Sponsors2Err").innerHTML = "Error: Please enter valid Sponsors2 Name";
        }else{
            document.getElementById("Sponsors2Err").innerHTML = "";
        }
    },
    validatePhone : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var Phone = newLead.Phone;
        var phonRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$/;
         var prefix = '+';
        if(Phone.indexOf(prefix) !== 0 ){
            Phone = '+971'+Phone;
            component.set("v.newLead.Phone",Phone);
        }
        if(!Phone.toString().match(phonRegex)){
            document.getElementById("mobileErr").innerHTML = "Error: Please enter valid phone number";
            return false;
        }else{
            document.getElementById("mobileErr").innerHTML = "";
        }
    },
    validateLeadPhone : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var Phone = newLead.Phone;
        var phonRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$/;
         var prefix = '+';
        if(Phone.indexOf(prefix) !== 0 ){
            Phone = '+971'+Phone;
            component.set("v.newLead.Phone",Phone);
        }
        if(!Phone.toString().match(phonRegex)){
            document.getElementById("PhoneLeadErr").innerHTML = "Error: Please enter valid phone number";
            return false;
        }else{
            document.getElementById("PhoneLeadErr").innerHTML = "";
        }
    },
     validateRelationship : function(component, event, helper) {
    	var relationship = event.getSource().get("v.value");
     // alert(relationship);
        var relationRegex = /^(\d{2})$/;
        
        if(!relationship.toString().match(relationRegex)){
        //      alert("not maych");
            document.getElementById("relationError").innerHTML = "Error: Please Enter 2 Digit.";
           
            return false;
        }else{
            //   alert(" maych");
            document.getElementById("relationError").innerHTML = "";
        }
    },
    
    validateSponsors1 : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var Sponsors1Err = newLead.ETT_Name_of_Owners_Sponsors_1__c;
        var fnameReg = /^[a-zA-Z ]*$/;
        
        if(!Sponsors1Err.toString().match(fnameReg)){
            document.getElementById("Sponsors1Err").innerHTML = "Error: Please enter valid Sponsors1 Name";
        }else{
            document.getElementById("Sponsors1Err").innerHTML = "";
        }
        
    },
    validateNatureOfBusiness : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var NatureOfBusiness = newLead.ETT_Nature_of_Business__c;
        var fnameReg = /^[a-zA-Z ]*$/;
        
        if(!NatureOfBusiness.toString().match(fnameReg)){
            document.getElementById("NatureOfBusinessErr").innerHTML = "Error: Please enter valid Nature Of Business";
        }else{
            document.getElementById("NatureOfBusinessErr").innerHTML = "";
        }
        
    },
    validateVAT : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var vat = newLead.ETT_VAT_TRN__c;
        
        if(isNaN(vat)){
            document.getElementById("vatErr").innerHTML = "Error: Please enter only digits in VAT TRN Number";
            return false;
        }else{
            document.getElementById("vatErr").innerHTML = "";
        }
        if(vat.length!=15){
            document.getElementById("vatErr").innerHTML = "Error: VAT TRN Number must be 15 digits";
            return false;
        }else{
            document.getElementById("vatErr").innerHTML = "";
        }        
        
    },
    validateEmail : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var Email = newLead.Email;
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        
        if(Email == ''){
            document.getElementById("emailErr").innerHTML = "Error: Please enter Email";                                    
            return false;
        }else{
            document.getElementById("emailErr").innerHTML = "";
        }                  
        
        if(!Email.match(regExpEmailformat)){
            document.getElementById("emailErr").innerHTML = "Error: Please enter valid email address";                                    
            return false;
        }else{
            document.getElementById("emailErr").innerHTML = "";
        }

        
    },
    validateFax : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var fax = newLead.Fax;
        var faxRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$/i;
      //   var faxRegex = /^[0-9]+$/i;
        var prefix = '+';
        if(fax.indexOf(prefix) !== 0 ){
            fax = '+971'+fax;
            component.set("v.newLead.Fax",fax);
        }
        
        if(!fax.toString().match(faxRegex)){
            document.getElementById("faxErr").innerHTML = "Error: Please enter valid Fax";
        }else{
          //  alert("match");
            document.getElementById("faxErr").innerHTML = "";
        }
    },
    validateLocation : function(component, event, helper) {
        var newLead = component.get("v.newLead");
        var location = newLead.ETT_Location__c;
        var fnameReg = /^[a-zA-Z ]*$/;
        
        if(!location.toString().match(fnameReg)){
            document.getElementById("locationErr").innerHTML = "Error: Please enter valid Location";
        }else{
            document.getElementById("locationErr").innerHTML = "";
        }
    },
    validatePOBox : function(component, event, helper) {
        var newLead = component.get("v.newLead");
    },
    
    AddNewRow : function(component, event, helper){
        var addRowInList = component.get("v.stagingContactList");
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
    
    addNewRowcustomerLPO : function(component, event, helper){
        var addRowInList = component.get("v.stagingCustomerLPOList");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingCustomerLPOList",addRowInList);
    },
    removeRowcustomerLPO : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingCustomerLPOList");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingCustomerLPOList", AllRowsList);
    },
    
    addNewRowtradeReference : function(component, event, helper){
        var addRowInList = component.get("v.stagingTradeReferenceList");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingTradeReferenceList",addRowInList);
    },
    removeRowtradeReference : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingTradeReferenceList");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingTradeReferenceList", AllRowsList);
    },
    
    addNewRowbankReference : function(component, event, helper){
        var addRowInList = component.get("v.stagingBankReferenceList");
        var contactObj = new Object();
        addRowInList.push(contactObj);
        component.set("v.stagingBankReferenceList",addRowInList);
    },
    removeRowbankReference : function(component, event, helper){
        var whichOne = event.target.getAttribute("id")
        var AllRowsList = component.get("v.stagingBankReferenceList");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingBankReferenceList", AllRowsList);
    },
   
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    
    clickCreate : function(component, event, helper){
       
        var newLead = component.get("v.newLead");
        var stagingContactList = component.get("v.stagingContactList");          
        var stagingCustomerLPOList   = component.get("v.stagingCustomerLPOList");
        var stagingTradeReferenceList  = component.get("v.stagingTradeReferenceList");
        var stagingBankReferenceList   = component.get("v.stagingBankReferenceList");
        
        newLead.Id = component.get("v.recordId");

        console.log(JSON.stringify(newLead));
        
        if(newLead!=null){
 
            if(newLead.Company==''||newLead.Company==null||
               newLead.ETT_VAT_TRN__c==''||newLead.ETT_VAT_TRN__c==null||
               newLead.ETT_Emirate__c==''||newLead.ETT_Emirate__c==null||
               newLead.Email==''||newLead.Email==null||
               newLead.Phone==''||newLead.Phone==null||
               newLead.ETT_Location__c==''||newLead.ETT_Location__c==null||
               newLead.ETT_Trade_License_Number__c==''||newLead.ETT_Trade_License_Number__c==null||
               newLead.ETT_Trade_Licenses_Expiry_Date__c==''||newLead.ETT_Trade_Licenses_Expiry_Date__c==null ){
                helper.showErrorToast({
                    "title": "Required: Lead",
                    "type": "error",
                    "message": "Name of Company, Phone, Email, Location, Emirate, Trade License Number,Trade Licenses Expiry Date, TRN Fields are required"
                });
                return false;
            }
        }
        
        
        var stgLeadJson = JSON.stringify(newLead);
        var stgContactJson  = JSON.stringify(stagingContactList);
        var stgCustomerLPOJson  = JSON.stringify(stagingCustomerLPOList);
        var stgTradeReferenceJson  = JSON.stringify(stagingTradeReferenceList);
        var stgBankReferenceJson  = JSON.stringify(stagingBankReferenceList);        
        
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
        
        
        if(stagingCustomerLPOList!=null && stagingCustomerLPOList.length>0){
            for(var i=0;i<stagingCustomerLPOList.length;i++){
                
                if((stagingCustomerLPOList[i].Name!=''&&stagingCustomerLPOList[i].Name!=null)||
                   (stagingCustomerLPOList[i].ETT_Designation__c!=''&&stagingCustomerLPOList[i].ETT_Designation__c!=null)||
                   (stagingCustomerLPOList[i].ETT_Signature__c!=''&&stagingCustomerLPOList[i].ETT_Signature__c!=null)){
                    
                    if(stagingCustomerLPOList[i].Name==''||stagingCustomerLPOList[i].Name==null ||
                       stagingCustomerLPOList[i].ETT_Designation__c==''||stagingCustomerLPOList[i].ETT_Designation__c==null
                      ){
                        helper.showErrorToast({
                            "title": "Required: Customer LPO List",
                            "type": "error",
                            "message": "Name, Designation LPO List Fields are required"
                        });
                        return false;
                    }


                    var nameReg = /^[a-zA-Z ]*$/;
                    if(!stagingCustomerLPOList[i].Name.toString().match(nameReg)){
                        helper.showErrorToast({
                            "title": "Required: Customer LPO List",
                            "type": "error",
                            "message": "Please enter valid Name"
                        });
                        return false;
                    }     
                    
                    if(!stagingCustomerLPOList[i].ETT_Designation__c.toString().match(nameReg)){
                        helper.showErrorToast({
                            "title": "Required: Customer LPO List",
                            "type": "error",
                            "message": "Please enter valid Designation"
                        });
                        return false;
                    } 
                    
                    
                }
            }
        }
        
        /*
        if(stagingTradeReferenceList!=null && stagingTradeReferenceList.length>0){
            for(var i=0;i<stagingTradeReferenceList.length;i++){
                
                
                if((stagingTradeReferenceList[i].ETT_Supplier_Name_Details__c!=''&&stagingTradeReferenceList[i].ETT_Supplier_Name_Details__c!=null)||
                   (stagingTradeReferenceList[i].ETT_Length_of_relationship__c!=''&&stagingTradeReferenceList[i].ETT_Length_of_relationship__c!=null)||
                   (stagingTradeReferenceList[i].ETT_Credit_Limit__c!=''&&stagingTradeReferenceList[i].ETT_Credit_Limit__c!=null)||
                   (stagingTradeReferenceList[i].ETT_Payment_Terms__c!=''&&stagingTradeReferenceList[i].ETT_Payment_Terms__c!=null)){
                    
                    if(stagingTradeReferenceList[i].ETT_Supplier_Name_Details__c==''||stagingTradeReferenceList[i].ETT_Supplier_Name_Details__c==null ){
                        helper.showErrorToast({
                            "title": "Required: Trade Reference",
                            "type": "error",
                            "message": "Trade Reference Fields are required"
                        });
                        return false;
                    }
                    
                }
                
            }
        }
        
        
        if(stagingBankReferenceList!=null && stagingBankReferenceList.length>0){
            for(var i=0;i<stagingBankReferenceList.length;i++){
                
                if((stagingBankReferenceList[i].Name!=''&&stagingBankReferenceList[i].Name!=null)||
                   (stagingBankReferenceList[i].ETT_Address__c!=''&&stagingBankReferenceList[i].ETT_Address__c!=null)||
                   (stagingBankReferenceList[i].ETT_Starting_With__c!=''&&stagingBankReferenceList[i].ETT_Starting_With__c!=null)||
                   (stagingBankReferenceList[i].ETT_Account_Number__c!=''&&stagingBankReferenceList[i].ETT_Account_Number__c!=null)){
                    
                    if(stagingBankReferenceList[i].Name==''||stagingBankReferenceList[i].Name==null){
                        helper.showErrorToast({
                            "title": "Required: Bank Reference",
                            "type": "error",
                            "message": "Name is required"
                        });
                        return false;
                    }
                    
                }
            }
        }
        */
        
        console.log('stgLeadJson: '+stgLeadJson);        
        console.log('stgContactJson: '+stgContactJson);
        console.log('stgCustomerLPOJson: '+stgCustomerLPOJson);
        console.log('stgTradeReferenceJson: '+stgTradeReferenceJson);
        console.log('stgBankReferenceJson: '+stgBankReferenceJson);    

        
        var actSave = component.get("c.saveDML");
        
        var mapNameForStagingObjects = {"stgLeadJson":stgLeadJson,
                                        "stgContactJson":stgContactJson,
                                        "stgCustomerLPOJson":stgCustomerLPOJson,
                                        "stgTradeReferenceJson":stgTradeReferenceJson,
                                        "stgBankReferenceJson":stgBankReferenceJson};
        
        actSave.setParams({
            "mapofStageJsonList":mapNameForStagingObjects
        });            
        
        actSave.setCallback(this, function(a){
            
            var state = a.getState();
            console.log('state: '+state);
            
            if(state == 'SUCCESS') {
                
                console.log('SUCCESS: '+a.getReturnValue());
                
                helper.showErrorToast({
                    "title": "Success: ",
                    "type": "success",
                    "message": "Record has been updated successfully"
                });
                
                $A.get("e.force:closeQuickAction").fire(); 
                
            }else if (state === "INCOMPLETE") {
                // do something
                console.log(state);
            }else if (state === "ERROR") {
                var errors = a.getError();
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
        
        
    }
    
})