({
    validateFirstName:function(component,event,helper){
        
        var objAcc = component.get("v.newLead");
        var FirstName = objAcc.FirstName;
        var fnameReg = /^[a-z]+$/i;
        
        if(!FirstName.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("fnameErr").innerHTML = "Error: Please enter valid FirstName";
        }else{
            component.set("v.isError",false);
            document.getElementById("fnameErr").innerHTML = "";
        }
    },
    
    convertCase: function(component, event, helper){
      var val = event.getSource().get("v.value");
        if(val!=null){
            val = val.toUpperCase();
            var selectCmp = event.getSource();
            selectCmp.set("v.value",val) ;  
        }
    },
    
    validateLastName:function(component,event,helper){
        var objAcc = component.get("v.newLead");
        var LastName = objAcc.LastName;
        var fnameReg = /^[a-z]+$/i;
        
        if(!LastName.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("lnameErr").innerHTML = "Error: Please enter valid LastName";
        }else{
            component.set("v.isError",false);
            document.getElementById("lnameErr").innerHTML = "";
        }
    },  
    validateCity:function(component,event,helper){
        var objAcc = component.get("v.newLead");
        var BillingCity = objAcc.City;
        var fnameReg = /^[a-z]+$/i;
        
        if(!BillingCity.toString().match(fnameReg)){
            //component.set("v.isError",true);
            document.getElementById("cityErr").innerHTML = "Error: Please enter valid city name";
        }else{
            //component.set("v.isError",false);
            document.getElementById("cityErr").innerHTML = "";
        }
        
    },  
    validateCountry:function(component,event,helper){
        var objAcc = component.get("v.newLead");
        var BillingCountry = objAcc.Country;
        var fnameReg = /^[a-zA-Z ]+$/i;
        
        if(!BillingCountry.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("companyErr").innerHTML = "Error: Please entr valid country name";
        }else{
            component.set("v.isError",false);
            document.getElementById("companyErr").innerHTML = "";
        }
        
    },      
    validateTRN:function(component,event,helper){
        var objAcc = component.get("v.newLead");
        var TRN = objAcc.ETT_VAT_TRN__c;
        var fnameReg = /^[0-9]+$/i;
        
        if(!TRN.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("trnErr").innerHTML = "Error: Please enter only numbers in TRN Number";
        }else{
            component.set("v.isError",false);
            document.getElementById("trnErr").innerHTML = "";
        }
        
        if(TRN.length != 15){
            component.set("v.isError",true);
            document.getElementById("trnErr").innerHTML = "Error: TRN Number must be 15 digits";
        }else{
            component.set("v.isError",false);
            document.getElementById("trnErr").innerHTML = "";
        }
        
    },      
    validateTradeNumber:function(component,event,helper){
        var objAcc = component.get("v.newLead");
        var TradeNo = objAcc.ETT_Trade_License_Number__c;
        var fnameReg = /^[0-9]+$/i;
        
        if(!TradeNo.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("tradeNoErr").innerHTML = "Error: Please enter only numbers in Trade License Number";
			return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("tradeNoErr").innerHTML = "";
        }
        
        if(TradeNo.length != 15){
            component.set("v.isError",true);
            document.getElementById("tradeNoErr").innerHTML = "Error: Trade License Number must be 15 digits";
        }else{
            component.set("v.isError",false);
            document.getElementById("tradeNoErr").innerHTML = "";
        }
    },          
    dateUpdate : function(component, event, helper) {
        debugger;
        var objAcc = component.get("v.newLead");  
        
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
        var tradeLicenseExpiryDate = objAcc.ETT_Trade_Licenses_Expiry_Date__c;
        console.log(todayFormattedDate);
        console.log(objAcc.ETT_Trade_Licenses_Expiry_Date__c);
        var timeDiffrence = Math.abs(new Date(tradeLicenseExpiryDate).getTime() - today.getTime());
        var differDays = Math.ceil(timeDiffrence / (1000 * 3600 * 24)); 
        if(tradeLicenseExpiryDate != '' && tradeLicenseExpiryDate < todayFormattedDate){
            component.set("v.isError",true);
            document.getElementById("tradeLicenseDateErr").innerHTML = "Please enter valid Trade Licenses Expiry Date";            
        }else if(differDays < 7){
            component.set("v.isError",true);
            document.getElementById("tradeLicenseDateErr").innerHTML = "Trade License should be valid atleast for a week";            
        }else{
            component.set("v.isError",false);
            document.getElementById("tradeLicenseDateErr").innerHTML = "";
        }
    },
    validateEmirateId : function(component, event, helper){
        
        var objAcc = component.get("v.newLead");
        var Emirates_Id = objAcc.ETT_Emirates_Id__c;        
        var regex = /^784-[0-9]{4}-[0-9]{7}-[0-9]{1}$/;
        
        console.log(Emirates_Id);
        console.log(Emirates_Id.toString().match(regex));
        
        if(Emirates_Id.toString().match(regex)){
            component.set("v.isError",false);
            document.getElementById("emiIdErr").innerHTML = "";
        }else{
            component.set("v.isError",true);
            document.getElementById("emiIdErr").innerHTML = "Error: Please enter valid Emirates Id";
        }
    },
    validateUsername : function(component, event, helper){
        
        var objUser = component.get("v.objUser");
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        
        if(objUser.Username == ''){
            component.set("v.isError",true);
            document.getElementById("usernameErr").innerHTML = "Error: Please enter Username";                                    
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("usernameErr").innerHTML = "";
        }                    
        
        if(!objUser.Username.match(regExpEmailformat)){
            component.set("v.isError",true);
            document.getElementById("usernameErr").innerHTML = "Error: Username must be in email format (e.g.username@domain.com)";                                                
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("usernameErr").innerHTML = "";
        }
        
    },
    validatePassword : function(component, event, helper){
        
        var Password = component.get("v.Password");
        
        if(Password == ''){
            component.set("v.isError",true);
            document.getElementById("passErr").innerHTML = "Error: Please enter Password";                                    
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("passErr").innerHTML = "";
        }
        
        if(Password.length < 7){
            component.set("v.isError",true);
            document.getElementById("passErr").innerHTML = "Error: Please enter atleast 7 digits password";                                                
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("passErr").innerHTML = "";
        }
        
    },
    validateConfirmPassword : function(component, event, helper){
        
        var Password = component.get("v.Password");        
        var ConfirmPassword = component.get("v.ConfirmPassword");
        
        if(ConfirmPassword == ''){
            component.set("v.isError",true);
            document.getElementById("confirmPassErr").innerHTML = "Error: Please enter Confirm Password";                                    
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("confirmPassErr").innerHTML = "";
        }
        
        if(ConfirmPassword != Password){
            component.set("v.isError",true);
            document.getElementById("confirmPassErr").innerHTML = "Error: Password & Confirm Password must be same";                                                
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("confirmPassErr").innerHTML = "";
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
       /* if(isNaN(Mobile)){
            document.getElementById("mobErr").innerHTML = "Error: Please enter only numbers";
            component.set("v.isMobileError",true);
            return false;
        }/*else if(Mobile.length != 10){
            document.getElementById("mobErr").innerHTML = "Error: Please enter atleast 10 digits";
            component.set("v.isMobileError",true);
            return false;                        
        }*//*else{
            component.set("v.isMobileError",false);            
            document.getElementById("mobErr").innerHTML = "";
        }*/
        
        if(!Mobile.toString().match(phonRegex)){
            component.set("v.isError",true);
            document.getElementById("mobileErr").innerHTML = "Error: Please enter valid phone number";
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("mobileErr").innerHTML = "";
        }
        
    },
    validateEmail : function(component, event, helper){
        
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        var newLead = component.get("v.newLead");
        
        if(newLead.Email == ''){
            component.set("v.isError",true);
            document.getElementById("emailErr").innerHTML = "Error: Please enter Email";                                    
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("emailErr").innerHTML = "";
        }                  
        
        if(!newLead.Email.match(regExpEmailformat)){
            component.set("v.isError",true);
            document.getElementById("emailErr").innerHTML = "Error: Please enter valid email address";                                    
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("emailErr").innerHTML = "";
        }
    },
    doInit:function(component,event,helper){

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
            ETT_New_Brand__c: "",
            ETT_New_Pattern__c: "",
            ETT_New_Country__c: ""
        });
        component.set("v.stagingQuotationRequest", stagingQuotationRequest);
        
        
        var fileWrapper = component.get("v.fileUploadWrapper");
        fileWrapper.push({
            "sobjectType": "ETT_FileUploadWrapper",
            "strFileName": "",
            "strBase64Data": "",
            "strFileType": ""
        });
        component.set("v.fileUploadWrapper",fileWrapper);
    },
    removeFile: function (component, event, helper) {
        
        var index = event.target.dataset.index;
        var toremovefile = event.currentTarget.dataset.filename;
        
        var removefileToBeUploaded= component.get("v.fileUploadWrapper");
        removefileToBeUploaded.splice(index, 1);
        component.set("v.fileUploadWrapper", removefileToBeUploaded);
        
        console.log('index: '+index);
        console.log('toremovefile: '+toremovefile);
        console.log(JSON.stringify(component.get("v.fileUploadWrapper")));
        
    },
    onFileUploaded:function(component,event,helper){
        
        var fileSourceType = event.getSource().getLocalId();
        var objWrapper = component.get("v.fileUploadWrapper");
        var files = component.get("v.fileToBeUploaded");
        var contentWrapperArr = [];
        var fileUploadWrapper = component.get("v.fileUploadWrapper");
        
        if (files && files.length > 0) {
            for(var i=0; i < files[0].length; i++){
                var file = files[0][i];
                var reader = new FileReader();
                reader.name = file.name;
                reader.type = file.type;
                
                var fileSizeInMB = (file.size / (1024*1024)).toFixed(2);
                
                if(fileSizeInMB > 4 && fileSourceType=='TradingLicense'){
                    document.getElementById("TradingLicenseErr").innerHTML = "Error: File size must be 4MB or less than 4MB";
                    return false;
                }else{
                    document.getElementById("TradingLicenseErr").innerHTML = "";
                }
                
                if(fileSizeInMB > 4 && fileSourceType=='companyProfile'){
                    document.getElementById("companyProfileErr").innerHTML = "Error: File size must be 4MB or less than 4MB";
                    return false;
                }else{
                    document.getElementById("companyProfileErr").innerHTML = "";
                }
                
                if(fileSizeInMB > 4 && fileSourceType=='membershipOfChamber'){
                    document.getElementById("membershipOfChamberErr").innerHTML = "Error: File size must be 4MB or less than 4MB";
                    return false;
                }else{
                    document.getElementById("membershipOfChamberErr").innerHTML = "";
                }
                reader.onloadend = function(e) {
                    var base64Img = e.target.result;
                    var base64result = base64Img.split(',')[1];
                    console.log(e.target.name+'======');
                    fileUploadWrapper.push({
                        'strFileName':e.target.name,
                        'strFileType':e.target.type,
                        'strBase64Data':base64result,
                        'fileSourceType':fileSourceType
                    });
                    contentWrapperArr.push({
                        'strFileName':e.target.name,
                        'strFileType':e.target.type,
                        'strBase64Data':base64result,
                        'fileSourceType':fileSourceType
                    });
                }
                
                function handleEvent(event) {
                    if(contentWrapperArr.length == i){
                        component.set("v.fileUploadWrapper",fileUploadWrapper);
                    }
                }
                
                reader.readAsDataURL(file);
                reader.addEventListener('loadend', handleEvent);
                
            }
            //console.log(files);
            //var file = files[0][0];
            //console.log(file.name);
            //var reader = new FileReader();
            /*reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                objWrapper.push({'strFileName':file.name, 'strBase64Data':content, 'strFileType':file.type});
                component.set("v.fileUploadWrapper",objWrapper);
            }
            reader.readAsDataURL(file);
            */
        }
        else{
            //helper.hide(component,event);
        }
    },
    handleSectionToggle : function(component, event, helper) {},
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
        
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    },
    login : function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            url: "https://etpdev-et.cs110.force.com/TyreRetreadingService/SiteLogin"
        });
        urlEvent.fire();
        
        
    },
    handleClick : function(component, event, helper) {
 component.set('v.isdisabled',true);
        //In the Cr.supplier lead page,  first name, City, country should not be mandatory.

        var isError = component.get("v.isError");
        if(isError){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please fix all errors to proceed."
            });
            return false;
        }
        var objUser = component.get("v.objUser");
        var newLead = component.get("v.newLead");
        newLead.RecordTypeId = $A.get("$Label.c.ETT_Tyre_Credit_B2B_Supplier");

        if(newLead.Company==''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please enter Company name."
            });
            return false;
        }
        if(newLead.LastName==''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please enter Last Name."
            });
            return false;
        }
        if(newLead.Email==''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please enter Email."
            });
            return false;
        }
        if(newLead.MobilePhone==''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please enter Mobile."
            });
            return false;
        }
        if(newLead.ETT_VAT_TRN__c==''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please enter TRN."
            });
            return false;
        }
        /*if(newLead.ETT_Emirate__c==''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please enter Emirate ID."
            });
            return false;
        }*/
        if(newLead.ETT_Trade_License_Number__c==''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please enter Trade License Number."
            });
            return false;
        }
        if(newLead.ETT_Trade_Licenses_Expiry_Date__c==''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please enter Trade Licenses Expiry Date."
            });
            return false;
        }
        newLead.ETT_Party_Type__c = 'Supplier';
        
        var strLeadJson = JSON.stringify(newLead);
        
        //console.log(strLeadJson);
        //return false;
        
        
        var action = component.get("c.saveDML");
        var mapNameForStagingObjects = {
            stgLeadJson: strLeadJson
        };
        action.setParams({
            mapofStageJsonList: mapNameForStagingObjects
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                
               /* var res = response.getReturnValue();
                var childComp = component.find('childComp');
                childComp.callChild(res,'send');
                */
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + response.getReturnValue()
                });
                urlEvent.fire();
                
            }else if (state === "ERROR") {
                
                console.log("Error: ");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
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
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    }, 
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    }
})