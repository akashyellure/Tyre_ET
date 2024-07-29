({
    doInit: function(component, event, helper) {
        // create a Default RowItem [Contact Instance] on first time Component Load
        // get the contactList from component and add(push) New Object to List
        
        var newLead = component.get("v.newLead"); 
        var supplierRecordType = $A.get("$Label.c.ETT_QuotationSupplier");
        //var supplierRecordType = $A.get("$Label.c.ET_Tyre");
        
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
            ETT_New_Brand__c: "",
            ETT_New_Pattern__c: "",
            ETT_New_Country__c: ""
        });
        
        component.set("v.stagingQuotationRequest", stagingQuotationRequest);
        
        helper.fetchPickListVal(component, "ETT_Payment_Type__c", "PaymentType");
        helper.fetchPickListVal(component, "ETT_Party_Type__c", "PartyType");
        helper.fetchPickListVal(component, "ETT_Tyre_Life__c", "tyreLife");
        
        //var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        //component.set("v.todaysDate", today);
        
        /*var action = component.get("c.getLeadRecordTypeID");
        action.setParams({ recTypeName : 'Supplier' });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                newLead.RecordTypeId = response.getReturnValue();
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);*/
    },
    convertCase: function(component, event, helper){
        var val = event.getSource().get("v.value");
        if(val!=null){
            val = val.toUpperCase();
            var selectCmp = event.getSource();
            selectCmp.set("v.value",val) ;  
        }
    },
    validateMobile : function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var Mobile = newLead.MobilePhone;
        var phonRegex = /^(?:\+971 |00971 |0 )?(?:50|51|52|54|55|56|2|3|4|6|7|9)\d{7}$/;
        var prefix = '+';
        if(Mobile.indexOf(prefix) !== 0 ){
            Mobile = '+971 '+Mobile;
            component.set("v.newLead.MobilePhone",Mobile);
        }
        
        /*if(isNaN(Mobile)){
            document.getElementById("mobErr").innerHTML = "Error: Please enter only numbers";
            component.set("v.isMobileError",true);
            return false;
        }/*else if(Mobile.length != 10){
            document.getElementById("mobErr").innerHTML = "Error: Please enter atleast 10 digits";
            component.set("v.isMobileError",true);
            return false;                        
        }else{
            component.set("v.isMobileError",false);            
            document.getElementById("mobErr").innerHTML = "";
        }*/
        
        if(!Mobile.toString().match(phonRegex)){
            component.set("v.isMobileError",true);
            document.getElementById("mobErr").innerHTML = "Error: Please enter valid phone number";
            return false;
        }else{
            component.set("v.isMobileError",false);
            document.getElementById("mobErr").innerHTML = "";
        }
        
    },
    validatePhone: function(component, event, helper){
        debugger;
        var newLead = component.get("v.newLead");
        var Phone = newLead.Phone;
        var phonRegex = /^(?:\+971 |00971 |0 )?(?:50|51|52|54|55|56|2|3|4|6|7|9)\d{7}$/;
        var prefix = '+';
        if(Phone.indexOf(prefix) !== 0 ){
            Phone = '+971 '+Phone;
            component.set("v.newLead.Phone",Phone);
        }
        
        if(!Phone.toString().match(phonRegex)){
            component.set("v.isError",true);
            document.getElementById("mobileErr").innerHTML = "Error: Please enter valid phone number";
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("mobileErr").innerHTML = "";
        }
        /*if(isNaN(newLead.Phone)){
            component.set("v.isError",true);
            document.getElementById("mobileErr").innerHTML = "Error: Please enter only digits in Phone";                                    
            return false;            
        }else{
            component.set("v.isError",false);
            document.getElementById("mobileErr").innerHTML = "";
        }*/
        
        /*if(newLead.Phone.length < 10){
            component.set("v.isError",true);
            document.getElementById("mobileErr").innerHTML = "Error: Please enter valid Phone";                                                
            return false;            
        }else{
            component.set("v.isError",false);
            document.getElementById("mobileErr").innerHTML = "";
        }*/
        
    },
    
    validateTRN: function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var TRN = newLead.ETT_VAT_TRN__c;
        var trnRegex = /^[0-9]+$/i;
        
        if(!TRN.toString().match(trnRegex)){
            component.set("v.isError",true);
            document.getElementById("trnErr").innerHTML = "Error: Please enter only numbers in TRN Number";
            return false;
        }else{
            component.set("v.isError",false);
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
            component.set("v.isError",true);
            document.getElementById("fnameErr").innerHTML = "Error: Please enter valid FirstName";
        }else{
            component.set("v.isError",false);
            document.getElementById("fnameErr").innerHTML = "";
        }
    },
    
    validateLastName:function(component,event,helper){
        var newLead = component.get("v.newLead");
        var LastName = newLead.LastName;
        var fnameReg = /^[a-z]+$/i;
        
        if(!LastName.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("lnameErr").innerHTML = "Error: Please enter valid LastName";
        }else{
            component.set("v.isError",false);
            document.getElementById("lnameErr").innerHTML = "";
        }
    },  
    
    validateFax: function(component, event, helper){
        /*
        var newLead = component.get("v.newLead");
        var fax = newLead.Fax;
        //var faxRegex = /^\+?[0-9]+$/;
        var faxRegex = /^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$/;
        
        if(!fax.toString().match(faxRegex)){
            component.set("v.isError",true);
            document.getElementById("faxErr").innerHTML = "Error: Please enter only numbers in Fax";
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("faxErr").innerHTML = "";
        }
        */
        
        var newLead = component.get("v.newLead");
        var Fax = newLead.Fax;
        var faxRegex = /^(?:\+971 |00971 |0 )?(?:50|51|52|54|55|56|2|3|4|6|7|9)\d{7}$/;
        var prefix = '+';
        if(Fax.indexOf(prefix) !== 0 ){
            Fax = '+971 '+Fax;
            component.set("v.newLead.Fax",Fax);
        }
        
        if(!Fax.toString().match(faxRegex)){
            component.set("v.isError",true);
            document.getElementById("faxErr").innerHTML = "Error: Please enter valid FAX";
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("faxErr").innerHTML = "";
        }
    },
    
    validateWebsite: function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var website = newLead.ETT_Web_Address__c;   
        var webRegex = /^((https?|ftp|smtp):\/\/)?(www.)?[a-z0-9]+\.[a-z]+(\/[a-zA-Z0-9#]+\/?)*$/;
        
        if(!website.toString().match(webRegex)){
            component.set("v.isError",true);
            document.getElementById("websiteErr").innerHTML = "Error: Please enter valid Website";
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("websiteErr").innerHTML = "";
        }
        
    },
    
    validateTradeLicenseNumber: function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var tradeLic = newLead.ETT_Trade_License_Number__c;
        var trnRegex = /^[a-z]+$/i;
        
        if(tradeLic.toString().match(trnRegex)){
            component.set("v.isError",true);
            document.getElementById("tradeLicErr").innerHTML = "Error: Trade License Number can't be only alphabates"; 
            return false;            
        }else{
            component.set("v.isError",false);
            document.getElementById("tradeLicErr").innerHTML = "";
        }
        
    },
    
    validateEmiratesId:function(component,event,helper){
       
       var newLead = component.get("v.newLead");
       var emiratesId = newLead.ETT_Emirates_Id__c;
       var emiratesRejex = new RegExp("^784-[0-9]{4}-[0-9]{7}-[0-9]{1}$");
       var res = emiratesRejex.test(emiratesId);
        
        if(!res){
            component.set("v.isError",true);
            document.getElementById("emiratesIdErr").innerHTML = "Error: Please enter valid Emirates Id"; 
            return false;            
        }else{
            component.set("v.isError",false);
            document.getElementById("emiratesIdErr").innerHTML = "";
        } 
       
    },
    
    validateAddress: function(component, event, helper){
        
        var newLead = component.get("v.newLead");
        var address = newLead.Street; 
        var addressRegex = /^[0-9]+$/i;
        
        if(address.toString().match(addressRegex)){
            component.set("v.isError",true);
            document.getElementById("addressErr").innerHTML = "Error: Please enter valid address";
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("addressErr").innerHTML = "";
        }        
        
    },
    
    dateUpdate : function(component, event, helper) {
        
        console.log('function is called');
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
        
        var date1 = new Date(todayFormattedDate);
        var date2 = new Date(component.get("v.newLead.ETT_Trade_Licenses_Expiry_Date__c"));
        
        const diffTime = Math.abs(date2 - date1);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
        
        
        if(component.get("v.newLead.ETT_Trade_Licenses_Expiry_Date__c") != '' && component.get("v.newLead.ETT_Trade_Licenses_Expiry_Date__c") < todayFormattedDate){
            component.set("v.isError",true);
            document.getElementById("dateErr").innerHTML = "Error: Please select future date";
        }else if(diffDays < 8){
            component.set("v.isError",true);
            document.getElementById("dateErr").innerHTML = "Error: Validity will expire shortly"; 
        }else{
            component.set("v.isError",false);
            document.getElementById("dateErr").innerHTML = "";            
        }
        
    },
    
    addNewRowQuotationRequest: function(component, event, helper) {
        
        component.set("v.TyreSizeName", '');
        component.set("v.BrandName", '');
        component.set("v.PatternName", '');
        component.set("v.CountryName", '');
        
        
        var addRowInList = component.get("v.stagingQuotationRequest");
        var quotationObj = new Object();
        
        quotationObj.ETT_Quantity__c = 1;
        var supplierRecordType = $A.get("$Label.c.ETT_QuotationSupplier");
        
        quotationObj.RecordTypeId = supplierRecordType;
        addRowInList.push(quotationObj);
        component.set("v.stagingQuotationRequest", addRowInList);
    },
    
    removeRowQuotationRequest: function(component, event, helper) {
        var whichOne = event.target.getAttribute("id");
        var AllRowsList = component.get("v.stagingQuotationRequest");
        AllRowsList.splice(whichOne, 1);
        component.set("v.stagingQuotationRequest", AllRowsList);
    },
    
    handleComponentEvent: function(component, event, helper) {
        
        console.log('********');
        var name = event.getParam("name");
        var index = event.getParam("index");
        var dynamicId = event.getParam("dynamicId");
        var objectName = event.getParam("objectName");
        
        console.log('name: '+name);
        console.log('index: '+index);
        console.log('dynamicId: '+dynamicId);
        console.log('objectName: '+objectName);
        
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
        
        console.log(component.get("v.CountryName"));
        console.log(component.get("v.PatternName"));
        console.log(component.get("v.BrandName"));
        console.log(component.get("v.TyreSizeName"));
    },
    
    clickCreate: function(component, event, helper) {
        
        component.set('v.isdisabled',true);
        var isError = component.get("v.isError");
        var isMobileError = component.get("v.isMobileError");
        
        if(isError == true || isMobileError == true){
            
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please fix all errors to proceed further"
            });
            return false;
        }
        
        var indexNo = event.getParam("index");
        var sobjectId = event.getParam("dynamicId");
        var stgLeadObj = component.get("v.newLead");
        var stagingQuotationRequest = component.get("v.stagingQuotationRequest");
        var isDateError = component.get("v.dateValidationError");
        
        var supplierRecordTypeId = $A.get("{!$Label.c.ETT_LeadRecordTypeSupplier}");
        //stgLeadObj.RecordTypeId = '0120C00000073ePQAQ';
        stgLeadObj.RecordTypeId = $A.get("$Label.c.ETT_Tyre_Cash_Individual");
        
        console.log(supplierRecordTypeId);
        console.log(JSON.stringify(stgLeadObj));
        
        
        if (stgLeadObj.Street == "" ||
            stgLeadObj.Street == null ||
            stgLeadObj.MobilePhone == null ||
            stgLeadObj.MobilePhone == "" ||
            stgLeadObj.LastName == null ||
            stgLeadObj.LastName == "" ||
            stgLeadObj.ETT_Payment_Type__c == "" ||
            stgLeadObj.ETT_Payment_Type__c == null){
            helper.showErrorToast({
                title: "Required: Supplier Form",
                type: "error",
                message:
                "Address, Last Name, Payment Type Fields are required"
            });
            return false;
        }
        
        if(isDateError == true){
            helper.showErrorToast({
                title: "Required: Supplier Form",
                type: "error",
                message:
                "Date must be in present or in future"
            });
            return false;
        }
        /*
        if(stagingQuotationRequest.length == 0){
            helper.showErrorToast({
                title: "Required: Supplier Price Agreement",
                type: "error",
                message:
                "Please enter Supplier Price Agreement Details"
            });
            return false;
        }*/
        
        if (stagingQuotationRequest != null && stagingQuotationRequest.length > 0) {
            for (var i = 0; i < stagingQuotationRequest.length; i++) {
                
                if(component.get("v.TyreSizeName") == 'New' && stagingQuotationRequest[i].ETT_New_Tyre_Size__c == ''){
                    helper.showErrorToast({
                        title: "Required",
                        type: "error",
                        message: "Please enter Tyre Size"
                    });
                    return false;
                }
                if(component.get("v.BrandName") == 'New' && stagingQuotationRequest[i].ETT_New_Brand__c == ''){
                    helper.showErrorToast({
                        title: "Required",
                        type: "error",
                        message: "Please enter Brand Name"
                    });
                    return false;
                }
                if(component.get("v.PatternName") == 'New' && stagingQuotationRequest[i].ETT_New_Pattern__c == ''){
                    helper.showErrorToast({
                        title: "Required",
                        type: "error",
                        message: "Please enter Pattern Name"
                    });
                    return false;
                }
                if(component.get("v.CountryName") == 'New' && stagingQuotationRequest[i].ETT_New_Country__c == ''){
                    helper.showErrorToast({
                        title: "Required",
                        type: "error",
                        message: "Please enter Country Name"
                    });
                    return false;
                }                
                
                
                if (stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == null &&
                    stagingQuotationRequest[i].ETT_Brand__c == null &&
                    stagingQuotationRequest[i].ETT_Country__c == null &&
                    stagingQuotationRequest[i].ETT_Pattern__c == null ) {
                    stagingQuotationRequest.splice(i, 1);
                }
                
                if (stagingQuotationRequest[i].ETT_Tyre_Size_Master__c != null) {
                    if (stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == "" ||
                        stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == null ) {
                        helper.showErrorToast({
                            title: "Required",
                            type: "error",
                            message: "Quantity,Tyre Size Fields are required"
                        });
                        return false;
                    }
                }
                
                
                if (stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == null ||
                    stagingQuotationRequest[i].ETT_Tyre_Size_Master__c == '' ||
                    stagingQuotationRequest[i].ETT_Brand__c == null ||
                    stagingQuotationRequest[i].ETT_Brand__c == '' ||                    
                    stagingQuotationRequest[i].ETT_Country__c == null ||
                    stagingQuotationRequest[i].ETT_Country__c == '' ||
                    stagingQuotationRequest[i].ETT_Pattern__c == null ||
                   stagingQuotationRequest[i].ETT_Pattern__c == ''){
                    
                    helper.showErrorToast({
                        title: "Required",
                        type: "error",
                        message: "Tyre Size, Brand, Pattern, Country are required fields"
                    });
                    return false;
                }
            }
        }
        
        stgLeadObj.Company = '';
        
        var strLeadJson = JSON.stringify(stgLeadObj);
        var stgQuotationJson = JSON.stringify(stagingQuotationRequest);
        
        
        console.log(stgQuotationJson);        
        
        
        
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
                
                if (uniqueArray.indexOf(combin) > -1) {
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
        
        var actSave = component.get("c.saveDML");
        var mapNameForStagingObjects = {
            stgLeadJson: strLeadJson,
            stgQuoteJson: stgQuotationJson
        };
        actSave.setParams({
            mapofStageJsonList: mapNameForStagingObjects
        });
        
        actSave.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var res = response.getReturnValue();
                var childComp = component.find('childComp');
                childComp.callChild(res,'send','Lead');
                
                
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
    }
});