({
    doInit : function(component, event, helper) {
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        var currentUser =  $A.get("$SObjectType.CurrentUser.Id");
        helper.getPriceDetails(component, event, helper);
        
        if(custLabelsFM==currentUser){
            component.set("v.isUserFM",custLabelsFM);
        }
        if(custLabelsHOO==currentUser){
            component.set("v.isUserHOO",custLabelsHOO);
        }
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        
        //if(custLabelsFM==currentUser || custLabelsHOO==currentUser){
        var actSave = component.get("c.getTyreDetailsAcc");
        actSave.setParams({
            accountId:component.get("v.recordId") 
        });
        actSave.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                try{
               
               //console.log(response.getReturnValue())
               //console.log('--lineItems--'+JSON.stringify(response.getReturnValue()));
                
                var CCList = [];
                var CCDateList = [];
                var tyreSizeList = [];
                var tyreSizeCount = [];
                var tyreSizeArr = [];
                var lstTyre = [];
                var conts = response.getReturnValue();
                var i=0,j=0,p=0;
                var totalPrice = 0;
                var count=0;
                    
                /*    
                    var listOfTyresizeStatusType = [];
                    for(var key in conts){
                        var tyreSizeName = conts[key]['Tyre_Size__c']; 
                        var status = conts[key]['ETT_Status__c'];
                        var type =  conts[key]['Tyre_Inventory__r']['Job_Type__c'];
                        var collectionCard = conts[key]['ETT_Collection_Card__r']['Name'];
                        let CCID = conts[key]['ETT_Collection_Card__c'];
                        let tyreMasID = conts[key]['Tyre_Inventory__r']['ETT_Tyre_Size_Master__c'];
                        listOfTyresizeStatusType.push({'Name':tyreSizeName,'Status':status,'Type':type,'CC':collectionCard,'Count':1,'CCID':CCID,'TyreMasId':tyreMasID});
                        
                        
                    }
                    
                    var helper = {};
                    var result = listOfTyresizeStatusType.reduce(function(r, o) {
                        var key = o.Name + '-' + o.Type+'-'+o.Status+'-'+o.CC;
                        
                        if(!helper[key]) {
                            helper[key] = Object.assign({}, o); // create a copy of o
                            r.push(helper[key]);
                        } else {
                            helper[key].Count += o.Count;
                            //helper[key].instances += o.instances;
                        }
                        
                        return r;
                    }, []);
                  
                   
                   var addRowInList = component.get("v.lstObjects");
                    result.forEach(function(item){
                         var quotLineObj = new Object();
                        quotLineObj.Collection_Card__c = item.CCID;
                        quotLineObj.ETT_Tyre_Size_Master__c = item.TyreMasId;
                        quotLineObj.ETT_Tyre_Size_Name__c= item.Name;
                        quotLineObj.ETT_Status__c = item.Status;
                        quotLineObj.ETT_Job_Type__c= item.Type;
                        quotLineObj.isSelected = false;
                        quotLineObj.Quantity = item.Count;
                        
                        let tyreSizeVsPrice = component.get("v.tyreSizeVsPrice");
                        if( item.Status == 'Send Back'){
                            quotLineObj.ETT_Unit_Price__c = '0';
                        }else{
                            quotLineObj.ETT_Unit_Price__c =  tyreSizeVsPrice.get(tyreSizeName);  
                        }
                        
                        quotLineObj.ETT_Total__c = (quotLineObj.Quantity*quotLineObj.ETT_Unit_Price__c);
                        totalPrice = (totalPrice + quotLineObj.ETT_Total__c);
                        addRowInList.push(quotLineObj);
                  
                        
                    });    
                     component.set("v.lstObjects",addRowInList);
                */
             
                
                for(var key in conts){
                    var addRowInList = component.get("v.lstObjects");
                    var contactObj = new Object();
                   
                    for(var k in conts[key]){
                        
                        var ccName = conts[key]['ETT_Collection_Card__r']['Name'];
                        if(!CCList.includes(ccName)){
                            CCList[i] = conts[key]['ETT_Collection_Card__r']['Name'];
                            i++;
                        }
                        var ccDate = conts[key]['ETT_Collection_Card__r']['ETT_Collection_Date__c'];
                        console.log(ccDate);
                        if(!CCDateList.includes(ccDate)){
                            CCDateList[p] = conts[key]['ETT_Collection_Card__r']['ETT_Collection_Date__c'];
                            p++;
                        }
                        
                        var tyreSizeName = conts[key]['Tyre_Size__c']; 
                        if(!tyreSizeList.includes(tyreSizeName)){
                            tyreSizeList[j] = tyreSizeName; 
                            j++;
                        }
                       contactObj.Collection_Card__c =conts[key]['ETT_Collection_Card__c'];
                        
                        contactObj.ETT_Work_Order_Line_Item__c=conts[key]['Id'];
                        contactObj.ETT_Tyre_Size_Name__c = conts[key]['Tyre_Size__c'];
                        contactObj.ETT_Tyre_Size__c = conts[key]['Tyre_Inventory__r']['ETT_Tyre_Size_Master__c'];
                        
                       
                        contactObj.ETT_Status__c = conts[key]['ETT_Status__c'];    
                        contactObj.TyreInventory = conts[key]['Tyre_Inventory__c'];
                        
                        if("Tyre_Inventory__r" in conts[key]){
                            contactObj.ETT_Job_Type__c = conts[key]['Tyre_Inventory__r']['Job_Type__c'];
                        }
                        
                        
                    }
				    contactObj.isSelected = false;
                    contactObj.Quantity = 1;
                   
                    let tyreSizeVsPrice = component.get("v.tyreSizeVsPrice");
                    if(conts[key]['ETT_Status__c'] == 'Send Back'){
                        contactObj.ETT_Unit_Price__c = '0';
                    }else{
                        contactObj.ETT_Unit_Price__c =  tyreSizeVsPrice.get(tyreSizeName);  
                    }
                    
                   contactObj.ETT_Total__c = (contactObj.Quantity*contactObj.ETT_Unit_Price__c);
                   totalPrice = (totalPrice + contactObj.ETT_Total__c);
                    addRowInList.push(contactObj);
                   component.set("v.lstObjects",addRowInList);
                }
                    
                    
                
                console.log(JSON.stringify(CCDateList));
                component.set('v.lstCC',CCList);
                component.set('v.CCDateList',CCDateList);                
                
                
                var vat = 0;
                var totalAmount = 0;
                
                if(totalPrice!=0){
                    vat = (totalPrice * 0.05);                    
                    component.set('v.vat',vat);      
                    totalAmount = totalPrice + vat;
                    component.set('v.totalAmount',totalAmount);
                }
                component.set('v.totalPrice',totalPrice);
                
            
                }catch(e){
                    console.log('--init Error--'+e.message);
                    console.log('--init Error--'+e.stack);
                    console.log('--init Error--'+e.line);
                    
                }
                
            }else if(state === "ERROR"){
                var errors = action.getError();
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
        //}
        
        
        
        var action = component.get("c.getTrafficFine");
        action.setParams({
            accountId:component.get("v.recordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state: '+state);
            
            if (state === "SUCCESS") {
                //console.log('getTrafficFine : '+JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                component.set('v.lstWallet',result);
                //console.log('wallet: '+JSON.stringify(result));
                //console.log('wallet size: '+result.length);
                if(result.length>0){
                  component.set('v.isWalletEmpty',true);  
                }else{
                    component.set('v.isWalletEmpty',false);
                }
                
            }else if(state === "ERROR"){
                var errors = action.getError();
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
        $A.enqueueAction(action);
        
        
    },
    
    handleSingleQuotation : function(component, event, helper){
        var lstObjects = component.get("v.lstObjects");
        var totalPrice = 0;
        var vat = 0;
        var totalAmount = 0;
        for(var i=0;i<lstObjects.length;i++){
            if(lstObjects[i].isSelected){
                totalPrice = (totalPrice + lstObjects[i].ETT_Total__c);
                console.log(totalPrice);
            }           
        }
        if(totalPrice!=0){
            vat = (totalPrice * 0.05);                    
            component.set('v.vat',vat);      
            totalAmount = totalPrice + vat;
            component.set('v.totalAmount',totalAmount);
        }
        
        component.set('v.totalPrice',totalPrice);
        
        
    },
    
    handleSelectAllQuotation : function(component, event, helper){
        
        var totalPrice = 0;
        var vat = 0;
        var totalAmount = 0;
        
        var isSelectAll = component.get("v.isSelectAll");
        var lstObjects = component.get("v.lstObjects");
        
        console.log(JSON.stringify(lstObjects));

        for(var i=0;i<lstObjects.length;i++){
            if(isSelectAll){
                lstObjects[i].isSelected = true;   
                totalPrice = (totalPrice + lstObjects[i].ETT_Total__c);
            }else{
                lstObjects[i].isSelected = false;                
            }            
        }
		component.set("v.lstObjects",lstObjects);
        
        if(totalPrice!=0){
            vat = (totalPrice * 0.05);                    
            component.set('v.vat',vat);      
            totalAmount = totalPrice + vat;
            component.set('v.totalAmount',totalAmount);
        }
        
        component.set('v.totalPrice',totalPrice);
        
        

    },
    

    handleSelectAllClaimTyreSettlement : function(component, event, helper){
        
        var isSelectAllClaim = component.get("v.isSelectAllClaim");
        var lstWallet = component.get("v.lstWallet");
        console.log(JSON.stringify(lstWallet));
        
        for(var i=0;i<lstWallet.length;i++){
            if(isSelectAllClaim){
                lstWallet[i].ETT_Is_Checked__c = true;                
            }else{
                lstWallet[i].ETT_Is_Checked__c = false;                
            }            
        }
        component.set("v.lstWallet",lstWallet);
        
    },
    
    submit : function(component, event, helper){
        var lstObj = component.get("v.lstObjects");
        
        if(lstObj!=null && lstObj.length>0){
               var addRowInList = component.get("v.lstQuotation");
            for(var i=0;i<lstObj.length;i++){
                if(lstObj[i].isSelected){
                  
                    var quotLineObj = new Object();
                    quotLineObj.sobjectType = 'ETT_Quotation_Line_Item__c';
                    quotLineObj.ETT_Tyre_Inventory__c = lstObj[i].TyreInventory;
                   // quotLineObj.ETT_Tyre_Size_Master__c = lstObj[i].ETT_Tyre_Size_Master__c;
                    quotLineObj.ETT_Status__c = lstObj[i].ETT_Status__c;
                    quotLineObj.ETT_Job_Type__c = lstObj[i].ETT_Job_Type__c;
                    quotLineObj.ETT_Quantity__c = lstObj[i].Quantity;
                    quotLineObj.ETT_Unit_Price__c = lstObj[i].ETT_Unit_Price__c;
                    quotLineObj.ETT_Total__c = lstObj[i].ETT_Total__c;
                    quotLineObj.ETT_Account__c = component.get("v.recordId");
                    quotLineObj.Collection_Card__c =lstObj[i].Collection_Card__c;
                    
                    addRowInList.push(quotLineObj);
                    
                    
                }
            }
            component.set("v.lstQuotation",addRowInList);
        }
        
        console.log(JSON.stringify(component.get("v.lstQuotation")));
        
        component.set("v.showSpinner",true);
        var actSave = component.get("c.createQuotations");
        actSave.setParams({
            lstQuotation:component.get("v.lstQuotation"),
            accountId:component.get("v.recordId"),
            Email:component.get("v.contactEmail"),
            KindAtten:component.get("v.contactName"),
            claimAmount:component.get("v.claimAmount"),
            selectedWallet:component.get("v.selectedLstWallet")
        });
        actSave.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                  component.set("v.showSpinner",false);
                helper.showErrorToast({
                    title: "Success: ",
                    type: "success",
                    message: "Quotations has been created successfully"
                });
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                
            }else if(state === "ERROR"){
                component.set("v.showSpinner",false);
                var errors = action.getError();
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
                component.set("v.showSpinner",false);
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
    
    
    claimSettlement : function(component, event, helper){
      //Modified By Janardhan    
        var lstWallet = component.get("v.lstWallet");
        let selectedLstWallet = component.get("v.selectedLstWallet");
        
        var claimAmount = 0;
        for(var i=0;i<lstWallet.length;i++){
            if(lstWallet[i].ETT_Is_Checked__c){
                claimAmount = claimAmount + lstWallet[i].Adjustment__c;  
                   
                    var walletObj = new Object();
                    walletObj.sobjectType = 'ET_Tyre_Wallet__c';
                    walletObj.Id = lstWallet[i].Id;
                    walletObj.Status__c='Paid';
                    
                    selectedLstWallet.push(walletObj);                    
                   
            }           
        }
        component.set("v.selectedLstWallet",selectedLstWallet);
        console.log('claimAmount: '+claimAmount);
        component.set('v.claimAmount',claimAmount);
        
        var totalPrice = component.get('v.totalPrice');
        totalPrice = totalPrice - claimAmount;
        
        var vat = (totalPrice * 0.05);                    
        component.set('v.vat',vat);      
        var totalAmount = totalPrice + vat;
        component.set('v.totalAmount',totalAmount);
       
        component.set('v.disablBtn',true);        
        
    },
    
    //Created By Janardhan
    onCollectionCardLoad : function(component, event, helper) {

     
            var action = component.get('c.getContactsFromAccountID');
            action.setParams({
                accId:component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                    if(data){
                        component.set("v.contactName",data[0].Name);
                        component.set("v.contactEmail",data[0].Email);
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
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
    
    cancel : function(component, event, helper){
        
        $A.get("e.force:closeQuickAction").fire();
    }
    
    
})