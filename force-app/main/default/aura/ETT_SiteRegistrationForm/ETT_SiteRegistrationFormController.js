({
    validateFirstName:function(component,event,helper){
        
        var objAcc = component.get("v.objAccount");
        var FirstName = objAcc.ETT_First_Name__c;
        var fnameReg = /^[a-z]+$/i;
        
        if(!FirstName.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("fnameErr").innerHTML = "Error: Please enter valid FirstName";
        }else{
            component.set("v.isError",false);
            document.getElementById("fnameErr").innerHTML = "";
        }
    },
    validateLastName:function(component,event,helper){
        var objAcc = component.get("v.objAccount");
        var LastName = objAcc.ETT_Last_Name__c;
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
        var objAcc = component.get("v.objAccount");
        var BillingCity = objAcc.BillingCity;
        var fnameReg = /^[a-z]+$/i;
        
        if(!BillingCity.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("cityErr").innerHTML = "Error: Please enter valid city name";
        }else{
            component.set("v.isError",false);
            document.getElementById("cityErr").innerHTML = "";
        }
        
    },  
    validateCountry:function(component,event,helper){
        var objAcc = component.get("v.objAccount");
        var BillingCountry = objAcc.BillingCountry;
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
        var objAcc = component.get("v.objAccount");
        var TRN = objAcc.ETT_VAT_TRN_No__c;
        var fnameReg = /^[0-9]+$/i;
        
        if(!TRN.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("trnErr").innerHTML = "Error: Please enter only numbers in TRN Number";
        }else{
            component.set("v.isError",false);
            document.getElementById("trnErr").innerHTML = "";
        }
        
    },      
    validateTradeNumber:function(component,event,helper){
        var objAcc = component.get("v.objAccount");
        var TradeNo = objAcc.ETT_Trade_License_Number__c;
        var fnameReg = /^[0-9]+$/i;
        
        if(!TradeNo.toString().match(fnameReg)){
            component.set("v.isError",true);
            document.getElementById("tradeNoErr").innerHTML = "Error: Please enter only numbers in Trade License Number";
        }else{
            component.set("v.isError",false);
            document.getElementById("tradeNoErr").innerHTML = "";
        }
        
    },          
    dateUpdate : function(component, event, helper) {
        var objAcc = component.get("v.objAccount");  
        
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
        
        if(tradeLicenseExpiryDate != '' && tradeLicenseExpiryDate < todayFormattedDate){
            component.set("v.isError",true);
            document.getElementById("tradeLicenseDateErr").innerHTML = "Please enter valid Trade Licenses Expiry Date";            
        }else{
            component.set("v.isError",false);
            document.getElementById("tradeLicenseDateErr").innerHTML = "";
        }
    },
    validateEmirateId : function(component, event, helper){
        
        var objAcc = component.get("v.objAccount");
        var Emirates_Id = objAcc.ETST_Emirates_Id__c;        
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
        
        var objUser = component.get("v.objUser");
        
        if(objUser.MobilePhone == ''){
            component.set("v.isError",true);
            document.getElementById("mobileErr").innerHTML = "Error: Please enter Mobile";                                                
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("mobileErr").innerHTML = "";
        }                       
        
        if(isNaN(objUser.MobilePhone)){
            component.set("v.isError",true);
            document.getElementById("mobileErr").innerHTML = "Error: Please enter only digits in Mobile";                                    
            return false;            
        }else{
            component.set("v.isError",false);
            document.getElementById("mobileErr").innerHTML = "";
        }
        
        if(objUser.MobilePhone.length < 10){
            component.set("v.isError",true);
            document.getElementById("mobileErr").innerHTML = "Error: Please enter valid Mobile Number";                                                
            return false;            
        }else{
            component.set("v.isError",false);
            document.getElementById("mobileErr").innerHTML = "";
        }
    },
    validateEmail : function(component, event, helper){
        
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        var objUser = component.get("v.objUser");
        
        if(objUser.Email == ''){
            component.set("v.isError",true);
            document.getElementById("emailErr").innerHTML = "Error: Please enter Email";                                    
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("emailErr").innerHTML = "";
        }                  
        
        if(!objUser.Email.match(regExpEmailformat)){
            component.set("v.isError",true);
            document.getElementById("emailErr").innerHTML = "Error: Please enter valid email address";                                    
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("emailErr").innerHTML = "";
        }
    },
    doInit:function(component,event,helper){
        
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
        
        var objUser = component.get("v.objUser");
        var objAccount = component.get("v.objAccount");
        var objBank =  component.get("v.objBank");
        var Password = component.get("v.Password");
        var ConfirmPassword = component.get("v.ConfirmPassword");
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        
        
        if(objUser.ETT_Customer_Type__c == ''){
            component.set("v.isError",true);
            document.getElementById("custErr").innerHTML = "Error: Please select supplier type";
            return false;
        }else{
            component.set("v.isError",false);
            document.getElementById("custErr").innerHTML = "";
        }
        
        
        var isError = component.get("v.isError");
        
        console.log('isError: '+isError);
        
        if(isError){
            alert("Please make sure you have entered valid data");
            return false;
        }
        
        //File To be upload        
        var objWrapper = component.get("v.fileUploadWrapper");
        objWrapper.shift();
        var lstFileUploadWrapper = JSON.stringify(objWrapper);
        //console.log(lstFileUploadWrapper);
        
        
        var FirstName = objAccount.ETT_First_Name__c;
        var LastName = objAccount.ETT_Last_Name__c;
        var alias = LastName.slice(0, 3);
        
        objAccount.Name = FirstName+' '+LastName;
        objUser.FirstName = objAccount.ETT_First_Name__c;
        objUser.LastName = objAccount.ETT_Last_Name__c;
        objUser.Alias = alias;
        
   
        
        
        
        var action = component.get("c.registerCommunityPortalUser");
        var mapofStageJsonList = {
            objUserJson: JSON.stringify(objUser),
            objAccountJson: JSON.stringify(objAccount),
            objBank: JSON.stringify(objBank),
            filesToUpload: JSON.stringify(objWrapper)
        };
        
        component.set("v.Spinner", true); 
        
        action.setParams({
            mapofStageJsonList: mapofStageJsonList,
            password:Password
        });
        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.Spinner", false);
            
            if (state === "SUCCESS") {
                console.log('success');
                component.set("v.showThankYou",true);
                console.log(response.getReturnValue());
            }else if (state === "ERROR") {
                
                console.log("Error: ");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }
                
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